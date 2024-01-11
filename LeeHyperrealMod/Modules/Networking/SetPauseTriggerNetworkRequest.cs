using LeeHyperrealMod.Content.Controllers;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Modules.Networking
{
    internal class SetPauseTriggerNetworkRequest : INetMessage
    {
        internal NetworkInstanceId netID;
        internal bool pauseVal;

        public SetPauseTriggerNetworkRequest() 
        {
            
        }

        public SetPauseTriggerNetworkRequest(NetworkInstanceId netID, bool pauseVal)
        {
            this.netID = netID;
            this.pauseVal = pauseVal;
        }

        public void Deserialize(NetworkReader reader)
        {
            netID = reader.ReadNetworkId();
            pauseVal = reader.ReadBoolean();
        }

        public void Serialize(NetworkWriter writer)
        {
            writer.Write(netID);
            writer.Write(pauseVal);
        }

        public void OnReceived()
        {
            GameObject masterobject = Util.FindNetworkObject(netID);

            if (!masterobject) 
            {
                return;
            }

            CharacterMaster master = masterobject.GetComponent<CharacterMaster>();
            if (!master) 
            {
                return;
            }

            CharacterBody body = master.GetBody();

            if (!body) 
            {
                return;   
            }

            ParryMonitor parryMonitor = body.GetComponent<ParryMonitor>();

            if (body.hasEffectiveAuthority) 
            {
                parryMonitor.SetPauseTrigger(pauseVal);
                return;
            }
        }
    }
}
