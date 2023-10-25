using ExtraSkillSlots;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;

namespace LeeHyperrealMod.Modules
{
    internal class BodyInputCheckHelper
    {
        internal static void CheckForOtherInputs(SkillLocator skillLocator, ExtraSkillLocator skillLocator2, bool isAuthority, InputBankTest inputBank, ExtraInputBankTest extraInputBankTest)
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

                if (skillLocator2)
                {
                    HandleSkill(skillLocator2.extraFirst, ref extraInputBankTest.extraSkill1);
                    HandleSkill(skillLocator2.extraSecond, ref extraInputBankTest.extraSkill2);
                    HandleSkill(skillLocator2.extraThird, ref extraInputBankTest.extraSkill3);
                    HandleSkill(skillLocator2.extraFourth, ref extraInputBankTest.extraSkill4);
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
