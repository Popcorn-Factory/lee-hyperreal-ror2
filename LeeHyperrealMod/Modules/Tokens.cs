﻿using R2API;
using System;
using static LeeHyperrealMod.Modules.Helpers;
using static LeeHyperrealMod.Modules.StaticValues;
using static LeeHyperrealMod.Modules.Config;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Primary;
using UnityEngine.Diagnostics;

namespace LeeHyperrealMod.Modules
{
    internal static class Tokens
    {
        internal static void AddTokens()
        {
            #region Lee: Hyperreal
            string prefix = LeeHyperrealPlugin.DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_";

            string desc = "Lee: Hyperreal is a highly technical grounded character with hard to master gameplay. He entirely focuses on damage to the detriment of his survivability." +
                Environment.NewLine + Environment.NewLine + $"<!> {UtilDesc("[3-ping]s")} do {DmgDesc("4 times")} the damage compared to 1 or 2-pings of the same color so always try to manipulate the orb list to do {UtilDesc("[3-ping]s")}." +
                Environment.NewLine + Environment.NewLine + $"<!> On a successful parry with {UtilDesc("[Armament Barrage]")}, you can instantly parry again. With decent timing, you can reduce/entirely negate damage." +
                $" Projectiles parried will be reflected with their damage multiplied. Hitting enemies with this ability will regen orbs faster." +
                Environment.NewLine + Environment.NewLine + $"<!> Entering the {UtilDesc("[Hypermatrix]")} is your time to shine. Delete those bosses but watch out for the end-lag on orb skills in Hypermatrix." +
                Environment.NewLine + Environment.NewLine + $"<!> Try to keep your ammo counters filled. Get {UtilDesc("[Outlined Bullets]")} from parrying, and {UtilDesc("[Coloured Bullets]")} from {UtilDesc("[3-ping]s")} " +
                Environment.NewLine + Environment.NewLine + $"<!> {UtilDesc("[Snipe Stance]")} is your highest damaging tool, even more so with {UtilDesc("[Outlined Bullets]")}. However, you’re vulnerable in this stance, so use this skill wisely." +
                Environment.NewLine + Environment.NewLine + $"<!> {UtilDesc("[End of Time]")} can decimate a huge radius of enemies with its unlimited range and huge radius. But be mindful of its long cooldown.";

            string outro = "..and so he left, still no closer to his true reality.";
            string outroFailure = "..and so he vanished, with a mission unfulfilled";

            LanguageAPI.Add(prefix + "NAME", "Lee: Hyperreal");
            LanguageAPI.Add(prefix + "DESCRIPTION", desc);
            LanguageAPI.Add(prefix + "SUBTITLE", "Hypermatrix Traverser");
            LanguageAPI.Add(prefix + "LORE", "sample lore");
            LanguageAPI.Add(prefix + "OUTRO_FLAVOR", outro);
            LanguageAPI.Add(prefix + "OUTRO_FAILURE", outroFailure);

            #region Skins
            LanguageAPI.Add(prefix + "DEFAULT_SKIN_NAME", "Lee: Hyperreal");
            LanguageAPI.Add(prefix + "ALT_SKIN_NAME", "Lee: Real");
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
                $" Lee gains damage in place of attack speed, however {UtilDesc("[Snipe Stance]")} scales normally.");
            #endregion

            #region Primary
            LanguageAPI.Add(prefix + "PRIMARY_NAME", "Armament Barrage");
            LanguageAPI.Add(prefix + "PRIMARY_DESCRIPTION", "Launch a 5-hit-combo attack. On hit 1 and 3, " +
                $"perform a {UtilDesc("[Parry]")} active for a short time. " +
                $"In the air, slam down, dealing {DmgDesc($"{primaryAerialDamageCoefficient * 100}% damage")}, increasing up to {DmgDesc($"{primaryAerialMaxDamageMultiplier}x times,")} dependant on vertical distance travelled. " +
                $"Hold down at anytime in the combo with a full {UtilDesc("[Power Gauge]")} to enter the {UtilDesc("[Hypermatrix]")}");
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
                Environment.NewLine + $"Enter a stance which immobilises you, changing your {UserSetting("Primary Skill")} to a Sniping shot that deals {DmgDesc($"{snipeDamageCoefficient * 100f}% Damage")} per shot." +
                Environment.NewLine + $"Using {UserSetting("Utility Skill")} without any directional input allows you to dodge backwards while firing a bullet that deals {DmgDesc($"{snipeDamageCoefficient * 100f}% Damage")}. Using this skill otherwise cancels the stance.");
            LanguageAPI.Add(prefix + "KEYWORD_POWER_GAUGE",
                $"{Keyword("Power Gauge")}" +
                Environment.NewLine + $"The Power Gauge situated above the Health gauge determines when you can enter the {UtilDesc("[Hypermatrix]")}, and how long left before exiting. Hold the {UserSetting("Primary Skill")} to enter the {UtilDesc("[Hypermatrix]")}.");
            LanguageAPI.Add(prefix + "KEYWORD_PARRY",
                $"{Keyword("Parry")}" +
                Environment.NewLine + $"Upon a successful parry, stun the enemy that dealt the damage, if they can be stunned. Any projectile parried will be shot back in the direction you aim at. A successful parry resets {UtilDesc("[Armament Barrage]")}, starting from the first hit again.");
            LanguageAPI.Add(prefix + "KEYWORD_DOMAIN",
                $"{Keyword("Hypermatrix System")}" +
                Environment.NewLine +
                $"Above your Health is the {UtilDesc("[Hypermatrix System Gauge]")}. When the gauge is full, holding {UserSetting("Primary Skill")} at any time in {UtilDesc("[Armament Barrage]")} will transition him into the {UtilDesc("[Hypermatrix]")}. " +
                Environment.NewLine +
                $"While in this state, {RedOrb()} and {YellowOrb()} orbs change entirely, and your Special becomes {UtilDesc("[Collapsing Realm]")}." +
                Environment.NewLine +
                $"If the gauge runs out while in this state, {UtilDesc("[Collapsing Realm]")} will trigger automatically, exiting you out of the {UtilDesc("[Hypermatrix]")}.");

            LanguageAPI.Add(prefix + "KEYWORD_DOMAIN_ULT",
                $"{Keyword("Collapsing Realm")}" +
                Environment.NewLine + 
                $"Collapse the {UtilDesc("[Hypermatrix]")}, turning invincible for a short time and dealing {DmgDesc($"{ultimateDomainDamageCoefficient * 100f}% damage")} in your wake.");

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