using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

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

            base.characterMotor.velocity = base.characterDirection.forward * -1f * moveMagnitude;
            PlayAnimation();
        }

        public void PlayAnimation() 
        {
            base.PlayCrossfade("Body", "EnterDomainSnipe", "attack.playbackRate", duration, 0.03f);
        }

        public override void OnExit()
        {
            base.OnExit();

            base.PlayAnimation("Body", "BufferEmpty");
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void Update()
        {
            base.Update();

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
    }
}
