using LeeHyperrealMod.SkillStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate;
using R2API.Networking.Interfaces;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Modules.Networking
{
    internal class SetDomainUltimateNetworkRequest : INetMessage
    {
        NetworkInstanceId netID;

        public SetDomainUltimateNetworkRequest()
        {

        }

        public SetDomainUltimateNetworkRequest(NetworkInstanceId netID)
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
            ForceDomainUltimate();
        }

        //Lots of checks in here.
        public void ForceDomainUltimate()
        {
            GameObject bodyObject = Util.FindNetworkObject(netID);

            if (!bodyObject)
            {
                Debug.Log("Specified GameObject not found!");
                return;
            }

            EntityStateMachine[] stateMachines = bodyObject.GetComponents<EntityStateMachine>();
            //"No statemachines?"
            if (!stateMachines[0])
            {
                Debug.LogWarning("StateMachine search failed! Wrong object?");
                return;
            }

            foreach (EntityStateMachine stateMachine in stateMachines)
            {
                if (stateMachine.customName == "Body")
                {
                    if (stateMachine.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death) 
                    {
                        stateMachine.SetNextState(new UltimateDomain { });
                        return;
                    }
                }
            }
        }
    }
}
