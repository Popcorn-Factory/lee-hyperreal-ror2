using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Content.Observers
{
    public class ParryDamageObserver : MonoBehaviour
    {
        //Need pair object to setup network connections to measure ping and apply damage after x time.
        public class ModifiedDamageInfo
        {
            public DamageInfo damageInfo;
            public double timestamp;

            public ModifiedDamageInfo(DamageInfo damageInfo, double timestamp)
            {
                this.damageInfo = damageInfo;
                this.timestamp = timestamp;
            }
        }

        public class PlayerDamageContainers
        {
            public NetworkClient connection; // To player.
            public int connectionRTT; // Round trip time to player.
            public List<ModifiedDamageInfo> modifiedDamageInfos;

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

        public static ParryDamageObserver instance { get; private set; }
        public static GameObject instanceContainer { get; private set; }
        public List<PlayerDamageContainers> playerList = new List<PlayerDamageContainers>();

        public static void CreateInstance()
        {
            if (!instance)
            {
                instanceContainer = new GameObject("__ParryDamageBufferObserver(Singleton)");
                instance = instanceContainer.AddComponent<ParryDamageObserver>();
            }
        }

        public static void DestroyInstance()
        {
            if (instance)
            {
                Destroy(instanceContainer);
            }
        }

        public void OnDestroy()
        {
            DestroyInstance();
        }

        public void Awake()
        {

        }

        public void Start()
        {
            if (NetworkServer.active)
            {
                foreach (NetworkClient client in NetworkClient.allClients)
                {
                    playerList.Add(new PlayerDamageContainers(client));
                }
            }
        }

        public void Update()
        {

        }

        public void Hook()
        {
            On.RoR2.Networking.NetworkManagerSystem.OnClientConnect += NetworkManagerSystem_OnClientConnect;
        }

        private void NetworkManagerSystem_OnClientConnect(On.RoR2.Networking.NetworkManagerSystem.orig_OnClientConnect orig, RoR2.Networking.NetworkManagerSystem self, NetworkConnection conn)
        {
            orig(self, conn);
        }

        public void Unhook()
        {
            On.RoR2.Networking.NetworkManagerSystem.OnClientConnect -= NetworkManagerSystem_OnClientConnect;
        }
    }
}
