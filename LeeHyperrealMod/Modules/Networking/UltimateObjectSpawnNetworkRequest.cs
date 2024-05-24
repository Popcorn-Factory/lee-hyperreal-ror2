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
    internal class UltimateObjectSpawnNetworkRequest : INetMessage
    {
        internal NetworkInstanceId leeNetID;
        internal Vector3 position;

        public UltimateObjectSpawnNetworkRequest()
        {

        }

        public UltimateObjectSpawnNetworkRequest(NetworkInstanceId leeNetID, Vector3 position)
        {
            this.leeNetID = leeNetID;
            this.position = position;
        }

        public void OnReceived()
        {
            //Do for all machines
            GameObject explosionObject = UnityEngine.Object.Instantiate(Modules.Assets.ultimateExplosionObject);
            UltimateOrbExplosion ultOrb = explosionObject.GetComponent<UltimateOrbExplosion>();
            ultOrb.position = position;
            ultOrb.leeObject = Util.FindNetworkObject(leeNetID);
        }

        public void Deserialize(NetworkReader reader)
        {
            leeNetID = reader.ReadNetworkId();
            position = reader.ReadVector3();
        }

        public void Serialize(NetworkWriter writer)
        {
            writer.Write(leeNetID);
            writer.Write(position);
        }
    }
}
