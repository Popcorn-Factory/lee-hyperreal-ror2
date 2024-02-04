﻿using EntityStates;
using UnityEngine;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
using RoR2;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class IdleSnipe : BaseSkillState
    {
        Animator animator;
        public float duration = 2.133f;

        public override void OnEnter()
        {
            base.OnEnter();
            base.characterBody.isSprinting = false;
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", 1f);

            base.characterDirection.forward = base.inputBank.aimDirection;
            PlayAttackAnimation();
        }

        public override void OnExit()
        {
            base.OnExit();
        }


        public override void Update()
        {
            base.Update();
            base.characterDirection.forward = base.inputBank.aimDirection;
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
            PlayAnimation("FullBody, Override", "SnipeAim", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.PrioritySkill;
        }
    }
}
