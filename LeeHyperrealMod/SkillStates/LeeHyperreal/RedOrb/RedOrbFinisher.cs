using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrbFinisher : BaseRootMotionMoverState
    {

        public float duration = 2.03f;
        public int baseFireAmount = 3;
        public int fireAmount;
        public bool hasFired;
        public float firingStopwatch;

        internal int attackAmount;
        internal float partialAttack;

        internal float attackStart = 0.174f;
        internal float attackEnd = 0.25f;
        internal float attackFinalShot = 0.32f;
        internal float exitEarlyFrac = 0.37f;
        internal Ray aimRay;

        internal OverlapAttack overlapAttack;
        internal string hitboxName = "Red3Ping";
        internal float overlapStart = 0.17f;
        internal float overlapEnd = 0.33f;
        internal HitBoxGroup hitBoxGroup;

        internal BulletAttack bulletAttack;
        internal string muzzleString = "SubmachineGunMuzzle";

        internal OrbController orbController;

        private float effectTimingFrac = 0.17f;
        private bool hasPlayedEffect = false;

        internal float damageCoefficient = Modules.StaticValues.redOrbFinisherDamageCoefficient;
        internal float procCoefficient = Modules.StaticValues.redOrbFinisherProcCoefficient;
        internal Vector3 bonusForce = Vector3.zero;
        internal float pushForce = 100f;
        private bool hasFiredOverlap;
        bool hasUnsetOrbController;
        public bool hasCancelledWithMovement;
        public override void OnEnter()
        {
            base.OnEnter();
            orbController = gameObject.GetComponent<OrbController>();
            if (orbController)
            {
                orbController.isExecutingSkill = true;
            }
            rmaMultiplier = 1f;
            fireAmount = baseFireAmount * (int)(attackSpeedStat > 1f ? attackSpeedStat : 1);

            firingStopwatch = attackEnd - attackStart;

            aimRay = base.GetAimRay();
            characterMotor.velocity.y = 0f;
            bulletAttack = new BulletAttack
            {
                bulletCount = 1,
                aimVector = aimRay.direction,
                origin = aimRay.origin,
                damage = Modules.StaticValues.redOrbFinisherDamageCoefficient * this.damageStat,
                damageColorIndex = DamageColorIndex.Default,
                damageType = DamageType.Generic,
                falloffModel = BulletAttack.FalloffModel.DefaultBullet,
                maxDistance = Modules.StaticValues.redOrbFinisherBulletRange,
                force = Modules.StaticValues.redOrbFinisherBulletForce,
                hitMask = LayerIndex.CommonMasks.bullet,
                minSpread = 0f,
                maxSpread = 0f,
                isCrit = base.RollCrit(),
                owner = base.gameObject,
                muzzleName = muzzleString,
                smartCollision = false,
                procChainMask = default(ProcChainMask),
                procCoefficient = Modules.StaticValues.redOrbFinisherProcCoefficient,
                radius = 0.75f,
                sniper = false,
                stopperMask = LayerIndex.CommonMasks.bullet,
                weapon = null,
                spreadPitchScale = 0f,
                spreadYawScale = 0f,
                queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                hitEffectPrefab = Modules.ParticleAssets.redOrbHit,
                hitCallback = BulletAttack.defaultHitCallback,
            };

            hitBoxGroup = null;
            Transform modelTransform = base.GetModelTransform();

            if (modelTransform)
            {
                hitBoxGroup = Array.Find<HitBoxGroup>(modelTransform.GetComponents<HitBoxGroup>(), (HitBoxGroup element) => element.groupName == this.hitboxName);
            }

            attackAmount = (int)this.attackSpeedStat;
            if (attackAmount < 1)
            {
                attackAmount = 1;
            }
            partialAttack = (float)(this.attackSpeedStat - (float)attackAmount);

            PlayAttackAnimation();

        }
        
        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "redOrb2", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            PlayAnimation("Body", "BufferEmpty");
            base.OnExit();
            if (orbController && !hasUnsetOrbController)
            {
                orbController.isExecutingSkill = false;
            }
        }

        public override void Update()
        {
            base.Update();
            if ((base.inputBank.skill3.down || base.inputBank.skill4.down) && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (base.age >= duration * effectTimingFrac && !hasPlayedEffect) 
            {
                hasPlayedEffect = true;

                if (base.isAuthority) 
                {
                    Modules.Helpers.PlaySwingEffect("BaseTransform", 1.25f, Modules.ParticleAssets.redOrbPingSwing, gameObject);
                    Modules.Helpers.PlaySwingEffect("BaseTransform", 1.25f, Modules.ParticleAssets.redOrbPingGround, gameObject);
                }
            }

            if (base.age >= duration * exitEarlyFrac && base.isAuthority) 
            {
                if (orbController && !hasUnsetOrbController)
                {
                    hasUnsetOrbController = true;
                    orbController.isExecutingSkill = false;
                }
                if (inputBank.moveVector != Vector3.zero && !hasCancelledWithMovement) 
                {
                    this.outer.SetNextStateToMain();
                    hasCancelledWithMovement = true;
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //if (fixedAge >= duration * attackStart && fixedAge <= duration * attackEnd && isAuthority)
            //{
            //    firingStopwatch += Time.fixedDeltaTime;
            //    if (firingStopwatch >= (attackStart - attackEnd) / fireAmount)
            //    {
            //        Util.PlaySound("HenryShootPistol", base.gameObject);
            //        firingStopwatch = 0f;
            //        bulletAttack.aimVector = base.GetAimRay().direction;
            //        bulletAttack.origin = base.GetAimRay().origin;
            //        bulletAttack.Fire();
            //    }
            //}

            if (fixedAge >= duration * attackFinalShot && isAuthority)
            {
                if (!hasFired)
                {
                    new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_red_dilie").Send(R2API.Networking.NetworkDestination.Clients);
                    hasFired = true;
                    bulletAttack.aimVector = base.GetAimRay().direction;
                    bulletAttack.origin = base.GetAimRay().origin;
                    bulletAttack.Fire();
                }
            }


            if (fixedAge >= duration * attackStart && fixedAge <= duration * attackEnd && isAuthority)
            {
                if (!hasFiredOverlap)
                {
                    hasFiredOverlap = true;
                    new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_red_bullet").Send(R2API.Networking.NetworkDestination.Clients);
                    int maxNumHit = 0;
                    List<HurtBox> result = new List<HurtBox>();
                    for (int i = 0; i < attackAmount; i++)
                    {
                        overlapAttack = new OverlapAttack();
                        overlapAttack.attacker = gameObject;
                        overlapAttack.inflictor = null;
                        overlapAttack.teamIndex = GetTeam();
                        overlapAttack.damageType = DamageType.Generic;
                        overlapAttack.damage = this.damageCoefficient * this.damageStat;
                        overlapAttack.procCoefficient = this.procCoefficient;
                        overlapAttack.hitEffectPrefab = Modules.ParticleAssets.redOrbDomainHit;
                        overlapAttack.forceVector = this.bonusForce / attackAmount;
                        overlapAttack.pushAwayForce = this.pushForce / attackAmount;
                        overlapAttack.isCrit = base.RollCrit();
                        overlapAttack.procCoefficient = procCoefficient;
                        overlapAttack.procChainMask = new ProcChainMask();
                        overlapAttack.hitBoxGroup = hitBoxGroup;
                        overlapAttack.Fire();
                        if (this.overlapAttack != null)
                        {
                            this.overlapAttack.Fire(result);
                            if (result.Count > maxNumHit)
                            {
                                maxNumHit = result.Count;
                            }
                        }
                    }
                    if (partialAttack > 0.0f)
                    {
                        overlapAttack = new OverlapAttack();
                        overlapAttack.attacker = gameObject;
                        overlapAttack.inflictor = null;
                        overlapAttack.teamIndex = GetTeam();
                        overlapAttack.damageType = DamageType.Generic;
                        overlapAttack.hitBoxGroup = hitBoxGroup;
                        overlapAttack.damage = this.damageCoefficient * this.damageStat * partialAttack;
                        overlapAttack.procCoefficient = this.procCoefficient * partialAttack;
                        overlapAttack.hitEffectPrefab = Modules.ParticleAssets.redOrbDomainHit;
                        overlapAttack.forceVector = this.bonusForce * partialAttack / attackAmount;
                        overlapAttack.pushAwayForce = this.pushForce * partialAttack / attackAmount;
                        overlapAttack.isCrit = base.RollCrit();
                        overlapAttack.procCoefficient = procCoefficient;
                        overlapAttack.procChainMask = new ProcChainMask();
                        overlapAttack.Fire();
                        if (this.overlapAttack != null)
                        {
                            this.overlapAttack.Fire(result);
                            if (result.Count > maxNumHit)
                            {
                                maxNumHit = result.Count;
                            }
                        }
                    }
                    if (maxNumHit > 0)
                    {
                        new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_imp_red_2").Send(R2API.Networking.NetworkDestination.Clients);
                        this.OnHitEnemyAuthority();
                    }
                }
            }

            if (fixedAge >= duration && base.isAuthority) 
            {
                base.outer.SetNextStateToMain();
                return;
            }
        }

        public void OnHitEnemyAuthority()
        {
            //Do something on hit.
        }

    }
}
