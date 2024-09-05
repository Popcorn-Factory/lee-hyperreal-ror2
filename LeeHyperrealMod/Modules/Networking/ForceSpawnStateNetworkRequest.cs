using LeeHyperrealMod.SkillStates;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Modules.Networking
{
    internal class ForceSpawnStateNetworkRequest : INetMessage
    {
        NetworkInstanceId netID; //Net id for the CharacterBody.

        public ForceSpawnStateNetworkRequest() 
        {
        
        }

        public ForceSpawnStateNetworkRequest(NetworkInstanceId netID)
        {
            this.netID = netID;
        }

        public void Deserialize(NetworkReader reader)
        {
            netID = reader.ReadNetworkId();
        }

        public void Serialize(NetworkWriter writer)
        {
            writer.Write(netID);
        }

        public void OnReceived()
        {
            GameObject bodyObject = Util.FindNetworkObject(netID);

            if (!bodyObject) 
            {
                Debug.Log("Failed to find Body object to apply state change to.");
                return;
            }

            CharacterBody body = bodyObject.GetComponent<CharacterBody>();

            if (!body.hasEffectiveAuthority) 
            {
                return;
            }

            EntityStateMachine[] esms = bodyObject.GetComponents<EntityStateMachine>();

            foreach (EntityStateMachine esm in esms) 
            {
                if (esm.customName == "Body") 
                {
                    esm.SetNextState(new LeeHyperrealSpawnState { });
                    return;
                }
            }
        }
    }
}
