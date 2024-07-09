using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
using RoR2;
using System.Reflection;
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

        public static float moveStartFrac = 0.25f;
        public static float moveEndFrac = 0.35f;
        private Ray aimRay;

        public RootMotionAccumulator rma;

        public static float heldButtonThreshold = 0.25f;
        public bool ifButtonLifted = false;

        public float attack2StartFrac = 0.35f;
        public float attack2EndFrac = 0.40f;
        public bool hasFired2 = false;

        public float attack3StartFrac = 0.45f;
        public float attack3EndFrac = 0.50f;
        public bool hasFired3 = false;

        private LeeHyperrealDomainController domainController;

        public override void OnEnter()
        {
            PlayExtraSwingEffect(Modules.ParticleAssets.primary2Shot);
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            this.hitboxName = "Primary2";

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.primary2DamageCoefficient;
            this.procCoefficient = Modules.StaticValues.primary2ProcCoefficient;
            this.pushForce = Modules.StaticValues.primary2PushForce;
            this.bonusForce = Vector3.zero;
            this.baseDuration = 2.366f;
            this.attackStartTime = 0.25f;
            this.attackEndTime = 0.35f;
            this.moveCancelEndTime = 0.6f;
            this.baseEarlyExitTime = 0.5f;

            this.bufferActiveTime = 0.15f;
            this.hitStopDuration = 0.012f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = Modules.StaticValues.primary2HitHopVelocity;

            this.swingSoundString = "HenrySwordSwing";
            this.hitSoundString = "";
            this.muzzleString = "BaseTransform";
            this.swingEffectPrefab = null;
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
            if (base.stopwatch >= duration * attack2StartFrac && base.stopwatch <= duration * attack2EndFrac && base.isAuthority && !hasFired2)
            {
                FireSecondAttack();
            }
            base.FixedUpdate();
            if (base.stopwatch >= duration * attack3StartFrac && base.stopwatch <= duration * attack3EndFrac && base.isAuthority && !hasFired3)
            {
                FireThirdAttack();
            }
        }

        internal void FireSecondAttack()
        {
            if (!hasFired2)
            {
                this.hasFired2 = true;

                if (base.isAuthority)
                {
                    this.PlaySwingEffect();
                    base.AddRecoil(-1f * this.attackRecoil, -2f * this.attackRecoil, -0.5f * this.attackRecoil, 0.5f * this.attackRecoil);
                    for (int i = 0; i < attackAmount; i++)
                    {
                        // Create Attack, fire it, do the on hit enemy authority.
                        this.attack = new OverlapAttack();
                        this.attack.damageType = this.damageType;
                        this.attack.attacker = base.gameObject;
                        this.attack.inflictor = base.gameObject;
                        this.attack.teamIndex = base.GetTeam();
                        this.attack.damage = this.damageCoefficient * this.damageStat;
                        this.attack.procCoefficient = this.procCoefficient;
                        this.attack.hitEffectPrefab = this.hitEffectPrefab;
                        this.attack.forceVector = this.bonusForce / attackAmount;
                        this.attack.pushAwayForce = this.pushForce / attackAmount;
                        this.attack.hitBoxGroup = hitBoxGroup;
                        this.attack.isCrit = base.RollCrit();
                        this.attack.impactSound = this.impactSound;
                        if (this.attack != null)
                        {
                            if (this.attack.Fire())
                            {
                                this.OnHitEnemyAuthority();
                            }
                        }
                    }
                    if (partialAttack > 0.0f)
                    {
                        // Create Attack, fire it, do the on hit enemy authority, partaial damage on final 
                        this.attack = new OverlapAttack();
                        this.attack.damageType = this.damageType;
                        this.attack.attacker = base.gameObject;
                        this.attack.inflictor = base.gameObject;
                        this.attack.teamIndex = base.GetTeam();
                        this.attack.damage = this.damageCoefficient * this.damageStat * partialAttack;
                        this.attack.procCoefficient = this.procCoefficient * partialAttack;
                        this.attack.hitEffectPrefab = this.hitEffectPrefab;
                        this.attack.forceVector = this.bonusForce * partialAttack / attackAmount;
                        this.attack.pushAwayForce = this.pushForce * partialAttack / attackAmount;
                        this.attack.hitBoxGroup = hitBoxGroup;
                        this.attack.isCrit = base.RollCrit();
                        this.attack.impactSound = this.impactSound;
                        if (this.attack != null)
                        {
                            if (this.attack.Fire())
                            {
                                this.OnHitEnemyAuthority();
                            }
                        }
                    }
                }
            }
        }
        internal void FireThirdAttack()
        {
            if (!hasFired3)
            {
                this.hasFired3 = true;

                if (base.isAuthority)
                {
                    this.PlaySwingEffect();
                    base.AddRecoil(-1f * this.attackRecoil, -2f * this.attackRecoil, -0.5f * this.attackRecoil, 0.5f * this.attackRecoil);
                    for (int i = 0; i < attackAmount; i++)
                    {
                        // Create Attack, fire it, do the on hit enemy authority.
                        this.attack = new OverlapAttack();
                        this.attack.damageType = this.damageType;
                        this.attack.attacker = base.gameObject;
                        this.attack.inflictor = base.gameObject;
                        this.attack.teamIndex = base.GetTeam();
                        this.attack.damage = this.damageCoefficient * this.damageStat;
                        this.attack.procCoefficient = this.procCoefficient;
                        this.attack.hitEffectPrefab = this.hitEffectPrefab;
                        this.attack.forceVector = this.bonusForce / attackAmount;
                        this.attack.pushAwayForce = this.pushForce / attackAmount;
                        this.attack.hitBoxGroup = hitBoxGroup;
                        this.attack.isCrit = base.RollCrit();
                        this.attack.impactSound = this.impactSound;
                        if (this.attack != null)
                        {
                            if (this.attack.Fire())
                            {
                                this.OnHitEnemyAuthority();
                            }
                        }
                    }
                    if (partialAttack > 0.0f)
                    {
                        // Create Attack, fire it, do the on hit enemy authority, partaial damage on final 
                        this.attack = new OverlapAttack();
                        this.attack.damageType = this.damageType;
                        this.attack.attacker = base.gameObject;
                        this.attack.inflictor = base.gameObject;
                        this.attack.teamIndex = base.GetTeam();
                        this.attack.damage = this.damageCoefficient * this.damageStat * partialAttack;
                        this.attack.procCoefficient = this.procCoefficient * partialAttack;
                        this.attack.hitEffectPrefab = this.hitEffectPrefab;
                        this.attack.forceVector = this.bonusForce * partialAttack / attackAmount;
                        this.attack.pushAwayForce = this.pushForce * partialAttack / attackAmount;
                        this.attack.hitBoxGroup = hitBoxGroup;
                        this.attack.isCrit = base.RollCrit();
                        this.attack.impactSound = this.impactSound;
                        if (this.attack != null)
                        {
                            if (this.attack.Fire())
                            {
                                this.OnHitEnemyAuthority();
                            }
                        }
                    }
                }
            }
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
        protected void PlayExtraSwingEffect(GameObject effect)
        {
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
                        EffectManager.SpawnEffect(effect, effectData, true);
                    }
                }
            }
        }
    }
}
