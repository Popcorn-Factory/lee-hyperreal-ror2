using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class Primary4 : BaseSkillState
    {
        private float rollSpeed;
        private Vector3 forwardDirection;
        private Vector3 previousPosition;

        public static float initialSpeedCoefficient = 2.2f;
        public static float finalSpeedCoefficient = 0f;

        public static float moveStartFrac = 0.05f;
        public static float moveEndFrac = 0.47f;
        public static float shootRadius = 35f;
        public static float basePulseRate = 0.2f;
        public static float damageCoefficient = 0.5f;
        public float pulseRate;
        private Ray aimRay;

        private static List<Tuple<float, float>> timings;
        private Tuple<float, float> currentTiming;
        private int currentIndex;


        private float earlyExitTime;
        public float duration;
        private bool hasFired;
        private float hitPauseTimer;
        private BlastAttack attack;
        protected bool inHitPause;
        private bool hasHopped;
        internal float stopwatch;

        public RootMotionAccumulator rma;
        public OrbController orbController;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();
            duration = 2.566f;
            pulseRate = basePulseRate / this.attackSpeedStat;
            earlyExitTime = 0.48f;
            hasFired = false;
            aimRay = base.GetAimRay();

            PlayAttackAnimation();

            // Setup Blastattack
            attack = new BlastAttack
            {
                attacker = base.gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = base.gameObject.transform.position,
                radius = shootRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = this.damageStat * damageCoefficient,
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = this.RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.NearestHit,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = 0.15f
            };

            stopwatch = 0f;
            InitMeleeRootMotion();
        }

        public RootMotionAccumulator InitMeleeRootMotion()
        {
            rma = base.GetModelRootMotionAccumulator();
            if (rma)
            {
                rma.ExtractRootMotion();
            }
            if (base.characterDirection)
            {
                base.characterDirection.forward = base.inputBank.aimDirection;
            }
            if (base.characterMotor)
            {
                base.characterMotor.moveDirection = Vector3.zero;
            }
            return rma;
        }

        // Token: 0x060003CA RID: 970 RVA: 0x0000F924 File Offset: 0x0000DB24
        public void UpdateMeleeRootMotion(float scale)
        {
            if (rma)
            {
                Vector3 a = rma.ExtractRootMotion();
                if (base.characterMotor)
                {
                    base.characterMotor.rootMotion = a * scale;
                }
            }
        }

        public override void Update()
        {
            base.Update();
            UpdateMeleeRootMotion(2.4f);
            stopwatch += Time.deltaTime;

            if (this.age >= (this.duration * moveStartFrac) && this.age <= (this.duration * moveEndFrac)) 
            {
                if (stopwatch >= pulseRate)
                {
                    stopwatch = 0f;

                    if (base.isAuthority)
                    {
                        FireAttack();
                    }
                }
            }

            if (this.age >= (this.duration * this.earlyExitTime) && base.isAuthority)
            {
                //Check this first.
                if (base.inputBank.skill1.down)
                {
                    if (!this.hasFired) this.FireAttack();
                    this.SetNextState();
                    return;
                }

                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }

            if (this.age >= this.duration && base.isAuthority)
            {
                this.outer.SetNextStateToMain();
                return;
            }

        }


        // Client sided function. Don't call on server.
        internal void FireAttack() 
        {
            attack.position = this.gameObject.transform.position;
            BlastAttack.Result result = attack.Fire();
            Util.PlayAttackSpeedSound("HenrySwordSwing", base.gameObject, this.attackSpeedStat);
            if (result.hitCount > 0) 
            {


                if (orbController)
                {
                    orbController.AddToIncrementor(0.015f);
                }

            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void OnExit()
        {
            base.OnExit();
        }


        protected void PlayAttackAnimation()
        {
            base.PlayAnimation("FullBody, Override", "primary4", "attack.playbackRate", duration);
        }

        protected void SetNextState()
        {
            // Move to Primary5

            base.outer.SetState(new Primary5 { });
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
