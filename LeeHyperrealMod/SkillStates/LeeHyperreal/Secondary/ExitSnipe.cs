using EntityStates;
using LeeHyperrealMod.Modules;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class ExitSnipe : BaseSkillState
    {
        Animator animator;
        public float duration = 1.74f;
        public float earlyExitFrac = 0.36f;

        public override void OnEnter()
        {
            base.OnEnter();
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);
            PlayAttackAnimation();

            base.skillLocator.primary.UnsetSkillOverride(base.skillLocator.primary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.SnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
            base.skillLocator.secondary.UnsetSkillOverride(base.skillLocator.secondary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.ExitSnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
        }

        public override void OnExit()
        {
            base.OnExit();
            PlayAnimation("FullBody, Override", "BufferEmpty");
        }

        public override void Update()
        {
            base.Update();
            if (age >= duration * earlyExitFrac && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
                return;
            }
            if (age >= duration && base.isAuthority)
            {
                base.outer.SetNextStateToMain();
                return;
            }
        }

        public void PlayAttackAnimation()
        {
            PlayAnimation("FullBody, Override", "SnipeExit", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
