using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealCloneFlicker : MonoBehaviour
    {
        Animator animator;

        public void Start() 
        {
            animator = GetComponent<Animator>();
            //Check the animator for the flicker animation
            //Choose random point in animation to play from
        }

        public void Update() 
        {

        }
    }
}
