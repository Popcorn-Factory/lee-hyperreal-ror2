using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class DestroyPlatformOnDelay : MonoBehaviour
    {
        public float delay = 0.75f;
        public bool startDestroy = false;
        public float timer = 0f;

        public Animator animator;

        public void Start() 
        {
            animator = gameObject.GetComponent<Animator>();
            if (animator) 
            {
                animator.SetBool("End", false);
                animator.SetBool("Turn Off", false);
            }
        }

        public void Update()
        {
            if (startDestroy)
            {
                timer += Time.deltaTime;
                if (timer >= delay) 
                {
                    TriggerDestroy();
                }
            }
        }

        public void StartDestroying() 
        {
            startDestroy = true;
            if (animator)
            {
                animator.SetBool("End", true);
                animator.SetBool("Turn Off", true);
            }
        }

        public void TriggerDestroy() 
        {
            Destroy(this.gameObject);
        }
    }
}
