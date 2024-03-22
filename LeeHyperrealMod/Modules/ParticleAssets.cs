using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;
using ShaderSwapper;

namespace LeeHyperrealMod.Modules
{
    internal class ParticleAssets
    {
        #region Materials
        internal static List<Material> materialStorage = new List<Material>();
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
        #endregion

        public static void Initialize() 
        {
            //UpdateAllBundleMaterials();
            CreateMaterialStorage(Modules.Assets.mainAssetBundle);
            PopulateAssets();
        }

        private static void UpdateAllBundleMaterials()
        {
            Material[] materials = Modules.Assets.mainAssetBundle.LoadAllAssets<Material>();

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

        private static GameObject ModifyEffect(GameObject newEffect, string soundName, bool parentToTransform)
        {
            newEffect.AddComponent<DestroyOnTimer>().duration = 12;
            newEffect.AddComponent<NetworkIdentity>();
            newEffect.AddComponent<VFXAttributes>().vfxPriority = VFXAttributes.VFXPriority.Always;
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

        public static void PopulateAssets() 
        {
            #region Primary
            PopulatePrimary1Assets();
            PopulatePrimary2Assets();
            PopulatePrimary3Assets();
            PopulatePrimary4Assets();
            PopulatePrimary5Assets();
            #endregion

            #region RedOrb
            PopulateRedOrbAssets();
            #endregion
        }

        private static void PopulateRedOrbAssets()
        {
            redOrbSwing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk10");
            AnimationCurveAsset redOrblightSCCurveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk10");
            LightIntensityCurve redOrblightSC = redOrbSwing.transform.GetChild(1).GetChild(0).gameObject.AddComponent<LightIntensityCurve>();
            redOrblightSC.timeMax = 0.5f;
            redOrblightSC.loop = false;
            redOrblightSC.randomStart = false;
            redOrblightSC.enableNegativeLights = false;
            redOrblightSC.curve = redOrblightSCCurveAsset.value;
            redOrbSwing = ModifyEffect(redOrbSwing, "", true);

            redOrbHit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk10hit02");
            AnimationCurveAsset redOrbHitSpjereAnimationAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk10hit02-spjere");
            LightIntensityCurve redOrbHitSpjereLightCurve = redOrbHit.transform.GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            redOrbHitSpjereLightCurve.timeMax = 0.5f;
            redOrbHitSpjereLightCurve.loop = false;
            redOrbHitSpjereLightCurve.randomStart = false;
            redOrbHitSpjereLightCurve.enableNegativeLights = false;
            redOrbHitSpjereLightCurve.curve = redOrbHitSpjereAnimationAsset.value;

            AnimationCurveAsset redOrbHitLightSCCurveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk10hit02-lightSC");
            LightIntensityCurve redOrbHitSCCurveLightCurve = redOrbHit.transform.GetChild(0).GetChild(2).gameObject.AddComponent<LightIntensityCurve>();
            redOrbHitSCCurveLightCurve.timeMax = 0.5f;
            redOrbHitSCCurveLightCurve.loop = false;
            redOrbHitSCCurveLightCurve.randomStart = false;
            redOrbHitSCCurveLightCurve.enableNegativeLights = false;
            redOrbHitSCCurveLightCurve.curve = redOrbHitLightSCCurveAsset.value;
            redOrbHit = ModifyEffect(redOrbHit, "", false);

            redOrbPingSwing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk11");
            redOrbPingSwing = ModifyEffect(redOrbPingSwing, "", false);

            redOrbPingGround = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk11dilie");
            AnimationCurveAsset redOrbPingGroundlightSCCurveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk11dilie");
            LightIntensityCurve redOrbPinglightSC = redOrbPingGround.transform.GetChild(1).GetChild(0).gameObject.AddComponent<LightIntensityCurve>();
            redOrbPinglightSC.timeMax = 0.5f;
            redOrbPinglightSC.loop = false;
            redOrbPinglightSC.randomStart = false;
            redOrbPinglightSC.enableNegativeLights = false;
            redOrbPinglightSC.curve = redOrbPingGroundlightSCCurveAsset.value;
            redOrbPingGround = ModifyEffect(redOrbPingGround, "", false);
        }

        private static void PopulatePrimary5Assets()
        {
            primary5Swing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk05");
            primary5Swing = ModifyEffect(primary5Swing, "", true);

            primary5Floor = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk05dilie");
            AnimationCurveAsset primary5lightSCCurveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk05dilie");
            LightIntensityCurve primary5lightSC = primary5Floor.transform.GetChild(0).gameObject.AddComponent<LightIntensityCurve>();
            primary5lightSC.timeMax = 1f;
            primary5lightSC.loop = false;
            primary5lightSC.randomStart = false;
            primary5lightSC.enableNegativeLights = false;
            primary5lightSC.curve = primary5lightSCCurveAsset.value;
            primary5Floor = ModifyEffect(primary5Floor, "", true);
        }

        private static void PopulatePrimary4Assets()
        {
            primary4Swing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk04");
            AnimationCurveAsset primary4SwingCurveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk04");
            LightIntensityCurve primary4SwingLIC = primary4Swing.transform.GetChild(1).GetChild(0).gameObject.AddComponent<LightIntensityCurve>();
            primary4SwingLIC.timeMax = 1f;
            primary4SwingLIC.loop = false;
            primary4SwingLIC.randomStart = false;
            primary4SwingLIC.enableNegativeLights = false;
            primary4SwingLIC.curve = primary4SwingCurveAsset.value;
            primary4Swing = ModifyEffect(primary4Swing, "", true);

            primary4AfterImage = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk04canying");
            primary4AfterImage = ModifyEffect(primary4AfterImage, "", true);

            primary4Hit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk04hit");
            AnimationCurveAsset primary4HitLightspjereCurveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk04hit-spjere");
            LightIntensityCurve primary4HitLightspjere = primary4Hit.transform.GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            primary4HitLightspjere.timeMax = 0.18f;
            primary4HitLightspjere.loop = false;
            primary4HitLightspjere.randomStart = false;
            primary4HitLightspjere.enableNegativeLights = false;
            primary4HitLightspjere.curve = primary4HitLightspjereCurveAsset.value;

            AnimationCurveAsset primary4HitLightSCCurveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk04hit-lightSC");
            LightIntensityCurve primary4HitLightSC = primary4Hit.transform.GetChild(0).GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            primary4HitLightSC.timeMax = 0.18f;
            primary4HitLightSC.loop = false;
            primary4HitLightSC.randomStart = false;
            primary4HitLightSC.enableNegativeLights = false;
            primary4HitLightSC.curve = primary4HitLightSCCurveAsset.value;

            primary4Hit = ModifyEffect(primary4Hit, "", true);
        }

        public static void PopulatePrimary3Assets() 
        {
            primary3Swing1 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk03dilie1");
            primary3Swing1 = ModifyEffect(primary3Swing1, "", true);

            primary3Swing2 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk03dilie2");
            primary3Swing2 = ModifyEffect(primary3Swing2, "", true);

            primary3hit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk03hit01");
            AnimationCurveAsset primary3CurvelightSC = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("Fxr4liangatk03hit01-lightSC");
            LightIntensityCurve primary3lightSC = primary2hit2.transform.GetChild(0).GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            primary3lightSC.timeMax = 0.12f;
            primary3lightSC.loop = false;
            primary3lightSC.randomStart = false;
            primary3lightSC.enableNegativeLights = false;
            primary3lightSC.curve = primary3CurvelightSC.value;

            AnimationCurveAsset primary3hit2Curvespjere = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk03hit01-spjere");
            LightIntensityCurve primary3hitspjere = primary2hit2.transform.GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            primary3hitspjere.timeMax = 0.18f;
            primary3hitspjere.loop = false;
            primary3hitspjere.randomStart = false;
            primary3hitspjere.enableNegativeLights = false;
            primary3hitspjere.curve = primary3hit2Curvespjere.value;
            primary3hit = ModifyEffect(primary3hit, "", true);
        }

        public static void PopulatePrimary2Assets()
        {
            primary2Shot = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk02");
            AnimationCurveAsset primary2ShotCurve = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("Fxr4liangatk02");
            LightIntensityCurve primary2ShotLight = primary2Shot.transform.GetChild(2).GetChild(0).gameObject.AddComponent<LightIntensityCurve>();
            primary2ShotLight.timeMax = 0.15f;
            primary2ShotLight.loop = false;
            primary2ShotLight.randomStart = false;
            primary2ShotLight.enableNegativeLights = false;
            primary2ShotLight.curve = primary2ShotCurve.value;
            primary2Shot = ModifyEffect(primary2Shot, "", true);

            primary2hit1 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk02hit01");
            AnimationCurveAsset primary2hit1Curve = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk02hit01");
            LightIntensityCurve primary2hit1Light = primary2hit1.transform.GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            primary2hit1Light.timeMax = 0.18f;
            primary2hit1Light.loop = false;
            primary2hit1Light.randomStart = false;
            primary2hit1Light.enableNegativeLights = false;
            primary2hit1Light.curve = primary2hit1Curve.value;
            primary2hit1 = ModifyEffect(primary2hit1, "", true);

            primary2hit2 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk02hit02");
            AnimationCurveAsset primary2hit2Curvespjere = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk02hit02-spjere");
            LightIntensityCurve primary2hitLightspjere = primary2hit2.transform.GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            primary2hitLightspjere.timeMax = 0.18f;
            primary2hitLightspjere.loop = false;
            primary2hitLightspjere.randomStart = false;
            primary2hitLightspjere.enableNegativeLights = false;
            primary2hitLightspjere.curve = primary2hit2Curvespjere.value;

            AnimationCurveAsset primary2hit2Curve2 = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("fxr4liangatk02hit02-lightSC");
            LightIntensityCurve primary2hitLightsc = primary2hit2.transform.GetChild(0).GetChild(1).gameObject.AddComponent<LightIntensityCurve>();
            primary2hitLightsc.timeMax = 0.12f;
            primary2hitLightsc.loop = false;
            primary2hitLightsc.randomStart = false;
            primary2hitLightsc.enableNegativeLights = false;
            primary2hitLightsc.curve = primary2hit2Curve2.value;
            primary2hit2 = ModifyEffect(primary2hit2, "", true);
        }

        public static void PopulatePrimary1Assets() 
        {
            primary1Swing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk01");
            primary1Swing = ModifyEffect(primary1Swing, "", true);

            primary1Hit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk01hit");
            AnimationCurveAsset primary1HitCurve = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>("Fxr4liangatk01hit");
            LightIntensityCurve primary1HitLight = primary1Hit.transform.GetChild(1).gameObject.AddComponent<LightIntensityCurve>(); ;
            primary1HitLight.timeMax = 0.18f;
            primary1HitLight.loop = false;
            primary1HitLight.randomStart = false;
            primary1HitLight.enableNegativeLights = false;
            primary1HitLight.curve = primary1HitCurve.value;
            primary1Hit = ModifyEffect(primary1Hit, "", true);

            primary1Floor = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk01dilie");
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
