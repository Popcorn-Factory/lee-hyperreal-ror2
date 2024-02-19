using EntityStates;
using UnityEngine;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
using RoR2;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class IdleSnipe : BaseSkillState
    {
        Animator animator;
        public float duration = 2.133f;
        Vector3 velocity = Vector3.zero;

        public override void OnEnter()
        {
            base.OnEnter();
            base.characterBody.isSprinting = false;
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", 1f);

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            PlayAttackAnimation();
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
                    Vector3 result = Modules.StaticValues.CheckDirection(inputBank.moveVector, GetAimRay());
                    if (result == new Vector3(0, 0, 1))
                    {
                        base.outer.SetState(new Evade.Evade { unsetSnipe = true });
                        return;
                    }
                    if (result == new Vector3(0, 0, 0))
                    {
                        base.outer.SetState(new EvadeBack180 { });
                        return;
                    }
                    if (result == new Vector3(1, 0, 0)) 
                    {
                        base.outer.SetState(new EvadeSide { isLeftRoll = false });
                        return;
                    }
                    if (result == new Vector3(-1, 0, 0))
                    {
                        base.outer.SetState(new EvadeSide { isLeftRoll = true });
                        return;
                    }

                    return;
                }
            }


            if (age >= duration && base.isAuthority) 
            {
                base.outer.SetState(new IdleSnipe { });
                return;
            }
        }

        public void PlayAttackAnimation()
        {
            PlayAnimation("Body", "SnipeAim", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
