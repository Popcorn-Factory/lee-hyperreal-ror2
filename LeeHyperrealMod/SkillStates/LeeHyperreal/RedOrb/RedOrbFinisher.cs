using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrbFinisher : BaseRootMotionMoverState
    {

        public float duration = 2.03f;
        public int baseFireAmount = 3;
        public int fireAmount;
        public bool hasFired;
        public float firingStopwatch;

        internal int attackAmount;
        internal float partialAttack;

        internal float attackStart = 0.174f;
        internal float attackEnd = 0.25f;
        internal float attackFinalShot = 0.32f;
        internal float exitEarlyFrac = 0.37f;
        internal Ray aimRay;

        internal BulletAttack bulletAttack;
        internal string muzzleString = "SubmachineGunMuzzle";

        internal OrbController orbController;
        public override void OnEnter()
        {
            base.OnEnter();
            orbController = gameObject.GetComponent<OrbController>();
            if (orbController)
            {
                orbController.isExecutingSkill = true;
            }
            rmaMultiplier = 1f;
            fireAmount = baseFireAmount * (int)(attackSpeedStat > 1f ? attackSpeedStat : 1);

            firingStopwatch = attackEnd - attackStart;

            aimRay = base.GetAimRay();
            characterMotor.velocity.y = 0f;
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
                procCoefficient = Modules.StaticValues.redOrbProcCoefficient,
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
            PlayAnimation("Body", "redOrb2", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            PlayAnimation("Body", "BufferEmpty");
            base.OnExit();
            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
        }

        public override void Update()
        {
            base.Update();

            if (base.age >= duration * exitEarlyFrac && base.isAuthority) 
            {
                if (orbController)
                {
                    orbController.isExecutingSkill = false;
                }
                if (inputBank.moveVector != Vector3.zero) 
                {
                    this.outer.SetNextStateToMain();
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            if (fixedAge >= duration * attackStart && fixedAge <= duration * attackEnd && isAuthority)
            {
                firingStopwatch += Time.fixedDeltaTime;
                if (firingStopwatch >= (attackStart - attackEnd) / fireAmount)
                {
                    Util.PlaySound("HenryShootPistol", base.gameObject);
                    firingStopwatch = 0f;
                    bulletAttack.aimVector = base.GetAimRay().direction;
                    bulletAttack.origin = base.GetAimRay().origin;
                    bulletAttack.Fire();
                }
            }

            if (fixedAge >= duration * attackFinalShot && isAuthority) 
            {
                if (!hasFired) 
                {
                    hasFired = true;
                    bulletAttack.aimVector = base.GetAimRay().direction;
                    bulletAttack.origin = base.GetAimRay().origin;
                    bulletAttack.Fire();
                }
            }

            if (fixedAge >= duration && base.isAuthority) 
            {
                base.outer.SetNextStateToMain();
                return;
            }
        }


        public void OnHitEnemyAuthority()
        {
            //Do something on hit.
        }

    }
}
