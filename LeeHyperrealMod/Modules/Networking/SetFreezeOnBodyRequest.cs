using LeeHyperrealMod.SkillStates;
using R2API.Networking.Interfaces;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.Modules.Networking
{
    internal class SetFreezeOnBodyRequest : INetMessage
    {
        NetworkInstanceId netID;
        float duration;

        public SetFreezeOnBodyRequest()
        {

        }

        public SetFreezeOnBodyRequest(NetworkInstanceId netID, float duration)
        {
            this.netID = netID;
            this.duration = duration;
        }

        public void Deserialize(NetworkReader reader)
        {
            netID = reader.ReadNetworkId();
            duration = reader.ReadSingle();
        }

        public void Serialize(NetworkWriter writer)
        {
            writer.Write(netID);
            writer.Write(duration);
        }

        public void OnReceived()
        {
            ForceFreezeState();
        }

        //Lots of checks in here.
        public void ForceFreezeState()
        {
            GameObject masterobject = Util.FindNetworkObject(netID);

            if (!masterobject)
            {
                Debug.Log("Specified GameObject not found!");
                return;
            }
            CharacterMaster charMaster = masterobject.GetComponent<CharacterMaster>();
            if (!charMaster)
            {
                Debug.Log("charMaster failed to locate");
                return;
            }

            if (!charMaster.hasEffectiveAuthority)
            {
                return;
            }

            GameObject bodyObject = charMaster.GetBodyObject();

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
                    stateMachine.SetState(new Freeze { duration = this.duration});
                    return;
                }
            }
        }
    }
}
