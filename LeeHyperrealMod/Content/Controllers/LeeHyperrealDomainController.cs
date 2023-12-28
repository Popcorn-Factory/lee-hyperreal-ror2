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
        bool energyConsuming;
        float energy;
        const float maxEnergy = 100f;
        float powerRechargeSpeed = 1f;
        float consumptionSpeed = 1f;
        

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
            energyConsuming = false;
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
                isInDomain = true;
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
    }
}
