using EntityStates;
using UnityEngine;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
using RoR2;
using LeeHyperrealMod.Content.Controllers;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class IdleSnipe : BaseSkillState
    {
        Animator animator;
        public float duration = 2.133f;
        Vector3 velocity = Vector3.zero;
        BulletController bulletController;

        public override void OnEnter()
        {
            base.OnEnter();
            base.characterBody.isSprinting = false;
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", 1f);
            bulletController = gameObject.GetComponent<BulletController>();

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            base.characterMotor.velocity = Vector3.zero;

            PlayAttackAnimation();

            //characterBody.SetAimTimer(duration + 1f);
            if (!bulletController.snipeAerialPlatform && !isGrounded) 
            {
                ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
                Transform baseTransform = childLocator.FindChild("BaseTransform");
                bulletController.snipeAerialPlatform = UnityEngine.Object.Instantiate(Modules.ParticleAssets.snipeAerialFloor, baseTransform.position, Quaternion.identity);
            }

            if (!base.inputBank.skill2.down && Modules.Config.allowSnipeButtonHold.Value && base.isAuthority)
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetNextState(new ExitSnipe());
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

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            base.characterDirection.moveVector = new Vector3(0, 0, 0);
            base.characterMotor.velocity = new Vector3(0, 0, 0);

            if (base.isAuthority) 
            {
                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill1.down)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextState(new Snipe { });
                        return;
                    }
                }

                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill3.justPressed && skillLocator.utility.stock >= 1) 
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        skillLocator.utility.stock -= 1;
                        Vector3 result = Modules.StaticValues.CheckDirection(inputBank.moveVector, GetAimRay());
                        if (result == new Vector3(0, 0, 1))
                        {
                            base.outer.SetNextState(new Evade.Evade { unsetSnipe = true });
                            return;
                        }
                        if (result == new Vector3(0, 0, 0))
                        {
                            base.outer.SetNextState(new EvadeBack360 { });
                            return;
                        }
                        if (result == new Vector3(1, 0, 0))
                        {
                            base.outer.SetNextState(new EvadeSide { isLeftRoll = false });
                            return;
                        }
                        if (result == new Vector3(-1, 0, 0))
                        {
                            base.outer.SetNextState(new EvadeSide { isLeftRoll = true });
                            return;
                        }

                        return;
                    }
                }

                if (!base.inputBank.skill2.down && Modules.Config.allowSnipeButtonHold.Value && base.isAuthority)
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextState(new ExitSnipe());
                    }
                }

                if ((base.inputBank.skill2.down || base.inputBank.skill4.down) && base.isAuthority)
                {
                    Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
                }
            }


            if (age >= duration && base.isAuthority)
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetNextState(new IdleSnipe { });
                    return;
                }
            }
        }

        public void PlayAttackAnimation()
        {
            PlayAnimation("Body", "SnipeAim", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
