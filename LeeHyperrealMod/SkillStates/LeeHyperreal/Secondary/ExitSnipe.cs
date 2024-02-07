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
        BulletController bulletController;
        public float duration = 1.74f;
        public float earlyExitFrac = 0.36f;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;

        public override void OnEnter()
        {
            base.OnEnter();
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            bulletController = gameObject.GetComponent<BulletController>();
            base.characterBody.isSprinting = false;
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);
            PlayAttackAnimation();

            base.characterDirection.forward = base.inputBank.aimDirection;

            //Override the M1 skill with snipe.
            bulletController.UnsetSnipeStance();

            //Disable grav for a bit
            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 0;
            gravParams.channeledAntiGravityGranterCount = 0;
            base.characterMotor.gravityParameters = gravParams;

        }

        public override void OnExit()
        {
            base.OnExit();
            PlayAnimation("Body", "BufferEmpty");
        }

        public override void Update()
        {
            base.Update();
            base.characterDirection.forward = base.inputBank.aimDirection;
            if (age >= duration * earlyExitFrac && base.isAuthority)
            {
                if (base.inputBank.moveVector != Vector3.zero) 
                {
                    base.outer.SetNextStateToMain();
                }
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
            PlayAnimation("Body", "SnipeExit", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
