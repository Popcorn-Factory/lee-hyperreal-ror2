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
        public float baseDuration = 1.74f;
        public float duration;
        public float earlyExitFrac = 0.15f;

        Vector3 velocity;

        public override void OnEnter()
        {
            base.OnEnter();
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            bulletController = gameObject.GetComponent<BulletController>();

            duration = baseDuration / base.attackSpeedStat;

            base.characterBody.isSprinting = false;
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);
            PlayAttackAnimation();

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);

            //Override the M1 skill with snipe.
            bulletController.UnsetSnipeStance();


            //characterBody.SetAimTimer(0f);

            //Destroy platform in exit
            if (bulletController.snipeAerialPlatform) 
            {
                bulletController.snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
            }
        }

        public override void OnExit()
        {
            base.OnExit();
            PlayAnimation("Body", "BufferEmpty");
        }

        public override void Update()
        {
            base.Update();
            if ((base.inputBank.skill3.justPressed || base.inputBank.skill4.justPressed) && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            if (age >= duration * earlyExitFrac && base.isAuthority)
            {
                if (base.inputBank.jump.down)
                {
                    base.outer.SetNextState(new LeeHyperrealCharacterMain { forceJump = true });
                    return;
                }

                if (base.inputBank.sprint.justPressed && characterBody.hasAuthority)
                {
                    base.outer.SetNextStateToMain();
                    return;
                }

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
            return InterruptPriority.Skill;
        }
    }
}
