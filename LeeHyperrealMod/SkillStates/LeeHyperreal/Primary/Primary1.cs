﻿using EntityStates;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class Primary1 : BaseMeleeAttack
    {

        private float rollSpeed;
        private Vector3 forwardDirection;
        private Animator animator;
        private Vector3 previousPosition;

        public static float initialSpeedCoefficient = 3.5f;
        public static float finalSpeedCoefficient = 0f;

        public static float moveStartFrac = 0f;
        public static float moveEndFrac = 0.03f;
        private Ray aimRay;
        public RootMotionAccumulator rma;

        public override void OnEnter()
        {
            this.hitboxName = "ShortMelee";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.swordDamageCoefficient;
            this.procCoefficient = 1f;
            this.pushForce = 300f;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2f;
            this.attackStartTime = 0.04f;
            this.attackEndTime = 0.15f;
            this.baseEarlyExitTime = 0.10f;
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
            UpdateMeleeRootMotion(1.5f);
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
            base.PlayAnimation("FullBody, Override", "primary1", "attack.playbackRate", duration);
        }
        

        protected override void SetNextState()
        {
            // Move to Primary2

            base.outer.SetState(new Primary2 { });
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
