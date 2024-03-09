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
            effect.applyScale = false;
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
            PopulatePrimary1Assets();
            PopulatePrimary2Assets();
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
