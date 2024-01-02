using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
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
