using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
using RoR2;
using System.Security.Cryptography;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class Primary2 : BaseMeleeAttack
    {
        private float rollSpeed;
        private Vector3 forwardDirection;
        private Animator animator;
        private Vector3 previousPosition;

        public static float initialSpeedCoefficient = 3f;
        public static float finalSpeedCoefficient = 0f;

        public static float moveStartFrac = 0f;
        public static float moveEndFrac = 0.04f;
        private Ray aimRay;

        public RootMotionAccumulator rma;

        public static float heldButtonThreshold = 0.25f;
        public bool ifButtonLifted = false;

        private LeeHyperrealDomainController domainController;

        public override void OnEnter()
        {
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            this.hitboxName = "Primary2";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.primary2DamageCoefficient;
            this.procCoefficient = Modules.StaticValues.primary2ProcCoefficient;
            this.pushForce = Modules.StaticValues.primary2PushForce;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2.366f;
            this.attackStartTime = 0.04f;
            this.attackEndTime = 0.07f;
            this.moveCancelEndTime = 0.27f;
            this.baseEarlyExitTime = 0.26f;

            this.bufferActiveTime = 0.15f;
            this.hitStopDuration = 0.012f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = Modules.StaticValues.primary2HitHopVelocity;

            this.swingSoundString = "HenrySwordSwing";
            this.hitSoundString = "";
            this.muzzleString = "BaseTransform";
            this.swingEffectPrefab = Modules.ParticleAssets.primary2Shot;
            this.hitEffectPrefab = Modules.ParticleAssets.primary2hit1;

            this.impactSound = Modules.Assets.swordHitSoundEvent.index;
            base.OnEnter();

            InitMeleeRootMotion();

            this.swingScale = 1.25f;
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
            if (!base.inputBank.skill1.down && base.isAuthority)
            {
                ifButtonLifted = true;
            }

            if (!ifButtonLifted && base.isAuthority && base.stopwatch >= duration * heldButtonThreshold && domainController.DomainEntryAllowed())
            {
                //Cancel out into Domain shift skill state
                base.outer.SetState(new DomainEnterState { shouldForceUpwards = true });
            }

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
            base.PlayAnimation("Body", "BufferEmpty");
        }

        protected override void PlayAttackAnimation()
        {
            base.PlayAnimation("Body", "primary2", "attack.playbackRate", duration);
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

        protected override void SetNextState()
        {
            // Move to Primary3

            base.outer.SetState(new Primary3 { });
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
