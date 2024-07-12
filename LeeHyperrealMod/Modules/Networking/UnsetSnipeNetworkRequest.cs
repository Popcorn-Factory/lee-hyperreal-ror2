using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate;
using R2API.Networking.Interfaces;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Modules.Networking
{
    internal class UnsetSnipeNetworkRequest : INetMessage
    {
        NetworkInstanceId netID;

        public UnsetSnipeNetworkRequest()
        {

        }

        public UnsetSnipeNetworkRequest(NetworkInstanceId netID)
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
            ForceUnsetSnipe();
        }

        //Lots of checks in here.
        public void ForceUnsetSnipe()
        {
            GameObject bodyObject = Util.FindNetworkObject(netID);
            CharacterBody charBody = bodyObject.GetComponent<CharacterBody>();

            if (bodyObject) 
            {
                BulletController bulletController = bodyObject.GetComponent<BulletController>();

                if (!charBody.hasEffectiveAuthority) 
                {
                    bulletController.UnsetSnipeStance();
                }
            }
        }
    }
}
