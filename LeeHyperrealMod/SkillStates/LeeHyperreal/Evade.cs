using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.Networking;
using UnityEngine;
using EntityStates;
using RoR2;
using System.Security.Cryptography;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal
{
    internal class Evade : BaseSkillState
    {
        public static float duration = 0.5f;

        public static string dodgeSoundString = "HenryRoll";
        public static float dodgeFOV = EntityStates.Commando.DodgeState.dodgeFOV;

        private Animator animator;

        private RootMotionAccumulator rma;
        private bool isForwardRoll;

        private float start = 0.3f;
        private float end = 0.6f;


        public override void OnEnter()
        {
            base.OnEnter();
            this.animator = base.GetModelAnimator();
            InitMeleeRootMotion();

            Vector3 forwardDirection = base.GetAimRay().direction;
            Vector3 backwardsDirection = forwardDirection * -1f;

            if (base.characterDirection.moveVector == Vector3.zero)
            {
                isForwardRoll = true;
                PlayAnimation();
                return;
            }

            if (Vector3.Dot(backwardsDirection, base.GetAimRay().direction) <= -0.833f) 
            {
                isForwardRoll = false;
                PlayAnimation();
                return;
            }

            isForwardRoll = true;
            PlayAnimation();
        }


        public override void FixedUpdate()
        {
            base.FixedUpdate();
            UpdateMeleeRootMotion(3f);

            if (base.fixedAge >= duration * start && base.fixedAge <= duration * end) 
            {
                
            }

            if (base.fixedAge >= duration && base.isAuthority) 
            {
                base.outer.SetNextStateToMain();
            }
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public void PlayAnimation() 
        {
            if (isForwardRoll) 
            {
                base.PlayAnimation("FullBody, Override", "evadeForward", "attack.playbackRate", duration);
                return;
            }
            base.PlayAnimation("FullBody, Override", "evadeBack", "attack.playbackRate", duration);
        }

        public RootMotionAccumulator InitMeleeRootMotion()
        {
            rma = base.GetModelRootMotionAccumulator();
            if (rma)
            {
                rma.ExtractRootMotion();
            }
            if (base.characterDirection)
            {
                base.characterDirection.forward = base.inputBank.aimDirection;
            }
            if (base.characterMotor)
            {
                base.characterMotor.moveDirection = Vector3.zero;
            }
            return rma;
        }

        // Token: 0x060003CA RID: 970 RVA: 0x0000F924 File Offset: 0x0000DB24
        public void UpdateMeleeRootMotion(float scale)
        {
            if (rma)
            {
                Vector3 a = rma.ExtractRootMotion();
                if (base.characterMotor)
                {
                    base.characterMotor.rootMotion = a * scale;
                }
            }
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
            if (base.age >= duration * end)
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
