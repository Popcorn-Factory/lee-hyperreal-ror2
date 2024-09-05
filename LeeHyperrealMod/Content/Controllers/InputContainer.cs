using ExtraSkillSlots;
using RoR2;
using System.Runtime.CompilerServices;
using UnityEngine;
using static LeeHyperrealMod.Content.Controllers.OrbController;

namespace LeeHyperrealMod.Content.Controllers
{

    //Separated to prevent the compiler from dying.
    internal class InputContainer
    {
        ExtraInputBankTest extraInputBankTest;
        CharacterBody charBody;
        OrbController orbController;

        [MethodImpl(MethodImplOptions.NoInlining)]
        public InputContainer(GameObject bodyObject, OrbController orbController) 
        {
            extraInputBankTest = bodyObject.GetComponent<ExtraInputBankTest>();
            charBody = bodyObject.GetComponent<CharacterBody>();
            this.orbController = orbController;
        }

        [MethodImpl(MethodImplOptions.NoInlining)]
        public void ExtraSkillSlotControllerInputCheck()
        {
            if (charBody.hasEffectiveAuthority && extraInputBankTest)
            {
                if (extraInputBankTest.extraSkill1.justPressed)
                {
                    orbController.ConsumeOrbsSimple(OrbType.BLUE);
                }
                else if (extraInputBankTest.extraSkill2.justPressed)
                {
                    orbController.ConsumeOrbsSimple(OrbType.RED);
                }
                else if (extraInputBankTest.extraSkill3.justPressed)
                {
                    orbController.ConsumeOrbsSimple(OrbType.YELLOW);
                }
            }
        }
    }
}
