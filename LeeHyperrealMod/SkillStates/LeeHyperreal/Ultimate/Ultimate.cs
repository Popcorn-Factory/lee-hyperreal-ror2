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

        internal string muzzleString = "SubmachineGunMuzzle"; //need to change to the sniper one

        private float movementMultiplier = 1.5f;

        public override void OnEnter()
        {
            base.OnEnter();
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;


            Ray aimRay = base.GetAimRay();


            base.characterDirection.forward = inputBank.aimDirection;

            PlayAttackAnimation();

            TriggerEnemyFreeze();

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
            PlayAnimation("FullBody, Override", "Ultimate", "attack.playbackRate", duration);
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
                    Ray aimRay = base.GetAimRay();

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
                    bulletAttack.weapon = null;
                    bulletAttack.tracerEffectPrefab = RoR2.LegacyResourcesAPI.Load<GameObject>("RoR2/Base/Huntress/TracerHuntressSnipe.prefab"); //temporary
                    bulletAttack.spreadPitchScale = 0f;
                    bulletAttack.spreadYawScale = 0f;
                    bulletAttack.queryTriggerInteraction = QueryTriggerInteraction.UseGlobal;
                    bulletAttack.hitEffectPrefab = null;
                    bulletAttack.hitCallback = AttachComponent;

                    bulletAttack.Fire();


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
