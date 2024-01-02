using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
[ExecuteInEditMode]
[RequireComponent(typeof(LineRenderer))]
public class DirectLink : LinkBase
{
    public enum TrajectoryType
    {
        Parabola = 1,
        Broken
    }
    public bool UseVectorData;
    public Vector3 HeadPosition;
    public Vector3 TailPosition;
    public Transform Head;
    public Transform Tail;
    public int ControlCount;
    TrajectoryType UseTrajectoryType;
    LineRenderer LineRenderer;
    Vector3[] Positions;

    void OnEnable()
    {
        LineRenderer = GetComponent<LineRenderer>();
        LineRenderer.useWorldSpace = true;
        ClearLine();
    }

    void OnDisable()
    {
        ClearLine();
    }

    void ClearLine()
    {
        SetPositions(Vector3.zero, Vector3.zero);
    }
    void Update()
    {
        if (LineRenderer)
        {
            if (UseVectorData)
            {
                SetPositionsByType(HeadPosition, TailPosition);
                return;
            }
            if (Head && Tail)
            {
                SetPositionsByType(Head.position, Tail.position);
            }
            else
                LineRenderer.positionCount = 0;
                
        }
    }

    void SetPositionsByType(Vector3 start, Vector3 end)
    {
        if(UseTrajectoryType == TrajectoryType.Parabola)
        {
            Debug.LogError("Not Supported!");
            return;
        }
        else
        {
            if(UseTrajectoryType==TrajectoryType.Broken)
            SetPositionsByBroken(start, end);
            else
                SetPositions(start, end);
        }
    }

    void SetPositions(Vector3 start, Vector3 end)
    {
        if(Positions == null ||Positions.Length<ControlCount+2)
            Positions = new Vector3[ControlCount+2];
        if (LineRenderer.alignment == LineAlignment.Local)
        {
            Vector3 temp = end - start;
            Vector3 cross = Vector3.Cross(transform.forward, temp);
            if (Vector3.Magnitude(cross) < 1)
                end.y = end.y + 0.0000099999997f;
        }
        Positions[0] = start;
        if(ControlCount+1>=Positions.Length)
        {
            return;
        }
        int i = ControlCount + 1;
        Positions[i] = end;
        if (ControlCount > 0)
        {
            Vector3 sub = end - start;
            Vector3 div = sub / ControlCount;
            int j = 1;
            if (ControlCount >= 1)
            {
                while (true)
                {
                    Vector3 temp2 = div * j;
                    Vector3 temp3 = start + temp2;
                    if (j >= Positions.Length)
                        return;
                    j++;
                    Positions[j] = temp3;
                    if (j > ControlCount)
                    {
                        break;
                    }
                }
            }
        }
        if (!LineRenderer)
            return;
        LineRenderer.positionCount = ControlCount + 2;
        LineRenderer.SetPositions(Positions);
    }

    void SetPositionsByBroken(Vector3 start, Vector3 end)
    {
        if (Positions == null || Positions.Length < 3)
        {
            Positions = new Vector3[3];
        }
        Positions[0] = start;
        Vector3 temp = Vector3.zero;
        temp.x = end.x - (end.x - start.x) * .5f;
        temp.y = end.y;
        temp.z = end.z;
        
        if (Positions.Length < 2)
        {
            return;
        }
        Positions[1] = temp;
        
        if(Positions.Length < 3)
        {
            return;
        }
        Positions[2] = end;
        if (LineRenderer)
        {
            LineRenderer.positionCount = 3;
            LineRenderer.SetPositions(Positions);
        }
    }

    void SetPositionsByParabola(Vector3 start, Vector3 end)
    {

    }

    public override void SetLinkPoint(Vector3 HeadPosition, Vector3 TailPosition)
    {
        this.HeadPosition = HeadPosition;
        this.TailPosition = TailPosition;
        UseVectorData = true;

    }

    public override void SetUseTrajectoryType(TrajectoryType TrajectoryType)
    {
        base.SetUseTrajectoryType(TrajectoryType);
    }

    public void SetLinkPoint(Vector3 HeadPosition, Vector3 TailPosition, TrajectoryType useTrajectoryType)
    {
        UseTrajectoryType = useTrajectoryType;
        SetLinkPoint(HeadPosition, TailPosition);
    }

    public DirectLink()
    {
        Positions = new Vector3[2];
    }
}

public class LinkBase : MonoBehaviour
{
    public virtual void SetLinkPoint(Vector3 HeadPosition, Vector3 TailPosition)
    {

    }

    public virtual void SetUseTrajectoryType(DirectLink.TrajectoryType TrajectoryType) { }

}
