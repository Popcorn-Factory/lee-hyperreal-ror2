using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class UltimateCameraEvent : MonoBehaviour
    {
        public UltimateCameraController controller;

        public void CameraFinished(string str)
        {
            Debug.Log(str);
            if (controller)
            {
                switch (str) 
                {
                    case "domain":
                        controller.UnsetDomainUltimate();
                        break;
                    case "nondomain":
                        controller.UnsetUltimate();
                        break;
                }
            }
        }
    }
}
