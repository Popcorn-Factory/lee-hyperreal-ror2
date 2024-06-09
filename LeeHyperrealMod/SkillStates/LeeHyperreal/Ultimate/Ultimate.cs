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
        public float fireTime = 0.42f;
        public float duration = 8.2f;
        public bool hasFired;
        public int moveStrength; //1-3

        internal BlastAttack blastAttack;
        private BulletAttack bulletAttack;

        internal string muzzleString = "BaseTransform"; //need to change to the sniper one

        private float movementMultiplier = 1.5f;
        private BulletController bulletController;
        private WeaponModelHandler weaponModelHandler;
        private UltimateCameraController ultimateCameraController;
        private Ray aimRay;
        private Vector3 velocity = Vector3.zero;

        public override void OnEnter()
        {
            base.OnEnter();
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;
            bulletController = gameObject.GetComponent<BulletController>();
            weaponModelHandler = gameObject.GetComponent<WeaponModelHandler>();
            ultimateCameraController = gameObject.GetComponent<UltimateCameraController>();

            if (bulletController.inSnipeStance && isAuthority) 
            {
                bulletController.UnsetSnipeStance();
            }


            bulletController.SetUltimateStance();

            base.characterMotor.velocity = Vector3.zero;

            weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.CANNON);

            aimRay = base.GetAimRay();

            base.characterDirection.forward = aimRay.direction;
            base.characterDirection.moveVector = aimRay.direction;

            PlayAttackAnimation();

            TriggerEnemyFreeze();

            GetModelAnimator().SetBool("isUltimate", true);

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
                            scale = 1.25f,
                        };
                        effectData.SetChildLocatorTransformReference(gameObject, childIndex);
                        EffectManager.SpawnEffect(Modules.ParticleAssets.ultTracerEffect, effectData, true);
                    }
                }
            }

            if (base.isAuthority) 
            {
                ultimateCameraController.TriggerUlt();
            }

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            Transform baseTransform = childLocator.FindChild("BaseTransform");
            if (!isGrounded)
            {
                bulletController.snipeAerialPlatform = UnityEngine.Object.Instantiate(Modules.ParticleAssets.snipeAerialFloor, baseTransform.position, Quaternion.identity);
            }
        }

        private bool AttachComponent(BulletAttack bulletAttackRef, ref BulletAttack.BulletHit hitInfo)
        {

            var hurtbox = hitInfo.hitHurtBox;
            if (hurtbox)
            {
                var healthComponent = hurtbox.healthComponent;
                if (healthComponent)
                {
                    var body = healthComponent.body;
                    if (body)
                    {
                        Ray aimRay = base.GetAimRay();
                        //attach component to pull enemies in, can add multiple?
                        UltimateController ultimateCon = body.gameObject.AddComponent<UltimateController>();
                        ultimateCon.charbody = characterBody;
                        ultimateCon.enemycharbody = body;

                    }
                }
            }
            return false;
        }

        protected void PlayAttackAnimation()
        {
            PlayAnimation("Body", "Ultimate", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            base.OnExit();
            if (base.isAuthority)
            {
                ultimateCameraController.UnsetUltimate();
            }

            if (bulletController.snipeAerialPlatform)
            {
                bulletController.snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
            }
            
            bulletController.UnsetUltimateStance();

            GetModelAnimator().SetBool("isUltimate", false);
            PlayAnimation("Body", "BufferEmpty");
            weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
        }

        public override void Update()
        {
            base.Update();


            base.characterDirection.forward = Vector3.SmoothDamp(base.characterDirection.forward, aimRay.direction, ref velocity, 0.1f, 100f, Time.deltaTime);
            base.characterDirection.moveVector = Vector3.SmoothDamp(base.characterDirection.moveVector, aimRay.direction, ref velocity, 0.1f, 100f, Time.deltaTime);

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

        public void TriggerEnemyFreeze()
        {

            BullseyeSearch search = new BullseyeSearch
            {
                teamMaskFilter = TeamMask.GetEnemyTeams(characterBody.teamComponent.teamIndex),
                filterByLoS = false,
                searchOrigin = characterBody.corePosition,
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

                    bulletAttack = new BulletAttack();
                    bulletAttack.bulletCount = (uint)(1U);
                    bulletAttack.aimVector = aimRay.direction;
                    bulletAttack.origin = aimRay.origin;
                    bulletAttack.damage = 1f * this.damageStat;
                    bulletAttack.damageColorIndex = DamageColorIndex.Default;
                    bulletAttack.damageType = DamageType.Generic;
                    bulletAttack.falloffModel = BulletAttack.FalloffModel.None;
                    bulletAttack.maxDistance = 200f;
                    bulletAttack.force = 0f;
                    bulletAttack.hitMask = LayerIndex.CommonMasks.bullet;
                    bulletAttack.minSpread = 0f;
                    bulletAttack.maxSpread = 0f;
                    bulletAttack.isCrit = base.RollCrit();
                    bulletAttack.owner = base.gameObject;
                    bulletAttack.muzzleName = muzzleString;
                    bulletAttack.smartCollision = false;
                    bulletAttack.procChainMask = default(ProcChainMask);
                    bulletAttack.procCoefficient = 0.1f;
                    bulletAttack.radius = 2f;
                    bulletAttack.sniper = true;
                    bulletAttack.stopperMask = LayerIndex.noCollision.mask;
                    bulletAttack.smartCollision = true;
                    bulletAttack.weapon = null;
                    bulletAttack.tracerEffectPrefab = RoR2.LegacyResourcesAPI.Load<GameObject>("RoR2/Base/Huntress/TracerHuntressSnipe.prefab"); //temporary
                    bulletAttack.spreadPitchScale = 0f;
                    bulletAttack.spreadYawScale = 0f;
                    bulletAttack.queryTriggerInteraction = QueryTriggerInteraction.UseGlobal;
                    bulletAttack.hitEffectPrefab = null;
                    bulletAttack.hitCallback = AttachComponent;

                    bulletAttack.Fire();

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
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
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
            return InterruptPriority.Skill;
        }
    }
}
