using RoR2;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.Modules
{
    internal static class ItemDisplays
    {
        private static Dictionary<string, GameObject> itemDisplayPrefabs = new Dictionary<string, GameObject>();

        internal static void PopulateDisplays()
        {
            PopulateFromBody("MageBody"); //commando is actually missing some displays
            PopulateFromBody("LunarExploderBody"); //solely for the perfected crown

            PopulateCustomLightningArm();

            //if you have any custom item displays to add here I would be very impressed
        }

        private static void PopulateFromBody(string bodyName)
        {
            ItemDisplayRuleSet itemDisplayRuleSet = RoR2.LegacyResourcesAPI.Load<GameObject>("Prefabs/CharacterBodies/" + bodyName).GetComponent<ModelLocator>().modelTransform.GetComponent<CharacterModel>().itemDisplayRuleSet;

            ItemDisplayRuleSet.KeyAssetRuleGroup[] item = itemDisplayRuleSet.keyAssetRuleGroups;

            for (int i = 0; i < item.Length; i++)
            {
                ItemDisplayRule[] rules = item[i].displayRuleGroup.rules;

                for (int j = 0; j < rules.Length; j++)
                {
                    GameObject followerPrefab = rules[j].followerPrefab;

                    // The game moved item display prefabs to addressables. Depending on load order
                    // (e.g. when other survivor mods are installed) the direct reference can still be
                    // null here, so resolve the addressable explicitly before giving up on it.
                    if (!followerPrefab && rules[j].followerPrefabAddress != null && rules[j].followerPrefabAddress.RuntimeKeyIsValid())
                    {
                        var displayAddress = rules[j].followerPrefabAddress;

                        // An AssetReference caches its own operation handle. If the load was already
                        // started (vanilla content loading, or two rules sharing the same reference)
                        // calling LoadAssetAsync again logs:
                        // "Attempting to load AssetReference that has already been loaded."
                        // Reuse the existing handle instead of starting a second load.
                        // OperationHandle is the non-generic AsyncOperationHandle, so its
                        // WaitForCompletion() returns 'object' - cast it to GameObject.
                        followerPrefab = displayAddress.OperationHandle.IsValid()
                            ? displayAddress.OperationHandle.WaitForCompletion() as GameObject
                            : displayAddress.LoadAssetAsync().WaitForCompletion() as GameObject;
                    }

                    if (followerPrefab)
                    {
                        string key = followerPrefab.name?.ToLowerInvariant();
                        if (!string.IsNullOrEmpty(key) && !itemDisplayPrefabs.ContainsKey(key))
                        {
                            itemDisplayPrefabs[key] = followerPrefab;
                        }
                    }
                }
            }
        }

        private static void PopulateCustomLightningArm()
        {
            Debug.Log("Loading custom lightning arm");
            foreach (var (key, value) in itemDisplayPrefabs)
            {
                Debug.Log(key + ": " + value.name);
            }
            #region IgnoreThisAndRunAway
            //seriously you don't need this
            //I see you're still here, well if you do need this here's what you do
            //but again you don't need this
            //capacitor is hardcoded to track your "UpperArmR", "LowerArmR", and "HandR" bones.
            //this is for having the lightning on custom bones in your childlocator

            // Do NOT hard-index the dictionary here. If "displaylightningarmright" wasn't collected
            // (addressable not resolved yet, another mod's content pack changing load order, etc.)
            // a KeyNotFoundException is thrown out of Awake() and aborts the rest of plugin init.
            if (!itemDisplayPrefabs.TryGetValue("displaylightningarmright", out GameObject lightningArmPrefab) || !lightningArmPrefab)
            {
                Log.Error("Could not find displaylightningarmright, skipping custom lightning arm.");
                return;
            }

            GameObject display = R2API.PrefabAPI.InstantiateClone(lightningArmPrefab, "DisplayLightningCustom", false);

            LimbMatcher limbMatcher = display.GetComponent<LimbMatcher>();
            if (limbMatcher && limbMatcher.limbPairs != null && limbMatcher.limbPairs.Length >= 3)
            {
                limbMatcher.limbPairs[0].targetChildLimb = "LightningArm1";
                limbMatcher.limbPairs[1].targetChildLimb = "LightningArm2";
                limbMatcher.limbPairs[2].targetChildLimb = "LightningArmEnd";
            }

            itemDisplayPrefabs["displaylightningarmcustom"] = display;
            #endregion
        }

        public static GameObject LoadDisplay(string name) {

            if (itemDisplayPrefabs.ContainsKey(name.ToLowerInvariant())) {

                if (itemDisplayPrefabs[name.ToLowerInvariant()]) {

                    GameObject display = itemDisplayPrefabs[name.ToLowerInvariant()];

                    return display;
                }
            }
            Log.Error("item display " + name + " returned null");
            return null;
        }
    }
}