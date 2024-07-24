using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Modules
{
    internal class DPadCheck
    {
        internal enum DPadInput
        {
            Left,
            Right,
            Up,
            Down
        }

        internal enum DPadAxis
        {
            Horizontal,
            Vertical
        }

        public static void Update()
        {
            float axis = Input.GetAxis("Joy1Axis6");
            float axis2 = Input.GetAxis("Joy1Axis7");

            //has to be a direct press in a specific direction. 


        }

    }
}
