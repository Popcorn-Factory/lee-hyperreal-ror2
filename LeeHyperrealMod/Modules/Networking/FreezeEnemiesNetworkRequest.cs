using R2API.Networking.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Modules.Networking
{
    internal class FreezeEnemiesNetworkRequest : INetMessage
    {
        public void Deserialize(NetworkReader reader)
        {
            throw new NotImplementedException();
        }

        public void OnReceived()
        {
            throw new NotImplementedException();
        }

        public void Serialize(NetworkWriter writer)
        {
            throw new NotImplementedException();
        }
    }
}
