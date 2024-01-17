using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using R2API.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrb : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.35f;
        public float fireFrac = 0.20f;
        public float endFireFrac = 0.3f;
        public int baseFireAmount = 3;
        public int fireAmount;
        public float duration = 2.2f;
        public int moveStrength; //1-3
        public bool hasFired;
        public float firingStopwatch;

        internal BlastAttack blastAttack;
        internal BulletAttack bulletAttack;
        internal int attackAmount;
        internal float partialAttack;

        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.redOrbProcCoefficient;

        internal string muzzleString = "SubmachineGunMuzzle";
        private float movementMultiplier = 1.5f;

        private float invincibilityStartFrac = 0.16f;
        private float invincibilityEndFrac = 0.4f;
        private bool invincibilitySet = false;

        float movespeedScalingCap = 25f;

        float disableInvincibility = 0.42f;

        public override void OnEnter()
        {
            base.OnEnter();
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;

            firingStopwatch = endFireFrac - fireFrac;
            if (moveStrength >= 3) 
            {
                isStrong = true;
            }

            fireAmount = baseFireAmount * (int)(attackSpeedStat > 1f ? attackSpeedStat : 1);

            attackAmount = (int)attackSpeedStat + baseFireAmount;
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


            base.characterDirection.forward = inputBank.aimDirection;

            rmaMultiplier = base.moveSpeedStat < movespeedScalingCap ? moveSpeedStat / 10f : movespeedScalingCap / 10f;

            if (rmaMultiplier < movementMultiplier)
            {
                rmaMultiplier = movementMultiplier;
            }

            PlayAttackAnimation();

            if (base.isAuthority)
            {
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 1, duration * disableInvincibility);
            }
        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("FullBody, Override", "redOrb", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
            if (base.isAuthority)
            {
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 0);
            }
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

                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.


            if (fixedAge >= duration * fireFrac && fixedAge <= duration * endFireFrac && isAuthority)
            {
                firingStopwatch += Time.fixedDeltaTime;
                if (firingStopwatch >= (endFireFrac - fireFrac) / fireAmount) 
                {
                    Util.PlaySound("HenryShootPistol", base.gameObject);
                    firingStopwatch = 0f;
                    bulletAttack.aimVector = base.GetAimRay().direction;
                    bulletAttack.origin = base.GetAimRay().origin;
                    bulletAttack.Fire();
                }
            }

            if (fixedAge >= duration * invincibilityStartFrac && fixedAge <= duration * invincibilityEndFrac && isAuthority && !invincibilitySet) 
            {
                invincibilitySet = true;
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 1, (duration * invincibilityEndFrac) - (duration * invincibilityStartFrac));
            }

            if (fixedAge >= duration * invincibilityEndFrac && isAuthority) 
            {
                base.characterBody.ApplyBuff(Modules.Buffs.invincibilityBuff.buffIndex, 0, -1);
            }


            if (fixedAge >= duration)
            {
                outer.SetNextStateToMain();
                return;
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
