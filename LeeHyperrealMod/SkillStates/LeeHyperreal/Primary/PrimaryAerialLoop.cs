using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
using R2API.Networking;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryAerialLoop : BaseSkillState
    {
        public Vector3 velocity;
        public LeeHyperrealDomainController domainController;

        public float heldStopwatch;
        public static float heldLengthToTrigger = 0.5f;

        public override void OnEnter()
        {
            base.OnEnter();
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();
            //Do nothing until you hit the ground.
            if (base.isAuthority && isGrounded)
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryAerialSlam { airTime = fixedAge });
                return;
            }

            if (base.isAuthority)
            {
                base.characterBody.ApplyBuff(Modules.Buffs.fallDamageNegateBuff.buffIndex, 1);
            }

            base.characterMotor.velocity = Vector3.SmoothDamp(base.characterMotor.velocity, ((Vector3.down).normalized * Modules.StaticValues.primaryAerialSlamSpeed), ref velocity, 0.1f);
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
                heldStopwatch = 0f;
            }

            if (base.inputBank.skill1.down && base.isAuthority)
            {
                heldStopwatch = Time.deltaTime;
            }

            if (base.isAuthority && heldStopwatch >= heldLengthToTrigger && domainController.DomainEntryAllowed())
            {
                //Cancel out into Domain shift skill state
                base.outer.SetState(new DomainEnterState { shouldForceUpwards = true });
                return;
            }

            if (base.isAuthority && isGrounded)
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryAerialSlam { airTime = fixedAge });
                return;
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Increase y vel until grounded
            base.characterMotor.velocity = Vector3.SmoothDamp(base.characterMotor.velocity, ((Vector3.down).normalized * Modules.StaticValues.primaryAerialSlamSpeed), ref velocity, 0.1f);


            //Only transition on grounded.
            if (base.isAuthority && isGrounded) 
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryAerialSlam { airTime = fixedAge });
                return;
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
