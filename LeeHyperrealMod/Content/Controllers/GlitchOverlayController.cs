using LeeHyperrealMod.Modules.Survivors;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class GlitchOverlayController : MonoBehaviour
    {
        public bool ShouldRandomlyPulse = false;
        public bool setpulse = false;
        public CharacterBody characterBody;

        public bool isActive = false;

        public float randomOff = 0f;
        public float randomOn = 0f;
        public float stopwatch = 0f;

        public float setStopwatch = 0f;
        public float pulseOn = 0f;

        public void Start() 
        {
            Hook();
            characterBody = GetComponent<CharacterBody>();

            // Check for glitch skin
            if (characterBody.skinIndex == LeeHyperreal.glitchSkinIndex) 
            {
                ShouldRandomlyPulse = true;
            }
        }

        public void RandomiseIntervals() 
        {
            randomOff = UnityEngine.Random.Range(2f, 4f);
            randomOn = UnityEngine.Random.Range(0.05f, 0.2f);
            pulseOn = randomOn;
        }

        public void RandomlyPulse() 
        {
            stopwatch += Time.deltaTime;

            if (isActive)
            {
                if (stopwatch >= randomOn)
                {
                    isActive = false;
                    stopwatch = 0f;
                }
            }
            else 
            {
                if (stopwatch >= randomOff) 
                {
                    RandomiseIntervals();
                    isActive = true;
                    stopwatch = 0f;
                }
            }
        }

        public void Update() 
        {
            if (ShouldRandomlyPulse) 
            {
                RandomlyPulse();
            }

            if (setpulse) 
            {
                RunPulse();
            }
        }

        private void RunPulse()
        {
            setStopwatch += Time.deltaTime;

            if (setStopwatch <= pulseOn)
            {
                isActive = true;
            }
            else 
            {
                isActive = false;
                setpulse = false;
                setStopwatch = 0f;
            }
        }

        public void TriggerPulse() 
        {
            RandomiseIntervals();
            setpulse = true;
            setStopwatch = 0f;
        }

        public void OnDestroy() 
        {
            Unhook();
        }


        public void Hook()
        {
            On.RoR2.CharacterModel.UpdateOverlays += CharacterModel_UpdateOverlays;
        }

        public void Unhook()
        {
            On.RoR2.CharacterModel.UpdateOverlays -= CharacterModel_UpdateOverlays;
        }

        private void CharacterModel_UpdateOverlays(On.RoR2.CharacterModel.orig_UpdateOverlays orig, CharacterModel self)
        {
            orig(self);

            if (self)
            {
                if (self.body)
                {
                    GlitchOverlayController glitchOverlayController = self.body.GetComponent<GlitchOverlayController>();
                    if (glitchOverlayController && self.body.skinIndex == LeeHyperreal.glitchSkinIndex)
                    {
                        this.overlayFunction(Modules.Assets.glitchMaterial, isActive, self);
                    }
                }
            }
        }



        private void overlayFunction(Material overlayMaterial, bool condition, CharacterModel model)
        {
            if (model.activeOverlayCount >= CharacterModel.maxOverlays)
            {
                return;
            }
            if (condition)
            {
                Material[] array = model.currentOverlays;
                int num = model.activeOverlayCount;
                model.activeOverlayCount = num + 1;
                array[num] = overlayMaterial;
            }
        }
    }
}
