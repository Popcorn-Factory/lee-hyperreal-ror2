using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

[ExecuteInEditMode]
public class ScreenshotEffect : MonoBehaviour
{
    public GameObject objNeedToShow;
    public Renderer[] renderers;
    bool excute;
    void OnEnable()
    {
        if(!Camera.main.GetComponent<CameraScreenShotRender>()) 
        {
            Camera.main.gameObject.AddComponent<CameraScreenShotRender>();
        }
        ScreenshotManager.IncreaseRefCount();
        excute = true;
    }
    //void Awake()
    //{
    //    //#if UNITY_EDITOR
    //    if (GetComponent<XScreenShotEffect>())
    //    {
    //        XScreenShotEffect ef = GetComponent<XScreenShotEffect>();
    //        objNeedToShow = ef.objNeedToShow;
    //        if (ef.renderers.Length > 0)
    //        {
    //            renderers = new Renderer[ef.renderers.Length];
    //            renderers = ef.renderers;
    //        }

    //    }
    //    //#endif
    //}
    void ScreenShot()
    {
        //if (objNeedToShow)
        //{
        //    objNeedToShow.SetActive(false);
        //}
        Action<RenderTexture> action = new Action<RenderTexture>(b_);
        
        ScreenshotManager.needScreenShot = true;
        ScreenshotManager.actionAfterScreenShot = action;
        void b_(RenderTexture source)
        {
            if (renderers.Length != 0)
            {

                for (int i = 0; i < renderers.Length; i++)
                {
                    if (!renderers[i])
                        break;
                    renderers[i].sharedMaterial.SetTexture("_MainTex", source);
                    //Debug.Log("set material of " + renderers[i]+" to "+source);
                }
                if (objNeedToShow)
                    objNeedToShow.SetActive(true);
                return;
            }
        }
    }


 

    void Update()
    {
        if(excute)
            ScreenShot();
        excute=false;
    }

    void OnDisable()
    {
        ScreenshotManager.DecreaseRefCount();

    }


}
