﻿using System;
using UnityEngine;
using UnityEngine.UIElements;

namespace LeeHyperrealMod.Modules
{
    internal static class StaticValues
    {        
        internal const float swordDamageCoefficient = 2.8f;

        internal const float gunDamageCoefficient = 4.2f;

        internal const float bombDamageCoefficient = 16f;

        #region Domain Shift
        internal const float forceUpwardsMagnitude = 7f;
        #endregion

        #region Parry Stuff
        internal const float bigParryFreezeRadius = 20f;
        internal const float bigParryFreezeDuration = 1.5f;
        internal const float bigParryHealthFrac = 0.2f;
        #endregion

        #region Orb Controller Values
        internal const float flatIncreaseOrbIncrementor = 0.5f;
        internal const float LimitToGrantOrb = 1f; // Amount that determines when to give orb, smaller = faster.
        #endregion

        #region Blue Orb
        internal const float blueOrbCoefficient = 2f;
        internal const float blueOrbBlastRadius = 8f;
        internal const float blueOrbTripleMultiplier = 1.5f;
        internal const float blueOrbShotCoefficient = 2f;
        internal const float blueOrbProcCoefficient = 1f;
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
        internal const float redOrbDomainBlastRadius = 5f;
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

        #region Invincibility Health
        internal static Color blueInvincibility = new Color(c(104), c(244), c(255), c(255));
        internal static Color parryInvincibility = new Color(c(255), c(139), c(232), c(255));
        #endregion

        #region Static functions

        public static float c(int val) 
        {
            return (float)val / 255f;
        }

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

            if (Vector3.Dot(moveVector, aimRay.direction) >= 0.833f) 
            {
                outputVector = new Vector3(0, 0, 1);
                return outputVector;
            }

            if (Vector3.Dot(direction, moveVector) <= -0.833f)
            {
                outputVector = new Vector3(0, 0, 0); // dodge backwards
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