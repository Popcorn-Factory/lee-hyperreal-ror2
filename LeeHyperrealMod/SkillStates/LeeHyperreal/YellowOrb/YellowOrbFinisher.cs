﻿using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrbFinisher : BaseMeleeAttack
    {
        internal OverlapAttack attack;

        internal HitBoxGroup hitBoxGroup;

        internal int attackAmount;
        internal float partialAttack;

        internal float attackStart = 0.154f;
        internal float attackEnd = 0.24f;
        internal float exitEarlyFrac = 0.35f;

        internal RootMotionAccumulator rma;

        public override void OnEnter()
        {
            base.OnEnter();
            this.hitboxName = "ShortMelee";
            duration = 1.13f;

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.swordDamageCoefficient;
            this.procCoefficient = 1f;
            this.pushForce = 300f;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2.366f;
            this.attackStartTime = attackStart;
            this.attackEndTime = attackEnd;
            this.baseEarlyExitTime = exitEarlyFrac;
            this.hitStopDuration = 0.05f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = 4f;

            this.swingSoundString = "HenrySwordSwing";
            this.hitSoundString = "";
            this.muzzleString = swingIndex % 2 == 0 ? "SwingLeft" : "SwingRight";
            this.swingEffectPrefab = Modules.Assets.swordSwingEffect;
            this.hitEffectPrefab = Modules.Assets.swordHitImpactEffect;

            this.impactSound = Modules.Assets.swordHitSoundEvent.index;

            enableParry = true;
            parryLength = 0.5f;
            parryTiming = 0.05f;
            parryPauseLength = 0.2f;

            base.OnEnter();

            InitMeleeRootMotion();
        }
        
        protected override void PlayAttackAnimation()
        {
            PlayAnimation("FullBody, Override", "yellowOrb2", "attack.playbackRate", duration);
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

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();

            UpdateMeleeRootMotion(1.6f);

            if (base.age >= duration * exitEarlyFrac && base.isAuthority) 
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }



        public void OnHitEnemyAuthority()
        {
            //Do something on hit.
        }

    }
}
