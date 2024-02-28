using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LeeHyperrealMod.ParticleScripts 
{
    public class LightRadiusCurve : MonoBehaviour
    {
        // Start is called before the first frame update
        [SerializeField]
        float time;
        [SerializeField]
        AnimationCurve curve;
        float timer;
        [Tooltip("Loop animation curve")]
        public bool loop;
        Light lightRef;

        void Start()
        {
            lightRef = GetComponent<Light>();

        }

        // Update is called once per frame
        void Update()
        {
            timer += Time.deltaTime;
            lightRef.range = curve.Evaluate(timer / time);
            if (timer >= time && loop)
            {
                timer = 0;
            }
            else if (timer >= time && !loop)
            {
                gameObject.SetActive(false);
            }
        }
    }
}