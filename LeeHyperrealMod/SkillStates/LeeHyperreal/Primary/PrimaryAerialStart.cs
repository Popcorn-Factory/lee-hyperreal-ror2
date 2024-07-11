using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
using RoR2;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryAerialStart : BaseRootMotionMoverState
    {
        LeeHyperrealDomainController domainController;
        private float duration = 0.8f;

        public static float heldButtonThreshold = 0.4f;
        public bool ifButtonLifted = false;

        public override void OnEnter()
        {
            base.OnEnter();
            //Play animation for going straight down. There will be a switch to change to domain variant in this state.
            //There are no attacks on this until you hit the ground.
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();

            //Continue with straight down attack
            base.PlayAnimation("Body", "Midair Attack Start", "attack.playbackRate", duration);

            Util.PlaySound("Play_c_liRk4_atk_nml_5_xuli", base.gameObject);
            //Automatically leads into Midair Attack Loop
            characterMotor.velocity.y = 0f;        /*reset current Velocity at start.*/

            if (base.isAuthority) 
            {
                PlaySwing("BaseTransform", 1.25f, Modules.ParticleAssets.primary5Swing);
            }
        }

        public void PlaySwing(string muzzleString, float swingScale, GameObject effectPrefab)
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


        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();

            if (!base.inputBank.skill1.down && base.isAuthority)
            {
                ifButtonLifted = true;
            }
                
            if (!ifButtonLifted && base.isAuthority && base.age >= duration * heldButtonThreshold && domainController.DomainEntryAllowed())
            {
                //Cancel out into Domain shift skill state
                base.outer.SetState(new DomainEnterState { shouldForceUpwards = true });
                return;
            }

            if (base.isAuthority && isGrounded)
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryAerialSlam { });
                return;
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (base.isAuthority && isGrounded)
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryAerialSlam { });
                return;
            } 

            if (fixedAge >= duration && base.isAuthority) 
            {
                //Send to loop state.
                base.outer.SetState(new PrimaryAerialLoop { });
                return;
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
