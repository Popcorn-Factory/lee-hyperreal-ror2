using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using LeeHyperrealMod.Modules;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrbDomain : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.35f;
        public float fireTime = 0.01f;
        public float fireEndTime = 0.25f;
        public float baseFireInterval = 0.07f;
        public float fireInterval;
        public float duration = 5f;
        public int moveStrength; //1-3

        public float fireStopwatch;
        public int fireCount = 0;

        internal BlastAttack blastAttack;

        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.yellowOrbProcCoefficient;
        internal float damageCoefficient = Modules.StaticValues.yellowOrbDomainDamageCoefficient;

        private float movementMultiplier = 1.5f;

        public override void OnEnter()
        {
            base.OnEnter();
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
            PlayAnimation("FullBody, Override", "YellowOrbDomain", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();

            if (age >= duration * earlyEnd && base.isAuthority)
            {

                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.
            if (fixedAge >= duration * fireTime && fixedAge <= duration * fireEndTime)
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
