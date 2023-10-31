using RoR2;
using RoR2.CharacterAI;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealUIController : MonoBehaviour
    {
        private CharacterBody characterBody;
        private CharacterMaster characterMaster;
        private GameObject canvasObject;
        public bool baseAIPresent;
        public bool enabledUI;


        #region Orb Variables
        private int maxShownOrbs = 8;
        private int startIndex = 4;
        private int endIndex = 11;
        List<Animator> orbAnimators;
        List<Image> orbImages;
        #endregion


        #region Unity MonoBehvaiour Functions
        public void Awake()
        {
            enabledUI = false;
            baseAIPresent = false;
            orbAnimators = new List<Animator>();
            orbImages = new List<Image>();
        }


        //Populate the internal variables
        public void Start()
        {
            characterBody = GetComponent<CharacterBody>();
            characterMaster = characterBody.master;
            BaseAI baseAI = characterMaster.GetComponent<BaseAI>();
            baseAIPresent = baseAI;
            Hook();


            //For some reason on goboo's first spawn the master is just not there. However subsequent spawns work.
            // Disable the UI in this event.
            // Besides, there should never be a UI element related to a non-existant master on screen if the attached master/charbody does not exist.
            if (!characterMaster) baseAIPresent = true; // Disable UI Just in case.


            canvasObject = UnityEngine.GameObject.Instantiate(Modules.Assets.uiObject);

            if (characterBody)
            {
                canvasObject.SetActive(characterBody.hasEffectiveAuthority);
            }

            //Now we need to initialize everything inside the canvas to variables we can control.
            InitializeOrbAnimatorArray();
        }

        public void Update()
        {

        }

        public void FixedUpdate()
        {
            if (characterBody.hasEffectiveAuthority)
            {
                if (!enabledUI && !baseAIPresent)
                {
                    enabledUI = true;
                    canvasObject.SetActive(true);
                }
            }
        }

        public void OnDestroy()
        {
            Destroy(canvasObject);
            Unhook();
        }
        #endregion

        #region Orb Functions

        private void InitializeOrbAnimatorArray()
        {
            // blegh not modular at all
            for (int i = startIndex; i <= endIndex; i++)
            {
                orbAnimators.Add(canvasObject.transform.GetChild(i).GetComponent<Animator>());
                orbImages.Add(canvasObject.transform.GetChild(i).GetChild(0).GetComponent<Image>());
            }
        }

        //Index is 0 indexed.
        public void PingSpecificOrb(int index) 
        {
            try
            {
                orbAnimators[index].SetTrigger("Pinged");
            }
            catch (IndexOutOfRangeException e) 
            {
                //do nothing really.
                //Mask the error.
                Debug.Log(e);
            }
        }

        public void UpdateOrbList(List<OrbController.OrbType> orbsList) 
        {
            // Go through the list
            // Determine what orbs should show using material setting.

            if (orbsList.Count != 0) 
            {
                int maxOrbCount = Mathf.Min(maxShownOrbs, orbsList.Count);

                for (int i = 0; i < maxShownOrbs; i++) 
                {
                    if (i < maxOrbCount)
                    {
                        orbImages[i].material = SelectOrbMaterial(orbsList[i]);
                        orbAnimators[i].SetTrigger("Spawn Orb");
                    }
                    else 
                    {
                        orbAnimators[i].SetTrigger("Pinged");
                    }
                }
            }
        }

        public Material SelectOrbMaterial(OrbController.OrbType orb) 
        {
            switch (orb)
            {
                case OrbController.OrbType.RED:
                    return Modules.Assets.redOrbMat;
                case OrbController.OrbType.YELLOW:
                    return Modules.Assets.yellowOrbMat;
                case OrbController.OrbType.BLUE:
                    return Modules.Assets.blueOrbMat;
            }

            //Actually impossible unless we REALLY fuck up.
            return null;
        }

        #endregion

        #region Hook
        public void Hook()
        {
            On.RoR2.CameraRigController.Update += CameraRigController_Update;
        }

        public void Unhook()
        {
            On.RoR2.CameraRigController.Update -= CameraRigController_Update;
        }

        private void CameraRigController_Update(On.RoR2.CameraRigController.orig_Update orig, CameraRigController self)
        {
            orig(self);
            //Perform a check to see if the hud is disabled and enable/disable our hud if necessary.
            if (self.hud.mainUIPanel.activeInHierarchy)
            {
                if (canvasObject && characterBody.hasEffectiveAuthority && !baseAIPresent)
                {
                    canvasObject.SetActive(true);
                }
            }
            else
            {
                if (canvasObject && characterBody.hasEffectiveAuthority)
                {
                    canvasObject.SetActive(false);
                }
            }
        }
        #endregion


    }   
}
