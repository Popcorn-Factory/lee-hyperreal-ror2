using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class EffectUnparenter : MonoBehaviour
    {

        public float duration;
        float stopwatch;
        bool hasUnparented;

        public void Update()
        {
            stopwatch += Time.deltaTime;

            if (stopwatch >= duration && !hasUnparented) 
            {
                //Unparent
                hasUnparented = true;
                this.gameObject.transform.SetParent(null, true);
            }
        }
    }
}
