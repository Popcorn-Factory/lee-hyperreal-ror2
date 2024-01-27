using BepInEx.Configuration;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Characters;
using LeeHyperrealMod.SkillStates.LeeHyperreal;
using LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb;
using RoR2;
using RoR2.Skills;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.Modules.Survivors
{
    internal class LeeHyperreal : SurvivorBase
    {
        //used when building your character using the prefabs you set up in unity
        //don't upload to thunderstore without changing this
        public override string prefabBodyName => "LeeHyperreal";

        public const string PLUGIN_PREFIX = LeeHyperrealPlugin.DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_";

        //used when registering your survivor's language tokens
        public override string survivorTokenPrefix => PLUGIN_PREFIX;

        public override BodyInfo bodyInfo { get; set; } = new BodyInfo
        {
            bodyName = "LeeHyperrealBody",
            bodyNameToken = PLUGIN_PREFIX + "NAME",
            subtitleNameToken = PLUGIN_PREFIX + "SUBTITLE",

            characterPortrait = Assets.mainAssetBundle.LoadAsset<Texture>("texHenryIcon"),
            bodyColor = Color.white,

            crosshair = Modules.Assets.LoadCrosshair("Standard"),
            podPrefab = RoR2.LegacyResourcesAPI.Load<GameObject>("Prefabs/NetworkedObjects/SurvivorPod"),

            maxHealth = 110f,
            healthRegen = 1.5f,
            armor = 0f,

            jumpCount = 1,
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

        public override Type characterMainState => typeof(EntityStates.GenericCharacterMain);

        public override ItemDisplaysBase itemDisplays => new LeeHyperrealItemDisplays();

                                                                          //if you have more than one character, easily create a config to enable/disable them like this
        public override ConfigEntry<bool> characterEnabledConfig => null; //Modules.Config.CharacterEnableConfig(bodyName);

        private static UnlockableDef masterySkinUnlockableDef;

        public override void InitializeCharacter()
        {
            base.InitializeCharacter();

            bodyPrefab.AddComponent<LeeHyperrealUIController>();
            bodyPrefab.AddComponent<OrbController>();
            bodyPrefab.AddComponent<LeeHyperrealDomainController>();
            bodyPrefab.AddComponent<ParryMonitor>();
            bodyPrefab.AddComponent<BulletController>();
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

        }

        public override void InitializeSkills()
        {
            Modules.Skills.CreateSkillFamilies(bodyPrefab, true);
            string prefix = LeeHyperrealPlugin.DEVELOPER_PREFIX;

            #region Primary
            //Creates a skilldef for a typical primary 
            SkillDef primarySkillDef = Modules.Skills.CreateSkillDef(new SkillDefInfo(prefix + "_HENRY_BODY_PRIMARY_SLASH_NAME",
                                                                                      prefix + "_HENRY_BODY_PRIMARY_SLASH_DESCRIPTION",
                                                                                      Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texPrimaryIcon"),
                                                                                      new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Primary.Primary1)),
                                                                                      "Body",
                                                                                      true));


            Modules.Skills.AddPrimarySkills(bodyPrefab, primarySkillDef);
            #endregion

            #region Secondary
            SkillDef shootSkillDef = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "_HENRY_BODY_SECONDARY_GUN_NAME",
                skillNameToken = prefix + "_HENRY_BODY_SECONDARY_GUN_NAME",
                skillDescriptionToken = prefix + "_HENRY_BODY_SECONDARY_GUN_DESCRIPTION",
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texSecondaryIcon"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.RedOrb.RedOrbDomain)),
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
                keywordTokens = new string[] { "KEYWORD_AGILE" }
            });

            Modules.Skills.AddSecondarySkills(bodyPrefab, shootSkillDef);
            #endregion

            #region Utility
            SkillDef rollSkillDef = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "_HENRY_BODY_UTILITY_ROLL_NAME",
                skillNameToken = prefix + "_HENRY_BODY_UTILITY_ROLL_NAME",
                skillDescriptionToken = prefix + "_HENRY_BODY_UTILITY_ROLL_DESCRIPTION",
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texUtilityIcon"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Evade)),
                activationStateMachineName = "Body",
                baseMaxStock = 1,
                baseRechargeInterval = 1f,
                beginSkillCooldownOnSkillEnd = false,
                canceledFromSprinting = false,
                forceSprintDuringState = true,
                fullRestockOnAssign = true,
                interruptPriority = EntityStates.InterruptPriority.Pain,
                resetCooldownTimerOnUse = false,
                isCombatSkill = false,
                mustKeyPress = false,
                cancelSprintingOnActivation = false,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1
            });

            Modules.Skills.AddUtilitySkills(bodyPrefab, rollSkillDef);
            #endregion

            #region Special
            SkillDef bombSkillDef = Modules.Skills.CreateSkillDef(new SkillDefInfo
            {
                skillName = prefix + "_HENRY_BODY_SPECIAL_BOMB_NAME",
                skillNameToken = prefix + "_HENRY_BODY_SPECIAL_BOMB_NAME",
                skillDescriptionToken = prefix + "_HENRY_BODY_SPECIAL_BOMB_DESCRIPTION",
                skillIcon = Modules.Assets.mainAssetBundle.LoadAsset<Sprite>("texSpecialIcon"),
                activationState = new EntityStates.SerializableEntityStateType(typeof(SkillStates.LeeHyperreal.Ultimate.UltimateEntry)),
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
                cancelSprintingOnActivation = true,
                rechargeStock = 1,
                requiredStock = 1,
                stockToConsume = 1
            });

            Modules.Skills.AddSpecialSkills(bodyPrefab, bombSkillDef);
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
            #region MasterySkin
            /*
            //creating a new skindef as we did before
            SkinDef masterySkin = Modules.Skins.CreateSkinDef(LeeHyperrealPlugin.DEVELOPER_PREFIX + "_HENRY_BODY_MASTERY_SKIN_NAME",
                Assets.mainAssetBundle.LoadAsset<Sprite>("texMasteryAchievement"),
                defaultRendererinfos,
                prefabCharacterModel.gameObject,
                masterySkinUnlockableDef);

            //adding the mesh replacements as above. 
            //if you don't want to replace the mesh (for example, you only want to replace the material), pass in null so the order is preserved
            masterySkin.meshReplacements = Modules.Skins.getMeshReplacements(defaultRendererinfos,
                "meshHenrySwordAlt",
                null,//no gun mesh replacement. use same gun mesh
                "meshHenryAlt");

            //masterySkin has a new set of RendererInfos (based on default rendererinfos)
            //you can simply access the RendererInfos defaultMaterials and set them to the new materials for your skin.
            masterySkin.rendererInfos[0].defaultMaterial = Modules.Materials.CreateHopooMaterial("matHenryAlt");
            masterySkin.rendererInfos[1].defaultMaterial = Modules.Materials.CreateHopooMaterial("matHenryAlt");
            masterySkin.rendererInfos[2].defaultMaterial = Modules.Materials.CreateHopooMaterial("matHenryAlt");

            //here's a barebones example of using gameobjectactivations that could probably be streamlined or rewritten entirely, truthfully, but it works
            masterySkin.gameObjectActivations = new SkinDef.GameObjectActivation[]
            {
                new SkinDef.GameObjectActivation
                {
                    gameObject = childLocator.FindChildGameObject("GunModel"),
                    shouldActivate = false,
                }
            };
            //simply find an object on your child locator you want to activate/deactivate and set if you want to activate/deacitvate it with this skin

            skins.Add(masterySkin);
            */
            #endregion

            skinController.skins = skins.ToArray();
        }
    }
}