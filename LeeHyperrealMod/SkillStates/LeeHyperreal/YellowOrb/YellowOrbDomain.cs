using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using LeeHyperrealMod.Modules;
using LeeHyperrealMod.Content.Controllers;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrbDomain : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.41f;
        public float fireTime = 0.01f;
        public float fireEndTime = 0.25f;
        public float baseFireInterval = 0.07f;
        public float fireInterval;
        public float duration = 2.8f;
        public int moveStrength; //1-3

        public float fireStopwatch;
        public int fireCount = 0;

        internal BlastAttack blastAttack;
        internal OrbController orbController;

        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.yellowOrbDomainProcCoefficient;
        internal float damageCoefficient = Modules.StaticValues.yellowOrbDomainDamageCoefficient;

        private float movementMultiplier = 1f;
        private Transform baseTransform;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.18f;
        float turnOnGravityFrac = 0.3f;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = gameObject.GetComponent<OrbController>();
            if (orbController)
            {
                orbController.isExecutingSkill = true;
            }

            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;

            fireInterval = baseFireInterval / attackSpeedStat;

            Ray aimRay = base.GetAimRay();


            base.characterDirection.forward = inputBank.aimDirection;

            PlayAttackAnimation();

            //check for move strength whether to get Anschauung stack
            // Added in entry.
            //if (moveStrength >= 3)
            //{
            //    //add anschauung stack
            //}

            blastAttack = new BlastAttack
            {
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position + GetAimRay().direction * 2.5f,
                radius = Modules.StaticValues.yellowOrbDomainBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = damageStat * damageCoefficient,
                baseForce = Modules.StaticValues.yellowOrbDomainBlastForce,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = procCoefficient,
            };

            BlastAttack.Result result1 =
            new BlastAttack
            { 
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position + GetAimRay().direction * 2.5f,
                radius = Modules.StaticValues.yellowOrbDomainBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = 1f,
                baseForce = 1000f,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = procCoefficient,

            }.Fire();

            if (result1.hitCount > 0)
            {
                OnHitEnemyAuthority(result1);
            }

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            baseTransform = childLocator.FindChild("BaseTransform");
            EffectData effectData = new EffectData
            {
                origin = baseTransform.position,
                rotation = Quaternion.LookRotation(characterDirection.forward),
            };
            EffectManager.SpawnEffect(Modules.ParticleAssets.yellowOrbMultishot, effectData, true);


            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;

        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "YellowOrbDomain", "attack.playbackRate", duration);
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
            if (base.inputBank.skill3.down && base.inputBank.skill4.down && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration * earlyEnd && base.isAuthority)
            {
                if (orbController)
                {
                    orbController.isExecutingSkill = false;
                }
                if (inputBank.moveVector != Vector3.zero)
                {
                    base.outer.SetNextStateToMain();
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration * turnOnGravityFrac)
            {
                characterMotor.gravityParameters = oldGravParams;
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.
            if (fixedAge >= duration * fireTime && fixedAge <= duration * fireEndTime && isAuthority)
            {
                if (fireStopwatch <= 0f && fireCount < StaticValues.yellowOrbDomainFireCount)
                {
                    fireStopwatch = fireInterval;
                    blastAttack.Fire();
                    fireCount++;
                }
                else
                {
                    fireStopwatch -= Time.fixedDeltaTime;
                }

            }



            if (fixedAge >= duration && isAuthority)
            {
                outer.SetNextStateToMain();
                return;
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
                EffectManager.SpawnEffect(Modules.ParticleAssets.yellowOrbMultishotHit, effectData, true);
            }
        }


        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
