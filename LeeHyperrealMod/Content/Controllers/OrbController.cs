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

        internal enum OrbType : ushort

        {
            BLUE = 1,
            RED = 2,
            YELLOW = 3,
        }

        bool onFire = false;
        List<OrbType> orbList;
        int OrbLimit = 16;
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


        // Checks if move is valid determined by an int. 
        // If value is greater than 0, an orb was found. 
        // Values returned will be the index in the list it was found at. 
        // If specified orb was not found, 0, 0, 0 will be returned. 
        // If there are no orbs, 0, 0 ,0 will be returned.
        public int[] CheckMoveValidity(OrbType type)
        {

            int objLimit = orbList.Count >= 8 ? 8 : orbList.Count;

            int[] result = { -1, -1, -1};
            int indexPtr = 0;

            // No Orbs to spend!
            if (objLimit == 0)
            {
                return result;
            }

            bool found = false;

            //Only check the first 8.
            for (int i = 0; i < objLimit; i++) 
            {
                if (orbList[i] == type)
                {
                    found = true;
                    result[indexPtr] = i;
                    indexPtr++;
                }

                // Previously found, but new one doesn't match the current one. end of sequence.
                if (found && orbList[i] != type) 
                {
                    return result;
                }

                if (indexPtr == 3) 
                {
                    return result;
                }
            }



            return result;
        }

        //
        public int ConsumeOrbs(OrbType type) 
        {
            // Uses the CheckMoveValidity() and attempts to remove.     

            int[] moveValidity = CheckMoveValidity(type);
            int[] failedCheck = { -1, -1, -1 };

            if (failedCheck[0] == moveValidity[0] && failedCheck[1] == moveValidity[1] && failedCheck[2] == moveValidity[2]) 
            {
                // Disallowed from running.
                return 0;
            }

            // Inverse the array since we remove from the end of the list first.
            int strength = 0;
            for( int i = moveValidity.Length - 1; i > -1; i-- )
            {
                if (moveValidity[i] != -1) 
                {
                    //SHIT THIS IS GARBAGE.
                    orbList.RemoveAt(moveValidity[i]);
                    strength++;
                }
            }


            //Success.
            return strength;
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

            string output = "";

            foreach (OrbType type in orbList)
            {
                switch (type)
                {
                    case OrbType.BLUE:
                        output += "B";
                        break;
                    case OrbType.RED:
                        output += "R";
                        break;
                    case OrbType.YELLOW:
                        output += "Y";
                        break;
                }
            }

            Chat.AddMessage($"{orbIncrementor}");
            Chat.AddMessage($"{output}");
        }

        public void GrantOrb()
        {
            if (orbList.Count >= 16) 
            {
                return;
            }

            int chosen = UnityEngine.Random.Range(1, 4);

            OrbType chosenOrbType = (OrbType)chosen;

            orbList.Add(chosenOrbType);
        }

        public void AddToIncrementor(float amount) 
        {
            orbIncrementor += amount;
        }
    }
}
