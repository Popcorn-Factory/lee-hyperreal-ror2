using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

namespace LeeHyperrealMod.ParticleScripts
{
    public class GPUParticlePlayer : MonoBehaviour
    {
        // Start is called before the first frame update
        [SerializeField]
        XGPUParticleDataSO data;
        [SerializeField]
        List<XGPUParticleDataSO> randomOtherData;
        [SerializeField]
        XGPUParticleDataSO curData;
        [SerializeField]
        Material mat;
        Material backupMat;
        Material cacheMat;
        [SerializeField]
        bool stopAtFinalFrame;
        [SerializeField]
        bool autoUpdate;
        [SerializeField]
        int simulateFramerate;
        [SerializeField]
        bool loop;
        [SerializeField]
        float loopIntervalTime;
        [SerializeField]
        int skipFrameCount;
        [SerializeField]
        float startWaitTime;
        float selfSpeed;
        bool startWait = true;
        float startWaitCount;
        MaterialPropertyBlock xBlock;
        [SerializeField]
        float curFrameFloat;
        public bool finished;
        [SerializeField]
        float particleDelta;
        float startWaitLength;
        [SerializeField]
        float loopLength;
        [SerializeField]
        float sumLength;

        float animLength;
        MeshRenderer meshRenderer;
        MeshFilter meshFilter;
        [SerializeField]
        bool reverse;
        [SerializeField]
        Material emptyMaterial;
        void Awake()
        {



            if (data)
            {
                data.TryInitialize();
            }
            backupMat = mat;
        }

        void OnDestroy()
        {

        }

        public void DisableGPUParticle()
        {
            if (cacheMat == null && mat != emptyMaterial)
            {
                cacheMat = mat;
                mat = emptyMaterial;
            }
            if (mat == emptyMaterial)
            {
                cacheMat = backupMat;
                mat = emptyMaterial;
            }


        }

        public void EnableGPUParticle()
        {
            if (cacheMat != null && cacheMat != emptyMaterial)
            {
                mat = cacheMat;
                cacheMat = null;
            }
            if (cacheMat != null && cacheMat == emptyMaterial)
            {
                mat = backupMat;
                cacheMat = null;
            }


        }

        public void OnEnable()
        {
            EnableGPUParticle();
            ResetParticle();

        }

        public void OnDisable()
        {
            DisableGPUParticle();
            ResetParticle();

        }



        MaterialPropertyBlock get_Block()
        {
            if (xBlock == null)
                xBlock = new MaterialPropertyBlock();
            return xBlock;
        }

        public MeshFilter get_Filter()
        {
            if (!meshFilter)
                meshFilter = GetComponent<MeshFilter>();
            return meshFilter;
        }

        MeshRenderer get_Renderer()
        {
            if (!meshRenderer)
                meshRenderer = GetComponent<MeshRenderer>();
            return meshRenderer;
        }

        public void SetSpeed(float speed)
        {
            selfSpeed = speed;
        }

        void DoUpdate()
        {
            if (autoUpdate && isActiveAndEnabled)
            {
                float deltaTime = Time.deltaTime;
                float speedDT = deltaTime * selfSpeed;
                //Debug.Log("speedDT: " + speedDT);
                if (!finished || stopAtFinalFrame)
                {



                    if (startWait)
                    {
                        float startwaitDT = speedDT + startWaitCount;
                        startWaitCount = startwaitDT;
                        if (startWaitCount >= startWaitLength)
                        {

                            float arg = startWaitCount - startWaitLength;
                            //Debug.Log("setting up particle with delta: " + arg);
                            SetupParticle(arg);
                            startWaitCount = 0;
                            startWait = false;
                        }

                    }
                    else
                    {
                        //Debug.Log("setting up particle");
                        SetupParticle(speedDT);
                    }

                    return;




                }
            }
        }

        void DoFrameUpdate(float delta)
        {
            if (!finished || stopAtFinalFrame)
            {
                if (startWait)
                {
                    float startWaitDelta = delta + startWaitCount;
                    startWaitCount = startWaitDelta;
                    if (startWaitCount >= startWaitLength)
                    {
                        SetupParticle(startWaitCount - startWaitLength);
                        startWaitCount = 0;
                        startWait = false;
                    }
                }
                else
                    SetupParticle(delta);
            }
        }

        void SetupParticle(float delta)
        {
            /*bool filterCheck;
            if (curData)
            {
                float workingCurFrameFloat = curFrameFloat;
                if (workingCurFrameFloat > sumLength)
                {
                    if (!loop)
                    {
                        finished = true;

                    }

                    workingCurFrameFloat = workingCurFrameFloat % sumLength;
                    curFrameFloat = workingCurFrameFloat;
                }
                if (sumLength > workingCurFrameFloat && workingCurFrameFloat >= animLength&&workingCurFrameFloat !=animLength)
                {
                    finished = true;
                    curFrameFloat = workingCurFrameFloat + delta;
                    return;
                }
                int tempEnd = (int)Mathf.Clamp(curData.StartFrame + (workingCurFrameFloat / particleDelta), curData.StartFrame, curData.EndFrame);

                if (reverse)
                {
                    tempEnd = curData.EndFrame - tempEnd;

                }
                List<XGPUParticlePlayerInfo>.Enumerator allParticleInfos = curData.AllParticleInfos.GetEnumerator();
                while (allParticleInfos.MoveNext())
                {
                    XGPUParticlePlayerInfo cur = allParticleInfos.Current;

            /*
                     * ( currentParticleInfoName->fields.StartFrame <= tempEndFrame && currentParticleInfoName->fields.EndFrame >= tempEndFrame )
                     * 
                     * ((tempEndFrame < currentParticleInfoName->fields.StartFrame) || currentParticleInfoName->fields.EndFrame < tempEndFrame))
                     * 
                     * start: 5
                     * end: 9
                     * tempEnd: 15
                     *

                    if (cur.EndFrame >= tempEnd && cur.StartFrame <= tempEnd)
                    {
                        allParticleInfos.Dispose();
                        if ((skipFrameCount * particleDelta) > curFrameFloat)
                        {
                            if (get_Renderer())
                            {
                                meshRenderer.enabled = false;
                                filterCheck = get_Filter() == false;
                                if(!filterCheck)
                                {
                                    goto label_73;
                                }

                            }


                        }
                        else
                        {
                            if (!cur.UseCompressedData)
                            {
                                if (!(cur.PreBuildMesh != false))
                                {


                                    if (get_Renderer())
                                    {
                                        meshRenderer.enabled = false;
                                        filterCheck = get_Filter() == false;
                                        if (!filterCheck)
                                            goto label_73;
                                    }
                                    //goto label_78;
                                }

                            }


                            meshRenderer.enabled = true;


                            meshRenderer.sharedMaterial = mat;
                            float val = 1 / (cur.EndFrame - cur.StartFrame) / (tempEnd - cur.StartFrame);
                            if (xBlock == null)
                                get_Block();
                            xBlock.SetFloat("_Progress", val);
                            xBlock.SetFloat("_AspectRatio", curData._AspectRatio);
                            xBlock.SetFloat("_ColorIntensity", curData._ColorIntensity);
                            xBlock.SetFloat("_VelocityScale", curData._VelocityScale);
                            meshRenderer.SetPropertyBlock(xBlock);
                        }

                        label_73:
                        if (cur.PreBuildMesh)
                            meshFilter.sharedMesh = cur.PreBuildMesh;
                        else
                            meshFilter.sharedMesh = cur.Mesh;
                        curFrameFloat = delta + curFrameFloat;
                        return;

                        //if(!a)
                    }
                    allParticleInfos.Dispose();
                    finished = true;
                    return;
                }

            }
            */
            bool filterCheck;
            XGPUParticlePlayerInfo cur;
            if (!curData)
                return;
            float workingFrameFloat = curFrameFloat;
            if (sumLength < workingFrameFloat)
            {
                if (!loop)
                {
                    finished = true;
                    //Debug.Log("marking finished");
                    return;
                }
                workingFrameFloat = workingFrameFloat % sumLength;
                curFrameFloat = workingFrameFloat;
            }
            if (workingFrameFloat < sumLength && animLength < workingFrameFloat)
            {
                //Debug.Log("marking finished");
                finished = true;
                curFrameFloat = workingFrameFloat + delta;
                return;
            }
            // Debug.Log("workingFrameFloat: " + workingFrameFloat);
            // Debug.Log("workingFrameFloat / particleDelta: " + workingFrameFloat/particleDelta);
            int tempEnd = (int)Mathf.Clamp((workingFrameFloat / particleDelta) + curData.StartFrame, curData.StartFrame, curData.EndFrame);

            if (reverse)
                tempEnd = curData.EndFrame - tempEnd;
            //  Debug.Log("tempEnd: " + tempEnd);
            List<XGPUParticlePlayerInfo>.Enumerator enumerator = curData.AllParticleInfos.GetEnumerator();
            do
            {
                if (!enumerator.MoveNext())
                {
                    enumerator.Dispose();
                    //Debug.Log("marking finished");
                    finished = true;
                    return;
                }
                cur = enumerator.Current;

            } while (tempEnd < cur.StartFrame || cur.EndFrame < tempEnd);
            enumerator.Dispose();
            if (curFrameFloat < (skipFrameCount * particleDelta))
            {
                meshRenderer.enabled = false;
                filterCheck = get_Filter() == false;
            }
            else
            {
                if (cur.UseCompressedData)
                {
                    //Debug.LogError("Haven't added compressed data support!");
                    DisableGPUParticle();
                    return;
                }
                if (!cur.PreBuildMesh)
                {
                    meshFilter.sharedMesh = null;
                    curFrameFloat = delta + curFrameFloat;
                    return;
                }

            }
            meshRenderer.enabled = true;
            meshRenderer.sharedMaterial = mat;
            xBlock = get_Block();
            float progress;
            if (tempEnd == 0)
                progress = 0;
            else
                progress = (1 / ((float)(cur.EndFrame - cur.StartFrame) / (float)(tempEnd - cur.StartFrame)));
            //Debug.Log(progress);

            meshRenderer.sharedMaterial.SetFloat("_Progress", progress);
            meshRenderer.sharedMaterial.SetFloat("_AspectRatio", curData._AspectRatio);
            meshRenderer.sharedMaterial.SetFloat("_ColorIntensity", curData._ColorIntensity);
            meshRenderer.sharedMaterial.SetFloat("_VelocityScale", curData._VelocityScale);
            meshRenderer.SetPropertyBlock(xBlock);

            meshFilter.sharedMesh = cur.PreBuildMesh;
            curFrameFloat = delta + curFrameFloat;
            return;


        }

        void ResetParticle()
        {
            //Debug.Log("reseting particle");
            selfSpeed = 1;
            startWait = true;
            startWaitCount = 0;
            finished = false;
            if (get_Renderer())
            {
                //Debug.Log("disabling renderer");
                meshRenderer.enabled = false;
                meshRenderer.sharedMaterial = mat;
            }
            if (get_Filter())
            {
                //Debug.Log("assigning null to filter");
                meshFilter.sharedMesh = null;
            }
            curData = GetCurGPUData();
            curFrameFloat = 0f;

            particleDelta = 1f / simulateFramerate;
            startWaitLength = (startWaitTime * 60f) / simulateFramerate;
            loopLength = (loopIntervalTime * 60f) / simulateFramerate;

            sumLength = (curData.EndFrame - curData.StartFrame) * particleDelta + loopLength;
            animLength = (curData.EndFrame - curData.StartFrame) * particleDelta;

        }

        XGPUParticleDataSO GetCurGPUData()
        {
            return data;
        }


        // Update is called once per frame
        void Update()
        {

            DoUpdate();

        }
    }
}