using LeeHyperrealMod.Modules.Networking;
using R2API.Networking;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class UltimateOrbExplosion : MonoBehaviour
    {
        public float timer;
        public float pullTimer;
        public float duration;
        public bool triggeredExplosion;
        public Vector3 position;
        public BlastAttack blastAttack;
        public GameObject leeObject;
        public CharacterBody leeBody;

        public float numberOfHits = 10;
        public float currentNumber;
        public float interval = 0.14f;

        public void Start()
        {
            timer = 0f;
            pullTimer = 0f;
            duration = 1.6f;
            triggeredExplosion = false;

            leeBody = leeObject.GetComponent<CharacterBody>();

            //Setup Blast
            blastAttack = new BlastAttack
            {
                attacker = leeObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = position,
                radius = Modules.StaticValues.ultimateBlastRadius,
                falloffModel = BlastAttack.FalloffModel.None,
                baseDamage = (leeBody.damage * Modules.StaticValues.ultimateDamageCoefficient) / (float)Modules.StaticValues.ultimateFinalBlastHitCount,
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = leeBody.RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = 1f,
            };

            //Trigger effect.
            if (leeBody.hasEffectiveAuthority) 
            {
                EffectManager.SpawnEffect(
                Modules.ParticleAssets.ultPreExplosionProjectile,
                new EffectData
                {
                    origin = position,
                    rotation = Quaternion.identity,
                    scale = 1.25f,
                },
                true);
            }
        }

        public void Update()
        {
            timer += Time.deltaTime;
            pullTimer += Time.deltaTime;

            if (pullTimer > interval && currentNumber <= numberOfHits)
            {
                currentNumber += 1;
                pullTimer = 0f;
                new PerformForceNetworkRequest(leeBody.masterObjectId, position, Vector3.up, Modules.StaticValues.ultimateBlastRadius, 10f, 0f, 360f).Send(NetworkDestination.Clients);
            }

            if (!triggeredExplosion && timer >= duration)
            {
                triggeredExplosion = true;
                //Trigger blast

                if (leeBody.hasEffectiveAuthority)
                {
                    for (int i = 0; i < Modules.StaticValues.ultimateFinalBlastHitCount; i++) 
                    {
                        blastAttack.Fire();
                    }

                    //Trigger effect.
                    EffectManager.SpawnEffect(
                        Modules.ParticleAssets.ultExplosion,
                        new EffectData
                        {
                            origin = position,
                            rotation = Quaternion.identity,
                            scale = 1.25f,
                        },
                        true);
                }

                Destroy(this.gameObject);
            }
        }

        public void OnDestroy()
        {
            
        }
    }
}
