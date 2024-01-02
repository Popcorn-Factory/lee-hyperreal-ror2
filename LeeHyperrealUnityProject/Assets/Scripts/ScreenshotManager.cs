using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class ScreenshotManager
{
    public static bool needScreenShot;
    static RenderTexture screenShot;
    public static int screenShotRefCount;
    public static Action<RenderTexture> actionAfterScreenShot;
    public static void UseScreenShot(Action<RenderTexture> action)
    {
        needScreenShot = true;
        actionAfterScreenShot = action;
    }

    public static bool isNeedScreenShot()
    {

        return needScreenShot;
    }

    public static void IncreaseRefCount()
    {
        screenShotRefCount++;
        //Debug.Log("increased ref count");
    }

    public static void DecreaseRefCount()
    {
        screenShotRefCount--;
       // Debug.Log("decreased ref count");
        if (screenShotRefCount==0)
            ClearRT();
    }

    static void ClearRT()
    {
        if(screenShot)
            RenderTexture.ReleaseTemporary(screenShot);
        screenShot = null;
    }

    public static void BlitToScreenShot(RenderTexture source)
    {
       // Debug.Log("running blitToScreenshot");
        if (screenShot == null)
        {
      





            ClearRT();
            screenShot = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.Default, RenderTextureReadWrite.Linear);
            screenShot.name = "ScreenShot";
        }
        else
        {
            if(screenShot.width != source.width||screenShot.height!=source.height)
            {
                ClearRT();
                screenShot = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.Default, RenderTextureReadWrite.Linear);
                screenShot.name = "ScreenShot";
            }
        }
        Graphics.Blit(source, screenShot);
        if (actionAfterScreenShot == null)
            return;
        actionAfterScreenShot.Invoke(screenShot);
        actionAfterScreenShot = null;

        needScreenShot = false;
    }
}
