using BepInEx.Configuration;
using IL.RoR2;
using RiskOfOptions;
using RiskOfOptions.OptionConfigs;
using RiskOfOptions.Options;
using System;
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
        public static ConfigEntry<bool> allowSnipeButtonHold;

        public static ConfigEntry<bool> changeCameraPos;
        public static ConfigEntry<float> horizontalCameraPosition;
        public static ConfigEntry<float> verticalCameraPosition;
        public static ConfigEntry<float> depthCameraPosition;

        public enum VoiceLanguage 
        {
            ENG,
            JPN,
        }
        public static ConfigEntry<VoiceLanguage> voiceLanguageOption;
        public static ConfigEntry<bool> voiceEnabled;
        public static ConfigEntry<float> voiceVolume;

        public static ConfigEntry<float> crosshairSize;
        
        public static ConfigEntry<float> ceaseChance;



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

            changeCameraPos = LeeHyperrealPlugin.instance.Config.Bind<bool>
            (
                new ConfigDefinition("03 - Snipe", "Enable Camera movement"),
                true,
                new ConfigDescription("Enabling this moves the camera during Snipe stance.", null, System.Array.Empty<object>())
            );

            depthCameraPosition = LeeHyperrealPlugin.instance.Config.Bind<float>
            (
                new ConfigDefinition("03 - Snipe", "Depth when scoped"),
                -4f,
                new ConfigDescription("Changes the Depth (Z-position) on the camera in snipe stance.")
            );
            horizontalCameraPosition = LeeHyperrealPlugin.instance.Config.Bind<float>
            (
                new ConfigDefinition("03 - Snipe", "Horizontal Camera Positioning when scoped"),
                2f,
                new ConfigDescription("Changes the the horizontal position of the camera when scoped. Positive values is right, Negative values are left.")
            );
            verticalCameraPosition = LeeHyperrealPlugin.instance.Config.Bind<float>
            (
                new ConfigDefinition("03 - Snipe", "Vertical Camera Positioning when scoped"),
                -1.6f,
                new ConfigDescription("Changes the the vertical position of the camera when scoped. Positive values is up, Negative values are down.")
            );

            allowSnipeButtonHold = LeeHyperrealPlugin.instance.Config.Bind<bool>
            (
                new ConfigDefinition("03 - Snipe", "Hold to Snipe"),
                false,
                new ConfigDescription("Changes the Snipe stance skill to allow you to hold the button down to stay in snipe. To exit snipe, let go of the Snipe stance button.")
            );

            voiceLanguageOption = LeeHyperrealPlugin.instance.Config.Bind
            (
                "04 - Voice", 
                "Voice Language", 
                VoiceLanguage.ENG, 
                "Sets the Language for Voicelines."
            );

            voiceEnabled = LeeHyperrealPlugin.instance.Config.Bind<bool>
            (
                new ConfigDefinition("04 - Voice", "Voiceline Enabled"),
                true,
                new ConfigDescription("Determines whether the voiceline should play or not.")
            );

            voiceVolume = LeeHyperrealPlugin.instance.Config.Bind<float>
            (
                new ConfigDefinition("04 - Voice", "Voiceline volume"),
                50f,
                new ConfigDescription("Determines the volume of voice lines")
            );

            crosshairSize = LeeHyperrealPlugin.instance.Config.Bind<float>
            (
                new ConfigDefinition("05 - Crosshair", "Crosshair Size"),
                0.6f,
                new ConfigDescription("Determines the crosshair size on both axes. (e.g 1 = 1x1, 0.5 = 0.5x0.5, you get the idea.)")
            );

            ceaseChance = LeeHyperrealPlugin.instance.Config.Bind<float>
            (
                new ConfigDefinition("06 - Cease", "Cease chance"),
                1f,
                new ConfigDescription("Determines chance of cease event to occur. (Go figure out what this means yourself.)")
            );
        }

        public static void SetupRiskOfOptions() 
        {
            Sprite icon = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Sprite>("LeeCharacterIcon");
            ModSettingsManager.SetModIcon(icon);
            ModSettingsManager.SetModDescription("Hypermatrix Traverser");

            ModSettingsManager.AddOption(new CheckBoxOption(isSimple));

            ModSettingsManager.AddOption( new KeyBindOption(orb1Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orb2Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orb3Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orb4Trigger) );
            ModSettingsManager.AddOption( new KeyBindOption(orbAltTrigger) );

            ModSettingsManager.AddOption( new KeyBindOption(blueOrbTrigger) );
            ModSettingsManager.AddOption( new KeyBindOption(redOrbTrigger) );
            ModSettingsManager.AddOption( new KeyBindOption(yellowOrbTrigger) );

            ModSettingsManager.AddOption(new CheckBoxOption(changeCameraPos));
            ModSettingsManager.AddOption(
                new StepSliderOption(
                    depthCameraPosition, 
                    new StepSliderConfig 
                    { 
                        min = -10f, 
                        max = 0f, 
                        increment = 0.1f
                    }
                )
            );

            ModSettingsManager.AddOption(
                new StepSliderOption(
                    horizontalCameraPosition,
                    new StepSliderConfig
                    {
                        min = -10f,
                        max = 10f,
                        increment = 0.01f
                    }
                )
            );

            ModSettingsManager.AddOption(
                new StepSliderOption(
                    verticalCameraPosition,
                    new StepSliderConfig
                    {
                        min = -10f,
                        max = 10f,
                        increment = 0.01f
                    }
                )
            );
            ModSettingsManager.AddOption(new CheckBoxOption(allowSnipeButtonHold));

            ModSettingsManager.AddOption(new ChoiceOption(voiceLanguageOption));

            ModSettingsManager.AddOption(new CheckBoxOption(voiceEnabled));

            ModSettingsManager.AddOption(
                new StepSliderOption(
                    voiceVolume,
                    new StepSliderConfig
                    {
                        min = 0f,
                        max = 100f,
                        increment = 0.1f
                    }
                )
            );

            ModSettingsManager.AddOption(
               new StepSliderOption(
                      crosshairSize,
                      new StepSliderConfig
                      {
                          min = 0f,
                          max = 1.5f,
                          increment = 0.01f
                      }
                  ));

            ModSettingsManager.AddOption(
                  new StepSliderOption(
                      ceaseChance,
                      new StepSliderConfig
                      {
                          min = 0f,
                          max = 100f,
                          increment = 0.01f
                      }
                  )
              );
        }

        // this helper automatically makes config entries for disabling survivors
        public static ConfigEntry<bool> CharacterEnableConfig(string characterName, string description = "Set to false to disable this character", bool enabledDefault = true) {

            return LeeHyperrealPlugin.instance.Config.Bind<bool>("General",
                                                          "Enable " + characterName,
                                                          enabledDefault,
                                                          description);
        }

        public static void OnChangeHooks()
        {
            voiceVolume.SettingChanged += VoiceVolume_SettingChanged;
        }

        private static void VoiceVolume_SettingChanged(object sender, System.EventArgs e)
        {
            if (AkSoundEngine.IsInitialized())
            {
                AkSoundEngine.SetRTPCValue("Volume_Lee_Voice", voiceVolume.Value);
            }
        }
    }
}