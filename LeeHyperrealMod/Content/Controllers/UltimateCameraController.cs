using LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate;
using RoR2;
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

        public float smoothDampTime = 0.2f;
        public float maxSmoothDampSpeed = 50f;

        public bool cameraAlreadyDamping2 = false;
        public bool cameraAlreadyDamping = false;
        public float cameraTimeAtStart;

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

            ultimateAnimator = ultimateCameraGameObject.transform.GetChild(0).GetComponent<Animator>();
            domainUltimateAnimator = domainUltimateCameraGameObject.GetComponent<Animator>();
            UltimateCameraEvent eventComponent = ultimateCameraGameObject.transform.GetChild(0).gameObject.AddComponent<UltimateCameraEvent>();
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
                cameraObject.transform.localPosition = Vector3.SmoothDamp(cameraObject.transform.localPosition, Vector3.zero, ref smoothDampVelocity, smoothDampTime, maxSmoothDampSpeed, Time.deltaTime);
            }
            if (ultimateAnimator)
            {
                if (Time.deltaTime > cameraTimeAtStart + 2.76f)
                {
                    if (!cameraAlreadyDamping)
                    {
                        CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
                        cameraParamsData.fov = 110f;

                        CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
                        {
                            cameraParamsData = cameraParamsData,
                            priority = 0,
                        };
                        cameraAlreadyDamping = true;
                        handle = cameraTargetParams.AddParamsOverride(request, 0.6f);
                    }
                    else
                    {

                    }
                }
                if(Time.deltaTime > cameraTimeAtStart + 3.4f && !cameraAlreadyDamping2)
                {
                    CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
                    cameraParamsData.fov = 40f;

                    CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
                    {
                        cameraParamsData = cameraParamsData,
                        priority = 0,
                    };
                    cameraAlreadyDamping2 = true;
                    handle = cameraTargetParams.AddParamsOverride(request, 0.3f);
                }
            }
        }

        public void UnsetUltimate() 
        {
            cameraAlreadyDamping = false;
            cameraAlreadyDamping2 = false;
            smoothDampTime = 0.75f;
            maxSmoothDampSpeed = 50f;
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
            cameraAlreadyDamping = false ;
            cameraAlreadyDamping2 = false;
            smoothDampTime = 0.5f;
            maxSmoothDampSpeed = 50f;
            //Force the animation back to default
            domainUltimateAnimator.Play("New State");

            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);
            cameraObject.transform.localRotation = Quaternion.identity;

            cameraTargetParams.RemoveParamsOverride(handle);
        }

        public void TriggerDomainUlt()
        {
            smoothDampTime = 0.001f;
            maxSmoothDampSpeed = 9999999f;
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
            smoothDampTime = 0.001f;
            maxSmoothDampSpeed = 9999999f;
            ultimateAnimator.SetTrigger("startUltimate");
            cameraTimeAtStart = Time.deltaTime;

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
