using LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate;
using RoR2;
using RoR2.CharacterAI;
using System;
using System.Collections.Generic;
using System.Text;
using Unity.Audio;
using UnityEngine;
using UnityEngine.Networking.Match;
using static RoR2.CameraTargetParams;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class UltimateCameraController : MonoBehaviour
    {
        public LeeHyperrealUIController uiController;
        public static string targetChild = "BaseTransform";
        public CharacterBody body;
        public CharacterMaster characterMaster;
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

        public float smoothDampTime = 0.2f;
        public float maxSmoothDampSpeed = 50f;

        public bool cameraStartFovAnimation = false;
        public bool cameraStartFovAnimation2 = false;
        public bool cameraAlreadyDamping2 = false;
        public bool cameraAlreadyDamping = false;
        public float cameraTimeAtStart;
        public bool baseAIPresent = false;

        public Vector3 previousCameraPosition;
        public Quaternion previousRotation;

        public Vector3 smoothDampVelocity;
        public CameraParamsOverrideHandle handle;

        public float lerpRotationInterpolationValue;
        public bool shouldRotateCamera;
        public Quaternion startRotation;
        public float stopwatch;
        public static float lerpTime = 1.25f;

        public void Awake() 
        {

        }

        public void Start() 
        {
            body = gameObject.GetComponent<CharacterBody>();
            modelLocator = gameObject.GetComponent<ModelLocator>();
            cameraTargetParams = GetComponent<CameraTargetParams>();
            uiController = GetComponent<LeeHyperrealUIController>();

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            rootTransform = childLocator.FindChild("BaseTransform");

            //Spawn object on toes.
            ultimateCameraGameObject = UnityEngine.Object.Instantiate(Modules.LeeHyperrealAssets.ultimateCameraObject, rootTransform);
            domainUltimateCameraGameObject = UnityEngine.Object.Instantiate(Modules.LeeHyperrealAssets.domainUltimateCameraObject, rootTransform);

            ultimateAnimator = ultimateCameraGameObject.transform.GetChild(0).GetComponent<Animator>();
            domainUltimateAnimator = domainUltimateCameraGameObject.GetComponent<Animator>();
            UltimateCameraEvent eventComponent = ultimateCameraGameObject.transform.GetChild(0).gameObject.AddComponent<UltimateCameraEvent>();
            UltimateCameraEvent secondEventComponent = domainUltimateCameraGameObject.AddComponent<UltimateCameraEvent>();
     
            eventComponent.controller = this;
            secondEventComponent.controller = this;

            ultimateCameraTransform = ultimateCameraGameObject.transform.GetChild(0).GetChild(0);
            domainUltimateCameraTransform = domainUltimateCameraGameObject.transform.GetChild(0);

            characterMaster = body.master;
            BaseAI baseAI = characterMaster.GetComponent<BaseAI>();
            baseAIPresent = baseAI;


            //For some reason on goboo's first spawn the master is just not there. However subsequent spawns work.
            // Disable the UI in this event.
            // Besides, there should never be a UI element related to a non-existant master on screen if the attached master/charbody does not exist.
            if (!characterMaster) baseAIPresent = true; // Disable UI Just in case.

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
                cameraObject.transform.localPosition = Vector3.SmoothDamp(cameraObject.transform.localPosition, Vector3.zero, ref smoothDampVelocity, smoothDampTime, maxSmoothDampSpeed, Time.deltaTime);
            }
            if (ultimateAnimator)
            {
                if (Time.time > cameraTimeAtStart + 2.60f && !cameraAlreadyDamping && cameraStartFovAnimation)
                {
                    cameraTargetParams.RemoveParamsOverride(handle);
                    CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
                    cameraParamsData.fov = 130f;

                    CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
                    {
                        cameraParamsData = cameraParamsData,
                        priority = 0,
                    };
                    cameraAlreadyDamping = true;
                    cameraStartFovAnimation = false;
                    handle = cameraTargetParams.AddParamsOverride(request, 0.7f);
                }
                if(Time.time > cameraTimeAtStart + 3.4f && !cameraAlreadyDamping2 && cameraStartFovAnimation2)
                {
                    cameraTargetParams.RemoveParamsOverride(handle);
                    CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
                    cameraParamsData.fov = 60f;

                    CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
                    {
                        cameraParamsData = cameraParamsData,
                        priority = 0,
                    };
                    cameraAlreadyDamping2 = true;
                    cameraStartFovAnimation2 = false;
                    handle = cameraTargetParams.AddParamsOverride(request, 0.3f);
                }
            }

            if (shouldRotateCamera) 
            {
                stopwatch += Time.deltaTime;
                cameraObject.transform.localRotation = Quaternion.Slerp(startRotation, Quaternion.identity, stopwatch / lerpTime);
                //Chat.AddMessage($"{stopwatch / lerpTime} {cameraObject.transform.localRotation}");
                if (stopwatch >= lerpTime) 
                {
                    stopwatch = 0f;
                    shouldRotateCamera = false;
                }
            }
        }

        public void UnsetUltimate() 
        {
            if (baseAIPresent)
            {
                return;
            }

            cameraAlreadyDamping = false;
            cameraAlreadyDamping2 = false;
            smoothDampTime = 0.75f;
            maxSmoothDampSpeed = 50f;
            lerpTime = 1.25f;
            //Force the animation back to default
            if (ultimateAnimator) 
            {
                ultimateAnimator.Play("New State");
            }

            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);

            cameraTargetParams.RemoveParamsOverride(handle, 0f);

            //Set after the camera Object has changed parent.
            shouldRotateCamera = true;
            startRotation = cameraObject.transform.localRotation;

            uiController.SetRORUIActiveState(true);
        }

        public void UnsetDomainUltimate()
        {
            if (baseAIPresent)
            {
                return;
            }

            cameraAlreadyDamping = false ;
            cameraAlreadyDamping2 = false;
            smoothDampTime = 0.5f;
            maxSmoothDampSpeed = 50f;
            lerpTime = 0.5f;
            shouldRotateCamera = true;

            //Force the animation back to default
            domainUltimateAnimator.Play("New State");

            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);

            cameraTargetParams.RemoveParamsOverride(handle);

            uiController.SetRORUIActiveState(true);
        }

        public void TriggerDomainUlt()
        {
            if (baseAIPresent)
            {
                return;
            }

            smoothDampTime = 0.001f;
            maxSmoothDampSpeed = 9999999f;
            domainUltimateAnimator.SetTrigger("startUltimateDomain");
            shouldRotateCamera = false;

            cameraObject.transform.SetParent(domainUltimateCameraTransform, true);
            cameraObject.transform.localRotation = Quaternion.identity;

            CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
            cameraParamsData.fov = 40f;

            CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
            {
                cameraParamsData = cameraParamsData,
                priority = 0,
            };

            uiController.SetRORUIActiveState(false);

            handle = cameraTargetParams.AddParamsOverride(request, 0.05f);
        }

        public void TriggerUlt()
        {
            if (baseAIPresent) 
            {
                return;
            }

            smoothDampTime = 0.001f;
            maxSmoothDampSpeed = 9999999f;
            ultimateAnimator.SetTrigger("startUltimate");
            cameraTimeAtStart = Time.time;
            cameraStartFovAnimation = true;
            cameraStartFovAnimation2 = true;
            shouldRotateCamera = false;

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

            handle = cameraTargetParams.AddParamsOverride(request, 0.05f);

            uiController.SetRORUIActiveState(false);
        }

        public void OnDestroy() 
        {

            Destroy(ultimateCameraGameObject);
        }
    }
}
