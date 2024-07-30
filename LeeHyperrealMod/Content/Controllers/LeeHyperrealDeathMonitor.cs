using System;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
	public class LeeHyperrealDeathMonitor : MonoBehaviour
	{
        /*
         - Check Health constantly
         - If health drops under X%, play near death sound, set timer to prevent the sound from playing
            more than once in Y seconds,
         - Once Y seconds has elapsed, allow playing of the sound if he drops below the low health fraction
         - If he stays at low health, even after the Y seconds has elapsed, never play the sound after the first time it plays. 
         */
        public HealthComponent healthComponent;
        public const float timeToElapseTillNextAllowedPlay = 60f;
        public float timerSinceLowHealth;
        public bool isHealthLow; // Value should be observed if changed.
        public bool canPlayNextTime;
        public bool timerElapsed;
        public bool timerStarted;
        public bool hasRecoveredAboveRequiredFraction;

        public void Start()
        {
            Hook();
            canPlayNextTime = false;
            hasRecoveredAboveRequiredFraction = false;
            isHealthLow = false;
            timerElapsed = true; // Can play the next time we hit
            timerSinceLowHealth = 0f;
            healthComponent = GetComponent<HealthComponent>();
        }

        public void OnDestroy()
        {
            Unhook();
        }

        public void Update()
        {
            if (timerStarted)
            {
                timerSinceLowHealth += Time.deltaTime;
                if (timerSinceLowHealth > timeToElapseTillNextAllowedPlay)
                {
                    timerSinceLowHealth = 0f;
                    timerElapsed = true;
                    timerStarted = false;
                }
            }

            CheckHealthLow();
            CheckCanPlayLowHealthLine();
        }

        private void CheckCanPlayLowHealthLine()
        {
            if (canPlayNextTime)
            {
                //Consume Value.
                canPlayNextTime = false;

                //Play voice line here.
            }
        }

        private void CheckHealthLow()
        {
            if (healthComponent)
            {
                if (healthComponent.isHealthLow != isHealthLow)
                {
                    //Check when set to true.
                    if (healthComponent.isHealthLow)
                    {
                        if (timerElapsed)
                        {
                            canPlayNextTime = true;
                            timerStarted = false;
                            timerElapsed = false;
                        }
                    }

                    //Otherwise just continue.
                    isHealthLow = healthComponent.isHealthLow;
                }
            }
        }

        public void Hook()
        {
            On.RoR2.CharacterBody.OnDeathStart += CharacterBody_OnDeathStart;
        }

        public void Unhook()
        {
            On.RoR2.CharacterBody.OnDeathStart -= CharacterBody_OnDeathStart;
        }

        private void CharacterBody_OnDeathStart(On.RoR2.CharacterBody.orig_OnDeathStart orig, CharacterBody self)
        {
            orig(self);
            if (self)
            {
                if (self.baseNameToken == LeeHyperrealPlugin.DEVELOPER_PREFIX + "_LEE_HYPERREAL_BODY_NAME")
                {
                    //Play death sound.
                }
            }
        }

    }
}

