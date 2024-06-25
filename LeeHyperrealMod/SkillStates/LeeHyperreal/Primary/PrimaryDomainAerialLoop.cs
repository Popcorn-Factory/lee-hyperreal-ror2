using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryDomainAerialLoop : BaseSkillState
    {
        public Vector3 velocity;
        public override void OnEnter()
        {
            base.OnEnter();
            //Do nothing until you hit the ground.
            if (base.isAuthority && isGrounded)
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryDomainAerialSlam { airTime = fixedAge });
                return;
            }

            if (base.isAuthority) 
            {
                base.characterBody.ApplyBuff(Modules.Buffs.fallDamageNegateBuff.buffIndex, 1);
            }

            base.characterMotor.velocity = Vector3.SmoothDamp(base.characterMotor.velocity, ((Vector3.down + base.characterDirection.forward).normalized * Modules.StaticValues.primaryAerialSlamSpeed), ref velocity, 0.02f);
        }


        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();
            if (base.isAuthority && isGrounded)
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryDomainAerialSlam { airTime = fixedAge });
                return;
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Increase y vel until grounded
            base.characterMotor.velocity = Vector3.SmoothDamp(base.characterMotor.velocity, ((Vector3.down + base.characterDirection.forward).normalized * Modules.StaticValues.primaryAerialSlamSpeed), ref velocity, 0.02f);

            //Only transition on grounded.
            if (base.isAuthority && isGrounded) 
            {
                //Send instantly to end state
                base.outer.SetState(new PrimaryDomainAerialSlam { airTime = fixedAge });
                return;
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
