using EntityStates;
using LeeHyperrealMod.Modules.Survivors;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
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
            base.characterBody.isSprinting = false;
            base.characterMotor.velocity = new Vector3(0, 0, 0);
            base.characterDirection.moveVector = new Vector3(0, 0, 0);
            
            
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);
            PlayAttackAnimation();

            base.characterDirection.forward = base.inputBank.aimDirection;
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
            Chat.AddMessage($"{base.characterDirection.forward}");
            base.characterDirection.forward = base.inputBank.aimDirection;
            if (age >= duration * earlyExitFrac && base.isAuthority) 
            {
                if (base.inputBank.skill1.down) 
                {
                    base.outer.SetNextState(new Snipe { });
                    return;
                }
                if (base.inputBank.skill2.down)
                {
                    //Exit snipe
                    base.outer.SetState(new ExitSnipe { });
                    return;
                }

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
