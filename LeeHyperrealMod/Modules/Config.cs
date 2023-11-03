using BepInEx.Configuration;
using IL.RoR2;
using RiskOfOptions;
using RiskOfOptions.Options;
using UnityEngine;

namespace LeeHyperrealMod.Modules
{
    public static class Config
    {
        public static ConfigEntry<KeyboardShortcut> orb1Trigger;
        public static ConfigEntry<KeyboardShortcut> orb2Trigger;
        public static ConfigEntry<KeyboardShortcut> orb3Trigger;
        public static ConfigEntry<KeyboardShortcut> orb4Trigger;
        public static ConfigEntry<KeyboardShortcut> orbAltTrigger;

        public static ConfigEntry<KeyboardShortcut> blueOrbTrigger;
        public static ConfigEntry<KeyboardShortcut> yellowOrbTrigger;
        public static ConfigEntry<KeyboardShortcut> redOrbTrigger;

        public static ConfigEntry<bool> isSimple;




        public static void ReadConfig()
        {
            orb1Trigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("01 - Orb Activation Controls", "Orb 1 Slot"),
                new KeyboardShortcut(UnityEngine.KeyCode.Alpha1),
                new ConfigDescription("Determines the key to trigger the orb in slot 1 (from the left).", null, System.Array.Empty<object>())
            );
            orb2Trigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("01 - Orb Activation Controls", "Orb 2 Slot"),
                new KeyboardShortcut(UnityEngine.KeyCode.Alpha2),
                new ConfigDescription("Determines the key to trigger the orb in slot 2 (from the left).", null, System.Array.Empty<object>())
            );
            orb3Trigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("01 - Orb Activation Controls", "Orb 3 Slot"),
                new KeyboardShortcut(UnityEngine.KeyCode.Alpha3),
                new ConfigDescription("Determines the key to trigger the orb in slot 3 (from the left).", null, System.Array.Empty<object>())
            );
            orb4Trigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("01 - Orb Activation Controls", "Orb 4 Slot"),
                new KeyboardShortcut(UnityEngine.KeyCode.Alpha4),
                new ConfigDescription("Determines the key to trigger the orb in slot 4 (from the left).", null, System.Array.Empty<object>())
            );
            orbAltTrigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("01 - Orb Activation Controls", "Orb Alt Trigger"),
                new KeyboardShortcut(UnityEngine.KeyCode.LeftAlt),
                new ConfigDescription("Determines the key to shift focus onto the latter half of the orbs (if orb 5 needs to be triggered, press this button and Orb 1 Slot.).", null, System.Array.Empty<object>())
            );

            blueOrbTrigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("02 - Simple Orb Activation Controls", "Blue Orb Trigger"),
                new KeyboardShortcut(UnityEngine.KeyCode.Alpha1),
                new ConfigDescription("Key to trigger the first blue orb group in the list.", null, System.Array.Empty<object>())
            );
            redOrbTrigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("02 - Simple Orb Activation Controls", "Red Orb Trigger"),
                new KeyboardShortcut(UnityEngine.KeyCode.Alpha2),
                new ConfigDescription("Key to trigger the first red orb group in the list.", null, System.Array.Empty<object>())
            );
            yellowOrbTrigger = LeeHyperrealPlugin.instance.Config.Bind<KeyboardShortcut>
            (
                new ConfigDefinition("02 - Simple Orb Activation Controls", "Yellow Orb Trigger"),
                new KeyboardShortcut(UnityEngine.KeyCode.Alpha3),
                new ConfigDescription("Key to trigger the first yellow orb group in the list.", null, System.Array.Empty<object>())
            );

            isSimple = LeeHyperrealPlugin.instance.Config.Bind<bool>
            (
                new ConfigDefinition("Controls", "Simple Controls"),
                true,
                new ConfigDescription("Enabling this uses the simple control bindings. Disabling uses the keybinds in Orb Activation Controls.", null, System.Array.Empty<object>())
            );

        }

        public static void SetupRiskOfOptions() 
        {
            ModSettingsManager.AddOption(new CheckBoxOption(isSimple));

            ModSettingsManager.AddOption( new KeyBindOption(orb1Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orb2Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orb3Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orb4Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orbAltTrigger) );

            ModSettingsManager.AddOption( new KeyBindOption(blueOrbTrigger) );
            ModSettingsManager.AddOption( new KeyBindOption(redOrbTrigger) );
            ModSettingsManager.AddOption( new KeyBindOption(yellowOrbTrigger) );


        }

        // this helper automatically makes config entries for disabling survivors
        public static ConfigEntry<bool> CharacterEnableConfig(string characterName, string description = "Set to false to disable this character", bool enabledDefault = true) {

            return LeeHyperrealPlugin.instance.Config.Bind<bool>("General",
                                                          "Enable " + characterName,
                                                          enabledDefault,
                                                          description);
        }
    }
}