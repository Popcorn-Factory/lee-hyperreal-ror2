using R2API.Networking;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealDomainController : MonoBehaviour
    {
        //Domain Control
        bool isInDomain;
        bool energyRegenAllowed;
        float energy;
        const float maxEnergy = 100f;
        float powerRechargeSpeed = 50f;
        float consumptionSpeed = 1f;
        int intuitionStacks = 0;

        int maxIntuitionStack = 4;

        GameObject loopDomainEffect;
        GameObject despawnDomainEffect;


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
            Transform baseTransform = childLocator.FindChild("BaseTransform");
            loopDomainEffect = UnityEngine.Object.Instantiate(Modules.ParticleAssets.domainFieldLoopEffect, baseTransform.transform);
            despawnDomainEffect = UnityEngine.Object.Instantiate(Modules.ParticleAssets.domainFieldEndEffect, baseTransform.transform);

            loopDomainEffect.SetActive(false);
            despawnDomainEffect.SetActive(false);
        }

        public void Update()
        {
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
                DisableDomain();
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

        public void DisableDomain()
        {
            isInDomain = false;
            this.energy = 0f;
            //DisableEffect?
            DisableDomainEffect();
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
        }

        public void DisableDomainEffect() 
        {
            loopDomainEffect.SetActive(false);
            despawnDomainEffect.SetActive(true);
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
