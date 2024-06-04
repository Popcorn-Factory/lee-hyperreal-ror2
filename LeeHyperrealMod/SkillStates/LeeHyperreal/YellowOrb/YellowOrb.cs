using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules;
using static RoR2.BlastAttack;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrb : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.42f;
        public float fireFrac = 0.22f;
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
        private Transform baseTransform;

        private float effectTimingFrac = 0.15f;
        private bool hasPlayedEffect;

        public override void OnEnter()
        {
            orbController = gameObject.GetComponent<OrbController>();

            if (orbController)
            {
                orbController.isExecutingSkill = true;
            }
            base.OnEnter();
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;
            characterMotor.velocity.y = 0f;

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
                radius = (moveStrength == 3 ? 1 : Modules.StaticValues.yellowOrbTripleMultiplier) * Modules.StaticValues.yellowOrbBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = damageStat * Modules.StaticValues.yellowOrbBlastRadius * (moveStrength == 3 ? 1 : Modules.StaticValues.yellowOrbTripleMultiplier),
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

            PlayAnimation("Body", "BufferEmpty");
        }

        public override void Update()
        {
            base.Update();
            if (base.inputBank.skill3.down && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration * effectTimingFrac && !hasPlayedEffect) 
            {
                hasPlayedEffect = true;
                EffectData effectData = new EffectData
                {
                    origin = baseTransform.position,
                    rotation = Quaternion.LookRotation(characterDirection.forward),
                    scale = 1.25f,
                };
                EffectManager.SpawnEffect(Modules.ParticleAssets.yellowOrbSwing, effectData, true);
            }


            if (age >= duration * earlyEnd && base.isAuthority)
            {
                if (orbController)
                {
                    orbController.isExecutingSkill = false;
                }
                if (isStrong) 
                {
                    //Exit earlier to the Strong ender.
                    this.outer.SetState(new YellowOrbFinisher { });
                    return;
                }

                if (base.inputBank.moveVector != Vector3.zero) 
                {
                    base.outer.SetNextStateToMain();
                    return;
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


            if (fixedAge >= duration * invincibilityStartFrac && fixedAge <= duration * invincibilityEndFrac && isAuthority && !invincibilitySet)
            {
                invincibilitySet = true;
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 1, (duration * invincibilityEndFrac) - (duration * invincibilityStartFrac));
            }

            if (fixedAge >= duration * invincibilityEndFrac && isAuthority)
            {
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 0, -1);
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
                radius = (moveStrength == 3 ? 1 : Modules.StaticValues.blueOrbTripleMultiplier) * Modules.StaticValues.blueOrbBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
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
