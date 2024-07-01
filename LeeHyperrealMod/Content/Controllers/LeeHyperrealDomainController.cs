using LeeHyperrealMod.Modules.Networking;
using R2API.Networking;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    public class LeeHyperrealDomainController : MonoBehaviour
    {
        //Domain Control
        bool isInDomain;
        bool energyRegenAllowed;
        float energy;
        const float maxEnergy = 100f;
        float powerRechargeSpeed = Modules.StaticValues.energyRechargeSpeed;
        float consumptionSpeed = Modules.StaticValues.energyConsumptionSpeed;
        int intuitionStacks = 0;

        int maxIntuitionStack = Modules.StaticValues.maxIntuitionStocks;

        Vector3 velocity;
        Transform baseTransform;

        GameObject loopDomainEffect;
        GameObject despawnDomainEffect;

        public List<GameObject> yellowOrbDomainEffects;


        //UI Controller
        private LeeHyperrealUIController uiController;

        //CharBody
        private CharacterBody charBody;

        //other shit
        private ModelLocator modelLocator;

        public void Start()
        {
            uiController = GetComponent<LeeHyperrealUIController>();
            charBody = GetComponent<CharacterBody>();
            modelLocator = gameObject.GetComponent<ModelLocator>();
            energy = 0f;
            energyRegenAllowed = true;

            ChildLocator childLocator = modelLocator.modelTransform.GetComponent<ChildLocator>();
            baseTransform = childLocator.FindChild("BaseTransform");
            loopDomainEffect = UnityEngine.Object.Instantiate(Modules.ParticleAssets.domainFieldLoopEffect, baseTransform.transform.position, Quaternion.identity);
            loopDomainEffect.transform.localScale = new Vector3(4f, 4f, 4f);
            despawnDomainEffect = UnityEngine.Object.Instantiate(Modules.ParticleAssets.domainFieldEndEffect, baseTransform.transform);

            loopDomainEffect.SetActive(false);
            despawnDomainEffect.SetActive(false);

            yellowOrbDomainEffects = new List<GameObject>();
        }

        public void Update()
        {
            if (loopDomainEffect) 
            {
                //Check each axis and determine how far they are away from the target point.
                float xDiff = Math.Abs(loopDomainEffect.transform.position.x - baseTransform.position.x);
                float yDiff = Math.Abs(loopDomainEffect.transform.position.y - baseTransform.position.y);
                float zDiff = Math.Abs(loopDomainEffect.transform.position.z - baseTransform.position.z);

                bool useX = false;
                //bool useY = false;
                bool useZ = false;

                //if X is greater than Y, use X, otherwise use Y, If the selected value is greater than Z, then use selected value. otherwise use Z
                //if (xDiff > yDiff)
                //{
                //    if (xDiff > zDiff)
                //    {
                //        useX = true;
                //    }
                //    else { useZ = true; }
                //}
                //else 
                //{
                //    if (yDiff > zDiff)
                //    {
                //        useY = true;
                //    }
                //    else { useZ = true; }
                //}

                useX = xDiff > zDiff;
                useZ = zDiff > xDiff;

                //Build the target vector based on what is prioritised.
                Vector3 target = Vector3.zero;
                if (useX) { target = new Vector3(baseTransform.position.x, baseTransform.position.y, loopDomainEffect.transform.position.z); }
                //if (useY) { target = new Vector3(loopDomainEffect.transform.position.x, baseTransform.position.y, loopDomainEffect.transform.position.z); }
                if (useZ) { target = new Vector3(loopDomainEffect.transform.position.x, baseTransform.position.y, baseTransform.position.z); }
                
                loopDomainEffect.transform.position = Vector3.SmoothDamp(loopDomainEffect.transform.position, target, ref velocity, 0.5f);
            }

            if (charBody.hasEffectiveAuthority)
            {
                // Normal stuff.
                if (!isInDomain)
                {
                    ResetIntutionStacksOnBody();
                    if (energyRegenAllowed)
                    {
                        EnergyRegen();
                    }
                }
                else
                {
                    ApplyIntutionBuffsToBody();
                    SpendEnergy(Time.deltaTime * consumptionSpeed);
                }
                UpdateUIController();
            }
        }

        private void DestroyAllYellowOrbEffects() 
        {
            foreach (GameObject obj in yellowOrbDomainEffects) 
            {
                Destroy(obj);
            }

            yellowOrbDomainEffects.Clear();
        }

        private void ApplyIntutionBuffsToBody()
        {
            charBody.ApplyBuff(Modules.Buffs.intuitionBuff.buffIndex, intuitionStacks, -1);
        }

        private void ResetIntutionStacksOnBody()
        {
            charBody.ApplyBuff(Modules.Buffs.intuitionBuff.buffIndex, 0, -1);

            // Also Set intution stacks to 0
            intuitionStacks = 0;
        }

        public void EnergyRegen()
        {
            energy += Time.deltaTime * powerRechargeSpeed;
            if (energy >= maxEnergy)
            {
                energy = maxEnergy;
            }
        }

        public void SpendEnergy(float energy)
        {
            this.energy -= energy;
            if (this.energy < 0f)
            {
                this.energy = 0f;
                DisableDomain(true);
            }
        }

        public void UpdateUIController()
        {
            if (uiController && charBody.hasEffectiveAuthority)
            {
                uiController.SetMeterLevel(energy / maxEnergy);
            }
            else if (!uiController)
            {
                uiController = GetComponent<LeeHyperrealUIController>();
            }
        }

        public void DisableDomain(bool shouldSetState)
        {
            if (shouldSetState && charBody.hasEffectiveAuthority) 
            {
                new SetDomainUltimateNetworkRequest(charBody.netId).Send(NetworkDestination.Clients);
            }
            isInDomain = false;
            this.energy = 0f;
            //DisableEffect?
            DisableDomainEffect();
            DestroyAllYellowOrbEffects();
        }

        public void EnableDomain()
        {
            isInDomain = true;

            //EnableEffect?
            EnableDomainEffect();
        }

        //Separated from base function to play on other systems.
        public void EnableDomainEffect() 
        {
            loopDomainEffect.SetActive(true);
            despawnDomainEffect.SetActive(false);
            uiController.DomainOverlayEnable(true);
            //Play Sound
            new PlaySoundNetworkRequest(charBody.netId, "Play_c_liRk4_skill_ex_timestop_loop").Send(R2API.Networking.NetworkDestination.Clients);
        }

        public void DisableDomainEffect() 
        {
            loopDomainEffect.SetActive(false);
            despawnDomainEffect.SetActive(true);
            uiController.DomainOverlayEnable(false);

            //Play Sound
            new PlaySoundNetworkRequest(charBody.netId, "Play_c_liRk4_skill_ex_timestop_end").Send(R2API.Networking.NetworkDestination.Clients);
        }

        public bool DomainEntryAllowed()
        {
            if (isInDomain)
            {
                return false;
            }
            return energy >= maxEnergy;
        }

        public bool GetDomainState()
        {
            return isInDomain;
        }

        public bool ConsumeIntuitionStacks(int amount)
        {
            if (amount > intuitionStacks)
            {
                return false;
            }

            intuitionStacks -= amount;
            return true;
        }

        public void GrantIntuitionStack(int amount)
        {
            intuitionStacks += amount;

            if (intuitionStacks > maxIntuitionStack)
            {
                intuitionStacks = maxIntuitionStack;
            }
        }

        public int GetIntuitionStacks()
        {
            return intuitionStacks;
        }

        public void OnDestroy() 
        {
            Destroy(loopDomainEffect);
            Destroy(despawnDomainEffect);
        }
    }
}
