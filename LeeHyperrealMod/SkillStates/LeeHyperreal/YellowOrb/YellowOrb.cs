using EntityStates;
using RoR2;
using LeeHyperrealMod.Content.Controllers;
using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;
using UnityEngine;
using ExtraSkillSlots;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrb : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.38f;
        public float fireFrac = 0.22f;
        public float duration = 2f;
        public int moveStrength; //1-3
        public bool hasFired;

        internal BlastAttack blastAttack;
        internal int attackAmount;
        internal float partialAttack;

        internal ExtraSkillLocator extraSkillLocator;
        internal ExtraInputBankTest extraInput;
        internal bool isStrong;


        private float movementMultiplier = 1.5f;

        public override void OnEnter()
        {
            base.OnEnter();
            rma = InitMeleeRootMotion();
            extraSkillLocator = gameObject.GetComponent<ExtraSkillLocator>();
            extraInput = gameObject.GetComponent<ExtraInputBankTest>();
            rmaMultiplier = movementMultiplier;

            if (moveStrength >= 3) 
            {
                isStrong = true;
            }

            attackAmount = (int)attackSpeedStat;
            if (attackAmount < 1)
            {
                attackAmount = 1;
            }
            partialAttack = attackSpeedStat - attackAmount;


            blastAttack = new BlastAttack
            {
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position + GetAimRay().direction * 2.5f,
                radius = (moveStrength == 3 ? 1 : Modules.StaticValues.blueOrbTripleMultiplier) * Modules.StaticValues.blueOrbBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = damageStat * Modules.StaticValues.blueOrbBlastRadius * (moveStrength == 3 ? 1 : Modules.StaticValues.blueOrbTripleMultiplier),
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = 1f,
            };


            base.characterDirection.forward = inputBank.aimDirection;

            PlayAttackAnimation();
        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("FullBody, Override", "yellowOrb", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();
            if (age >= duration * earlyEnd && base.isAuthority)
            {
                if (isStrong) 
                {
                    //Exit earlier to the Strong ender.
                    this.outer.SetState(new YellowOrbFinisher { });
                    return;
                }

                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, extraSkillLocator, isAuthority, inputBank, extraInput);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.


            if (fixedAge >= duration * fireFrac && isAuthority)
            {
                if (!hasFired)
                {
                    hasFired = true;
                    FireAttack();
                }
            }



            if (fixedAge >= duration)
            {
                outer.SetNextStateToMain();
                return;
            }
        }

        public void FireAttack()
        {
            for (int i = 0; i < Modules.StaticValues.yellowOrbBaseHitAmount; i++) 
            {
                for (int j = 0; j < attackAmount; j++)
                {
                    BlastAttack.Result result = blastAttack.Fire();

                    if (result.hitCount > 0)
                    {
                        OnHitEnemyAuthority();
                    }
                }

                if (partialAttack > 0f)
                {
                    blastAttack.baseDamage = blastAttack.baseDamage * partialAttack;
                    blastAttack.procCoefficient = blastAttack.procCoefficient * partialAttack;
                    blastAttack.radius = blastAttack.radius * partialAttack;
                    blastAttack.baseForce = blastAttack.baseForce * partialAttack;

                    BlastAttack.Result result = blastAttack.Fire();

                    if (result.hitCount > 0)
                    {
                        OnHitEnemyAuthority();
                    }
                }
            }            
        }

        public void OnHitEnemyAuthority()
        {
            //Do something on hit.
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(moveStrength);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            moveStrength = reader.ReadInt32();
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
