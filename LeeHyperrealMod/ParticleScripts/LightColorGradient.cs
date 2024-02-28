using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.ParticleScripts
{
    public class LightColorGradient : MonoBehaviour
    {
        // Start is called before the first frame update
        [SerializeField]
        float time;
        [SerializeField]
        Gradient gradient;
        float timer;
        [Tooltip("Loop animation curve")]
        public bool loop;
        Light lightRef;
        Color color;
        void Start()
        {
            lightRef = GetComponent<Light>();
        }

        // Update is called once per frame
        void Update()
        {
            timer += Time.deltaTime;
            color = gradient.Evaluate(timer / time);
            lightRef.color = color;
            if (timer >= time && loop)
            {
                timer = 0;
            }
        }
    }

}