﻿using System;
using UnityEngine;

namespace LeeHyperrealMod.Modules
{
    internal static class StaticValues
    {
        internal static string descriptionText = "Henry is a skilled fighter who makes use of a wide arsenal of weaponry to take down his foes.<color=#CCD3E0>" + Environment.NewLine + Environment.NewLine
             + "< ! > Sword is a good all-rounder while Boxing Gloves are better for laying a beatdown on more powerful foes." + Environment.NewLine + Environment.NewLine
             + "< ! > Pistol is a powerful anti air, with its low cooldown and high damage." + Environment.NewLine + Environment.NewLine
             + "< ! > Roll has a lingering armor buff that helps to use it aggressively." + Environment.NewLine + Environment.NewLine
             + "< ! > Bomb can be used to wipe crowds with ease." + Environment.NewLine + Environment.NewLine;

        internal const float swordDamageCoefficient = 2.8f;

        internal const float gunDamageCoefficient = 4.2f;

        internal const float bombDamageCoefficient = 16f;

        #region Parry Stuff
        internal const float bigParryFreezeRadius = 20f;
        internal const float bigParryFreezeDuration = 1.5f;
        internal const float bigParryHealthFrac = 0.2f;
        #endregion

        #region Orb Controller Values
        internal const float flatIncreaseOrbIncrementor = 0.5f;
        internal const float LimitToGrantOrb = 10f;
        #endregion

        #region Blue Orb
        internal const float blueOrbCoefficient = 2f;
        internal const float blueOrbBlastRadius = 10f;
        internal const float blueOrbTripleMultiplier = 1.5f;
        #endregion

        #region Domain
        internal const float domainShiftBlastRadius = 10f;
        internal const float domainShiftCoefficient = 3f;
        #endregion


        #region Yellow Orb
        internal const float yellowOrbDamageCoefficient = 2f;
        internal const int yellowOrbBaseHitAmount = 3;
        internal const float yellowOrbProcCoefficient = 1f;

        internal const float yellowOrbDomainDamageCoefficient = 1f;
        internal const float yellowOrbDomainBlastRadius = 20f;
        internal const int yellowOrbDomainFireCount = 6;
        #endregion


        #region Red Orb
        internal const float redOrbDamageCoefficient = 2f;
        internal const int redOrbBaseHitAmount = 3;
        internal const float redOrbProcCoefficient = 1f;

        internal const float redOrbDomainDamageCoefficient = 2f;
        internal const float redOrbDomainBlastRadius = 20f;
        internal const int redOrbDomainFireCount = 4;
        #endregion

        #region Ultimate
        internal const float ultimateDamageCoefficient = 44f;
        internal const float ultimateProcCoefficient = 1f;
        internal const float ultimateBlastRadius = 20f;
        internal const float ultimateFreezeDuration = 8f;

        internal const float ultimateDomainMiniDamageCoefficient = 1f;
        internal const float ultimateDomainDamageCoefficient = 4f;
        internal const float ultimateDomainBlastRadius = 40f;
        internal const int ultimateDomainFireCount = 3;
        internal const float ultimateDomainDuration = 4f;
        #endregion

        #region Static functions

        public static Vector3 CheckDirection(Vector3 moveVector, Ray aimRay)
        {
            Vector3 outputVector = new Vector3();
            if (moveVector == Vector3.zero)
            {
                outputVector = new Vector3(0, 0, 0); // Dodge backwards.

                return outputVector;
            }

            Vector3 direction = new Vector3(aimRay.direction.x, 0, aimRay.direction.z);
            Vector3 rotatedVector = Quaternion.AngleAxis(90, Vector3.up) * direction;

            if (Vector3.Dot(direction, moveVector) <= -0.833f)
            {
                outputVector = new Vector3(0, 0, 0);
                return outputVector;
            }

            //Should be rotated 90 degrees
            if (Vector3.Dot(rotatedVector, moveVector) >= 0.833f)
            {
                // It's in the right direction
                outputVector = new Vector3(1, 0, 0);
            }
            else
            {
                outputVector = new Vector3(-1, 0, 0);
            }

            return outputVector;
        }
        #endregion
    }
}