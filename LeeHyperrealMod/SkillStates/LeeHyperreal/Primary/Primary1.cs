using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
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

        public static float heldButtonThreshold = 0.15f;
        public bool ifButtonLifted = false;

        private LeeHyperrealDomainController domainController;

        /*
         
        internal bool enableParry;
        internal float parryLength;
        internal float parryTiming;
        internal bool parryTriggered;
        internal float parryPauseLength = 0.75f;
        internal ParryMonitor parryMonitor;
         */

        public override void OnEnter()
        {
            domainController = this.GetComponent<LeeHyperrealDomainController>();

            this.hitboxName = "ShortMelee";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.swordDamageCoefficient;
            this.procCoefficient = 1f;
            this.pushForce = 300f;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2.23f;
            this.attackStartTime = 0.04f;
            this.attackEndTime = 0.15f;
            this.moveCancelEndTime = 0.17f;
            this.baseEarlyExitTime = 0.16f;
            this.bufferActiveTime = 0.10f;
            this.hitStopDuration = 0.012f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = 4f;

            this.swingSoundString = "HenrySwordSwing";
            this.hitSoundString = "";
            this.muzzleString = "Base";
            this.swingEffectPrefab = Modules.ParticleAssets.primary1Swing;
            this.hitEffectPrefab = Modules.ParticleAssets.primary1Hit;

            this.impactSound = Modules.Assets.swordHitSoundEvent.index;
            
            enableParry = true;
            parryLength = 0.1f;
            parryTiming = 0.05f;
            parryPauseLength = 0.2f;

            base.OnEnter();
            InitMeleeRootMotion();

            //Play Effect
            RoR2.EffectManager.SimpleEffect(
                Modules.ParticleAssets.primary1Floor,
                transform.position, 
                Quaternion.identity,
                true);
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
                base.outer.SetState(new DomainEnterState { });
            }

            base.Update();
            UpdateMeleeRootMotion(1.5f);

        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        protected override void PlaySwingEffect() 
        {
            EffectManager.SimpleEffect(Modules.ParticleAssets.primary1Swing, transform.position, Quaternion.identity, true);
        }

        public override void OnExit()
        {
            base.OnExit();
            base.PlayAnimation("Body", "BufferEmpty");
        }

        protected override void PlayAttackAnimation()
        {
            base.PlayAnimation("Body", "primary1", "attack.playbackRate", duration);
        }

        protected override void OnHitEnemyAuthority() 
        {
            base.OnHitEnemyAuthority();
            //Increment the orb incrementor

            if (orbController) 
            {
                orbController.AddToIncrementor(0.2f/ ((attackAmount <= 0) ? 1 : attackAmount));
            }
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
