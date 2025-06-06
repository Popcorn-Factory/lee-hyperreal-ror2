using R2API;
using RoR2;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.Modules
{
    internal static class Skins
    {
        internal static SkinDef CreateSkinDef(string skinName, Sprite skinIcon, CharacterModel.RendererInfo[] defaultRendererInfos, GameObject root, UnlockableDef unlockableDef = null)
        {
            SkinDefInfo skinDefInfo = new SkinDefInfo
            {
                BaseSkins = Array.Empty<SkinDef>(),
                Icon = skinIcon,
                Name = skinName,
                NameToken = skinName,
                RendererInfos = new CharacterModel.RendererInfo[defaultRendererInfos.Length],
                RootObject = root,
                UnlockableDef = unlockableDef
            };

            On.RoR2.SkinDef.Awake += DoNothing;

            SkinDef skinDef = ScriptableObject.CreateInstance<RoR2.SkinDef>();
            skinDef.baseSkins = skinDefInfo.BaseSkins;
            skinDef.icon = skinDefInfo.Icon;
            skinDef.unlockableDef = skinDefInfo.UnlockableDef;
            skinDef.rootObject = skinDefInfo.RootObject;
            skinDef.nameToken = skinDefInfo.NameToken;
            skinDef.name = skinDefInfo.Name;

            SkinDefParams skinDefParams = ScriptableObject.CreateInstance<RoR2.SkinDefParams>();
            skinDefParams.projectileGhostReplacements = new SkinDefParams.ProjectileGhostReplacement[0];
            skinDefParams.minionSkinReplacements = new SkinDefParams.MinionSkinReplacement[0];
            skinDefParams.meshReplacements = new SkinDefParams.MeshReplacement[0];
            skinDefParams.gameObjectActivations = new SkinDefParams.GameObjectActivation[0];
            defaultRendererInfos.CopyTo(skinDefInfo.RendererInfos, 0);
            skinDefParams.rendererInfos = skinDefInfo.RendererInfos;

            skinDef.skinDefParams = skinDefParams;

            On.RoR2.SkinDef.Awake -= DoNothing;

            return skinDef;
        }

        private static void DoNothing(On.RoR2.SkinDef.orig_Awake orig, RoR2.SkinDef self)
        {
            //????
        }

        internal struct SkinDefInfo
        {
            internal SkinDef[] BaseSkins;
            internal Sprite Icon;
            internal string NameToken;
            internal UnlockableDef UnlockableDef;
            internal GameObject RootObject;
            internal CharacterModel.RendererInfo[] RendererInfos;
            internal string Name;
        }

        private static CharacterModel.RendererInfo[] getRendererMaterials(CharacterModel.RendererInfo[] defaultRenderers, params Material[] materials)
        {
            CharacterModel.RendererInfo[] newRendererInfos = new CharacterModel.RendererInfo[defaultRenderers.Length];
            defaultRenderers.CopyTo(newRendererInfos, 0);

            for (int i = 0; i < newRendererInfos.Length; i++)
            {
                try
                {
                    newRendererInfos[i].defaultMaterial = materials[i];
                }
                catch
                {
                    Log.Error("error adding skin rendererinfo material. make sure you're not passing in too many");
                }
            }

            return newRendererInfos;
        }
        /// <summary>
        /// pass in strings for mesh assets in your bundle. pass the same amount and order based on your rendererinfos, filling with null as needed
        /// <code>
        /// myskindef.meshReplacements = Modules.Skins.getMeshReplacements(defaultRenderers,
        ///    "meshHenrySword",
        ///    null,
        ///    "meshHenry");
        /// </code>
        /// </summary>
        /// <param name="defaultRendererInfos">your skindef's rendererinfos to access the renderers</param>
        /// <param name="meshes">name of the mesh assets in your project</param>
        /// <returns></returns>
        internal static SkinDefParams.MeshReplacement[] getMeshReplacements(CharacterModel.RendererInfo[] defaultRendererInfos, params string[] meshes)
        {

            List<SkinDefParams.MeshReplacement> meshReplacements = new List<SkinDefParams.MeshReplacement>();

            for (int i = 0; i < defaultRendererInfos.Length; i++)
            {
                if (string.IsNullOrEmpty(meshes[i]))
                    continue;

                meshReplacements.Add(
                new SkinDefParams.MeshReplacement
                {
                    renderer = defaultRendererInfos[i].renderer,
                    mesh = LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>(meshes[i])
                });
            }

            return meshReplacements.ToArray();
        }
    }
}