using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Content.Observers
{
    public class PlayerDamageContainers
    {
        public NetworkClient connection; // To player.
        public int connectionRTT; // Round trip time to player in milliseconds ( divide by 1000 to get seconds )
        public List<ModifiedDamageInfo> modifiedDamageInfos;
        public HealthComponent healthComponent;

        public PlayerDamageContainers(NetworkClient newConnection)
        {
            connection = newConnection;
            modifiedDamageInfos = new List<ModifiedDamageInfo>();
        }

        public int GetEstimatedRTT()
        {
            if (connection == null)
            {
                return -1;
            }

            connectionRTT = connection.GetRTT();
            return connectionRTT;
        }
    }
}
