﻿using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using Unity.Audio;
using UnityEngine;
using static RoR2.CameraTargetParams;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class UltimateCameraController : MonoBehaviour
    {
        public static string targetChild = "BaseTransform";
        public CharacterBody body;
        public GameObject cameraObject;
        public Animator ultimateAnimator;
        public Transform ultimateCameraTransform;
        public GameObject ultimateCameraGameObject;
        public Transform previousCameraParent;
        public CameraTargetParams cameraTargetParams;
        public Animator domainUltimateAnimator;
        public GameObject domainUltimateCameraGameObject;
        public Transform domainUltimateCameraTransform;

        public ModelLocator modelLocator;
        public Transform rootTransform;

        public Vector3 previousCameraPosition;
        public Quaternion previousRotation;

        public Vector3 smoothDampVelocity;
        public CameraParamsOverrideHandle handle;

        public void Awake() 
        {

        }

        public void Start() 
        {
            body = gameObject.GetComponent<CharacterBody>();
            modelLocator = gameObject.GetComponent<ModelLocator>();
            cameraTargetParams = GetComponent<CameraTargetParams>();

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            rootTransform = childLocator.FindChild("BaseTransform");

            //Spawn object on toes.
            ultimateCameraGameObject = UnityEngine.Object.Instantiate(Modules.Assets.ultimateCameraObject, rootTransform);
            domainUltimateCameraGameObject = UnityEngine.Object.Instantiate(Modules.Assets.domainUltimateCameraObject, rootTransform);

            ultimateAnimator = ultimateCameraGameObject.GetComponent<Animator>();
            domainUltimateAnimator = domainUltimateCameraGameObject.GetComponent<Animator>();
            UltimateCameraEvent eventComponent = ultimateCameraGameObject.AddComponent<UltimateCameraEvent>();
            UltimateCameraEvent secondEventComponent = domainUltimateCameraGameObject.AddComponent<UltimateCameraEvent>();
     
            eventComponent.controller = this;
            secondEventComponent.controller = this;

            ultimateCameraTransform = ultimateCameraGameObject.transform.GetChild(0).GetChild(0);
            domainUltimateCameraTransform = domainUltimateCameraGameObject.transform.GetChild(0);

            try
            {
                cameraObject = Camera.main.gameObject;
                previousCameraParent = cameraObject.transform.parent;
            }
            catch (NullReferenceException e) 
            {
                Debug.Log($"Should be alright: {e}");
            }
        }

        public void Update() 
        {
            //???
            if (!cameraObject)
            {
                cameraObject = Camera.main.gameObject;
                previousCameraParent = cameraObject.transform.parent;
            }

            if (cameraObject) 
            {
                cameraObject.transform.localPosition = Vector3.SmoothDamp(cameraObject.transform.localPosition, Vector3.zero, ref smoothDampVelocity, 0.2f, 50f, Time.deltaTime);
            }
        }

        public void UnsetUltimate() 
        {
            //Force the animation back to default
            if (ultimateAnimator) 
            {
                ultimateAnimator.Play("New State");
            }

            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);
            cameraObject.transform.localRotation = Quaternion.identity;

            cameraTargetParams.RemoveParamsOverride(handle);
        }

        public void UnsetDomainUltimate()
        {
            //Force the animation back to default
            domainUltimateAnimator.Play("New State");

            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);
            cameraObject.transform.localRotation = Quaternion.identity;

            cameraTargetParams.RemoveParamsOverride(handle);
        }

        public void TriggerDomainUlt()
        {
            domainUltimateAnimator.SetTrigger("startUltimateDomain");

            cameraObject.transform.SetParent(domainUltimateCameraTransform, true);
            cameraObject.transform.localRotation = Quaternion.identity;

            CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
            cameraParamsData.fov = 40f;

            CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
            {
                cameraParamsData = cameraParamsData,
                priority = 0,
            };

            handle = cameraTargetParams.AddParamsOverride(request, 0.4f);
        }

        public void TriggerUlt()
        {
            ultimateAnimator.SetTrigger("startUltimate");

            cameraObject.transform.SetParent(ultimateCameraTransform, true);
            //reset to 0
            cameraObject.transform.localRotation = Quaternion.identity;

            CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
            cameraParamsData.fov = 40f;

            CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
            {
                cameraParamsData = cameraParamsData,
                priority = 0,
            };

            handle = cameraTargetParams.AddParamsOverride(request, 0.4f);
        }

        public void OnDestroy() 
        {
            UnsetUltimate();
            Destroy(ultimateCameraGameObject);
        }
    }
}
