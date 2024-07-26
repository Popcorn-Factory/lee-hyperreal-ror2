using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryDomainAerialStart : BaseRootMotionMoverState
    {
        LeeHyperrealDomainController domainController;
        private bool isDomain;
        private float duration = 0.8f;

        private float ungroundFrac = 0.33f;

        private Vector3 velocity;

        public override void OnEnter()
        {
            base.OnEnter();
            //Play animation for going straight down. There will be a switch to change to domain variant in this state.
            //There are no attacks on this until you hit the ground.
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();

            domainController.EnableLoopEffect();

            isDomain = domainController.GetDomainState();

            if (isDomain && base.isAuthority)
            {
                //Lead to new state

            }

            if (NetworkServer.active)
            {
                base.characterBody.ApplyBuff(Modules.Buffs.fallDamageNegateBuff.buffIndex, 1);
            }

            //Continue with straight down attack
            base.PlayAnimation("Body", "DomainMidairStart", "attack.playbackRate", duration);

            Util.PlaySound("Play_c_liRk4_atk_nml_5_xuli", base.gameObject);
            //Automatically leads into Midair Attack Loop


            base.characterMotor.velocity = Vector3.SmoothDamp(base.characterMotor.velocity, ((Vector3.down + base.characterDirection.forward).normalized * Modules.StaticValues.primaryAerialSlamSpeed), ref velocity, 0.1f);

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

            base.characterMotor.velocity = Vector3.SmoothDamp(base.characterMotor.velocity, ((Vector3.down + base.characterDirection.forward).normalized * Modules.StaticValues.primaryAerialSlamSpeed), ref velocity, 0.1f);
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            if (fixedAge >= duration && base.isAuthority)
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    //Send to loop state.
                    base.outer.SetState(new PrimaryDomainAerialLoop { initialAirTime = fixedAge});
                    return;
                }
            }

            if (base.isAuthority && isGrounded)
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    //Send instantly to end state
                    base.outer.SetState(new PrimaryDomainAerialSlam { airTime = fixedAge });
                    return;
                }
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
