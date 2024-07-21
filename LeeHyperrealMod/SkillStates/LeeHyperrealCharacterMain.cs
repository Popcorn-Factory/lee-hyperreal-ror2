using EntityStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates
{
    internal class LeeHyperrealCharacterMain : GenericCharacterMain
    {
        public override void OnEnter()
        {
            /*
             * You are a worthless bitch ass piece of code, your existance is literally as valuable as a summer ant. 
             * I'm gonna compile you and you're gonna keep making bugs, Imma seal up all my cracks and you'll keep crashing, Why? 
             * Cause you smelling my incompetency, you worthless piece of code. 
             * 
             * You're gonna stay on my dick until you crash. You serve no purpose in life. Your purpose in life is to be on this class 
             * overriding the damn animation every time you transition state. Your purpose is to be in that inheritance chain blowing 
             * the animator until you get what you want. 
             * 
             * Your life is nothing, you serve zero purpose.
             * 
             * You should decompile yourself, NOW.
             * 
             * And give somebody else a piece of that electricity, so that we can run more useful code.
             * 
             * Cause what are you here for? To be useful? Decompile youself. I mean that, with a 100%, with a 1000%.
             */

            useRootMotion = true;
            base.OnEnter();
            if (this.modelAnimator)
            {
                if (this.characterAnimParamAvailability.isSprinting)
                {
                    this.modelAnimator.SetBool(AnimationParameters.isSprinting, base.characterBody.isSprinting);
                }

                Vector3 moveVector = base.inputBank ? base.inputBank.moveVector : Vector3.zero;
                bool movingVal = moveVector != Vector3.zero && base.characterBody.moveSpeed > Mathf.Epsilon;
                if (this.characterAnimParamAvailability.isMoving)
                {
                    this.modelAnimator.SetBool(AnimationParameters.isMoving, movingVal);
                }

                bool isMoving = base.modelAnimator.GetBool(AnimationParameters.isMoving);
                bool isSprinting = base.modelAnimator.GetBool(AnimationParameters.isSprinting);
                bool isGrounded = base.modelAnimator.GetBool(AnimationParameters.isGrounded);

                int layerIndex = this.modelAnimator.GetLayerIndex("Body");

                if (isMoving && !isSprinting && isGrounded) 
                {
                    this.modelAnimator.CrossFadeInFixedTime("Run", 0.1f, layerIndex);
                }
                else if (isMoving && isSprinting && isGrounded)
                {
                    this.modelAnimator.CrossFadeInFixedTime("Sprint", 0.1f, layerIndex);
                }
                else if (!isGrounded)
                {
                    this.modelAnimator.CrossFadeInFixedTime("AscendDescend", 0.1f, layerIndex);
                }
                this.modelAnimator.Update(0f);
            }
        }

        public override void Update()
        {
            base.Update();

            if (this.modelAnimator.GetCurrentAnimatorStateInfo(0).IsName("StopRun"))
            {
                Vector3 moveVector = base.inputBank ? base.inputBank.moveVector : Vector3.zero;
                bool movingVal = moveVector != Vector3.zero && base.characterBody.moveSpeed > Mathf.Epsilon;
                //Don't use root if you're moving.
                this.useRootMotion = !movingVal;
            }
            else 
            {
                this.useRootMotion = ((base.characterBody && base.characterBody.rootMotionInMainState && base.isGrounded) || base.railMotor);
            }

            if (base.inputBank.skill2.down && Modules.Config.allowSnipeButtonHold.Value && base.isAuthority && base.skillLocator.secondary.skillNameToken == "POPCORN_LEE_HYPERREAL_BODY_ENTER_SNIPE_NAME")
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetState(new EnterSnipe());
                }
            }
        }
    }
}
