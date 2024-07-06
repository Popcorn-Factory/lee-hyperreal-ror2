using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using Unity.Audio;
using UnityEngine;
using UnityEngine.Animations;
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

        bool followRoRCamera;
        RotationConstraint constraint;
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

            followRoRCamera = true;

            try
            {
                cameraObject = Camera.main.gameObject;
                previousCameraParent = cameraObject.transform.parent;
            }
            catch (NullReferenceException e) 
            {
                Debug.Log($"Can't grab the camera now! Attempting later.");
            }
        }

        public void Update() 
        {
            //???
            if (!cameraObject)
            {
                cameraObject = Camera.main.gameObject;
                previousCameraParent = cameraObject.transform.parent;
                ApplyConstraintRemoveParent();
            }

            if (cameraObject) 
            {
                if (followRoRCamera)
                {
                    cameraObject.transform.position = Vector3.SmoothDamp(cameraObject.transform.position, previousCameraParent.position, ref smoothDampVelocity, 0.1f, 10000f, Time.deltaTime);
                }
                else 
                {
                    cameraObject.transform.localPosition = Vector3.SmoothDamp(cameraObject.transform.localPosition, Vector3.zero, ref smoothDampVelocity, 0.2f, 100f, Time.deltaTime);
                }
            }
        }

        public void ApplyConstraintRemoveParent() 
        {
            constraint = cameraObject.GetComponent<RotationConstraint>();
            if (!constraint) 
            {
                constraint = cameraObject.AddComponent<RotationConstraint>();
            }

            constraint.AddSource
                (
                    new ConstraintSource
                    {
                        sourceTransform = previousCameraParent,
                        weight = 1.0f,
                    }
                );

            constraint.constraintActive = true;
            constraint.locked = true;

            cameraObject.transform.SetParent(null, true);
        }

        public void UnsetUltimate() 
        {
            followRoRCamera = true;
            //Force the animation back to default
            ultimateAnimator.Play("New State");
            
            //Set parent
            cameraObject.transform.SetParent(null, true);
            cameraObject.transform.localRotation = Quaternion.identity;

            cameraTargetParams.RemoveParamsOverride(handle);

            constraint.AddSource
                (
                    new ConstraintSource
                    {
                        sourceTransform = previousCameraParent,
                        weight = 1.0f,
                    }
                );

            constraint.locked = true;
            constraint.constraintActive = true;
        }

        public void UnsetDomainUltimate()
        {
            followRoRCamera = true;
            //Force the animation back to default
            domainUltimateAnimator.Play("New State");

            //Set parent
            cameraObject.transform.SetParent(null, true);
            cameraObject.transform.localRotation = Quaternion.identity;

            cameraTargetParams.RemoveParamsOverride(handle);

            constraint.AddSource
                (
                    new ConstraintSource
                    {
                        sourceTransform = previousCameraParent,
                        weight = 1.0f,
                    }
                );
            constraint.locked = true;
            constraint.constraintActive = true;
        }

        public void TriggerDomainUlt()
        {
            followRoRCamera = false;
            domainUltimateAnimator.SetTrigger("startUltimateDomain");
            constraint.RemoveSource(0);
            constraint.locked = false;
            constraint.constraintActive = false;

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
            followRoRCamera = false;
            ultimateAnimator.SetTrigger("startUltimate");
            constraint.RemoveSource(0);
            constraint.locked = false;
            constraint.constraintActive = false;

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
