using EntityStates;
using RoR2;
using LeeHyperrealMod.Modules;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class IdleSnipe : BaseSkillState
    {
        Animator animator;
        public float duration = 2.133f;

        public override void OnEnter()
        {
            base.OnEnter();
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", 1f);

            PlayAttackAnimation();
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();

            if (base.isAuthority) 
            {
                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill1.down)
                {
                    base.outer.SetState(new Snipe { });
                    return;
                }

                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill2.down)
                {
                    base.outer.SetState(new ExitSnipe { });
                    return;
                }

                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill3.down) 
                {
                    base.outer.SetState(new Evade { snipeDodge = true });
                    return;
                }

                //Should allow other skills to run. since M1 should be overriden with snipe and M2 should be exit snipe.
                BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }


            if (age >= duration && base.isAuthority) 
            {
                base.outer.SetState(new IdleSnipe { });
                return;
            }
        }

        public void PlayAttackAnimation()
        {
            PlayAnimation("FullBody, Override", "SnipeAim", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
