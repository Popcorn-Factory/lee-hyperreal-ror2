using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrbEntry : BaseSkillState
    {
        OrbController orbController;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();
            int moveStrength = orbController.ConsumeOrbs(OrbController.OrbType.YELLOW);

            if (base.isAuthority) 
            {
                if (moveStrength > 0)
                {
                    this.outer.SetState(new YellowOrb { moveStrength = moveStrength });
                    return;
                }
                else
                {
                    base.PlayAnimation("FullBody, Override", "BufferEmpty");
                    this.outer.SetNextStateToMain();
                    return;
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
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
