using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using R2API.Networking;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking.Interfaces;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrb : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.35f;
        public float fireFrac = 0.20f;
        public float endFireFrac = 0.3f;
        public int baseFireAmount = Modules.StaticValues.redOrbBaseHitAmount;
        public int fireAmount;
        public float duration = 2.2f;
        public int moveStrength; //1-3
        public bool hasFired;
        public float firingStopwatch;

        internal BlastAttack blastAttack;
        internal BulletAttack bulletAttack;
        internal int attackAmount;
        internal float partialAttack;

        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.redOrbProcCoefficient;

        internal string muzzleString = "SubmachineGunMuzzle";
        private float movementMultiplier = 3f;

        private float invincibilityStartFrac = 0.16f;
        private float invincibilityEndFrac = 0.4f;
        private bool invincibilitySet = false;

        float movespeedScalingCap = 25f;
        private bool hasCancelledWithMovement = false;

        float disableInvincibility = 0.42f;
        public OrbController orbController;
        public BulletController bulletController;
        bool hasUnsetOrbController;
        public override void OnEnter()
        {
            base.OnEnter();

            orbController = gameObject.GetComponent<OrbController>();
            bulletController = gameObject.GetComponent<BulletController>();

            if (bulletController.inSnipeStance)
            {
                bulletController.UnsetSnipeStance();
            }

            if (orbController)
            {
                orbController.isExecutingSkill = true;
            }
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;
            characterMotor.velocity.y = 0f;
            firingStopwatch = endFireFrac - fireFrac;
            if (moveStrength >= 3) 
            {
                isStrong = true;
            }

            fireAmount = baseFireAmount * (int)(attackSpeedStat > 1f ? attackSpeedStat : 1);

            attackAmount = (int)attackSpeedStat + baseFireAmount;
            if (attackAmount < 1)
            {
                attackAmount = 1;
            }
            partialAttack = attackSpeedStat - attackAmount;

            Ray aimRay = base.GetAimRay();


            bulletAttack = new BulletAttack
            {
                bulletCount = 1,
                aimVector = aimRay.direction,
                origin = aimRay.origin,
                damage = Modules.StaticValues.redOrbDamageCoefficient * this.damageStat * (moveStrength == 3 ? Modules.StaticValues.redOrbTripleMultiplier : 1),
                damageColorIndex = DamageColorIndex.Default,
                damageType = DamageType.Generic,
                falloffModel = BulletAttack.FalloffModel.DefaultBullet,
                maxDistance = Modules.StaticValues.redOrbBulletRange,
                force = Modules.StaticValues.redOrbBulletForce,
                hitMask = LayerIndex.CommonMasks.bullet,
                minSpread = 0f,
                maxSpread = 0f,
                isCrit = base.RollCrit(),
                owner = base.gameObject,
                muzzleName = muzzleString,
                smartCollision = true,
                procChainMask = default(ProcChainMask),
                procCoefficient = procCoefficient,
                radius = 2f,
                sniper = false,
                stopperMask = LayerIndex.CommonMasks.bullet,
                weapon = null,
                spreadPitchScale = 0f,
                spreadYawScale = 0f,
                queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                hitEffectPrefab = Modules.ParticleAssets.redOrbHit,
                hitCallback = BulletAttack.defaultHitCallback,
            };


            base.characterDirection.forward = inputBank.aimDirection;
            base.characterDirection.moveVector = inputBank.aimDirection;

            rmaMultiplier = base.moveSpeedStat < movespeedScalingCap ? moveSpeedStat / 10f : movespeedScalingCap / 10f;

            if (rmaMultiplier < movementMultiplier)
            {
                rmaMultiplier = movementMultiplier;
            }

            PlayAttackAnimation();

            if (base.isAuthority)
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_red").Send(NetworkDestination.Clients);
            }

            if (base.isAuthority) 
            {
                Modules.Helpers.PlaySwingEffect("BaseTransform", 1.25f, Modules.ParticleAssets.redOrbSwing, gameObject);
            }
        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "redOrb", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
            if (orbController && !hasUnsetOrbController)
            {
                orbController.isExecutingSkill = false;
            }
            PlayAnimation("Body", "BufferEmpty");
            if (NetworkServer.active) 
            {
                characterBody.ClearTimedBuffs(Modules.Buffs.invincibilityBuff.buffIndex);
            }
        }

        public override void Update()
        {
            base.Update();
            if ((base.inputBank.skill3.down || base.inputBank.skill4.down) && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }
            if (age >= duration * earlyEnd && base.isAuthority)
            {
                if (isStrong)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        //Exit earlier to the Strong ender.
                        this.outer.SetNextState(new RedOrbFinisher { });
                        return;
                    }
                }

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

                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.


            if (fixedAge >= duration * fireFrac && fixedAge <= duration * endFireFrac && isAuthority)
            {
                firingStopwatch += Time.fixedDeltaTime;
                if (firingStopwatch >= (endFireFrac - fireFrac) / fireAmount) 
                {
                    firingStopwatch = 0f;
                    bulletAttack.origin = base.GetAimRay().origin;
                    bulletAttack.Fire();
                }
            }

            if (fixedAge >= duration * invincibilityStartFrac && fixedAge <= duration * invincibilityEndFrac && NetworkServer.active && !invincibilitySet) 
            {
                invincibilitySet = true;
                base.characterBody.AddTimedBuff(Modules.Buffs.invincibilityBuff.buffIndex, (duration * invincibilityEndFrac) - (duration * invincibilityStartFrac));
            }


            if (fixedAge >= duration)
            {
                outer.SetNextStateToMain();
                return;
            }
        }

        public void OnHitEnemyAuthority()
        {
            //Do something on hit.
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(moveStrength);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            moveStrength = reader.ReadInt32();
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
