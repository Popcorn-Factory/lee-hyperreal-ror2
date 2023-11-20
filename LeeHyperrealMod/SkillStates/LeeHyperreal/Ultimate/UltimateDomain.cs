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

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class UltimateDomain : BaseRootMotionMoverState
    {

        public float start = 0;
        public float earlyEnd = 0.8f;
        public float fireTime = 0.35f;
        public float fireInterval = 0.1f;
        public float finalInterval = 0.5f;
        public float duration = StaticValues.ultimateDomainDuration;
        public float fireStopwatch;
        public float finalStopwatch;

        internal BlastAttack blastAttack;

        internal bool isStrong;
        internal float procCoefficient = Modules.StaticValues.redOrbProcCoefficient;
        internal float damageCoefficient = Modules.StaticValues.redOrbDomainDamageCoefficient;

        private float movementMultiplier = 1.5f;
        private float annshacungMultiplier;
        private int fireCount;

        public override void OnEnter()
        {
            base.OnEnter();
            rma = InitMeleeRootMotion();
            rmaMultiplier = movementMultiplier;
            annshacungMultiplier = 1f; //multiply by number of stacks

            Ray aimRay = base.GetAimRay();


            base.characterDirection.forward = inputBank.aimDirection;

            Freeze();
            PlayAttackAnimation();

            //add random 3 ping
            blastAttack = new BlastAttack
            {
                attacker = gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = gameObject.transform.position + GetAimRay().direction * 2.5f,
                radius = Modules.StaticValues.redOrbDomainBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = damageStat * Modules.StaticValues.ultimateDomainMiniDamageCoefficient * annshacungMultiplier, //multiply by anschauung stacks
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = procCoefficient,
            };

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
                    new SetFreezeOnBodyRequest(singularTarget.healthComponent.body.masterObjectId).Send(NetworkDestination.Clients);


                }
            }
        }
        protected void PlayAttackAnimation()
        {
            PlayAnimation("FullBody, Override", "ultimateDomain", "attack.playbackRate", duration);
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

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.


            if (fixedAge >= duration * fireTime )
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
                    if(finalStopwatch > finalInterval)
                    {
                        //final hit
                        blastAttack.baseDamage = damageStat * Modules.StaticValues.ultimateDomainDamageCoefficient * annshacungMultiplier; //multiple by anschauung stacks
                        blastAttack.Fire();

                    }
                    else
                    {
                        finalStopwatch += Time.fixedDeltaTime;
                    }

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
