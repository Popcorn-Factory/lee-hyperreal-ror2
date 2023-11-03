using RoR2;
using System;
using System.Collections.Generic;
using System.Text;

namespace LeeHyperrealMod.Modules
{
    internal class BodyInputCheckHelper
    {
        internal static void CheckForOtherInputs(SkillLocator skillLocator, bool isAuthority, InputBankTest inputBank)
        {
            if (isAuthority)
            {
                if (skillLocator)
                {
                    HandleSkill(skillLocator.primary, ref inputBank.skill1);
                    HandleSkill(skillLocator.secondary, ref inputBank.skill2);
                    HandleSkill(skillLocator.utility, ref inputBank.skill3);
                    HandleSkill(skillLocator.special, ref inputBank.skill4);
                }
            }
        }

        private static void HandleSkill(GenericSkill skillSlot, ref InputBankTest.ButtonState buttonState)
        {
            if (!buttonState.down || !skillSlot)
            {
                return;
            }
            if (skillSlot.mustKeyPress && buttonState.hasPressBeenClaimed)
            {
                return;
            }
            if (skillSlot.ExecuteIfReady())
            {
                buttonState.hasPressBeenClaimed = true;
            }
        }
    }
}
