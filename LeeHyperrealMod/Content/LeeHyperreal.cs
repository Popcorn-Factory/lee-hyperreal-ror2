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

namespace LeeHyperrealMod.Modules.Survivors
{
    internal class LeeHyperreal : SurvivorBase
    {
        public static GameObject staticBodyPrefab;
        public override string prefabBodyName => "LeeHyperreal";

        public const string PLUGIN_PREFIX = LeeHyperrealPlugin.DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_";

        public override string survivorTokenPrefix => PLUGIN_PREFIX;

        public static SkillDef SnipeSkill;
        public static SkillDef ExitSnipeSkill;
        public static SkillDef EnterSnipeSkill;
        public static SkillDef ultimateSkill;
        public static SkillDef domainUltimateSkill;
        public static int glitchSkinIndex = 1;

        public override BodyInfo bodyInfo { get; set; } = new BodyInfo
        {
            bodyName = "LeeHyperrealBody",
            bodyNameToken = PLUGIN_PREFIX + "NAME",
            subtitleNameToken = PLUGIN_PREFIX + "SUBTITLE",

            characterPortrait = Assets.mainAssetBundle.LoadAsset<Texture>("LeeCharacterIcon"),
            bodyColor = new Color(0.4f, 1f, 1f),
            aimOriginPosition = new Vector3(0f, 0f ,0f),

            podPrefab = Modules.Assets.leeSurvivorPod,

            maxHealth = 110f,
            healthRegen = 1.5f,
            armor = 0f,

            jumpCount = 1,
            moveSpeed = Modules.StaticValues.baseMoveSpeed,
        };

        public override CustomRendererInfo[] customRendererInfos { get; set; } = new CustomRendererInfo[] 
        {
                new CustomRendererInfo 
                { 
                    childName = "ArmModel",
                    material = Materials.CreateHopooMaterial("leeArmMat")
                },
                new CustomRendererInfo
                {
                    childName = "TorsoModel",
                    material = Materials.CreateHopooMaterial("leeTorsoClothmat"),
                },
                new CustomRendererInfo
                {
                    childName = "FaceModel",
                    material = Materials.CreateHopooMaterial("leeFaceMat"),
                },
                new CustomRendererInfo
                {
                    childName = "HairModel",
                    material = Materials.CreateHopooMaterial("leeHairMat"),
                },
                new CustomRendererInfo
                {
                    childName = "ArmourPlateModel",
                    material = Materials.CreateHopooMaterial("leeChestLegPlateMat"),
                },
                new CustomRendererInfo
                {
                    childName = "EyeModel",
                    material = Materials.CreateHopooMaterial("leeEyeMat"),
                },
                new CustomRendererInfo
                {
                    childName = "LegModel",
                    material = Materials.CreateHopooMaterial("leeLegMat"),
                },
                new CustomRendererInfo
                {
                    childName = "GunCaseModel",
                    material = Materials.CreateHopooMaterial("leeBoxGunMat"),
                },
                new CustomRendererInfo
                {
                    childName = "SubMachineGunModel",
                    material = Materials.CreateHopooMaterial("leeSubmachineMat"),
                },
                new CustomRendererInfo 
                {
                    childName = "SuperCannonModel",
                    material = Materials.CreateHopooMaterial("Cannon"),
                    ignoreOverlays = true,
                },
                new CustomRendererInfo
                {
                    childName = "SuperRifleModel",
                    material = Materials.CreateHopooMaterial("leeSuperRifleMat"),
                },
                new CustomRendererInfo
                {
                    childName = "SuperRifleModelAlphaBit",
                },
                new CustomRendererInfo
                {
                    childName = "PistolModel",
                    material = Materials.CreateHopooMaterial("leePistolMat"),
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
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texPrimary"),
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
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texPrimary"),
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
                keywordTokens = new string[] { $"{prefix}KEYWORD_DOMAIN", $"{prefix}KEYWORD_SNIPE_STANCE", $"{prefix}KEYWORD_POWER_GAUGE" }
            });

            Modules.Skills.AddPassiveSkills(passive.orbPassiveSkillSlot.skillFamily, new SkillDef[]{
                passive.orbAndBulletPassive
            });
            Modules.Skills.AddPassiveSkills(passive.hypermatrixPassiveSkillSlot.skillFamily, new SkillDef[]{
                passive.hypermatrixPassive
            });
            #endregion

            #region Primary
            //Creates a skilldef for a typical primary 
            SkillDef primarySkillDef = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "PRIMARY_NAME",
                skillNameToken = prefix + "PRIMARY_NAME",
                skillDescriptionToken = prefix + "PRIMARY_DESCRIPTION",
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texPrimary"),
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
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texSnipe"),
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
                keywordTokens = new string[] { $"{prefix}KEYWORD_SNIPE_STANCE" }
            });

            ExitSnipeSkill = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "EXIT_SNIPE_NAME",
                skillNameToken = prefix + "EXIT_SNIPE_NAME",
                skillDescriptionToken = prefix + "EXIT_SNIPE_DESCRIPTION",
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texExitSnipe"),
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
                keywordTokens = new string[] { $"{prefix}KEYWORD_SNIPE_STANCE" }
            });

            EnterSnipeSkill = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "ENTER_SNIPE_NAME",
                skillNameToken = prefix + "ENTER_SNIPE_NAME",
                skillDescriptionToken = prefix + "ENTER_SNIPE_DESCRIPTION",
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texEnterSnipe"),                
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
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texDodge"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(Evade)),
                activationStateMachineName = "Body",
                baseMaxStock = 5,
                baseRechargeInterval = 5f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = true,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Pain,
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
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texUltimate"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Ultimate.UltimateEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 10,
                baseRechargeInterval = 4f,
                beginSkillCooldownOnSkillEnd = true,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.PrioritySkill,
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
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texUltimate"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Ultimate.UltimateEntry)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 40f, //instantly triggerable but only in the powered state.
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = false,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.PrioritySkill,
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
            ModelSkinController skinController = prefabCharacterModel.gameObject.AddComponent<ModelSkinController>();
            ChildLocator childLocator = prefabCharacterModel.GetComponent<ChildLocator>();

            CharacterModel.RendererInfo[] defaultRendererinfos = prefabCharacterModel.baseRendererInfos;

            List<SkinDef> skins = new List<SkinDef>();

            #region DefaultSkin
            //this creates a SkinDef with all default fields
            SkinDef defaultSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "DEFAULT_SKIN_NAME",
                Assets.mainAssetBundle.LoadAsset<Sprite>("texMainSkin"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject);

            //these are your Mesh Replacements. The order here is based on your CustomRendererInfos from earlier
            //pass in meshes as they are named in your assetbundle
            //defaultSkin.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
            //    "meshHenrySword",
            //    "meshHenryGun",
            //    "meshHenry");

            //add new skindef to our list of skindefs. this is what we'll be passing to the SkinController
            skins.Add(defaultSkin);
            #endregion

            //uncomment this when you have a mastery skin
            #region BlueSkin

            //creating a new skindef as we did before
            SkinDef blueSkin = Modules.Skins.CreateSkinDef(PLUGIN_PREFIX + "ALT_SKIN_NAME",
                Assets.mainAssetBundle.LoadAsset<Sprite>("texMasteryAchievement"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            blueSkin.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null);

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
                    "skinClonePistol"
                };

            for (int i = 0; i < materialStrings.Length; i++) 
            {
                if (materialStrings[i] == null)
                {
                    blueSkin.rendererInfos[i].defaultMaterial = defaultRendererinfos[i].defaultMaterial;
                }
                else 
                {
                    blueSkin.rendererInfos[i].defaultMaterial = Modules.Assets.mainAssetBundle.LoadAsset<Material>(materialStrings[i]);
                }
            }

            //here's a barebones example of using gameobjectactivations that could probably be streamlined or rewritten entirely, truthfully, but it works
            //masterySkin.gameObjectActivations = new SkinDef.GameObjectActivation[]
            //{
            //    new SkinDef.GameObjectActivation
            //    {
            //        gameObject = childLocator.FindChildGameObject("GunModel"),
            //        shouldActivate = false,
            //    }
            //};
            //simply find an object on your child locator you want to activate/deactivate and set if you want to activate/deacitvate it with this skin

            skins.Add(blueSkin);

            #endregion

            skinController.skins = skins.ToArray();
        }
    }
}