using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

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

        public Animator domainUltimateAnimator;
        public GameObject domainUltimateCameraGameObject;
        public Transform domainUltimateCameraTransform;

        public ModelLocator modelLocator;
        public Transform rootTransform;

        public Vector3 previousCameraPosition;
        public Quaternion previousRotation;

        public Vector3 smoothDampVelocity;

        public void Awake() 
        {

        }

        public void Start() 
        {
            body = gameObject.GetComponent<CharacterBody>();
            modelLocator = gameObject.GetComponent<ModelLocator>();

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            rootTransform = childLocator.FindChild("BaseTransform");

            //Spawn object on toes.
            ultimateCameraGameObject = UnityEngine.Object.Instantiate(Modules.Assets.ultimateCameraObject, rootTransform);
            domainUltimateCameraGameObject = UnityEngine.Object.Instantiate(Modules.Assets.domainUltimateCameraObject, rootTransform);

            ultimateAnimator = ultimateCameraGameObject.GetComponent<Animator>();
            domainUltimateAnimator = domainUltimateCameraGameObject.GetComponent<Animator>();
            UltimateCameraEvent eventComponent = ultimateCameraGameObject.AddComponent<UltimateCameraEvent>();
            UltimateDomainCameraEvent secondEventComponent = domainUltimateCameraGameObject.AddComponent<UltimateDomainCameraEvent>();
     
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
            ultimateAnimator.Play("New State");
            
            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);
            cameraObject.transform.localRotation = Quaternion.identity;
        }

        public void UnsetDomainUltimate()
        {
            //Force the animation back to default
            domainUltimateAnimator.Play("New State");

            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);
            cameraObject.transform.localRotation = Quaternion.identity;
        }

        public void TriggerDomainUlt()
        {
            domainUltimateAnimator.SetTrigger("startUltimateDomain");

            cameraObject.transform.SetParent(domainUltimateCameraTransform, true);
            cameraObject.transform.localRotation = Quaternion.identity;
        }

        public void TriggerUlt()
        {
            ultimateAnimator.SetTrigger("startUltimate");

            cameraObject.transform.SetParent(ultimateCameraTransform, true);
            //reset to 0
            cameraObject.transform.localRotation = Quaternion.identity;
        }

        public void OnDestroy() 
        {
            UnsetUltimate();
            Destroy(ultimateCameraGameObject);
        }
    }
}
