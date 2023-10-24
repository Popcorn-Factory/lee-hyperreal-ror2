using LeeHyperrealMod.SkillStates;
using LeeHyperrealMod.SkillStates.BaseStates;
using System.Collections.Generic;
using System;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Primary;
using LeeHyperrealMod.SkillStates.LeeHyperreal;

namespace LeeHyperrealMod.Modules
{
    public static class States
    {
        internal static void RegisterStates()
        {
            Modules.Content.AddEntityState(typeof(BaseMeleeAttack));
            Modules.Content.AddEntityState(typeof(Primary1));
            Modules.Content.AddEntityState(typeof(Primary2));
            Modules.Content.AddEntityState(typeof(Primary3));
            Modules.Content.AddEntityState(typeof(Primary4));
            Modules.Content.AddEntityState(typeof(Primary5));

            Modules.Content.AddEntityState(typeof(Evade));
            
            Modules.Content.AddEntityState(typeof(SlashCombo));

            Modules.Content.AddEntityState(typeof(Shoot));

            Modules.Content.AddEntityState(typeof(Roll));

            Modules.Content.AddEntityState(typeof(ThrowBomb));
        }
    }
}