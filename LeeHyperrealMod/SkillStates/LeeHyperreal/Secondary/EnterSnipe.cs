using EntityStates;
using LeeHyperrealMod.Modules.Survivors;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class EnterSnipe : BaseSkillState
    {
        Animator animator;
        public float duration = 2.133f;
        public float earlyExitFrac = 0.28f;
        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;

        public override void OnEnter()
        {
            base.OnEnter();
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);
            PlayAttackAnimation();
            base.characterBody.SetAimTimer(2f);

            Ray aimRay = base.GetAimRay();
            base.characterDirection.forward = aimRay.direction;
            //Override the M1 skill with snipe.

            base.skillLocator.primary.SetSkillOverride(base.skillLocator.primary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.SnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
            base.skillLocator.secondary.SetSkillOverride(base.skillLocator.secondary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.ExitSnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            base.characterMotor.gravityParameters = gravParams;
            base.characterMotor.velocity = new Vector3();
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public void PlayAttackAnimation() 
        {
            PlayAnimation("FullBody, Override", "SnipeEntry", "attack.playbackRate", duration);
        }

        public override void Update() 
        {
            base.Update();

            Ray aimRay = base.GetAimRay();
            base.characterDirection.forward = aimRay.direction;
            if (age >= duration * earlyExitFrac && base.isAuthority) 
            {
                if (base.inputBank.skill1.down) 
                {
                    base.outer.SetNextState(new Snipe { });
                    return;
                }
            }
            if (age >= duration && base.isAuthority) 
            {
                base.outer.SetNextState(new IdleSnipe { });
                return;
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
