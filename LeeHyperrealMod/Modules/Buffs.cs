using RoR2;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.Modules
{
    public static class Buffs
    {
        internal static BuffDef intuitionBuff;
        internal static BuffDef invincibilityBuff;
        internal static BuffDef parryBuff;
        internal static BuffDef fallDamageNegateBuff;
        internal static BuffDef glitchEffectBuff;

        internal static void RegisterBuffs()
        {

            intuitionBuff = AddNewBuff("Anschauung Buff", LegacyResourcesAPI.Load<BuffDef>("BuffDefs/HiddenInvincibility").iconSprite, Color.red, true, false);
            invincibilityBuff = AddNewBuff("Invincibility Buff",
                LegacyResourcesAPI.Load<BuffDef>("BuffDefs/HiddenInvincibility").iconSprite,
                Color.blue,
                false,
                false);
            fallDamageNegateBuff = AddNewBuff("Fall Damage Negation Buff",
                LegacyResourcesAPI.Load<BuffDef>("BuffDefs/HiddenInvincibility").iconSprite,
                Color.cyan,
                false,
                false);
            parryBuff = AddNewBuff("Parry Buff", LegacyResourcesAPI.Load<BuffDef>("BuffDefs/HiddenInvincibility").iconSprite, Color.magenta, false, false);
            glitchEffectBuff = AddNewBuff("Glitch Effect", LegacyResourcesAPI.Load<BuffDef>("BuffDefs/TeslaField").iconSprite, Color.cyan, false, false);
        }

        // simple helper method
        internal static BuffDef AddNewBuff(string buffName, Sprite buffIcon, Color buffColor, bool canStack, bool isDebuff)
        {
            BuffDef buffDef = ScriptableObject.CreateInstance<BuffDef>();
            buffDef.name = buffName;
            buffDef.buffColor = buffColor;
            buffDef.canStack = canStack;
            buffDef.isDebuff = isDebuff;
            buffDef.eliteDef = null;
            buffDef.iconSprite = buffIcon;

            Modules.Content.AddBuffDef(buffDef);

            return buffDef;
        }
    }
}