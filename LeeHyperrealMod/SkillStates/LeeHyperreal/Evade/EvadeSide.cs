﻿using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UIElements.UIR;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Evade
{
    internal class EvadeSide : BaseRootMotionMoverState
    {
        public static float duration = 2.6f;

        public static string dodgeSoundString = "HenryRoll";
        public static float dodgeFOV = EntityStates.Commando.DodgeState.dodgeFOV;

        private Animator animator;

        public bool isLeftRoll;

        private float earlyExitFrac = 0.32f;

        private float movementMultiplier = 1.6f;

        private float disableInvincibility = 0.15f;

        CharacterGravityParameters gravParams;
        private float disableGrav = 0.3f;

        LeeHyperrealUIController uiController;

        public override void OnEnter()
        {
            base.OnEnter();
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            animator = GetModelAnimator();
            animator.SetFloat("attack.playbackRate", 1f);
            rmaMultiplier = movementMultiplier;
            base.characterBody.isSprinting = false;
            //Unset from IdleSnipe.
            base.skillLocator.primary.UnsetSkillOverride(base.skillLocator.primary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.SnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
            base.skillLocator.secondary.UnsetSkillOverride(base.skillLocator.secondary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.ExitSnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);

            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;
            base.characterMotor.gravityParameters = gravParams;

            //Receive the var from the previous state, run animation.

            if (isAuthority)
            {
                characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 1, duration * disableInvincibility);
            }
            Ray aimRay = base.GetAimRay();
            base.characterDirection.forward = aimRay.direction;
            PlayDodgeAnimation();


            cameraTargetParams.RemoveParamsOverride(uiController.handle);
        }

        public override void OnExit()
        {
            base.OnExit();
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 0;
            gravParams.channeledAntiGravityGranterCount = 0;
            base.characterMotor.gravityParameters = gravParams;
        }

        public override void Update()
        {
            base.Update();
            if (age >= duration * disableGrav && isAuthority) 
            {
                gravParams = new CharacterGravityParameters();
                gravParams.environmentalAntiGravityGranterCount = 0;
                gravParams.channeledAntiGravityGranterCount = 0;
                base.characterMotor.gravityParameters = gravParams;
            }

            if (age >= duration * earlyExitFrac && isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }
            if (age >= duration && isAuthority) 
            {
                base.outer.SetNextStateToMain();
            }
        }

        public void PlayDodgeAnimation() 
        {
            if (isLeftRoll) 
            {
                PlayAnimation("FullBody, Override", "SnipeEvadeLeft", "attack.playbackRate", duration);
                return;
            }

            PlayAnimation("FullBody, Override", "SnipeEvadeRight", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            if (age >= duration * earlyExitFrac)
            {
                return InterruptPriority.Skill;
            }
            else
            {
                return InterruptPriority.Frozen;
            }
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(isLeftRoll);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            isLeftRoll = reader.ReadBoolean();
        }
    }
}