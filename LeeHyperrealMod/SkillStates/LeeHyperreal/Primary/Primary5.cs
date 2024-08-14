using EntityStates;
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
        bool playedLandingEffect = false;
        float slamEffectFrac = 0.3f;

        public override void OnEnter()
        {
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            this.hitboxName = "LongMelee";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.primary5DamageCoefficient;
            this.procCoefficient = Modules.StaticValues.primary5ProcCoefficient;
            this.pushForce = Modules.StaticValues.primary5PushForce;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2.4f;
            this.attackStartTime = 0.28f;
            this.attackEndTime = 0.4f;
            this.baseEarlyExitTime = 0.46f;
            this.bufferActiveTime = 0.36f;
            this.moveCancelEndTime = 0.48f;
            this.hitStopDuration = 0.012f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = Modules.StaticValues.primary5HitHopVelocity;

            this.swingSoundString = "";
            this.hitSoundString = "";
            this.muzzleString = swingIndex % 2 == 0 ? "SwingLeft" : "SwingRight";
            this.swingEffectPrefab = Modules.ParticleAssets.primary5Swing;
            this.hitEffectPrefab = Modules.ParticleAssets.primary4Hit;
            base.OnEnter();
            InitMeleeRootMotion();

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;


            PlaySwing("BaseTransform", 1.25f, Modules.ParticleAssets.primary5Swing);
            Util.PlaySound("Play_c_liRk4_atk_nml_5_xuli", base.gameObject);
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
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    //Cancel out into Domain shift skill state
                    base.outer.SetNextState(new DomainEnterState { shouldForceUpwards = true });
                }
            }


            if (base.stopwatch <= duration * turnOffGravityFrac)
            {
                base.characterMotor.Motor.ForceUnground();
            }

            if (base.stopwatch >= duration * turnOffGravityFrac)
            {
                base.characterMotor.gravityParameters = oldGravParams;
                //Is falling, play effect
                animator.SetBool("isGrounded", base.isGrounded);
            }

            if (base.stopwatch >= duration * slamEffectFrac && !playedLandingEffect) 
            {
                playedLandingEffect = true;
                PlaySwing("BaseTransform", 1.25f, Modules.ParticleAssets.primary5Floor);
            }


            base.Update();
            UpdateMeleeRootMotion(1.8f);
        }
        public void PlaySwing(string muzzleString, float swingScale, GameObject effectPrefab)
        {
            if (!base.isAuthority) 
            {
                return;
            }
            ModelLocator component = gameObject.GetComponent<ModelLocator>();
            if (component && component.modelTransform)
            {
                ChildLocator component2 = component.modelTransform.GetComponent<ChildLocator>();
                if (component2)
                {
                    int childIndex = component2.FindChildIndex(muzzleString);
                    Transform transform = component2.FindChild(childIndex);
                    if (transform)
                    {
                        EffectData effectData = new EffectData
                        {
                            origin = transform.position,
                            scale = swingScale,
                        };
                        effectData.SetChildLocatorTransformReference(gameObject, childIndex);
                        EffectManager.SpawnEffect(effectPrefab, effectData, true);
                    }
                }
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void OnExit()
        {
            animator.SetBool("isGrounded", base.isGrounded);
            base.characterMotor.gravityParameters = oldGravParams;
            base.OnExit();

            base.PlayAnimation("Body", "BufferEmpty");
        }

        protected override void TriggerOrbIncrementor(int timesHit)
        {
            if (orbController)
            {
                orbController.AddToIncrementor(Modules.StaticValues.flatAmountToGrantOnPrimaryHit * timesHit);
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
