﻿using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrbFinisher : BaseMeleeAttack
    {
        internal OverlapAttack attack;

        internal HitBoxGroup hitBoxGroup;

        internal int attackAmount;
        internal float partialAttack;

        internal float attackStart = 0.154f;
        internal float attackEnd = 0.24f;
        internal float exitEarlyFrac = 0.26f;

        internal RootMotionAccumulator rma;
        internal OrbController orbController;
        private Transform baseTransform;

        public override void OnEnter()
        {

            this.hitboxName = "ShortMelee";
            base.OnEnter();
            duration = 1.13f;

            this.damageType = DamageType.Generic;
            this.damageCoefficient = Modules.StaticValues.yellowOrbFinisherDamageCoefficient;
            this.procCoefficient = Modules.StaticValues.yellowOrbFinisherProcCoefficient;
            this.pushForce = Modules.StaticValues.yellowOrbFinisherPushForce;
            this.bonusForce = Vector3.up;
            this.baseDuration = 2.366f;
            this.attackStartTime = attackStart;
            this.attackEndTime = attackEnd;
            this.baseEarlyExitTime = exitEarlyFrac;
            this.hitStopDuration = 0.05f;
            this.attackRecoil = 0.5f;
            this.hitHopVelocity = 4f;

            this.swingSoundString = "HenrySwordSwing";
            this.hitSoundString = "";
            this.muzzleString = "BaseTransform";
            this.swingEffectPrefab = Modules.ParticleAssets.yellowOrbKick;
            this.hitEffectPrefab = Modules.ParticleAssets.yellowOrbSwingHit;

            this.impactSound = Modules.Assets.swordHitSoundEvent.index;

            enableParry = true;
            parryLength = 0.5f;
            parryTiming = 0.05f;
            parryPauseLength = 0.2f;
            parryProjectileTiming = 0.04f;
            parryProjectileTimingEnd = 0.08f;

            base.OnEnter();

            InitMeleeRootMotion();

            orbController = gameObject.GetComponent<OrbController>();
            if (orbController)
            {
                orbController.isExecutingSkill = true;
            }
            characterMotor.velocity.y = 0f;

            //ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            //baseTransform = childLocator.FindChild("BaseTransform");

            ////Play Effect
            //EffectData effectData = new EffectData
            //{
            //    origin = baseTransform.position,
            //    rotation = Quaternion.LookRotation(characterDirection.forward),
            //    scale = 1.25f,
            //};
            //EffectManager.SpawnEffect(Modules.ParticleAssets.yellowOrbKick, effectData, true);
        }
        
        protected override void PlayAttackAnimation()
        {
            PlayAnimation("Body", "yellowOrb2", "attack.playbackRate", duration);
        }

        public RootMotionAccumulator InitMeleeRootMotion()
        {
            rma = base.GetModelRootMotionAccumulator();
            if (rma)
            {
                rma.ExtractRootMotion();
            }
            if (base.characterDirection)
            {
                base.characterDirection.forward = base.inputBank.aimDirection;
            }
            if (base.characterMotor)
            {
                base.characterMotor.moveDirection = Vector3.zero;
            }
            return rma;
        }

        // Token: 0x060003CA RID: 970 RVA: 0x0000F924 File Offset: 0x0000DB24
        public void UpdateMeleeRootMotion(float scale)
        {
            if (rma)
            {
                Vector3 a = rma.ExtractRootMotion();
                if (base.characterMotor)
                {
                    base.characterMotor.rootMotion = a * scale;
                }
            }
        }

        public override void OnExit()
        {
            base.OnExit();
            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
            PlayAnimation("Body", "BufferEmpty");
        }

        public override void Update()
        {
            base.Update();
            if (base.inputBank.skill3.down && base.inputBank.skill4.down && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }
            UpdateMeleeRootMotion(1f);

            if (base.age >= duration * exitEarlyFrac && base.isAuthority) 
            {
                if (orbController)
                {
                    orbController.isExecutingSkill = false;
                }
                if (base.inputBank.moveVector != Vector3.zero) 
                {
                    base.outer.SetNextStateToMain();
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }



        public void OnHitEnemyAuthority()
        {
            //Do something on hit.
        }

    }
}
