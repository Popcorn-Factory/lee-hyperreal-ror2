using UnityEngine.Networking;
using UnityEngine;
using EntityStates;
using RoR2;
using ExtraSkillSlots;
using LeeHyperrealMod.SkillStates.BaseStates;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal
{
    internal class Evade : BaseRootMotionMoverState
    {
        public static float duration = 1f;

        public static string dodgeSoundString = "HenryRoll";
        public static float dodgeFOV = EntityStates.Commando.DodgeState.dodgeFOV;

        private Animator animator;

        private bool isForwardRoll;

        private float start = 0.3f;
        private float end = 0.8f;
        private Vector3 forwardDirection;
        private ExtraInputBankTest extraInput;
        private ExtraSkillLocator extraSkillLocator;
        private Vector3 moveVector;

        private float movementMultiplier = 1.6f;

        public override void OnEnter()
        {
            base.OnEnter();
            this.animator = base.GetModelAnimator();
            extraSkillLocator = base.gameObject.GetComponent<ExtraSkillLocator>();
            extraInput = base.gameObject.GetComponent<ExtraInputBankTest>();
            forwardDirection = base.GetAimRay().direction;
            Vector3 backwardsDirection = forwardDirection * -1f;
            moveVector = base.inputBank.moveVector;
            rmaMultiplier = movementMultiplier;
            if (base.inputBank.moveVector == Vector3.zero)
            {
                isForwardRoll = false;
                PlayAnimation();
                return;
            }

            if (Vector3.Dot(backwardsDirection, base.inputBank.moveVector) >= 0.833f) 
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

        }

        public override void Update()
        {
            base.Update();
            float y = base.characterMotor.velocity.y;
            base.characterMotor.velocity = Vector3.zero;
            base.characterMotor.velocity.y = y;
            if (isForwardRoll)
            {
                base.characterDirection.moveVector = moveVector;
            }
            else 
            {
                base.characterDirection.moveVector = forwardDirection;
            }

            if (base.fixedAge >= duration * start && base.fixedAge <= duration * end)
            {
                if (base.isAuthority && !isForwardRoll)
                {
                    if (inputBank.skill1.down)
                    {
                        //Go to Primary 3.
                        this.outer.SetState(new Primary.Primary3 { });
                        return;
                    }
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, extraSkillLocator, isAuthority, base.inputBank, extraInput);
            }

            if (base.fixedAge >= duration * end && base.isAuthority) 
            {
                if (base.isAuthority && !isForwardRoll)
                {
                    if (inputBank.skill1.down)
                    {
                        //Go to Primary 3.
                        this.outer.SetState(new Primary.Primary3 { });
                        return;
                    }
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, extraSkillLocator, isAuthority, base.inputBank, extraInput);
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
                base.PlayAnimation("FullBody, Override", "evadeForwardTrimmed", "attack.playbackRate", duration);
                return;
            }
            base.PlayAnimation("FullBody, Override", "evadeBackTrimmed", "attack.playbackRate", duration);
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
