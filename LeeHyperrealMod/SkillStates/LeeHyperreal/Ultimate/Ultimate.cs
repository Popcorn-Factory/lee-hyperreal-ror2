using EntityStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using System;
using LeeHyperrealMod.Modules;
using R2API.Networking;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking.Interfaces;
using System.Collections.Generic;
using System.Linq;
using LeeHyperrealMod.Content.Controllers;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate
{
    internal class Ultimate : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.9f;
        public float fireTime = 0.514f;
        public float duration = 6.7f;
        public bool hasFired;
        public int moveStrength; //1-3

        internal BlastAttack blastAttack;
        private BulletAttack bulletAttack;

        internal string muzzleString = "BaseTransform"; //need to change to the sniper one
        internal string cannonmainString = "CannonMain";

        internal Transform cannonEndTransform;
        internal Transform cannonMainTransform;

        private float movementMultiplier = 1.5f;
        private BulletController bulletController;
        private WeaponModelHandler weaponModelHandler;
        private UltimateCameraController ultimateCameraController;
        private OrbController orbController;
        private LeeHyperrealDomainController domainController;
        private Ray aimRay;
        private Vector3 velocity = Vector3.zero;

        private bool setCease = false;
        private float playCeaseFrac = 0.312f;
        private bool hasCeased = false;

        private float weaponTransitionFrac = 0.8138f;
        private bool hasTransitioned = false;

        public override void OnEnter()
        {
            base.OnEnter();
            characterBody.isSprinting = false;
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;
            bulletController = gameObject.GetComponent<BulletController>();
            weaponModelHandler = gameObject.GetComponent<WeaponModelHandler>();
            ultimateCameraController = gameObject.GetComponent<UltimateCameraController>();
            orbController = gameObject.GetComponent<OrbController>();
            domainController = gameObject.GetComponent<LeeHyperrealDomainController>();

            if (domainController) 
            {
                domainController.SetTapped();
            }

            if (orbController) 
            {
                orbController.isExecutingSkill = true;
            }

            if (bulletController.inSnipeStance && isAuthority) 
            {
                bulletController.UnsetSnipeStance();
            }

            if (bulletController.snipeAerialPlatform) 
            {
                bulletController.snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
                bulletController.snipeAerialPlatform = null;
            }

            if (base.isAuthority && Modules.Config.ceaseChance.Value != 0f)
            {
                //Roll Cease chance
                float rand = UnityEngine.Random.Range(0f, 100f);
                if (rand <= Modules.Config.ceaseChance.Value)
                {
                    setCease = true;
                }
            }


            if (base.isAuthority) 
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_ultimate_start").Send(NetworkDestination.Clients);

                if (Modules.Config.voiceEnabled.Value && !setCease)
                {
                    if (Modules.Config.voiceLanguageOption.Value == Modules.Config.VoiceLanguage.ENG)
                    {
                        new PlaySoundNetworkRequest(characterBody.netId, "Play_Lee_Ult_Voice_EN").Send(NetworkDestination.Clients);
                    }
                    else
                    {
                        new PlaySoundNetworkRequest(characterBody.netId, "Play_Lee_Ult_Voice_JP").Send(NetworkDestination.Clients);
                    }
                }
            }

            bulletController.SetUltimateStance();

            base.characterMotor.velocity = Vector3.zero;

            weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.CANNON);
            weaponModelHandler.ActivateCannonOnAnimator();

            aimRay = base.GetAimRay();

            base.characterDirection.forward = aimRay.direction;
            base.characterDirection.moveVector = aimRay.direction;

            PlayAttackAnimation();

            RaycastHit hit;
            Physics.Raycast(GetAimRay(), out hit, Mathf.Infinity, (1 << LayerIndex.world.intVal) | (1 << LayerIndex.entityPrecise.intVal));

            if (base.isAuthority) 
            {
                TriggerFreezeAtPoint(characterBody.corePosition);
                if (hit.collider)
                {
                    TriggerFreezeAtPoint(hit.point);
                }
                else
                {
                    TriggerFreezeAtPoint(aimRay.origin + (aimRay.direction * 20f));
                }
            }

            GetModelAnimator().SetBool("isUltimate", true);

            if (base.isAuthority) 
            {
                ModelLocator component = gameObject.GetComponent<ModelLocator>();
                if (component && component.modelTransform)
                {
                    ChildLocator component2 = component.modelTransform.GetComponent<ChildLocator>();
                    if (component2)
                    {
                        cannonEndTransform = component2.FindChild("CannonEnd");
                        int childIndex = component2.FindChildIndex(muzzleString);
                        Transform transform = component2.FindChild(childIndex);
                        if (transform)
                        {
                            EffectData effectData = new EffectData
                            {
                                origin = transform.position,
                                scale = 1.25f,
                            };
                            effectData.SetChildLocatorTransformReference(gameObject, childIndex);
                            EffectManager.SpawnEffect(Modules.ParticleAssets.ultTracerEffect, effectData, true);
                        }
                    }
                }
                ModelLocator maincannoncomponent = gameObject.GetComponent<ModelLocator>();
                if (maincannoncomponent && maincannoncomponent.modelTransform)
                {
                    ChildLocator component2 = maincannoncomponent.modelTransform.GetComponent<ChildLocator>();
                    if (component2)
                    {
                        cannonMainTransform = component2.FindChild("CannonMain");
                        int childIndex = component2.FindChildIndex(cannonmainString);
                        Transform transform = component2.FindChild(childIndex);
                        if (transform)
                        {
                            EffectData effectData = new EffectData
                            {
                                origin = transform.position,
                            };
                            effectData.SetChildLocatorTransformReference(gameObject, childIndex);
                            EffectManager.SpawnEffect(Modules.ParticleAssets.ultShootingEffect, effectData, true);
                        }
                    }
                }

                ultimateCameraController.TriggerUlt();
            }

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            Transform baseTransform = childLocator.FindChild("BaseTransform");
            if (!isGrounded)
            {
                bulletController.snipeAerialPlatform = UnityEngine.Object.Instantiate(Modules.ParticleAssets.snipeAerialFloor, baseTransform.position, Quaternion.identity);
            }

            if (NetworkServer.active) 
            {
                //Set Invincibility cause fuck you.
                characterBody.SetBuffCount(Modules.Buffs.invincibilityBuff.buffIndex, 1);
            }
        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "Ultimate", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
            if (NetworkServer.active)
            {
                //Set Invincibility cause fuck you.
                characterBody.SetBuffCount(Modules.Buffs.invincibilityBuff.buffIndex, 0);
            }

            if (base.isAuthority)
            {
                ultimateCameraController.UnsetUltimate();
            }

            if (bulletController.snipeAerialPlatform)
            {
                bulletController.snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
                bulletController.snipeAerialPlatform = null;
            }
            
            bulletController.UnsetUltimateStance();

            GetModelAnimator().SetBool("isUltimate", false);
            PlayAnimation("Body", "BufferEmpty");
            if (weaponModelHandler.GetState() != WeaponModelHandler.WeaponState.SUBMACHINE) 
            {
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
            }

            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
        }

        public override void Update()
        {
            base.Update();


            //base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, aimRay.direction, ref velocity, 0.1f, 100f, Time.deltaTime);
            //base.characterDirection.moveVector = Vector3.SmoothDamp(base.characterDirection.moveVector, aimRay.direction, ref velocity, 0.1f, 100f, Time.deltaTime);

            base.characterMotor.velocity = new Vector3(0, 0, 0);

            if (age >= duration * playCeaseFrac && !hasCeased && base.isAuthority && setCease)
            {
                //Play cease effect.
                hasCeased = true;

                new PlaySoundNetworkRequest(characterBody.netId, "Play_cease_your_existance_NOW").Send(NetworkDestination.Clients);
                UnityEngine.Object.Instantiate(Modules.ParticleAssets.UltimateDomainCEASEYOUREXISTANCE, Camera.main.transform);
            }

            if (age >= duration * weaponTransitionFrac && !hasTransitioned) 
            {
                hasTransitioned = true;
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
            }


            if (age >= duration * earlyEnd && base.isAuthority)
            {
                if (base.inputBank.moveVector != Vector3.zero) 
                {
                    base.outer.SetNextStateToMain();
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

        }

        public void TriggerFreezeAtPoint(Vector3 point) 
        {
            BullseyeSearch search = new BullseyeSearch
            {
                teamMaskFilter = TeamMask.GetEnemyTeams(characterBody.teamComponent.teamIndex),
                filterByLoS = false,
                searchOrigin = point,
                searchDirection = UnityEngine.Random.onUnitSphere,
                sortMode = BullseyeSearch.SortMode.Distance,
                maxDistanceFilter = 100f,
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

                    new SetFreezeOnBodyRequest(singularTarget.healthComponent.body.masterObjectId, StaticValues.ultimateFreezeDuration).Send(NetworkDestination.Clients);


                }
            }
            

        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.



            if (fixedAge >= duration * fireTime && !hasFired)
            {
                hasFired = true;
                if (base.isAuthority)
                {
                    GetModelAnimator().SetBool("isUltimate", false);
                    SpawnBlastFromRay(aimRay);
                }

            }


            if (fixedAge >= duration)
            {
                outer.SetNextStateToMain();
                return;
            }
        }

        private void SpawnBlastFromRay(Ray ray)
        {
            //Get CannonEnd transform
            // Hijack the ray so that it fires from the cannon end 
            ray.origin = cannonEndTransform.position;

            RaycastHit hit;
            Physics.Raycast(ray, out hit, Mathf.Infinity, (1 << LayerIndex.world.intVal) | (1 << LayerIndex.entityPrecise.intVal));
            if (hit.collider)
            { 
                new UltimateObjectSpawnNetworkRequest(characterBody.netId, hit.point).Send(NetworkDestination.Clients);
            }
            else 
            {
                new UltimateObjectSpawnNetworkRequest(characterBody.netId, ray.origin + (ray.direction * 20f)).Send(NetworkDestination.Clients);
            }

            //Spawn blast attack.
        }

        public void OnHitEnemyAuthority()
        {
            //Do something on hit.
        }


        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
