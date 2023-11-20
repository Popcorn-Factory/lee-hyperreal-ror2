using EntityStates;
using LeeHyperrealMod.Modules;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates
{
    public class Freeze : BaseSkillState
    {
        Animator animator;
        private float duration = StaticValues.ultimateDomainDuration;

        public override void OnEnter()
        {
            base.OnEnter();

            animator = base.GetModelAnimator();
            if (animator)
            {
                animator.enabled= false;
            }
            attackSpeedStat = 0f;

            if (base.characterDirection)
            {
                base.characterDirection.moveVector = base.characterDirection.forward;
            }
            if (base.characterMotor)
            {
                base.characterMotor.velocity = Vector3.zero;
                base.characterMotor.rootMotion = Vector3.zero;
            }
            else if (!base.characterMotor)
            {
                RigidbodyMotor rigidBodyMotor = base.gameObject.GetComponent<RigidbodyMotor>();
                rigidBodyMotor.moveVector = Vector3.zero;
                rigidBodyMotor.rootMotion = Vector3.zero;

                base.rigidbody.velocity = Vector3.zero;

            }


        }
        public override void OnExit()
        {
            base.OnExit();
            if (animator)
            {
                animator.enabled = true;
            }
            attackSpeedStat = 1f;
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            attackSpeedStat = 0f;


            if (base.characterDirection)
            {
                base.characterDirection.moveVector = base.characterDirection.forward;
            }
            if (base.characterMotor)
            {
                base.characterMotor.velocity = Vector3.zero;
                base.characterMotor.rootMotion = Vector3.zero;
            }
            else if (!base.characterMotor)
            {
                RigidbodyMotor rigidBodyMotor = base.gameObject.GetComponent<RigidbodyMotor>();
                rigidBodyMotor.moveVector = Vector3.zero;
                rigidBodyMotor.rootMotion = Vector3.zero;

                base.rigidbody.velocity = Vector3.zero;

            }

            if (base.fixedAge > duration)
            {
                this.outer.SetNextStateToMain();
                return;
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Death;
        }

    }
}