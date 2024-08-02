using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Primary
{
    internal class PrimaryDomainAerialSlam : BaseRootMotionMoverState
    {
        LeeHyperrealDomainController domainController;
        OrbController orbController;
        private bool isDomain;
        private float moveCancelFrac = 0.3f;
        private float duration = 1.6666f;
        private bool hasFired = false;
        public float airTime = 1f;
        public float damageCoefficient = Modules.StaticValues.primaryAerialDamageCoefficient;
        public float procCoefficient = Modules.StaticValues.primaryAerialProcCoefficient;   

        public BlastAttack attack;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = GetComponent<OrbController>();
            domainController = GetComponent<LeeHyperrealDomainController>();

            domainController.DisableLoopEffect();

            base.characterMotor.velocity = Vector3.zero;

            base.rmaMultiplier = 1.4f;

            float maxAirTime = 1.2f;

            if (airTime > maxAirTime)
            {
                airTime = maxAirTime;
            }

            airTime = Util.Remap(airTime, 0f, maxAirTime, 1f, Modules.StaticValues.primaryAerialMaxDamageMultiplier);

            //Fire as soon as this state is triggered.
            if (base.isAuthority) 
            {
                FireAttack();
                PlaySwing("BaseTransform", 1.25f, Modules.ParticleAssets.primaryAerialEffectEnd);
            }

            base.PlayAnimation("Body", "DomainMidairEnd", "attack.playbackRate", duration);
        }

        public void PlaySwing(string muzzleString, float swingScale, GameObject effectPrefab)
        {
            ModelLocator component = gameObject.GetComponent<ModelLocator>();
            if (component && component.modelTransform)
            {
                ChildLocator component2 = component.modelTransform.GetComponent<ChildLocator>();
                if (component2)
                {
                    int childIndex = component2.FindChildIndex(muzzleString);
                    Transform transform = component2.FindChild(childIndex);
                    if (transform)
                    {
                        EffectData effectData = new EffectData
                        {
                            origin = transform.position,
                            scale = swingScale,
                        };
                        effectData.SetChildLocatorTransformReference(gameObject, childIndex);
                        EffectManager.SpawnEffect(effectPrefab, effectData, true);
                    }
                }
            }
        }

        public override void OnExit()
        {
            base.OnExit();
            if (base.isAuthority)
            {
                base.characterBody.ApplyBuff(Modules.Buffs.fallDamageNegateBuff.buffIndex, 0);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            if (fixedAge >= duration * moveCancelFrac && base.isAuthority) 
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);

                if (base.inputBank.moveVector != new Vector3(0, 0, 0))
                {
                    this.outer.SetNextStateToMain();
                    return;
                }
            }

            if (fixedAge >= duration && base.isAuthority)
            {
                base.outer.SetNextStateToMain();
                return;
            }
        }

        private void FireAttack()
        {
            attack = new BlastAttack
            {
                attacker = base.gameObject,
                inflictor = null,
                teamIndex = base.GetTeam(),
                position = base.gameObject.transform.position,
                radius = Modules.StaticValues.primaryAerialSlamRadius,
                falloffModel = BlastAttack.FalloffModel.None,
                baseDamage = this.damageStat * damageCoefficient * airTime,
                baseForce = 600f * airTime,
                bonusForce = Vector3.up,
                crit = this.RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.NearestHit,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = procCoefficient,
                //impactEffect = EffectCatalog.FindEffectIndexFromPrefab(Modules.ParticleAssets.primary4Hit)
            };
            BlastAttack.Result result = attack.Fire();

            if (result.hitCount > 0)
            {
                if (orbController)
                {
                    orbController.AddToIncrementor(Modules.StaticValues.flatAmountToGrantOnPrimaryHit * result.hitCount);
                }
            }
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(airTime);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            airTime = reader.ReadSingle();
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
