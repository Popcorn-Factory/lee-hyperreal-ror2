using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryAerialLoop : BaseSkillState
    {
        public Vector3 velocity;
        public override void OnEnter()
        {
            base.OnEnter();
            //Do nothing until you hit the ground.
            
        }


        public override void OnExit()
        {
            base.OnExit();
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Increase y vel until grounded
            base.characterMotor.velocity = Vector3.SmoothDamp(base.characterMotor.velocity, (Vector3.down * 60f), ref velocity, 0.4f);

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
