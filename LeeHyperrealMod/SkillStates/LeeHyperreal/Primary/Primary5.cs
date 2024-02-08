﻿using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
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

        public RootMotionAccumulator rma;


        public static float heldButtonThreshold = 0.46f;
        public bool ifButtonLifted = false;

        private LeeHyperrealDomainController domainController;
        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.23f;

        public override void OnEnter()
        {
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            this.hitboxName = "LongMelee";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.swordDamageCoefficient;
            this.procCoefficient = 1f;
            this.pushForce = 300f;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2.4f;
            this.attackStartTime = 0.28f;
            this.attackEndTime = 0.4f;
            this.baseEarlyExitTime = 0.46f;
            this.bufferActiveTime = 0.36f;
            this.moveCancelEndTime = 0.48f;
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

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;
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
            if (!base.inputBank.skill1.down)
            {
                ifButtonLifted = true;
            }

            if (!ifButtonLifted && base.isAuthority && base.stopwatch >= duration * heldButtonThreshold && domainController.DomainEntryAllowed())
            {
                //Cancel out into Domain shift skill state
                base.outer.SetState(new DomainEnterState { });
            }

            if (base.stopwatch >= duration * turnOffGravityFrac)
            {
                base.characterMotor.gravityParameters = oldGravParams;
            }


            base.Update();

            base.characterMotor.Motor.ForceUnground();
            UpdateMeleeRootMotion(1.8f);
        }


        public override void FixedUpdate()
        {
            base.FixedUpdate();
            base.characterMotor.Motor.ForceUnground();
        }

        public override void OnExit()
        {
            base.characterMotor.gravityParameters = oldGravParams;
            base.OnExit();

            base.PlayAnimation("Body", "BufferEmpty");
        }

        protected override void OnHitEnemyAuthority()
        {
            base.OnHitEnemyAuthority();
            //Increment the orb incrementor

            if (orbController)
            {
                orbController.AddToIncrementor(0.2f / ((attackAmount <= 0) ? 1 : attackAmount));
            }
        }

        protected override void PlayAttackAnimation()
        {
            base.PlayAnimation("Body", "primary5", "attack.playbackRate", duration);
        }

        protected override void SetNextState()
        {
            // End

            base.outer.SetNextStateToMain();
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
