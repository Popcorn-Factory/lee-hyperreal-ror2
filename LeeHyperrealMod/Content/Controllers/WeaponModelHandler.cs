using BepInEx.Bootstrap;
using EmotesAPI;
using LeeHyperrealMod.Modules;
using LeeHyperrealMod.ParticleScripts;
using RoR2;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using UnityEngine;
using static RoR2.Skills.SkillFamily;

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
        LeeHyperrealPassive passive;
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


        private GameObject chestBone;
        private GameObject jetpackObj;

        private GameObject bkm;
        private GameObject yibody;
        private GameObject yicoat;

        public void Awake() 
        {
            state = WeaponState.SUBMACHINE;

        }

        public void Start() 
        {
            characterBody = GetComponent<CharacterBody>();
            passive = GetComponent<LeeHyperrealPassive>();
            childLocator = characterBody.modelLocator.modelTransform.GetComponent<ChildLocator>();

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

                chestBone = childLocator.FindChild("Chest").gameObject;

                bkm = childLocator.FindChild("BKM").gameObject;
                yibody = childLocator.FindChild("YiBody").gameObject;
                yicoat = childLocator.FindChild("YiCoat").gameObject;
            }

            ChangeLaserColour();
            ChangeFlashEffect();

            SpawnChestJetpack();
            superCannonEffect.gameObject.SetActive(false);
            SetLaserState(false);
            TransitionState(WeaponState.SUBMACHINE);
            Hook();
        }

        private void SpawnChestJetpack()
        {
            if (Modules.Survivors.LeeHyperreal.rorSkins.Contains((int)characterBody.skinIndex)) 
            {
                if (!jetpackObj) 
                {
                    jetpackObj = UnityEngine.Object.Instantiate(ParticleAssets.RetrieveParticleEffectFromSkin("skinJetpack", this.characterBody), chestBone.transform);
                }
            }
        }

        private void ChangeFlashEffect()
        {
            ParticleAssets.ParticleColorInfo color = Modules.ParticleAssets.LIGHTBLUE_PARTICLE;
            bool skip = true;

            if (passive) 
            {
                if (passive.GetVFXPassive() != LeeHyperrealPassive.VFXPassive.DEFAULT)
                {
                    switch (passive.GetVFXPassive())
                    {
                        case LeeHyperrealPassive.VFXPassive.RED:
                            color = Modules.ParticleAssets.RED_PARTICLE;
                            skip = false;
                            break;
                        case LeeHyperrealPassive.VFXPassive.ORANGE:
                            color = Modules.ParticleAssets.ORANGE_PARTICLE;
                            skip = false;
                            break;
                        case LeeHyperrealPassive.VFXPassive.YELLOW:
                            color = Modules.ParticleAssets.YELLOW_PARTICLE;
                            skip = false;
                            break;
                        case LeeHyperrealPassive.VFXPassive.GREEN:
                            color = Modules.ParticleAssets.GREEN_PARTICLE;
                            skip = false;
                            break;
                        case LeeHyperrealPassive.VFXPassive.BLUE:
                            skip = true;
                            break;
                        case LeeHyperrealPassive.VFXPassive.LIGHTBLUE:
                            color = Modules.ParticleAssets.LIGHTBLUE_PARTICLE;
                            skip = false;
                            break;
                        case LeeHyperrealPassive.VFXPassive.VIOLET:
                            color = Modules.ParticleAssets.VIOLET_PARTICLE;
                            skip = false;
                            break;
                        case LeeHyperrealPassive.VFXPassive.PINK:
                            color = Modules.ParticleAssets.PINK_PARTICLE;
                            skip = false;
                            break;
                    }
                }
                else 
                {
                    // Run default skin check
                    if (Modules.Survivors.LeeHyperreal.orangeVFXSkins.Contains((int)characterBody.skinIndex))
                    {
                        color = Modules.ParticleAssets.ORANGE_PARTICLE;
                        skip = false;
                    }

                    if (Modules.Survivors.LeeHyperreal.lightBlueVFXSkins.Contains((int)characterBody.skinIndex))
                    {
                        color = Modules.ParticleAssets.LIGHTBLUE_PARTICLE;
                        skip = false;
                    }

                    if (Modules.Survivors.LeeHyperreal.redVFXSkins.Contains((int)characterBody.skinIndex))
                    {
                        color = Modules.ParticleAssets.RED_PARTICLE;
                        skip = false;
                    }
                }
            }

            if (skip) return;

            GameObject[] objToModify = { boxFlashEffect.gameObject, rifleFlashEffect.gameObject };

            foreach (GameObject obj in objToModify) 
            {
                float intensity = Modules.ParticleAssets.GetVFXIntensity(passive.GetVFXPassive());

                Renderer[] rends = obj.GetComponentsInChildren<Renderer>();
                foreach (Renderer rend in rends)
                {
                    //Modify with the new colour on XEffect, may need more functions to convert more later
                    Modules.ParticleAssets.ModifyXEffectOnRenderer(rend, color);
                    Modules.ParticleAssets.ModifyNoBatchingRenderers(rend, color);
                }

                Light[] lights = obj.GetComponentsInChildren<Light>(true);
                foreach (Light light in lights)
                {
                    Modules.ParticleAssets.ModifyLights(light, color);
                }

                GPUParticlePlayer[] gpuPlayers = obj.GetComponentsInChildren<GPUParticlePlayer>();
                foreach (GPUParticlePlayer player in gpuPlayers)
                {
                    Modules.ParticleAssets.ModifyGPUParticles(player, color);
                }
            }
        }

        private void ChangeLaserColour()
        {
            Transform parent = rifleLaser.transform.parent;

            Destroy(rifleLaser);

            rifleLaser = GameObject.Instantiate(Modules.ParticleAssets.RetrieveParticleEffectFromSkin("rifleLaser", characterBody), parent);
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
                isEmoting = false;
                TransitionState(state);
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

            Destroy(jetpackObj);
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
                if (Modules.Survivors.LeeHyperreal.rorSkins.Contains((int)characterBody.skinIndex))
                {
                    armModel.SetActive(state);
                    torsoModel.SetActive(state);
                    faceModel.SetActive(false);
                    hairModel.SetActive(state);
                    armourPlateModel.SetActive(false);
                    eyeModel.SetActive(false);
                    legModel.SetActive(false);
                    bkm.SetActive(false);
                    yibody.SetActive(false);
                    yicoat.SetActive(false);
                    if (jetpackObj)
                    {
                        jetpackObj.SetActive(state);
                    }
                }
                else if (characterBody.skinIndex == 5) // Yi Skin
                {
                    armModel.SetActive(false);
                    torsoModel.SetActive(false);
                    faceModel.SetActive(false);
                    hairModel.SetActive(false);
                    armourPlateModel.SetActive(false);
                    eyeModel.SetActive(false);
                    legModel.SetActive(false);
                    bkm.SetActive(false);
                    yibody.SetActive(state);
                    yicoat.SetActive(state);
                }
                else if (characterBody.skinIndex == 6) 
                {
                    armModel.SetActive(false);
                    torsoModel.SetActive(false);
                    faceModel.SetActive(false);
                    hairModel.SetActive(false);
                    armourPlateModel.SetActive(false);
                    eyeModel.SetActive(false);
                    legModel.SetActive(false);
                    bkm.SetActive(state);
                    yibody.SetActive(false);
                    yicoat.SetActive(false);
                }
                else
                {
                    armModel.SetActive(state);
                    torsoModel.SetActive(state);
                    faceModel.SetActive(state);
                    hairModel.SetActive(state);
                    armourPlateModel.SetActive(state);
                    eyeModel.SetActive(state);
                    legModel.SetActive(state);
                    bkm.SetActive(false);
                    yibody.SetActive(false);
                    yicoat.SetActive(false);
                }

                guncaseModel.SetActive(state);
                submachineModel.SetActive(state);
            }
        }

        public void SetStateForModel(bool state) 
        {
            if (characterBody.skinIndex == 5) 
            {
                armModel.SetActive(false);
                torsoModel.SetActive(false);
                faceModel.SetActive(false);
                hairModel.SetActive(false);
                armourPlateModel.SetActive(false);
                eyeModel.SetActive(false);
                legModel.SetActive(false);
                bkm.SetActive(false);
                yibody.SetActive(state);
                yicoat.SetActive(state);
            }
            else if(characterBody.skinIndex == 6)
            {
                armModel.SetActive(false);
                torsoModel.SetActive(false);
                faceModel.SetActive(false);
                hairModel.SetActive(false);
                armourPlateModel.SetActive(false);
                eyeModel.SetActive(false);
                legModel.SetActive(false);
                bkm.SetActive(state);
                yibody.SetActive(false);
                yicoat.SetActive(false);
            }
            else if (armModel)
            {
                armModel.SetActive(state);
                torsoModel.SetActive(state);
                faceModel.SetActive(state);
                hairModel.SetActive(state);
                armourPlateModel.SetActive(state);
                eyeModel.SetActive(state);
                legModel.SetActive(state);
                bkm.SetActive(false);
                yibody.SetActive(false);
                yicoat.SetActive(false);
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

        public void TransitionState(WeaponState newState, bool playFlashEffect = true)
        {
            if (playFlashEffect) 
            {
                if (state == WeaponState.SUBMACHINE)
                {
                    boxFlashEffect.Play();
                }

                if (state == WeaponState.RIFLE)
                {
                    rifleFlashEffect.Play();
                }
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
                    if (playFlashEffect) 
                    {
                        boxFlashEffect.Play();
                    }
                    break;
                case WeaponState.CANNON:
                    superCannonRoot.SetActive(true);
                    supercannonModel.SetActive(true);
                    break;
                case WeaponState.RIFLE:
                    snipeRoot.SetActive(true);
                    sniperRifleAlphaModel.SetActive(true);
                    sniperRifleModel.SetActive(true);
                    if (playFlashEffect) 
                    {
                        rifleFlashEffect.Play();
                    }
                    break;
            }
        }
    }
}
