using RoR2;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.Content.Controllers;
using R2API;
using System;
using LeeHyperrealMod.ParticleScripts;
using static Rewired.Controller;
using static RoR2.Skills.SkillFamily;

namespace LeeHyperrealMod.Modules
{
    internal class ParticleAssets
    {
        // BLUE
        internal static string DEFAULT_PARTICLE_VARIANT = "default";

        internal static ParticleColorInfo RED_PARTICLE = new ParticleColorInfo
        {
            name = "red",
            mainColor = new Color(1f, 0f, 0f),
            secondaryColor = new Color(1f, 0f, 0f),
            rimColor = new Color(1f, 0f, 0f),
            intensityMult = 1.8f
        };

        internal static ParticleColorInfo ORANGE_PARTICLE = new ParticleColorInfo
        {
            name = "orange",
            mainColor = new Color(1f, 30f / 255f, 0f),
            secondaryColor = new Color(1f, 30f / 255f, 0f),
            rimColor = new Color(1f, 30f / 255f, 0f),
            intensityMult = 1.7f
        };

        internal static ParticleColorInfo YELLOW_PARTICLE = new ParticleColorInfo
        {
            name = "yellow",
            mainColor = new Color(1f, 0.85f, 0f),
            secondaryColor = new Color(1f, 0.85f, 0f),
            rimColor = new Color(1f, 0.85f, 0f),
            intensityMult = 1.6f
        };

        internal static ParticleColorInfo GREEN_PARTICLE = new ParticleColorInfo
        {
            name = "green",
            mainColor = new Color(0f, 1f, 0f),
            secondaryColor = new Color(0f, 1f, 0f),
            rimColor = new Color(0f, 1f, 0f),
            intensityMult = 1.8f
        };

        internal static ParticleColorInfo LIGHTBLUE_PARTICLE = new ParticleColorInfo
        {
            name = "lightblue",
            mainColor = new Color(0f, 247f / 255f, 1f),
            secondaryColor = new Color(0f, 247f / 255f, 1f),
            rimColor = new Color(0f, 247f / 255f, 1f),
            intensityMult = 1.8f
        };

        internal static ParticleColorInfo VIOLET_PARTICLE = new ParticleColorInfo
        {
            name = "violet",
            mainColor = new Color(120f / 255f, 35f / 255f, 1f),
            secondaryColor = new Color(120f / 255f, 0f / 255f, 1f),
            rimColor = new Color(120f / 255f, 100f / 255f, 1f),
            intensityMult = 2.1f
        };

        internal static ParticleColorInfo PINK_PARTICLE = new ParticleColorInfo
        {
            name = "pink",
            mainColor = new Color(1f, 105f/ 255f, 180f/255f),
            secondaryColor = new Color(1f, 105f / 255f, 180f / 255f),
            rimColor = new Color(1f, 105f / 255f, 180f / 255f),
            intensityMult = 1.7f
        };

        internal static ParticleColorInfo DEFAULT_PARTICLE = new ParticleColorInfo
        {
            name = "default",
            mainColor = new Color(0f, 130f / 255f, 1f),
            secondaryColor = new Color(0f, 130f / 255f, 1f),
            rimColor = new Color(0f, 130f / 255f, 1f),
            intensityMult = 1f
        };

        //internal static Color BLUE_PARTICLE_COLOR = new Color(1f, 0f, 0f); //new Color(0.5176f, 0.0705f, 1f);
        internal static List<Material> GENERATED_GPU_MATERIALS;

        internal class ParticleColorInfo
        {
            internal string name;
            internal Color mainColor;
            internal Color secondaryColor;
            internal Color rimColor;
            internal float intensityMult;

            internal ParticleColorInfo() { }
            internal ParticleColorInfo(string name, Color mainColor, Color secondaryColor, Color rimColor, float intensityMult)
            {
                this.name = name;
                this.mainColor = mainColor;
                this.secondaryColor = secondaryColor;
                this.rimColor = rimColor;
                this.intensityMult = intensityMult;
            }
        }

        internal class ParticleVariant 
        {
            internal Dictionary<string, GameObject> colourVariants;
            internal bool shouldVariantCloneUseModify = true; 

            internal ParticleVariant() 
            {
                colourVariants = new Dictionary<string, GameObject>();            
            }

            internal ParticleVariant(string name, GameObject obj) 
            {
                colourVariants = new Dictionary<string, GameObject>
                {
                    { name, obj }
                };
            }
        }

        /*
            On access, you should look for the key for that move you want
            In the case of P1, access "p1" and then choose a variant, these should be 
            defined here.

            Variants planned
                - "default", // This is the blue one.
                - "red",

            e.g to access the blue variant, call the following: particleDictionary["p1"].colourVariants["default"] -> returns the gameobject you want to use.
         */

        internal static Dictionary<string, ParticleVariant> particleDictionary;

        #region Materials
        internal static List<Material> materialStorage = new List<Material>();
        #endregion

        #region Misc
        public static GameObject customCrosshair;
        #endregion

        public static float GetVFXIntensity(LeeHyperrealPassive.VFXPassive passive)  
        {
            switch (passive)
            {
                case LeeHyperrealPassive.VFXPassive.RED:
                    return RED_PARTICLE.intensityMult;
                case LeeHyperrealPassive.VFXPassive.ORANGE:
                    return ORANGE_PARTICLE.intensityMult;
                case LeeHyperrealPassive.VFXPassive.YELLOW:
                    return YELLOW_PARTICLE.intensityMult;
                case LeeHyperrealPassive.VFXPassive.GREEN:
                    return GREEN_PARTICLE.intensityMult;
                case LeeHyperrealPassive.VFXPassive.BLUE:
                    return -1f;
                case LeeHyperrealPassive.VFXPassive.LIGHTBLUE:
                    return LIGHTBLUE_PARTICLE.intensityMult;
                case LeeHyperrealPassive.VFXPassive.VIOLET:
                    return VIOLET_PARTICLE.intensityMult;
                case LeeHyperrealPassive.VFXPassive.PINK:
                    return PINK_PARTICLE.intensityMult;
                default:
                    return -1f;

            }
        }
                
        public static void Initialize() 
        {
            particleDictionary = new Dictionary<string, ParticleVariant>();

            UpdateAllBundleMaterials();
            CreateMaterialStorage(Modules.LeeHyperrealAssets.mainAssetBundle);
            PopulateAssets();

            // Generate Colour variants
            GenerateColorVariant(RED_PARTICLE);
            GenerateColorVariant(ORANGE_PARTICLE);
            GenerateColorVariant(YELLOW_PARTICLE);
            GenerateColorVariant(GREEN_PARTICLE);
            GenerateColorVariant(LIGHTBLUE_PARTICLE);
            GenerateColorVariant(VIOLET_PARTICLE);
            GenerateColorVariant(PINK_PARTICLE);
        }

        private static void UpdateAllBundleMaterials()
        {
            Material[] materials = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAllAssets<Material>();

            foreach (Material material in materials)
            {
                if (material.shader.name.StartsWith("StubbedRoR2"))
                {
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

        private static GameObject ModifyEffect(GameObject newEffect, string soundName, bool parentToTransform, float duration, VFXAttributes.VFXPriority priority = VFXAttributes.VFXPriority.Always, bool shouldNotPool = false)
        {
            DestroyOnTimer timer = newEffect.GetComponent<DestroyOnTimer>();
            if (!timer) 
            {
                newEffect.AddComponent<DestroyOnTimer>().duration = duration;
            }
            NetworkIdentity netid = newEffect.GetComponent<NetworkIdentity>();
            if (!netid)
            {
                netid = newEffect.AddComponent<NetworkIdentity>();
            }

            //else 
            //{
            //    //Reinit netid.
            //    UnityEngine.Object.DestroyImmediate(netid);
            //    netid = newEffect.AddComponent<NetworkIdentity>();
            //}
            VFXAttributes attr = newEffect.GetComponent<VFXAttributes>();
            if (!attr) 
            {
                attr = newEffect.AddComponent<VFXAttributes>();
            }
            attr.vfxPriority = priority;
            attr.DoNotPool = shouldNotPool;
            EffectComponent effect = newEffect.GetComponent<EffectComponent>();
            if (!effect) 
            {
                effect = newEffect.AddComponent<EffectComponent>();// probably already added.
            }
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

        public static void ModifyXEffectOnRenderer(Renderer rend, ParticleColorInfo newColor) 
        {
            //Check if the material is Xeffect
            foreach (Material mat in rend.materials) 
            {
                if (mat.shader.name == "Unlit/XEffect")
                {
                    Color tintOld = mat.GetColor("_TintColor");
                    float averagedVal = (tintOld.r + tintOld.g + tintOld.b) / 3f;
                    mat.SetColor("_TintColor", new Color(averagedVal, averagedVal, averagedVal, tintOld.a));

                    Color secondaryOld = mat.GetColor("_SecondColor");
                    float averagedSecond = (secondaryOld.r + secondaryOld.g + secondaryOld.b) / 3f;
                    mat.SetColor("_SecondColor", new Color(averagedSecond, averagedSecond, averagedSecond, secondaryOld.a));

                    //Get New Colour, figure out percentages for each and spread across colours in the same intensity
                    float oldR = mat.GetFloat("_EffectBrightnessR");
                    float oldG = mat.GetFloat("_EffectBrightnessG");
                    float oldB = mat.GetFloat("_EffectBrightnessB");

                    float divisor = oldR;
                    if (divisor < oldG) 
                    {
                        divisor = oldG;
                    }

                    if (divisor < oldB) 
                    {
                        divisor = oldB;
                    }

                    Color nonHDRColor = new Color(oldR / divisor, oldG / divisor, oldB / divisor);
                    float oldHue;
                    float oldSat;
                    float oldVal;
                    Color.RGBToHSV(nonHDRColor, out oldHue, out oldSat, out oldVal);
                    
                    float newHue;
                    float newSat;
                    float newVal;
                    Color.RGBToHSV(newColor.mainColor, out newHue, out newSat, out newVal);

                    Color outputNonHDRColor = Color.HSVToRGB(newHue, 1f, oldVal);
                    if (newColor.intensityMult >= 0)
                    {
                        divisor = divisor * newColor.intensityMult;
                    }
                    float newR = outputNonHDRColor.r * divisor;
                    float newG = outputNonHDRColor.g * divisor;
                    float newB = outputNonHDRColor.b * divisor;

                    // Modify the following properties:
                    mat.SetFloat("_EffectBrightnessR", newR);
                    mat.SetFloat("_EffectBrightnessG", newG);
                    mat.SetFloat("_EffectBrightnessB", newB);

                    if (newColor.intensityMult >= 0f)
                    {
                        mat.SetFloat("_EffectBrightness", mat.GetFloat("_EffectBrightness") * newColor.intensityMult);
                    }
                }
            }
        }

        public static void ModifyNoBatchingRenderers(Renderer rend, ParticleColorInfo newColor)
        {
            foreach (Material mat in rend.materials)
            {
                //Check if the material is Xeffect
                if (mat.shader.name == "Unlit/EffectNoBatching")
                {
                    Color tintOld = mat.GetColor("_TintColor");
                    float averagedVal = (tintOld.r + tintOld.g + tintOld.b) / 3f;
                    mat.SetColor("_TintColor", new Color(averagedVal, averagedVal, averagedVal, tintOld.a));

                    Color secondaryOld = mat.GetColor("_SecondColor");
                    float averagedSecond = (secondaryOld.r + secondaryOld.g + secondaryOld.b) / 3f;
                    mat.SetColor("_SecondColor", new Color(averagedSecond, averagedSecond, averagedSecond, secondaryOld.a));

                    //Get New Colour, figure out percentages for each and spread across colours in the same intensity
                    float oldR = mat.GetFloat("_EffectBrightnessR");
                    float oldG = mat.GetFloat("_EffectBrightnessG");
                    float oldB = mat.GetFloat("_EffectBrightnessB");

                    float divisor = oldR;
                    if (divisor < oldG)
                    {
                        divisor = oldG;
                    }

                    if (divisor < oldB)
                    {
                        divisor = oldB;
                    }

                    Color nonHDRColor = new Color(oldR / divisor, oldG / divisor, oldB / divisor);
                    float oldHue;
                    float oldSat;
                    float oldVal;
                    Color.RGBToHSV(nonHDRColor, out oldHue, out oldSat, out oldVal);

                    float newHue;
                    float newSat;
                    float newVal;
                    Color.RGBToHSV(newColor.mainColor, out newHue, out newSat, out newVal);

                    Color outputNonHDRColor = Color.HSVToRGB(newHue, 1f, oldVal);

                    if (newColor.intensityMult >= 0) 
                    {
                        divisor = divisor * newColor.intensityMult;
                    }

                    float newR = outputNonHDRColor.r * divisor;
                    float newG = outputNonHDRColor.g * divisor;
                    float newB = outputNonHDRColor.b * divisor;

                    // Modify the following properties:
                    mat.SetFloat("_EffectBrightnessR", newR);
                    mat.SetFloat("_EffectBrightnessG", newG);
                    mat.SetFloat("_EffectBrightnessB", newB);


                    if (newColor.intensityMult >= 0f)
                    {
                        mat.SetFloat("_EffectBrightness", mat.GetFloat("_EffectBrightness") * newColor.intensityMult);
                    }
                }
            }
        }

        public static void ModifyGPUParticles(GPUParticlePlayer player, ParticleColorInfo newColor) 
        {
            if (player.mat.shader.name == "Unlit/GPUParticle")
            {
                Material material = new Material(player.mat);

                //Get New Colour, figure out percentages for each and spread across colours in the same intensity
                float oldR = material.GetFloat("_R_Intensity");
                float oldG = material.GetFloat("_G_Intensity");
                float oldB = material.GetFloat("_B_Intensity");

                float divisor = oldR;
                if (divisor < oldG)
                {
                    divisor = oldG;
                }

                if (divisor < oldB)
                {
                    divisor = oldB;
                }

                Color nonHDRColor = new Color(oldR / divisor, oldG / divisor, oldB / divisor);
                float oldHue;
                float oldSat;
                float oldVal;
                Color.RGBToHSV(nonHDRColor, out oldHue, out oldSat, out oldVal);

                float newHue;
                float newSat;
                float newVal;
                Color.RGBToHSV(newColor.mainColor, out newHue, out newSat, out newVal);

                Color outputNonHDRColor = Color.HSVToRGB(newHue, 1f, oldVal);
                if (newColor.intensityMult >= 0)
                {
                    divisor = divisor * newColor.intensityMult;
                }
                float newR = outputNonHDRColor.r * divisor;
                float newG = outputNonHDRColor.g * divisor;
                float newB = outputNonHDRColor.b * divisor;

                // Modify the following properties:
                material.SetFloat("_R_Intensity", newR);
                material.SetFloat("_G_Intensity", newG);
                material.SetFloat("_B_Intensity", newB);

                if (newColor.intensityMult >= 0f)
                {
                    material.SetFloat("_Intensity", material.GetFloat("_Intensity") * newColor.intensityMult);
                }

                player.mat = material;
            }
        }


        public static void ModifyCloneRenderers(Renderer rend, ParticleColorInfo newColor)
        {
            foreach (Material mat in rend.materials)
            {
                //Check if the material is Xeffect
                if (mat.shader.name == "ASESampleShaders/DitheringFadeModify")
                {
                    mat.SetColor("_Tint", newColor.mainColor);
                }
            }
        }

        public static void ModifySnipeFloorRenderer(Renderer rend, ParticleColorInfo newColor)
        {
            //Check if the material is Xeffect
            if (rend.material.shader.name == "Snipe Floor")
            {
                rend.material.SetColor("_MainColor", newColor.mainColor);
            }
        }

        private static void ModifySuperSprint(Renderer rend, ParticleColorInfo newColor)
        {
            //Check if the material is Xeffect
            if (rend.material.shader.name == "Super Sprint")
            {
                rend.material.SetColor("_MainColor", newColor.mainColor);
            }
        }

        public static void ModifyLights(Light light, ParticleColorInfo color)
        {
            if (light) 
            {
                light.color = color.mainColor;
            }
        }


        #region Particle Effect Retrieval

        public static GameObject RetrieveParticleEffect(string particleName, string variant)
        {
            if (!particleDictionary.ContainsKey(particleName))
            {
                return null; // Failed!
            }

            return particleDictionary[particleName].colourVariants[variant];
        }

        public static UnityEngine.Color RetrieveParticleColor(CharacterBody body) 
        {
            switch (body.GetComponent<LeeHyperrealPassive>().GetVFXPassive())
            {
                case LeeHyperrealPassive.VFXPassive.RED:
                    return RED_PARTICLE.mainColor;
                case LeeHyperrealPassive.VFXPassive.ORANGE:
                    return ORANGE_PARTICLE.mainColor;
                case LeeHyperrealPassive.VFXPassive.YELLOW:
                    return YELLOW_PARTICLE.mainColor;
                case LeeHyperrealPassive.VFXPassive.GREEN:
                    return GREEN_PARTICLE.mainColor;
                case LeeHyperrealPassive.VFXPassive.BLUE:
                    return DEFAULT_PARTICLE.mainColor;
                case LeeHyperrealPassive.VFXPassive.LIGHTBLUE:
                    return LIGHTBLUE_PARTICLE.mainColor;
                case LeeHyperrealPassive.VFXPassive.VIOLET:
                    return VIOLET_PARTICLE.mainColor;
                case LeeHyperrealPassive.VFXPassive.PINK:
                    return PINK_PARTICLE.mainColor;
            }

            //Get Skin index
            uint skinIndex = body.skinIndex;

            //Get related skin particle effect
            if (Modules.Survivors.LeeHyperreal.redVFXSkins.Contains((int)skinIndex))
            {
                return RED_PARTICLE.mainColor;
            }

            if (Modules.Survivors.LeeHyperreal.orangeVFXSkins.Contains((int)skinIndex))
            {
                return ORANGE_PARTICLE.mainColor;
            }

            if (Modules.Survivors.LeeHyperreal.lightBlueVFXSkins.Contains((int)skinIndex))
            {
                return LIGHTBLUE_PARTICLE.mainColor;
            }

            return DEFAULT_PARTICLE.mainColor;
        }

        public static GameObject RetrieveParticleEffectFromSkin(string particleName, CharacterBody body = null) 
        {
            //Checking if such a name exists for this particle.
            if (!particleDictionary.ContainsKey(particleName)) 
            {
                return null; // Failed!
            }

            ParticleVariant variants = particleDictionary[particleName];

            // Exit early, we don't know what variant they have selected and they explicitly used this one!
            if (!body) 
            {
                return variants.colourVariants[DEFAULT_PARTICLE_VARIANT];
            }

            LeeHyperrealPassive.VFXPassive selectedPassive = body.GetComponent<LeeHyperrealPassive>().GetVFXPassive();
            if (selectedPassive == LeeHyperrealPassive.VFXPassive.RANDOM) 
            {
                //check random
                Array values = Enum.GetValues(typeof(LeeHyperrealPassive.VFXPassive));
                System.Random rand = new System.Random();
                LeeHyperrealPassive.VFXPassive randomPassive = (LeeHyperrealPassive.VFXPassive)values.GetValue(rand.Next(values.Length));

                selectedPassive = randomPassive;
            }

            //Check if the user has selected a passive instead'
            switch (selectedPassive) 
            {
                case LeeHyperrealPassive.VFXPassive.RED:
                    return variants.colourVariants[RED_PARTICLE.name];
                case LeeHyperrealPassive.VFXPassive.ORANGE:
                    return variants.colourVariants[ORANGE_PARTICLE.name];
                case LeeHyperrealPassive.VFXPassive.YELLOW:
                    return variants.colourVariants[YELLOW_PARTICLE.name];
                case LeeHyperrealPassive.VFXPassive.GREEN:
                    return variants.colourVariants[GREEN_PARTICLE.name];
                case LeeHyperrealPassive.VFXPassive.BLUE:
                    return variants.colourVariants[DEFAULT_PARTICLE_VARIANT];
                case LeeHyperrealPassive.VFXPassive.LIGHTBLUE:
                    return variants.colourVariants[LIGHTBLUE_PARTICLE.name];
                case LeeHyperrealPassive.VFXPassive.VIOLET:
                    return variants.colourVariants[VIOLET_PARTICLE.name];
                case LeeHyperrealPassive.VFXPassive.PINK:
                    return variants.colourVariants[PINK_PARTICLE.name];
            }

            //Well shit, they chose default, go back to the usual programming.

            //Get Skin index
            uint skinIndex = body.skinIndex;

            //Get related skin particle effect
            if (Modules.Survivors.LeeHyperreal.redVFXSkins.Contains((int)skinIndex)) 
            {
                if (variants.colourVariants.ContainsKey(RED_PARTICLE.name)) 
                {
                    return variants.colourVariants[RED_PARTICLE.name];
                }
            }

            if (Modules.Survivors.LeeHyperreal.orangeVFXSkins.Contains((int)skinIndex)) 
            {
                if (variants.colourVariants.ContainsKey(ORANGE_PARTICLE.name))
                {
                    return variants.colourVariants[ORANGE_PARTICLE.name];
                }
            }

            if (Modules.Survivors.LeeHyperreal.lightBlueVFXSkins.Contains((int)skinIndex)) 
            {
                if (variants.colourVariants.ContainsKey(LIGHTBLUE_PARTICLE.name))
                {
                    return variants.colourVariants[LIGHTBLUE_PARTICLE.name];
                }
            }

            //all else fails, just send them the default
            return variants.colourVariants[DEFAULT_PARTICLE_VARIANT];
        }

        private static void GenerateColorVariant(ParticleColorInfo color)
        {
            foreach (KeyValuePair<string, ParticleVariant> item in particleDictionary)
            {
                ParticleVariant pVar = item.Value;
                Dictionary<string, GameObject> pVarColourVar = item.Value.colourVariants;
                if (pVarColourVar.ContainsKey(color.name)) 
                {
                    //Skip processing, we already have a variant e.g RED for this prefab.
                    continue;
                }

                //Get default 
                GameObject defaultVariant = pVarColourVar[DEFAULT_PARTICLE_VARIANT];
                GameObject clone = PrefabAPI.InstantiateClone(defaultVariant, defaultVariant.name + "-" + color.name, false);

                Renderer[] rends = clone.GetComponentsInChildren<Renderer>();
                foreach (Renderer rend in rends)
                {
                    //Modify with the new colour on XEffect, may need more functions to convert more later
                    ModifyXEffectOnRenderer(rend, color);
                    ModifyNoBatchingRenderers(rend, color);
                    ModifySnipeFloorRenderer(rend, color);
                    ModifyCloneRenderers(rend, color);
                    ModifySuperSprint(rend, color);
                }

                Light[] lights = clone.GetComponentsInChildren<Light>(true);
                foreach (Light light in lights) 
                {
                    ModifyLights(light, color);
                }

                GPUParticlePlayer[] gpuPlayers = clone.GetComponentsInChildren<GPUParticlePlayer>();
                foreach (GPUParticlePlayer player in gpuPlayers) 
                {
                    ModifyGPUParticles(player, color);
                }

                //check if the prefab is a clone prefab, and skip the ModifyEffect registration
                if (pVar.shouldVariantCloneUseModify) 
                {
                    //Get original sound from default
                    EffectComponent effectComp = defaultVariant.GetComponent<EffectComponent>();
                    string soundname = "";
                    bool parentToTransform = true;
                    if (effectComp)
                    {
                        soundname = effectComp.soundName;
                        parentToTransform = effectComp.parentToReferencedTransform;
                    }

                    //Retrieve the timer if it has one
                    DestroyOnTimer timer = defaultVariant.GetComponent<DestroyOnTimer>();
                    float duration = 1f;
                    if (timer) 
                    {
                        duration = timer.duration;
                    }

                    VFXAttributes.VFXPriority priority = VFXAttributes.VFXPriority.Always;
                    bool shouldNotPool = false;

                    //Get custom variables
                    SetPriorityAndPooling(ref priority, ref shouldNotPool, item.Key);

                    //Finally resetup the prefab
                    ModifyEffect(clone, soundname, parentToTransform, duration, priority, shouldNotPool);
                }

                //Register the new prefab under name
                pVarColourVar.Add(color.name, clone);
            }
        }

        private static void SetPriorityAndPooling(ref VFXAttributes.VFXPriority priority, ref bool shouldNotPool, string effectName) 
        {
            switch (effectName) 
            {
                case "snipe":
                    priority = VFXAttributes.VFXPriority.Medium;
                    shouldNotPool = false;
                    return;
                case "snipeBulletCasing":
                    priority = VFXAttributes.VFXPriority.Low;
                    shouldNotPool = false;
                    return;
            }
        }

        #endregion

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

            #region Clone Masters
            PopulateMasterClonePrefabs();
            #endregion

            #region Misc
            PopulateMiscAssets();
            #endregion
        }

        private static void PopulateMasterClonePrefabs()
        {
            GameObject leeMasterClone = GetGameObjectFromBundle("LeeMasterClone");
            leeMasterClone.AddComponent<LeeHyperrealCloneController>();
            GameObject scarletMasterClone = GetGameObjectFromBundle("ScarletMasterClone");
            scarletMasterClone.AddComponent<LeeHyperrealCloneController>();
            GameObject prospectorMasterClone = GetGameObjectFromBundle("ProspectorMasterClone");
            prospectorMasterClone.AddComponent<LeeHyperrealCloneController>();
            GameObject comradeMasterClone = GetGameObjectFromBundle("ComradeMasterClone");
            comradeMasterClone.AddComponent<LeeHyperrealCloneController>();
            GameObject yiMasterClone = GetGameObjectFromBundle("YiMasterClone");
            yiMasterClone.AddComponent<LeeHyperrealCloneController>();
            GameObject bkMasterClone = GetGameObjectFromBundle("BKMasterClone");
            bkMasterClone.AddComponent<LeeHyperrealCloneController>();

            ParticleVariant leeMasterObjectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, leeMasterClone);
            leeMasterObjectVariant.shouldVariantCloneUseModify = false;
            ParticleVariant scarletMasterObjectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, scarletMasterClone);
            scarletMasterObjectVariant.shouldVariantCloneUseModify = false;
            ParticleVariant prospectorMasterObjectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, prospectorMasterClone);
            prospectorMasterObjectVariant.shouldVariantCloneUseModify = false;
            ParticleVariant comradeMasterObjectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, comradeMasterClone);
            comradeMasterObjectVariant.shouldVariantCloneUseModify = false;
            ParticleVariant yiMasterCloneVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yiMasterClone);
            yiMasterCloneVariant.shouldVariantCloneUseModify = false;
            ParticleVariant bkMasterCloneVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, bkMasterClone);
            bkMasterCloneVariant.shouldVariantCloneUseModify = false;

            particleDictionary.Add("leeMasterClone", leeMasterObjectVariant);
            particleDictionary.Add("scarletMasterClone", scarletMasterObjectVariant);
            particleDictionary.Add("prospectorMasterClone", prospectorMasterObjectVariant);
            particleDictionary.Add("comradeMasterClone", comradeMasterObjectVariant);
            particleDictionary.Add("yiMasterClone", yiMasterCloneVariant);
            particleDictionary.Add("bkMasterClone", bkMasterCloneVariant);
        }

        private static void PopulateMiscAssets()
        {
            GameObject jumpEffect = GetGameObjectFromBundle("Extra Jump Floor");
            EffectUnparenter effectUnparenter = jumpEffect.AddComponent<EffectUnparenter>();
            effectUnparenter.duration = 0.175f;
            ModifyEffect(jumpEffect, "", true, 1.5f, VFXAttributes.VFXPriority.Always);

            GameObject jetpack = GetGameObjectFromBundle("Ror Skin Jetpack");
            ParticleVariant jetpackVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, jetpack);
            jetpackVariant.shouldVariantCloneUseModify = false;

            GameObject superSprint = GetGameObjectFromBundle("SuperSprintVFX");
            superSprint.AddComponent<DestroySprintOnDelay>();
            ParticleVariant superSprintVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, superSprint);
            superSprintVariant.shouldVariantCloneUseModify = false;

            customCrosshair = GetGameObjectFromBundle("Lee Crosshair");

            particleDictionary.Add("jumpEffect", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, jumpEffect));
            particleDictionary.Add("skinJetpack", jetpackVariant);
            particleDictionary.Add("superSprint", superSprintVariant);
        }

        private static void PopulateAerialDomainAssets()
        {
            ParticleVariant primaryAerialParticleVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, GetGameObjectFromBundle("DomainMidairLoop"));
            primaryAerialParticleVariant.shouldVariantCloneUseModify = false;

            GameObject primaryAerialEffectEnd = GetGameObjectFromBundle("DomainMidairEnd");
            primaryAerialEffectEnd = ModifyEffect(primaryAerialEffectEnd, "Play_c_liRk4_skill_yellow_dilie", false, 2f);
            ParticleVariant primaryAerialEnd = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primaryAerialEffectEnd);

            // Add to dictionary
            particleDictionary.Add("primaryAerialLoop", primaryAerialParticleVariant);
            particleDictionary.Add("primaryAerialEnd", primaryAerialEnd);
        }

        private static void PopulateDisplayParticleAssets()
        {
            GameObject displayLandingEffect = GetGameObjectFromBundle("fxr4liangborn1");
            displayLandingEffect.AddComponent<DestroyOnTimer>().duration = 5f;
            ParticleVariant displayLandingEffectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, displayLandingEffect);

            particleDictionary.Add("displayLandingEffect", displayLandingEffectVariant);
        }

        private static void PopulateUltimateAssets()
        {
            //ultGunEffect = GetGameObjectFromBundle("");
            //ultGunEffect = ModifyEffect(ultGunEffect, "", true);

            GameObject ultTracerEffect = GetGameObjectFromBundle("fxr4liangatk51xuli");
            ModifyEffect(ultTracerEffect, "", true, 6f);

            GameObject ultShootingEffect = GetGameObjectFromBundle("Cannon Ult Shot Extra Prefab");
            ModifyEffect(ultShootingEffect, "", true, 6f);

            GameObject ultPreExplosionProjectile = GetGameObjectFromBundle("fxr4liangatk51");
            ModifyEffect(ultPreExplosionProjectile, "Play_c_liRk4_skill_ultimate_blast", true, 5f);

            GameObject ultExplosion = GetGameObjectFromBundle("fxr4liangatk51zha");
            ModifyEffect(ultExplosion, "", true, 5f);

            particleDictionary.Add("ultTracerEffect", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultTracerEffect));
            particleDictionary.Add("ultShootingEffect", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultShootingEffect));
            particleDictionary.Add("ultPreExplosionProjectile", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultPreExplosionProjectile));
            particleDictionary.Add("ultExplosion", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultExplosion));
        }

        private static void PopulateDomainUltimateAssets()
        {
            GameObject ultimateDomainFinisherEffect = GetGameObjectFromBundle("fxr4liangatk42suiping");
            ultimateDomainFinisherEffect.AddComponent<DestroyOnTimer>().duration = 2f;
            ParticleVariant ultimateDomainFinisherEffectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultimateDomainFinisherEffect);
            ultimateDomainFinisherEffectVariant.shouldVariantCloneUseModify = false;

            GameObject ultimateDomainCEASEYOUREXISTANCE = GetGameObjectFromBundle("Cease");
            ultimateDomainCEASEYOUREXISTANCE.AddComponent<DestroyOnTimer>().duration = 2f;
            ParticleVariant ultimateDomainCEASEYOUREXISTANCEVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultimateDomainCEASEYOUREXISTANCE);
            ultimateDomainFinisherEffectVariant.shouldVariantCloneUseModify = false;

            GameObject domainOverlayEffect = GetGameObjectFromBundle("fxr4liangatk51pingmu"); // Control manually.
            ParticleVariant domainOverlayEffectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, domainOverlayEffect);
            domainOverlayEffectVariant.shouldVariantCloneUseModify = false;

            GameObject ultimateDomainBulletFinisher = GetGameObjectFromBundle("fxr4liangatk42zhongjie01");
            ModifyEffect(ultimateDomainBulletFinisher, "", true, 10f);

            GameObject ultimateDomainClone1 = GetGameObjectFromBundle("DomainUltClone1");
            ModifyEffect(ultimateDomainClone1, "", true, 2f, VFXAttributes.VFXPriority.Always);

            GameObject ultimateDomainClone2 = GetGameObjectFromBundle("DomainUltClone2");
            ModifyEffect(ultimateDomainClone2, "", true, 2f, VFXAttributes.VFXPriority.Always);

            GameObject ultimateDomainClone3 = GetGameObjectFromBundle("DomainUltClone3");
            ModifyEffect(ultimateDomainClone3, "", true, 2f, VFXAttributes.VFXPriority.Always);

            particleDictionary.Add("ultimateDomainFinisherEffect", ultimateDomainFinisherEffectVariant);
            particleDictionary.Add("ultimateDomainCEASEYOUREXISTANCE", ultimateDomainCEASEYOUREXISTANCEVariant);
            particleDictionary.Add("domainOverlayEffect", domainOverlayEffectVariant);
            particleDictionary.Add("ultimateDomainBulletFinisher", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultimateDomainBulletFinisher));
            particleDictionary.Add("ultimateDomainClone1", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultimateDomainClone1));
            particleDictionary.Add("ultimateDomainClone2", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultimateDomainClone2));
            particleDictionary.Add("ultimateDomainClone3", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, ultimateDomainClone3));
        }

        private static void PopulateDomainTransitionAssets()
        {
            GameObject transitionEffectLee = GetGameObjectFromBundle("fxr4liangatk41");
            ModifyEffect(transitionEffectLee, "", true);

            GameObject transitionEffectGround = GetGameObjectFromBundle("fxr4liangatk41bao");
            ModifyEffect(transitionEffectGround, "", true);

            GameObject transitionEffectHit = GetGameObjectFromBundle("fxr4liangatk41hit");
            ModifyEffect(transitionEffectHit, "", true);

            GameObject domainFieldLoopEffect = GetGameObjectFromBundle("fxr4liangatk41loop");
            ParticleVariant domainFieldLoopEffectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, domainFieldLoopEffect);
            domainFieldLoopEffectVariant.shouldVariantCloneUseModify = false;
            GameObject domainFieldEndEffect = GetGameObjectFromBundle("fxr4liangatk41out");
            ParticleVariant domainFieldEndEffectVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, domainFieldEndEffect);
            domainFieldEndEffectVariant.shouldVariantCloneUseModify = false;

            particleDictionary.Add("transitionEffectLee", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, transitionEffectLee));
            particleDictionary.Add("transitionEffectGround", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, transitionEffectGround));
            particleDictionary.Add("transitionEffectHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, transitionEffectHit));
            particleDictionary.Add("domainFieldLoopEffect", domainFieldLoopEffectVariant);
            particleDictionary.Add("domainFieldEndEffect", domainFieldEndEffectVariant);
        }

        private static void PopulateDodgeAssets()
        {
            GameObject dodgeForwards = GetGameObjectFromBundle("fxr4liangmove01");
            ModifyEffect(dodgeForwards, "Play_c_liRk4_act_flash_1", true);

            GameObject dodgeBackwards = GetGameObjectFromBundle("fxr4liangmove02");
            ModifyEffect(dodgeBackwards, "Play_c_liRk4_act_flash_2", true);

            particleDictionary.Add("dodgeForwards", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, dodgeForwards));
            particleDictionary.Add("dodgeBackwards", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, dodgeBackwards));
        }

        private static void PopulateParryAssets()
        {
            GameObject normalParry = GetGameObjectFromBundle("Normal Parry");
            ModifyEffect(normalParry, "", true);

            GameObject bigParry = GetGameObjectFromBundle("Big Parry");
            ModifyEffect(bigParry, "", true);

            particleDictionary.Add("normalParry", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, normalParry));
            particleDictionary.Add("bigParry", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, bigParry));
        }

        private static void PopulateSnipeAssets()
        {
            GameObject snipeStart = GetGameObjectFromBundle("fxr4liangatk23");
            ModifyEffect(snipeStart, "", true);

            GameObject snipe = GetGameObjectFromBundle("fxr4liangatk24");
            ModifyEffect(snipe, "", false, 1.25f, VFXAttributes.VFXPriority.Medium);

            GameObject snipeHitEnhanced = GetGameObjectFromBundle("fxr4liangatk24bao");
            ModifyEffect(snipeHitEnhanced, "Play_c_liRk4_atk_ex_3_break", true, 2f);

            GameObject snipeHit = GetGameObjectFromBundle("fxr4liangatk24hit");
            ModifyEffect(snipeHit, "Play_c_liRk4_imp_ex_3_1", true, 2f);

            GameObject snipeGround = GetGameObjectFromBundle("fxr4liangatk24ground");
            ModifyEffect(snipeGround, "", true, 2f);

            GameObject snipeBulletCasing = GetGameObjectFromBundle("fxr4liangatk24bulletcasing");
            ModifyEffect(snipeBulletCasing, "", true, 2f, VFXAttributes.VFXPriority.Low);

            GameObject snipeDodge = GetGameObjectFromBundle("fxr4liangatk28");
            ModifyEffect(snipeDodge, "Play_c_liRk4_act_flash_3", true);

            GameObject snipeAerialFloor = GetGameObjectFromBundle("Snipe Floor");
            snipeAerialFloor.AddComponent<DestroyPlatformOnDelay>();
            ParticleVariant snipeAerialFloorVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipeAerialFloor);
            snipeAerialFloorVariant.shouldVariantCloneUseModify = false;

            GameObject rifleLaser = GetGameObjectFromBundle("fxr4liangatk25weaponcase1");
            ParticleVariant rifleLaserVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, rifleLaser);
            rifleLaserVariant.shouldVariantCloneUseModify = false;

            particleDictionary.Add("snipeStart", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipeStart));
            particleDictionary.Add("snipe", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipe));
            particleDictionary.Add("snipeHitEnhanced", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipeHitEnhanced));
            particleDictionary.Add("snipeHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipeHit));
            particleDictionary.Add("snipeGround", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipeGround));
            particleDictionary.Add("snipeBulletCasing", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipeBulletCasing));
            particleDictionary.Add("snipeDodge", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, snipeDodge));
            particleDictionary.Add("snipeAerialFloor", snipeAerialFloorVariant);
            particleDictionary.Add("rifleLaser", rifleLaserVariant);
        }

        private static void PopulateYellowOrbAssets()
        {
            GameObject yellowOrbSwing = GetGameObjectFromBundle("fxr4liangatk34dilie");
            ModifyEffect(yellowOrbSwing, "Play_c_liRk4_skill_yellow", true);

            GameObject yellowOrbSwingHit = GetGameObjectFromBundle("fxr4liangatk34hit");
            ModifyEffect(yellowOrbSwingHit, "Play_c_liRk4_imp_yellow_1", true);

            GameObject yellowOrbKick = GetGameObjectFromBundle("fxr4liangatk32");
            ModifyEffect(yellowOrbKick, "Play_c_liRk4_skill_yellow_fire", true);

            GameObject yellowOrbMultishot = GetGameObjectFromBundle("fxr4liangatk35");
            ModifyEffect(yellowOrbMultishot, "", true);

            GameObject yellowOrbMultishotHit = GetGameObjectFromBundle("fxr4liangatk35hit");
            ModifyEffect(yellowOrbMultishotHit, "", true);

            GameObject yellowOrbDomainBulletLeftovers = GetGameObjectFromBundle("fxr4liangatk35dandao");
            yellowOrbDomainBulletLeftovers.AddComponent<DestroyOnTimer>().duration = 150f;
            ParticleVariant yellowOrbDomainBulletLeftoversVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yellowOrbDomainBulletLeftovers);
            yellowOrbDomainBulletLeftoversVariant.shouldVariantCloneUseModify = false;

            //GameObject yellowOrbDomainClone = GetGameObjectFromBundle("YellowOrbDomainClone");
            //LeeHyperrealCloneFlicker flicker = yellowOrbDomainClone.AddComponent<LeeHyperrealCloneFlicker>();
            //ParticleVariant yellowOrbDomainCloneVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yellowOrbDomainClone);
            //yellowOrbDomainCloneVariant.shouldVariantCloneUseModify = false;

            particleDictionary.Add("yellowOrbSwing", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yellowOrbSwing));
            particleDictionary.Add("yellowOrbSwingHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yellowOrbSwingHit));
            particleDictionary.Add("yellowOrbKick", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yellowOrbKick));
            particleDictionary.Add("yellowOrbMultishot", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yellowOrbMultishot));
            particleDictionary.Add("yellowOrbMultishotHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, yellowOrbMultishotHit));
            particleDictionary.Add("yellowOrbDomainBulletLeftovers", yellowOrbDomainBulletLeftoversVariant);
            //particleDictionary.Add("yellowOrbDomainClone", yellowOrbDomainCloneVariant);
        }

        private static void PopulateBlueOrbAssets()
        {
            GameObject blueOrbShot = GetGameObjectFromBundle("fxr4liangatk20");
            ModifyEffect(blueOrbShot, "Play_c_liRk4_skill_blue", true);

            GameObject blueOrbHit = GetGameObjectFromBundle("fxr4liangatk20hit");
            ModifyEffect(blueOrbHit, "Play_c_liRk4_imp_blue", true);

            GameObject blueOrbGroundHit = GetGameObjectFromBundle("fxr4liangatk20bao");
            ModifyEffect(blueOrbGroundHit, "Play_c_liRk4_skill_blue_dilie", true, 3f);

            particleDictionary.Add("blueOrbShot", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, blueOrbShot));
            particleDictionary.Add("blueOrbHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, blueOrbHit));
            particleDictionary.Add("blueOrbGroundHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, blueOrbGroundHit));
        }

        private static void PopulateRedOrbAssets()
        {
            GameObject redOrbSwing = GetGameObjectFromBundle("fxr4liangatk10");
            ModifyEffect(redOrbSwing, "Play_c_liRk4_skill_red", true);

            GameObject redOrbHit = GetGameObjectFromBundle("fxr4liangatk10hit02");
            ModifyEffect(redOrbHit, "Play_c_liRk4_imp_red_1", false);

            GameObject redOrbPingSwing = GetGameObjectFromBundle("fxr4liangatk11");
            ModifyEffect(redOrbPingSwing, "", false, 3f);

            GameObject redOrbPingGround = GetGameObjectFromBundle("fxr4liangatk11dilie");
            ModifyEffect(redOrbPingGround, "", false, 3f);

            GameObject redOrbDomainFloorImpact = GetGameObjectFromBundle("fxr4liangatk14dilie");
            ModifyEffect(redOrbDomainFloorImpact, "Play_c_liRk4_atk_ex_2", false);

            GameObject redOrbDomainHit = GetGameObjectFromBundle("fxr4liangatk14fshit01");
            ModifyEffect(redOrbDomainHit, "Play_c_liRk4_imp_ex_2_2", false);

            //GameObject redOrbDomainClone = GetGameObjectFromBundle("RedOrbDomainClone");
            //redOrbDomainClone.AddComponent<LeeHyperrealCloneFlicker>();
            //redOrbDomainClone.AddComponent<LeeHyperrealCloneMeshSwapper>();
            //ParticleVariant redOrbDomainCloneVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbDomainClone);
            //redOrbDomainCloneVariant.shouldVariantCloneUseModify = false;

            //GameObject redOrbDomainCloneStart = GetGameObjectFromBundle("RedOrbDomainCloneStart");
            //redOrbDomainCloneStart.AddComponent<LeeHyperrealCloneFlicker>();
            //redOrbDomainClone.AddComponent<LeeHyperrealCloneMeshSwapper>();
            //ParticleVariant redOrbDomainCloneStartVariant = new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbDomainCloneStart);
            //redOrbDomainCloneStartVariant.shouldVariantCloneUseModify = false;

            particleDictionary.Add("redOrbSwing", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbSwing));
            particleDictionary.Add("redOrbHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbHit));
            particleDictionary.Add("redOrbPingSwing", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbPingSwing));
            particleDictionary.Add("redOrbPingGround", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbPingGround));
            particleDictionary.Add("redOrbDomainFloorImpact", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbDomainFloorImpact));
            particleDictionary.Add("redOrbDomainHit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, redOrbDomainHit));
            //particleDictionary.Add("redOrbDomainClone", redOrbDomainCloneVariant);
            //particleDictionary.Add("redOrbDomainCloneStart", redOrbDomainCloneStartVariant);
        }

        private static void PopulatePrimary5Assets()
        {
            GameObject primary5Swing = GetGameObjectFromBundle("fxr4liangatk05");
            ModifyEffect(primary5Swing, "Play_c_liRk4_atk_nml_5_jump", true, 1.5f);

            GameObject primary5Floor = GetGameObjectFromBundle("fxr4liangatk05dilie");
            ModifyEffect(primary5Floor, "Play_c_liRk4_atk_nml_5_dilie", false, 1.5f);

            particleDictionary.Add("primary5Swing", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary5Swing));
            particleDictionary.Add("primary5Floor", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary5Floor));
        }

        private static void PopulatePrimary4Assets()
        {
            GameObject primary4Swing = GetGameObjectFromBundle("fxr4liangatk04");
            ModifyEffect(primary4Swing, "", true, 2f);

            GameObject primary4AfterImage = GetGameObjectFromBundle("fxr4liangatk04canying");
            ModifyEffect(primary4AfterImage, "", true, 2f);

            GameObject primary4Hit = GetGameObjectFromBundle("fxr4liangatk04hit");
            ModifyEffect(primary4Hit, "", true);

            particleDictionary.Add("primary4Swing", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary4Swing));
            particleDictionary.Add("primary4AfterImage", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary4AfterImage));
            particleDictionary.Add("primary4Hit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary4Hit));
        }

        public static void PopulatePrimary3Assets() 
        {
            GameObject primary3Swing1 = GetGameObjectFromBundle("fxr4liangatk03dilie1");
            ModifyEffect(primary3Swing1, "Play_c_liRk4_atk_nml_3_dilie_1", false, 3f);

            GameObject primary3Swing2 = GetGameObjectFromBundle("fxr4liangatk03dilie2");
            ModifyEffect(primary3Swing2, "Play_c_liRk4_atk_nml_3_dilie_2", false, 3f);

            GameObject primary3hit = GetGameObjectFromBundle("fxr4liangatk03hit01");
            ModifyEffect(primary3hit, "", false, 1.5f);

            particleDictionary.Add("primary3Swing1", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary3Swing1));
            particleDictionary.Add("primary3Swing2", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary3Swing2));
            particleDictionary.Add("primary3Hit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary3hit));
        }

        public static void PopulatePrimary2Assets()
        {
            GameObject primary2Shot = GetGameObjectFromBundle("fxr4liangatk02");
            ModifyEffect(primary2Shot, "Play_c_liRk4_atk_nml_2", true);

            GameObject primary2hit1 = GetGameObjectFromBundle("fxr4liangatk02hit01");
            ModifyEffect(primary2hit1, "", true);

            GameObject primary2hit2 = GetGameObjectFromBundle("fxr4liangatk02hit02");
            ModifyEffect(primary2hit2, "", true);

            particleDictionary.Add("primary2Shot", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary2Shot));
            particleDictionary.Add("primary2hit1", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary2hit1));
            particleDictionary.Add("primary2hit2", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary2hit2));
        }

        public static void PopulatePrimary1Assets() 
        {
            GameObject primary1Swing = GetGameObjectFromBundle("fxr4liangatk01");
            ModifyEffect(primary1Swing, "Play_c_liRk4_atk_nml_1", true);

            GameObject primary1Hit = GetGameObjectFromBundle("fxr4liangatk01hit");
            ModifyEffect(primary1Hit, "", true);

            GameObject primary1Floor = GetGameObjectFromBundle("fxr4liangatk01dilie");
            ModifyEffect(primary1Floor, "", true);


            particleDictionary.Add("primary1Swing", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary1Swing));
            particleDictionary.Add("primary1Hit", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary1Hit));
            particleDictionary.Add("primary1Floor", new ParticleVariant(DEFAULT_PARTICLE_VARIANT, primary1Floor));
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
