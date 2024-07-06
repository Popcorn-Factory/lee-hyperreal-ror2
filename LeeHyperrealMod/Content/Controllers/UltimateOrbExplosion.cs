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
        public float duration;
        public bool triggeredExplosion;
        public Vector3 position;
        public BlastAttack blastAttack;
        public GameObject leeObject;
        public CharacterBody leeBody;

        public void Start()
        {
            timer = 0f;
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
                baseDamage = leeBody.damage * Modules.StaticValues.ultimateDamageCoefficient,
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

            if (!triggeredExplosion && timer >= duration)
            {
                triggeredExplosion = true;
                //Trigger blast

                if (leeBody.hasEffectiveAuthority) 
                {
                    blastAttack.Fire();

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
