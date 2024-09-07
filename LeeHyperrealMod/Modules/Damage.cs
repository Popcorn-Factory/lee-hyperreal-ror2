using R2API;
using System;
using System.Collections.Generic;
using System.Text;

namespace LeeHyperrealMod.Modules
{
    internal static class Damage
    {
        internal static DamageAPI.ModdedDamageType unparryable;
        internal static DamageAPI.ModdedDamageType leeHyperrealParryDamage;

        internal static void SetupModdedDamageTypes() 
        {
            leeHyperrealParryDamage = DamageAPI.ReserveDamageType();
            unparryable = DamageAPI.ReserveDamageType();
        }
    }
}
