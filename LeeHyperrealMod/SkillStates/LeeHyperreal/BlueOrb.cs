using EntityStates;
using RoR2;
using LeeHyperrealMod.Content.Controllers;
using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;
using UnityEngine;
using LeeHyperrealMod.SkillStates.BaseStates;
using UnityEngine.Networking;
using R2API.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal
{
    internal class BlueOrb : BaseRootMotionMoverState
    {
        OrbController orbController;
        BulletController bulletController;

        public float start = 0;
        public float earlyEnd = 0.38f;
        public float fireFrac = 0.22f;
        public float duration = 3.83f;
        public int moveStrength; //1-3
        public bool hasFired;

        internal BlastAttack blastAttack;
        internal int attackAmount;
        internal float partialAttack;

        private float movementMultiplier = 1.5f;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.298f;

        float movespeedScalingCap = 15f;

        float disableInvincibility = 0.43f;

        float orbCancelFrac = 0.24f;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();
            bulletController = base.gameObject.GetComponent<BulletController>();

            if (orbController) 
            {
                orbController.isExecutingSkill = true;
            }

            rmaMultiplier = movementMultiplier;

            base.characterMotor.velocity.y = 0f;

            if (bulletController.inSnipeStance && isAuthority) 
            {
                bulletController.UnsetSnipeStance();
            }

            if (moveStrength == 3)
            {
                bulletController.GrantColouredBullet(BulletController.BulletType.BLUE);
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
            base.characterDirection.moveVector = inputBank.aimDirection;

            PlayAttackAnimation();

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;

            rmaMultiplier = base.moveSpeedStat < movespeedScalingCap ? moveSpeedStat / 10f : movespeedScalingCap / 10f;

            if (rmaMultiplier < movementMultiplier) 
            {
                rmaMultiplier = movementMultiplier;
            }

            if (base.isAuthority) 
            {
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 1, duration * disableInvincibility);
            }
        }

        protected void PlayAttackAnimation()
        {
            base.PlayAnimation("Body", "blueOrb", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
            base.characterMotor.gravityParameters = oldGravParams;
            if (base.isAuthority)
            {
                //Remove the invincibility just in case.
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 0);
            }
            PlayAnimation("Body", "BufferEmpty");
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();
            if (base.age >= duration * orbCancelFrac && base.isAuthority) 
            {
                if (orbController)
                {
                    orbController.isExecutingSkill = false;
                }
            }
            if (base.age >= duration * earlyEnd && base.isAuthority)
            {
                if (inputBank.moveVector != new Vector3()) 
                {
                    //Cancel
                    base.outer.SetNextStateToMain();
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }


            if (base.age >= duration * turnOffGravityFrac)
            {
                base.characterMotor.gravityParameters = oldGravParams;
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

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(this.moveStrength);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            this.moveStrength = reader.ReadInt32();
        }
    }
}
