using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.ParticleScripts
{
    [DisallowMultipleComponent]
    public class UVScroller : UVScrollerBase
    {
        MaterialPropertyBlock Block;
        Renderer Renderer;
        private Material material;
        public Material Material
        {
            get
            {
                return material;
            }
            private set
            {
                material = value;
            }
        }
        void SetMaterial()
        {
            if (Renderer)
            {
                if (Renderer.GetType() == typeof(ParticleSystemRenderer))
                {
                    Material = Renderer.sharedMaterial;
                    return;
                }
                if (Renderer.sharedMaterials.Length <= 1)
                {
                    Material = Renderer.sharedMaterial;
                    return;
                }
                else
                    Debug.LogError("Shared Materials count is more than 1!");
            }
        }
        public override Vector4 GetScaleOffset(int propertyID)
        {
            return Material.GetVector(propertyID);
        }

        protected override bool OnInittialize(List<XScroller> scrollers)
        {
            if (!Renderer)
            {
                Renderer = GetComponent<Renderer>();
                if (!Renderer)
                {
                    IgnoreInitialized = true;
                    enabled = false;
                    Debug.LogError("No Renderer!");
                    return false;
                }
            }
            if (Block == null)
            {
                Block = new MaterialPropertyBlock();

            }
            SetMaterial();
            if (!Material)
            {
                Debug.LogError("material is null!");
                return false;
            }
            int i = 0;
            while (true)
            {

                if (i >= scrollers.Count)
                    return true;
                XScroller cur = scrollers[i];
                if (cur == null)
                    return false;
                cur.Recache(cur.TextureName, GetScaleOffset(cur.PropertyId));
                i++;
            }

        }

        protected override void SetScaleOffset(int propertyID, Vector4 scaleOffset)
        {
            if (Block != null)
            {
                Block.SetVector(propertyID, scaleOffset);
                return;
            }

        }
        public bool Reset(Renderer target)
        {
            Renderer = target;
            SetMaterial();
            if (!Material)
                return false;
            if (Scrollers != null)
            {
                for (int i = 0; i < Scrollers.Count; i++)
                {
                    Scrollers[i].Recache(Scrollers[i].TextureName, GetScaleOffset(Scrollers[i].PropertyId));
                }
            }
            return true;
        }
        public MaterialPropertyBlock GetBlock()
        {
            return Block;
        }
        public void Clear()
        {
            Scrollers = null;
            Material = null;
            if (Block != null)
            {
                Block.Clear();
            }
        }

    }
}