using RoR2.Projectile;
using RoR2;
using System;
using UnityEngine;
using UnityEngine.UIElements;
using EntityStates;

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
        internal const float parryProjectileRadius = 10f;
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

        //private void ParryLasers()
        //{
        //    if (this.usingBash)
        //        return;

        //    if (enforcerNet.parries <= 0)
        //        return;

        //    Util.PlayAttackSpeedSound(Sounds.BashDeflect, EnforcerPlugin.VRAPICompat.IsLocalVRPlayer(characterBody) ? EnforcerPlugin.VRAPICompat.GetShieldMuzzleObject() : gameObject, UnityEngine.Random.Range(0.9f, 1.1f));

        //    for (int i = 0; i < enforcerNet.parries; i++)
        //    {
        //        //using drOctagonapus monobehaviour to start the coroutine, however any monobehaviour would work
        //        this.shieldComponent.drOctagonapus.StartCoroutine(ShootParriedLaser(i * parryInterval));
        //    }

        //    enforcerNet.parries = 0;

        //    if (!this.hasDeflected)
        //    {
        //        this.hasDeflected = true;

        //        if (Config.sirenOnDeflect.Value)
        //            Util.PlaySound(Sounds.SirenDeflect, base.gameObject);

        //        base.characterBody.GetComponent<EnforcerLightController>().FlashLights(3);
        //        base.characterBody.GetComponent<EnforcerLightControllerAlt>().FlashLights(3);
        //    }
        //}

        //private IEnumerator ShootParriedLaser(float delay)
        //{
        //    yield return new WaitForSeconds(delay);

        //    Ray aimRay = base.GetAimRay();

        //    Vector3 point = aimRay.GetPoint(1000);
        //    Vector3 laserDirection = point - transform.position;

        //    GolemMonster.FireLaser fireLaser = new GolemMonster.FireLaser();
        //    fireLaser.laserDirection = laserDirection;
        //    this.shieldComponent.drOctagonapus.SetInterruptState(fireLaser, InterruptPriority.Skill);
        //}

        /*
            private void FireLaser_OnEnter(On.EntityStates.GolemMonster.FireLaser.orig_OnEnter orig, EntityStates.GolemMonster.FireLaser self)
        {
            orig(self);

            Ray ray = self.modifiedAimRay;

            CheckEnforcerParry(ray);
        }

        private static void CheckEnforcerParry(Ray ray) {

            RaycastHit raycastHit;

            if (Physics.Raycast(ray, out raycastHit, 1000f, LayerIndex.world.mask | LayerIndex.defaultLayer.mask | LayerIndex.entityPrecise.mask)) {
                                                                             //do I have this power?
                GameObject gob = raycastHit.transform.GetComponent<HurtBox>()?.healthComponent.gameObject;

                if (!gob) {
                    gob = raycastHit.transform.GetComponent<HealthComponent>()?.gameObject;
                }
                                                //I believe I do. it makes the decompiled version look mad ugly tho
                EnforcerComponent enforcer = gob?.GetComponent<EnforcerComponent>();

                //Debug.LogWarning($"tran {raycastHit.transform}, " +
                //    $"hurt {raycastHit.transform.GetComponent<HurtBox>()}, " +
                //    $"health {raycastHit.transform.GetComponent<HurtBox>()?.healthComponent.gameObject}, " +
                //    $"{gob?.GetComponent<EnforcerComponent>()}");

                if (enforcer) {
                    enforcer.invokeOnLaserHitEvent();
                }
            }
        }
         */

        #endregion
    }
}