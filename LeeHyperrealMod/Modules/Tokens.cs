using R2API;
using System;
using static LeeHyperrealMod.Modules.Helpers;
using static LeeHyperrealMod.Modules.StaticValues;
using static LeeHyperrealMod.Modules.Config;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Primary;

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
                $"Lee uses {UtilDesc("[Orbs]")} that allow the execution of unique skills. " +
                $"His {UtilDesc("[Ammo Counter]")} grants unique effects for {UtilDesc("[Snipe Stance]")}.");

            LanguageAPI.Add(prefix + "PASSIVE_DOMAIN_NAME", "Hypermatrix System");
            LanguageAPI.Add(prefix + "PASSIVE_DOMAIN_DESCRIPTION", "" +
                $"Lee has access to the {UtilDesc("[Hypermatrix]")}, by holding the Primary button" +
                $" down with a full {UtilDesc("[Power Gauge]")}." +
                $" Lee gains damage scales with attack speed, however {UtilDesc("[ Snipe Stance ]")} scales normally.");
            #endregion

            #region Primary
            LanguageAPI.Add(prefix + "PRIMARY_NAME", "Armament Barrage");
            LanguageAPI.Add(prefix + "PRIMARY_DESCRIPTION", "Launch a 5-hit-combo attack. On hit 1 and 3, " +
                $"peform a {UtilDesc("[Parry]")} active for a short time. " +
                $"In the air, slam down, dealing {DmgDesc($"{primaryAerialDamageCoefficient * 100}% damage")}, increasing up to {DmgDesc($"{primaryAerialMaxDamageMultiplier}x times,")} dependant on vertical distance travelled.");
            #endregion

            #region Secondary
            LanguageAPI.Add(prefix + "SECONDARY_SNIPE_NAME", "Snipe");
            LanguageAPI.Add(prefix + "SECONDARY_SNIPE_DESCRIPTION", "" +
                $"Shoot a bullet for {DmgDesc($"{snipeDamageCoefficient * 100f}% damage")}.");
            LanguageAPI.Add(prefix + "EXIT_SNIPE_NAME", "Exit Snipe Stance");
            LanguageAPI.Add(prefix + "EXIT_SNIPE_DESCRIPTION", "" +
                $"Exit {UtilDesc("[Snipe Stance]")}, allowing you to move again.");
            LanguageAPI.Add(prefix + "ENTER_SNIPE_NAME", "Snipe Stance");
            LanguageAPI.Add(prefix + "ENTER_SNIPE_DESCRIPTION", "" +
                $"Enter {UtilDesc("[Snipe Stance]")}, locking you in place, allowing you to Snipe using Primary" +
                $" for {DmgDesc($"{snipeDamageCoefficient * 100f}% damage")}.");
            #endregion

            #region Utility
            LanguageAPI.Add(prefix + "DASH_NAME", "Reality Travel");
            LanguageAPI.Add(prefix + "DASH_DESCRIPTION", "" +
                $"{UtilDesc("Dodge")}, turning invincible for a short time.");
            #endregion

            #region Special
            LanguageAPI.Add(prefix + "ULTIMATE_NAME", "End of Time");
            LanguageAPI.Add(prefix + "ULTIMATE_DESCRIPTION", "" +
                $"Turn invincible, pulling out a cannon that blasts enemies in a wide radius for {DmgDesc($"{ultimateDamageCoefficient * 100f}% damage")} after a short windup. " +
                $"Move changes while in the {UtilDesc("[Hypermatrix]")}.");

            LanguageAPI.Add(prefix + "ULTIMATE_DOMAIN_NAME", "Collapsing Realm");
            LanguageAPI.Add(prefix + "ULTIMATE_DOMAIN_DESCRIPTION", "" +
                $"Collapse the {UtilDesc("[Hypermatrix]")}, turning invincible for a short time and dealing {DmgDesc($"{ultimateDomainDamageCoefficient * 100f}% damage")} in your wake.");
            #endregion

            #region Keywords
            LanguageAPI.Add(prefix + "KEYWORD_ORBS",
                $"{Keyword("Orb System")}" +
                Environment.NewLine +
                $"Lee: Hyperreal uses 3 different coloured Orbs to use extra skills." +
                Environment.NewLine +
                $"In Simple Mode, activate {BlueOrb()}, {RedOrb()} and {YellowOrb()} orbs using the keys " +
                $"{UserSetting($"{blueOrbTrigger.Value}, {redOrbTrigger.Value}, {yellowOrbTrigger.Value}")} respectively, to use the first group of coloured orbs going from left to right. " +
                Environment.NewLine +
                $"Using 3 adjacent orbs of the same color, known as a {UtilDesc($"3-ping")}, " +
                $"will increase the orb's skill damage by {DmgDesc($"{yellowOrbTripleMultiplier}x times")}, while also granting extra attacks for {RedOrb()} and {YellowOrb()} Orbs.");
            LanguageAPI.Add(prefix + "KEYWORD_AMMO",
                $"{Keyword("Ammo System")}" +
                Environment.NewLine + $"" +
                $"Lee: Hyperreal can store and use a variety of {UtilDesc("Ammo")}, indicated above the {UtilDesc("[Power Gauge]")}." +
                Environment.NewLine +
                $"Using a {UtilDesc("3-ping")} will store a {UtilDesc("[Coloured Bullet]")}, which can be used in the {UtilDesc("[Hypermatrix]")} to add 3 Orbs of that shots colour back into your {UtilDesc("[Orb System]")}" +
                Environment.NewLine +
                $"Upon a successful {UtilDesc("[Parry]")}, {UtilDesc("[Outlined Bullet]'s")} are granted, increasing the damage of your next shot in {UtilDesc("[Snipe Stance]")} by {DmgDesc($"{empoweredBulletMultiplier}x times.  ")}");
            LanguageAPI.Add(prefix + "KEYWORD_SNIPE_STANCE",
                $"{Keyword("Snipe Stance")}" +
                Environment.NewLine + $"");
            LanguageAPI.Add(prefix + "KEYWORD_POWER_GAUGE",
                $"{Keyword("Power Gauge")}" +
                Environment.NewLine + $"");
            LanguageAPI.Add(prefix + "KEYWORD_PARRY",
                $"{Keyword("Parry")}" +
                Environment.NewLine + $"");
            LanguageAPI.Add(prefix + "KEYWORD_DOMAIN", 
                $"{Keyword("Hypermatrix System")}" +
                Environment.NewLine + 
                $"Above your Health is the {UtilDesc("[Hypermatrix System Gauge]")}. When the gauge is full, holding {UserSetting("Primary Skill")} at any time in {UtilDesc("[Armament Barrage]")} will transition him into the {UtilDesc("[Hypermatrix]")}. " +
                Environment.NewLine +
                $"While in this state, {RedOrb()} and {YellowOrb()} orbs change entirely, and your Special becomes {UtilDesc("[Collapsing Realm]")}." +
                Environment.NewLine +
                $"If the gauge runs out while in this state, {UtilDesc("[Collapsing Realm]")} will trigger automatically, exiting you out of the {UtilDesc("[Hypermatrix]")}.");

            #endregion

            #region Achievements
            LanguageAPI.Add(prefix + "MASTERYUNLOCKABLE_ACHIEVEMENT_NAME", "Lee: Hyperreal: Mastery");
            LanguageAPI.Add(prefix + "MASTERYUNLOCKABLE_ACHIEVEMENT_DESC", "As Lee: Hyperreal, beat the game or obliterate on Monsoon.");
            LanguageAPI.Add(prefix + "MASTERYUNLOCKABLE_UNLOCKABLE_NAME", "Lee: Hyperreal: Mastery");
            #endregion
            #endregion
        }
    }
}