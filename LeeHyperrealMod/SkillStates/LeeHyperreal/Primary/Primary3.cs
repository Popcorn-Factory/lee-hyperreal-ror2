using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
using RoR2;
using System.Security.Cryptography;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class Primary3 : BaseMeleeAttack
    {

        private float rollSpeed;
        private Vector3 forwardDirection;
        private Animator animator;
        private Vector3 previousPosition;

        public static float initialSpeedCoefficient = 4f;
        public static float finalSpeedCoefficient = 0f;

        public static float moveStartFrac = 0f;
        public static float moveEndFrac = 0.18f;
        private Ray aimRay;

        public RootMotionAccumulator rma;


        public static float heldButtonThreshold = 0.21f;
        public bool ifButtonLifted = false;

        private LeeHyperrealDomainController domainController;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.13f; 

        public override void OnEnter()
        {
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            this.hitboxName = "AOEMelee";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.swordDamageCoefficient;
            this.procCoefficient = 1f;
            this.pushForce = 300f;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 3f;
            this.attackStartTime = 0.15f;
            this.attackEndTime = 0.22f;
            this.baseEarlyExitTime = 0.225f;
            this.moveCancelEndTime = 0.673f;
            this.hitStopDuration = 0.012f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = 4f;

            this.swingSoundString = "HenrySwordSwing";
            this.hitSoundString = "";
            this.muzzleString = swingIndex % 2 == 0 ? "SwingLeft" : "SwingRight";
            this.swingEffectPrefab = Modules.Assets.swordSwingEffect;
            this.hitEffectPrefab = Modules.Assets.swordHitImpactEffect;

            this.impactSound = Modules.Assets.swordHitSoundEvent.index;

            enableParry = true;
            parryLength = 0.3f;
            parryTiming = 0.08f;
            parryPauseLength = 0.2f;

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
            UpdateMeleeRootMotion(1.6f);
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

        }

        public override void OnExit()
        {

            base.PlayAnimation("Body", "BufferEmpty");
            base.characterMotor.gravityParameters = oldGravParams;
            base.OnExit();
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
            base.PlayAnimation("Body", "primary3", "attack.playbackRate", duration);
        }

        protected override void SetNextState()
        {
            // Move to Primary4

            base.outer.SetState(new Primary4 { });
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
