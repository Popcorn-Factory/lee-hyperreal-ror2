using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using LeeHyperrealMod.Modules;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking;
using System.Collections.Generic;
using System.Linq;
using R2API.Networking.Interfaces;
using LeeHyperrealMod.Content.Controllers;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate
{
    internal class UltimateDomain : BaseRootMotionMoverState
    {
        public LeeHyperrealDomainController docon;
        private UltimateCameraController ultimateCameraController;
        private BulletController bulletController;

        public float start = 0;
        public float earlyEnd = 0.65f;
        public float effectPlay = 0.55f;
        public bool hasPlayedEffect = false;
        public float fireTime = 0.01f;
        public float fireEndTime = 0.35f;
        public float fireInterval = 0.1f;
        public float finalInterval = 0.2f;
        public float duration = StaticValues.ultimateDomainDuration;
        public float fireStopwatch;
        public float finalStopwatch;
        public bool preFinalBlastTriggered = false;
        public bool finalBlastTriggered = false;

        internal BlastAttack blastAttack;

        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.redOrbProcCoefficient;
        internal float damageCoefficient = Modules.StaticValues.redOrbDomainDamageCoefficient;

        private float movementMultiplier = 1.5f;
        private int fireCount;
        private int sightStacks; //annschauung

        private bool setCease = false;
        private float playCeaseFrac = 0.188f;
        private bool hasCeased = false;

        public override void OnEnter()
        {
            base.OnEnter();
            characterBody.isSprinting = false;
            docon = gameObject.GetComponent<LeeHyperrealDomainController>();
            ultimateCameraController = gameObject.GetComponent<UltimateCameraController>();
            bulletController = gameObject.GetComponent<BulletController>();

            if (bulletController.inSnipeStance && isAuthority)
            {
                bulletController.UnsetSnipeStance();
            }

            sightStacks = docon.GetIntuitionStacks();
            if (sightStacks == 0) 
            {
                sightStacks = 1;
            }
            docon.DisableDomain(false);

            if (base.isAuthority && Modules.Config.ceaseChance.Value != 0f) 
            {
                //Roll Cease chance
                float rand = UnityEngine.Random.Range(0f, 100f);
                if (rand <= Modules.Config.ceaseChance.Value) 
                {
                    setCease = true;
                }
            }


            if (isAuthority)
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_ex_ultimate").Send(NetworkDestination.Clients);

                if (Modules.Config.voiceEnabled.Value && !setCease)
                {
                    if (Modules.Config.voiceLanguageOption.Value == Modules.Config.VoiceLanguage.ENG)
                    {
                        new PlaySoundNetworkRequest(characterBody.netId, "Play_Lee_Domain_Ult_Voice_EN").Send(NetworkDestination.Clients);
                    }
                    else
                    {
                        new PlaySoundNetworkRequest(characterBody.netId, "Play_Lee_Domain_Ult_Voice_JP").Send(NetworkDestination.Clients);
                    }
                }
            }


            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;

            Ray aimRay = base.GetAimRay();

            blastAttack = new BlastAttack
            {
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position,
                radius = Modules.StaticValues.ultimateDomainBlastRadius,
                falloffModel = BlastAttack.FalloffModel.None,
                baseDamage = damageStat * Modules.StaticValues.ultimateDomainMiniDamageCoefficient * sightStacks, //multiply by anschauung stacks
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = procCoefficient,
            };

            base.GetModelAnimator().SetFloat("attack.playbackRate", 1f);
            base.characterDirection.forward = inputBank.aimDirection;

            Freeze();
            PlayAttackAnimation();


            if (base.isAuthority)
            {
                ultimateCameraController.TriggerDomainUlt();
            }
            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            Transform baseTransform = childLocator.FindChild("BaseTransform");
            Vector3 targetDir = Camera.main.transform.position - baseTransform.position;
            EffectData effectData = new EffectData
            {
                origin = gameObject.transform.position,
                rotation = Quaternion.LookRotation(targetDir.normalized, Vector3.up),
                scale = 1.25f,
            };
            EffectManager.SpawnEffect(Modules.ParticleAssets.UltimateDomainBulletFinisher, effectData, true);
        }

        public void Freeze()
        {
            BullseyeSearch search = new BullseyeSearch
            {

                teamMaskFilter = TeamMask.GetEnemyTeams(characterBody.teamComponent.teamIndex),
                filterByLoS = false,
                searchOrigin = characterBody.corePosition,
                searchDirection = UnityEngine.Random.onUnitSphere,
                sortMode = BullseyeSearch.SortMode.Distance,
                maxDistanceFilter = 200f,
                maxAngleFilter = 360f
            };

            search.RefreshCandidates();
            search.FilterOutGameObject(characterBody.gameObject);

            List<HurtBox> target = search.GetResults().ToList<HurtBox>();
            foreach (HurtBox singularTarget in target)
            {
                if (singularTarget.healthComponent && singularTarget.healthComponent.body)
                {
                    //stop time for all enemies within this radius

                    //Chat.AddMessage("freeze enemy");
                    new SetFreezeOnBodyRequest(singularTarget.healthComponent.body.masterObjectId, StaticValues.ultimateDomainDuration).Send(NetworkDestination.Clients);
                }
            }
        }
        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "UltimateDomain", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
            if (base.isAuthority)
            {
                ultimateCameraController.UnsetUltimate();
            }
            PlayAnimation("Body", "BufferEmpty");
        }

        public override void Update()
        {
            base.Update();
            if (age >= duration * earlyEnd && base.isAuthority)
            {

                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (age >= duration * playCeaseFrac && !hasCeased && base.isAuthority && setCease) 
            {
                //Play cease effect.
                hasCeased = true;

                new PlaySoundNetworkRequest(characterBody.netId, "Play_cease_your_existance_NOW").Send(NetworkDestination.Clients);
                UnityEngine.Object.Instantiate(Modules.ParticleAssets.UltimateDomainCEASEYOUREXISTANCE, Camera.main.transform);
            }

            if (age >= duration * effectPlay && !hasPlayedEffect && base.isAuthority && !setCease) 
            {
                hasPlayedEffect = true;
                UnityEngine.Object.Instantiate(Modules.ParticleAssets.UltimateDomainFinisherEffect, Camera.main.transform);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.
            if (fixedAge >= duration * fireTime && base.isAuthority)
            {
                if(fireStopwatch <= 0f && fireCount < StaticValues.ultimateDomainFireCount)
                {
                    //mini hits
                    fireStopwatch = fireInterval;
                    blastAttack.Fire();
                    fireCount++;

                }
                else if (fireStopwatch > 0f && fireCount < StaticValues.ultimateDomainFireCount)
                {
                    fireStopwatch -= Time.fixedDeltaTime;
                }

                if (fireCount >= StaticValues.ultimateDomainFireCount)
                {
                    if(finalStopwatch > finalInterval && !preFinalBlastTriggered)
                    {
                        preFinalBlastTriggered = true;
                        //final hit
                        blastAttack.baseDamage = damageStat * Modules.StaticValues.ultimateDomainDamageCoefficient * sightStacks; //multiple by anschauung stacks
                        blastAttack.Fire();

                    }
                    else
                    {
                        finalStopwatch += Time.fixedDeltaTime;
                    }

                }
            }

            if (fixedAge >= duration * effectPlay && base.isAuthority) 
            {
                if (!finalBlastTriggered) 
                {
                    finalBlastTriggered = true;
                    blastAttack.baseDamage = damageStat * Modules.StaticValues.ultimateDomainDamageCoefficient * sightStacks;
                    blastAttack.bonusForce = Vector3.up;
                    blastAttack.baseForce = 1000f;
                    blastAttack.Fire();
                }
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


        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }
    }
}
