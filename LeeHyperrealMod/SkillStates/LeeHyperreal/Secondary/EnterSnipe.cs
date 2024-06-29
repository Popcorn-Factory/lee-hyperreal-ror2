using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Survivors;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class EnterSnipe : BaseSkillState
    {
        LeeHyperrealUIController uiController;
        BulletController bulletController;
        Animator animator;
        public float duration = 2.133f;
        public float earlyExitFrac = 0.28f;
        Vector3 velocity;
        GameObject platform;
        public string muzzleString = "BaseTransform";

        public override void OnEnter()
        {
            base.OnEnter();
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            bulletController = gameObject.GetComponent<BulletController>();
            base.characterBody.isSprinting = false;
            base.characterMotor.velocity = new Vector3(0, 0, 0);
            base.characterDirection.moveVector = new Vector3(0, 0, 0);

            //Override the M1 skill with snipe.
            bulletController.SetSnipeStance();

            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);
            PlayAttackAnimation();

            //Set direction
            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);

            base.characterMotor.velocity = Vector3.zero;

            //characterBody.SetAimTimer(duration);
            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            Transform baseTransform = childLocator.FindChild("BaseTransform");
            if (!isGrounded) 
            {
                bulletController.snipeAerialPlatform = UnityEngine.Object.Instantiate(Modules.ParticleAssets.snipeAerialFloor, baseTransform.position, Quaternion.identity);
            }

            Util.PlaySound("Play_c_liRk4_atk_ex_3_xuli", base.gameObject);
            PlaySwingEffect(1.25f, Modules.ParticleAssets.SnipeStart, true);
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

        public void PlayAttackAnimation() 
        {
            PlayAnimation("Body", "SnipeEntry", "attack.playbackRate", duration);
        }

        public override void Update() 
        {
            base.Update();
            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            base.characterDirection.moveVector = Vector3.zero;
            if (age >= duration * earlyExitFrac && base.isAuthority) 
            {
                if (base.inputBank.skill1.down) 
                {
                    base.outer.SetNextState(new Snipe { });
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

                if (base.inputBank.skill4.down && base.isAuthority)
                {
                    Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
                }
            }
            if (age >= duration && base.isAuthority) 
            {
                base.outer.SetNextState(new IdleSnipe { });
                return;
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
