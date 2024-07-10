using RoR2;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.Modules.Characters
{
    internal class LeeHyperrealItemDisplays : ItemDisplaysBase
    {
        protected override void SetItemDisplayRules(List<ItemDisplayRuleSet.KeyAssetRuleGroup> itemDisplayRules)
        {
            //paste all your displays here
            //sotv item displays not added yet. you can add them yourself from DLC1Content if you like. I believe in ya
            #region Item Displays
            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Jetpack,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBugWings"),
childName = "Chest",
localPos = new Vector3(0.05599F, -0.00287F, 0.00441F),
localAngles = new Vector3(0F, 270F, 0F),
localScale = new Vector3(0.1F, 0.1F, 0.1F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.GoldGat,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGoldGat"),
childName = "ShoulderL",
localPos = new Vector3(0.02022F, 0.10317F, -0.17368F),
localAngles = new Vector3(28.47433F, 355.95F, 130.2749F),
localScale = new Vector3(0.05399F, 0.05353F, 0.05399F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.BFG,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBFG"),
childName = "ShoulderL",
localPos = new Vector3(0F, 0F, 0F),
localAngles = new Vector3(0F, 90F, 315F),
localScale = new Vector3(0.2297F, 0.2297F, 0.2297F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.CritGlasses,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGlasses"),
childName = "Head",
localPos = new Vector3(-0.11683F, 0.13508F, 0.00406F),
localAngles = new Vector3(326.6815F, 271.4411F, 358.1049F),
localScale = new Vector3(0.19455F, 0.18359F, 0.18359F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Syringe,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySyringeCluster"),
childName = "UpperarmL",
localPos = new Vector3(-0.03541F, 0.14928F, -0.00583F),
localAngles = new Vector3(0F, 340F, 70.00001F),
localScale = new Vector3(0.1F, 0.1F, 0.1F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Behemoth,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBehemoth"),
childName = "CannonTipStretch",
localPos = new Vector3(0.00974F, 0.54756F, -0.1283F),
localAngles = new Vector3(356.0157F, 177.2968F, 0.53823F),
localScale = new Vector3(0.04037F, 0.04037F, 0.04037F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Missile,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayMissileLauncher"),
childName = "CannonTipStretch",
localPos = new Vector3(-0.18217F, 0.57003F, -0.00727F),
localAngles = new Vector3(270F, 90F, 0F),
localScale = new Vector3(0.06429F, 0.06429F, 0.06399F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Dagger,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayDagger"),
childName = "ShoulderR",
localPos = new Vector3(-0.02669F, 0.05927F, 0.05293F),
localAngles = new Vector3(292.4269F, 15.96809F, 144.4474F),
localScale = new Vector3(0.29022F, 0.29022F, 0.2872F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Hoof,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayHoof"),
childName = "CalfR",
localPos = new Vector3(-0.03679F, 0.46808F, -0.04918F),
localAngles = new Vector3(67.01733F, 91.11732F, 346.3165F),
localScale = new Vector3(0.0211F, 0.02112F, 0.01891F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ChainLightning,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayUkulele"),
childName = "WeaponCase",
localPos = new Vector3(-0.06103F, -0.59655F, 0.24351F),
localAngles = new Vector3(0.56914F, 276.5148F, 181.8305F),
localScale = new Vector3(0.24784F, 0.24784F, 0.24784F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.GhostOnKill,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayMask"),
childName = "CalfL",
localPos = new Vector3(-0.04313F, 0.08597F, 0.00427F),
localAngles = new Vector3(347.1985F, 261.809F, 178.8544F),
localScale = new Vector3(0.37677F, 0.37677F, 0.37677F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Mushroom,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayMushroom"),
childName = "ShoulderL",
localPos = new Vector3(-0.03367F, 0.05102F, -0.06705F),
localAngles = new Vector3(9.58999F, 326.6974F, 83.59933F),
localScale = new Vector3(0.02494F, 0.02494F, 0.02494F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.AttackSpeedOnCrit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWolfPelt"),
childName = "ShoulderR",
localPos = new Vector3(0.02259F, 0.1224F, 0.0474F),
localAngles = new Vector3(15.13525F, 89.97064F, 43.64096F),
localScale = new Vector3(0.15032F, 0.15032F, 0.15032F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BleedOnHit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayTriTip"),
childName = "SubmachineMain",
localPos = new Vector3(0.00032F, -0.0168F, 0.25924F),
localAngles = new Vector3(0.38262F, 359.4307F, 229.9383F),
localScale = new Vector3(0.1728F, 0.1728F, 0.1728F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.WardOnLevel,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWarbanner"),
childName = "WeaponCase",
localPos = new Vector3(0.10813F, -0.14973F, 0.20407F),
localAngles = new Vector3(0F, 270F, 90F),
localScale = new Vector3(0.21014F, 0.21014F, 0.21014F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.HealOnCrit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayScythe"),
childName = "ThighR",
localPos = new Vector3(0.06863F, 0.23453F, -0.09227F),
localAngles = new Vector3(282.9168F, 70.09832F, 290.784F),
localScale = new Vector3(0.20176F, 0.20176F, 0.20176F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.HealWhileSafe,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySnail"),
childName = "SubmachineMain",
localPos = new Vector3(0.02599F, 0.08278F, 0.04935F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.0289F, 0.0289F, 0.0289F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Clover,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayClover"),
childName = "RifleMain",
localPos = new Vector3(0.0267F, 0.03444F, 0.19782F),
localAngles = new Vector3(11.31532F, 174.1491F, 86.11386F),
localScale = new Vector3(0.18949F, 0.18949F, 0.18949F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BarrierOnOverHeal,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAegis"),
childName = "ForearmL",
localPos = new Vector3(-0.01308F, 0.08021F, -0.03771F),
localAngles = new Vector3(88.4568F, 164.0215F, 148.2735F),
localScale = new Vector3(0.0658F, 0.0658F, 0.0658F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.GoldOnHit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBoneCrown"),
childName = "Head",
localPos = new Vector3(-0.01575F, 0.14347F, 0.05477F),
localAngles = new Vector3(50.06754F, 315.3609F, 325.8994F),
localScale = new Vector3(0.27892F, 0.27892F, 0.27892F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.WarCryOnMultiKill,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayPauldron"),
childName = "ShoulderL",
localPos = new Vector3(0.06882F, 0.08223F, -0.04583F),
localAngles = new Vector3(352.1561F, 179.6555F, 73.44093F),
localScale = new Vector3(0.24916F, 0.24916F, 0.24916F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.SprintArmor,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBuckler"),
childName = "UpperarmR",
localPos = new Vector3(0.03658F, 0.08976F, 0.0447F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.09F, 0.09F, 0.09F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.IceRing,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayIceRing"),
childName = "CannonTipStretch",
localPos = new Vector3(-0.00771F, -0.21878F, -0.01473F),
localAngles = new Vector3(271.1152F, 277.778F, 105.159F),
localScale = new Vector3(1.46432F, 1.46432F, 1.46432F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayIceRing"),
childName = "WeaponCase",
localPos = new Vector3(0.00725F, 0.41792F, 0.18422F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.54575F, 0.54575F, 0.54575F),
                            limbMask = LimbFlags.None
                        }

                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.FireRing,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFireRing"),
childName = "CannonTipStretch",
localPos = new Vector3(-0.0159F, -0.02215F, -0.00699F),
localAngles = new Vector3(271.8136F, 289.7438F, 77.01118F),
localScale = new Vector3(1.46761F, 1.46761F, 1.42814F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFireRing"),
childName = "WeaponCase",
localPos = new Vector3(0.01077F, -0.47412F, 0.1855F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.54575F, 0.54575F, 0.53108F),
                            limbMask = LimbFlags.None
                        }
                    }

                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.UtilitySkillMagazine,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAfterburnerShoulderRing"),
                            childName = "Chest",
                            localPos = new Vector3(0F, -0.02001F, -0.0319F),
                            localAngles = new Vector3(89.97202F, 290.0697F, 0F),
                            localScale = new Vector3(0.37659F, 0.37659F, 0.37659F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAfterburnerShoulderRing"),
                            childName = "Chest",
                            localPos = new Vector3(0.00016F, -0.02034F, 0.03212F),
                            localAngles = new Vector3(83.63955F, 44.36956F, 141.5555F),
                            localScale = new Vector3(0.37659F, 0.37659F, 0.37659F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.JumpBoost,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWaxBird"),
childName = "WeaponCase",
localPos = new Vector3(0.05524F, -0.53166F, 0.38308F),
localAngles = new Vector3(271.6142F, 104.7141F, 263.8886F),
localScale = new Vector3(0.5253F, 0.5253F, 0.5253F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ArmorReductionOnHit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWarhammer"),
childName = "ThighL",
localPos = new Vector3(-0.04887F, 0.16492F, 0.09263F),
localAngles = new Vector3(79.2801F, 279.0936F, 301.612F),
localScale = new Vector3(0.07064F, 0.07064F, 0.07064F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.NearbyDamageBonus,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayDiamond"),
childName = "SubmachineMain",
localPos = new Vector3(-0.00071F, 0.08444F, 0.27329F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.02228F, 0.02228F, 0.02228F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ArmorPlate,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayRepulsionArmorPlate"),
childName = "Chest",
localPos = new Vector3(-0.09523F, 0.05039F, 0.05753F),
localAngles = new Vector3(284.0708F, 113.7817F, 168.1993F),
localScale = new Vector3(0.08474F, 0.08474F, 0.08474F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.CommandMissile,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayMissileRack"),
childName = "Chest",
localPos = new Vector3(0.10018F, 0.18238F, 0.00169F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.24729F, 0.24729F, 0.24729F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Feather,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFeather"),
childName = "FootL",
localPos = new Vector3(-0.04595F, -0.35153F, 0.0323F),
localAngles = new Vector3(341.2012F, 274.8207F, 192.2418F),
localScale = new Vector3(0.0126F, 0.0126F, 0.0126F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Crowbar,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayCrowbar"),
childName = "FootL",
localPos = new Vector3(0F, 0.1219F, -0.0764F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.1936F, 0.1936F, 0.1936F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.FallBoots,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGravBoots"),
childName = "CalfR",
localPos = new Vector3(0.0032F, 0.38044F, -0.00661F),
localAngles = new Vector3(351.8642F, 78.38302F, 187.4645F),
localScale = new Vector3(0.13726F, 0.13726F, 0.13726F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGravBoots"),
childName = "CalfL",
localPos = new Vector3(0.00719F, 0.35657F, 0.00376F),
localAngles = new Vector3(349.9485F, 99.58595F, 178.2831F),
localScale = new Vector3(0.1377F, 0.1377F, 0.1377F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ExecuteLowHealthElite,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGuillotine"),
childName = "WeaponCase",
localPos = new Vector3(0.10168F, 0.41574F, 0.16815F),
localAngles = new Vector3(83.38201F, 192.3172F, 94.39822F),
localScale = new Vector3(0.10364F, 0.10364F, 0.10364F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.EquipmentMagazine,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBattery"),
childName = "WeaponCase",
localPos = new Vector3(0.0991F, -0.60551F, 0.17165F),
localAngles = new Vector3(0F, 95F, 180F),
localScale = new Vector3(0.096F, 0.096F, 0.096F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.NovaOnHeal,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayDevilHorns"),
childName = "Head",
localPos = new Vector3(-0.06448F, 0.11365F, -0.04916F),
localAngles = new Vector3(282.3408F, 234.78F, 248.6609F),
localScale = new Vector3(0.31914F, 0.31914F, 0.31914F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayDevilHorns"),
childName = "Head",
localPos = new Vector3(-0.06448F, 0.11365F, 0.04916F),
localAngles = new Vector3(69.68186F, 122.6336F, 53.61706F),
localScale = new Vector3(-0.31914F, -0.31914F, -0.31914F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Infusion,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayInfusion"),
childName = "WeaponCase",
localPos = new Vector3(0.09518F, -0.00726F, 0.17393F),
localAngles = new Vector3(358.7858F, 91.62571F, 268.7358F),
localScale = new Vector3(0.40197F, 0.40197F, 0.40197F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Medkit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayMedkit"),
childName = "Lowerspine",
localPos = new Vector3(-0.10789F, -0.03775F, -0.01247F),
localAngles = new Vector3(275.0095F, 122.5156F, 144.0028F),
localScale = new Vector3(0.20617F, 0.20617F, 0.20617F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Bandolier,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBandolier"),
childName = "Lowerspine",
localPos = new Vector3(0.02508F, 0.00299F, -0.01048F),
localAngles = new Vector3(285.0419F, 152.24F, 207.2494F),
localScale = new Vector3(0.27223F, 0.39121F, 0.39121F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BounceNearby,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayHook"),
childName = "WeaponCase",
localPos = new Vector3(-0.08081F, -0.4523F, 0.20564F),
localAngles = new Vector3(58.15363F, 286.0486F, 12.40594F),
localScale = new Vector3(0.214F, 0.214F, 0.214F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.IgniteOnKill,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGasoline"),
childName = "FootL",
localPos = new Vector3(0.0494F, 0.0954F, 0.0015F),
localAngles = new Vector3(90F, 0F, 0F),
localScale = new Vector3(0.3165F, 0.3165F, 0.3165F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.StunChanceOnHit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayStunGrenade"),
childName = "Lowerspine",
localPos = new Vector3(-0.09515F, -0.10826F, 0.10648F),
localAngles = new Vector3(280F, 180F, 180F),
localScale = new Vector3(0.3856F, 0.3856F, 0.3856F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Firework,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFirework"),
childName = "SubmachineMain",
localPos = new Vector3(0.0287F, 0.04471F, 0.12639F),
localAngles = new Vector3(12.05189F, 350.9267F, 66.45092F),
localScale = new Vector3(0.1194F, 0.1194F, 0.1194F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.LunarDagger,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayLunarDagger"),
childName = "RifleMain",
localPos = new Vector3(0.02575F, 0.0498F, 0.38728F),
localAngles = new Vector3(15.24353F, 0.22339F, 273.029F),
localScale = new Vector3(0.14006F, 0.14006F, 0.14006F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Knurl,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayKnurl"),
childName = "Lowerspine",
localPos = new Vector3(-0.08429F, -0.01096F, 0.12332F),
localAngles = new Vector3(0F, 90F, 0F),
localScale = new Vector3(0.03277F, 0.03277F, 0.03277F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BeetleGland,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBeetleGland"),
childName = "CalfR",
localPos = new Vector3(0.04864F, 0.44634F, -0.00275F),
localAngles = new Vector3(332.4982F, 25.46641F, 332.0024F),
localScale = new Vector3(0.03867F, 0.03867F, 0.03867F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.SprintBonus,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySoda"),
childName = "SubmachineMain",
localPos = new Vector3(-0.03173F, 0.06024F, 0.11224F),
localAngles = new Vector3(270F, 251.0168F, 0F),
localScale = new Vector3(0.1655F, 0.1655F, 0.1655F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.SecondarySkillMagazine,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayDoubleMag"),
childName = "RifleMain",
localPos = new Vector3(0.02989F, 0.0366F, -0.0958F),
localAngles = new Vector3(25.5646F, 0.6586F, 355.0574F),
localScale = new Vector3(0.0441F, 0.0441F, 0.0441F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.StickyBomb,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayStickyBomb"),
childName = "SubmachineMain",
localPos = new Vector3(0.00092F, 0.16259F, 0.03231F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.10847F, 0.10847F, 0.10847F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.TreasureCache,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayKey"),
childName = "Chest",
localPos = new Vector3(-0.09374F, 0.04719F, -0.06836F),
localAngles = new Vector3(2.36173F, 343.0718F, 76.95858F),
localScale = new Vector3(0.22912F, 0.22912F, 0.22912F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BossDamageBonus,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAPRound"),
childName = "RifleMain",
localPos = new Vector3(0.02714F, 0.04054F, -0.21307F),
localAngles = new Vector3(86.28606F, 87.71285F, 0.44996F),
localScale = new Vector3(0.37613F, 0.37613F, 0.37613F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.SlowOnHit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBauble"),
childName = "Lowerspine",
localPos = new Vector3(-0.01663F, -0.22893F, -0.20435F),
localAngles = new Vector3(359.0852F, 34.437F, 0.03821F),
localScale = new Vector3(0.22345F, 0.22345F, 0.22345F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ExtraLife,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayHippo"),
childName = "CannonTipStretch",
localPos = new Vector3(0.22163F, 0.35996F, -0.00635F),
localAngles = new Vector3(282.1311F, 96.76801F, 175.8324F),
localScale = new Vector3(0.12894F, 0.12894F, 0.12894F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.KillEliteFrenzy,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBrainstalk"),
childName = "RifleMain",
localPos = new Vector3(0.0031F, 0.09166F, 0.16623F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.14038F, 0.14038F, 0.14038F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.RepeatHeal,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayCorpseFlower"),
childName = "Head",
localPos = new Vector3(-0.07739F, 0.16587F, 0.05296F),
localAngles = new Vector3(348.4032F, 66.48242F, 49.49538F),
localScale = new Vector3(0.09809F, 0.09809F, 0.09809F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.AutoCastEquipment,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFossil"),
childName = "Chest",
localPos = new Vector3(-0.07995F, 0.10611F, -0.05719F),
localAngles = new Vector3(2.07615F, 347.3439F, 348.1757F),
localScale = new Vector3(0.11549F, 0.11549F, 0.11549F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.IncreaseHealing,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAntler"),
childName = "Head",
localPos = new Vector3(-0.01965F, 0.15764F, 0.06386F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.12232F, 0.12232F, 0.12232F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAntler"),
childName = "Head",
localPos = new Vector3(-0.01965F, 0.15764F, -0.06386F),
localAngles = new Vector3(0F, 180F, 0F),
localScale = new Vector3(0.12232F, 0.12232F, 0.12232F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.TitanGoldDuringTP,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGoldHeart"),
childName = "WeaponCase",
localPos = new Vector3(-0.0949F, 0.35026F, 0.14245F),
localAngles = new Vector3(352.2849F, 230.7796F, 90.59948F),
localScale = new Vector3(0.1191F, 0.1191F, 0.1191F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.SprintWisp,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBrokenMask"),
childName = "CalfR",
localPos = new Vector3(-0.09632F, 0.12537F, -0.00669F),
localAngles = new Vector3(348.9888F, 270.5609F, 181.668F),
localScale = new Vector3(0.11891F, 0.11891F, 0.11891F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BarrierOnKill,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBrooch"),
childName = "FootL",
localPos = new Vector3(-0.04803F, -0.1646F, -0.0015F),
localAngles = new Vector3(65.33152F, 273.0871F, 5.73554F),
localScale = new Vector3(0.2982F, 0.2982F, 0.2982F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.TPHealingNova,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGlowFlower"),
childName = "Head",
localPos = new Vector3(-0.07828F, 0.16856F, -0.03505F),
localAngles = new Vector3(320.8832F, 239.9608F, 3.09478F),
localScale = new Vector3(0.14834F, 0.14834F, 0.14834F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.LunarUtilityReplacement,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBirdFoot"),
childName = "CalfL",
localPos = new Vector3(0.06895F, 0.44135F, 0.00604F),
localAngles = new Vector3(0F, 180F, 0F),
localScale = new Vector3(0.2833F, 0.2833F, 0.2833F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Thorns,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayRazorwireLeft"),
childName = "CalfL",
localPos = new Vector3(-0.02404F, 0.47239F, -0.02503F),
localAngles = new Vector3(81.881F, 349.0211F, 348.7278F),
localScale = new Vector3(0.4814F, 0.4814F, 0.4814F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.LunarPrimaryReplacement,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBirdEye"),
childName = "Chest",
localPos = new Vector3(-0.0091F, 0.18203F, -0.00044F),
localAngles = new Vector3(358.7469F, 359.5154F, 259.0507F),
localScale = new Vector3(0.12888F, 0.12888F, 0.12888F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.NovaOnLowHealth,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayJellyGuts"),
childName = "RifleEnd",
localPos = new Vector3(0.00417F, -0.10459F, -0.0303F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.02922F, 0.02922F, 0.02922F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.LunarTrinket,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBeads"),
childName = "WeaponCase",
localPos = new Vector3(-0.03286F, -0.13498F, 0.0889F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.89815F, 0.89815F, 0.89815F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Plant,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayInterstellarDeskPlant"),
childName = "ShoulderR",
localPos = new Vector3(0.00058F, 0.05812F, 0.0989F),
localAngles = new Vector3(335F, 0F, 90F),
localScale = new Vector3(0.02853F, 0.02853F, 0.02853F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Bear,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBear"),
childName = "WeaponCase",
localPos = new Vector3(0.09484F, -0.49136F, 0.15942F),
localAngles = new Vector3(7.67833F, 90.2774F, 267.5603F),
localScale = new Vector3(0.11045F, 0.11045F, 0.11045F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.DeathMark,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayDeathMark"),
childName = "ThighL",
localPos = new Vector3(0.01079F, 0.23051F, 0.09875F),
localAngles = new Vector3(278.4452F, 137.8694F, 50.39653F),
localScale = new Vector3(-0.01624F, -0.01476F, -0.02009F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ExplodeOnDeath,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWilloWisp"),
childName = "WeaponCase",
localPos = new Vector3(0.10776F, 0.25565F, -0.00182F),
localAngles = new Vector3(312.7722F, 6.16034F, 87.44836F),
localScale = new Vector3(0.0287F, 0.0287F, 0.0287F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Seed,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySeed"),
childName = "SubmachineMain",
localPos = new Vector3(-0.0163F, 0.10723F, -0.00327F),
localAngles = new Vector3(359.3604F, 22.48366F, 10.4859F),
localScale = new Vector3(0.01649F, 0.01649F, 0.01649F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.SprintOutOfCombat,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWhip"),
childName = "ThighR",
localPos = new Vector3(-0.05799F, 0.04775F, 0.22245F),
localAngles = new Vector3(1.24316F, 28.10744F, 14.51679F),
localScale = new Vector3(0.17266F, 0.17266F, 0.17266F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = JunkContent.Items.CooldownOnCrit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySkull"),
childName = "FootL",
localPos = new Vector3(0F, 0.3997F, 0F),
localAngles = new Vector3(270F, 0F, 0F),
localScale = new Vector3(0.2789F, 0.2789F, 0.2789F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Phasing,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayStealthkit"),
childName = "FootL",
localPos = new Vector3(-0.0063F, 0.2032F, -0.0507F),
localAngles = new Vector3(90F, 0F, 0F),
localScale = new Vector3(0.1454F, 0.2399F, 0.16F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.PersonalShield,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayShieldGenerator"),
childName = "Chest",
localPos = new Vector3(-0.09419F, 0.02229F, 0.00019F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.07646F, 0.07646F, 0.07646F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ShockNearby,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayTeslaCoil"),
childName = "ShoulderL",
localPos = new Vector3(-0.00366F, 0.11604F, -0.0544F),
localAngles = new Vector3(290F, 0F, 0F),
localScale = new Vector3(0.09943F, 0.09943F, 0.09943F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ShieldOnly,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayShieldBug"),
childName = "Head",
localPos = new Vector3(0.0177F, 0.11347F, 0.08379F),
localAngles = new Vector3(0F, 90F, 90F),
localScale = new Vector3(0.15164F, 0.15164F, 0.15164F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayShieldBug"),
childName = "Head",
localPos = new Vector3(0.0177F, 0.11347F, -0.08379F),
localAngles = new Vector3(0F, 270F, 270F),
localScale = new Vector3(-0.15164F, -0.15164F, -0.15164F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.AlienHead,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAlienHead"),
childName = "RifleEnd",
localPos = new Vector3(0.00592F, -0.00427F, -0.01909F),
localAngles = new Vector3(329.0368F, 2.95857F, 173.7183F),
localScale = new Vector3(0.51784F, 0.51784F, 0.51784F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.HeadHunter,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySkullCrown"),
childName = "Chest",
localPos = new Vector3(0.02504F, 0.22172F, -0.00171F),
localAngles = new Vector3(16.40689F, 260.2159F, 6.04816F),
localScale = new Vector3(0.15495F, 0.05165F, 0.05165F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.EnergizedOnEquipmentUse,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWarHorn"),
childName = "WeaponCase",
localPos = new Vector3(-0.00553F, -0.44658F, 0.27761F),
localAngles = new Vector3(84.63389F, 119.6098F, 300.8841F),
localScale = new Vector3(0.17758F, 0.17758F, 0.17758F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.FlatHealth,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySteakCurved"),
childName = "WeaponCase",
localPos = new Vector3(0.09064F, -0.24609F, 0.19677F),
localAngles = new Vector3(359.3087F, 112.1198F, 273.8745F),
localScale = new Vector3(0.05717F, 0.05304F, 0.05304F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Tooth,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayToothMeshLarge"),
childName = "Chest",
localPos = new Vector3(-0.04198F, 0.16526F, -0.00086F),
localAngles = new Vector3(4.83849F, 359.8651F, 1.85178F),
localScale = new Vector3(0.8094F, 0.8094F, 0.8094F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Pearl,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayPearl"),
childName = "WeaponCase",
localPos = new Vector3(0.03277F, -0.45994F, 0.18115F),
localAngles = new Vector3(90F, 0F, 0F),
localScale = new Vector3(0.1F, 0.1F, 0.1F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.ShinyPearl,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayShinyPearl"),
childName = "WeaponCase",
localPos = new Vector3(0.03277F, -0.45994F, 0.18115F),
localAngles = new Vector3(270F, 90F, 0F),
localScale = new Vector3(0.13878F, 0.13878F, 0.13878F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BonusGoldPackOnKill,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayTome"),
childName = "ThighR",
localPos = new Vector3(0.00772F, 0.24564F, -0.09323F),
localAngles = new Vector3(355.473F, 166.4758F, 356.2667F),
localScale = new Vector3(0.0475F, 0.0475F, 0.0475F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Squid,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySquidTurret"),
childName = "RifleMain",
localPos = new Vector3(-0.00151F, 0.06221F, -0.27468F),
localAngles = new Vector3(282.2478F, 189.6552F, 168.7244F),
localScale = new Vector3(0.01743F, 0.01743F, 0.01743F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Icicle,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFrostRelic"),
childName = "Chest",
localPos = new Vector3(0.15529F, 0.17162F, -0.0815F),
localAngles = new Vector3(26.3321F, 4.05977F, 280.9123F),
localScale = new Vector3(0.44389F, 0.44389F, 0.44389F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.Talisman,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayTalisman"),
childName = "Chest",
localPos = new Vector3(0.27635F, 0.25394F, -0.40374F),
localAngles = new Vector3(0.14732F, 262.127F, 359.9398F),
localScale = new Vector3(0.31969F, 0.31969F, 0.31969F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.LaserTurbine,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayLaserTurbine"),
childName = "Chest",
localPos = new Vector3(0.11689F, 0.09579F, -0.0644F),
localAngles = new Vector3(348.1729F, 89.14928F, 2.40915F),
localScale = new Vector3(0.14844F, 0.14844F, 0.14844F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.FocusConvergence,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFocusedConvergence"),
childName = "Chest",
localPos = new Vector3(0.24948F, 0.0666F, 0.11746F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.04491F, 0.04491F, 0.04491F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = JunkContent.Items.Incubator,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayAncestralIncubator"),
childName = "WeaponCase",
localPos = new Vector3(0.02488F, -0.38602F, 0.28156F),
localAngles = new Vector3(90F, 0F, 0F),
localScale = new Vector3(0.01314F, 0.01314F, 0.01314F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.FireballsOnHit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFireballsOnHit"),
childName = "SubmachineMain",
localPos = new Vector3(0.00083F, 0.15864F, -0.0832F),
localAngles = new Vector3(270F, 0F, 0F),
localScale = new Vector3(0.01962F, 0.01962F, 0.01962F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.SiphonOnLowHealth,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySiphonOnLowHealth"),
childName = "WeaponCase",
localPos = new Vector3(0.01081F, -0.31343F, 0.02729F),
localAngles = new Vector3(270F, 0F, 0F),
localScale = new Vector3(0.02919F, 0.02919F, 0.02919F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.BleedOnHitAndExplode,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBleedOnHitAndExplode"),
childName = "WeaponCase",
localPos = new Vector3(0.11748F, -0.35313F, 0.19551F),
localAngles = new Vector3(300.3069F, 2.70002F, 269.4594F),
localScale = new Vector3(0.04013F, 0.04013F, 0.04013F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.MonstersOnShrineUse,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayMonstersOnShrineUse"),
childName = "WeaponCase",
localPos = new Vector3(-0.05421F, -0.30709F, 0.22332F),
localAngles = new Vector3(27.1298F, 9.91047F, 18.14895F),
localScale = new Vector3(0.04518F, 0.04518F, 0.04518F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Items.RandomDamageZone,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayRandomDamageZone"),
childName = "CalfR",
localPos = new Vector3(0.12402F, 0.18531F, -0.00947F),
localAngles = new Vector3(7.37473F, 270.3681F, 174.3454F),
localScale = new Vector3(0.0465F, 0.0465F, 0.0465F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Fruit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayFruit"),
childName = "Chest",
localPos = new Vector3(-0.00575F, -0.05549F, -0.15576F),
localAngles = new Vector3(354.7403F, 305.3714F, 336.9526F),
localScale = new Vector3(0.2118F, 0.2118F, 0.2118F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.AffixRed,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEliteHorn"),
childName = "Head",
localPos = new Vector3(-0.0014F, 0.16413F, -0.05927F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.04816F, 0.04816F, 0.04816F),
                            limbMask = LimbFlags.None
                        },
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEliteHorn"),
childName = "Head",
localPos = new Vector3(-0.0014F, 0.16413F, 0.05927F),
localAngles = new Vector3(-0.00001F, 0.00001F, 180F),
localScale = new Vector3(-0.04816F, -0.04816F, -0.04816F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.AffixBlue,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEliteRhinoHorn"),
childName = "Head",
localPos = new Vector3(-0.11305F, 0.10511F, -0.00203F),
localAngles = new Vector3(0F, 270F, 0F),
localScale = new Vector3(0.07382F, 0.07382F, 0.07382F),
                            limbMask = LimbFlags.None
                        },
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.AffixWhite,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEliteIceCrown"),
childName = "Head",
localPos = new Vector3(-0.00823F, 0.19667F, 0.00092F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.01465F, 0.01465F, 0.01465F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.AffixPoison,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEliteUrchinCrown"),
childName = "Head",
localPos = new Vector3(-0.00775F, 0.17594F, 0.0005F),
localAngles = new Vector3(283.6258F, 127.8171F, 232.019F),
localScale = new Vector3(0.02619F, 0.02619F, 0.02619F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.AffixHaunted,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEliteStealthCrown"),
childName = "Head",
localPos = new Vector3(-0.014F, 0.19195F, 0.00008F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.02148F, 0.02148F, 0.02148F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.CritOnUse,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayNeuralImplant"),
childName = "Head",
localPos = new Vector3(-0.2328F, 0.05313F, -0.00306F),
localAngles = new Vector3(0F, 90F, 0F),
localScale = new Vector3(0.2326F, 0.2326F, 0.2326F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.DroneBackup,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayRadio"),
childName = "Chest",
localPos = new Vector3(0.11253F, 0.15073F, 0.03062F),
localAngles = new Vector3(0F, 90F, 0F),
localScale = new Vector3(0.28712F, 0.28712F, 0.28712F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Lightning,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayLightningArmRight"),
childName = "ForearmR",
localPos = new Vector3(-0.01313F, 0.0165F, 0.06061F),
localAngles = new Vector3(90F, 270F, 0F),
localScale = new Vector3(0.22661F, 0.22661F, 0.22661F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.BurnNearby,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayPotion"),
childName = "ThighR",
localPos = new Vector3(-0.11002F, 0.1511F, 0.00205F),
localAngles = new Vector3(353.0407F, 99.80488F, 148.3094F),
localScale = new Vector3(0.01955F, 0.01955F, 0.01955F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.CrippleWard,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEffigy"),
childName = "Chest",
localPos = new Vector3(-0.08423F, 0.09625F, 0.04205F),
localAngles = new Vector3(0F, 90F, 0F),
localScale = new Vector3(0.12316F, 0.12316F, 0.12316F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.QuestVolatileBattery,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayBatteryArray"),
childName = "FootL",
localPos = new Vector3(0F, 0.2584F, -0.0987F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.2188F, 0.2188F, 0.2188F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.GainArmor,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayElephantFigure"),
childName = "ThighR",
localPos = new Vector3(0.10484F, 0.21463F, -0.00907F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.3346F, 0.3346F, 0.3346F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Recycle,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayRecycler"),
childName = "WeaponCase",
localPos = new Vector3(0.09551F, -0.62933F, 0.17388F),
localAngles = new Vector3(270F, 0F, 0F),
localScale = new Vector3(0.03285F, 0.03285F, 0.03285F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.FireBallDash,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayEgg"),
childName = "WeaponCase",
localPos = new Vector3(0.08104F, -0.61014F, 0.20623F),
localAngles = new Vector3(-0.00001F, 180F, 180F),
localScale = new Vector3(0.1891F, 0.1891F, 0.1891F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Cleanse,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayWaterPack"),
childName = "WeaponCase",
localPos = new Vector3(0.00453F, -0.67471F, 0.1165F),
localAngles = new Vector3(71.09172F, 178.6231F, 181.0301F),
localScale = new Vector3(0.05318F, 0.05318F, 0.05318F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Tonic,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayTonic"),
childName = "ThighR",
localPos = new Vector3(-0.10705F, 0.11921F, -0.00258F),
localAngles = new Vector3(-0.00001F, 270F, 180F),
localScale = new Vector3(0.1252F, 0.1252F, 0.1252F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Gateway,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayVase"),
childName = "WeaponCase",
localPos = new Vector3(0.16234F, -0.61614F, 0.17424F),
localAngles = new Vector3(90F, 90F, 0F),
localScale = new Vector3(0.0982F, 0.0982F, 0.0982F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Meteor,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayMeteor"),
childName = "Chest",
localPos = new Vector3(0.21365F, 0.46726F, -0.4198F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.64089F, 0.64089F, 0.64089F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Saw,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplaySawmerangFollower"),
childName = "Chest",
localPos = new Vector3(0.17317F, 0.07788F, -0.00267F),
localAngles = new Vector3(0F, 90F, 0F),
localScale = new Vector3(0.0325F, 0.0325F, 0.0325F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Blackhole,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayGravCube"),
childName = "Chest",
localPos = new Vector3(0.14348F, 0.25613F, -0.27325F),
localAngles = new Vector3(0F, 0F, 0F),
localScale = new Vector3(0.5F, 0.5F, 0.5F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.Scanner,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayScanner"),
childName = "ForearmL",
localPos = new Vector3(-0.00646F, 0.01746F, -0.00134F),
localAngles = new Vector3(8.55063F, 176.8006F, 262.533F),
localScale = new Vector3(0.1F, 0.1F, 0.1F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.DeathProjectile,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayDeathProjectile"),
childName = "CannonTipStretch",
localPos = new Vector3(0.14926F, 0.5309F, -0.00267F),
localAngles = new Vector3(270F, 270F, 0F),
localScale = new Vector3(0.04043F, 0.04043F, 0.04043F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.LifestealOnHit,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayLifestealOnHit"),
childName = "ShoulderL",
localPos = new Vector3(-0.00186F, 0.08356F, -0.10094F),
localAngles = new Vector3(31.49462F, 354.2938F, 30.27812F),
localScale = new Vector3(0.03021F, 0.03021F, 0.03021F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });

            itemDisplayRules.Add(new ItemDisplayRuleSet.KeyAssetRuleGroup
            {
                keyAsset = RoR2Content.Equipment.TeamWarCry,
                displayRuleGroup = new DisplayRuleGroup
                {
                    rules = new ItemDisplayRule[]
                    {
                        new ItemDisplayRule
                        {
                            ruleType = ItemDisplayRuleType.ParentedPrefab,
                            followerPrefab = ItemDisplays.LoadDisplay("DisplayTeamWarCry"),
childName = "Chest",
localPos = new Vector3(0.15388F, 0.11054F, 0.05541F),
localAngles = new Vector3(340.4734F, 81.46542F, 199.5956F),
localScale = new Vector3(0.03935F, 0.03935F, 0.03935F),
                            limbMask = LimbFlags.None
                        }
                    }
                }
            });
            #endregion
        }
    }
}