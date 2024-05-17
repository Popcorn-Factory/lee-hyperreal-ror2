using RoR2;
using RoR2.CharacterAI;
using RoR2.ConVar;
using RoR2.UI;
using System;
using System.Collections.Generic;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static UnityEngine.AddressableAssets.ResourceLocators.ContentCatalogData;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealUIController : MonoBehaviour
    {
        private CharacterBody characterBody;
        private CharacterMaster characterMaster;
        private GameObject canvasObject;
        private OrbController orbController;
        public bool baseAIPresent;
        public bool enabledUI;
        private float uiScale;


        #region Orb Variables
        private int maxShownOrbs = 8;
        private int startIndex = 4;
        private int endIndex = 11;
        private int orbAmountIndex = 1;
        HGTextMeshProUGUI orbAmountLabel;        
        List<Animator> orbAnimators;
        List<Image> orbImages;
        #endregion

        #region Power Meter
        private int meterindex = 15;
        private Animator meterAnimator;
        private bool isLerpingBetweenValues;
        private const float lerpSpeed = 10f;
        private float targetMeterAmount;
        private float currentMeterAmount;
        #endregion

        #region Invincibility Layer
        private GameObject layerInvincibilityHealthObject;
        private GameObject layerInvincibilityHazeObject;
        private Image invincibilityBorder;
        private int healthIndex = 2;
        private int hazeIndex = 3;
        #endregion

        #region Ammo Management
        private int bulletIndex = 1; //Starts at 1 in the power meter section
        private int endBulletIndex = 5;
        private int parryPoweredIndex = 6; // Starts at 6 in the power meter section
        private int endParryPoweredIndex = 10; // Starts at 6 in the power meter section
        private int incomingParryBulletIndex = 11;
        private int extraParryPoweredIndex = 12; // Starts at 12 in the power meter section
        private int endExtraParryPoweredIndex = 26; // Starts at 12 in the power meter section
        private int incomingExtraParryPoweredIndex = 27; // Starts at 27 in the power meter section
        List<GameObject> bulletObjects;
        List<GameObject> parryBullets;
        List<GameObject> extraParryBullets;
        GameObject IncomingParryBullet;
        GameObject IncomingExtraParryBullet;
        BulletTriggerComponent trigger;

        public struct BulletState 
        {
            public List<BulletController.BulletType> bulletTypes;
            public int parryBulletCount;
            public float bulletAnimationSpeed;
            public bool isColouredBulletMoving;
            public bool isEnhancedBulletMoving;

            public BulletState(int parryCount, List<BulletController.BulletType> types, float bulletAnimationSpeed, bool isColouredBulletMoving, bool isEnhancedBulletMoving) 
            {
                bulletTypes = types;
                parryBulletCount = parryCount;
                this.bulletAnimationSpeed = bulletAnimationSpeed;
                this.isColouredBulletMoving = isColouredBulletMoving;
                this.isEnhancedBulletMoving = isEnhancedBulletMoving;
            }
        }
        private BulletState targetBulletState;
        #endregion

        #region Domain overlay
        private GameObject domainOverlayObject;
        private bool spawnedEffect;
        #endregion

        private HGTextMeshProUGUI CreateLabel(Transform parent, string name, string text, Vector2 position, float textScale)
        {
            GameObject gameObject = new GameObject(name);
            gameObject.transform.parent = parent;
            gameObject.AddComponent<CanvasRenderer>();
            RectTransform rectTransform = gameObject.AddComponent<RectTransform>();
            HGTextMeshProUGUI hgtextMeshProUGUI = gameObject.AddComponent<HGTextMeshProUGUI>();
            hgtextMeshProUGUI.text = text;
            hgtextMeshProUGUI.fontSize = textScale;
            hgtextMeshProUGUI.color = Color.white;
            hgtextMeshProUGUI.alignment = TextAlignmentOptions.Center;
            hgtextMeshProUGUI.enableWordWrapping = false;
            rectTransform.localPosition = Vector2.zero;
            rectTransform.anchorMin = Vector2.zero;
            rectTransform.anchorMax = Vector2.one;
            rectTransform.localScale = Vector3.one;
            rectTransform.sizeDelta = Vector2.zero;
            rectTransform.anchoredPosition = position;
            return hgtextMeshProUGUI;
        }

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
            orbController = GetComponent<OrbController>();
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
            if (orbController)
            {
                UpdateOrbList(orbController.orbList);
            }

            InitializeOrbAmountLabel();

            InitializePowerMeter();
            InitializeHealthLayer();
            InitializeBulletUI();
        }

        public void Update()
        {
            if (characterBody.hasEffectiveAuthority)
            {
                if (enabledUI)
                {
                    UpdateUIScale();
                    UpdateHealthUIObject();
                    UpdateMeterLevel();
                    SetAnimatorMeterValue();
                    HandleBulletUIChange();
                }
            }
        }

        private void UpdateUIScale()
        {
            BaseConVar baseConVar = RoR2.Console.instance.FindConVar("hud_scale");
            if (baseConVar != null && TextSerialization.TryParseInvariant(baseConVar.GetString(), out uiScale)) 
            {
                // Do something. Scale all the ui elements.
            }
        }

        public void FixedUpdate()
        {
            if (characterBody.hasEffectiveAuthority)
            {
                if (!enabledUI && !baseAIPresent)
                {
                    enabledUI = true;
                    canvasObject.SetActive(true);

                    if (!spawnedEffect) 
                    {
                        domainOverlayObject = UnityEngine.Object.Instantiate(Modules.ParticleAssets.DomainOverlayEffect, Camera.main.transform);
                        domainOverlayObject.SetActive(false);
                    }
                }
            }
        }

        public void OnDestroy()
        {
            Destroy(canvasObject);
            Destroy(domainOverlayObject);
            Unhook();
        }
        #endregion

        #region Invincible Health layer
        public void InitializeHealthLayer()
        {
            layerInvincibilityHealthObject = canvasObject.transform.GetChild(healthIndex).gameObject;
            layerInvincibilityHazeObject = canvasObject.transform.GetChild(hazeIndex).gameObject;
            invincibilityBorder = layerInvincibilityHealthObject.transform.GetChild(0).gameObject.GetComponent<Image>();
        }

        public void SetActiveHealthUIObject(bool state, Color color)
        {
            layerInvincibilityHealthObject.SetActive(state);
            layerInvincibilityHazeObject.SetActive(state);
            invincibilityBorder.color = color;
        }

        public void UpdateHealthUIObject() 
        {
            if (characterBody.HasBuff(Modules.Buffs.parryBuff.buffIndex)) 
            {
                SetActiveHealthUIObject(true, Modules.StaticValues.parryInvincibility);
                return;
            }
            SetActiveHealthUIObject(characterBody.HasBuff(Modules.Buffs.invincibilityBuff) || characterBody.HasBuff(RoR2Content.Buffs.HiddenInvincibility), Modules.StaticValues.blueInvincibility);
        }
        #endregion

        #region Power Meter Functions
        private void InitializePowerMeter()
        {
            meterAnimator = canvasObject.transform.GetChild(meterindex).GetComponent<Animator>();
        }

        public void SetMeterLevel(float percentageFill)
        {
            isLerpingBetweenValues = true;

            if (percentageFill >= 1f)
            {
                targetMeterAmount = 0.999f;
                return;
            }

            if (percentageFill < 0f)
            {
                targetMeterAmount = 0f;
                return;
            }

            targetMeterAmount = percentageFill;

        }

        public void UpdateMeterLevel()
        {
            if (isLerpingBetweenValues)
            {
                if (currentMeterAmount <= targetMeterAmount)
                {
                    currentMeterAmount += Time.deltaTime * lerpSpeed;
                    if (currentMeterAmount >= targetMeterAmount)
                    {
                        currentMeterAmount = targetMeterAmount;
                        isLerpingBetweenValues = false;
                    }
                }
                if (currentMeterAmount >= targetMeterAmount)
                {
                    currentMeterAmount -= Time.deltaTime * lerpSpeed;
                    if (currentMeterAmount <= targetMeterAmount)
                    {
                        currentMeterAmount = targetMeterAmount;
                        isLerpingBetweenValues = false;
                    }
                }
            }
        }

        private void SetAnimatorMeterValue()
        {
            meterAnimator.SetFloat("bar fill", currentMeterAmount);
        }

        #endregion

        #region Orb Functions

        private void InitializeOrbAmountLabel()
        {
            Transform labeltransform = canvasObject.transform.GetChild(orbAmountIndex);
            Destroy(labeltransform.gameObject.GetComponent<Text>());
            orbAmountLabel = CreateLabel(labeltransform, "Orb Amount", "0 / 16", Vector2.zero, 24f);
        }

        public void UpdateOrbAmount(int amount, int max) 
        {
            orbAmountLabel.SetText($"{amount} / {max}");
        }

        private void InitializeOrbAnimatorArray()
        {
            // blegh not modular at all
            for (int i = startIndex; i <= endIndex; i++)
            {
                orbAnimators.Add(canvasObject.transform.GetChild(i).GetComponent<Animator>());
                orbImages.Add(canvasObject.transform.GetChild(i).GetChild(0).GetComponent<Image>());
            }

            UpdateOrbList(new List<OrbController.OrbType>());// Update with empty list.
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
            if (orbsList.Count == 0)
            {
                //Clear everything
                for (int i = 0; i < orbAnimators.Count; i++)
                {
                    orbAnimators[i].SetTrigger("Silent Clear");
                }
                return;
            }

            // Go through the list
            // Determine what orbs should show using material setting.

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
                    orbAnimators[i].SetTrigger("Silent Clear");
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
                default:
                    return null;
            }

            //Actually impossible unless we REALLY fuck up.
            return null;
        }

        #endregion

        #region Bullet UI Functions

        private void HandleBulletUIChange()
        {
            //The UI constantly checks if we should transition to the next state.
            //The issue lies in the fact that there is no gap between transitions, so now we have a situation where the bullet is consumed but never
            // triggers an update.
            // We need a way to trigger the update by checking the previous state of the UI. If the UI is outdated, force an update on the UI to show what it should actually look like.

            if (targetBulletState.parryBulletCount > 19)
            {
                IncomingExtraParryBullet.SetActive(true);
            }
            else 
            {
                IncomingExtraParryBullet.SetActive(false);
            }
            if (targetBulletState.parryBulletCount > 4)
            {
                IncomingParryBullet.SetActive(true);
            }
            else
            {
                IncomingParryBullet.SetActive(false);
            }
        }

        internal void UpdateBulletStateTarget(BulletState state) 
        {
            targetBulletState = state;

            SetFiringSpeed(state.bulletAnimationSpeed);
        }

        internal void AdvanceBulletState(BulletState state) 
        {
            targetBulletState = state;

            //Check if the state is mid animation.


            SetFiringSpeed(state.bulletAnimationSpeed);
            if (state.isColouredBulletMoving)
            {
                TriggerBulletFire();
            }
            if (state.isEnhancedBulletMoving) 
            {
                TriggerParryBulletReload();
            }
        }

        public void InitializeBulletUI()
        {
            Transform powerMeter = canvasObject.transform.GetChild(meterindex);

            //Add the Script to the animator part of the thing we want to monitor.
            trigger = powerMeter.gameObject.AddComponent<BulletTriggerComponent>();
            trigger.body = this.characterBody;
            trigger.uiController = this;

            //Initialize Bullet objects first
            bulletObjects = new List<GameObject>();
            for (int i = bulletIndex; i <= endBulletIndex; i++) 
            {
                bulletObjects.Add(powerMeter.GetChild(i).gameObject);
            }

            parryBullets = new List<GameObject>();
            for (int i = parryPoweredIndex; i <= endParryPoweredIndex; i++) 
            {
                parryBullets.Add(powerMeter.GetChild(i).gameObject);
            }

            extraParryBullets = new List<GameObject>();
            for (int i = extraParryPoweredIndex; i <= endExtraParryPoweredIndex; i++) 
            {
                extraParryBullets.Add(powerMeter.GetChild(i).gameObject);
            }

            IncomingExtraParryBullet = powerMeter.GetChild(incomingExtraParryPoweredIndex).gameObject;
            IncomingParryBullet = powerMeter.GetChild(incomingParryBulletIndex).gameObject;

            //Disable all UI elements as there are no bullets.
            foreach (GameObject bullet in bulletObjects) 
            {
                bullet.SetActive(false);
            }
            foreach (GameObject bullet in parryBullets)
            {
                bullet.SetActive(false);
            }
            foreach (GameObject bullet in extraParryBullets)
            {
                bullet.SetActive(false);
            }
            IncomingExtraParryBullet.SetActive(false);
            IncomingParryBullet.SetActive(false);
        }

        public void TriggerBulletFire() 
        {
            //Triggers the event on the animator.
            if (meterAnimator) 
            {
                meterAnimator.SetTrigger("Fire Bullet");
            }
        }

        public void TriggerParryBulletReload() 
        {
            if (meterAnimator)
            {
                meterAnimator.SetTrigger("Fire Enhance Bullet");
            }
        }

        public void SetFiringSpeed(float firingSpeed) 
        {
            if (meterAnimator)
            {
                meterAnimator.SetFloat("firing speed", firingSpeed);
            }
        }

        public void SetBulletStates(List<BulletController.BulletType> bulletTypes) 
        {
            if (meterAnimator.GetCurrentAnimatorStateInfo(1).IsName("Fire Bullet"))
            {
                return;
            }
            //Set Bullet count based on bullet input.
            if (bulletTypes.Count <= 5)
            {
                for (int i = 0; i < bulletTypes.Count; i++)
                {
                    SetBulletType(bulletObjects[i], bulletTypes[i]);
                }
            }
            else 
            {
                for (int i = 0; i < 5; i++) 
                {
                    SetBulletType(bulletObjects[i], bulletTypes[i]);
                }
            }

            //Disable the bullets that should not be seen.
            for (int i = 0; i < bulletObjects.Count; i++) 
            {
                bulletObjects[i].SetActive(i < bulletTypes.Count);
            }
        }

        public void SetBulletType(GameObject bullet, BulletController.BulletType type) 
        {
            //Order of children is red blue yellow
            switch (type) 
            {
                case BulletController.BulletType.RED:
                    bullet.SetActive(true);
                    bullet.transform.GetChild(0).gameObject.SetActive(true);
                    bullet.transform.GetChild(1).gameObject.SetActive(false);
                    bullet.transform.GetChild(2).gameObject.SetActive(false);
                    break;
                case BulletController.BulletType.BLUE:
                    bullet.SetActive(true);
                    bullet.transform.GetChild(0).gameObject.SetActive(false);
                    bullet.transform.GetChild(1).gameObject.SetActive(true);
                    bullet.transform.GetChild(2).gameObject.SetActive(false);
                    break;
                case BulletController.BulletType.YELLOW:
                    bullet.SetActive(true);
                    bullet.transform.GetChild(0).gameObject.SetActive(false);
                    bullet.transform.GetChild(1).gameObject.SetActive(false);
                    bullet.transform.GetChild(2).gameObject.SetActive(true);
                    break;
            }
        }

        public void SetEnhancedBulletState(int bulletCount)
        {
            //if (meterAnimator.GetCurrentAnimatorStateInfo(2).IsName("Fire Enhanced Ammo"))
            //{
            //    Chat.AddMessage("Bruh");
            //    return;
            //}
            if (bulletCount < 6) 
            {
                //Only enable the first 5 bullets.
                foreach (GameObject extraParryObject in extraParryBullets) 
                {
                    extraParryObject.SetActive(false);
                }

                for (int i = 0; i < parryBullets.Count; i++) 
                {
                    parryBullets[i].SetActive( i < bulletCount );
                }
                return;
            }

            //Set the bullets up with the extended stuff.
            foreach (GameObject parryBullet in parryBullets) 
            {
                parryBullet.SetActive(true);
            }

            for (int i = 0; i < extraParryBullets.Count; i++) 
            {
                extraParryBullets[i].SetActive(i < (bulletCount - 5) );
            }
        }

        public void TriggerUpdateOnEnhanced() 
        {
            SetEnhancedBulletState(targetBulletState.parryBulletCount);
        }

        public void TriggerUpdateOnColour()
        {
            SetBulletStates(targetBulletState.bulletTypes);
        }

        #endregion

        #region Domain overlay
        public void DomainOverlayEnable(bool state) 
        {
            if (domainOverlayObject) 
            {
                domainOverlayObject.SetActive(state);
            }
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
