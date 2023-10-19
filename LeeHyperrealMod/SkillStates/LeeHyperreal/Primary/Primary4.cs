using EntityStates;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class Primary4 : BaseMeleeAttack
    {
        private float rollSpeed;
        private Vector3 forwardDirection;
        private Vector3 previousPosition;

        public static float initialSpeedCoefficient = 2.5f;
        public static float finalSpeedCoefficient = 0f;

        public static float moveStartFrac = 0f;
        public static float moveEndFrac = 0.18f;
        private Ray aimRay;

        private static List<Tuple<float, float>> timings;
        private Tuple<float, float> currentTiming;
        private int currentIndex;

        public override void OnEnter()
        {
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

            this.hitboxName = "Sword";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.swordDamageCoefficient;
            this.procCoefficient = 1f;
            this.pushForce = 300f;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2f;
            this.attackStartTime = 0.2f;
            this.attackEndTime = 0.4f;
            this.baseEarlyExitTime = 0.4f;
            this.hitStopDuration = 0.012f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = 4f;

            this.swingSoundString = "HenrySwordSwing";
            this.hitSoundString = "";
            this.muzzleString = swingIndex % 2 == 0 ? "SwingLeft" : "SwingRight";
            this.swingEffectPrefab = Modules.Assets.swordSwingEffect;
            this.hitEffectPrefab = Modules.Assets.swordHitImpactEffect;

            this.impactSound = Modules.Assets.swordHitSoundEvent.index;
            base.OnEnter();

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
                base.characterMotor.velocity = this.forwardDirection * this.rollSpeed;
            }

            Vector3 b = base.characterMotor ? base.characterMotor.velocity : Vector3.zero;
            this.previousPosition = base.transform.position - b;
        }

        public override void Update()
        {
            base.Update();
            if (stopwatch > duration * currentTiming.Item2) 
            {
                if (currentIndex < timings.Count) 
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
                Vector3 vector = normalized * this.rollSpeed;
                float d = Mathf.Max(Vector3.Dot(vector, this.forwardDirection), 0f);
                vector = this.forwardDirection * d;

                base.characterMotor.velocity = vector;
            }
            this.previousPosition = base.transform.position;

        }


        private void RecalculateRollSpeed()
        {
            this.rollSpeed = this.moveSpeedStat * Mathf.Lerp(initialSpeedCoefficient, finalSpeedCoefficient, (base.stopwatch - currentTiming.Item1) / duration * currentTiming.Item2);
        }


        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        protected override void PlayAttackAnimation()
        {
            base.PlayAnimation("FullBody, Override", "primary4", "attack.playbackRate", duration);
        }

        protected override void SetNextState()
        {
            // Move to Primary5

            base.outer.SetState(new Primary5 { });
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
