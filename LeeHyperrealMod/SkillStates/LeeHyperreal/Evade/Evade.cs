﻿using UnityEngine.Networking;
using UnityEngine;
using EntityStates;
using RoR2;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.Content.Controllers;
using R2API.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Evade
{
    internal class Evade : BaseRootMotionMoverState
    {
        public static float duration = 2.0f;
        public BulletController bulletController;

        public static string dodgeSoundString = "HenryRoll";
        public static float dodgeFOV = EntityStates.Commando.DodgeState.dodgeFOV;

        private Animator animator;

        private bool isForwardRoll;

        private float earlyExitFrac = 0.32f;
        private float start = 0.3f;
        private float end = 0.65f;
        private Vector3 forwardDirection;
        private Vector3 moveVector;

        private float movementMultiplier = 1.6f;

        private float disableInvincibility = 0.15f;
        public bool unsetSnipe = false;
        private float movementMultiplierPrimary3 = 1.6f;

        public Transform baseTransform;

        public override void OnEnter()
        {
            base.OnEnter();

            bulletController = gameObject.GetComponent<BulletController>();

            if (bulletController && unsetSnipe) 
            {
                bulletController.UnsetSnipeStance();
                if (bulletController.snipeAerialPlatform) 
                {
                    bulletController.snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
                    bulletController.snipeAerialPlatform = null; //unset so it doesn't follow the player.
                }
            }

            animator = GetModelAnimator();
            forwardDirection = GetAimRay().direction;
            Vector3 backwardsDirection = forwardDirection * -1f;
            animator.SetFloat("attack.playbackRate", 1f);
            moveVector = inputBank.moveVector;
            rmaMultiplier = movementMultiplier;
            if (isAuthority)
            {
                characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 1, duration * disableInvincibility);
            }

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            baseTransform = childLocator.FindChild("BaseTransform");

            if (inputBank.moveVector == Vector3.zero)
            {
                EffectManager.SpawnEffect(
                    Modules.ParticleAssets.dodgeBackwards, 
                    new EffectData 
                    { 
                        origin = baseTransform.position,
                        scale = 1.25f,
                        rotation = Quaternion.LookRotation(GetAimRay().direction * -1f)
                    }, 
                    true);
                isForwardRoll = false;
                PlayAnimation();
                return;
            }

            //if (Vector3.Dot(backwardsDirection, inputBank.moveVector) >= 0.833f)
            //{
            //    isForwardRoll = false;
            //    PlayAnimation();
            //    return;
            //}

            EffectManager.SpawnEffect(
                Modules.ParticleAssets.dodgeForwards,
                new EffectData
                {
                    origin = baseTransform.position,
                    scale = 1.25f,
                    rotation = Quaternion.LookRotation(inputBank.moveVector.normalized)
                },
                true);
            isForwardRoll = true;
            PlayAnimation();

            this.characterDirection.forward = base.inputBank.moveVector;
            this.characterDirection.moveVector = base.inputBank.moveVector;
        }


        public override void FixedUpdate()
        {
            base.FixedUpdate();

        }

        public override void Update()
        {
            base.Update();
            float y = characterMotor.velocity.y;
            characterMotor.velocity = Vector3.zero;
            characterMotor.velocity.y = y;
            if (isForwardRoll)
            {
                characterDirection.moveVector = moveVector;
            }
            else
            {
                characterDirection.moveVector = forwardDirection;
            }

            if (age >= duration * start && age <= duration * end)
            {
                if (isAuthority && !isForwardRoll)
                {
                    if (inputBank.skill1.down)
                    {
                        //Go to Primary 3.
                        outer.SetState(new Primary.Primary3 { xzMovementMultiplier = movementMultiplierPrimary3 });
                        return;
                    }
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration * end && isAuthority)
            {
                if (isAuthority && !isForwardRoll)
                {
                    if (inputBank.skill1.down)
                    {
                        //Go to Primary 3.
                        outer.SetState(new Primary.Primary3 { xzMovementMultiplier = movementMultiplierPrimary3 });
                        return;
                    }
                }
            }

            if (age >= duration * earlyExitFrac && isAuthority)
            {
                if (!isForwardRoll)
                {
                    if (inputBank.skill1.down)
                    {
                        //Go to Primary 3.
                        outer.SetState(new Primary.Primary3 { xzMovementMultiplier = movementMultiplierPrimary3 });
                        return;
                    }
                }
                if (inputBank.moveVector != Vector3.zero) 
                {
                    outer.SetNextStateToMain();
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration && isAuthority)
            {
                outer.SetNextStateToMain();
            }
        }

        public override void OnExit()
        {
            base.OnExit();
            base.characterBody.SetAimTimer(0);
            base.PlayAnimation("Body", "BufferEmpty");
        }

        public void PlayAnimation()
        {
            if (isForwardRoll)
            {
                PlayAnimation("Body", "evadeForward", "attack.playbackRate", duration);
                return;
            }
            PlayAnimation("Body", "evadeBack", "attack.playbackRate", duration);
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
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
    }
}
