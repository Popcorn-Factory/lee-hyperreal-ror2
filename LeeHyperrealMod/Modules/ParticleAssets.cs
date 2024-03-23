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

        #region Blue Orb
        public static GameObject blueOrbShot;
        public static GameObject blueOrbHit;
        public static GameObject blueOrbGroundHit;
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

        public static void AddLightIntensityCurveWithCurve(GameObject targetObject, LightIntensityProps liProps, string curveName) 
        {
            AnimationCurveAsset curveAsset = Modules.Assets.mainAssetBundle.LoadAsset<AnimationCurveAsset>(curveName);
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
            #endregion

            #region Domain Shift
            #endregion
        }

        private static void PopulateBlueOrbAssets()
        {
            blueOrbShot = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk20");
            AddLightIntensityCurveWithCurve(
                blueOrbShot.transform.GetChild(0).GetChild(1).GetChild(1).gameObject,
                new LightIntensityProps 
                {
                    timeMax = 0.15f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false
                },
                "fxr4liangatk20-spjere"
                );
            AddLightIntensityCurveWithCurve(
                blueOrbShot.transform.GetChild(0).GetChild(1).GetChild(0).gameObject,
                new LightIntensityProps 
                {
                    timeMax = 0.35f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false
                },
                "fxr4liangatk20-lightSC"
                );
            blueOrbShot = ModifyEffect(blueOrbShot, "", true);

            blueOrbHit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk20hit");
            AddLightIntensityCurveWithCurve(
                blueOrbHit.transform.GetChild(1).gameObject,
                new LightIntensityProps 
                {
                    timeMax = 0.18f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false
                },
                "fxr4liangatk20hit-spjere"
                );
            AddLightIntensityCurveWithCurve(
                blueOrbHit.transform.GetChild(0).GetChild(1).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.12f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false
                },
                "fxr4liangatk20hit-lightSC"
                );
            blueOrbHit = ModifyEffect(blueOrbHit, "", true);

            blueOrbGroundHit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk20bao");
            blueOrbGroundHit = ModifyEffect(blueOrbGroundHit, "", true);
        }

        private static void PopulateRedOrbAssets()
        {
            redOrbSwing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk10");
            AddLightIntensityCurveWithCurve(
                redOrbSwing.transform.GetChild(1).GetChild(0).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.5f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk10"
                );
            redOrbSwing = ModifyEffect(redOrbSwing, "", true);

            redOrbHit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk10hit02");
            AddLightIntensityCurveWithCurve(
                redOrbHit.transform.GetChild(1).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.5f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk10hit02-spjere"
                );
            AddLightIntensityCurveWithCurve(
                redOrbHit.transform.GetChild(0).GetChild(2).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.5f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk10hit02-lightSC"
                );
            redOrbHit = ModifyEffect(redOrbHit, "", false);

            redOrbPingSwing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk11");
            redOrbPingSwing = ModifyEffect(redOrbPingSwing, "", false);

            redOrbPingGround = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk11dilie");
            AddLightIntensityCurveWithCurve(
                redOrbPingGround.transform.GetChild(0).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.5f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk11dilie"
                );
            redOrbPingGround = ModifyEffect(redOrbPingGround, "", false);
        }

        private static void PopulatePrimary5Assets()
        {
            primary5Swing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk05");
            primary5Swing = ModifyEffect(primary5Swing, "", true);

            primary5Floor = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk05dilie");
            AddLightIntensityCurveWithCurve(
                primary5Floor.transform.GetChild(0).gameObject,
                new LightIntensityProps
                {
                    timeMax = 1f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk05dilie"
                );
            primary5Floor = ModifyEffect(primary5Floor, "", true);
        }

        private static void PopulatePrimary4Assets()
        {
            primary4Swing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk04");
            AddLightIntensityCurveWithCurve(
               primary4Swing.transform.GetChild(1).GetChild(0).gameObject,
               new LightIntensityProps
               {
                   timeMax = 1f,
                   loop = false,
                   randomStart = false,
                   enableNegativeLights = false,
               },
               "fxr4liangatk04"
               );
            primary4Swing = ModifyEffect(primary4Swing, "", true);

            primary4AfterImage = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk04canying");
            primary4AfterImage = ModifyEffect(primary4AfterImage, "", true);

            primary4Hit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk04hit");
            AddLightIntensityCurveWithCurve(
                primary4Hit.transform.GetChild(1).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.18f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk04hit-spjere"
                );
            AddLightIntensityCurveWithCurve(
                primary4Hit.transform.GetChild(0).GetChild(1).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.18f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk04hit-lightSC"
                );
            primary4Hit = ModifyEffect(primary4Hit, "", true);
        }

        public static void PopulatePrimary3Assets() 
        {
            primary3Swing1 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk03dilie1");
            primary3Swing1 = ModifyEffect(primary3Swing1, "", true);

            primary3Swing2 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk03dilie2");
            primary3Swing2 = ModifyEffect(primary3Swing2, "", true);

            primary3hit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk03hit01");
            AddLightIntensityCurveWithCurve(
                primary3hit.transform.GetChild(0).GetChild(1).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.12f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "Fxr4liangatk03hit01-lightSC"
                );
            AddLightIntensityCurveWithCurve(
                primary3hit.transform.GetChild(1).gameObject,
                new LightIntensityProps 
                {
                    timeMax = 0.18f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "fxr4liangatk03hit01-spjere"
                );
            primary3hit = ModifyEffect(primary3hit, "", true);
        }

        public static void PopulatePrimary2Assets()
        {
            primary2Shot = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk02");
            AddLightIntensityCurveWithCurve(
                primary2Shot.transform.GetChild(2).GetChild(0).gameObject,
                new LightIntensityProps 
                {
                    timeMax = 0.15f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                },
                "Fxr4liangatk02"
                );
            primary2Shot = ModifyEffect(primary2Shot, "", true);

            primary2hit1 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk02hit01");
            AddLightIntensityCurveWithCurve(
                primary2hit1.transform.GetChild(1).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.18f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false
                },
                "fxr4liangatk02hit01"
                );
            primary2hit1 = ModifyEffect(primary2hit1, "", true);

            primary2hit2 = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk02hit02");
            AddLightIntensityCurveWithCurve(
                primary2hit2.transform.GetChild(1).gameObject,
                new LightIntensityProps 
                {
                    timeMax = 0.18f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false
                },
                "fxr4liangatk02hit02-spjere"
                );
            AddLightIntensityCurveWithCurve(
                primary2hit2.transform.GetChild(0).GetChild(1).gameObject,
                new LightIntensityProps
                {
                    timeMax = 0.12f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false
                },
                "fxr4liangatk02hit02-lightSC"
                );
            primary2hit2 = ModifyEffect(primary2hit2, "", true);
        }

        public static void PopulatePrimary1Assets() 
        {
            primary1Swing = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk01");
            primary1Swing = ModifyEffect(primary1Swing, "", true);

            primary1Hit = Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("fxr4liangatk01hit");
            AddLightIntensityCurveWithCurve(
                primary1Hit.transform.GetChild(1).gameObject, 
                new LightIntensityProps 
                {
                    timeMax = 0.18f,
                    loop = false,
                    randomStart = false,
                    enableNegativeLights = false,
                }, 
                "Fxr4liangatk01hit");
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
