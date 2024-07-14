using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealCloneFlicker : MonoBehaviour
    {
        Animator animator;
        Transform followTransform;
        public float timerToStopFollowing;
        public float timer = 0f;

        public void Start() 
        {
            animator = GetComponent<Animator>();
            //Check the animator for the flicker animation
            //Choose random point in animation to play from

            animator.SetBool("Flicker", true);

            animator.Play("Flicker", animator.GetLayerIndex("Flicker"), UnityEngine.Random.Range(0f, 1.0f));
            animator.Play("FlickerMaterial", animator.GetLayerIndex("MaterialChange"), UnityEngine.Random.Range(0f, 1.0f));
        }

        public void Update() 
        {
            //timer += Time.deltaTime;
            //if (timer <= timerToStopFollowing && followTransform) 
            //{
            //    gameObject.transform.position = new Vector3(0, followTransform.position.y, 0f);
            //}
        }
    }
}
