using RoR2.Projectile;
using RoR2;
using System;
using UnityEngine;
using UnityEngine.UIElements;
using EntityStates;
using TMPro;

namespace LeeHyperrealMod.Modules
{
    internal static class StaticValues
    {        
        internal const float swordDamageCoefficient = 2.8f;

        internal const float gunDamageCoefficient = 4.2f;

        internal const float bombDamageCoefficient = 16f;

        #region Primary 1
        internal const float primary1DamageCoefficient = 1.5f;
        internal const float primary1ProcCoefficient = 1f;
        internal const float primary1PushForce = 300f;
        internal const float primary1HitHopVelocity = 4f;
        internal const float primary1ParryLength = 0.15f; //How long the parry window is openf or
        internal const float primary1ParryTiming = 0.025f; // A percentage of the duration in which the parry starts
        internal const float primary1ParryPauseLength = 0.2f; // How long YOU are stuck in hit pause when a parry is triggered
        internal const float primary1ParryProjectileTimingStart = 0.03f; // Percentage of the duration of the move where a projectile parry can be triggered
        internal const float primary1ParryProjectileTimingEnd = 0.07f; // Percentage of the duration of the move when a projectile parry can be triggered. In this case it's ranging from duration * start to duration * end, this value should never be higher than 1f
        #endregion

        #region Primary 2
        internal const float primary2DamageCoefficient = 2f;
        internal const float primary2ProcCoefficient = 1f;
        internal const float primary2PushForce = 300f;
        internal const float primary2HitHopVelocity = 4f;
        #endregion

        #region Primary 3
        internal const float primary3DamageCoefficient = 3f;
        internal const float primary3ProcCoefficient = 1f;
        internal const float primary3PushForce = 300f;
        internal const float primary3HitHopVelocity = 4f;
        internal const float primary3ParryLength = 0.45f; //How long the parry window is openf or
        internal const float primary3ParryTiming = 0.08f; // A percentage of the duration in which the parry starts
        internal const float primary3ParryPauseLength = 0.2f; // How long YOU are stuck in hit pause when a parry is triggered
        internal const float primary3ParryProjectileTimingStart = 0.05f; // Percentage of the duration of the move where a projectile parry can be triggered
        internal const float primary3ParryProjectileTimingEnd = 0.1f; // Percentage of the duration of the move when a projectile parry can be triggered. In this case it's ranging from 5% to 10% of the move, this value should never be higher than 1f
        #endregion

        #region Primary 4
        internal const float primary4DamageCoefficient = 1f; // This is per tick!
        internal const float primary4ProcCoefficient = 1f;
        internal const float primary4BasePulseRate = 0.2f;
        internal const float primary4BlastRadius = 30f;
        #endregion

        #region Primary 5
        internal const float primary5DamageCoefficient = 10f;
        internal const float primary5ProcCoefficient = 1f;
        internal const float primary5PushForce = 300f;
        internal const float primary5HitHopVelocity = 4f;
        #endregion

        #region Primary Aerial
        internal const float primaryAerialSlamRadius = 20f;
        internal const float primaryAerialMaxDamageMultiplier = 3f;
        internal const float primaryAerialDamageCoefficient = 7f;
        internal const float primaryAerialProcCoefficient = 1f;
        internal const float primaryAerialSlamSpeed = 70f;
        #endregion

        #region Domain Shift
        internal const float forceUpwardsMagnitude = 7f;
        #endregion

        #region Parry Stuff
        internal const float bigParryFreezeRadius = 20f;
        internal const float bigParryFreezeDuration = 1.5f;
        internal const float bigParryLeeFreezeDuration = 0.6f;
        internal const float bigParryHealthFrac = 0.2f;
        internal const float parryProjectileRadius = 5f;
        internal const float parryProjectileDamageMultiplier = 10f;
        internal const int enhancedBulletGrantOnProjectileParry = 1;
        internal const int enhancedBulletGrantOnDamageParry = 1;
        #endregion

        #region Orb Controller Values
        internal const float flatIncreaseOrbIncrementor = 0.5f;
        internal const float LimitToGrantOrb = 1f; // Amount that determines when to give orb, smaller = faster.
        internal const float yAxisPositionBrackets = -135f;
        #endregion

        #region Blue Orb
        internal const float blueOrbCoefficient = 6f;
        internal const float blueOrbBlastRadius = 12f;
        internal const float blueOrbTripleMultiplier = 4f;
        internal const float blueOrbShotCoefficient = 4f;
        internal const float blueOrbProcCoefficient = 1f;
        #endregion

        #region Domain
        internal const float domainShiftBlastRadius = 10f;
        internal const float domainShiftCoefficient = 3f;
        internal const float domainShiftBulletDamageCoefficient = 4.5f;
        internal const float energyRechargeSpeed = 50f;
        internal const float energyConsumptionSpeed = 3f;
        internal const int maxIntuitionStocks = 4;
        #endregion

        #region Yellow Orb
        internal const float yellowOrbDamageCoefficient = 1f;
        internal const int yellowOrbBaseHitAmount = 3;
        internal const float yellowOrbProcCoefficient = 1f;
        internal const float yellowOrbTripleMultiplier = 4f;
        internal const float yellowOrbBlastRadius = 10f;

        internal const float yellowOrbFinisherDamageCoefficient = 6f;
        internal const float yellowOrbFinisherProcCoefficient = 1f;
        internal const float yellowOrbFinisherPushForce = 300f;

        internal const float yellowOrbDomainDamageCoefficient = 1f;
        internal const float yellowOrbDomainProcCoefficient = 1f;
        internal const float yellowOrbDomainBlastForce = 1000f;
        internal const float yellowOrbDomainBlastRadius = 20f;
        internal const int yellowOrbDomainFireCount = 9;
        internal const float yellowOrbDomainTripleMultiplier = 4f;

        internal const float yellowOrbFinisherParryLength = 0.75f; //How long the parry window is openf or
        internal const float yellowOrbFinisherParryTiming = 0.025f; // A percentage of the duration in which the parry starts
        internal const float yellowOrbFinisherParryPauseLength = 0.2f; // How long YOU are stuck in hit pause when a parry is triggered
        internal const float yellowOrbFinisherParryProjectileTimingStart = 0.04f; // Percentage of the duration of the move where a projectile parry can be triggered
        internal const float yellowOrbFinisherParryProjectileTimingEnd = 0.08f; // Percentage of the duration of the move when a projectile parry can be triggered. In this case it's ranging from 5% to 10% of the move, this value should never be higher than 1f
        #endregion

        #region Red Orb
        internal const float redOrbDamageCoefficient = 1.5f;
        internal const int redOrbBaseHitAmount = 3; // Amount of shots at 1 attack speed
        internal const float redOrbProcCoefficient = 1f;
        internal const float redOrbBulletRange = 256f;
        internal const float redOrbBulletForce = 800f;
        internal const float redOrbTripleMultiplier = 4f;

        internal const float redOrbFinisherDamageCoefficient = 6f;
        internal const float redOrbFinisherProcCoefficient = 1f;
        internal const float redOrbFinisherBulletRange = 256f;
        internal const float redOrbFinisherBulletForce = 800f;

        internal const float redOrbDomainDamageCoefficient = 4f;
        internal const float redOrbDomainBlastRadius = 10f;
        internal const int redOrbDomainFireCount = 3;
        internal const float redOrbDomainProcCoefficient = 1f;
        internal const float redOrbDomainBlastForce = 1000f;
        internal const float redOrbDomainBaseFireInterval = 0.15f;
        internal const float redOrbDomainTripleMultiplier = 4f;
        #endregion

        #region Ultimate
        internal const float ultimateDamageCoefficient = 40f;
        internal const float ultimateProcCoefficient = 1f;
        internal const float ultimateBlastRadius = 25f;
        internal const float ultimateFreezeDuration = 8f;

        internal const float ultimateDomainMiniDamageCoefficient = 2f;
        internal const float ultimateDomainDamageCoefficient = 20f;
        internal const float ultimateDomainBlastRadius = 50f;
        internal const int ultimateDomainFireCount = 3;
        internal const float ultimateDomainDuration = 4f;
        #endregion

        #region Invincibility Health
        internal static Color blueInvincibility = new Color(c(104), c(244), c(255), c(255));
        internal static Color parryInvincibility = new Color(c(255), c(139), c(232), c(255));
        #endregion

        #region Snipe
        internal const float snipeProcCoefficient = 1f;
        internal const float snipeRange = 1000f;
        internal const float snipeDamageCoefficient = 4f;
        internal const float snipeForce = 100f;
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