using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryDomainAerialStart : BaseRootMotionMoverState
    {
        LeeHyperrealDomainController domainController;
        private bool isDomain;
        private float duration = 0.8f;

        private float ungroundFrac = 0.33f;

        public override void OnEnter()
        {
            base.OnEnter();
            //Play animation for going straight down. There will be a switch to change to domain variant in this state.
            //There are no attacks on this until you hit the ground.
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();

            isDomain = domainController.GetDomainState();

            if (isDomain && base.isAuthority)
            {
                //Lead to new state

            }

            //Continue with straight down attack
            base.PlayAnimation("Body", "Midair Attack Start", "attack.playbackRate", duration);

            Util.PlaySound("Play_c_liRk4_atk_nml_5_xuli", base.gameObject);
            //Automatically leads into Midair Attack Loop

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

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (fixedAge >= duration * ungroundFrac) 
            {
                base.characterMotor.Motor.ForceUnground();
            }
            
            if (fixedAge >= duration && base.isAuthority) 
            {
                //Send to loop state.
                base.outer.SetState(new PrimaryDomainAerialLoop { });
                return;
            }

            if (base.isAuthority && isGrounded) 
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryDomainAerialSlam { });
                return;
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
