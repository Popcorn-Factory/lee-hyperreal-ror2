using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class ParryMonitor : MonoBehaviour
    {
        private bool PauseTrigger = false;
        public bool ShouldDoBigParry = false;

        public void SetPauseTrigger(bool val) 
        {
            PauseTrigger = val;
        }

        public bool GetPauseTrigger() 
        {
            return PauseTrigger;
        }
    }
}
