using EntityStates;
using RoR2;
using LeeHyperrealMod.Content.Controllers;
using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;
using UnityEngine;
using ExtraSkillSlots;
using LeeHyperrealMod.SkillStates.BaseStates;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal
{
    internal class BlueOrb : BaseRootMotionMoverState
    {
        OrbController orbController;

        public float start = 0;
        public float earlyEnd = 0.49f;
        public float fireFrac = 0.22f;
        public float duration = 3.83f;
        public int moveStrength; //1-3
        public bool hasFired;

        internal BlastAttack blastAttack;
        internal int attackAmount;
        internal float partialAttack;

        internal ExtraSkillLocator extraSkillLocator;
        internal ExtraInputBankTest extraInput;

        private float movementMultiplier = 1.5f;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();
            moveStrength = orbController.ConsumeOrbs(OrbController.OrbType.BLUE);
            extraSkillLocator = base.gameObject.GetComponent<ExtraSkillLocator>();
            extraInput = base.gameObject.GetComponent<ExtraInputBankTest>();
            rmaMultiplier = movementMultiplier;
            if (moveStrength == 0) 
            {
                base.PlayAnimation("FullBody, Override", "BufferEmpty");
                this.outer.SetNextStateToMain();
                return;
            }

            attackAmount = (int)this.attackSpeedStat;
            if (attackAmount < 1)
            {
                attackAmount = 1;
            }
            partialAttack = (float)(this.attackSpeedStat - (float)attackAmount);


            blastAttack = new BlastAttack
            {
                attacker = base.gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = base.gameObject.transform.position + (GetAimRay().direction * 2.5f),
                radius = (moveStrength == 3 ? 1 : Modules.StaticValues.blueOrbTripleMultiplier) * Modules.StaticValues.blueOrbBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = this.damageStat * Modules.StaticValues.blueOrbBlastRadius * (moveStrength == 3 ? 1 : Modules.StaticValues.blueOrbTripleMultiplier),
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = this.RollCrit(),
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
            base.PlayAnimation("FullBody, Override", "blueOrb", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();
            if (base.fixedAge >= duration * earlyEnd && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, extraSkillLocator, isAuthority, base.inputBank, extraInput);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.
            

            if (base.fixedAge >= duration * fireFrac && base.isAuthority) 
            {
                if (!hasFired) 
                {
                    hasFired = true;
                    FireAttack();
                }
            }



            if (base.fixedAge >= duration)
            {
                this.outer.SetNextStateToMain();
                return;
            }
        }

        public void FireAttack()
        {
            for (int i = 0; i < attackAmount; i++) 
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

        public void OnHitEnemyAuthority() 
        {
            //Do something on hit.
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
