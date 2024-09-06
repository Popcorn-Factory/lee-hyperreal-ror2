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
        public static ParryDamageObserver instance { get; private set; }
        public static GameObject instanceContainer { get; private set; }
        public static List<BuffDef> buffsToTriggerOn = new List<BuffDef>();
        public List<PlayerDamageContainers> playerList = new List<PlayerDamageContainers>();

        public static void CreateInstance()
        {
            if (!instance)
            {
                instanceContainer = new GameObject("__ParryDamageBufferObserver(Singleton)");
                DontDestroyOnLoad(instanceContainer);
                instance = instanceContainer.AddComponent<ParryDamageObserver>();

                Debug.Log("I have been born!");
            }
            else 
            {
                Debug.Log("Singleton instance has already been created! Instance has not been changed.");
            }
        }

        public static bool InstanceExists()
        {
            return instance != null;
        }

        public static bool CanDoDamageDelay() 
        {
            if (!instance) { return false; }
            if (instance.playerList.Count == 0) { return false; }

            return true;
        }

        public static void DestroyInstance()
        {
            if (instance)
            {
                Debug.Log("Goodbye world.");
                Destroy(instanceContainer);
            }
        }

        public void OnDestroy()
        {
            Unhook();
            DestroyInstance();
        }

        public void Awake()
        {

        }

        public void Start()
        {
            Hook();
        }

        public void UpdateListOfPlayers() 
        {
            playerList.Clear();

            //Repopulate the list of players.
            if (NetworkServer.active)
            {
                foreach (NetworkClient client in NetworkClient.allClients)
                {
                    playerList.Add(new PlayerDamageContainers(client));
                }
            }

            Debug.Log("Player list updated!");
        }

        public void Update()
        {
            Debug.Log("Listening");
        }

        public void Hook()
        {
            On.RoR2.Networking.NetworkManagerSystem.OnClientConnect += NetworkManagerSystem_OnClientConnect;
            On.RoR2.HealthComponent.TakeDamage += HealthComponent_TakeDamage;
        }

        private void HealthComponent_TakeDamage(On.RoR2.HealthComponent.orig_TakeDamage orig, RoR2.HealthComponent self, RoR2.DamageInfo damageInfo)
        {
            orig(self, damageInfo);
        }

        private void NetworkManagerSystem_OnClientConnect(On.RoR2.Networking.NetworkManagerSystem.orig_OnClientConnect orig, RoR2.Networking.NetworkManagerSystem self, NetworkConnection conn)
        {
            orig(self, conn);
            UpdateListOfPlayers();
        }

        public void Unhook()
        {
            On.RoR2.Networking.NetworkManagerSystem.OnClientConnect -= NetworkManagerSystem_OnClientConnect;
            On.RoR2.HealthComponent.TakeDamage -= HealthComponent_TakeDamage;
        }
    }
}
