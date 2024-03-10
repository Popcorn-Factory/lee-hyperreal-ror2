using System;
using System.Collections;
using System.Collections.Generic;
using System.Xml.Serialization;
// using RoR2;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.UIElements;

namespace LeeHyperrealMod.ParticleScripts 
{
    public class EffectScaler : MonoBehaviour
    {
        public enum Operation
        {
            Scale = 1,
            Flip
        }

        public enum MatchType
        {
            ScreenAspect,
            RectTransform
        }

        public enum CameraSearchRule
        {
            MainOrParentCamera,
            CameraUI,
            FarCamera,
            NearCamera,
            CustomCamera
        }

        public enum ScaleType
        {
            Clip,
            Scale,
            ScaleByWidth,
            ScaleByHeight,
            KeepAspectWithoutClip
        }

        public bool IsFightSceneEffect;
        public MatchType matchType;
        public ScaleType Type;
        public Operation operation;
        public float DesignWidth;
        public float DesignHeight;
        [SerializeField]
        float LastWidth;
        [SerializeField]
        float LastHeight;
        [SerializeField]
        ScaleType LastType;
        public float DesignFOV;
        public CameraSearchRule cameraSearchRule;
        public Camera CustomCamera;
        private const float DESIGN_SCREEN_ASPECT = 1.7777778f;
        Vector3 OriginScale;
        Camera CameraCached;
        [SerializeField]
        float LastFieldOfView;
        [SerializeField]
        float LastAspect;
        [SerializeField]
        int LastLayer;
        public RectTransform MatchRectTransform
        {
            get
            {
                if (transform.GetType() == typeof(RectTransform))
                    return (RectTransform)transform;
                else
                    return null;
            }
        }
        float DesignTanHalfFov
        {
            get
            {
                return Mathf.Tan((DesignFOV * 0.017453292f) * 0.5f);
            }
        }
        public Camera GetCamera()
        {
            if (CameraCached)
                return CameraCached;
            switch (cameraSearchRule)
            {
                case CameraSearchRule.MainOrParentCamera:
                    //Debug.Log(Camera.main);
                    return Camera.main;

                case CameraSearchRule.CameraUI:
                    return Camera.current;

                case CameraSearchRule.FarCamera:
                    return Camera.current;
                case CameraSearchRule.NearCamera:
                    return Camera.current;
                case CameraSearchRule.CustomCamera:
                    return CustomCamera;

            }
            return null;
        }

        void Awake()
        {
            OriginScale = transform.localScale;
            //Debug.Log("Awake originScale: " + OriginScale);
        }

        void OnEnable()
        {
            OriginScale = transform.localScale;
            if (IsReady())
                DoTransform();
        }

        void OnDisable()
        {
            CameraCached = null;
            LastAspect = 0;
            LastFieldOfView = 0;
            LastHeight = 0;
            LastWidth = 0;
            LastLayer = 0;
            transform.localScale = Vector3.one;
            OriginScale = Vector3.zero;
        }

        bool IsReady()
        {
            if (!IsFightSceneEffect)
                return true;
            else
            {
                Debug.LogError("not supported!");
                return false;
            }
        }

        void Update()
        {
            if (IsReady())
                DoTransform();
        }

        void DoTransform()
        {
            if (operation == Operation.Scale)
            {
                if (matchType == MatchType.RectTransform)
                    ScaleByRectTransform(ref OriginScale);
                else
                    ScaleByScreenAspect(ref OriginScale);
            }
            else if (operation == Operation.Flip)
                DoFlip();
        }

        void DoFlip()
        {
            if (GetCamera())
            {
                Vector3 forword = transform.forward;
                float dot = Vector3.Dot(forword, GetCamera().transform.forward);
                if (dot < 0)
                {
                    Vector3 euler = transform.localEulerAngles;
                    Vector3 tmp;
                    tmp.x = euler.x;
                    tmp.y = euler.y + 180;
                    tmp.z = euler.z;
                    transform.localEulerAngles = tmp;
                    return;
                }
            }
        }

        void DoScale()
        {
            if (matchType == MatchType.RectTransform)
                ScaleByRectTransform(ref OriginScale);
            else
                ScaleByScreenAspect(ref OriginScale);
        }

        void ScaleByScreenAspect(ref Vector3 localScale)
        {
            Camera camera = GetCamera();
            if (camera)
            {
                if (camera.aspect == LastAspect && camera.fieldOfView == LastFieldOfView && Type == LastType && gameObject.layer == LastLayer)
                {
                    return;
                }
                ScaleByAspect(ref localScale, camera.aspect);
                float tmp = Mathf.Tan((camera.fieldOfView * 0.01745329f) * 0.5f);
                //Debug.Log("cameraFOVtanHalfFOV: " + tmp);
                float tmp2 = DesignTanHalfFov;
                // Debug.Log("DesignTanHalfFov: " + tmp2);
                //Debug.Log("originScale: " + OriginScale);
                localScale.y = (tmp / tmp2) * localScale.y;
                localScale.x = (tmp / tmp2) * localScale.x;
                //transform.localScale = localScale;
                LastType = Type;
                LastAspect = camera.aspect;
                LastFieldOfView = camera.fieldOfView;
                LastLayer = gameObject.layer;
                transform.localScale = localScale;
            }
        }

        void ScaleByRectTransform(ref Vector3 localScale)
        {
            if (!MatchRectTransform)
            {
                Debug.LogError("no RectTransform!");
                return;
            }
            if (MatchRectTransform.rect.width != LastWidth || MatchRectTransform.rect.height != LastHeight || Type != LastType)
            {
                ScaleRectTransform(ref localScale, MatchRectTransform.rect.width, MatchRectTransform.rect.height);
                LastType = Type;
                LastWidth = MatchRectTransform.rect.width;
                LastHeight = MatchRectTransform.rect.height;
            }

        }

        void ScaleRectTransform(ref Vector3 localScale, float width, float height)
        {
            float Desasp = DesignWidth / DesignHeight;
            float asp = width / height;
            float tmp = 0;
            float tmp2 = 0;
            Vector2 tmpx2;
            if (Type == ScaleType.Clip)
            {

                if (Desasp < asp)
                {

                    tmpx2.y = width / DesignWidth;
                    tmpx2.x = tmpx2.y;
                }
                else
                {
                    tmpx2.y = height / DesignHeight;
                    tmpx2.x = tmpx2.y;
                }

            }
            else
            {

                if (Type == ScaleType.Scale)
                {
                    tmpx2 = new Vector2(width / DesignWidth, height / DesignHeight);
                    goto label_2;
                }
                else if (Type == ScaleType.ScaleByWidth)
                {



                    tmpx2.y = width / DesignWidth;
                    tmpx2.x = tmpx2.y;

                }
                else if (Type != ScaleType.ScaleByHeight)
                {
                    if (Type != ScaleType.KeepAspectWithoutClip)
                    {
                        tmpx2 = Vector2.one;

                        goto label_2;
                    }
                    if (asp < Desasp)
                    {
                        tmpx2.y = width / DesignWidth;
                        tmpx2.x = tmpx2.y;
                    }

                }
                tmpx2.y = height / DesignHeight;
                tmpx2.x = tmpx2.y;
            }

        label_2:
            localScale.x *= tmpx2.x;
            localScale.y *= tmpx2.y;
            localScale.z = 0;
            transform.localScale = localScale;
        }

        void ScaleByFov(ref Vector3 localScale, float fieldOfView)
        {
            float tmp = Mathf.Tan((fieldOfView * 0.01745329f) * 0.5f);
            float tmp2 = DesignTanHalfFov;
            localScale.y = (tmp / tmp2) * localScale.y;
            localScale.x = (tmp / tmp2) * localScale.x;
            transform.localScale = localScale;
        }

        void ScaleByAspect(ref Vector3 localScale, float aspect)
        {
            bool tmp;
            if ((gameObject.layer == LayerMask.NameToLayer("UI")))
            {
                ScaleUi(ref localScale, aspect);
                return;
            }
            if (Type == ScaleType.Clip)
            {
                tmp = aspect < DESIGN_SCREEN_ASPECT;
            }
            else if (Type == ScaleType.Scale)
            {
                localScale.x = (aspect * localScale.x) / DESIGN_SCREEN_ASPECT;
                return;
            }
            else if (Type == ScaleType.ScaleByWidth)
            {
                localScale.x = (aspect / DESIGN_SCREEN_ASPECT) * localScale.x;
                localScale.y = (aspect / DESIGN_SCREEN_ASPECT) * localScale.y;
                return;
            }
            else if (Type == ScaleType.ScaleByHeight)
                return;
            else if (Type == ScaleType.KeepAspectWithoutClip)
            {
                tmp = DESIGN_SCREEN_ASPECT < aspect;
                if (tmp || aspect == DESIGN_SCREEN_ASPECT)
                    return;
                localScale.x = (aspect / DESIGN_SCREEN_ASPECT) * localScale.x;
                localScale.y = (aspect / DESIGN_SCREEN_ASPECT) * localScale.y;
                return;
            }


        }

        void ScaleCommon(ref Vector3 localScale, float aspect)
        {
            bool check;
            if (Type == ScaleType.Clip)
            {
                check = aspect < DESIGN_SCREEN_ASPECT;
            }
            else if (Type == ScaleType.Scale)
            {
                localScale.x = (aspect * localScale.x) / DESIGN_SCREEN_ASPECT;
                return;
            }
            else if (Type == ScaleType.ScaleByWidth)
            {
                localScale.x = (aspect / DESIGN_SCREEN_ASPECT) * localScale.x;
                localScale.y = (aspect / DESIGN_SCREEN_ASPECT) * localScale.y;
                return;
            }
            else if (Type == ScaleType.ScaleByHeight)
                return;
            else
            {
                check = DESIGN_SCREEN_ASPECT < aspect;
            }
            if (check || aspect == DESIGN_SCREEN_ASPECT)
                return;
            localScale.x = (aspect / DESIGN_SCREEN_ASPECT) * localScale.x;
            localScale.y = (aspect / DESIGN_SCREEN_ASPECT) * localScale.y;
            return;

        }

        void ScaleUi(ref Vector3 localScale, float aspect)
        {
            float localY = 0;
            if (Type == ScaleType.Clip)
            {
                if (DESIGN_SCREEN_ASPECT <= aspect)
                {
                    localScale.x = (aspect / DESIGN_SCREEN_ASPECT) * localScale.x;
                    localScale.y = (aspect / DESIGN_SCREEN_ASPECT) * localScale.y;
                    return;
                }
                localScale.x = localScale.x * ((1 / aspect) / 0.5625f);
                localY = ((1 / aspect) / 0.5625f) * localScale.y;
            }
            else
            {
                if (Type != ScaleType.Scale)
                {
                    if (Type == ScaleType.ScaleByWidth)
                    {
                        if (aspect <= DESIGN_SCREEN_ASPECT)
                        {
                            return;
                        }
                        localScale.x = (aspect / DESIGN_SCREEN_ASPECT) * localScale.x;
                        localScale.y = (aspect / DESIGN_SCREEN_ASPECT) * localScale.y;
                        return;
                    }
                    if (Type != ScaleType.ScaleByHeight)
                        return;
                    if (DESIGN_SCREEN_ASPECT <= aspect)
                        return;
                    localY = (1 / aspect) / 0.5625f;
                    localScale.y = localY * localScale.y;
                    localScale.x = localY * localScale.x;
                    return;
                }
                if (DESIGN_SCREEN_ASPECT < aspect)
                {
                    localScale.x = (aspect * localScale.x) / DESIGN_SCREEN_ASPECT;
                    return;
                }
                localY = ((1 / aspect) * localScale.y) / 0.5625f;



            }


            localScale.y = localY;
        }

        public EffectScaler()
        {
            LastFieldOfView = -1;
            LastAspect = -1;
        }
    }
}