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
        public Transform ultimateCameraTransform;
        public GameObject ultimateCameraGameObject;
        public Transform previousCameraParent;

        public ModelLocator modelLocator;
        public Transform rootTransform;

        public Vector3 previousCameraPosition;
        public Quaternion previousRotation;

        public Vector3 smoothDampVelocity;
        public bool isCaptured;

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

            ultimateCameraTransform = ultimateCameraGameObject.transform.GetChild(0).GetChild(0);

        }

        public void Update() 
        {
            //???
            if (!cameraObject)
            {
                cameraObject = Camera.main.gameObject;
            }

            if (cameraObject) 
            {
                cameraObject.transform.localPosition = Vector3.SmoothDamp(cameraObject.transform.localPosition, Vector3.zero, ref smoothDampVelocity, 0.2f, 50f, Time.deltaTime);
            }
        }

        public void UnsetUltimate() 
        {
            isCaptured = false;
            //Force the animation back to default
            ultimateAnimator.Play("New State");
            
            //Set parent
            cameraObject.transform.SetParent(previousCameraParent, true);
            cameraObject.transform.localRotation = Quaternion.identity;
        }

        public void TriggerUlt()
        {
            ultimateAnimator.SetTrigger("startUltimate");
            isCaptured = true;
            //Store old position
            previousCameraParent = cameraObject.transform.parent;

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
