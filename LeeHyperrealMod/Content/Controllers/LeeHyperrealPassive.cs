using RoR2;
using RoR2.Skills;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealPassive : MonoBehaviour
    {
        public SkillDef orbAndBulletPassive;
        public GenericSkill orbPassiveSkillSlot;

        public SkillDef hypermatrixPassive;
        public GenericSkill hypermatrixPassiveSkillSlot;

        public SkillDef defaultVFXPassive;
        public SkillDef redVFXPassive;
        public SkillDef orangeVFXPassive;
        public SkillDef yellowVFXPassive;
        public SkillDef greenVFXPassive;
        public SkillDef blueVFXPassive;
        public SkillDef lightBlueVFXPassive;
        public SkillDef violetVFXPassive;
        public SkillDef pinkVFXPassive;
        public SkillDef rainbowVFXPassive;
        public GenericSkill VFXColorPassiveSkillSlot;


        internal enum VFXPassive : uint
        {
            DEFAULT = 0,
            RED = 1,
            ORANGE = 2,
            YELLOW = 3,
            GREEN = 4,
            BLUE = 5,
            LIGHTBLUE = 6,
            VIOLET = 7,
            PINK = 8,
            RANDOM = 9,
        }

        internal VFXPassive GetVFXPassive() 
        {
            if (VFXColorPassiveSkillSlot) 
            {
                if (VFXColorPassiveSkillSlot.skillDef == defaultVFXPassive)
                {
                    return VFXPassive.DEFAULT;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == redVFXPassive)
                {
                    return VFXPassive.RED;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == orangeVFXPassive)
                {
                    return VFXPassive.ORANGE;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == yellowVFXPassive)
                {
                    return VFXPassive.YELLOW;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == greenVFXPassive)
                {
                    return VFXPassive.GREEN;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == blueVFXPassive)
                {
                    return VFXPassive.BLUE;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == lightBlueVFXPassive)
                {
                    return VFXPassive.LIGHTBLUE;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == violetVFXPassive)
                {
                    return VFXPassive.VIOLET;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == pinkVFXPassive)
                {
                    return VFXPassive.PINK;
                }
                else if (VFXColorPassiveSkillSlot.skillDef == rainbowVFXPassive) 
                {
                    return VFXPassive.RANDOM;
                }
                else
                {
                    return VFXPassive.DEFAULT;
                }
            }

            return VFXPassive.DEFAULT;
        }
    }
}
