using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using System;
using System.Collections.Generic;
using System.Text;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryEntry : BaseSkillState
    {
        public override void OnEnter() 
        {
            base.OnEnter();

            //Decide where to start the move:

            LeeHyperrealDomainController domainController = base.gameObject.GetComponent<LeeHyperrealDomainController>();

            if (base.isAuthority)
            {
                if (!characterMotor.isGrounded)
                {
                    if (domainController && domainController.GetDomainState())
                    {
                        if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                        {
                            base.outer.SetNextState(new PrimaryDomainAerialStart { });
                            return;
                        }
                    }
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextState(new PrimaryAerialStart { });
                        return;
                    }
                }

                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetNextState(new Primary1 { });
                    return;
                }
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void OnExit()
        {
            base.OnExit();
        }
    }
}
