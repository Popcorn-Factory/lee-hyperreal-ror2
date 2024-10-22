﻿using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;
using ShaderSwapper;
using LeeHyperrealMod.Content.Controllers;

namespace LeeHyperrealMod.Modules
{
    internal class ParticleAssets
    {
        #region Materials
        internal static List<Material> materialStorage = new List<Material>();
        #endregion

        #region Primary Aerial
        internal static GameObject primaryAerialEffectLoop;
        internal static GameObject primaryAerialEffectEnd;
        #endregion

        #region Primary 1
        public static GameObject primary1Swing;
        public static GameObject primary1Hit;
        public static GameObject primary1Floor;
        #endregion

        #region Primary 2
        public static GameObject primary2Shot;
        public static GameObject primary2hit1;
        public static GameObject primary2hit2;
        #endregion

        #region Primary 3
        public static GameObject primary3Swing1;
        public static GameObject primary3Swing2;
        public static GameObject primary3hit;
        #endregion

        #region Primary 4
        public static GameObject primary4Swing;
        public static GameObject primary4AfterImage;
        public static GameObject primary4Hit;
        #endregion

        #region Primary 5
        public static GameObject primary5Swing;
        public static GameObject primary5Floor;
        #endregion

        #region Red Orb
        public static GameObject redOrbSwing;
        public static GameObject redOrbHit;
        public static GameObject redOrbPingSwing;
        public static GameObject redOrbPingGround;

        public static GameObject redOrbDomainHit;
        public static GameObject redOrbDomainFloorImpact;
        public static GameObject redOrbDomainClone;
        public static GameObject redOrbDomainCloneStart;
        #endregion

        #region Blue Orb
        public static GameObject blueOrbShot;
        public static GameObject blueOrbHit;
        public static GameObject blueOrbGroundHit;
        #endregion

        #region Yellow Orb
        public static GameObject yellowOrbSwing;
        public static GameObject yellowOrbSwingHit;
        public static GameObject yellowOrbKick;
        public static GameObject yellowOrbMultishot;
        public static GameObject yellowOrbMultishotHit;
        public static GameObject yellowOrbDomainBulletLeftovers;
        public static GameObject yellowOrbDomainClone;
        #endregion

        #region Snipe
        public static GameObject SnipeStart;
        public static GameObject Snipe;
        public static GameObject snipeHit;
        public static GameObject snipeHitEnhanced;
        public static GameObject snipeGround;
        public static GameObject snipeBulletCasing;
        public static GameObject snipeDodge;
        public static GameObject snipeAerialFloor;
        #endregion

        #region Parry
        public static GameObject normalParry;
        public static GameObject bigParry;
        #endregion

        #region Dodge
        public static GameObject dodgeForwards;
        public static GameObject dodgeBackwards;
        #endregion

        #region Ultimate Domain
        //FXR 42
        public static GameObject UltimateDomainFinisherEffect;
        public static GameObject UltimateDomainCEASEYOUREXISTANCE;
        public static GameObject DomainOverlayEffect;
        public static GameObject UltimateDomainBulletFinisher;
        public static GameObject UltimateDomainClone1;
        public static GameObject UltimateDomainClone2;
        public static GameObject UltimateDomainClone3;
        #endregion

        #region Domain/Transition Effects
        //FXR 41
        public static GameObject transitionEffectLee;
        public static GameObject transitionEffectHit;
        public static GameObject transitionEffectGround;
        public static GameObject domainFieldLoopEffect;
        public static GameObject domainFieldEndEffect;
        #endregion

        #region Ultimate non-domain 
        //FXR 51
        public static GameObject ultExplosion;
        public static GameObject ultGunEffect;
        public static GameObject ultTracerEffect;
        public static GameObject ultPreExplosionProjectile;
        public static GameObject ultShootingEffect;
        #endregion

        #region Display particles
        public static GameObject displayLandingEffect;
        #endregion

        #region Misc
        public static GameObject jumpEffect;
        public static GameObject customCrosshair;
        #endregion

        public struct LightIntensityProps 
        {
            public float timeMax;
            public bool loop;
            public bool randomStart;
            public bool enableNegativeLights;
        }

        public static void Initialize() 
        {
            //UpdateAllBundleMaterials();
            CreateMaterialStorage(Modules.LeeHyperrealAssets.mainAssetBundle);
            PopulateAssets();
        }

        private static void UpdateAllBundleMaterials()
        {
            Material[] materials = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAllAssets<Material>();

            foreach (Material material in materials)
            {
                if (material.shader.name.StartsWith("StubbedRoR2"))
                {
                    Debug.Log($"{material.name}: {material.shader.name}");
                    string newName;
                    nameConversion.TryGetValue(material.shader.name, out newName);
                    material.shader = RoR2.LegacyShaderAPI.Find(newName);
                }
            }
        }

        private static GameObject GetGameObjectFromBundle(string objectName) 
        {
            return Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<GameObject>(objectName);
        }

        private static GameObject ModifyEffect(GameObject newEffect, string soundName, bool parentToTransform) 
        {
            return ModifyEffect(newEffect, soundName, parentToTransform, 1f);
        }

        private static GameObject ModifyEffect(GameObject newEffect, string soundName, bool parentToTransform, float duration, VFXAttributes.VFXPriority priority = VFXAttributes.VFXPriority.Always)
        {
            newEffect.AddComponent<DestroyOnTimer>().duration = duration;
            newEffect.AddComponent<NetworkIdentity>();
            newEffect.AddComponent<VFXAttributes>().vfxPriority = priority;
            EffectComponent effect = newEffect.AddComponent<EffectComponent>();
            effect.applyScale = true;
            effect.parentToReferencedTransform = parentToTransform;
            effect.positionAtReferencedTransform = true;
            effect.soundName = soundName;

            AddNewEffectDef(newEffect, soundName);

            return newEffect;
        }

        private static void AddNewEffectDef(GameObject effectPrefab, string soundName)
        {
            EffectDef newEffectDef = new EffectDef();
            newEffectDef.prefab = effectPrefab;
            newEffectDef.prefabEffectComponent = effectPrefab.GetComponent<EffectComponent>();
            newEffectDef.prefabName = effectPrefab.name;
            newEffectDef.prefabVfxAttributes = effectPrefab.GetComponent<VFXAttributes>();
            newEffectDef.spawnSoundEventName = soundName;

            Modules.Content.AddEffectDef(newEffectDef);
        }

        public static void AddLightIntensityCurveWithCurve(GameObject targetObject, LightIntensityProps liProps, string curveName) 
        {
            AnimationCurveAsset curveAsset = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<AnimationCurveAsset>(curveName);
            LightIntensityCurve lightIntensityCurveComponent = targetObject.AddComponent<LightIntensityCurve>();
            lightIntensityCurveComponent.timeMax = liProps.timeMax;
            lightIntensityCurveComponent.loop = liProps.loop;
            lightIntensityCurveComponent.randomStart = liProps.randomStart;
            lightIntensityCurveComponent.enableNegativeLights = liProps.enableNegativeLights;
            lightIntensityCurveComponent.curve = curveAsset.value;
        }

        public static void PopulateAssets() 
        {
            #region Primary
            PopulateAerialDomainAssets();
            PopulatePrimary1Assets();
            PopulatePrimary2Assets();
            PopulatePrimary3Assets();
            PopulatePrimary4Assets();
            PopulatePrimary5Assets();
            #endregion

            #region RedOrb
            PopulateRedOrbAssets();
            #endregion

            #region Blue Orb
            PopulateBlueOrbAssets();
            #endregion

            #region Yellow Orb
            PopulateYellowOrbAssets();
            #endregion

            #region Snipe
            PopulateSnipeAssets();
            #endregion

            #region Parry
            PopulateParryAssets();
            #endregion

            #region Dodge
            PopulateDodgeAssets();
            #endregion

            #region Domain/Transition Effects
            PopulateDomainTransitionAssets();
            #endregion

            #region Domain Ultimate
            PopulateDomainUltimateAssets();
            #endregion

            #region Ultimate Non-domain
            PopulateUltimateAssets();
            #endregion

            #region Display Particles
            PopulateDisplayParticleAssets();
            #endregion

            #region Misc
            PopulateMiscAssets();
            #endregion
        }

        private static void PopulateMiscAssets()
        {
            jumpEffect = GetGameObjectFromBundle("Extra Jump Floor");
            EffectUnparenter effectUnparenter = jumpEffect.AddComponent<EffectUnparenter>();
            effectUnparenter.duration = 0.175f;
            jumpEffect = ModifyEffect(jumpEffect, "", true, 1.5f);


            customCrosshair = GetGameObjectFromBundle("Lee Crosshair");
        }

        private static void PopulateAerialDomainAssets()
        {
            primaryAerialEffectLoop = GetGameObjectFromBundle("DomainMidairLoop");

            primaryAerialEffectEnd = GetGameObjectFromBundle("DomainMidairEnd");
            primaryAerialEffectEnd = ModifyEffect(primaryAerialEffectEnd, "Play_c_liRk4_skill_yellow_dilie", false, 2f);
        }

        private static void PopulateDisplayParticleAssets()
        {
            displayLandingEffect = GetGameObjectFromBundle("fxr4liangborn1");
            displayLandingEffect.AddComponent<DestroyOnTimer>().duration = 5f;
        }

        private static void PopulateUltimateAssets()
        {
            //ultGunEffect = GetGameObjectFromBundle("");
            //ultGunEffect = ModifyEffect(ultGunEffect, "", true);

            ultTracerEffect = GetGameObjectFromBundle("fxr4liangatk51xuli");
            ultTracerEffect = ModifyEffect(ultTracerEffect, "", true, 6f);

            ultShootingEffect = GetGameObjectFromBundle("Cannon Ult Shot Extra Prefab");
            ultShootingEffect = ModifyEffect(ultShootingEffect, "", true, 6f);

            ultPreExplosionProjectile = GetGameObjectFromBundle("fxr4liangatk51");
            ultPreExplosionProjectile = ModifyEffect(ultPreExplosionProjectile, "Play_c_liRk4_skill_ultimate_blast", true, 5f);

            ultExplosion = GetGameObjectFromBundle("fxr4liangatk51zha");
            ultExplosion = ModifyEffect(ultExplosion, "", true, 5f);
        }

        private static void PopulateDomainUltimateAssets()
        {
            UltimateDomainFinisherEffect = GetGameObjectFromBundle("fxr4liangatk42suiping");
            UltimateDomainFinisherEffect.AddComponent<DestroyOnTimer>().duration = 2f;

            UltimateDomainCEASEYOUREXISTANCE = GetGameObjectFromBundle("Cease");
            UltimateDomainCEASEYOUREXISTANCE.AddComponent<DestroyOnTimer>().duration = 2f;

            DomainOverlayEffect = GetGameObjectFromBundle("fxr4liangatk51pingmu"); // Control manually.

            UltimateDomainBulletFinisher = GetGameObjectFromBundle("fxr4liangatk42zhongjie01");
            UltimateDomainBulletFinisher = ModifyEffect(UltimateDomainBulletFinisher, "", true, 10f);

            UltimateDomainClone1 = GetGameObjectFromBundle("DomainUltClone1");
            UltimateDomainClone1 = ModifyEffect(UltimateDomainClone1, "", true, 2f, VFXAttributes.VFXPriority.Always);

            UltimateDomainClone2 = GetGameObjectFromBundle("DomainUltClone2");
            UltimateDomainClone2 = ModifyEffect(UltimateDomainClone2, "", true, 2f, VFXAttributes.VFXPriority.Always);

            UltimateDomainClone3 = GetGameObjectFromBundle("DomainUltClone3");
            UltimateDomainClone3 = ModifyEffect(UltimateDomainClone3, "", true, 2f, VFXAttributes.VFXPriority.Always);
        }

        private static void PopulateDomainTransitionAssets()
        {
            transitionEffectLee = GetGameObjectFromBundle("fxr4liangatk41");
            transitionEffectLee = ModifyEffect(transitionEffectLee, "", true);

            transitionEffectGround = GetGameObjectFromBundle("fxr4liangatk41bao");
            transitionEffectGround = ModifyEffect(transitionEffectGround, "", true);

            transitionEffectHit = GetGameObjectFromBundle("fxr4liangatk41hit");
            //AddLightIntensityCurveWithCurve(
            //    transitionEffectHit.transform.GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk41hit"
            //);
            transitionEffectHit = ModifyEffect(transitionEffectHit, "", true);

            domainFieldLoopEffect = GetGameObjectFromBundle("fxr4liangatk41loop");
            domainFieldEndEffect = GetGameObjectFromBundle("fxr4liangatk41out");
        }

        private static void PopulateDodgeAssets()
        {
            dodgeForwards = GetGameObjectFromBundle("fxr4liangmove01");
            dodgeForwards = ModifyEffect(dodgeForwards, "Play_c_liRk4_act_flash_1", true);

            dodgeBackwards = GetGameObjectFromBundle("fxr4liangmove02");
            dodgeBackwards = ModifyEffect(dodgeBackwards, "Play_c_liRk4_act_flash_2", true);
        }

        private static void PopulateParryAssets()
        {
            normalParry = GetGameObjectFromBundle("Normal Parry");
            normalParry = ModifyEffect(normalParry, "", true);

            bigParry = GetGameObjectFromBundle("Big Parry");
            bigParry = ModifyEffect(bigParry, "", true);
        }

        private static void PopulateSnipeAssets()
        {
            SnipeStart = GetGameObjectFromBundle("fxr4liangatk23");
            SnipeStart = ModifyEffect(SnipeStart, "", true);

            Snipe = GetGameObjectFromBundle("fxr4liangatk24");
            //AddLightIntensityCurveWithCurve(
            //    Snipe.transform.GetChild(0).GetChild(1).gameObject,
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.5f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk24-lightSC1"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    Snipe.transform.GetChild(1).GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.4f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk24-spjere"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    Snipe.transform.GetChild(2).GetChild(11).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.45f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk24-lightSC2"
            //    );

            Snipe = ModifyEffect(Snipe, "", false, 1.25f, VFXAttributes.VFXPriority.Medium);

            snipeHitEnhanced = GetGameObjectFromBundle("fxr4liangatk24bao");
            snipeHitEnhanced = ModifyEffect(snipeHitEnhanced, "Play_c_liRk4_atk_ex_3_break", true, 2f);

            snipeHit = GetGameObjectFromBundle("fxr4liangatk24hit");
            //AddLightIntensityCurveWithCurve(
            //    snipeHit.transform.GetChild(0).GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.15f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk24hit-lightSC"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    snipeHit.transform.GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk24hit-spjere"
            //    );
            snipeHit = ModifyEffect(snipeHit, "Play_c_liRk4_imp_ex_3_1", true, 2f);

            snipeGround = GetGameObjectFromBundle("fxr4liangatk24ground");
            snipeGround = ModifyEffect(snipeGround, "", true, 2f);

            snipeBulletCasing = GetGameObjectFromBundle("fxr4liangatk24bulletcasing");
            snipeBulletCasing = ModifyEffect(snipeBulletCasing, "", true, 2f, VFXAttributes.VFXPriority.Low);

            snipeDodge = GetGameObjectFromBundle("fxr4liangatk28");
            snipeDodge = ModifyEffect(snipeDodge, "Play_c_liRk4_act_flash_3", true);

            snipeAerialFloor = GetGameObjectFromBundle("Snipe Floor");
            snipeAerialFloor.AddComponent<DestroyPlatformOnDelay>();
        }

        private static void PopulateYellowOrbAssets()
        {
            yellowOrbSwing = GetGameObjectFromBundle("fxr4liangatk34dilie");
            yellowOrbSwing = ModifyEffect(yellowOrbSwing, "Play_c_liRk4_skill_yellow", true);

            yellowOrbSwingHit = GetGameObjectFromBundle("fxr4liangatk34hit");
            //AddLightIntensityCurveWithCurve(
            //    yellowOrbSwingHit.transform.GetChild(0).GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false

            //    },
            //    "fxr4liangatk34hit-spjere"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    yellowOrbSwingHit.transform.GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.12f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false

            //    },
            //    "fxr4liangatk34hit-lightSC"
            //    );
            yellowOrbSwingHit = ModifyEffect(yellowOrbSwingHit, "Play_c_liRk4_imp_yellow_1", true);

            yellowOrbKick = GetGameObjectFromBundle("fxr4liangatk32");
            AddLightIntensityCurveWithCurve(
                yellowOrbKick.transform.GetChild(0).GetChild(6).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.3f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false

                },
                "fxr4liangatk32"
                );
            yellowOrbKick = ModifyEffect(yellowOrbKick, "Play_c_liRk4_skill_yellow_fire", true);

            yellowOrbMultishot = GetGameObjectFromBundle("fxr4liangatk35");
            //AddLightIntensityCurveWithCurve(
            //    yellowOrbMultishot.transform.GetChild(8).GetChild(3).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.15f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk35"
            //    );
            yellowOrbMultishot = ModifyEffect(yellowOrbMultishot, "", true);

            yellowOrbMultishotHit = GetGameObjectFromBundle("fxr4liangatk35hit");
            //AddLightIntensityCurveWithCurve(
            //    yellowOrbMultishotHit.transform.GetChild(0).GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 1.6f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk35hit-lightSC"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    yellowOrbMultishotHit.transform.GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 1.6f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk35hit-spjere"
            //    );
            yellowOrbMultishotHit = ModifyEffect(yellowOrbMultishotHit, "", true);

            yellowOrbDomainBulletLeftovers = GetGameObjectFromBundle("fxr4liangatk35dandao");
            yellowOrbDomainBulletLeftovers.AddComponent<DestroyOnTimer>().duration = 150f;

            yellowOrbDomainClone = GetGameObjectFromBundle("YellowOrbDomainClone");
            LeeHyperrealCloneFlicker flicker = yellowOrbDomainClone.AddComponent<LeeHyperrealCloneFlicker>();
        }

        private static void PopulateBlueOrbAssets()
        {
            blueOrbShot = GetGameObjectFromBundle("fxr4liangatk20");
            //AddLightIntensityCurveWithCurve(
            //    blueOrbShot.transform.GetChild(0).GetChild(1).GetChild(1).gameObject,
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.15f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk20-spjere"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    blueOrbShot.transform.GetChild(0).GetChild(1).GetChild(0).gameObject,
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.35f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk20-lightSC"
            //    );
            blueOrbShot = ModifyEffect(blueOrbShot, "Play_c_liRk4_skill_blue", true);

            blueOrbHit = GetGameObjectFromBundle("fxr4liangatk20hit");
            //AddLightIntensityCurveWithCurve(
            //    blueOrbHit.transform.GetChild(1).gameObject,
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk20hit-spjere"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    blueOrbHit.transform.GetChild(0).GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.12f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk20hit-lightSC"
            //    );
            blueOrbHit = ModifyEffect(blueOrbHit, "Play_c_liRk4_imp_blue", true);

            blueOrbGroundHit = GetGameObjectFromBundle("fxr4liangatk20bao");
            blueOrbGroundHit = ModifyEffect(blueOrbGroundHit, "Play_c_liRk4_skill_blue_dilie", true, 3f);
        }

        private static void PopulateRedOrbAssets()
        {
            redOrbSwing = GetGameObjectFromBundle("fxr4liangatk10");
            //AddLightIntensityCurveWithCurve(
            //    redOrbSwing.transform.GetChild(1).GetChild(0).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.5f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk10"
            //    );
            redOrbSwing = ModifyEffect(redOrbSwing, "Play_c_liRk4_skill_red", true);

            redOrbHit = GetGameObjectFromBundle("fxr4liangatk10hit02");
            //AddLightIntensityCurveWithCurve(
            //    redOrbHit.transform.GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.5f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk10hit02-spjere"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    redOrbHit.transform.GetChild(0).GetChild(2).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.5f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk10hit02-lightSC"
            //    );
            redOrbHit = ModifyEffect(redOrbHit, "Play_c_liRk4_imp_red_1", false);

            redOrbPingSwing = GetGameObjectFromBundle("fxr4liangatk11");
            redOrbPingSwing = ModifyEffect(redOrbPingSwing, "", false);

            redOrbPingGround = GetGameObjectFromBundle("fxr4liangatk11dilie");
            //AddLightIntensityCurveWithCurve(
            //    redOrbPingGround.transform.GetChild(0).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.5f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk11dilie"
            //    );
            redOrbPingGround = ModifyEffect(redOrbPingGround, "", false);

            redOrbDomainFloorImpact = GetGameObjectFromBundle("fxr4liangatk14dilie");
            //AddLightIntensityCurveWithCurve(
            //    redOrbDomainFloorImpact.transform.GetChild(0).gameObject,
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.5f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk14dilie"
            //    );
            redOrbDomainFloorImpact = ModifyEffect(redOrbDomainFloorImpact, "Play_c_liRk4_atk_ex_2", false);

            redOrbDomainHit = GetGameObjectFromBundle("fxr4liangatk14fshit01");
            //AddLightIntensityCurveWithCurve(
            //    redOrbDomainHit.transform.GetChild(0).GetChild(4).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.5f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk14fshit01"
            //    );
            redOrbDomainHit = ModifyEffect(redOrbDomainHit, "Play_c_liRk4_imp_ex_2_2", false);

            redOrbDomainClone = GetGameObjectFromBundle("RedOrbDomainClone");
            redOrbDomainClone.AddComponent<LeeHyperrealCloneFlicker>();

            redOrbDomainCloneStart = GetGameObjectFromBundle("RedOrbDomainCloneStart");
            redOrbDomainCloneStart.AddComponent<LeeHyperrealCloneFlicker>();
        }

        private static void PopulatePrimary5Assets()
        {
            primary5Swing = GetGameObjectFromBundle("fxr4liangatk05");
            primary5Swing = ModifyEffect(primary5Swing, "Play_c_liRk4_atk_nml_5_jump", true, 1.5f);

            primary5Floor = GetGameObjectFromBundle("fxr4liangatk05dilie");
            //AddLightIntensityCurveWithCurve(
            //    primary5Floor.transform.GetChild(0).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 1f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk05dilie"
            //    );
            primary5Floor = ModifyEffect(primary5Floor, "Play_c_liRk4_atk_nml_5_dilie", false, 1.5f);
        }

        private static void PopulatePrimary4Assets()
        {
            primary4Swing = GetGameObjectFromBundle("fxr4liangatk04");
            //AddLightIntensityCurveWithCurve(
            //   primary4Swing.transform.GetChild(1).GetChild(0).gameObject,
            //   new LightIntensityProps
            //   {
            //       timeMax = 1f,
            //       loop = false,
            //       randomStart = false,
            //       enableNegativeLights = false,
            //   },
            //   "fxr4liangatk04"
            //   );
            primary4Swing = ModifyEffect(primary4Swing, "", true, 2f);

            primary4AfterImage = GetGameObjectFromBundle("fxr4liangatk04canying");
            primary4AfterImage = ModifyEffect(primary4AfterImage, "", true, 2f);

            primary4Hit = GetGameObjectFromBundle("fxr4liangatk04hit");
            primary4Hit = ModifyEffect(primary4Hit, "", true);
        }

        public static void PopulatePrimary3Assets() 
        {
            primary3Swing1 = GetGameObjectFromBundle("fxr4liangatk03dilie1");
            primary3Swing1 = ModifyEffect(primary3Swing1, "Play_c_liRk4_atk_nml_3_dilie_1", true);

            primary3Swing2 = GetGameObjectFromBundle("fxr4liangatk03dilie2");
            primary3Swing2 = ModifyEffect(primary3Swing2, "Play_c_liRk4_atk_nml_3_dilie_2", true);

            primary3hit = GetGameObjectFromBundle("fxr4liangatk03hit01");
            //AddLightIntensityCurveWithCurve(
            //    primary3hit.transform.GetChild(0).GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.12f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "Fxr4liangatk03hit01-lightSC"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    primary3hit.transform.GetChild(1).gameObject,
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "fxr4liangatk03hit01-spjere"
            //    );
            primary3hit = ModifyEffect(primary3hit, "", false, 1.5f);
        }

        public static void PopulatePrimary2Assets()
        {
            primary2Shot = GetGameObjectFromBundle("fxr4liangatk02");
            //AddLightIntensityCurveWithCurve(
            //    primary2Shot.transform.GetChild(2).GetChild(0).gameObject,
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.15f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    },
            //    "Fxr4liangatk02"
            //    );
            primary2Shot = ModifyEffect(primary2Shot, "Play_c_liRk4_atk_nml_2", true);

            primary2hit1 = GetGameObjectFromBundle("fxr4liangatk02hit01");
            //AddLightIntensityCurveWithCurve(
            //    primary2hit1.transform.GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk02hit01"
            //    );
            primary2hit1 = ModifyEffect(primary2hit1, "", true);

            primary2hit2 = GetGameObjectFromBundle("fxr4liangatk02hit02");
            //AddLightIntensityCurveWithCurve(
            //    primary2hit2.transform.GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk02hit02-spjere"
            //    );
            //AddLightIntensityCurveWithCurve(
            //    primary2hit2.transform.GetChild(0).GetChild(1).gameObject,
            //    new LightIntensityProps
            //    {
            //        timeMax = 0.12f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false
            //    },
            //    "fxr4liangatk02hit02-lightSC"
            //    );
            primary2hit2 = ModifyEffect(primary2hit2, "", true);
        }

        public static void PopulatePrimary1Assets() 
        {
            primary1Swing = GetGameObjectFromBundle("fxr4liangatk01");
            primary1Swing = ModifyEffect(primary1Swing, "Play_c_liRk4_atk_nml_1", true);

            primary1Hit = GetGameObjectFromBundle("fxr4liangatk01hit");
            //AddLightIntensityCurveWithCurve(
            //    primary1Hit.transform.GetChild(1).gameObject, 
            //    new LightIntensityProps 
            //    {
            //        timeMax = 0.18f,
            //        loop = false,
            //        randomStart = false,
            //        enableNegativeLights = false,
            //    }, 
            //    "Fxr4liangatk01hit");
            primary1Hit = ModifyEffect(primary1Hit, "", true);

            primary1Floor = GetGameObjectFromBundle("fxr4liangatk01dilie");
            primary1Floor = ModifyEffect(primary1Floor, "", true);
        }

        private static void CreateMaterialStorage(AssetBundle inAssetBundle)
        {
            Material[] tempArray = inAssetBundle.LoadAllAssets<Material>();

            materialStorage.AddRange(tempArray);
        }


        private static Dictionary<string, string> nameConversion = new Dictionary<string, string>()
        {
            ["StubbedShader/Deferred/Standard"] = "Hopoo Games/Deferred/Standard",
            ["StubbedShader/UI/Default Overbrighten"] = "Hopoo Games/UI/Default Overbrighten",
            ["stubbed_Hopoo Games/FX/Cloud Remap Proxy"] = "Hopoo Games/FX/Cloud Remap",
            ["StubbedRoR2/Base/Shaders/HGDistortion"] = "Hopoo Games/FX/Distortion"
        };
    }
}
