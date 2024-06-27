﻿using System;
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

        private GameObject sniperRifleModel;
        private GameObject sniperRifleAlphaModel;
        
        private GameObject supercannonModel;

        private Animator superCannonAnimator;
        private GameObject superCannonEffect;
        private float disableCannonEffectTimer;
        private bool isCannonEnabled;


        private WeaponState state;
        private ChildLocator childLocator;

        public void Awake() 
        {
            state = WeaponState.SUBMACHINE;

        }

        public void Start() 
        {
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
            }

            superCannonEffect.gameObject.SetActive(false);

            TransitionState(WeaponState.SUBMACHINE);
        }

        public void Update() 
        {
            //TODO:
            //Transitions

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

        public void TransitionState(WeaponState newState) 
        {
            state = newState;

            submachineModel.SetActive(false);
            submachine2Model.SetActive(false);
            guncaseModel.SetActive(false);

            sniperRifleAlphaModel.SetActive(false);
            sniperRifleModel.SetActive(false);
            
            supercannonModel.SetActive(false);

            switch (state) 
            {
                case WeaponState.SUBMACHINE:
                    submachineModel.SetActive(true);
                    submachine2Model.SetActive(true);
                    guncaseModel.SetActive(true);
                    break;
                case WeaponState.CANNON:
                    supercannonModel.SetActive(true);
                    break;
                case WeaponState.RIFLE:
                    sniperRifleAlphaModel.SetActive(true);
                    sniperRifleModel.SetActive(true);

                    break;
            }
        }
    }
}
