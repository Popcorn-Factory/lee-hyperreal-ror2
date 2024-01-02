using JetBrains.Annotations;
using System;
using System.CodeDom;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Runtime.Remoting.Channels;
using UnityEngine;


public class Tail : MonoBehaviour
{
    private interface IRecycleable
    {
        void OnRecycle();
    }
    private class FrameData : IRecycleable
    {
        public float Time;
        public Fragment Fragment;
        public void Init(float time, Fragment fragment)
        {
            Time = time;
            Fragment = fragment;
        }

        public void OnRecycle()
        {
            Fragment = null;
        }


    }

    private class Fragment : IRecycleable
    {
        public float Time;
        public int Frame;
        public Vector3[] SourceVertices;
        public Vector3[] Vertices;
        public Color[] Colors;
        public Vector3 Center;
        public float Length;
        public void Init(ActionRef<Vector3[]> verticesFilter, int vertexCount, float time, int frame = -1)
        {
            Frame = frame;
            Time = time;
            if(SourceVertices==null)
                SourceVertices = new Vector3[vertexCount];
            if(Vertices==null)
                Vertices = new Vector3[vertexCount];
            if(Colors==null)
                Colors = new Color[vertexCount];
            if (verticesFilter!=null)
            {
                verticesFilter.Invoke(ref SourceVertices);
                int i = 0;
                Center = Vector3.zero;
                while (SourceVertices!=null)
                {
                    
                    if (SourceVertices.Length <= i)
                    {
                        Center = Center / SourceVertices.Length;
                        return;
                    }
                    Center += SourceVertices[i];
                    i++;
                }
            }

        }
        public void OnRecycle()
        {
            return;
        }

    }

    private struct Besier
    {
        public  Vector3 A;
        public  Vector3 B;
        public  Vector3 C;
        public Vector3 D;
        public Besier(Vector3 a, Vector3 b, Vector3 c, Vector3 d)
        {
            A = a; B = b; C = c; D = d;
        }
        public Vector3 Sample(float t)
        {
            Vector3 tmp,tmp2,tmp3,tmp4,tmp5,ret;
            tmp = Vector3.Lerp(A, B, t);
            tmp2 = Vector3.Lerp(C,D, t);
            tmp3 = Vector3.Lerp(B, C, t);

            tmp4 = Vector3.Lerp(tmp, tmp3, t);
            tmp5 = Vector3.Lerp(tmp3, tmp2, t);
            ret = Vector3.Lerp(tmp4,tmp5, t);
            return ret;
        }
    }

    private class BesierGroup : IRecycleable
    {
        public FrameData BeginFrame;
        public FrameData EndFrame;
        public Besier[] Curves;
        public float CurrentSampleT;
        public ActionRef<Vector3[]> VerticesFilter;
        public BesierGroup()
        {
            VerticesFilter = new ActionRef<Vector3[]>(ref FillVertices);
        }

        public void Init(ActionRef<Besier[]> curvesFilter,int curvesCount, FrameData beginFrame, FrameData endFrame)
        {
            if(Curves == null)
            {
                Curves = new Besier[curvesCount];
            }
            curvesFilter.Invoke(ref Curves);
            EndFrame = endFrame;
            BeginFrame = beginFrame;
        }
        public void OnRecycle()
        {
            BeginFrame = null;
            EndFrame = null;
            return;
        }
        public void Sample(ref Fragment fragment, float t)
        {
            CurrentSampleT = t;
            if(BeginFrame != null)
            {
                if(EndFrame != null)
                {
                    float sam = Mathf.Lerp(BeginFrame.Time, EndFrame.Time, t);
                    if (Curves != null && fragment != null)
                    {
                        fragment.Init( VerticesFilter, Curves.Length, sam);
                    }
                }
            }
        }

        private void FillVertices(ref Vector3[] vertices)
        {
            int i = 0;
            while (Curves != null)
            {
                if (Curves.Length <= i)
                {
                    return;
                }
                if (Curves.Length <= i)
                {
                    throw new IndexOutOfRangeException();
                }
                
                if(vertices.Length <= i)
                    throw new IndexOutOfRangeException();
                vertices[i] = Curves[i].Sample(CurrentSampleT);
                i++;
            }
        }
    }
    private enum UvType
    {
        Common,
        Repeat
    }
    private class Pool<T> where T : class, IRecycleable, new()
    {
        private const int MIN_SIZE = 4;
        private static readonly T[] EmptyArray = { };
        private T[] array;
        private int Count;
        public void Recycle(T obj)
        {
            T[] dest;
            if (array == EmptyArray)
                array = new T[MIN_SIZE];
            else
            {
                if (Count == array.Length)
                {
                    T[] tmp = new T[array.Length*2];
                    dest = tmp;
                    Array.Copy(array, dest, array.Length + 1);
                    array = dest;
                }
                    

            }
            if (array != null)
            {
                if(array.Length <= Count)
                {
                    throw new IndexOutOfRangeException();
                }
                array[Count] = obj;
                
                    Count++;
                
            }
        }
        public T Get()
        {
            if (Count == 0)
            {
                
                return null;
            }
               
            else 
            {
                if(Count-1 < array.Length)
                {
                    T tmp = array[Count - 1];
                    array[Count - 1] = null;
                    Count--;
                    return tmp;
                }
                throw new IndexOutOfRangeException();
               
            }
            
        }

        public void Clear()
        {
            int i = 0;
            if (0 < Count)
            {
                do
                {
                    if (array.Length <= i)
                        throw new IndexOutOfRangeException();
                    array[i] = null;

                } while (i+1 < Count);
            }
            Count = 0;
        }
        public Pool()
        {

            array = new T[MIN_SIZE];

        }
    }
    public bool Emit;
    public float Lifetime;
    [Range(1, 10)]
    public float MinSmoothness;
    [Range(5,30)]
    public float MaxSmoothness;
    [Range(0.05f, 1)]
    public float IntervalSmoothness;
    public Transform[] Shape;
    public AnimationCurve SizeOverLifeTime;
    public Gradient ColorOverLifeTime;
    UvType uvType;
    public float UvRepeatLength;
    bool EmitCached;
    int Frame;
    Mesh Mesh;
    readonly CircularBuffer<Fragment> Fragments;
    readonly CircularBuffer<FrameData> FrameDatas;
     List<Vector3> Vertices;
     List<int> Triangles;
     List<Vector2> UvsCommon;
     List<Vector2> UvsRepeat;
     List<Color> Colors;
    readonly Pool<Fragment> FragmentPool;
    readonly Pool<FrameData> FrameDataPool;
    readonly Pool<BesierGroup> BesierGroupPool;
    float MinSmoothnessDotValue;
    float MaxSmoothnessDotValue;
    ActionRef<Besier[]> HeadFilter;
    ActionRef<Besier[]> BodyFilter;
    ActionRef<Besier[]> TailFilter;
    ActionRef<Vector3[]> VerticesFilter;
    bool Moved;
    Vector3 LastPosition;
    Quaternion LastRotation;
    void Start()
    {
        Mesh = new Mesh();
        Mesh.name = "Tail(Temp)";
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = Mesh;
        if(!CheckParams())
            this.enabled = false;
        float maxSmooth = MaxSmoothness * 0.017453292f;
        float minSmooth = MinSmoothness * 0.017453292f;
        Vector3 tmp = new Vector3(Mathf.Cos(minSmooth), Mathf.Sin(minSmooth),0);
        MinSmoothnessDotValue = Vector3.Dot(Vector3.right, tmp);
        tmp = new Vector3(Mathf.Cos(maxSmooth), Mathf.Sin(maxSmooth), 0);
        MaxSmoothnessDotValue = Vector3.Dot(Vector3.right, tmp);
        HeadFilter =new ActionRef<Besier[]>(ref FillHeadCurve);
        BodyFilter = new ActionRef<Besier[]>(ref FillBodyCurve);
        TailFilter = new ActionRef<Besier[]>(ref FillTailCurve);
        VerticesFilter = new ActionRef<Vector3[]>(ref FillVertices);
    }
    delegate void ActionRef<T>(ref T Item);
    void LateUpdate()
    {
        UpdateBasicState();
        UpdateFrameData();
        UpdateFragments();
        UpdateMesh();
        if (Moved)
        {
            Frame++;
        }
    }

    void OnDrawGizmos()
    {
        if((!Application.isPlaying)&& Shape != null && 1 < Shape.Length)
        {
            int i = 0;
            do
            {
                if (Shape.Length <= i)
                    return;
                if (Shape == null) break;
                
                int tmp = i+1 % Shape.Length;
                if(Shape.Length <= tmp)
                {
                    throw new IndexOutOfRangeException();
                }
                bool a = Shape[i] == null;
                if (!a)
                {
                    Vector3 pos = Shape[i].position;
                    Vector3 pos2 = Shape[tmp].position;
                    Gizmos.DrawLine(pos, pos2);
                }
                i++;
            } while (Shape!=null);

        }
    }

    void OnDisable()
    {
        Clear();
    }

    void OnDestroy()
    {
        Clear();
    }

    void Clear()
    {
        Frame = -1;
        EmitCached = false;
        LastRotation = Quaternion.identity;
        LastPosition = Vector3.zero;
        if (FrameDatas != null)
        {
            FrameDatas.Clear();
            if(Fragments != null)
            {
                Fragments.Clear();
                if(Vertices != null)
                {
                    Vertices.Clear();
                    if(Triangles != null)
                    {
                        Triangles.Clear();
                        if(UvsCommon != null)
                        {
                            UvsCommon.Clear();
                            if(UvsRepeat != null)
                            {
                                UvsRepeat.Clear();
                                if(Colors != null)
                                {
                                    Colors.Clear();
                                    if(FragmentPool != null)
                                    {
                                        FragmentPool.Clear();
                                        if(BesierGroupPool != null)
                                        {
                                            BesierGroupPool.Clear();
                                            if(FrameDataPool != null)
                                            {
                                                FrameDataPool.Clear();
                                                return;
                                            }
                                        }
                                    }
                                        

                                }
                            }
                        }
                    }
                }
            }
        }
    }

    bool CheckParams()
    {
        if(Lifetime <= 0)
        {
            Debug.LogError("XTail.CheckParams : Life time <= 0");
            return false;
        }
        if (Shape != null)
        {
            if(Shape.Length < 2)
            {
                Debug.LogError("XTail.CheckParams : Shape's length < 2");
                return false;
            }

            return true;
        }
        return false;
    }

    void UpdateBasicState()
    {
        if (Emit != EmitCached)
        {
            EmitCached = Emit;
            if (!Emit)
                Frame = -1;
            else
            {
                Frame = 0;
                if(Fragments==null)
                    throw new NullReferenceException();
                Fragments.Clear();
                if (FrameDatas == null)
                    throw new NullReferenceException();
                FrameDatas.Clear();
            }
        }
        bool posCheck = transform.position != LastPosition;
        if (!posCheck)
        {
            posCheck = transform.rotation != LastRotation;

        }
        Moved = posCheck;
        LastPosition = transform.position;
        LastRotation = transform.rotation;

    }

    void UpdateFrameData()
    {
        if (Emit)
        {
            while (FrameDatas.Count > 4)
            {
                FrameData frameData = FrameDatas.GetHead();
                if (FrameDatas != null)
                {

                    
                    FrameDatas.RemoveHead();

                    if (FrameDataPool != null)
                    {
                        FrameDataPool.Recycle(frameData);
                    }
                    if (FrameDatas != null)
                        continue;
                }
            }
            if (Moved)
            {
                if (FragmentPool!=null)
                {
                    if (FrameDataPool != null)
                    {
                        if (Shape != null)
                        {
                            if(FragmentPool.Get() != null)
                            {
                                FragmentPool.Get().Init(VerticesFilter, Shape.Length, Time.time, Frame);
                                if(FrameDataPool != null)
                                {
                                    FrameDataPool.Get().Init(Time.time, FragmentPool.Get());
                                    if(FrameDatas != null)
                                    {
                                        FrameDatas.Put(FrameDataPool.Get());
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    void UpdateFragments()
    {
        if(Frame > 2)
        {
            if (Fragments != null)
            {
                while (Fragments.Count > 0)
                {
                    Fragment head = Fragments.GetHead();
                    
                    if (head != null)
                    {
                        if(Time.time - head.Time <= Lifetime)
                        {
                            break;
                        }
                        if (Fragments != null)
                        {
                            Fragments.RemoveHead();
                            if (FragmentPool != null)
                            {
                                FragmentPool.Recycle(head);
                                if (Fragments != null)
                                    continue;
                            }
                        }
                    }
                }
            }
        }
        if(Emit && Moved)
        {
            ReBuildLastFrameFragment();
            AppendCurrentFrameFragments();
        }
        UpdateFragmentsVertexData();
    }

    void UpdateFragmentsVertexData()
    {
        if(Fragments != null)
        {
            IEnumerator<Fragment> fragmentsEnumerator = Fragments.GetEnumerator();
            while (fragmentsEnumerator.MoveNext())
            {
                Fragment fragment = fragmentsEnumerator.Current;
                if( fragment != null )
                {

                    if (Lifetime <= 0)
                        Lifetime = 0.0099999998f;
                    float tmpTime = (Time.time - fragment.Time) / Lifetime;
                    float tmpSize = SizeOverLifeTime.Evaluate(tmpTime);
                    Color tmpColor = ColorOverLifeTime.Evaluate(tmpTime);
                    Fragment prev = null;
                    for(int i = 0; ; i++)
                    {
                        if (i >= Shape.Length)
                            break;
                        if (i >= fragment.Colors.Length)
                        {
                            throw new IndexOutOfRangeException();
                        }
                        fragment.Colors[i] = tmpColor;
                        if(i>=fragment.SourceVertices.Length)
                            throw new IndexOutOfRangeException();
                        Vector3 tmpV3 = Vector3.Lerp(fragment.Center, fragment.SourceVertices[i], tmpSize);
                        if (i >= fragment.Vertices.Length)
                            throw new IndexOutOfRangeException();
                        fragment.Vertices[i] = tmpV3;
                        if(prev != null)
                        {
                            fragment.Length = Vector3.Distance(fragment.Center, prev.Center);
                        }

                    }
                    prev = fragment;
                }
            }
            fragmentsEnumerator.Dispose();
        }
    }

    void ReBuildLastFrameFragment()
    {
        if (Fragments.Count < 2)
            return;
        FrameData startFrame;
        FrameData endFrame;
        ActionRef<Besier[]> headFilter;
        BesierGroup besierGroup;
        if (Fragments != null)
        {
            Fragment tail1 = Fragments.GetTail();
            while (Fragments.Count > 0)
            {
                if (Fragments!=null)
                {
                    Fragment tail = Fragments.GetTail();
                    if(tail != null)
                    {
                        if (tail.Time + 1 == Frame - 2)
                            break;
                        Fragments.RemoveTail();
                        if(tail!= tail1)
                        {
                            FragmentPool.Recycle(tail);

                        }
                        if (Fragments != null)
                            continue;
                    }
                }
            }
            if (Frame == 2)
            {
                if (FrameDatas != null)
                {
                    FrameData item = FrameDatas.Get(0);
                    FrameData item2 = FrameDatas.Get(1);
                    startFrame = item;
                    endFrame = item2;
                    if (BesierGroupPool != null)
                    {
                        besierGroup = BesierGroupPool.Get();
                        if (Shape != null)
                        {
                            if (besierGroup != null)
                            {
                                headFilter = HeadFilter;
                                goto Label_32;
                            }
                    }
                    }
                    
                }
            }
            int count = FrameDatas.Count;
            FrameData frameData = FrameDatas.Get(count - 3);

            FrameData frameData2 = FrameDatas.Get(count - 2);
            startFrame = frameData;
            endFrame = frameData2;
            besierGroup = BesierGroupPool.Get();
            headFilter = BodyFilter;
        Label_32:
            besierGroup.Init(headFilter, Shape.Length, startFrame, endFrame);
            SmoothRecursively( startFrame.Fragment,  endFrame.Fragment, ref besierGroup);
            BesierGroupPool.Recycle(besierGroup);
            Fragments.Put(tail1);


        }
    }

    void FillVertices(ref Vector3[] vertices)
    {
        int i = 0;
        while (0 < Shape.Length)
        {
            if (Shape != null)
            {
                if(i >= Shape.Length)
                {
                    throw new IndexOutOfRangeException();
                }
                Transform tmp = Shape[i];
                if (tmp)
                {
                    Vector3 pos = tmp.position;
                    if (vertices!=null)
                    {
                        if(i>=vertices.Length)
                            throw new IndexOutOfRangeException();
                        vertices[i] = pos;
                        i++;
                        if (Shape != null)
                            continue;
                    }
                }
            }
        }
    }

    void RemoveOverTimeFragments()
    {
        if (Frame <= 2)
            return;
        while (Fragments.Count > 0)
        {
            float time = Time.time;
            if (Fragments != null)
            {
                Fragment Head = Fragments.GetHead();
                if(Head != null)
                {
                    if((time - Head.Time) <= Lifetime)
                    {
                        return;
                    }
                    if(Fragments!= null)
                    {
                        Fragments.RemoveHead();
                        if(FragmentPool != null)
                        {
                            FragmentPool.Recycle(Head);
                            continue;
                        }
                    }
                }
            }
        }
    }

    void AppendCurrentFrameFragments()
    {
        int count;
        BesierGroup besierGroup;
        FrameData beginFrame;
        FrameData endFrame;
        FrameData tail;
        if (Frame >= 2)
        {
            if(FrameDatas==null)
                throw new NullReferenceException();
            count = FrameDatas.Count;
            beginFrame = FrameDatas.Get(count - 2);
            endFrame = FrameDatas.Get(count - 1);
            besierGroup = BesierGroupPool.Get();
            besierGroup.Init(TailFilter, Shape.Length, beginFrame, endFrame);
            SmoothRecursively(beginFrame.Fragment, endFrame.Fragment,ref besierGroup);
            BesierGroupPool.Recycle(besierGroup);
        }
        if (FrameDatas != null)
        {
            tail = FrameDatas.GetTail();
            if (tail != null)
            {
                if (Fragments != null)
                {
                    Fragments.Put(tail.Fragment);
                    return;
                }
            }
        }
    }

    void UpdateMesh()
    {
        Fragment tail;
        Fragment head;
        
        Mesh.Clear();
        if (Fragments.Count < 2)
            return;
        RefreshVertices();
        RefreshTriangles();
        tail = Fragments.GetTail();
        head = Fragments.GetHead();
        float diff = tail.Length - head.Length;
        int check;
        if (uvType == UvType.Repeat)
        {
            if (uvType != UvType.Repeat)
                goto label_21;
            RefreshUv(UvRepeatLength,ref UvsRepeat, 0);
            check = 1;
        }
        else
        {
            check = 0;
        }
            
        
        RefreshUv(diff,ref UvsCommon, check);
        label_21:
        RefreshColors();
    }

    void RefreshVertices()
    {
        Fragment item;
        if(Vertices != null)
        {
            Vertices.Clear();
            int i = 0;
            if(Fragments != null)
            {
                while(i < Fragments.Count)
                {
                    for (int j = 0; ; j++)
                    {
                        if (j >= Shape.Length)
                            break;
                        item = Fragments.Get(i);
                        if (item == null)
                            throw new NullReferenceException();
                        if(j>=Vertices.Count)
                            throw new IndexOutOfRangeException();
                        Vector3 tmp = transform.InverseTransformPoint(Vertices[j]);
                        Vertices.Add(tmp);

                    }
                    i++;

                }
                if(Mesh)
                    Mesh.SetVertices(Vertices);
            }
        }
    }

    void RefreshTriangles()
    {
        if (Triangles != null)
        {
            int i = 0;
            int length = Shape.Length;
            int v11;
            int v12;
            int v24;

            int l2 = length;
            int m_value;
            int v14;
            int v16;
            
            Triangles.Clear();
            if(Shape != null)
            {
                if (Fragments != null)
                {
                    v11 = length + 1;
                    v24 = length + 1;
                    v12 = length;
                    while (i < Fragments.Count - 1)
                    {
                        if (length - 1 > 0)
                        {
                            m_value = v11;
                            v14 = -length - 1;

                            do
                            {
                                v16 = v14 + m_value;
                                Triangles.Add(v14 + m_value);
                                Triangles.Add(m_value - 1);
                                Triangles.Add(m_value);
                                Triangles.Add(v16);
                                Triangles.Add(m_value);
                                Triangles.Add(m_value - length);
                                m_value++;
                                v14 = -length - 1;
                            } while (v12 + m_value < length - 1);
                            v11 = v24;
                        }
                        i++;
                        v11 += length;
                        v12 -= length;
                        v24 = v11;
                        
                    }
                    if (Mesh)
                        Mesh.SetTriangles(Triangles,0);
                }
            }
        }
    }

    void RefreshUvs()
    {
        Fragment tail;
        Fragment head;
        float leng;
        tail = Fragments.GetTail();
        head = Fragments.GetHead();
        leng = tail.Length - head.Length;
        if (uvType == UvType.Common)
        {
            RefreshUv(leng,ref UvsCommon,  0);
            return;
        }
        if (uvType == UvType.Repeat)
        {
            RefreshUv(UvRepeatLength,ref UvsRepeat, 0);
            RefreshUv(leng,ref  UvsCommon, 1);
        }
    }

    void RefreshUv(float repeatLength,ref List<Vector2> list, int chanel, int chanel2 = -1)
    {
        list.Clear();
        int i = 0;
        int j = 0;
        Vector2 tmp = new Vector2();
        Vector2 tmp2 = new Vector2();
        while (i < Fragments.Count)
        {
            j = 0;
            while (true)
            {
                if (Shape.Length <= j) break;
                if (Fragments == null || Fragments.GetTail() == null)
                {
                    throw new NullReferenceException();
                }
                if (Fragments == null || Fragments.Get(i) == null || Shape == null)
                {
                    throw new NullReferenceException();
                }
                tmp = new Vector2((Fragments.GetTail().Length-Fragments.Get(i).Length)/repeatLength,j/(Shape.Length-1));
                list.Add(tmp);
                j++;
            }
            i++;
        }
        if (Mesh)
        {
            tmp2 = new Vector2(chanel,0);
            Mesh.SetUVs(chanel, list);
            if (chanel2 < 1)
                return;
            Mesh.SetUVs(chanel, list);
        }
    }

    void RefreshColors()
    {
        int i = 0;
        int j = 0;
        Fragment item;
        Color color;
        if (Colors != null)
        {
            Colors.Clear();
            if(Fragments != null)
            {
                j = 0;
                while(i < Fragments.Count)
                {
                    while (true)
                    {
                        if(Shape.Length <= j) break;
                        item = Fragments.Get(i);
                        if (Fragments == null || item == null || Colors == null)
                            throw new NullReferenceException();
                        if(Colors.Count <= j)
                        {
                            throw new IndexOutOfRangeException(j.ToString());

                        }
                        color = Colors[j];
                        Colors.Add(color);
                        j++;
                    }
                    i++;
                    
                }
                if (Mesh)
                {
                    Mesh.SetColors(Colors);
                }
            }
        }
    }

    void SmoothRecursively( Fragment a,  Fragment b,ref BesierGroup besizer, float beginT = 0f, float endT = 1f, int smoothTimes = 0)
    {
        float p2;
        Fragment fragment;
        float tmp;
        do
        {
            p2 = (beginT + endT) * .5f;
            fragment = FragmentPool.Get();
            if(FragmentPool==null||fragment==null||besizer==null)
                throw new NullReferenceException();
            besizer.CurrentSampleT = p2;
            if (besizer.BeginFrame == null)
                throw new NullReferenceException();
            tmp = Mathf.Lerp(besizer.BeginFrame.Time,besizer.EndFrame.Time,p2);
            if (besizer.Curves == null || fragment == null)
                throw new NullReferenceException();
            fragment.Init(besizer.VerticesFilter, besizer.Curves.Length, tmp);
            if(!NeedSmooth( a, b, fragment, smoothTimes))
            {
                FragmentPool.Recycle(fragment);
                return;
            }
            SmoothRecursively( a,  b, ref besizer, beginT, p2, smoothTimes + 1);
            Fragments.Put(fragment);
            smoothTimes++;
            beginT = p2;

        } while (true);
    }

    bool NeedSmooth( Fragment a, Fragment b, Fragment insert, int smoothTimes)
    {
        Vector3 tmp;
        Vector3 tmp2;
        float tmp3;
        if (smoothTimes >= 5)
            return false;
        if(a.Center==b.Center)
            return false;
        if((IntervalSmoothness * 0.5f) > Vector3.Distance(a.Center,b.Center))
            return false;
        tmp = a.Center - insert.Center;
        tmp.Normalize();
        tmp2 = b.Center - insert.Center;
        tmp2.Normalize();
        tmp3 = -Vector3.Dot(tmp, tmp2);
        if(tmp3 > MinSmoothnessDotValue)
            return false;
        if (MaxSmoothnessDotValue > tmp3)
            return true;
        tmp3 = Vector3.Distance(a.Center, b.Center);
        return tmp3 > IntervalSmoothness;
    }

    void FillBodyCurve(ref Besier[] curves)
    {
        int i = 0;
        int count;
        FrameData item,item2,item3,item4;
        Fragment fragment,fragment2,fragment3,fragment4;
        Vector3 vertice,vertice2,vertice3,vertice4;
        Vector3 tmp, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11, tmp12, tmp13, tmp14;
        float ftmp,ftmp2;
        while (i < Shape.Length)
        {
            if (FrameDatas != null)
            {
                count = FrameDatas.Count;
                item = FrameDatas.Get(count - 4);
                if (item != null)
                {
                    fragment = item.Fragment;
                    if (fragment == null || fragment.SourceVertices == null) break;
                    
                        if(fragment.SourceVertices.Length <= i)
                        {
                            throw new IndexOutOfRangeException();

                        }
                        vertice = fragment.SourceVertices[i];
                        item2 = FrameDatas.Get(count - 3);

                        if (item2 != null)
                        {
                            fragment2 = item2.Fragment;
                            if (fragment2 == null || fragment2.SourceVertices == null) break;
                            
                            if(fragment2.SourceVertices.Length <= i)
                                throw new IndexOutOfRangeException();
                            vertice2 = fragment2.SourceVertices[i];
                            item3 = FrameDatas.Get(count - 2);
                            if(item3!= null)
                        {
                            fragment3 = item3.Fragment;
                            if (fragment3 == null || fragment3.SourceVertices == null) break;
                            if(fragment3.SourceVertices.Length <= i)
                                throw new IndexOutOfRangeException();
                            vertice3 = fragment3.SourceVertices[i];
                            item4 = FrameDatas.Get(count - 1);
                            if (item4 != null)
                            {
                                fragment4 = item4.Fragment;
                                if (fragment4 == null || fragment4.SourceVertices == null) break;
                                if(fragment4.SourceVertices.Length <= i)
                                    throw new IndexOutOfRangeException();
                                vertice4 = fragment4.SourceVertices[i];
                                tmp = vertice3 - vertice2;
                                tmp.Normalize();
                                tmp2 = vertice3 - vertice;
                                tmp2.Normalize();
                                tmp3 = vertice3 - vertice2;
                                tmp3.Normalize();
                                tmp4 = vertice2 - vertice;
                                tmp4.Normalize();
                                ftmp = Vector3.Dot(tmp3, tmp2);
                                tmp5 = Vector3.Lerp(tmp, tmp4, ftmp);
                                tmp6 = tmp2 * tmp5.x;
                                tmp6 *= 0.40000001f;
                                tmp7 = vertice2 + tmp6;
                                tmp8 = vertice2 - vertice4;
                                tmp8.Normalize();
                                tmp9 = vertice3 - vertice4;
                                tmp9.Normalize();
                                tmp10 = -tmp3;
                                ftmp2 = Vector3.Dot(tmp8, tmp10);
                                tmp11 = Vector3.Lerp(tmp, tmp9, ftmp2);
                                tmp12 = tmp8 * tmp11.x;
                                tmp13 = tmp12 * 0.4f;
                                tmp14 = vertice3 + tmp13;
                                if (curves == null) break;
                                if(curves.Length <=i)
                                    throw new IndexOutOfRangeException();
                                curves[i].A = vertice2;
                                curves[i].B = tmp7;
                                curves[i].C = tmp14;
                                curves[i].D = vertice3;
                                i++;
                                if(Shape==null) break;
                            }
                        }
                        }
                        
                    

                }
            }
        }
    }

    void FillHeadCurve(ref Besier[] curves)
    {
        Vector3 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11, tmp12, tmp13, tmp14, tmp15, tmp16;
        Fragment fragment1,fragment2,fragment3;
        FrameData item1,item2,item3;
        Vector3 vertice1, vertice2, vertice3;
        float ftmp1, ftmp2,ftmp3,ftmp4;
        float lerp1;
        int i = 0;
        if (Shape != null)
        {
            while (true)
            {
                if (Shape.Length <= i)
                    return;
                if(FrameDatas == null) break;
                item1 = FrameDatas.Get(0);
                if (item1 != null)
                {
                    fragment1 = item1.Fragment;
                    if (fragment1 == null || fragment1.SourceVertices == null) break;

                    if (fragment1.SourceVertices.Length <= i)
                    {
                        throw new IndexOutOfRangeException();

                    }
                    vertice1 = fragment1.SourceVertices[i]; //pcVar3
                    item2 = FrameDatas.Get(1);
                    if (item2 != null)
                    {
                        fragment2 = item2.Fragment;
                        if (fragment2 == null || fragment2.SourceVertices == null) break;
                        if(fragment2.SourceVertices.Length <= i)
                            throw new IndexOutOfRangeException();
                        vertice2 = fragment2.SourceVertices[i]; //pIVar4
                        item3 = FrameDatas.Get(2);
                        if(item3 != null)
                        {
                            fragment3 = item3.Fragment;
                            if (fragment3 == null || fragment3.SourceVertices == null) break;
                            if(fragment3.SourceVertices.Length <= i)
                                throw new IndexOutOfRangeException();
                            vertice3 = fragment3.SourceVertices[i]; //uvar1
                            tmp1 = vertice3 - vertice2;
                            tmp1.Normalize();
                            tmp2 = vertice3 - vertice1;
                            tmp2.Normalize();
                            tmp3 = vertice3 - vertice2;
                            tmp3.Normalize();
                            tmp4 = vertice2 - vertice1;
                            tmp4.Normalize();
                            ftmp1 = Vector3.Dot(tmp2, tmp3);
                            lerp1 = Mathf.Lerp(tmp1.x, tmp4.x, ftmp1);
                            tmp5 = tmp2 * lerp1;
                            tmp5 *= 0.4f;
                            tmp6 = vertice2 - tmp5;
                            tmp7 = vertice1 - vertice2;
                            tmp7.Normalize();
                            tmp8 = -tmp2;
                            tmp9 = Vector3.Cross(tmp8, tmp7);
                            tmp9.Normalize();
                            tmp10 = Vector3.Cross(tmp9, tmp7);
                            tmp10.Normalize();
                            ftmp2 = Vector3.Dot(tmp5, tmp10);
                            ftmp3 = Vector3.Dot(tmp5, tmp9);
                            ftmp4 = Vector3.Dot(tmp5, tmp7);
                            tmp11 = ftmp2 * tmp10;
                            tmp12 = ftmp3 * tmp9;
                            tmp13 = tmp11 + tmp12;
                            tmp14 = (ftmp4 * -1) * tmp7;
                            tmp15 = tmp13 + tmp14;
                            tmp16 = vertice1 - tmp15;
                            if (curves == null) break;
                            if(curves.Length <= i)
                                throw new IndexOutOfRangeException();
                            curves[i].A = vertice1;
                            curves[i].B = tmp16;
                            curves[i].C = tmp6;
                            curves[i].D = vertice2;
                            i++;
                            if(Shape==null) break;
                        }
                    }
                }
            }
        }
    }

    void FillTailCurve(ref Besier[] curves)
    {
        Vector3 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11, tmp12, tmp13, tmp14, tmp15, tmp16,tmp17;
        Fragment fragment1, fragment2, fragment3;
        FrameData item1, item2, item3;
        Vector3 vertice1, vertice2, vertice3;
        float ftmp1, ftmp2, ftmp3, ftmp4;
        float lerp1;
        int count;
        int i = 0;
        if (Shape != null)
        {
            while (true)
            {
                if (Shape.Length <= i)
                    return;
                count = FrameDatas.Count;
                item1 = FrameDatas.Get(count - 3);
                if(item1 == null) break;
                fragment1 = item1.Fragment;
                if (fragment1 == null || fragment1.SourceVertices == null) break;
                if (fragment1.SourceVertices.Length <= i)
                    throw new IndexOutOfRangeException();
                vertice1 = fragment1.SourceVertices[i]; //pIVar3
                item2 = FrameDatas.Get(count - 2);
                if (item2 == null) break;
                fragment2 = item2.Fragment;
                if (fragment2 == null || fragment2.SourceVertices == null) break;
                if(fragment2.SourceVertices.Length <= i)
                    throw new IndexOutOfRangeException();
                vertice2 = fragment2.SourceVertices[i]; //uVar4
                item3 = FrameDatas.Get(count - 1);
                if( item3 == null) break;
                fragment3 = item3.Fragment;
                if (fragment3 == null || fragment3.SourceVertices == null) break;
                if( fragment3.SourceVertices.Length <= i)
                    throw new IndexOutOfRangeException();
                vertice3 = fragment3.SourceVertices[i]; //pcVar5
                tmp1 = vertice2 - vertice1;
                tmp1.Normalize();
                tmp2 = vertice2 - vertice1;
                tmp2.Normalize();
                tmp3 = vertice1 - vertice3;
                tmp3.Normalize();
                tmp4 = vertice2 - vertice3;
                tmp4.Normalize();
                tmp5 = -tmp2;
                ftmp1 = Vector3.Dot(tmp3, tmp5);
                lerp1 = Mathf.Lerp(tmp1.x,tmp4.x,ftmp1);
                tmp6 = tmp3 * lerp1;
                tmp6 *= 0.4f;
                tmp7 = vertice2 - tmp6;
                tmp8 = vertice3 - vertice2;
                tmp8.Normalize();
                tmp9 = -tmp3;
                tmp10 = Vector3.Cross(tmp9, tmp8);
                tmp10.Normalize();
                tmp11 = Vector3.Cross(tmp10, tmp8);
                tmp11.Normalize();
                ftmp2 = Vector3.Dot(tmp6, tmp11);
                ftmp3 = Vector3.Dot(tmp6, tmp10);
                ftmp4 = Vector3.Dot(tmp6, tmp8);
                tmp12 = ftmp2 * tmp11;
                tmp13 = ftmp3 * tmp10;
                tmp14 = tmp12 + tmp13;
                tmp15 = (ftmp4 * -1) * tmp8;
                tmp16 = tmp14 + tmp15;
                tmp17 = vertice3 - tmp16;
                if (curves == null) break;
                if (curves.Length <= i)
                    throw new IndexOutOfRangeException();
                curves[i].A = vertice2;
                curves[i].B = tmp7;
                curves[i].C = tmp17;
                curves[i].D = vertice3;
            }
        }
    }

    public Tail()
    {
        Lifetime = 1;
        IntervalSmoothness = 0.1f;
        Fragments = new CircularBuffer<Fragment>();
        FrameDatas = new CircularBuffer<FrameData>();
        Vertices = new List<Vector3>();
        Triangles = new List<int>();
        UvsCommon = new List<Vector2>();
        UvsRepeat = new List<Vector2>();
        Colors = new List<Color>();
        FragmentPool = new Pool<Fragment>();
        FrameDataPool = new Pool<FrameData>();
        BesierGroupPool = new Pool<BesierGroup>();
    }
}


#region License
/* Copyright 2015 Joe Osborne
 * 
 * This file is part of RingBuffer.
 *
 *  RingBuffer is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  RingBuffer is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with RingBuffer. If not, see <http://www.gnu.org/licenses/>.
 */
#endregion



    /// <summary>
    /// A generic ring buffer with fixed capacity.
    /// </summary>
    /// <typeparam name="T">The type of data stored in the buffer</typeparam>
    [Serializable]
    public class CircularBuffer<T> : IEnumerable<T>, IEnumerable, ICollection<T>, ICollection
    {

    public int head = 0;
    
        public int tail = 0;
        protected int size = 0;
    int originalCap;
  

        protected T[] buffer;

        private bool allowOverflow;
        public bool AllowOverflow { get { return allowOverflow; } }

        /// <summary>
        /// The total number of elements the buffer can store (grows).
        /// </summary>
        public int Capacity { get { return buffer.Length; } }

        /// <summary>
        /// The number of elements currently contained in the buffer.
        /// </summary>
        public int Size { get { return size; } }

        /// <summary>
        /// Retrieve the next item from the buffer.
        /// </summary>
        /// <returns>The oldest item added to the buffer.</returns>
        public T Get()
        {
            if (size == 0) throw new System.InvalidOperationException("Buffer is empty.");
            T _item = buffer[head];
            head = (head + 1) % Capacity;
            size--;
            return _item;
        }
    /// <summary>
    /// Retrieve the first item from the buffer.
    /// </summary>
    /// <param name="index"></param>
    /// <returns></returns>
    /// <exception cref="System.InvalidOperationException"></exception>
    public T Get(int index)
    {
        if (index < Count)
            return buffer[index];
        else
            throw new IndexOutOfRangeException();
    }
    public T GetHead()
    {
        return buffer[head];
    }
    public T GetTail()
    {
        return buffer[tail];
    }


        /// <summary>
        /// Adds an item to the end of the buffer.
        /// </summary>
        /// <param name="item">The item to be added.</param>
        public void Put(T item)
        {
        // If tail & head are equal and the buffer is not empty, assume
        // that it will overflow and throw an exception.
        if (tail == head && size != 0)
        {
            T[] _newArray = new T[buffer.Length + Capacity];
            for (int i = 0; i < Capacity; i++)
            {
                _newArray[i] = buffer[i];
            }
            buffer = _newArray;
            tail = (head + size) % Capacity;
            addToBuffer(item, false);
        }
        // If the buffer would not overflow, just add the item.
        else
        {
            addToBuffer(item, false);
        }
    }

        protected void addToBuffer(T toAdd, bool overflow)
        {
            if (overflow)
            {
                head = (head + 1) % Capacity;
            }
            else
            {
                size++;
            }
            buffer[tail] = toAdd;
            tail = (tail + 1) % Capacity;
        }

        #region Constructors
        // Default capacity is 4, default overflow behavior is false.
        public CircularBuffer() : this(4) { }

    public CircularBuffer(int capacity)
    {
        buffer = new T[capacity];
        originalCap = Capacity;
    }

        
        #endregion

        #region IEnumerable Members
        public IEnumerator<T> GetEnumerator()
        {
            int _index = head;
            for (int i = 0; i < size; i++, _index = (_index + 1) % Capacity)
            {
                yield return buffer[_index];
            }
        }

        IEnumerator<T> IEnumerable<T>.GetEnumerator()
        {
            return GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return (IEnumerator)GetEnumerator();
        }
        #endregion

        #region ICollection<T> Members
        public int Count { get { return size; } }
        public bool IsReadOnly { get { return false; } }

        public void Add(T item)
        {
            Put(item);
        }

        /// <summary>
        /// Determines whether the RingBuffer contains a specific value.
        /// </summary>
        /// <param name="item">The value to check the RingBuffer for.</param>
        /// <returns>True if the RingBuffer contains <paramref name="item"/>
        /// , false if it does not.
        /// </returns>
        public bool Contains(T item)
        {
            EqualityComparer<T> comparer = EqualityComparer<T>.Default;
            int _index = head;
            for (int i = 0; i < size; i++, _index = (_index + 1) % Capacity)
            {
                if (comparer.Equals(item, buffer[_index])) return true;
            }
            return false;
        }

        /// <summary>
        /// Removes all items from the RingBuffer.
        /// </summary>
        public void Clear()
        {
        if (head < tail)
            tail = Count;
        else
        {
            Array.Clear(buffer, head, buffer.Length-head);

        }
        Array.Clear(buffer, head, tail);
        head = 0;
        size = 0;
        }
   

        /// <summary>
        /// Copies the contents of the RingBuffer to <paramref name="array"/>
        /// starting at <paramref name="arrayIndex"/>.
        /// </summary>
        /// <param name="array">The array to be copied to.</param>
        /// <param name="arrayIndex">The index of <paramref name="array"/>
        /// where the buffer should begin copying to.</param>
        public void CopyTo(T[] array, int arrayIndex)
        {
            int _index = head;
            for (int i = 0; i < size; i++, arrayIndex++, _index = (_index + 1) %
                Capacity)
            {
                array[arrayIndex] = buffer[_index];
            }
        }

        /// <summary>
        /// Removes <paramref name="item"/> from the buffer.
        /// </summary>
        /// <param name="item"></param>
        /// <returns>True if <paramref name="item"/> was found and 
        /// successfully removed. False if <paramref name="item"/> was not
        /// found or there was a problem removing it from the RingBuffer.
        /// </returns>
        public bool Remove(T item)
        {
            int _index = head;
            int _removeIndex = 0;
            bool _foundItem = false;
            EqualityComparer<T> _comparer = EqualityComparer<T>.Default;
            for (int i = 0; i < size; i++, _index = (_index + 1) % Capacity)
            {
                if (_comparer.Equals(item, buffer[_index]))
                {
                    _removeIndex = _index;
                    _foundItem = true;
                    break;
                }
            }
            if (_foundItem)
            {
                T[] _newBuffer = new T[size - 1];
                _index = head;
                bool _pastItem = false;
                for (int i = 0; i < size - 1; i++, _index = (_index + 1) % Capacity)
                {
                    if (_index == _removeIndex)
                    {
                        _pastItem = true;
                    }
                    if (_pastItem)
                    {
                        _newBuffer[_index] = buffer[(_index + 1) % Capacity];
                    }
                    else
                    {
                        _newBuffer[_index] = buffer[_index];
                    }
                }
                size--;
                buffer = _newBuffer;
                return true;
            }
            return false;
        }
    public void RemoveHead()
    {
        Remove(buffer[head]);
    }
    public void RemoveTail()
    {
        Remove(buffer[tail]);
    }
        #endregion

        #region ICollection Members
        /// <summary>
        /// Gets an object that can be used to synchronize access to the
        /// RingBuffer.
        /// </summary>
        public object SyncRoot { get { return this; } }

        /// <summary>
        /// Gets a value indicating whether access to the RingBuffer is 
        /// synchronized (thread safe).
        /// </summary>
        public bool IsSynchronized { get { return false; } }

        /// <summary>
        /// Copies the elements of the RingBuffer to <paramref name="array"/>, 
        /// starting at a particular Array <paramref name="index"/>.
        /// </summary>
        /// <param name="array">The one-dimensional Array that is the 
        /// destination of the elements copied from RingBuffer. The Array must 
        /// have zero-based indexing.</param>
        /// <param name="index">The zero-based index in 
        /// <paramref name="array"/> at which copying begins.</param>
        void ICollection.CopyTo(Array array, int index)
        {
            CopyTo((T[])array, index);
        }
        #endregion
    }
