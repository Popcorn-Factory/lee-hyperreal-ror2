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
        string soundStr;

        //Don't network these.
        GameObject bodyObj;

        public PlaySoundNetworkRequest()
        {

        }

        public PlaySoundNetworkRequest(NetworkInstanceId charnetID, uint soundNum)
        {
            this.charnetID = charnetID;
            this.soundNum = soundNum;
            this.soundStr = "";
        }

        public PlaySoundNetworkRequest(NetworkInstanceId charnetID, string soundStr)
        {
            this.charnetID = charnetID;
            this.soundStr = soundStr;
            this.soundNum = 0;
        }

        public void Deserialize(NetworkReader reader)
        {
            charnetID = reader.ReadNetworkId();
            soundNum = reader.ReadUInt32();
            soundStr = reader.ReadString();
        }

        public void Serialize(NetworkWriter writer)
        {
            writer.Write(charnetID);
            writer.Write(soundNum);
            writer.Write(soundStr);
        }

        public void OnReceived()
        {
            GameObject bodyObj = Util.FindNetworkObject(charnetID);
            if (!bodyObj) 
            {
                return;
            }

            if (soundNum != 0) 
            {
                AkSoundEngine.PostEvent(soundNum, bodyObj);
            }

            if (soundStr != "") 
            {
                AkSoundEngine.PostEvent(soundStr, bodyObj);
            }
        }
    }
}
