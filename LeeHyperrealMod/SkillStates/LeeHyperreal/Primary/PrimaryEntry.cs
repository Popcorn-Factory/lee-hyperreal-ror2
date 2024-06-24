﻿using EntityStates;
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
                        base.outer.SetState(new PrimaryDomainAerialStart { });
                    }

                    base.outer.SetState(new PrimaryAerialStart { });
                    return;
                }

                base.outer.SetState(new Primary1 { });
                return;
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
