using EntityStates;
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

        public static float damageCoefficient = Modules.StaticValues.snipeDamageCoefficient;
        public static float procCoefficient = 1f;
        public static float baseDuration = 1.3f;
        public static float force = 800f;
        public static float recoil = 3f;
        public static float range = 256f;

        public OrbController orbController;
        public BulletController bulletController;
        public LeeHyperrealDomainController domainController;
        public float empoweredBulletMultiplier = 1f;

        public Vector3 velocity;

        public bool triggerBreakVFX = false;
        public bool playBreakSFX = false;
        public float playReloadSFXFrac = 0.475f;
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



            if (bulletController.ConsumeEnhancedBullet(1))
            {
                empoweredBulletMultiplier = Modules.StaticValues.empoweredBulletMultiplier;
                playBreakSFX = true;
                triggerBreakVFX = true;
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
            if (!hasPlayedReload)
            {
                hasPlayedReload = true;
                AkSoundEngine.PostEvent("Play_c_liRk4_atk_ex_3_reload", base.gameObject);
            }
        }

        public void PlaySwingEffect(float scale, GameObject effectPrefab, Vector3 startPos, Vector3 aimVector)
        {
            var effectData = new EffectData()
            {
                origin = startPos,
                rotation = Quaternion.LookRotation(aimVector),
                scale = scale
            };

            EffectManager.SpawnEffect(effectPrefab, effectData, true);
        }

        public override void Update()
        {
            base.Update();

            base.characterMotor.velocity = new Vector3(0, 0, 0);
            base.characterDirection.moveVector = new Vector3(0, 0, 0);

            if ((base.inputBank.skill4.justPressed || base.inputBank.skill2.justPressed) && isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration * playReloadSFXFrac && !hasPlayedReload)
            {
                hasPlayedReload = true;
                AkSoundEngine.PostEvent("Play_c_liRk4_atk_ex_3_reload", base.gameObject);
            }

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            if (age >= duration * firingFrac && base.isAuthority && !hasFired)
            {
                PlayAttackAnimation();

                this.hasFired = true;

                base.characterBody.AddSpreadBloom(1.5f);

                var modelTransform = GetModelTransform();
                var muzzleTransform = modelTransform.Find("Rifle").transform;
                var startPos = muzzleTransform.position;
                var startEffectPos = startPos;

                const float scale = 1.25f;
                var stupidOffset = scale == 1.25f ? 0.89f : 0.6f;
                startEffectPos.y -= stupidOffset;

                PlayerCharacterMasterController.CanSendBodyInput(characterBody.master.playerCharacterMasterController.networkUser, out var _, out var _, out var cameraRigController);

                var endPos = cameraRigController.crosshairWorldPosition;
                var endEffectPos = endPos;
                endEffectPos.y -= stupidOffset;

                var aimVector = (endPos - startPos).normalized;
                var aimEffectVector = (endEffectPos - startEffectPos).normalized;

                if (isGrounded)
                {
                    PlaySwingEffect(scale, Modules.ParticleAssets.snipeGround, startEffectPos, aimEffectVector);
                }
                PlaySwingEffect(scale, Modules.ParticleAssets.Snipe, startEffectPos, aimEffectVector);
                PlaySwingEffect(scale, Modules.ParticleAssets.snipeBulletCasing, startEffectPos, aimEffectVector);

                base.AddRecoil(-1f * recoil, -2f * recoil, -0.5f * recoil, 0.5f * recoil);

                new BulletAttack
                {
                    bulletCount = 1,
                    aimVector = aimVector,
                    origin = startPos,
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
                    smartCollision = true,
                    procChainMask = default(ProcChainMask),
                    procCoefficient = Modules.StaticValues.snipeProcCoefficient,
                    radius = 0.75f,
                    sniper = false,
                    stopperMask = LayerIndex.world.mask,
                    weapon = null,
                    spreadPitchScale = 0f,
                    spreadYawScale = 0f,
                    hitCallback = snipeHitCallback,
                    queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                    hitEffectPrefab = triggerBreakVFX ? Modules.ParticleAssets.snipeHitEnhanced : Modules.ParticleAssets.snipeHit,
                }.Fire();

                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_atk_ex_3").Send(R2API.Networking.NetworkDestination.Clients);
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
                        base.outer.SetNextState(new Snipe { });
                        return;
                    }
                }


                //IF we're not in hold variant, then allow the transition if the skill is down.
                if (inputBank.skill2.down && !Modules.Config.allowSnipeButtonHold.Value && base.isAuthority)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextState(new ExitSnipe());
                    }
                }

                //IF we ARE in the hold variant, then allow the transition if the skill is not pressed.
                if (!base.inputBank.skill2.down && Modules.Config.allowSnipeButtonHold.Value && base.isAuthority)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextState(new ExitSnipe());
                    }
                }

                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill3.justPressed && skillLocator.utility.stock >= 1)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        skillLocator.utility.stock -= 1;
                        Vector3 result = Modules.StaticValues.CheckDirection(inputBank.moveVector, GetAimRay());
                        if (result == new Vector3(0, 0, 1))
                        {
                            base.outer.SetNextState(new Evade.Evade { unsetSnipe = true });
                            return;
                        }
                        if (result == new Vector3(0, 0, 0))
                        {
                            base.outer.SetNextState(new EvadeBack180 { });
                            return;
                        }
                        if (result == new Vector3(1, 0, 0))
                        {
                            base.outer.SetNextState(new EvadeSide { isLeftRoll = false });
                            return;
                        }
                        if (result == new Vector3(-1, 0, 0))
                        {
                            base.outer.SetNextState(new EvadeSide { isLeftRoll = true });
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
                    base.outer.SetNextState(new IdleSnipe { });
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