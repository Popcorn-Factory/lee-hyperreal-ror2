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

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate
{
    internal class UltimateController : MonoBehaviour
    {

        public CharacterBody charbody;
        public CharacterBody enemycharbody;
        public float numberOfHits = 10;
        public float currentNumber;
        public float timer;
        public float interval = 0.2f;
        private BlastAttack blastAttack;

        public void Start()
        {
            currentNumber = 0f;

        }



        public void FixedUpdate()
        {

            if (charbody.healthComponent.alive)
            {
                timer += Time.fixedDeltaTime;
                if (timer > 0.1f)
                {
                    if (currentNumber < numberOfHits)
                    {
                        currentNumber += 1;
                        timer -= interval;

                        new PerformForceNetworkRequest(charbody.masterObjectId, enemycharbody.corePosition, Vector3.up, StaticValues.ultimateBlastRadius, 0f, 1f, 360f).Send(NetworkDestination.Clients);
                    }
                    else if (currentNumber == numberOfHits)
                    {
                        currentNumber += 1;

                        blastAttack = new BlastAttack();
                        blastAttack.radius = StaticValues.ultimateBlastRadius;
                        blastAttack.procCoefficient = StaticValues.ultimateProcCoefficient;
                        blastAttack.position = enemycharbody.corePosition;
                        blastAttack.attacker = charbody.gameObject;
                        blastAttack.crit = charbody.RollCrit();
                        blastAttack.baseDamage = Modules.StaticValues.ultimateDamageCoefficient * charbody.damage;
                        blastAttack.falloffModel = BlastAttack.FalloffModel.None;
                        blastAttack.baseForce = 0f;
                        blastAttack.teamIndex = TeamComponent.GetObjectTeam(blastAttack.attacker);
                        blastAttack.damageType = DamageType.Generic;
                        blastAttack.attackerFiltering = AttackerFiltering.Default;

                        blastAttack.Fire();
                        
                        
                    }
                    else if (currentNumber > numberOfHits)
                    {

                        Destroy(this);
                    }

                }

            }
            else if (!charbody)
            {
                Destroy(this);
            }
        }

    }
}
