using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary;
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
        public static float baseDuration = 2.6f;
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
        OrbController orbController;

        public override void OnEnter()
        {
            base.OnEnter();
            duration = baseDuration / attackSpeedStat;
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            bulletController = gameObject.GetComponent<BulletController>();
            orbController = gameObject.GetComponent<OrbController>();
            animator = GetModelAnimator();
            animator.SetFloat("attack.playbackRate", attackSpeedStat);
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

            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }

            if (NetworkServer.active) 
            {
                characterBody.AddTimedBuff(Modules.Buffs.invincibilityBuff.buffIndex, baseDuration * disableInvincibility);
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

        public override void UpdateMeleeRootMotion(float scale)
        {
            if (rma)
            {
                Vector3 a = rma.ExtractRootMotion();
                if (base.characterMotor)
                {
                    a.x *= Modules.StaticValues.ScaleMoveSpeed(moveSpeedStat);
                    a.z *= Modules.StaticValues.ScaleMoveSpeed(moveSpeedStat);

                    base.characterMotor.rootMotion = a * scale;
                }
            }
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
                if (base.inputBank.skill2.down && Modules.Config.allowSnipeButtonHold.Value && base.isAuthority && base.skillLocator.secondary.skillNameToken == "POPCORN_LEE_HYPERREAL_BODY_ENTER_SNIPE_NAME")
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextState(new EnterSnipe());
                        return;
                    }
                }

                if (base.inputBank.moveVector != new Vector3(0, 0, 0))
                {
                    if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                    {
                        base.outer.SetNextStateToMain();
                        return;
                    }
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }
            if (age >= duration && isAuthority) 
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    base.outer.SetNextStateToMain();
                }
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
