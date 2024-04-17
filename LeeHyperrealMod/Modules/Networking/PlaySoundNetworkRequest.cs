using R2API.Networking.Interfaces;
using RoR2;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Networking;


namespace LeeHyperrealMod.Modules.Networking
{
    internal class PlaySoundNetworkRequest : INetMessage
    {
        //Network these ones.
        NetworkInstanceId charnetID;
        uint soundNum;

        //Don't network these.
        GameObject bodyObj;

        public PlaySoundNetworkRequest()
        {

        }

        public PlaySoundNetworkRequest(NetworkInstanceId charnetID, uint soundNum)
        {
            this.charnetID = charnetID;
            this.soundNum = soundNum;
        }

        public void Deserialize(NetworkReader reader)
        {
            charnetID = reader.ReadNetworkId();
            soundNum = reader.ReadUInt32();
        }

        public void Serialize(NetworkWriter writer)
        {
            writer.Write(charnetID);
            writer.Write(soundNum);
        }

        public void OnReceived()
        {
            GameObject bodyObj = Util.FindNetworkObject(charnetID);
            if (!bodyObj) 
            {
                return;
            }
            AkSoundEngine.PostEvent(soundNum, bodyObj);
        }
    }
}
