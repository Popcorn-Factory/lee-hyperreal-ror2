﻿using LeeHyperrealMod.SkillStates;
using LeeHyperrealMod.SkillStates.BaseStates;
using System.Collections.Generic;
using System;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Primary;
using LeeHyperrealMod.SkillStates.LeeHyperreal;
using LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb;
using LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate;
using LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Secondary;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Evade;

namespace LeeHyperrealMod.Modules
{
    public static class States
    {
        internal static void RegisterStates()
        {
            Modules.Content.AddEntityState(typeof(LeeHyperrealCharacterMain));

            #region Primary
            Modules.Content.AddEntityState(typeof(PrimaryEntry));
            Modules.Content.AddEntityState(typeof(PrimaryAerialStart));
            Modules.Content.AddEntityState(typeof(PrimaryAerialLoop));
            Modules.Content.AddEntityState(typeof(PrimaryAerialSlam));
            Modules.Content.AddEntityState(typeof(Primary1));
            Modules.Content.AddEntityState(typeof(Primary2));
            Modules.Content.AddEntityState(typeof(Primary3));
            Modules.Content.AddEntityState(typeof(Primary4));
            Modules.Content.AddEntityState(typeof(Primary5));
            #endregion

            #region Secondary
            Modules.Content.AddEntityState(typeof(EnterSnipe));
            Modules.Content.AddEntityState(typeof(ExitSnipe));
            Modules.Content.AddEntityState(typeof(IdleSnipe));
            Modules.Content.AddEntityState(typeof(Snipe));
            #endregion

            #region Blue Orb
            Modules.Content.AddEntityState(typeof(BlueOrb));
            #endregion

            #region Yellow Orb
            Modules.Content.AddEntityState(typeof(YellowOrbEntry));
            Modules.Content.AddEntityState(typeof(YellowOrbFinisher));
            Modules.Content.AddEntityState(typeof(YellowOrb));

            Modules.Content.AddEntityState(typeof(YellowOrbDomain));
            #endregion

            #region Red Orb
            Modules.Content.AddEntityState(typeof(RedOrbEntry));
            Modules.Content.AddEntityState(typeof(RedOrb));
            Modules.Content.AddEntityState(typeof(RedOrbFinisher));

            Modules.Content.AddEntityState(typeof(RedOrbDomain));
            #endregion

            #region Ultimate
            Modules.Content.AddEntityState(typeof(UltimateEntry));
            Modules.Content.AddEntityState(typeof(Ultimate));
            Modules.Content.AddEntityState(typeof(UltimateDomain));
            Modules.Content.AddEntityState(typeof(UltimateController));
            Modules.Content.AddEntityState(typeof(Freeze));
            #endregion

            #region Base States
            Modules.Content.AddEntityState(typeof(BaseRootMotionMoverState));
            Modules.Content.AddEntityState(typeof(BaseMeleeAttack));
            #endregion

            #region Evade
            Modules.Content.AddEntityState(typeof(Evade));
            Modules.Content.AddEntityState(typeof(EvadeSide));
            Modules.Content.AddEntityState(typeof(EvadeBack180));
            #endregion

            #region Domain Enter State
            Modules.Content.AddEntityState(typeof(DomainEnterState));
            #endregion

            Modules.Content.AddEntityState(typeof(SlashCombo));

            Modules.Content.AddEntityState(typeof(Shoot));

            Modules.Content.AddEntityState(typeof(Roll));

            Modules.Content.AddEntityState(typeof(ThrowBomb));
        }
    }
}