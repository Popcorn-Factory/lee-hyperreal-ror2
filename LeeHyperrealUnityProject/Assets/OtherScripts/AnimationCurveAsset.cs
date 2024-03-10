using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace RoR2
{

    [CreateAssetMenu(menuName = "RoR2/Animation Curve Asset")]
    public class AnimationCurveAsset : ScriptableObject
    {
        public AnimationCurve value;
    }
}

