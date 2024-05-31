using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class UltimateCameraEvent : MonoBehaviour
    {
        public UltimateCameraController controller;

        public void CameraFinished(AnimationEvent animationEvent)
        {
            Debug.Log(animationEvent.stringParameter);
            if (controller)
            {
                controller.UnsetUltimate();
            }
        }
    }
}
