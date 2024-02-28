using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.ParticleScripts
{
    public abstract class UVScrollerBase : MonoBehaviour
    {
        protected bool IgnoreInitialized;
        public List<XScroller> Scrollers;
        private bool Started;
        private float TimeScale;
        private bool initialized;
        protected bool Initialized
        {
            get { return initialized; }
            private set { initialized = value; }
        }
        [Serializable]
        public class XScroller
        {
            public Vector2 Speed;
            public string TextureName;
            [NonSerialized]
            public Vector4 ScaleOffset;
            [NonSerialized]
            public Vector4 ScaleOffsetBackup;
            private int PropertyIdCache;
            public int PropertyId
            {
                get
                {
                    if (PropertyIdCache < 0)
                    {

                        PropertyIdCache = Shader.PropertyToID(string.Concat(TextureName, "_ST"));
                    }
                    return PropertyIdCache;
                }

            }

            public XScroller()
            {

                TextureName = "_MainTex";
                PropertyIdCache = -1;
            }

            public void RevertScaleOffset()
            {
                ScaleOffset = ScaleOffsetBackup;
            }

            public void Recache(string textureName, Vector4 backup)
            {
                TextureName = textureName;
                PropertyIdCache = -1;
                ScaleOffsetBackup = backup;
                ScaleOffset = backup;
            }

        }
        // Start is called before the first frame update
        protected UVScrollerBase()
        {
            Scrollers = new List<XScroller>();
            TimeScale = 1;
        }
        void Start()
        {
            Started = true;
            Enable();
        }
        void OnEnable()
        {
            Enable();
        }
        public void ChangeSpeed(float speed)
        {
            TimeScale = Mathf.Max(speed, 0);
        }
        void Enable()
        {
            TimeScale = 1;
            if (Started)
            {
                if (Initialized)
                {
                    List<XScroller>.Enumerator enumer = Scrollers.GetEnumerator();
                    while (enumer.MoveNext())
                    {

                        XScroller cur = enumer.Current;


                        cur.ScaleOffset = cur.ScaleOffsetBackup;
                        SetScaleOffset(cur.PropertyId, cur.ScaleOffset);
                    }
                    enumer.Dispose();
                }
                else if (!IgnoreInitialized)
                {
                    Initialized = OnInittialize(Scrollers);
                }
            }
        }
        // Update is called once per frame
        void Update()
        {
            if (Initialized || !IgnoreInitialized)
            {
                List<XScroller>.Enumerator enumer = Scrollers.GetEnumerator();
                while (enumer.MoveNext())
                {
                    XScroller cur = enumer.Current;
                    Vector2 temp = cur.Speed * Time.deltaTime;
                    temp *= TimeScale;
                    Vector4 temp4;
                    temp4.x = cur.ScaleOffset.x;
                    temp4.y = cur.ScaleOffset.y;
                    temp4.z = cur.ScaleOffset.z + temp.x;
                    temp4.w = cur.ScaleOffset.w + temp.y;
                    cur.ScaleOffset = temp4;
                    SetScaleOffset(cur.PropertyId, cur.ScaleOffset);

                }
                enumer.Dispose();
            }
        }
        void OnDisable()
        {
            if (Initialized)
            {
                List<XScroller>.Enumerator enumer = Scrollers.GetEnumerator();
                while (enumer.MoveNext())
                {
                    XScroller cur = enumer.Current;
                    cur.ScaleOffset = cur.ScaleOffsetBackup;
                    SetScaleOffset(cur.PropertyId, cur.ScaleOffset);
                }
                enumer.Dispose();
            }
        }

        void Initialize()
        {
            if (!IgnoreInitialized)
                Initialized = OnInittialize(Scrollers);
        }

        public abstract Vector4 GetScaleOffset(int propertyID);

        protected abstract void SetScaleOffset(int propertyID, Vector4 scaleOffset);

        protected abstract bool OnInittialize(List<XScroller> scrollers);


        public virtual string Check()
        {
            StringBuilder sb = new StringBuilder();
            Renderer rend = GetComponent<Renderer>();
            int i = 0;
            if (!rend)
                sb.AppendLine("No Renderer!");

            HashSet<int> stuff = new HashSet<int>();
            List<XScroller>.Enumerator enumer = Scrollers.GetEnumerator();
            while (enumer.MoveNext())
            {
                XScroller cur = enumer.Current;
                if (!stuff.Add(cur.PropertyId))
                {
                    sb.AppendLine("UvScroller Conflict: " + cur.TextureName);
                }

            }
            enumer.Dispose();
            if (rend.GetType() != typeof(ParticleSystemRenderer))
            {
                if (rend.sharedMaterials.Length > 1)
                {
                    sb.AppendLine("Material count > 1: " + rend.name);

                }

            }
            List<Material> sharedMats = new List<Material>();
            rend.GetSharedMaterials(sharedMats);
            Material sharedMat = rend.sharedMaterial;
            if (sharedMats.Count > 0)
            {
                HashSet<int>.Enumerator enumer1 = stuff.GetEnumerator();

                while (enumer1.MoveNext())
                {
                    int cur = enumer1.Current;
                    if (!sharedMat)
                        break;
                    if (!sharedMat.HasProperty(cur))
                    {
                        sb.AppendLine("Cannot find property: " + cur);

                    }


                }
                enumer1.Dispose();
            }
            else
            {
                sb.AppendLine("material is null: " + rend.name);
            }


            for (int x = 0; x < Scrollers.Count; x++)
            {
                if (Scrollers[x] == null)
                {
                    sb.Append("scroller is null: " + Scrollers[x]);
                }
            }
            HashSet<string> textureNames = new HashSet<string>();
            while (true)
            {
                if (i >= Scrollers.Count)
                {
                    break;
                }
                if (!textureNames.Add(Scrollers[i].TextureName))
                {
                    string one = "scroller redundancy: " + Scrollers[i].TextureName;
                    string two = "There are two or more UV scrolling options that modify the UVs of the same mapping";
                    sb.AppendLine(string.Concat(one, two));
                }
                i++;
            }
            return sb.ToString();
        }


    }
}