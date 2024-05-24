using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class UltimateCameraController : MonoBehaviour
    {
        public bool enabled = false;
        public static string targetChild = "BaseTransform";
        public CharacterBody body;
        public GameObject cameraObject;
        public Animator ultimateAnimator;
        public GameObject ultimateCameraGameObject;
        public Transform previousCameraParent;

        public ModelLocator modelLocator;
        public Transform rootTransform;

        public Vector3 previousCameraPosition;
        public Quaternion previousRotation;

        //Steal the camera
        //force the camera to child object
        //Once done, unparent camera back to original position

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

            ultimateAnimator = ultimateCameraGameObject.GetComponent<Animator>();
            UltimateCameraEvent eventComponent = ultimateCameraGameObject.AddComponent<UltimateCameraEvent>();

            eventComponent.body = body;
            eventComponent.controller = this;

            try
            {
                cameraObject = Camera.main.gameObject;
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
            }
        }

        public void UnsetUltimate() 
        {
            //Force the animation back to default 
            ultimateAnimator.SetTrigger("forceUnsetUltimate");
            
            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, false);
            cameraObject.transform.localPosition = Vector3.zero;
            cameraObject.transform.localRotation = Quaternion.identity;
        }

        public void TriggerUlt()
        {
            ultimateAnimator.SetTrigger("startUltimate");
            //Store old position
            previousCameraParent = cameraObject.transform.parent;

            cameraObject.transform.SetParent(ultimateCameraGameObject.transform.GetChild(0).GetChild(0), false);
            //reset to 0
            cameraObject.transform.localPosition = Vector3.zero;
            cameraObject.transform.localRotation = Quaternion.identity;
        }

        public void OnDestroy() 
        {
            Destroy(ultimateCameraGameObject);
        }
    }
}
