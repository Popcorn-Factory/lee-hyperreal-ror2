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
        public List<GameObject> yellowCloneObjects;
        public List<GameObject> redCloneObjects;


        //UI Controller
        private LeeHyperrealUIController uiController;

        //CharBody
        private CharacterBody charBody;
        private SkillLocator skillLocator;
        enum UltimateIconState 
        {
            NONE,
            ULTIMATE,
            DOMAIN
        }

        private UltimateIconState iconState;


        //other shit
        private ModelLocator modelLocator;

        public float ultCooldownBeforeSwitch;
        public int ultStockBeforeSwitch;

        //Domain Aerial prefab
        public GameObject domainAerialEffect;

        public void Start()
        {
            uiController = GetComponent<LeeHyperrealUIController>();
            charBody = GetComponent<CharacterBody>();
            modelLocator = gameObject.GetComponent<ModelLocator>();
            skillLocator = gameObject.GetComponent<SkillLocator>();
            iconState = UltimateIconState.NONE;
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
            yellowCloneObjects = new List<GameObject>();
            redCloneObjects = new List<GameObject>();

            if (AkSoundEngine.IsInitialized())
            {
                AkSoundEngine.SetRTPCValue("Volume_Lee_Voice", Modules.Config.voiceVolume.Value);
            }
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

                useX = xDiff > zDiff;
                useZ = zDiff > xDiff;

                //Build the target vector based on what is prioritised.
                Vector3 target = Vector3.zero;
                if (useX) { target = new Vector3(baseTransform.position.x, baseTransform.position.y, loopDomainEffect.transform.position.z); }
                //if (useY) { target = new Vector3(loopDomainEffect.transform.position.x, baseTransform.position.y, loopDomainEffect.transform.position.z); }
                if (useZ) { target = new Vector3(loopDomainEffect.transform.position.x, baseTransform.position.y, baseTransform.position.z); }

                loopDomainEffect.transform.position = Vector3.SmoothDamp(loopDomainEffect.transform.position, target, ref velocity, 0.5f);
            }

            ChangeIconState();

            if (domainAerialEffect) 
            {

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

        public void SetupDomainAerialEffect() 
        {
            domainAerialEffect = UnityEngine.Object.Instantiate(Modules.ParticleAssets.primaryAerialDomainEffect, baseTransform);
        }

        public void DisposeDomainAerialEffect() 
        {
            domainAerialEffect.transform.SetParent(null, true);
            domainAerialEffect.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
            domainAerialEffect = null;
        }

        private void ChangeIconState()
        {
            if(skillLocator.special.stock >= 1 && GetDomainState())
            {
                SetIconState(UltimateIconState.DOMAIN);
                return;
            }

            if (skillLocator.special.stock >= 1 && !GetDomainState()) 
            {
                SetIconState(UltimateIconState.ULTIMATE);
                return;
            }

            SetIconState(UltimateIconState.NONE);
        }

        private void SetIconState(UltimateIconState incomingIconState) 
        {
            //if (iconState == incomingIconState && uiController.isInitialized) 
            //{
            //    //Do nothing
            //    return;
            //}

            iconState = incomingIconState;

            switch (iconState) 
            {
                case UltimateIconState.NONE:
                    uiController.TriggerNone();
                    break;
                case UltimateIconState.DOMAIN:
                    uiController.TriggerUltDomain();
                    break;
                case UltimateIconState.ULTIMATE:
                    uiController.TriggerUlt();
                    break;
            }
        }

        public void SetTapped() 
        {
            uiController.TriggerTappedUltIcon();
        }

        private void DestroyAllClonesAndBullets() 
        {
            foreach (GameObject obj in yellowOrbDomainEffects) 
            {
                Destroy(obj);
            }

            yellowOrbDomainEffects.Clear();

            foreach (GameObject obj in yellowCloneObjects) 
            {
                Destroy(obj);
            }

            yellowCloneObjects.Clear();

            foreach (GameObject obj in redCloneObjects) 
            {
                Destroy(obj);
            }
            redCloneObjects.Clear();
        }

        private void ApplyIntutionBuffsToBody()
        {
            charBody.ApplyBuff(Modules.Buffs.intuitionBuff.buffIndex, intuitionStacks, -1);

            uiController.SetIntuitionStacks(intuitionStacks);
        }

        private void ResetIntutionStacksOnBody()
        {
            charBody.ApplyBuff(Modules.Buffs.intuitionBuff.buffIndex, 0, -1);

            // Also Set intution stacks to 0
            intuitionStacks = 0;

            uiController.SetIntuitionStacks(intuitionStacks);
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
            DestroyAllClonesAndBullets();
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

            //Update UI
            uiController.SetIntuitionStacks(intuitionStacks);
            return true;
        }

        public void GrantIntuitionStack(int amount)
        {
            intuitionStacks += amount;

            if (intuitionStacks > maxIntuitionStack)
            {
                intuitionStacks = maxIntuitionStack;
            }

            //Update UI
            uiController.SetIntuitionStacks(intuitionStacks);
        }

        public int GetIntuitionStacks()
        {
            //Update UI
            uiController.SetIntuitionStacks(intuitionStacks);
            return intuitionStacks;
        }

        public void OnDestroy() 
        {
            Destroy(loopDomainEffect);
            Destroy(despawnDomainEffect);
        }
    }
}
