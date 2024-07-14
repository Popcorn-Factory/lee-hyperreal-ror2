using EntityStates;
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

        private float changeWeaponFrac = 0.65f;
        private bool hasChangedWeapon = false;

        CharacterGravityParameters gravParams;
        private float disableGrav = 0.3f;

        WeaponModelHandler weaponModelHandler; 
        LeeHyperrealUIController uiController;
        BulletController bulletController;

        public override void OnEnter()
        {
            base.OnEnter();
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            bulletController = gameObject.GetComponent<BulletController>();
            animator = GetModelAnimator();
            animator.SetFloat("attack.playbackRate", 1f);
            rmaMultiplier = movementMultiplier;
            base.characterBody.isSprinting = false;
            weaponModelHandler = base.gameObject.GetComponent<WeaponModelHandler>();
            //Unset from IdleSnipe.
            bulletController.UnsetSnipeStance(false);

            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;
            base.characterMotor.gravityParameters = gravParams;

            //Receive the var from the previous state, run animation.

            if (NetworkServer.active) 
            {
                characterBody.AddTimedBuff(Modules.Buffs.invincibilityBuff.buffIndex, duration * disableInvincibility);
            }

            if (isAuthority)
            {
                EffectManager.SpawnEffect(Modules.ParticleAssets.snipeDodge,
                    new EffectData
                    {
                        origin = this.gameObject.transform.position,
                        scale = 1.25f
                    },
                    true);
            }
            Ray aimRay = base.GetAimRay();
            base.characterDirection.forward = aimRay.direction;

            if (bulletController.snipeAerialPlatform)
            {
                bulletController.snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
                bulletController.snipeAerialPlatform = null;
            }

            PlayDodgeAnimation();

        }

        public override void OnExit()
        {
            base.OnExit();
            weaponModelHandler.SetLaserState(false);
            if (!hasChangedWeapon)
            {
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
            }
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
            if (age >= duration * changeWeaponFrac && !hasChangedWeapon)
            {
                weaponModelHandler.SetLaserState(false);
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
                hasChangedWeapon = true;
            }
            if (age >= duration * earlyExitFrac && isAuthority)
            {
                if (base.inputBank.moveVector != new Vector3(0, 0, 0))
                {
                    base.outer.SetNextStateToMain();
                    return;
                }
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
                PlayAnimation("Body", "SnipeEvadeLeft", "attack.playbackRate", duration);
                return;
            }

            PlayAnimation("Body", "SnipeEvadeRight", "attack.playbackRate", duration);
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
