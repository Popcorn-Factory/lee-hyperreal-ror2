using BepInEx.Bootstrap;
using EmotesAPI;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class WeaponModelHandler : MonoBehaviour
    {
        public enum WeaponState 
        {
            SUBMACHINE,
            RIFLE,
            CANNON
        }

        private GameObject submachineModel;
        private GameObject submachine2Model;
        private GameObject guncaseModel;
        private GameObject guncaseRoot;
        private GameObject submachineRoot;

        private GameObject sniperRifleModel;
        private GameObject sniperRifleAlphaModel;
        private GameObject snipeRoot;

        private GameObject supercannonModel;
        private GameObject superCannonRoot;

        private ParticleSystem rifleFlashEffect;
        private GameObject rifleLaser;
        private ParticleSystem boxFlashEffect;

        private Animator superCannonAnimator;
        private GameObject superCannonEffect;
        private float disableCannonEffectTimer;
        private bool isCannonEnabled;

        CharacterBody characterBody;
        private WeaponState state;
        private ChildLocator childLocator;

        private bool isEmoting;

        private GameObject armModel;
        private GameObject torsoModel;
        private GameObject faceModel;
        private GameObject hairModel;
        private GameObject armourPlateModel;
        private GameObject eyeModel;
        private GameObject legModel;

        public void Awake() 
        {
            state = WeaponState.SUBMACHINE;

        }

        public void Start() 
        {
            characterBody = GetComponent<CharacterBody>();
            childLocator = GetComponentInChildren<ChildLocator>();
            if (childLocator)
            {
                submachineModel = childLocator.FindChild("PistolModel").gameObject;
                submachine2Model = childLocator.FindChild("SubMachineGunModel").gameObject;
                guncaseModel = childLocator.FindChild("GunCaseModel").gameObject;
                sniperRifleModel = childLocator.FindChild("SuperRifleModel").gameObject;
                sniperRifleAlphaModel = childLocator.FindChild("SuperRifleModelAlphaBit").gameObject;
                supercannonModel = childLocator.FindChild("SuperCannonModel").gameObject;
                superCannonAnimator = childLocator.FindChild("CannonAnimator").gameObject.GetComponent<Animator>();
                superCannonEffect = childLocator.FindChild("CannonEffect").gameObject;
                rifleFlashEffect = childLocator.FindChild("RifleFlashEffect").gameObject.GetComponent<ParticleSystem>();
                boxFlashEffect = childLocator.FindChild("BoxFlashEffect").gameObject.GetComponent<ParticleSystem>();
                rifleLaser = childLocator.FindChild("RifleLaser").gameObject;

                submachineRoot = childLocator.FindChild("SubmachineMain").gameObject;
                snipeRoot = childLocator.FindChild("RifleMain").gameObject;
                superCannonRoot = superCannonAnimator.gameObject;
                guncaseRoot = childLocator.FindChild("WeaponCase").gameObject;

                armModel = childLocator.FindChild("ArmModel").gameObject;
                torsoModel = childLocator.FindChild("TorsoModel").gameObject;
                faceModel = childLocator.FindChild("FaceModel").gameObject;
                hairModel = childLocator.FindChild("HairModel").gameObject;
                armourPlateModel = childLocator.FindChild("ArmourPlateModel").gameObject;
                eyeModel = childLocator.FindChild("EyeModel").gameObject;
                legModel = childLocator.FindChild("LegModel").gameObject;
            }

            superCannonEffect.gameObject.SetActive(false);
            SetLaserState(false);
            TransitionState(WeaponState.SUBMACHINE);
            Hook();
        }

        public void Hook() 
        {
            if (Chainloader.PluginInfos.ContainsKey("com.weliveinasociety.CustomEmotesAPI"))
            {
                SetupEmoteHook();
            }
        }

        public void Unhook() 
        {
            if (Chainloader.PluginInfos.ContainsKey("com.weliveinasociety.CustomEmotesAPI"))
            {
                UnsetEmoteHook();
            }
        }

        //Removed from normal flow as we don't want these hooks to be called if they aren't loaded in game.
        public void SetupEmoteHook() 
        {
            CustomEmotesAPI.animChanged += CustomEmotesAPI_animChanged;
        }

        //Removed from normal flow as we don't want these hooks to be called if they aren't loaded in game.
        public void UnsetEmoteHook() 
        {
            CustomEmotesAPI.animChanged -= CustomEmotesAPI_animChanged;
        }

        private void CustomEmotesAPI_animChanged(string newAnimation, BoneMapper mapper)
        {
            if (mapper != CustomEmotesAPI.localMapper) 
            {
                return;
            }

            if (newAnimation == "none") 
            {
                isEmoting = false;
                TransitionState(state);
                return;
            }

            isEmoting = true;
        }


        public void OnDestroy() 
        {
            Unhook();
        }

        public void Update()
        {
            if (isEmoting) 
            {
                DisableAll();
            }

            if (isCannonEnabled) 
            {
                disableCannonEffectTimer += Time.deltaTime;
                if (disableCannonEffectTimer >= 5f) 
                {
                    disableCannonEffectTimer = 0f;
                    isCannonEnabled = false;
                    superCannonEffect.gameObject.SetActive(false);
                    superCannonAnimator.ResetTrigger("Ultimate");
                }
            }
        }

        public void SetStateForModelAndSubmachine(bool state) 
        {
            if (armModel) 
            {
                armModel.SetActive(state);
                torsoModel.SetActive(state);
                faceModel.SetActive(state);
                hairModel.SetActive(state);
                armourPlateModel.SetActive(state);
                eyeModel.SetActive(state);
                legModel.SetActive(state);

                //Disable the submachine gun.
                guncaseModel.SetActive(state);
                submachineModel.SetActive(state);
            }
        }

        public void ActivateCannonOnAnimator() 
        {
            if (superCannonAnimator) 
            {
                superCannonEffect.gameObject.SetActive(true);
                superCannonAnimator.SetTrigger("Ultimate");

                isCannonEnabled = true;
                disableCannonEffectTimer = 0f;
            }
        }

        public void SetLaserState(bool state) 
        {
            if (rifleLaser) 
            {
                rifleLaser.SetActive(state);
            }
        }

        public WeaponState GetState() 
        {
            return state;
        }

        public void DisableAll() 
        {
            submachineModel.SetActive(false);
            submachine2Model.SetActive(false);
            guncaseModel.SetActive(false);

            sniperRifleAlphaModel.SetActive(false);
            sniperRifleModel.SetActive(false);

            supercannonModel.SetActive(false);
        
            submachineRoot.SetActive(false);
            snipeRoot.SetActive(false);
            guncaseRoot.SetActive(false);
            superCannonRoot.SetActive(false);
        }

        public void TransitionState(WeaponState newState)
        {
            if (state == WeaponState.SUBMACHINE) 
            {
                boxFlashEffect.Play();
            }

            if (state == WeaponState.RIFLE)
            {
                rifleFlashEffect.Play();
            }

            state = newState;

            submachineModel.SetActive(false);
            submachine2Model.SetActive(false);
            guncaseModel.SetActive(false);

            sniperRifleAlphaModel.SetActive(false);
            sniperRifleModel.SetActive(false);

            supercannonModel.SetActive(false);

            snipeRoot.SetActive(false);
            submachineRoot.SetActive(false);
            guncaseRoot.SetActive(false);
            superCannonRoot.SetActive(false);

            switch (state) 
            {
                case WeaponState.SUBMACHINE:
                    submachineRoot.SetActive(true);
                    guncaseRoot.SetActive(true);
                    submachineModel.SetActive(true);
                    //submachine2Model.SetActive(true);
                    guncaseModel.SetActive(true);
                    boxFlashEffect.Play();
                    break;
                case WeaponState.CANNON:
                    superCannonRoot.SetActive(true);
                    supercannonModel.SetActive(true);
                    break;
                case WeaponState.RIFLE:
                    snipeRoot.SetActive(true);
                    sniperRifleAlphaModel.SetActive(true);
                    sniperRifleModel.SetActive(true);
                    rifleFlashEffect.Play();
                    break;
            }
        }
    }
}
