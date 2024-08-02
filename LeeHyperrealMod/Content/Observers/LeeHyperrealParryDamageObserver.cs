using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Content.Observers
{
    public class LeeHyperrealParryDamageObserver : MonoBehaviour
    {
        //Need pair object to setup network connections to measure ping and apply damage after x time.
        public class LeeHyperrealDamageContainer
        {
            public NetworkConnection connection; // To player.
            public DamageInfo damageInfo;
            public float timer;
        }

        public static LeeHyperrealParryDamageObserver instance { get; private set; }
        public static GameObject instanceContainer { get; private set; }
        public List<LeeHyperrealDamageContainer> damageBuffer = new List<LeeHyperrealDamageContainer>();

        public static void CreateInstance() 
        {
            if (!instance) 
            {
                instanceContainer = new GameObject("__ParryDamageBufferObserver(Singleton)");
                instance = instanceContainer.AddComponent<LeeHyperrealParryDamageObserver>();
            }
        }

        public static void DestroyInstance() 
        {
            if (instance) 
            {
                Destroy(instanceContainer);
            }
        }

        public void OnDestroy() 
        {
            DestroyInstance();
        }

        public void Awake() 
        {
            
        }

        public void Update() 
        {
            
        }
    }
}
