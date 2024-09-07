using R2API;
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
        /*
            What does this component do?
            
            This component is a singleton that listens for damage events and stores them in a buffer.
            Damage events are stored in a buffer for a certain amount of time before being applied.
            If a buff that signifies a parry is active on a body, force the player state to be in a parry state, and do custom stuff on top of that.

            Character Body -> character Master -> NetworkIdentity -> NetworkConnection

            Get List of NetworkClients and store their ping.
            
         */

        public static ParryDamageObserver instance { get; private set; }
        public static GameObject instanceContainer { get; private set; }
        public static List<BuffDef> buffsToTriggerOn = new List<BuffDef>();
        public static List<string> bodyNamesToFocusOn = new List<string>{ $"{LeeHyperrealPlugin.DEVELOPER_PREFIX}_LEE_HYPERREAL_BODY_NAME", };
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
            UpdateListOfPlayers();
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
        }

        public void Update()
        {
            Debug.Log("Listening");

            foreach (PlayerDamageContainers playerContainer in playerList) 
            {
                playerContainer.GetEstimatedRTT();

                List<ModifiedDamageInfo> damageToApply = new List<ModifiedDamageInfo>();
                for (int i = 0; i < playerContainer.modifiedDamageInfos.Count; i++)
                {
                    ModifiedDamageInfo currentDamageInfo = playerContainer.modifiedDamageInfos[i];

                    if (Time.time - currentDamageInfo.timestamp >= playerContainer.connectionRTT / 1000)
                    {
                        damageToApply.Add(currentDamageInfo);
                        playerContainer.modifiedDamageInfos.RemoveAt(i);
                        i--;
                        Debug.Log("Damage applied!");
                    }
                }

                for (int i = 0; i < damageToApply.Count; i++)
                {
                    DamageInfo dmgInfo = damageToApply[i].damageInfo;
                    DamageAPI.AddModdedDamageType(dmgInfo, Modules.Damage.unparryable);
                    damageToApply[i].healthComponent.TakeDamage(damageToApply[i].damageInfo);
                }
            }
        }

        public void Hook()
        {
            On.RoR2.Networking.NetworkManagerSystem.OnClientConnect += NetworkManagerSystem_OnClientConnect;
            On.RoR2.HealthComponent.TakeDamage += HealthComponent_TakeDamage;
        }

        public void ActionOnParry() 
        {
            //Do something here.
        }

        private void HealthComponent_TakeDamage(On.RoR2.HealthComponent.orig_TakeDamage orig, RoR2.HealthComponent self, RoR2.DamageInfo damageInfo)
        {
            bool applyDamage = true;

            //Grab Damage on body.
            if (self?.body && !damageInfo.HasModdedDamageType(Modules.Damage.unparryable)) 
            {
                CharacterBody characterBody = self.body;
                //Check if the body is a player
                if (characterBody.isPlayerControlled && bodyNamesToFocusOn.Contains(characterBody.baseNameToken)) 
                {
                    // Grab the damage and store it in a buffer.
                    // Need to match the NetworkClient to the player controlled object somehow.
                    for (int i = 0; i < playerList.Count; i++) 
                    {
                        NetworkConnection currentConnection = playerList[i].connection.connection;

                        if (currentConnection == characterBody.master.GetComponent<NetworkIdentity>().clientAuthorityOwner) 
                        {
                            playerList[i].modifiedDamageInfos.Add(new ModifiedDamageInfo(damageInfo, Time.time, playerList[i].connectionRTT, self));
                            applyDamage = false;                 
                        }
                    }
                }
            }

            if (applyDamage) 
            {
                orig(self, damageInfo);
            }
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
