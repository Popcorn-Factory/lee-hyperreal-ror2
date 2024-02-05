using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using Unity.Audio;
using UnityEngine;
using UnityEngine.UIElements.UIR;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class ExitSnipe : BaseSkillState
    {
        Animator animator;
        LeeHyperrealUIController uiController;
        public float duration = 1.74f;
        public float earlyExitFrac = 0.36f;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;

        public override void OnEnter()
        {
            base.OnEnter();
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            base.characterBody.isSprinting = false;
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);
            PlayAttackAnimation();

            base.characterDirection.forward = base.inputBank.aimDirection;

            base.skillLocator.primary.UnsetSkillOverride(base.skillLocator.primary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.SnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
            base.skillLocator.secondary.UnsetSkillOverride(base.skillLocator.secondary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.ExitSnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 0;
            gravParams.channeledAntiGravityGranterCount = 0;
            base.characterMotor.gravityParameters = gravParams;

            cameraTargetParams.RemoveParamsOverride(uiController.handle);
        }

        public override void OnExit()
        {
            base.OnExit();
            PlayAnimation("FullBody, Override", "BufferEmpty");
        }

        public override void Update()
        {
            base.Update();
            base.characterDirection.forward = base.inputBank.aimDirection;
            if (age >= duration * earlyExitFrac && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
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
