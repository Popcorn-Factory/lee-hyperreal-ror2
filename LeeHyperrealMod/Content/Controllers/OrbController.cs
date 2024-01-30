using LeeHyperrealMod.SkillStates.LeeHyperreal;
using LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb;
using LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using static LeeHyperrealMod.Content.Controllers.BulletController;

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
        public List<OrbType> orbList;
        int OrbLimit = 16;
        float orbIncrementor = 0f;
        const bool autoIncrementOrbIncrementor = true;

        float orbUIStopwatch = 0f;
        float updateRate = 0.25f;

        LeeHyperrealUIController uiController;

        CharacterBody charBody;

        EntityStateMachine[] stateMachines;


        public void Awake()
        {
            orbIncrementor = 0f;
            orbList = new List<OrbType>();
        }

        public void Start()
        {
            charBody = gameObject.GetComponent<CharacterBody>();
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();

            stateMachines = charBody.gameObject.GetComponents<EntityStateMachine>();

        }

        public void Hook()
        {

        }

        public void Unhook()
        {

        }

        public void Update()
        {
            //Check input


            if (Modules.Config.isSimple.Value) 
            {
                if (UnityEngine.Input.GetKeyDown(Modules.Config.blueOrbTrigger.Value.MainKey)) 
                {
                    ConsumeOrbsSimple(OrbType.BLUE);
                }
                else if (UnityEngine.Input.GetKeyDown(Modules.Config.redOrbTrigger.Value.MainKey))
                { 
                    ConsumeOrbsSimple(OrbType.RED);
                }
                else if (UnityEngine.Input.GetKeyDown(Modules.Config.yellowOrbTrigger.Value.MainKey))
                {
                    ConsumeOrbsSimple(OrbType.YELLOW);
                }
            }
            else 
            {
                int SelectedIndex = -1;
                bool isAltPressed = UnityEngine.Input.GetKey(Modules.Config.orbAltTrigger.Value.MainKey);
                if (UnityEngine.Input.GetKeyDown(Modules.Config.orb1Trigger.Value.MainKey))
                {
                    SelectedIndex = 1;
                }
                else if (UnityEngine.Input.GetKeyDown(Modules.Config.orb2Trigger.Value.MainKey))
                {
                    SelectedIndex = 2;
                }
                else if(UnityEngine.Input.GetKeyDown(Modules.Config.orb3Trigger.Value.MainKey))
                {
                    SelectedIndex = 3;
                }
                else if(UnityEngine.Input.GetKeyDown(Modules.Config.orb4Trigger.Value.MainKey))
                {
                    SelectedIndex = 4;
                }

                if (isAltPressed && SelectedIndex != -1) 
                {
                    SelectedIndex += 4;
                }

                if (SelectedIndex != -1) 
                {
                    ConsumeOrbsFromSlot(SelectedIndex);
                }
            }


            if (uiController)
            {
                orbUIStopwatch += Time.deltaTime;
                if (orbUIStopwatch >= updateRate) 
                {
                    uiController.UpdateOrbList(orbList);
                    uiController.UpdateOrbAmount(orbList.Count, OrbLimit);
                }
            }
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
        public int ConsumeOrbsSimple(OrbType type) 
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
                    orbList.RemoveAt(moveValidity[i]);
                    strength++;
                    if (uiController) 
                    {
                        uiController.PingSpecificOrb(moveValidity[i]); 
                    }


                }
            }


            if (uiController) 
            {
                uiController.UpdateOrbList(orbList);
            }

            TriggerOrbState(strength, type);
            //Success.
            return strength;
        }

        public void ConsumeOrbsFromSlot(int slotToConsumeFrom) 
        {
            //Check the first 8 orbs
            //Group into colours
            //check against the index (it'll be from 1 - 8)
            // match against the group that the index matches.  
            // count strength
            // Trigger state associated with that.

            List<Tuple<OrbType, Nullable<int>>> typeList = new List<Tuple<OrbType, Nullable<int>>>();
            for (int i = 0; i < orbList.Count; i++) 
            {
                if (i == 0)
                {
                    typeList.Add(new Tuple<OrbType, Nullable<int>>(orbList[i], 1));
                }
                else 
                {
                    //Type if matches
                    if (typeList[typeList.Count - 1].Item1 == orbList[i])
                    {
                        // BRUGH LMAOOO
                        typeList[typeList.Count - 1] = new Tuple<OrbType, Nullable<int>>(typeList[typeList.Count - 1].Item1, typeList[typeList.Count - 1].Item2 + 1);
                    } 
                    else 
                    {
                        // Type if not matched.
                        typeList.Add(new Tuple<OrbType, Nullable<int>>(orbList[i], 1));
                    }
                }
            }

            Nullable<int> slotPos = 0;
            bool found = false;
            for (int i = 0; i < typeList.Count; i++) 
            {
                slotPos += typeList[i].Item2;

                if (slotPos >= slotToConsumeFrom && !found)
                {
                    //Found the state we need to trigger off.   
                    found = true;

                    int startingIndex = 0;
                    int[] indexes = new int[3];
                    //Finding the damn indexes to remove.
                    for (int j = 0; j < typeList.Count; j++) 
                    {
                        if (j == i) 
                        {
                            //Indexing BRUHSIAUHSD I HATE ALL OF THIS LOGIC>
                            indexes[0] = startingIndex;
                            indexes[1] = typeList[i].Item2 >= 2 ? startingIndex + 1 : -1;
                            indexes[2] = typeList[i].Item2 >= 3 ? startingIndex + 2 : -1;

                            //End 
                            j = typeList.Count - 1;
                        }

                        startingIndex += (int)typeList[j].Item2;
                    }

                    ClearSuggestedOrbs(indexes);
                    TriggerOrbState((int)typeList[i].Item2, typeList[i].Item1);
                }
            }
        }

        private void ClearSuggestedOrbs(int[] indexes)
        {
            for (int i = indexes.Length - 1; i > -1; i--)
            {
                if (indexes[i] != -1)
                {
                    orbList.RemoveAt(indexes[i]);
                    if (uiController)
                    {
                        uiController.PingSpecificOrb(indexes[i]);
                    }
                }
            }
        }

        public void TriggerOrbState(int strength, OrbType orbType) 
        {
            EntityStateMachine bodyMachine = null;
            
            foreach (EntityStateMachine esm in stateMachines) 
            {
                if (esm.customName == "Body") 
                {
                    bodyMachine = esm;
                }
            }

            if (bodyMachine) 
            {
                switch (orbType)
                {
                    case OrbType.BLUE:
                        bodyMachine.SetState(new BlueOrb { moveStrength = strength});
                        break;
                    case OrbType.YELLOW:
                        bodyMachine.SetState(new YellowOrbEntry { moveStrength = strength });
                        break;
                    case OrbType.RED:
                        bodyMachine.SetState(new RedOrbEntry { moveStrength = strength });
                        break;
                    default:
                        break;
                }
            }
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

            //Chat.AddMessage($"{orbIncrementor}");
            //Chat.AddMessage($"{output}");
        }

        public void GrantOrb()
        {
            //Disallow more than the limit specified.
            if (orbList.Count >= OrbLimit) 
            {
                return;
            }

            int chosen = UnityEngine.Random.Range(1, 4);

            OrbType chosenOrbType = (OrbType)chosen;

            orbList.Add(chosenOrbType);

            if (uiController)
            {
                uiController.UpdateOrbList(orbList);
            }
        }

        public void Grant3Ping(BulletType type) 
        {
            switch (type) 
            {
                case BulletType.BLUE:
                    orbList.Add(OrbType.BLUE);
                    orbList.Add(OrbType.BLUE);
                    orbList.Add(OrbType.BLUE);
                    break;
                case BulletType.RED:
                    orbList.Add(OrbType.RED);
                    orbList.Add(OrbType.RED);
                    orbList.Add(OrbType.RED);
                    break;
                case BulletType.YELLOW:
                    orbList.Add(OrbType.YELLOW);
                    orbList.Add(OrbType.YELLOW);
                    orbList.Add(OrbType.YELLOW);
                    break;
            }
        }

        public void AddToIncrementor(float amount) 
        {
            orbIncrementor += amount;
        }
    }
}
