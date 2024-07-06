using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary;
using R2API.Networking;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.UIElements.UIR;
using static LeeHyperrealMod.Content.Controllers.BulletController;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Evade
{
    internal class EvadeBack180 : BaseRootMotionMoverState
    {
        public static float duration = 0.566f;

        public static string dodgeSoundString = "HenryRoll";
        public static float dodgeFOV = EntityStates.Commando.DodgeState.dodgeFOV;

        private Animator animator;

        public bool isLeftRoll;

        private float earlyExitFrac = 0.803f;

        private float movementMultiplier = 2f;

        private float disableInvincibility = 0.45f;

        private float firingFrac = 0.42f;
        private bool hasFired = false;
        public static float procCoefficient = 1f;
        public string muzzleString = "BaseTransform";

        public OrbController orbController;
        public BulletController bulletController;
        public LeeHyperrealDomainController domainController;
        public float empoweredBulletMultiplier = 1f;


        public override void OnEnter()
        {
            base.OnEnter();
            animator = GetModelAnimator();
            animator.SetFloat("attack.playbackRate", 1f);
            rmaMultiplier = movementMultiplier;
            bulletController = gameObject.GetComponent<BulletController>();
            orbController = gameObject.GetComponent<OrbController>();
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();
            base.characterBody.isSprinting = false;
            if (bulletController.ConsumeEnhancedBullet(1))
            {
                empoweredBulletMultiplier = 2.0f;
            }

            if (domainController.GetDomainState())
            {
                BulletType type = bulletController.ConsumeColouredBullet();

                if (type != BulletType.NONE)
                {
                    //Grant a 3 ping.
                    orbController.Grant3Ping(type);
                }
            }

            //Receive the var from the previous state, run animation.

            if (isAuthority)
            {
                characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 1, duration * disableInvincibility);
            }
            Ray aimRay = base.GetAimRay();
            base.characterDirection.forward = aimRay.direction;
            PlayDodgeAnimation();

            StartAimMode(duration, false);

            if (bulletController.snipeAerialPlatform) 
            {
                bulletController.snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();

                bulletController.snipeAerialPlatform = null; // reset so Idle spawns another.
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

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();
            if (age >= duration * firingFrac && isAuthority && !hasFired) 
            {
                hasFired = true;
                Ray aimRay = base.GetAimRay();
                base.AddRecoil(-1f * Modules.StaticValues.snipeRecoil, -2f * Modules.StaticValues.snipeRecoil, -0.5f * Modules.StaticValues.snipeRecoil, 0.5f * Modules.StaticValues.snipeRecoil);

                if (isGrounded)
                {
                    PlaySwingEffect(1.25f, Modules.ParticleAssets.snipeGround, false);
                }
                PlaySwingEffect(1.25f, Modules.ParticleAssets.Snipe);

                new BulletAttack
                {
                    bulletCount = 1,
                    aimVector = aimRay.direction,
                    origin = aimRay.origin,
                    damage = Modules.StaticValues.snipeDamageCoefficient * this.damageStat * empoweredBulletMultiplier,
                    damageColorIndex = DamageColorIndex.Default,
                    damageType = DamageType.Generic,
                    falloffModel = BulletAttack.FalloffModel.DefaultBullet,
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
                    procCoefficient = procCoefficient,
                    radius = 0.75f,
                    sniper = false,
                    stopperMask = LayerIndex.CommonMasks.bullet,
                    weapon = null,
                    spreadPitchScale = 0f,
                    spreadYawScale = 0f,
                    queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                    hitEffectPrefab = Modules.ParticleAssets.snipeHit,
                }.Fire();

                //characterBody.SetAimTimer(duration + 1f);
                if (!bulletController.snipeAerialPlatform && !isGrounded)
                {
                    ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
                    Transform baseTransform = childLocator.FindChild("BaseTransform");
                    bulletController.snipeAerialPlatform = UnityEngine.Object.Instantiate(Modules.ParticleAssets.snipeAerialFloor, baseTransform.position, Quaternion.identity);
                }
            }

            if (age >= duration * earlyExitFrac && isAuthority)
            {
                if (base.inputBank.skill1.down)
                {
                    //Fire Snipe
                    base.outer.SetState(new Snipe { });
                    return;
                }

                if (base.inputBank.skill2.down)
                {
                    //Exit snipe
                    base.outer.SetState(new ExitSnipe { });
                    return;
                }

                if (base.inputBank.skill3.down)
                {
                    Vector3 result = Modules.StaticValues.CheckDirection(inputBank.moveVector, GetAimRay());

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
                }
            }
            if (age >= duration && isAuthority)
            {
                base.outer.SetState(new IdleSnipe{ });
                return;
            }
        }

        public void PlayDodgeAnimation() 
        {
            PlayAnimation("Body", "SnipeEvade180", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            if (age >= duration * earlyExitFrac)
            {
                return InterruptPriority.Skill;
            }
            else
            {
                return InterruptPriority.Frozen;
            }
        }
    }
}
