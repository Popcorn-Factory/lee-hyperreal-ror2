using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using LeeHyperrealMod.Modules;
using UnityEngine.UIElements.UIR;
using LeeHyperrealMod.Content.Controllers;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrbDomain : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.45f;
        public float fireTime = 0.35f;
        public float baseFireInterval = 0.07f;
        public float fireInterval;
        public float duration = 4f;
        public int moveStrength; //1-3

        public float fireStopwatch;
        public int fireCount = 0;

        internal BlastAttack blastAttack;
        internal OrbController orbController;

        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.redOrbProcCoefficient;
        internal float damageCoefficient = Modules.StaticValues.redOrbDomainDamageCoefficient;


        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.298f;
        float gravOffTimer = 0.18f;

        private float movementMultiplier = 1.5f;

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

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;

            Ray aimRay = base.GetAimRay();
            characterMotor.velocity.y = 0f;


            PlayAttackAnimation();


            blastAttack = new BlastAttack
            {
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position + characterDirection.forward * 2.5f,
                radius = Modules.StaticValues.redOrbDomainBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = damageStat * Modules.StaticValues.redOrbDomainDamageCoefficient,
                baseForce = 1000f,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = procCoefficient,
            };

        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "RedOrbDomain", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
            characterMotor.gravityParameters = oldGravParams;
            PlayAnimation("Body", "BufferEmpty");
            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
        }

        public override void Update()
        {
            base.Update();

            //Able to be cancelled after this.
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

            if(age >= duration * gravOffTimer && base.isAuthority)
            {
                base.characterMotor.gravityParameters = oldGravParams;
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            if (fixedAge >= duration * fireTime)
            {
                if(fireStopwatch <= 0f && fireCount < StaticValues.redOrbDomainFireCount)
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


        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
