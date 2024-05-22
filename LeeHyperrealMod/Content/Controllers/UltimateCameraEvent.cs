using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class UltimateCameraEvent : MonoBehaviour
    {

        public CharacterBody body;
        public UltimateCameraController controller;

        public void CameraFinished(AnimationEvent animationEvent)
        {
            if (controller) 
            {
                controller.UnsetUltimate();
            }
        }
    }
}
