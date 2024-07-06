using R2API;
using System;
using static LeeHyperrealMod.Modules.Helpers;
using static LeeHyperrealMod.Modules.StaticValues;

namespace LeeHyperrealMod.Modules
{
    internal static class Tokens
    {
        internal static void AddTokens()
        {
            #region Lee: Hyperreal
            string prefix = LeeHyperrealPlugin.DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_";

            string desc = "Henry is a skilled fighter who makes use of a wide arsenal of weaponry to take down his foes.<color=#CCD3E0>" + Environment.NewLine + Environment.NewLine;
            desc = desc + "< ! > Sword is a good all-rounder while Boxing Gloves are better for laying a beatdown on more powerful foes." + Environment.NewLine + Environment.NewLine;
            desc = desc + "< ! > Pistol is a powerful anti air, with its low cooldown and high damage." + Environment.NewLine + Environment.NewLine;
            desc = desc + "< ! > Roll has a lingering armor buff that helps to use it aggressively." + Environment.NewLine + Environment.NewLine;
            desc = desc + "< ! > Bomb can be used to wipe crowds with ease." + Environment.NewLine + Environment.NewLine;

            string outro = "..and so he left, still no closer to his true reality.";
            string outroFailure = "..and so he vanished, with a mission unfulfilled";

            LanguageAPI.Add(prefix + "NAME", "Lee: Hyperreal");
            LanguageAPI.Add(prefix + "DESCRIPTION", desc);
            LanguageAPI.Add(prefix + "SUBTITLE", "Hypermatrix Traverser");
            LanguageAPI.Add(prefix + "LORE", "sample lore");
            LanguageAPI.Add(prefix + "OUTRO_FLAVOR", outro);
            LanguageAPI.Add(prefix + "OUTRO_FAILURE", outroFailure);

            #region Skins
            LanguageAPI.Add(prefix + "DEFAULT_SKIN_NAME", "Default");
            #endregion

            #region Passive
            LanguageAPI.Add(prefix + "PASSIVE_ORB_AND_AMMO_NAME", "Orb and Ammo System");
            LanguageAPI.Add(prefix + "PASSIVE_ORB_AND_AMMO_DESCRIPTION", "" +
                $"Lee uses {Helpers.UtilDesc("[Orbs]")} that allow the execution of unique skills. " +
                $"His {Helpers.UtilDesc("[Ammo Counter]")} grants unique effects for {Helpers.UtilDesc("[Snipe Stance]")}.");

            LanguageAPI.Add(prefix + "PASSIVE_DOMAIN_NAME", "Hypermatrix System");
            LanguageAPI.Add(prefix + "PASSIVE_DOMAIN_DESCRIPTION", "" +
                $"Lee has access to the {Helpers.UtilDesc("[Hypermatrix]")}, by holding the Primary button" +
                $" down with a full {Helpers.UtilDesc("[Power Gauge]")}." +
                $" Lee gains damage scales with attack speed, however {Helpers.UtilDesc("[ Snipe Stance ]")} scales normally.");
            #endregion

            #region Primary
            LanguageAPI.Add(prefix + "PRIMARY_NAME", "Armament Barrage");
            LanguageAPI.Add(prefix + "PRIMARY_DESCRIPTION", "Launch a 5-hit-combo attack. On hit 1 and 3, " +
                $"peform a {Helpers.UtilDesc("[Parry]")} active for a short time. " +
                $"In the air, slam down, dealing {Helpers.DmgDesc($"{StaticValues.primaryAerialDamageCoefficient * 100}% damage")}, increasing up to 3 times dependant on vertical distance travelled.");
            #endregion

            #region Secondary
            LanguageAPI.Add(prefix + "SECONDARY_SNIPE_NAME", "Snipe");
            LanguageAPI.Add(prefix + "SECONDARY_SNIPE_DESCRIPTION","" +
                $"Shoot a bullet for {Helpers.DmgDesc($"{StaticValues.snipeDamageCoefficient * 100f}% damage")}.");
            LanguageAPI.Add(prefix + "EXIT_SNIPE_NAME", "Exit Snipe Stance");
            LanguageAPI.Add(prefix + "EXIT_SNIPE_DESCRIPTION","" +
                $"Exit {Helpers.UtilDesc("[Snipe Stance]")}, allowing you to move again.");
            LanguageAPI.Add(prefix + "ENTER_SNIPE_NAME", "Snipe Stance");
            LanguageAPI.Add(prefix + "ENTER_SNIPE_DESCRIPTION", "" +
                $"Enter {Helpers.UtilDesc("[Snipe Stance]")}, locking you in place, allowing you to Snipe using Primary" +
                $" for {Helpers.DmgDesc($"{StaticValues.snipeDamageCoefficient * 100f}% damage")}.");
            #endregion

            #region Utility
            LanguageAPI.Add(prefix + "DASH_NAME", "Reality Travel");
            LanguageAPI.Add(prefix + "DASH_DESCRIPTION", "" +
                "Dodge, turning invincible for a short time.");
            #endregion

            #region Special
            LanguageAPI.Add(prefix + "ULTIMATE_NAME", "End of Time");
            LanguageAPI.Add(prefix + "ULTIMATE_DESCRIPTION", "" +
                $"Turn invincible, pulling out a cannon that blasts enemies in a wide radius for {Helpers.DmgDesc($"{StaticValues.ultimateDamageCoefficient * 100f}% damage")} after a short windup. " +
                $"Move changes while in the {Helpers.UtilDesc("[Hypermatrix]")}.");

            LanguageAPI.Add(prefix + "ULTIMATE_DOMAIN_NAME", "Collapsing Realm");
            LanguageAPI.Add(prefix + "ULTIMATE_DOMAIN_DESCRIPTION", "" +
                $"Collapse the {Helpers.UtilDesc("[Hypermatrix]")}, turning invincible for a short time and dealing {Helpers.DmgDesc($"{StaticValues.ultimateDomainDamageCoefficient * 100f}% damage")} in your wake.");
            #endregion

            #region Keywords
            LanguageAPI.Add(prefix + "KEYWORD_ORBS", "");
            LanguageAPI.Add(prefix + "KEYWORD_AMMO", "");
            LanguageAPI.Add(prefix + "KEYWORD_SNIPE_STANCE", "");
            LanguageAPI.Add(prefix + "KEYWORD_POWER_GAUGE", "");
            LanguageAPI.Add(prefix + "KEYWORD_PARRY", "");
            LanguageAPI.Add(prefix + "KEYWORD_DOMAIN", 
                $"{Helpers.Keyword("[ Hypermatrix System ]")}" +
                Environment.NewLine + $"");

            #endregion

            #region Achievements
            LanguageAPI.Add(prefix + "MASTERYUNLOCKABLE_ACHIEVEMENT_NAME", "Henry: Mastery");
            LanguageAPI.Add(prefix + "MASTERYUNLOCKABLE_ACHIEVEMENT_DESC", "As Henry, beat the game or obliterate on Monsoon.");
            LanguageAPI.Add(prefix + "MASTERYUNLOCKABLE_UNLOCKABLE_NAME", "Henry: Mastery");
            #endregion
            #endregion
        }
    }
}