using RoR2;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.Modules
{
    public static class Buffs
    {
        internal static BuffDef intuitionBuff;
        internal static BuffDef invincibilityBuff;

        internal static void RegisterBuffs()
        {

            intuitionBuff = AddNewBuff("Anschauung Buff", LegacyResourcesAPI.Load<BuffDef>("BuffDefs/HiddenInvincibility").iconSprite, Color.red, true, false);
            invincibilityBuff = AddNewBuff("Invincibility Buff",
                LegacyResourcesAPI.Load<BuffDef>("BuffDefs/HiddenInvincibility").iconSprite,
                Color.blue,
                false,
                false);
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