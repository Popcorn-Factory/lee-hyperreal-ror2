using LeeHyperrealMod.SkillStates;
using LeeHyperrealMod.SkillStates.BaseStates;
using System.Collections.Generic;
using System;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Primary;
using LeeHyperrealMod.SkillStates.LeeHyperreal;
using LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb;
using LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb;

namespace LeeHyperrealMod.Modules
{
    public static class States
    {
        internal static void RegisterStates()
        {

            #region Primary
            Modules.Content.AddEntityState(typeof(Primary1));
            Modules.Content.AddEntityState(typeof(Primary2));
            Modules.Content.AddEntityState(typeof(Primary3));
            Modules.Content.AddEntityState(typeof(Primary4));
            Modules.Content.AddEntityState(typeof(Primary5));
            #endregion

            #region Blue Orb
            Modules.Content.AddEntityState(typeof(BlueOrb));
            #endregion

            #region Yellow Orb
            Modules.Content.AddEntityState(typeof(YellowOrbEntry));
            Modules.Content.AddEntityState(typeof(YellowOrbFinisher));
            Modules.Content.AddEntityState(typeof(YellowOrb));
            #endregion

            #region Red Orb
            Modules.Content.AddEntityState(typeof(RedOrbEntry));
            #endregion

            #region Base States
            Modules.Content.AddEntityState(typeof(BaseRootMotionMoverState));
            Modules.Content.AddEntityState(typeof(BaseMeleeAttack));
            #endregion

            #region Evade
            Modules.Content.AddEntityState(typeof(Evade));
            #endregion

            Modules.Content.AddEntityState(typeof(SlashCombo));

            Modules.Content.AddEntityState(typeof(Shoot));

            Modules.Content.AddEntityState(typeof(Roll));

            Modules.Content.AddEntityState(typeof(ThrowBomb));
        }
    }
}