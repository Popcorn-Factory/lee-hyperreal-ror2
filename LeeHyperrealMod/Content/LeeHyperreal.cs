using BepInEx.Configuration;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Characters;
using LeeHyperrealMod.SkillStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;
using R2API;
using RoR2;
using RoR2.CharacterAI;
using RoR2.Skills;
using System;
using System.Collections.Generic;
using UnityEngine;
using static RoR2.SkinDef;

namespace LeeHyperrealMod.Modules.Survivors
{
    internal class LeeHyperreal : SurvivorBase
    {
        public static GameObject staticBodyPrefab;
        public override string prefabBodyName => "LeeHyperreal";

        public const string PLUGIN_PREFIX = LeeHyperrealPlugin.DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_";

        public static List<int> redVFXSkins;
        public static List<int> orangeVFXSkins;
        public static List<int> lightBlueVFXSkins;
        public static List<int> voiceDisabledSkins;
        public static List<int> rorSkins;

        public override string survivorTokenPrefix => PLUGIN_PREFIX;

        public static SkillDef SnipeSkill;
        public static SkillDef ExitSnipeSkill;
        public static SkillDef EnterSnipeSkill;
        public static SkillDef ultimateSkill;
        public static SkillDef domainUltimateSkill;
        public static int glitchSkinIndex = 1;

        public static float emStr = 2f;

        public override BodyInfo bodyInfo { get; set; } = new BodyInfo
        {
            bodyName = "LeeHyperrealBody",
            bodyNameToken = PLUGIN_PREFIX + "NAME",
            subtitleNameToken = PLUGIN_PREFIX + "SUBTITLE",

            characterPortrait = Modules.Config.loreMode.Value ? LeeHyperrealAssets.mainAssetBundle.LoadAsset<Texture>("ProspectorCharacterIcon") : LeeHyperrealAssets.mainAssetBundle.LoadAsset<Texture>("LeeCharacterIcon"),
            bodyColor = Modules.StaticValues.bodyColor,
            aimOriginPosition = new Vector3(0f, 0f ,0f),

            podPrefab = Modules.LeeHyperrealAssets.leeSurvivorPod,

            maxHealth = 90f,
            shield = 30f,
            healthRegen = 1.5f,
            armor = 0f,

            shieldGrowth = 100 * 0.1f,
            jumpCount = 1,
            moveSpeed = Modules.StaticValues.baseMoveSpeed,
        };

        public override CustomRendererInfo[] customRendererInfos { get; set; } = new CustomRendererInfo[] 
        {
                new CustomRendererInfo 
                { 
                    childName = "ArmModel",
                    material = Materials.CreateHopooMaterial("leeArmMat", emStr)
                },
                new CustomRendererInfo
                {
                    childName = "TorsoModel",
                    material = Materials.CreateHopooMaterial("leeTorsoClothmat", emStr),
                },
                new CustomRendererInfo
                {
                    childName = "FaceModel",
                    material = Materials.CreateHopooMaterial("leeFaceMat", emStr),
                    ignoreOverlays = true,
                },
                new CustomRendererInfo
                {
                    childName = "HairModel",
                    material = Materials.CreateHopooMaterial("leeHairMat", emStr),
                },
                new CustomRendererInfo
                {
                    childName = "ArmourPlateModel",
                    material = Materials.CreateHopooMaterial("leeChestLegPlateMat", emStr),
                },
                new CustomRendererInfo
                {
                    childName = "EyeModel",
                    material = Materials.CreateHopooMaterial("leeEyeMat", emStr),
                    ignoreOverlays = true,
                },
                new CustomRendererInfo
                {
                    childName = "LegModel",
                    material = Materials.CreateHopooMaterial("leeLegMat", emStr),
                },
                new CustomRendererInfo
                {
                    childName = "GunCaseModel",
                    material = Materials.CreateHopooMaterial("leeBoxGunMat", emStr),
                },
                new CustomRendererInfo
                {
                    childName = "SubMachineGunModel",
                    material = Materials.CreateHopooMaterial("leeSubmachineMat", emStr),
                },
                new CustomRendererInfo 
                {
                    childName = "SuperCannonModel",
                    material = Materials.CreateHopooMaterial("Cannon", emStr),
                    ignoreOverlays = true,
                },
                new CustomRendererInfo
                {
                    childName = "SuperRifleModel",
                    material = Materials.CreateHopooMaterial("leeSuperRifleMat", emStr),
                },
                new CustomRendererInfo
                {
                    childName = "SuperRifleModelAlphaBit",
                },
                new CustomRendererInfo
                {
                    childName = "PistolModel",
                    material = Materials.CreateHopooMaterial("leePistolMat", emStr),
                },
                new CustomRendererInfo
                {
                    childName = "BKM",
                    material = Materials.CreateHopooMaterial("boy", emStr)
                },
                new CustomRendererInfo
                {
                    childName = "YiBody",
                    material = Materials.CreateHopooMaterial("yiMat", emStr)
                },
                new CustomRendererInfo
                {
                    childName = "YiCoat",
                    material = Materials.CreateHopooMaterial("yiMat", emStr)
                }
        };

        public override UnlockableDef characterUnlockableDef => null;

        public override Type characterMainState => typeof(LeeHyperrealCharacterMain);

        public override Type characterDeathState => typeof(LeeHyperrealDeathState);

        public override Type characterSpawnState => base.characterSpawnState;

        public override ItemDisplaysBase itemDisplays => new LeeHyperrealItemDisplays();

                                                                          //if you have more than one character, easily create a config to enable/disable them like this
        public override ConfigEntry<bool> characterEnabledConfig => null; //Modules.Config.CharacterEnableConfig(bodyName);

        private static UnlockableDef masterySkinUnlockableDef;

        public override void InitializeCharacter()
        {
            base.InitializeCharacter();

            if (AkSoundEngine.IsInitialized())
            {
                AkSoundEngine.SetRTPCValue("Volume_Lee_Voice", Modules.Config.voiceVolume.Value);
            }

            bodyPrefab.AddComponent<LeeHyperrealUIController>();
            bodyPrefab.AddComponent<OrbController>();
            bodyPrefab.AddComponent<LeeHyperrealDomainController>();
            bodyPrefab.AddComponent<ParryMonitor>();
            bodyPrefab.AddComponent<BulletController>();
            bodyPrefab.AddComponent<WeaponModelHandler>();
            bodyPrefab.AddComponent<UltimateCameraController>();
            bodyPrefab.AddComponent<GlitchOverlayController>();
            bodyPrefab.AddComponent<LeeHyperrealDeathMonitor>();
            staticBodyPrefab = bodyPrefab;
        }

        public override void InitializeDoppelganger(string clone)
        {
            GameObject newMasterGameObject = PrefabAPI.InstantiateClone(RoR2.LegacyResourcesAPI.Load<GameObject>("Prefabs/CharacterMasters/" + clone + "MonsterMaster"), bodyInfo.bodyName + "MonsterMaster", true);
            CharacterMaster master = newMasterGameObject.GetComponent<CharacterMaster>();
            master.bodyPrefab = bodyPrefab;

            //Set AI Skill Drivers

            AISkillDriver[] drivers = master.GetComponents<AISkillDriver>();
            foreach (AISkillDriver driver in drivers)
            {
                UnityEngine.Object.DestroyImmediate(driver);
            }

            //Fire as much as possible in range.
            AISkillDriver armamentBarrage = master.gameObject.AddComponent<AISkillDriver>();
            armamentBarrage.customName = "Lee: Hyperreal - Armament Barrage";
            armamentBarrage.skillSlot = SkillSlot.Primary;
            armamentBarrage.requireSkillReady = true;
            armamentBarrage.requireEquipmentReady = false;
            armamentBarrage.minDistance = 0;
            armamentBarrage.maxDistance = 10f;
            armamentBarrage.selectionRequiresAimTarget = true;
            armamentBarrage.selectionRequiresOnGround = false;
            armamentBarrage.selectionRequiresAimTarget = true;
            armamentBarrage.moveTargetType = AISkillDriver.TargetType.CurrentEnemy;
            armamentBarrage.activationRequiresTargetLoS = true;
            armamentBarrage.activationRequiresAimTargetLoS = true;
            armamentBarrage.activationRequiresAimConfirmation = true;
            armamentBarrage.movementType = AISkillDriver.MovementType.ChaseMoveTarget;
            armamentBarrage.buttonPressType = AISkillDriver.ButtonPressType.TapContinuous;
            armamentBarrage.aimType = AISkillDriver.AimType.AtCurrentEnemy;
            armamentBarrage.resetCurrentEnemyOnNextDriverSelection = true;

            AISkillDriver snipeSkill = master.gameObject.AddComponent<AISkillDriver>();
            snipeSkill.customName = "Lee: Hyperreal - Snipe";
            snipeSkill.skillSlot = SkillSlot.Primary;
            snipeSkill.requireSkillReady = true;
            snipeSkill.requireEquipmentReady = false;
            snipeSkill.minDistance = 50f;
            snipeSkill.maxDistance = 150f;
            snipeSkill.selectionRequiresAimTarget = true;
            snipeSkill.selectionRequiresOnGround = false;
            snipeSkill.selectionRequiresAimTarget = true;
            snipeSkill.moveTargetType = AISkillDriver.TargetType.CurrentEnemy;
            snipeSkill.activationRequiresTargetLoS = true;
            snipeSkill.activationRequiresAimTargetLoS = true;
            snipeSkill.activationRequiresAimConfirmation = true;
            snipeSkill.movementType = AISkillDriver.MovementType.ChaseMoveTarget;
            snipeSkill.buttonPressType = AISkillDriver.ButtonPressType.TapContinuous;
            snipeSkill.aimType = AISkillDriver.AimType.AtCurrentEnemy;
            snipeSkill.resetCurrentEnemyOnNextDriverSelection = true;

            ////Always fire when at a distance away from the player.
            AISkillDriver snipeStance = master.gameObject.AddComponent<AISkillDriver>();
            snipeStance.customName = "Lee: Snipe Stance";
            snipeStance.skillSlot = SkillSlot.Secondary;
            snipeStance.requireSkillReady = true;
            snipeStance.requireEquipmentReady = false;
            snipeStance.minDistance = 50f;
            snipeStance.maxDistance = 150f;
            snipeStance.selectionRequiresAimTarget = true;
            snipeStance.selectionRequiresOnGround = false;
            snipeStance.selectionRequiresAimTarget = true;
            snipeStance.moveTargetType = AISkillDriver.TargetType.CurrentEnemy;
            snipeStance.activationRequiresTargetLoS = true;
            snipeStance.activationRequiresAimTargetLoS = true;
            snipeStance.activationRequiresAimConfirmation = true;
            snipeStance.movementType = AISkillDriver.MovementType.Stop;
            snipeStance.buttonPressType = AISkillDriver.ButtonPressType.Hold;
            snipeStance.aimType = AISkillDriver.AimType.AtCurrentEnemy;
            snipeStance.resetCurrentEnemyOnNextDriverSelection = true;

            AISkillDriver dodge = master.gameObject.AddComponent<AISkillDriver>();
            dodge.customName = "Lee: hyperreal dodge";
            dodge.skillSlot = SkillSlot.Utility;
            dodge.requireSkillReady = true;
            dodge.requireEquipmentReady = false;
            dodge.minDistance = 0f;
            dodge.maxDistance = 20f;
            dodge.selectionRequiresAimTarget = true;
            dodge.selectionRequiresOnGround = false;
            dodge.selectionRequiresAimTarget = true;
            dodge.moveTargetType = AISkillDriver.TargetType.CurrentEnemy;
            dodge.activationRequiresTargetLoS = true;
            dodge.activationRequiresAimTargetLoS = true;
            dodge.activationRequiresAimConfirmation = true;
            dodge.movementType = AISkillDriver.MovementType.StrafeMovetarget;
            dodge.aimType = AISkillDriver.AimType.AtCurrentEnemy;
            dodge.buttonPressType = AISkillDriver.ButtonPressType.TapContinuous;
            dodge.resetCurrentEnemyOnNextDriverSelection = true;
            dodge.maxTimesSelected = 2;
            //cleanse.noRepeat = true;

            AISkillDriver ult = master.gameObject.AddComponent<AISkillDriver>();
            ult.customName = "Lee: Fire Ult";
            ult.skillSlot = SkillSlot.Special;
            ult.requireSkillReady = true;
            ult.requireEquipmentReady = false;
            ult.minDistance = 2f;
            ult.maxDistance = float.PositiveInfinity;
            ult.selectionRequiresAimTarget = true;
            ult.selectionRequiresOnGround = false;
            ult.moveTargetType = AISkillDriver.TargetType.CurrentEnemy;
            ult.activationRequiresTargetLoS = true;
            ult.activationRequiresAimTargetLoS = true;
            ult.activationRequiresAimConfirmation = true;
            ult.movementType = AISkillDriver.MovementType.StrafeMovetarget;
            ult.buttonPressType = AISkillDriver.ButtonPressType.TapContinuous;
            ult.resetCurrentEnemyOnNextDriverSelection = true;
            ult.aimType = AISkillDriver.AimType.AtCurrentEnemy;
            ult.maxTimesSelected = 1;

            //Setup AI
            AISkillDriver flee = master.gameObject.AddComponent<AISkillDriver>();
            flee.customName = "Lee: Keep short distance away from enemies";
            flee.skillSlot = SkillSlot.None;
            flee.requireSkillReady = false;
            flee.requireEquipmentReady = false;
            flee.shouldSprint = true;
            flee.maxDistance = 5f;
            flee.minDistance = 0f;
            flee.selectionRequiresAimTarget = false;
            flee.selectionRequiresOnGround = false;
            flee.selectionRequiresAimTarget = false;
            flee.moveTargetType = AISkillDriver.TargetType.CurrentEnemy;
            flee.moveInputScale = 1f;
            flee.activationRequiresTargetLoS = true;
            flee.activationRequiresAimTargetLoS = true;
            flee.activationRequiresAimConfirmation = true;
            flee.movementType = AISkillDriver.MovementType.FleeMoveTarget;
            flee.buttonPressType = AISkillDriver.ButtonPressType.Abstain;
            flee.resetCurrentEnemyOnNextDriverSelection = true;

            AISkillDriver FIND = master.gameObject.AddComponent<AISkillDriver>();
            FIND.customName = "Lee: Find enemies to chase";
            FIND.skillSlot = SkillSlot.None;
            FIND.requireSkillReady = false;
            FIND.requireEquipmentReady = false;
            FIND.minDistance = 0f;
            FIND.maxDistance = float.PositiveInfinity;
            FIND.shouldSprint = true;
            FIND.selectionRequiresAimTarget = false;
            FIND.selectionRequiresOnGround = false;
            FIND.selectionRequiresAimTarget = false;
            FIND.moveTargetType = AISkillDriver.TargetType.CurrentEnemy;
            FIND.moveInputScale = 1f;
            FIND.activationRequiresTargetLoS = false;
            FIND.activationRequiresAimTargetLoS = false;
            FIND.activationRequiresAimConfirmation = false;
            FIND.movementType = AISkillDriver.MovementType.ChaseMoveTarget;
            FIND.buttonPressType = AISkillDriver.ButtonPressType.Abstain;
            FIND.resetCurrentEnemyOnNextDriverSelection = false;

            Modules.Content.AddMasterPrefab(newMasterGameObject);
        }

        public override void InitializeUnlockables()
        {
            //uncomment this when you have a mastery skin. when you do, make sure you have an icon too
            //masterySkinUnlockableDef = Modules.Unlockables.AddUnlockable<Modules.Achievements.MasteryAchievement>();
        }

        public override void InitializeHitboxes()
        {
            ChildLocator childLocator = bodyPrefab.GetComponentInChildren<ChildLocator>();

            //example of how to create a hitbox
            Modules.Prefabs.SetupHitbox(prefabCharacterModel.gameObject, childLocator.FindChild("ShortMeleeAttackHitbox"), "ShortMelee");
            Modules.Prefabs.SetupHitbox(prefabCharacterModel.gameObject, childLocator.FindChild("LongMeleeAttackHitbox"), "LongMelee");
            Modules.Prefabs.SetupHitbox(prefabCharacterModel.gameObject, childLocator.FindChild("AOEAttackHitbox"), "AOEMelee");
            Modules.Prefabs.SetupHitbox(prefabCharacterModel.gameObject, childLocator.FindChild("RedOrb1PingHitbox"), "Red1Ping");
            Modules.Prefabs.SetupHitbox(prefabCharacterModel.gameObject, childLocator.FindChild("RedOrb3PingHitbox"), "Red3Ping");
            Modules.Prefabs.SetupHitbox(prefabCharacterModel.gameObject, childLocator.FindChild("Primary2Hitbox"), "Primary2");
        }
        
        public override void InitializeSkills()
        {
            LeeHyperrealPassive passive = bodyPrefab.AddComponent<LeeHyperrealPassive>();
            Modules.Skills.CreateSkillFamilies(bodyPrefab, true);

            if (LeeHyperrealPlugin.isControllerCheck)
            {
                Modules.Skills.CreateExtraSkillFamilies(bodyPrefab, false);
            }
            string prefix = LeeHyperrealPlugin.DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_";

            #region Passive
            passive.orbAndBulletPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_ORB_AND_AMMO_NAME",
                skillNameToken = prefix + "PASSIVE_ORB_AND_AMMO_NAME",
                skillDescriptionToken = prefix + "PASSIVE_ORB_AND_AMMO_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Passive Orb Bullets"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { $"{prefix}KEYWORD_ORBS", $"{prefix}KEYWORD_AMMO" }
            });

            passive.hypermatrixPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_DOMAIN_NAME",
                skillNameToken = prefix + "PASSIVE_DOMAIN_NAME",
                skillDescriptionToken = prefix + "PASSIVE_DOMAIN_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Passive Hypermatrix"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { $"{prefix}KEYWORD_DOMAIN", $"{prefix}KEYWORD_POWER_GAUGE" }
            });

            Modules.Skills.AddPassiveSkills(passive.orbPassiveSkillSlot.skillFamily, new SkillDef[]{
                passive.orbAndBulletPassive
            });
            Modules.Skills.AddPassiveSkills(passive.hypermatrixPassiveSkillSlot.skillFamily, new SkillDef[]{
                passive.hypermatrixPassive
            });
            #endregion

            #region VFX Colors
            passive.defaultVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_DEFAULT_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_DEFAULT_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_DEFAULT_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconDefault"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.redVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_RED_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_RED_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_RED_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconRed"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.orangeVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_ORANGE_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_ORANGE_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_ORANGE_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconOrange"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.yellowVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_YELLOW_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_YELLOW_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_YELLOW_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconYellow"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.greenVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_GREEN_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_GREEN_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_GREEN_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconGreen"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.blueVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_BLUE_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_BLUE_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_BLUE_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconBlue"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.lightBlueVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_LIGHTBLUE_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_LIGHTBLUE_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_LIGHTBLUE_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconLightBlue"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.violetVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_VIOLET_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_VIOLET_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_VIOLET_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconViolet"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            passive.pinkVFXPassive = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PASSIVE_PINK_VFX_NAME",
                skillNameToken = prefix + "PASSIVE_PINK_VFX_NAME",
                skillDescriptionToken = prefix + "PASSIVE_PINK_VFX_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("VFXIconPink"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                keywordTokens = new string[] { }
            });
            Modules.Skills.AddPassiveSkills(passive.VFXColorPassiveSkillSlot.skillFamily, new SkillDef[] {
                passive.defaultVFXPassive,
            });
            
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.redVFXPassive, Unlockables.scarletUnlockableDef);
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.orangeVFXPassive, Unlockables.masteryUnlockableDef);
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.yellowVFXPassive, Unlockables.yellowVFXUnlockableDef);
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.greenVFXPassive, Unlockables.greenVFXUnlockableDef);
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.blueVFXPassive, null);
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.lightBlueVFXPassive, Unlockables.blueSkinUnlockableDef);
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.violetVFXPassive, Unlockables.violetVFXUnlockableDef);
            Modules.Skills.AddSkillToFamily(passive.VFXColorPassiveSkillSlot.skillFamily, passive.pinkVFXPassive, Unlockables.pinkVFXUnlockableDef);
            #endregion

            #region Primary
            //Creates a skilldef for a typical primary 
            SkillDef primarySkillDef = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PRIMARY_NAME",
                skillNameToken = prefix + "PRIMARY_NAME",
                skillDescriptionToken = prefix + "PRIMARY_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Primary"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.PrimaryEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 0f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 0,
                requiredStock = 0,
                stockToConsume = 0,
                keywordTokens = new string[] { $"{prefix}KEYWORD_PARRY" }
            });

            Modules.Skills.AddPrimarySkills(bodyPrefab, primarySkillDef);
            #endregion

            #region Secondary
            SnipeSkill = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "SECONDARY_SNIPE_NAME",
                skillNameToken = prefix + "SECONDARY_SNIPE_NAME",
                skillDescriptionToken = prefix + "SECONDARY_SNIPE_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Snipe Primary"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Secondary.Snipe)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 1f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = false,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                autoHandleLuminousShot = false,
                keywordTokens = new string[] { $"{prefix}KEYWORD_SNIPE_STANCE" }
            });

            ExitSnipeSkill = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "EXIT_SNIPE_NAME",
                skillNameToken = prefix + "EXIT_SNIPE_NAME",
                skillDescriptionToken = prefix + "EXIT_SNIPE_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Exit Snipe"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Secondary.ExitSnipe)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 1f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = false,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                autoHandleLuminousShot = false,
                keywordTokens = new string[] { $"{prefix}KEYWORD_SNIPE_STANCE" }
            });

            EnterSnipeSkill = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "ENTER_SNIPE_NAME",
                skillNameToken = prefix + "ENTER_SNIPE_NAME",
                skillDescriptionToken = prefix + "ENTER_SNIPE_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Snipe Shot"),                
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Secondary.EnterSnipe)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 1f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Skill,
                resetCooldownTimerOnUse = false,
                isCombatSkill = false,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1,
                autoHandleLuminousShot = false,
                keywordTokens = new string[] { $"{prefix}KEYWORD_SNIPE_STANCE" }
            });

            Modules.Skills.AddSecondarySkills(bodyPrefab, EnterSnipeSkill);
            #endregion

            #region Utility
            SkillDef dashSkillDef = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "DASH_NAME",
                skillNameToken = prefix + "DASH_NAME",
                skillDescriptionToken = prefix + "DASH_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Dodge"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(Evade)),
                activationStateMachineName = "Body",
                baseMaxStock = 5,
                baseRechargeInterval = 5f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = true,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Frozen,
                resetCooldownTimerOnUse = false,
                isCombatSkill = false,
                mustKeyPress = true,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1
            });

            Modules.Skills.AddUtilitySkills(bodyPrefab, dashSkillDef);
            #endregion

            #region Special
            ultimateSkill = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "ULTIMATE_NAME",
                skillNameToken = prefix + "ULTIMATE_NAME",
                skillDescriptionToken = prefix + "ULTIMATE_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Ultimate"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Ultimate.UltimateEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 10,
                baseRechargeInterval = 6f,
                beginSkillCooldownOnSkillEnd = true,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Frozen,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = true,
                rechargeStock = 1,
                requiredStock = 10,
                stockToConsume = 10,
                keywordTokens = new string[] { $"{prefix}KEYWORD_DOMAIN_ULT" }
            });

            domainUltimateSkill = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "ULTIMATE_DOMAIN_NAME",
                skillNameToken = prefix + "ULTIMATE_DOMAIN_NAME",
                skillDescriptionToken = prefix + "ULTIMATE_DOMAIN_DESCRIPTION",
                skillIcon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("Domain Ultimate"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Ultimate.UltimateEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 40f, //instantly triggerable but only in the powered state.
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Frozen,
                resetCooldownTimerOnUse = false,
                isCombatSkill = true,
                mustKeyPress = true,
                cancelSprintingOnActivation = true,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1
            });

            Modules.Skills.AddSpecialSkills(bodyPrefab, ultimateSkill);
            #endregion
        }

        public override void InitializeSkins()
        {
            ModelSkinController skinController = prefabCharacterModel.gameObject.GetComponent<ModelSkinController>();
            if (!skinController) 
            {
                skinController = prefabCharacterModel.gameObject.AddComponent<ModelSkinController>();
            }

            ChildLocator childLocator = prefabCharacterModel.GetComponent<ChildLocator>();

            CharacterModel.RendererInfo[] defaultRendererinfos = prefabCharacterModel.baseRendererInfos;

            List<SkinDef> skins = new List<SkinDef>();

            #region DefaultSkin
            //this creates a SkinDef with all default fields
            SkinDef defaultSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "DEFAULT_SKIN_NAME",
                LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("texMainSkin"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject);

            //these are your Mesh Replacements. The order here is based on your CustomRendererInfos from earlier
            //pass in meshes as they are named in your assetbundle
            defaultSkin.skinDefParams.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                "leeArmsMeshBlend",
                "leeTorsoClothMeshBlend",
                "leeFaceMeshBlend",
                "leeHairMeshBlend",
                "leeChestLegPlateMeshBlend",
                "leeEyeMeshBlend",
                "leeLegsMeshBlend",
                "leeGunCaseMeshBlend",
                "leePistolMeshBlend",
                "E3SuperlicannonMd010011",
                "leeSuperRifleMeshBlend",
                "leeSuperRilfeAlphaMeshBlend",
                "leeSubMachineGunMeshBlend",
                "BoyKisserMesh",
                "YiMesh",
                "YiCoat"
            );

            defaultSkin.skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[]
            {
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("TorsoModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("FaceModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("HairModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmourPlateModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("EyeModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("LegModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("BKM"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiBody"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiCoat"),
                    shouldActivate = false,
                }
            };
            #endregion

            //uncomment this when you have a mastery skin
            #region BlueSkin

            //creating a new skindef as we did before
            SkinDef blueSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "ALT_SKIN_NAME",
                LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("texCloneSkin"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject, 
                Unlockables.blueSkinUnlockableDef);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            blueSkin.skinDefParams.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                "leeArmsMeshBlend",
                "leeTorsoClothMeshBlend",
                "leeFaceMeshBlend",
                "leeHairMeshBlend",
                "leeChestLegPlateMeshBlend",
                "leeEyeMeshBlend",
                "leeLegsMeshBlend",
                "leeGunCaseMeshBlend",
                "leePistolMeshBlend",
                "E3SuperlicannonMd010011",
                "leeSuperRifleMeshBlend",
                "leeSuperRilfeAlphaMeshBlend",
                "leeSubMachineGunMeshBlend",
                "BoyKisserMesh",
                "YiMesh",
                "YiCoat"
            );

            //masterySkin has a new set of RendererInfos (based on default rendererinfos)
            //you can simply access the RendererInfos defaultMaterials and set them to the new materials for your skin.
            string[] materialStrings = 
                { 
                    "skinCloneBody", 
                    "skinCloneCloth", 
                    "skinCloneFace", 
                    "skinCloneHair", 
                    "skinCloneAlpha", 
                    "skinCloneEye", 
                    "skinCloneDown", 
                    "skinCloneSuperBox", 
                    "skinClonePistol", 
                    "skinCloneCannon",
                    "skinCloneRifle", 
                    null, 
                    "skinClonePistol",
                    null,
                    null,
                    null
                };

            for (int i = 0; i < materialStrings.Length; i++) 
            {
                if (materialStrings[i] == null)
                {
                    blueSkin.skinDefParams.rendererInfos[i].defaultMaterial = defaultRendererinfos[i].defaultMaterial;
                }
                else 
                {
                    blueSkin.skinDefParams.rendererInfos[i].defaultMaterial = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>(materialStrings[i]);
                }
            }

            //simply find an object on your child locator you want to activate/deactivate and set if you want to activate/deacitvate it with this skin
            blueSkin.skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[]
            {
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("TorsoModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("FaceModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("HairModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmourPlateModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("EyeModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("LegModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("BKM"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiBody"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiCoat"),
                    shouldActivate = false,
                }
            };

            #endregion

            #region Scarlet Redeemer

            //creating a new skindef as we did before
            SkinDef scarletSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "SCARLET_SKIN_NAME",
                LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("texScarletSkin"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject,
                Unlockables.scarletUnlockableDef);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            scarletSkin.skinDefParams.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                "R4LiangMd019011Body",
                "R4LiangMd019011Cloth",
                "leeFaceMeshBlend",
                "R4LiangMd019011Hair",
                "R4LiangMd019011Alpha",
                "leeEyeMeshBlend",
                "R4LiangMd019011Down",
                "E3SuperliboxMd030011",
                "E3SuperligunMd030011.001",
                "E3SuperlicannonMd010011",
                "E3SuperlirifleMd030011",
                null,
                "E3SuperligunMd030011",
                "BoyKisserMesh",
                "YiMesh",
                "YiCoat");

            //masterySkin has a new set of RendererInfos (based on default rendererinfos)
            //you can simply access the RendererInfos defaultMaterials and set them to the new materials for your skin.
            string[] scarletMaterialStrings =
                {
                    "scarletUpper",
                    "scarletUpper",
                    null,
                    null,
                    "scarletLower",
                    null,
                    "scarletLower",
                    "scarletBox",
                    "scarletSemiGun",
                    null,
                    "scarletSemiGun",
                    null,
                    "scarletSemiGun",
                    null,
                    null,
                    null
                };

            for (int i = 0; i < scarletMaterialStrings.Length; i++)
            {
                if (scarletMaterialStrings[i] == null)
                {
                    scarletSkin.skinDefParams.rendererInfos[i].defaultMaterial = defaultRendererinfos[i].defaultMaterial;
                }
                else
                {
                    scarletSkin.skinDefParams.rendererInfos[i].defaultMaterial = Materials.CreateHopooMaterial(scarletMaterialStrings[i], 2.5f);
                }
            }

            scarletSkin.skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[]
            {
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("TorsoModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("FaceModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("HairModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmourPlateModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("EyeModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("LegModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("BKM"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiBody"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiCoat"),
                    shouldActivate = false,
                }
            };
            #endregion

            #region Prospector

            //creating a new skindef as we did before
            SkinDef prospectorSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "PROSPECTOR_SKIN_NAME",
                LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("ProspectorSkinIcon"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            prospectorSkin.skinDefParams.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                "LeeRor2Heart",
                "LeeRor2ProspectorCloth",
                "leeFaceMeshBlend",
                "LeeRor2Head",
                "leeChestLegPlateMeshBlend",
                "leeEyeMeshBlend",
                "leeLegsMeshBlend",
                "LeeRor2ProspectorBoxMesh",
                "LeeRor2ProspectorBoxPistolMesh",
                "LeeRor2ProspsectorCannonMesh",
                "LeeRor2ProspectorRifleMesh",
                "leeSuperRilfeAlphaMeshBlend",
                "LeeRor2ProspectorPistolMesh",
                "BoyKisserMesh",
                "YiMesh",
                "YiCoat"
            );


            /*
                    "leeArmMat",
                    "leeTorsoClothmat", 
                    "leeFaceMat", no replacement
                    "leeHairMat", material replacement only
                    "leeChestLegPlateMat", 
                    "leeEyeMat", no replacement
                    "leeLegMat", 
                    "leeBoxGunMat", no replacement
                    "leeSubmachineMat", no replacement
                    "Cannon", no replacement
                    "leeSuperRifleMat",
                    some alpha bit
                    "leePistolMat" no replacement
             */


            //masterySkin has a new set of RendererInfos (based on default rendererinfos)
            //you can simply access the RendererInfos defaultMaterials and set them to the new materials for your skin.
            string[] prospectorMaterialStrings =
                {
                    "LeeRor2ProspectorPalette",
                    "LeeRor2ProspectorPalette",
                    "LeeRor2ProspectorPalette",
                    "LeeRor2ProspectorPalette",
                    "LeeRor2ProspectorPalette",
                    "LeeRor2ProspectorPalette",
                    "LeeRor2ProspectorPalette",
                    "LeeRoR2ProspectorWeaponPalette",
                    "LeeRoR2ProspectorWeaponPalette",
                    "LeeRoR2ProspectorWeaponPalette",
                    "LeeRoR2ProspectorWeaponPalette",
                    "LeeRor2ProspectorPalette",
                    "LeeRoR2ProspectorWeaponPalette",
                    null,
                    null,
                    null
                };

            for (int i = 0; i < prospectorMaterialStrings.Length; i++)
            {
                if (prospectorMaterialStrings[i] == null)
                {
                    prospectorSkin.skinDefParams.rendererInfos[i].defaultMaterial = defaultRendererinfos[i].defaultMaterial;
                }
                else
                {
                    prospectorSkin.skinDefParams.rendererInfos[i].defaultMaterial = Materials.CreateHopooMaterial(prospectorMaterialStrings[i], emStr);
                }
            }

            //here's a barebones example of using gameobjectactivations that could probably be streamlined or rewritten entirely, truthfully, but it works

            /*
                "ArmModel"
                "TorsoModel"
                "FaceModel"
                "HairModel"
                "ArmourPlateModel"
                "EyeModel"
                "LegModel"
                "GunCaseModel"
                "SubMachineGunModel"
                "SuperCannonModel"
                "SuperRifleModel"
                "SuperRifleModelAlphaBit"
                "PistolModel"
             */
            prospectorSkin.skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[]
            {
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("TorsoModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("FaceModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("HairModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmourPlateModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("EyeModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("LegModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("BKM"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiBody"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiCoat"),
                    shouldActivate = false,
                }
            };
            //simply find an object on your child locator you want to activate/deactivate and set if you want to activate/deacitvate it with this skin

            #endregion

            #region Comrade

            //creating a new skindef as we did before
            SkinDef comradeSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "PROSPECTOR_ALT_SKIN_NAME",
                LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("ProspectorSkinRedIcon"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject,
                Modules.Unlockables.masteryUnlockableDef);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            comradeSkin.skinDefParams.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                "LeeRor2Heart",
                "LeeRor2BodyComrade",
                "leeFaceMeshBlend",
                "LeeRor2HeadComrade",
                "leeChestLegPlateMeshBlend",
                "leeEyeMeshBlend",
                "leeLegsMeshBlend",
                "LeeRor2ProspectorBoxMesh",
                "LeeRor2ProspectorBoxPistolMesh",
                "LeeRor2ProspsectorCannonMesh",
                "LeeRor2ProspectorRifleMesh",
                "leeSuperRilfeAlphaMeshBlend",
                "LeeRor2ProspectorPistolMesh",
                "BoyKisserMesh",
                "YiMesh",
                "YiCoat"
            );


            /*
                    "leeArmMat",
                    "leeTorsoClothmat", 
                    "leeFaceMat", no replacement
                    "leeHairMat", material replacement only
                    "leeChestLegPlateMat", 
                    "leeEyeMat", no replacement
                    "leeLegMat", 
                    "leeBoxGunMat", no replacement
                    "leeSubmachineMat", no replacement
                    "Cannon", no replacement
                    "leeSuperRifleMat",
                    some alpha bit
                    "leePistolMat" no replacement
             */


            //masterySkin has a new set of RendererInfos (based on default rendererinfos)
            //you can simply access the RendererInfos defaultMaterials and set them to the new materials for your skin.
            string[] comradeMaterialStrings =
                {
                    "LeeRor2ComradePalette",
                    "LeeRor2ComradePalette",
                    "LeeRor2ComradePalette",
                    "LeeRor2ComradePalette",
                    "LeeRor2ComradePalette",
                    "LeeRor2ComradePalette",
                    "LeeRor2ComradePalette",
                    "LeeRoR2ComradeWeaponPalette",
                    "LeeRoR2ComradeWeaponPalette",
                    "LeeRoR2ComradeWeaponPalette",
                    "LeeRoR2ComradeWeaponPalette",
                    "LeeRor2ComradePalette",
                    "LeeRoR2ComradeWeaponPalette",
                    null,
                    null,
                    null
                };

            for (int i = 0; i < comradeMaterialStrings.Length; i++)
            {
                if (comradeMaterialStrings[i] == null)
                {
                    comradeSkin.skinDefParams.rendererInfos[i].defaultMaterial = defaultRendererinfos[i].defaultMaterial;
                }
                else
                {
                    comradeSkin.skinDefParams.rendererInfos[i].defaultMaterial = Materials.CreateHopooMaterial(comradeMaterialStrings[i], emStr);
                }
            }

            //here's a barebones example of using gameobjectactivations that could probably be streamlined or rewritten entirely, truthfully, but it works

            /*
                "ArmModel"
                "TorsoModel"
                "FaceModel"
                "HairModel"
                "ArmourPlateModel"
                "EyeModel"
                "LegModel"
                "GunCaseModel"
                "SubMachineGunModel"
                "SuperCannonModel"
                "SuperRifleModel"
                "SuperRifleModelAlphaBit"
                "PistolModel"
             */
            comradeSkin.skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[]
            {
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("TorsoModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("FaceModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("HairModel"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmourPlateModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("EyeModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("LegModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("BKM"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiBody"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiCoat"),
                    shouldActivate = false,
                }
            };
            //simply find an object on your child locator you want to activate/deactivate and set if you want to activate/deacitvate it with this skin

            #endregion

            #region Yi

            //creating a new skindef as we did before
            SkinDef yiSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "YI_SKIN_NAME",
                LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("YiIcon"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject,
                null);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            yiSkin.skinDefParams.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                null,
                null,
                null,
                null,
                null,
                "YiMesh",
                "YiCoat",
                "leeGunCaseMeshBlend",
                "leePistolMeshBlend",
                "E3SuperlicannonMd010011",
                "leeSuperRifleMeshBlend",
                "leeSuperRilfeAlphaMeshBlend",
                "leeSubMachineGunMeshBlend",
                "BoyKisserMesh",
                "YiMesh",
                "YiCoat"
            );

            /*
                    "leeArmMat",
                    "leeTorsoClothmat", 
                    "leeFaceMat", no replacement
                    "leeHairMat", material replacement only
                    "leeChestLegPlateMat", 
                    "leeEyeMat", no replacement
                    "leeLegMat", 
                    "leeBoxGunMat", no replacement
                    "leeSubmachineMat", no replacement
                    "Cannon", no replacement
                    "leeSuperRifleMat",
                    some alpha bit
                    "leePistolMat" no replacement
             */


            //masterySkin has a new set of RendererInfos (based on default rendererinfos)
            //you can simply access the RendererInfos defaultMaterials and set them to the new materials for your skin.
            string[] yiMaterialStrings =
                {
                    "yiMat",
                    "yiMat",
                    "yiMat",
                    "yiMat",
                    "yiMat",
                    "yiMat",
                    "yiMat",
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    "yiMat",
                    "yiMat",
                    "yiMat"
                };

            for (int i = 0; i < yiMaterialStrings.Length; i++)
            {
                if (yiMaterialStrings[i] == null)
                {
                    yiSkin.skinDefParams.rendererInfos[i].defaultMaterial = defaultRendererinfos[i].defaultMaterial;
                }
                else
                {
                    yiSkin.skinDefParams.rendererInfos[i].defaultMaterial = Materials.CreateHopooMaterial(yiMaterialStrings[i], emStr);
                }
            }

            //here's a barebones example of using gameobjectactivations that could probably be streamlined or rewritten entirely, truthfully, but it works

            /*
                "ArmModel"
                "TorsoModel"
                "FaceModel"
                "HairModel"
                "ArmourPlateModel"
                "EyeModel"
                "LegModel"
                "GunCaseModel"
                "SubMachineGunModel"
                "SuperCannonModel"
                "SuperRifleModel"
                "SuperRifleModelAlphaBit"
                "PistolModel"
             */
            yiSkin.skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[]
            {
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("TorsoModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("FaceModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("HairModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmourPlateModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("EyeModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("LegModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("BKM"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiBody"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiCoat"),
                    shouldActivate = true,
                }
            };
            //simply find an object on your child locator you want to activate/deactivate and set if you want to activate/deacitvate it with this skin

            #endregion

            #region BKSkin

            //creating a new skindef as we did before
            SkinDef bkSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "BK_SKIN_NAME",
                LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("BKIcon"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject,
                null);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            bkSkin.skinDefParams.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                "leeGunCaseMeshBlend",
                "leePistolMeshBlend",
                "E3SuperlicannonMd010011",
                "leeSuperRifleMeshBlend",
                "leeSuperRilfeAlphaMeshBlend",
                "leeSubMachineGunMeshBlend",
                "BoyKisserMesh",
                "YiMesh",
                "YiCoat"
            );

            /*
                    "leeArmMat",
                    "leeTorsoClothmat", 
                    "leeFaceMat", no replacement
                    "leeHairMat", material replacement only
                    "leeChestLegPlateMat", 
                    "leeEyeMat", no replacement
                    "leeLegMat", 
                    "leeBoxGunMat", no replacement
                    "leeSubmachineMat", no replacement
                    "Cannon", no replacement
                    "leeSuperRifleMat",
                    some alpha bit
                    "leePistolMat" no replacement
             */


            //masterySkin has a new set of RendererInfos (based on default rendererinfos)
            //you can simply access the RendererInfos defaultMaterials and set them to the new materials for your skin.
            string[] bkMaterialStrings =
                {
                    "boy",
                    "boy",
                    "boy",
                    "boy",
                    "boy",
                    "boy",
                    "boy",
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    "boy",
                    "boy",
                    "boy"
                };

            for (int i = 0; i < bkMaterialStrings.Length; i++)
            {
                if (bkMaterialStrings[i] == null)
                {
                    bkSkin.skinDefParams.rendererInfos[i].defaultMaterial = defaultRendererinfos[i].defaultMaterial;
                }
                else
                {
                    bkSkin.skinDefParams.rendererInfos[i].defaultMaterial = Materials.CreateHopooMaterial(bkMaterialStrings[i], emStr);
                }
            }

            //here's a barebones example of using gameobjectactivations that could probably be streamlined or rewritten entirely, truthfully, but it works

            /*
                "ArmModel"
                "TorsoModel"
                "FaceModel"
                "HairModel"
                "ArmourPlateModel"
                "EyeModel"
                "LegModel"
                "GunCaseModel"
                "SubMachineGunModel"
                "SuperCannonModel"
                "SuperRifleModel"
                "SuperRifleModelAlphaBit"
                "PistolModel"
             */
            bkSkin.skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[]
            {
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("TorsoModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("FaceModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("HairModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("ArmourPlateModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("EyeModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("LegModel"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("BKM"),
                    shouldActivate = true,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiBody"),
                    shouldActivate = false,
                },
                new SkinDefParams.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("YiCoat"),
                    shouldActivate = false,
                }
            };
            //simply find an object on your child locator you want to activate/deactivate and set if you want to activate/deacitvate it with this skin

            #endregion

            if (Modules.Config.loreMode.Value)
            {
                // Put RoRified skin first
                skins.Add(prospectorSkin);
                skins.Add(comradeSkin);
                skins.Add(defaultSkin);
                skins.Add(blueSkin);
                skins.Add(scarletSkin);

                glitchSkinIndex = 3;
                redVFXSkins = new List<int> { 4 };
                orangeVFXSkins = new List<int> { 1 };
                lightBlueVFXSkins = new List<int> { 3 };
                voiceDisabledSkins = new List<int> { 0, 1 };
                rorSkins = new List<int> { 0, 1 };
            }
            else 
            {
                skins.Add(defaultSkin);
                skins.Add(blueSkin);
                skins.Add(scarletSkin);
                skins.Add(prospectorSkin);
                skins.Add(comradeSkin);

                glitchSkinIndex = 1;
                redVFXSkins = new List<int> { 2 };
                orangeVFXSkins = new List<int> { 4 };
                lightBlueVFXSkins = new List<int> { 1 };
                voiceDisabledSkins = new List<int> { 3, 4 };
                rorSkins = new List<int> { 3, 4 };
            }

            skins.Add(yiSkin);
            skins.Add(bkSkin);

            skinController.skins = skins.ToArray();

            //Add to modelskincontroller

            ModelSkinController displayPrefabMSC = displayPrefab.GetComponent<ModelSkinController>();
            if (!displayPrefabMSC) 
            {
                displayPrefabMSC = displayPrefab.AddComponent<ModelSkinController>();
            }

            displayPrefabMSC.skins = skins.ToArray();

        }
    }
}