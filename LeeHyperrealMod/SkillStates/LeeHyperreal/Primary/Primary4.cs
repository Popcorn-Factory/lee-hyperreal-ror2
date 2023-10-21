using EntityStates;
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

        public static float moveStartFrac = 0f;
        public static float moveEndFrac = 0.18f;
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

        public override void OnEnter()
        {
            base.OnEnter();
            duration = 2.5f;
            pulseRate = basePulseRate / this.attackSpeedStat;
            earlyExitTime = 0.4f;
            hasFired = false;
            timings = new List<Tuple<float, float>>
            {
                new Tuple<float, float>(0f, 0.04f),
                new Tuple<float, float>(0.08f, 0.11f),
                new Tuple<float, float>(0.15f, 0.17f),
                new Tuple<float, float>(0.22f, 0.24f),
                new Tuple<float, float>(0.29f, 0.31f),
                new Tuple<float, float>(0.36f, 0.38f),
                new Tuple<float, float>(0.42f, 0.44f),
            };
            currentIndex = 0;
            currentTiming = timings[currentIndex];

            aimRay = base.GetAimRay();

            if (base.isAuthority && base.inputBank && base.characterDirection)
            {
                this.forwardDirection = aimRay.direction;
            }

            Vector3 rhs = base.characterDirection ? base.characterDirection.forward : this.forwardDirection;
            Vector3 rhs2 = Vector3.Cross(Vector3.up, rhs);

            this.RecalculateRollSpeed();

            if (base.characterMotor && base.characterDirection)
            {
                float yCharacterMotorVelocity = base.characterMotor.velocity.y;
                base.characterMotor.velocity = this.forwardDirection * this.rollSpeed;
                base.characterMotor.velocity.y = yCharacterMotorVelocity;
            }

            Vector3 b = base.characterMotor ? base.characterMotor.velocity : Vector3.zero;
            this.previousPosition = base.transform.position - b;

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
        }

        public override void Update()
        {
            base.Update();

            stopwatch += Time.deltaTime;

            if (base.fixedAge > duration * currentTiming.Item2)
            {
                if (currentIndex < timings.Count - 1)
                {
                    currentIndex++;
                }

                currentTiming = timings[currentIndex];
            }


            this.RecalculateRollSpeed();

            if (base.characterDirection) base.characterDirection.forward = this.forwardDirection;

            Vector3 normalized = (base.transform.position - this.previousPosition).normalized;
            if (base.characterMotor && base.characterDirection && normalized != Vector3.zero)
            {
                float yCharacterMotorVelocity = base.characterMotor.velocity.y;
                Vector3 vector = normalized * this.rollSpeed;
                float d = Mathf.Max(Vector3.Dot(vector, this.forwardDirection), 0f);
                vector = this.forwardDirection * d;

                base.characterMotor.velocity = vector;
                base.characterMotor.velocity.y = yCharacterMotorVelocity;
            }
            this.previousPosition = base.transform.position;

            if (stopwatch >= pulseRate) 
            {
                stopwatch = 0f;

                if (base.isAuthority) 
                {
                    FireAttack();
                }
            }

            if (this.age >= (this.duration * this.earlyExitTime) && base.isAuthority)
            {
                if (base.inputBank.skill1.down)
                {
                    this.SetNextState();
                    return;
                }
            }

            if (this.age >= this.duration && base.isAuthority)
            {
                this.outer.SetNextStateToMain();
                return;
            }

        }


        private void RecalculateRollSpeed()
        {
            this.rollSpeed = this.moveSpeedStat * Mathf.Lerp(initialSpeedCoefficient, finalSpeedCoefficient, (base.age - currentTiming.Item1) / duration * currentTiming.Item2);
        }


        // Client sided function. Don't call on server.
        internal void FireAttack() 
        {
            attack.position = this.gameObject.transform.position;
            BlastAttack.Result result = attack.Fire();
            Util.PlayAttackSpeedSound("HenrySwordSwing", base.gameObject, this.attackSpeedStat);
            if (result.hitCount > 0) 
            {
                // I dunno do something with this.
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
            return InterruptPriority.PrioritySkill;
        }
    }
}
