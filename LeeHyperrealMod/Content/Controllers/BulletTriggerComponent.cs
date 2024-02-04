using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class BulletTriggerComponent : MonoBehaviour
    {

        public CharacterBody body;
        public LeeHyperrealUIController uiController;

        public void FireEnhancedBulletEnd(AnimationEvent animationEvent)
        {
            if (body) 
            {
                if (body.hasEffectiveAuthority) 
                {
                    uiController.TriggerUpdateOnEnhanced();
                }
            }
        }

        public void FireBulletEnd(AnimationEvent animationEvent)
        {
            if (body)
            {
                if (body.hasEffectiveAuthority)
                {
                    uiController.TriggerUpdateOnColour();
                }
            }
        }

    }
}
