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
    internal class PrimaryAerialSlam : BaseRootMotionMoverState
    {
        LeeHyperrealDomainController domainController;
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

            if (airTime <= 1f) 
            {
                airTime = 1f;
            }

            if (airTime >= Modules.StaticValues.primaryAerialMaxDamageMultiplier) 
            {
                airTime = Modules.StaticValues.primaryAerialMaxDamageMultiplier;
            }

            //Fire as soon as this state is triggered.
            FireAttack();

            base.PlayAnimation("Body", "Midair Attack End", "attack.playbackRate", duration);
            PlaySwing("BaseTransform", 1.25f, Modules.ParticleAssets.primary5Floor);

            if (base.isAuthority)
            {
                base.characterBody.ApplyBuff(Modules.Buffs.fallDamageNegateBuff.buffIndex, 0);
            }
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
                teamIndex = TeamIndex.Player,
                position = base.gameObject.transform.position,
                radius = Modules.StaticValues.primaryAerialSlamRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
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
            attack.Fire();
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
