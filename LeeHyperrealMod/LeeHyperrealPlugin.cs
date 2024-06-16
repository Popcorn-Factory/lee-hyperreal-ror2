﻿using BepInEx;
using BepInEx.Bootstrap;
using LeeHyperrealMod.Modules.Survivors;
using R2API.Utils;
using RoR2;
using System.Collections.Generic;
using System.Security;
using System.Security.Permissions;
using UnityEngine;
using EmotesAPI;
using System;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking;
using R2API.Networking.Interfaces;
using ShaderSwapper;
using Rewired.UI.ControlMapper;

[module: UnverifiableCode]
[assembly: SecurityPermission(SecurityAction.RequestMinimum, SkipVerification = true)]

//rename this namespace
namespace LeeHyperrealMod
{
    [BepInDependency("com.bepis.r2api", BepInDependency.DependencyFlags.HardDependency)]

    [BepInDependency("com.rune580.riskofoptions", BepInDependency.DependencyFlags.SoftDependency)]
    [BepInDependency("com.weliveinasociety.CustomEmotesAPI", BepInDependency.DependencyFlags.SoftDependency)]
    [NetworkCompatibility(CompatibilityLevel.EveryoneMustHaveMod, VersionStrictness.EveryoneNeedSameModVersion)]
    [BepInPlugin(MODUID, MODNAME, MODVERSION)]
    [R2APISubmoduleDependency(new string[]
    {
        "PrefabAPI",
        "LanguageAPI",
        "SoundAPI",
        "UnlockableAPI"
    })]

    public class LeeHyperrealPlugin : BaseUnityPlugin
    {
        // if you don't change these you're giving permission to deprecate the mod-
        //  please change the names to your own stuff, thanks
        //   this shouldn't even have to be said
        public const string MODUID = "com.PopcornFactory.LeeHyperrealMod";
        public const string MODNAME = "LeeHyperrealMod";
        public const string MODVERSION = "0.0.12";

        // a prefix for name tokens to prevent conflicts- please capitalize all name tokens for convention
        public const string DEVELOPER_PREFIX = "POPCORN";

        public static LeeHyperrealPlugin instance;

        private void Awake()
        {
            instance = this;

            Log.Init(Logger);
            Modules.Assets.Initialize(); // load assets and read config
            base.StartCoroutine(Modules.Assets.mainAssetBundle.UpgradeStubbedShadersAsync());
            Modules.ParticleAssets.Initialize();
            Modules.Config.ReadConfig();

            if (Chainloader.PluginInfos.ContainsKey("com.rune580.riskofoptions"))
            {
                Modules.Config.SetupRiskOfOptions();
            }

            Modules.States.RegisterStates(); // register states for networking
            Modules.Buffs.RegisterBuffs(); // add and register custom buffs/debuffs
            Modules.Projectiles.RegisterProjectiles(); // add and register custom projectiles
            Modules.Tokens.AddTokens(); // register name tokens
            Modules.ItemDisplays.PopulateDisplays(); // collect item display prefabs for use in our display rules

            // survivor initialization
            new LeeHyperreal().Initialize();

            //networking
            NetworkingAPI.RegisterMessageType<PerformForceNetworkRequest>();
            NetworkingAPI.RegisterMessageType<SetFreezeOnBodyRequest>();
            NetworkingAPI.RegisterMessageType<SetPauseTriggerNetworkRequest>();
            NetworkingAPI.RegisterMessageType<PlaySoundNetworkRequest>();
            NetworkingAPI.RegisterMessageType<UltimateObjectSpawnNetworkRequest>();

            // now make a content pack and add it- this part will change with the next update
            new Modules.ContentPacks().Initialize();

            Hook();
        }

        private void Hook()
        {
            // run hooks here, disabling one is as simple as commenting out the line
            On.RoR2.CharacterBody.RecalculateStats += CharacterBody_RecalculateStats;
            On.RoR2.CharacterModel.Start += CharacterModel_Start;
            On.RoR2.HealthComponent.TakeDamage += HealthComponent_TakeDamage;
            //On.RoR2.CharacterBody.Update += CharacterBody_Update;

            if (Chainloader.PluginInfos.ContainsKey("com.weliveinasociety.CustomEmotesAPI"))
            {
                On.RoR2.SurvivorCatalog.Init += SurvivorCatalog_Init;
            }
        }

        private void HealthComponent_TakeDamage(On.RoR2.HealthComponent.orig_TakeDamage orig, HealthComponent self, DamageInfo damageInfo)
        {

            if (self)
            {
                if (self.body)
                {
                    if (self.body.HasBuff(Modules.Buffs.invincibilityBuff)) 
                    {
                        damageInfo.rejected = true;
                        damageInfo.damage = 0f;
                    }

                    if (self.body.baseNameToken == DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_NAME") 
                    {
                        if (self.body.HasBuff(Modules.Buffs.parryBuff)) 
                        {
                            bool doBigParry = false;
                            if (damageInfo.damage > self.fullHealth * Modules.StaticValues.bigParryHealthFrac) 
                            {
                                doBigParry = true;
                            }

                            //Reject damage, return to ~~monke~~ pause in state.
                            damageInfo.rejected = true;
                            damageInfo.damage = 0f;

                            new SetPauseTriggerNetworkRequest(self.body.master.netId, true, doBigParry).Send(NetworkDestination.Clients);

                            //Stun the attacker
                            if (damageInfo.attacker) 
                            {
                                HealthComponent attackerHealthComp = damageInfo.attacker.GetComponent<HealthComponent>();
                                if (attackerHealthComp) 
                                {
                                    DamageInfo stunInfo = new DamageInfo
                                    {
                                        damage = damageInfo.damage / 2f,
                                        attacker = self.body.gameObject,
                                        crit = self.body.RollCrit(),
                                        damageType = DamageType.Stun1s,
                                        damageColorIndex = DamageColorIndex.Default
                                    };
                                    attackerHealthComp.TakeDamage(stunInfo);
                                }
                            }
                        }
                    }
                }
            }

            orig(self, damageInfo);
        }

        private void CharacterModel_Start(On.RoR2.CharacterModel.orig_Start orig, CharacterModel self)
        {
            orig(self);
            if (self.gameObject.name.Contains("LeeHyperrealDisplay"))
            {
                LeeHyperrealDisplayController displayHandler = self.gameObject.GetComponent<LeeHyperrealDisplayController>();
                if (!displayHandler)
                {
                    displayHandler = self.gameObject.AddComponent<LeeHyperrealDisplayController>();
                }
            }
        }

        private void SurvivorCatalog_Init(On.RoR2.SurvivorCatalog.orig_Init orig)
        {
            orig();
            foreach (var item in SurvivorCatalog.allSurvivorDefs)
            {
                if (item.bodyPrefab.name == "LeeHyperrealBody")
                {
                    CustomEmotesAPI.ImportArmature(item.bodyPrefab, Modules.Assets.mainAssetBundle.LoadAsset<GameObject>("humanoidLeeHyperreal"));
                }
            }
        }

        private void CharacterBody_RecalculateStats(On.RoR2.CharacterBody.orig_RecalculateStats orig, CharacterBody self)
        {
            orig(self);

            // a simple stat hook, adds armor after stats are recalculated
            if (self)
            {
            
            }
        }
    }
}