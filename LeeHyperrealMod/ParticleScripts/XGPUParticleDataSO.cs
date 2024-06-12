using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.ParticleScripts
{
    public class XGPUParticleDataSO : ScriptableObject
    {
        public float _ColorIntensity;

        public float _VelocityScale;

        public float _AspectRatio;

        public int StartFrame;

        public int EndFrame;

        public List<XGPUParticlePlayerInfo> AllParticleInfos;

        private readonly HashSet<GPUParticlePlayer> BeReferenceSet;

        private bool InitState;

        private string particleName;

        public int ReferenceCount
        {
            get
            {
                return 0;
            }
        }

        public void TryInitialize()
        {
            int x = 0;
            string name;

            if (AllParticleInfos == null) 
            {
                return;
            }

            if (InitState)
                return;
            if (string.IsNullOrEmpty(particleName))
                particleName = this.name;
            List<XGPUParticlePlayerInfo>.Enumerator particleInfoEnum = AllParticleInfos.GetEnumerator();
            while (true)
            {
                if (!particleInfoEnum.MoveNext())
                    break;

                XGPUParticlePlayerInfo cur = particleInfoEnum.Current;
                name = string.Format("{0} {1}", particleName, x);
                cur.Initialize(name);
                x++;

            }
            particleInfoEnum.Dispose();
            InitState = true;
        }

        private void OnEnable()
        {
            if (this)
            {
                TryInitialize();
            }

        }

        public void Destroy()
        {
            InitState = false;
            List<XGPUParticlePlayerInfo>.Enumerator enumerator = AllParticleInfos.GetEnumerator();
            while (true)
            {
                if (!enumerator.MoveNext())
                    break;
                XGPUParticlePlayerInfo cur = enumerator.Current;
                cur.Destroy();
            }
            enumerator.Dispose();
        }

        public void RecaculateBounds()
        {


        }

        public void AddReference(GPUParticlePlayer player)
        {
        }

        public void RemoveReference(GPUParticlePlayer player)
        {
        }
    }
}