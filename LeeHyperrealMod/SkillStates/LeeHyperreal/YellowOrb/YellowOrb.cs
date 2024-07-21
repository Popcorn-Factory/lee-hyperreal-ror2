using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules;
using static RoR2.BlastAttack;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking.Interfaces;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrb : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.30f;
        public float fireFrac = 0.22f;
        public float GravityEndFrac = 0.5f;
        public float duration = 2f;
        public int moveStrength; //1-3
        public bool hasFired;

        internal BlastAttack blastAttack;
        internal int attackAmount;
        internal float partialAttack;

        internal bool isStrong;


        private float movementMultiplier = 1f;

        private float invincibilityStartFrac = 0.10f;
        private float invincibilityEndFrac = 0.4f;
        private bool invincibilitySet = false;
        private OrbController orbController;
        private BulletController bulletController;
        private Transform baseTransform;

        private float effectTimingFrac = 0.15f;
        private bool hasPlayedEffect;
        private bool hasPlayedBulletCasingSFX = false;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;

        public override void OnEnter()
        {
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
            base.OnEnter();
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;

            characterMotor.velocity.y = 0f;
            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;              ///Set Gravity

            if (moveStrength >= 3)
            {
                isStrong = true;
            }

            attackAmount = (int)attackSpeedStat;
            if (attackAmount < 1)
            {
                attackAmount = 1;
            }
            partialAttack = attackSpeedStat - attackAmount;


            blastAttack = new BlastAttack
            {
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position + GetAimRay().direction * 2.5f,
                radius = (moveStrength == 3 ? Modules.StaticValues.yellowOrbTripleMultiplier : 1) * Modules.StaticValues.yellowOrbBlastRadius,
                falloffModel = BlastAttack.FalloffModel.None,
                baseDamage = damageStat * Modules.StaticValues.yellowOrbDamageCoefficient * (moveStrength == 3 ? Modules.StaticValues.yellowOrbTripleMultiplier : 1),
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = Modules.StaticValues.yellowOrbProcCoefficient,
            };


            base.characterDirection.forward = inputBank.aimDirection;
            base.characterDirection.moveVector = inputBank.aimDirection;

            PlayAttackAnimation();
            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            baseTransform = childLocator.FindChild("BaseTransform");

            if (base.isAuthority)
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_yellow_tuijin").Send(NetworkDestination.Clients);
            }
        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "yellowOrb", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
            characterMotor.gravityParameters = oldGravParams;   ///reset Gravity
            PlayAnimation("Body", "BufferEmpty");

            if (NetworkServer.active) 
            {
                characterBody.ClearTimedBuffs(Modules.Buffs.invincibilityBuff.buffIndex);
            }
        }

        public override void Update()
        {
            base.Update();
            if (base.inputBank.skill3.down && base.inputBank.skill4.down && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration * effectTimingFrac && !hasPlayedEffect)
            {
                hasPlayedEffect = true;
                if (base.isAuthority)
                {
                    EffectData effectData = new EffectData
                    {
                        origin = baseTransform.position,
                        rotation = Quaternion.LookRotation(characterDirection.forward),
                        scale = 1.25f,
                    };

                    EffectManager.SpawnEffect(Modules.ParticleAssets.yellowOrbSwing, effectData, true);
                }
            }


            if (age >= duration * earlyEnd && base.isAuthority)
            {
                //Check any move to cancel into.
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
                characterMotor.gravityParameters = oldGravParams;

                if (!hasPlayedBulletCasingSFX)
                {
                    hasPlayedBulletCasingSFX = true;
                    new PlaySoundNetworkRequest(characterBody.netId, "c_liRk4_skill_yellow_bullet").Send(NetworkDestination.Clients);
                }
                if (orbController)
                {
                    orbController.isExecutingSkill = false;
                }
                if (isStrong)
                {
                    //Exit earlier to the Strong ender.
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        this.outer.SetState(new YellowOrbFinisher { });
                        return;
                    }
                }

                if (base.inputBank.moveVector != Vector3.zero)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextStateToMain();
                        return;
                    }
                }
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.


            if (fixedAge >= duration * fireFrac && isAuthority)
            {
                if (!hasFired)
                {
                    hasFired = true;
                    FireAttack();
                }
            }

            if (fixedAge >= duration * GravityEndFrac)
            {
                characterMotor.gravityParameters = oldGravParams;
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

        public void FireAttack()
        {
            for (int i = 0; i < Modules.StaticValues.yellowOrbBaseHitAmount; i++) 
            {
                for (int j = 0; j < attackAmount; j++)
                {
                    BlastAttack.Result result = blastAttack.Fire();

                }

                if (partialAttack > 0f)
                {
                    blastAttack.baseDamage = blastAttack.baseDamage * partialAttack;
                    blastAttack.procCoefficient = blastAttack.procCoefficient * partialAttack;
                    blastAttack.radius = blastAttack.radius * partialAttack;
                    blastAttack.baseForce = blastAttack.baseForce * partialAttack;

                    BlastAttack.Result result = blastAttack.Fire();

                }
            }

            BlastAttack.Result result1 =
            new BlastAttack
            {
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position + GetAimRay().direction * 2.5f,
                radius = (moveStrength == 3 ? Modules.StaticValues.blueOrbTripleMultiplier : 1) * Modules.StaticValues.blueOrbBlastRadius,
                falloffModel = BlastAttack.FalloffModel.None,
                baseDamage = 1f,
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = 1f,

            }.Fire();

            if (result1.hitCount > 0)
            {
                OnHitEnemyAuthority(result1);
            }
        }

        public void OnHitEnemyAuthority(BlastAttack.Result result)
        {
            //Do something on hit.

            foreach (BlastAttack.HitPoint hitpoint in result.hitPoints)
            {
                EffectData effectData = new EffectData
                {
                    origin = hitpoint.hurtBox.healthComponent.body.corePosition,
                    rotation = Quaternion.identity,
                    scale = 5f,
                };
                EffectManager.SpawnEffect(Modules.ParticleAssets.yellowOrbSwingHit, effectData, true);
            }

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
