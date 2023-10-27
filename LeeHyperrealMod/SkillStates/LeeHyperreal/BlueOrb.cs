﻿using EntityStates;
using RoR2;
using LeeHyperrealMod.Content.Controllers;
using System;
using System.Collections.Generic;
using System.Text;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal
{
    internal class BlueOrb : BaseSkillState
    {
        OrbController orbController;
        
        public override void OnEnter()
        {
            base.OnEnter();

            orbController = base.gameObject.GetComponent<OrbController>();
            int strength = orbController.ConsumeOrbs(OrbController.OrbType.BLUE);

            if ( strength >= 0) 
            {
                Chat.AddMessage("Nice!");

                this.outer.SetNextStateToMain();
            }
            else 
            {
                this.outer.SetNextStateToMain();
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
            return InterruptPriority.PrioritySkill;
        }
    }
}
