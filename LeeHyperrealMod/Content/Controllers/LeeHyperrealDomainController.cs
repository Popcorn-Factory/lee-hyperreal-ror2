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
        float consumptionSpeed = 15f;
        

        //UI Controller
        private LeeHyperrealUIController uiController;

        //CharBody
        private CharacterBody charBody;    

        public void Start()
        {
            uiController = GetComponent<LeeHyperrealUIController>();
            charBody = GetComponent<CharacterBody>();
            energy = 0f;
            energyRegenAllowed = true;
        }

        public void Update()
        {
            if (charBody.hasEffectiveAuthority) 
            {
                // Normal stuff.
                if (!isInDomain)
                {
                    if (energyRegenAllowed) 
                    {
                        EnergyRegen();
                    }
                }
                else 
                {
                    SpendEnergy(Time.deltaTime * consumptionSpeed);
                }
                UpdateUIController();
            }
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

            //DisableEffect?
        }

        public void EnableDomain() 
        {
            isInDomain = true;

            //EnableEffect?
        }

        public bool DomainEntryAllowed() 
        {
            if (isInDomain) 
            {
                return false;
            }
            return energy >= maxEnergy;
        }
    }
}
