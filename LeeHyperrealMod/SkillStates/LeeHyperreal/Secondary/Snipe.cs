﻿using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using Unity.Audio;
using UnityEngine;
using static LeeHyperrealMod.Content.Controllers.BulletController;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary
{
    internal class Snipe : BaseSkillState
    {
        Animator animator;
        public float earlyExitFrac = 0.35f;
        public float firingFrac = 0.08f;
        public bool hasFired;
        public float duration = 1.3f;
        public string muzzleString = "";

        public static float damageCoefficient = Modules.StaticValues.gunDamageCoefficient;
        public static float procCoefficient = 1f;
        public static float baseDuration = 1.3f;
        public static float force = 800f;
        public static float recoil = 3f;
        public static float range = 256f;
        public static GameObject tracerEffectPrefab = RoR2.LegacyResourcesAPI.Load<GameObject>("Prefabs/Effects/Tracers/TracerGoldGat");

        public OrbController orbController;
        public BulletController bulletController;
        public LeeHyperrealDomainController domainController;
        public float empoweredBulletMultiplier = 1f;

        public Vector3 velocity;

        public override void OnEnter()
        {
            bulletController = gameObject.GetComponent<BulletController>();
            orbController = gameObject.GetComponent<OrbController>();
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();
            base.characterBody.isSprinting = false;
            base.OnEnter();
            //Enter the snipe stance, move to IdleSnipe
            animator = this.GetModelAnimator();
            animator.SetFloat("attack.playbackRate", base.attackSpeedStat);

            PlayAttackAnimation();

            duration = baseDuration / base.attackSpeedStat;

            if (bulletController.ConsumeEnhancedBullet(1)) 
            {
                empoweredBulletMultiplier = 2.0f;
            }

            if (domainController.GetDomainState()) 
            {
                BulletType type = bulletController.ConsumeColouredBullet();

                if (type != BulletType.NONE)
                {
                    //Grant a 3 ping.
                    orbController.Grant3Ping(type);
                }
            }



            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();
            Ray aimRay = base.GetAimRay();

            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, base.inputBank.aimDirection, ref velocity, 0.1f, 100f, Time.deltaTime);
            if (age >= duration * firingFrac && base.isAuthority && !hasFired) 
            {
                this.hasFired = true;

                base.characterBody.AddSpreadBloom(1.5f);
                EffectManager.SimpleMuzzleFlash(EntityStates.Commando.CommandoWeapon.FirePistol2.muzzleEffectPrefab, base.gameObject, this.muzzleString, false);
                Util.PlaySound("HenryShootPistol", base.gameObject);

                if (base.isAuthority)
                {
                    base.AddRecoil(-1f * Shoot.recoil, -2f * Shoot.recoil, -0.5f * Shoot.recoil, 0.5f * Shoot.recoil);

                    new BulletAttack
                    {
                        bulletCount = 1,
                        aimVector = aimRay.direction,
                        origin = aimRay.origin,
                        damage = Shoot.damageCoefficient * this.damageStat * empoweredBulletMultiplier,
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
                    }.Fire();
                }
            }

            if (age >= duration * earlyExitFrac && base.isAuthority) 
            {
                if (inputBank.skill1.down) 
                {
                    base.outer.SetState(new Snipe { });
                    return;
                }

                //Check for dodging. Otherwise ignore.
                if (base.inputBank.skill3.down)
                {
                    Vector3 result = Modules.StaticValues.CheckDirection(inputBank.moveVector, GetAimRay());

                    if (result == new Vector3(0, 0, 0))
                    {
                        base.outer.SetState(new EvadeBack180 { });
                        return;
                    }
                    if (result == new Vector3(1, 0, 0))
                    {
                        base.outer.SetState(new EvadeSide { isLeftRoll = false });
                        return;
                    }
                    if (result == new Vector3(-1, 0, 0))
                    {
                        base.outer.SetState(new EvadeSide { isLeftRoll = true });
                        return;
                    }

                    return;
                }
            }

            if (age >= duration && base.isAuthority) 
            {
                base.outer.SetState(new IdleSnipe { });
                return;
            }
        }

        public void PlayAttackAnimation()
        {
            PlayAnimation("Body", "SnipeShot", "attack.playbackRate", duration);
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
