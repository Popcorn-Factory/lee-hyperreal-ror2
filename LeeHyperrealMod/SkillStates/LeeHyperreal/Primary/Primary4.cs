﻿using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class Primary4 : BaseSkillState
    {
        private float rollSpeed;
        private Vector3 forwardDirection;
        private Vector3 previousPosition;

        public static float initialSpeedCoefficient = 2.2f;
        public static float finalSpeedCoefficient = 0f;

        public static float moveStartFrac = 0.05f;
        public static float moveEndFrac = 0.47f;
        public static float shootRadius = Modules.StaticValues.primary4BlastRadius;
        public static float basePulseRate = Modules.StaticValues.primary4BasePulseRate;
        public static float damageCoefficient = Modules.StaticValues.primary4DamageCoefficient;
        public float pulseRate;
        private Ray aimRay;

        private static List<Tuple<float, float>> timings;
        private Tuple<float, float> currentTiming;
        private int currentIndex;

        private bool bufferNextMove;
        private float bufferActiveTime;
        private float earlyExitTime;
        public float duration;
        public float baseDuration = 3f;
        private float hitPauseTimer;
        private BlastAttack attack;
        protected bool inHitPause;
        private bool hasHopped;
        internal float stopwatch;
        internal float moveCancelEndTime = 0.7f;
        public RootMotionAccumulator rma;
        public OrbController orbController;
        private int hitConfirmResult;

        public static float heldButtonThreshold = 0.46f;
        public bool ifButtonLifted = false;

        private LeeHyperrealDomainController domainController;

        public float defaultMovementMultiplier = 1f;
        public float inputMovementMultiplier = 2.5f;
        public float movementMultiplier;
        public Transform baseTransform;

        public float waitSwingTimer = 0.066f;
        public bool playedSwing = false;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            duration = baseDuration / Modules.StaticValues.ScaleAttackSpeed(attackSpeedStat);
            pulseRate = basePulseRate / this.attackSpeedStat;
            earlyExitTime = 0.48f;

            bufferActiveTime = 0.42f;
            aimRay = base.GetAimRay();
            PlayAttackAnimation();

            // Setup Blastattack
            attack = new BlastAttack
            {
                attacker = base.gameObject,
                inflictor = null,
                teamIndex = base.GetTeam(),
                position = base.gameObject.transform.position,
                radius = shootRadius,
                falloffModel = BlastAttack.FalloffModel.None,
                baseDamage = this.damageStat * damageCoefficient,
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = this.RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.NearestHit,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = Modules.StaticValues.primary4ProcCoefficient,
                impactEffect = EffectCatalog.FindEffectIndexFromPrefab(Modules.ParticleAssets.primary4Hit),
                attackerFiltering = AttackerFiltering.NeverHitSelf
        };

            stopwatch = 0f;
            InitMeleeRootMotion();
            movementMultiplier = defaultMovementMultiplier;

            if (base.isAuthority) 
            {
                PlaySwingEffect("BaseTransform", 1.25f, Modules.ParticleAssets.primary4AfterImage);
            }
        }

        public void PlaySwingEffect(string muzzleString, float swingScale, GameObject effectPrefab) 
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
                        EffectManager.SpawnEffect(effectPrefab, effectData, true);
                    }
                }
            }
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
                    a.x *= Modules.StaticValues.ScaleMoveSpeed(moveSpeedStat);
                    a.z *= Modules.StaticValues.ScaleMoveSpeed(moveSpeedStat);

                    base.characterMotor.rootMotion = a * scale;
                }
            }
        }

        public override void Update()
        {
            if ((base.inputBank.skill3.justPressed || base.inputBank.skill4.justPressed) && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (base.isAuthority && this.age >= duration * bufferActiveTime && base.isAuthority) 
            {
                if (inputBank.skill1.down) 
                {
                    bufferNextMove = true;
                }
            }

            if (this.age >= waitSwingTimer * duration && !playedSwing && base.isAuthority) 
            {
                playedSwing = true;
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_atk_nml_4").Send(R2API.Networking.NetworkDestination.Clients);
                PlaySwingEffect("BaseTransform", 1f, Modules.ParticleAssets.primary4Swing);
            }

            if (base.isAuthority && this.age <= duration * earlyExitTime) 
            {
                if (inputBank.moveVector != Vector3.zero)
                {
                    this.characterDirection.moveVector = base.inputBank.moveVector;
                    this.characterDirection.forward = base.inputBank.moveVector;
                    movementMultiplier = inputMovementMultiplier;
                }
                else 
                {
                    this.characterDirection.moveVector = base.inputBank.aimDirection;
                    this.characterDirection.forward = base.inputBank.aimDirection;
                    movementMultiplier = defaultMovementMultiplier;
                }
            }

            if (!base.inputBank.skill1.down)
            {
                ifButtonLifted = true;
            }

            if (!ifButtonLifted && base.isAuthority && base.age >= duration * heldButtonThreshold && domainController.DomainEntryAllowed())
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    //Cancel out into Domain shift skill state
                    base.outer.SetNextState(new DomainEnterState { shouldForceUpwards = true });
                }
            }

            base.Update();

            UpdateMeleeRootMotion(movementMultiplier);
            stopwatch += Time.deltaTime;

            if (this.age >= (this.duration * moveStartFrac) && this.age <= (this.duration * moveEndFrac)) 
            {
                if (stopwatch >= pulseRate)
                {
                    stopwatch = 0f;

                    if (base.isAuthority)
                    {
                        FireAttack();
                    }
                }
            }

            if (this.age >= (this.duration * this.earlyExitTime) && base.isAuthority)
            {
                //Check this first.
                if (base.inputBank.skill1.down || bufferNextMove)
                {
                    this.SetNextState();
                    return;
                }

                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }

            if (this.age >= (this.duration * this.moveCancelEndTime) && base.isAuthority) 
            {
                if (inputBank.moveVector != new Vector3(0, 0, 0)) 
                {
                    this.outer.SetNextStateToMain();
                    return;
                }
            }

            if (this.age >= this.duration && base.isAuthority)
            {
                this.outer.SetNextStateToMain();
                return;
            }

        }


        // Client sided function. Don't call on server.
        internal void FireAttack() 
        {
            attack.position = this.gameObject.transform.position;
            BlastAttack.Result result = attack.Fire();

            if (result.hitCount > 0) 
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_imp_nml_4").Send(R2API.Networking.NetworkDestination.Clients);
                if (orbController)
                {
                    orbController.AddToIncrementor(Modules.StaticValues.flatAmountToGrantOnPrimaryHit * result.hitCount * basePulseRate);
                }

            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void OnExit()
        {
            base.OnExit();
            this.characterBody.SetAimTimer(0);
            base.PlayAnimation("Body", "BufferEmpty");
        }


        protected void PlayAttackAnimation()
        {
            base.PlayAnimation("Body", "primary4", "attack.playbackRate", duration);
        }

        protected void SetNextState()
        {
            // Move to Primary5
            if (!base.isGrounded)
            {
                if (domainController && domainController.GetDomainState())
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextState(new PrimaryDomainAerialStart { });
                        return;
                    }
                }

                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetNextState(new PrimaryAerialStart { });
                    return;
                }
            }

            if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
            {
                base.outer.SetNextState(new Primary5 { });
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
