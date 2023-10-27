using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class OrbController : MonoBehaviour
    {
        // 16 orbs max
        // On fire or not
        // Orb Types

        enum OrbType : ushort

        {
            BLUE = 1,
            RED = 2,
            YELLOW = 3,
        }

        bool onFire = false;
        List<OrbType> orbList;
        int OrbLimit;
        float orbIncrementor = 0f;
        const bool autoIncrementOrbIncrementor = true;

        CharacterBody charBody;

        public void Awake()
        {
            orbIncrementor = 0f;
            orbList = new List<OrbType>();
        }

        public void Start()
        {
            charBody = gameObject.GetComponent<CharacterBody>();
        }

        public void Hook()
        {

        }

        public void Unhook()
        {

        }

        public void Update()
        {

        }


        //Logic
        public void FixedUpdate()
        {
            if (charBody.hasEffectiveAuthority)
            {
                orbIncrementor += Modules.StaticValues.flatIncreaseOrbIncrementor * Time.fixedDeltaTime;

                if (orbIncrementor >= Modules.StaticValues.LimitToGrantOrb)
                {
                    orbIncrementor = 0f;
                    GrantOrb();
                }
            }
        }

        public void GrantOrb()
        {
            int chosen = UnityEngine.Random.Range(1, 3);

            OrbType chosenOrbType = (OrbType)chosen;

            orbList.Add(chosenOrbType);
        }

        public void AddToIncrementor(float amount) 
        {
            orbIncrementor += amount;
        }
    }
}
