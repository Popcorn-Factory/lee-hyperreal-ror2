﻿using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using Unity.Audio;
using UnityEngine;
using static LeeHyperrealMod.Content.Controllers.BulletController;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class Snipe : BaseSkillState
    {
        Animator animator;
        public float earlyExitFrac = 0.35f;
        public float firingFrac = 0.08f;
        public bool hasFired;
        public float duration = 1.3f;
        public string muzzleString = "BaseTransform";

        public static float damageCoefficient = Modules.StaticValues.snipeDamageCoefficient;
        public static float procCoefficient = 1f;
        public static float baseDuration = 1.3f;
        public static float force = 800f;
        public static float recoil = 3f;
        public static float range = 256f;
        public static GameObject tracerEffectPrefab = RoR2.LegacyResourcesAPI.Load<GameObject>("Prefabs/Effects/Tracers/TracerGoldGat");

        public OrbController orbController;
        public BulletController bulletController;
        public LeeHyperrealDomainController domainController;
        public float empoweredBulletMultiplier = 1f;

        public Vector3 velocity;

        public bool playBreakSFX = false;
        public float playReloadSFXFrac = 0.505f;
        public bool hasPlayedReload = false;

        public override void OnEnter()
        {
            bulletController = gameObject.GetComponent<BulletController>();
            orbController = gameObject.GetComponent<OrbController>();
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();

            base.characterMotor.velocity = new Vector3(0, 0, 0);
            base.characterDirection.moveVector = new Vector3(0, 0, 0);

            base.characterBody.isSprinting = false;
            base.OnEnter();
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);

            duration = baseDuration / base.attackSpeedStat;

            PlayAttackAnimation();


            if (bulletController.ConsumeEnhancedBullet(1)) 
            {
                empoweredBulletMultiplier = Modules.StaticValues.empoweredBulletMultiplier;
                playBreakSFX = true;
            }

            if (domainController.GetDomainState()) 
            {
                BulletType type = bulletController.ConsumeColouredBullet();

                if (type != BulletType.NONE)
                {
                    //Grant a 3 ping.
                    orbController.Grant3Ping(type);
                    playBreakSFX = true;
                }
            }



            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);


            //characterBody.SetAimTimer(duration + 1f);

            if (!bulletController.snipeAerialPlatform && !isGrounded)
            {
                ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
                Transform baseTransform = childLocator.FindChild("BaseTransform");
                bulletController.snipeAerialPlatform = UnityEngine.Object.Instantiate(Modules.ParticleAssets.snipeAerialFloor, baseTransform.position, Quaternion.identity);
            }
        }

        public override void OnExit()
        {
            base.OnExit();
            if(!hasPlayedReload)
            {
                hasPlayedReload = true;
                AkSoundEngine.PostEvent("Play_c_liRk4_atk_ex_3_reload", base.gameObject);
            }
        }

        protected virtual void PlaySwingEffect(float scale, GameObject effectPrefab, bool aimRot = true)
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
                        Vector3 aimRotation = GetAimRay().direction;
                        EffectData effectData = new EffectData 
                        {
                            origin = transform.position,
                            scale = scale,
                            rotation = Quaternion.LookRotation(new Vector3(aimRotation.x, 0f, aimRotation.z), Vector3.up),
                        };
                        if (aimRot) 
                        {
                            effectData.rotation = Quaternion.LookRotation(GetAimRay().direction, Vector3.up);
                        }
                        //effectData.SetChildLocatorTransformReference(gameObject, childIndex);
                        EffectManager.SpawnEffect(effectPrefab, effectData, true);
                    }
                }
            }
            //EffectManager.SimpleMuzzleFlash(this.swingEffectPrefab, base.gameObject, this.muzzleString, true);
        }

        public override void Update()
        {
            base.Update();

            base.characterMotor.velocity = new Vector3(0, 0, 0);
            base.characterDirection.moveVector = new Vector3(0, 0, 0);


            if ((base.inputBank.skill4.down || base.inputBank.skill2.down))
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            Ray aimRay = base.GetAimRay();

            if (age >= duration * playReloadSFXFrac && !hasPlayedReload) 
            {
                hasPlayedReload = true;
                AkSoundEngine.PostEvent("Play_c_liRk4_atk_ex_3_reload", base.gameObject);
            }

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            if (age >= duration * firingFrac && base.isAuthority && !hasFired) 
            {
                this.hasFired = true;

                base.characterBody.AddSpreadBloom(1.5f);
                EffectData effectData = new EffectData
                {
                    origin = gameObject.transform.position,
                    scale = 1.25f,
                    rotation = Quaternion.LookRotation(GetAimRay().direction, Vector3.up),
                };
                EffectData groundData = new EffectData
                {
                    origin = gameObject.transform.position,
                    scale = 1.25f,

                };

                if (isGrounded) 
                {
                    PlaySwingEffect(1.25f, Modules.ParticleAssets.snipeGround);
                }
                PlaySwingEffect(1.25f, Modules.ParticleAssets.Snipe);
                PlaySwingEffect(1.25f, Modules.ParticleAssets.snipeBulletCasing);

                base.AddRecoil(-1f * Shoot.recoil, -2f * Shoot.recoil, -0.5f * Shoot.recoil, 0.5f * Shoot.recoil);

                new BulletAttack
                {
                    bulletCount = 1,
                    aimVector = aimRay.direction,
                    origin = aimRay.origin,
                    damage = damageCoefficient * this.damageStat * empoweredBulletMultiplier,
                    damageColorIndex = DamageColorIndex.Default,
                    damageType = DamageType.Generic,
                    falloffModel = BulletAttack.FalloffModel.None,
                    maxDistance = Modules.StaticValues.snipeRange,
                    force = Modules.StaticValues.snipeForce,
                    hitMask = LayerIndex.CommonMasks.bullet,
                    minSpread = 0f,
                    maxSpread = 0f,
                    isCrit = base.RollCrit(),
                    owner = base.gameObject,
                    muzzleName = muzzleString,
                    smartCollision = false,
                    procChainMask = default(ProcChainMask),
                    procCoefficient = Modules.StaticValues.snipeProcCoefficient,
                    radius = 0.75f,
                    sniper = false,
                    stopperMask = LayerIndex.CommonMasks.bullet,
                    weapon = null,
                    spreadPitchScale = 0f,
                    spreadYawScale = 0f,
                    hitCallback = snipeHitCallback,
                    queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                    hitEffectPrefab = Modules.ParticleAssets.snipeHit,
                }.Fire();

                if (playBreakSFX)
                {
                    new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_atk_ex_3_break").Send(R2API.Networking.NetworkDestination.Clients);
                }
                
            }

            if (age >= duration * earlyExitFrac && base.isAuthority) 
            {
                if (inputBank.skill1.down)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetState(new Snipe { });
                        return;
                    }
                }


                //IF we're not in hold variant, then allow the transition if the skill is down.
                if (inputBank.skill2.down && !Modules.Config.allowSnipeButtonHold.Value && base.isAuthority) 
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetState(new ExitSnipe());
                    }
                }

                //IF we ARE in the hold variant, then allow the transition if the skill is not pressed.
                if (!base.inputBank.skill2.down && Modules.Config.allowSnipeButtonHold.Value && base.isAuthority)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetState(new ExitSnipe());
                    }
                }

                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill3.down && skillLocator.utility.stock >= 1)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        skillLocator.utility.stock -= 1;
                        Vector3 result = Modules.StaticValues.CheckDirection(inputBank.moveVector, GetAimRay());
                        if (result == new Vector3(0, 0, 1))
                        {
                            base.outer.SetState(new Evade.Evade { unsetSnipe = true });
                            return;
                        }
                        if (result == new Vector3(0, 0, 0))
                        {
                            base.outer.SetState(new EvadeBack180 { });
                            return;
                        }
                        if (result == new Vector3(1, 0, 0))
                        {
                            base.outer.SetState(new EvadeSide { isLeftRoll = false });
                            return;
                        }
                        if (result == new Vector3(-1, 0, 0))
                        {
                            base.outer.SetState(new EvadeSide { isLeftRoll = true });
                            return;
                        }

                        return;
                    }
                }
            }

            if (age >= duration && base.isAuthority)
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetState(new IdleSnipe { });
                    return;
                }
            }
        }

        private bool snipeHitCallback(BulletAttack bulletAttack, ref BulletAttack.BulletHit hitInfo)
        {
            if (orbController)
            {
                orbController.AddToIncrementor(Modules.StaticValues.flatAmountToGrantOnPrimaryHit);
            }
            return BulletAttack.defaultHitCallback(bulletAttack, ref hitInfo);
        }

        public void PlayAttackAnimation()
        {
            PlayAnimation("Body", "SnipeShot", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
