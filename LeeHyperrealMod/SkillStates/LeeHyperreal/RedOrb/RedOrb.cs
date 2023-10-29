using EntityStates;
using RoR2;
using UnityEngine;
using ExtraSkillSlots;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrb : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.35f;
        public float fireFrac = 0.22f;
        public float duration = 2.2f;
        public int moveStrength; //1-3
        public bool hasFired;

        internal BlastAttack blastAttack;
        internal BulletAttack bulletAttack;
        internal int attackAmount;
        internal float partialAttack;

        internal ExtraSkillLocator extraSkillLocator;
        internal ExtraInputBankTest extraInput;
        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.redOrbProcCoefficient;

        internal string muzzleString = "SubmachineGunMuzzle";
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

            Ray aimRay = base.GetAimRay();


            bulletAttack = new BulletAttack
            {
                bulletCount = 1,
                aimVector = aimRay.direction,
                origin = aimRay.origin,
                damage = Shoot.damageCoefficient * this.damageStat,
                damageColorIndex = DamageColorIndex.Default,
                damageType = DamageType.Generic,
                falloffModel = BulletAttack.FalloffModel.DefaultBullet,
                maxDistance = Shoot.range,
                force = Shoot.force,
                hitMask = LayerIndex.CommonMasks.bullet,
                minSpread = 0f,
                maxSpread = 0f,
                isCrit = base.RollCrit(),
                owner = base.gameObject,
                muzzleName = muzzleString,
                smartCollision = false,
                procChainMask = default(ProcChainMask),
                procCoefficient = procCoefficient,
                radius = 0.75f,
                sniper = false,
                stopperMask = LayerIndex.CommonMasks.bullet,
                weapon = null,
                tracerEffectPrefab = Shoot.tracerEffectPrefab,
                spreadPitchScale = 0f,
                spreadYawScale = 0f,
                queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                hitEffectPrefab = EntityStates.Commando.CommandoWeapon.FirePistol2.hitEffectPrefab,
                hitCallback = BulletAttack.defaultHitCallback,
            };

            PlayAttackAnimation();
        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("FullBody, Override", "redOrb", "attack.playbackRate", duration);
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
                    this.outer.SetState(new RedOrbFinisher { });
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
                    base.GetAimRay();

                    bulletAttack.Fire();
                }

                if (partialAttack > 0f)
                {

                    bulletAttack.Fire();
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
