using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift
{
    internal class DomainEnterState : BaseRootMotionMoverState
    {
        private LeeHyperrealDomainController domainController;
        private Vector3 aoePos;
        private float duration = 4.06f;
        private BlastAttack blastAttack;
        private float triggerBlastFrac = 0.16f;
        private bool hasFired;
        private float moveMagnitude = 10f;
        private float moveCancelFrac = 0.37f;
        private bool startedGrounded = false;

        private float groundedMovementFrac = 0.2f;
        private float groundedMovementMagnitude = 5f;
        private Vector3 groundedMovementDir;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.22f;

        public bool shouldForceUpwards;

        /*
        Domain shift
        Sets isDomain in domain controller
        Move player back slightly
        Play effect? 
            Effect should be handled in controller I guess lel
        Do shooting thing where you jumped from.
        AOE where you started the move
         */
        public override void OnEnter()
        {
            base.OnEnter();
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            aoePos = this.gameObject.transform.position;


            blastAttack = new BlastAttack
            {
                attacker = base.gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = aoePos,
                radius = Modules.StaticValues.domainShiftBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = this.damageStat * Modules.StaticValues.domainShiftCoefficient,
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = this.RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = 1f,
            };

            startedGrounded = isGrounded;

            groundedMovementDir = base.characterDirection.forward * -1f;


            //base.characterMotor.velocity = base.characterDirection.forward * -1f * moveMagnitude;
            PlayAnimation();

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;

            if (shouldForceUpwards) 
            {
                // Move 5 units back, 3 units up
                Vector3 newPosition = new Vector3(0,0,0);
                Vector3 direction = (base.characterDirection.forward * -1f) + (Vector3.up * 0.6f);
                float magnitude = Modules.StaticValues.forceUpwardsMagnitude;
                direction = direction.normalized;

                newPosition = base.gameObject.transform.position + (direction * magnitude);

                base.characterMotor.Motor.MoveCharacter(newPosition);
            }
        }

        public void PlayAnimation() 
        {
            base.PlayCrossfade("Body", "EnterDomainSnipe", "attack.playbackRate", duration, 0.03f);
        }

        public override void OnExit()
        {
            base.OnExit();

            base.characterMotor.gravityParameters = oldGravParams;
            base.PlayAnimation("Body", "BufferEmpty");
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void Update()
        {
            base.Update();

            if (base.age >= duration * turnOffGravityFrac)
            {
                base.characterMotor.gravityParameters = oldGravParams;
            }

            if (base.age >= duration * moveCancelFrac && base.isAuthority) 
            {
                if (inputBank.moveVector != Vector3.zero) 
                {
                    base.outer.SetNextStateToMain();
                    return;
                }
            }

            if (base.age >= duration * triggerBlastFrac && base.isAuthority) 
            {
                if (!hasFired) 
                {
                    hasFired = true;
                    blastAttack.Fire();
                    domainController.EnableDomain();
                }

            }

            if (base.age >= duration * 0.41f && base.isAuthority) 
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }

            if (base.age >= duration && base.isAuthority) 
            {
                base.outer.SetNextStateToMain();
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            // Lock player into animation for a sizeable section of the skill
            if (base.age >= duration * 0.41f)
            {
                return InterruptPriority.Death;
            }
            else 
            {
                return InterruptPriority.Skill;
            }
            
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(shouldForceUpwards);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            this.shouldForceUpwards = reader.ReadBoolean();
        }
    }
}
