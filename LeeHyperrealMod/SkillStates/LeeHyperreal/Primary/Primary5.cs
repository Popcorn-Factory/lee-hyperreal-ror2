﻿using EntityStates;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class Primary5 : BaseMeleeAttack
    {
        private float rollSpeed;
        private Vector3 forwardDirection;
        private Animator animator;
        private Vector3 previousPosition;

        public static float initialSpeedCoefficient = 2.6f;
        public static float finalSpeedCoefficient = 0f;

        public static float moveStartFrac = 0f;
        public static float moveEndFrac = 0.52f;
        private Ray aimRay;


        public override void OnEnter()
        {
            this.hitboxName = "LongMelee";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.swordDamageCoefficient;
            this.procCoefficient = 1f;
            this.pushForce = 300f;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2f;
            this.attackStartTime = 0.28f;
            this.attackEndTime = 0.4f;
            this.baseEarlyExitTime = 0.7f;
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
                float yCharacterMotorVelocity = base.characterMotor.velocity.y;
                base.characterMotor.velocity = this.forwardDirection * this.rollSpeed;
                base.characterMotor.velocity.y = yCharacterMotorVelocity;
            }

            Vector3 b = base.characterMotor ? base.characterMotor.velocity : Vector3.zero;
            this.previousPosition = base.transform.position - b;
        }

        public override void Update()
        {
            base.Update();

            if (this.stopwatch <= duration * moveEndFrac)
            {
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
            }
        }


        private void RecalculateRollSpeed()
        {
            this.rollSpeed = this.moveSpeedStat * Mathf.Lerp(initialSpeedCoefficient, finalSpeedCoefficient, base.fixedAge / duration * moveEndFrac);
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
            base.PlayAnimation("FullBody, Override", "primary5", "attack.playbackRate", duration);
        }

        protected override void SetNextState()
        {
            // End

            base.outer.SetNextStateToMain();
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
