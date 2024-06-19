using EntityStates;
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

            if (base.isAuthority) 
            {
                if (!characterMotor.isGrounded) 
                {
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
