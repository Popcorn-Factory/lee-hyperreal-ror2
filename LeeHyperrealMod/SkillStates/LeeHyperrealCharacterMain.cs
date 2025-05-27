using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Animations;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates
{
    internal class LeeHyperrealCharacterMain : GenericCharacterMain
    {
        LeeHyperrealDomainController domainController;
        Transform baseTransform;
        int baseTransformIndex;

        public bool forceJump;

        public GameObject superSprintVFX;
        public Transform leftFoot;
        public Transform rightFoot;
        public Transform leftFootReal;
        public Transform rightFootReal;
        public ParentConstraint leftFootConstraint;
        public ParentConstraint rightFootConstraint;

        public bool inSuperSprint;

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
            domainController = base.gameObject.GetComponent<LeeHyperrealDomainController>();
            BulletController bulletController = base.gameObject.GetComponent<BulletController>();
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


                //Fuck you stupid piece of shit goddamn it ASOIDJaegioanlwejirdvnfasdhu
                //Decompile yourself NOW.
                if (domainController) 
                {
                    if (domainController.JustEnded) 
                    {
                        domainController.JustEnded = false;
                        if (base.isGrounded || !this.hasCharacterMotor)
                        {
                            this.modelAnimator.CrossFadeInFixedTime("IdleEmptyHand", 0.1f, layerIndex);
                        }
                    }
                }

                this.modelAnimator.Update(0f);
            }


            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            baseTransform = childLocator.FindChild("BaseTransform");
            leftFoot = childLocator.FindChild("FootL");
            rightFoot = childLocator.FindChild("FootR");
            leftFootReal = childLocator.FindChild("FootLReal");
            rightFootReal = childLocator.FindChild("FootRReal");
            baseTransformIndex = childLocator.FindChildIndex("BaseTransform");

            if (bulletController.inSnipeStance) 
            {
                //Override the M1 skill with snipe.
                bulletController.UnsetSnipeStance();
            }

            if (forceJump) 
            {
                forceJump = false;
                base.jumpInputReceived = true;
            }
        }

        public override void ProcessJump()
        {
            int beforeJumpCount = base.characterMotor.jumpCount;
            base.ProcessJump();
            int afterJumpCount = base.characterMotor.jumpCount;
            if (beforeJumpCount < afterJumpCount && base.characterMotor.jumpCount != 1)
            {
                EffectData data = new EffectData
                {
                    origin = baseTransform.position,
                    scale = 1f,
                    rotation = baseTransform.rotation,
                };

                data.SetChildLocatorTransformReference(gameObject, baseTransformIndex);
                EffectManager.SpawnEffect(Modules.ParticleAssets.RetrieveParticleEffectFromSkin("jumpEffect", characterBody), data, true);
            }
        }

        public override void Update()
        {
            base.Update();

            if (this.modelAnimator.GetCurrentAnimatorStateInfo(0).IsName("StopRun") ||
                this.modelAnimator.GetCurrentAnimatorStateInfo(0).IsName("Super Sprint Outro"))
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

            this.modelAnimator.SetBool("IsSuperSprinting", this.characterBody.moveSpeed > Modules.StaticValues.requiredMoveSpeedToSupersprint && this.characterBody.isSprinting);

            //Super Sprint vfx
            if (this.modelAnimator.GetCurrentAnimatorStateInfo(0).IsName("Super Sprint Intro") || this.modelAnimator.GetCurrentAnimatorStateInfo(0).IsName("Super Sprint Loop"))
            {
                if (!superSprintVFX && !inSuperSprint)
                {
                    OnSuperSprintEnter();
                }
            }
            else 
            {
                if (superSprintVFX && inSuperSprint) 
                {
                    OnSuperSprintExit();
                }
            }

            if (base.inputBank.skill2.down && Modules.Config.allowSnipeButtonHold.Value && base.isAuthority && base.skillLocator.secondary.skillNameToken == "POPCORN_LEE_HYPERREAL_BODY_ENTER_SNIPE_NAME")
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetNextState(new EnterSnipe());
                }
            }
        }

        public void OnSuperSprintEnter() 
        {
            inSuperSprint = true;
            if (!superSprintVFX) 
            {
                SetupSuperSprintVFX(true);
            }

        }

        public void OnSuperSprintExit()
        {
            inSuperSprint = false;
            if (superSprintVFX) 
            {
                superSprintVFX.GetComponent<DestroySprintOnDelay>().StartDestroying();
                Util.PlaySound("Stop_Super_Sprint", this.superSprintVFX);
                superSprintVFX = null;
            }

            if (this.modelAnimator.GetCurrentAnimatorStateInfo(0).IsName("Super Sprint Outro"))
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_Super_Sprint_End_Slide").Send(R2API.Networking.NetworkDestination.Clients);
            }

        }


        public void SetupSuperSprintVFX(bool setActive = false) 
        {
            if (!superSprintVFX) 
            {
                superSprintVFX = GameObject.Instantiate(Modules.ParticleAssets.RetrieveParticleEffectFromSkin("superSprint", this.characterBody), baseTransform);
                //LMAO ABSOLUTE VOMIT 
                superSprintVFX.SetActive(setActive);
                rightFootConstraint = superSprintVFX.transform.GetChild(3).gameObject.GetComponent<ParentConstraint>();
                leftFootConstraint = superSprintVFX.transform.GetChild(2).gameObject.GetComponent<ParentConstraint>();
                rightFootConstraint.SetSource(0, new ConstraintSource { sourceTransform = rightFootReal, weight = 1 });
                leftFootConstraint.SetSource(0, new ConstraintSource { sourceTransform = leftFootReal, weight = 1 });

                Util.PlaySound("Play_Super_Sprint", this.superSprintVFX);
            }
        }

        public override void OnExit()
        {
            base.OnExit();
            if (superSprintVFX) 
            {
                superSprintVFX.GetComponent<DestroySprintOnDelay>().StartDestroying();
            }
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(forceJump);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            forceJump = reader.ReadBoolean();
        }
    }
}
