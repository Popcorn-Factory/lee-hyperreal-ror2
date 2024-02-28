using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.ParticleScripts
{
    public class CameraScreenShotRender : MonoBehaviour
    {

        void OnRenderImage(RenderTexture source, RenderTexture dst)
        {
            if (ScreenshotManager.isNeedScreenShot())
            {
                ScreenshotManager.BlitToScreenShot(source);
            }
            Graphics.Blit(source, dst);
        }
    }
}