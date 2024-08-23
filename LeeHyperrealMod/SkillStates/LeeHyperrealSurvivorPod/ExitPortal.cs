using UnityEngine.Networking;
using UnityEngine;
using RoR2;
using EntityStates.SurvivorPod;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking.Interfaces;

namespace LeeHyperrealMod.SkillStates.LeeHyperrealSurvivorPod
{
    internal class ExitPortal : SurvivorPodBaseState
    {
        float duration = 4.833f;
        float ejectFrac = 2.92f;
        Animator portalAnimator;
        CharacterBody currentPassengerBody;

        public override void OnEnter()
        {
            base.OnEnter();
            portalAnimator = GetComponent<Animator>();
            currentPassengerBody = base.vehicleSeat.currentPassengerBody;

            base.vehicleSeat.onPassengerExitUnityEvent.AddListener(PassengerExitUnityEvent);

            if (!base.survivorPodController)
            {
                return;
            }
            if (NetworkServer.active && base.vehicleSeat && base.vehicleSeat.currentPassengerBody)
            {
                base.vehicleSeat.EjectPassenger(currentPassengerBody.gameObject);
            }

            portalAnimator.SetTrigger("Transition");

            PassengerExitUnityEvent();
        }

        private void PassengerExitUnityEvent()
        {
            if (currentPassengerBody.hasEffectiveAuthority) 
            {
                new ForceSpawnStateNetworkRequest(currentPassengerBody.netId).Send(R2API.Networking.NetworkDestination.Clients);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (NetworkServer.active && (!base.vehicleSeat || !base.vehicleSeat.currentPassengerBody))
            {
                this.outer.SetNextStateToMain();
                base.vehicleSeat.onPassengerExitUnityEvent.RemoveListener(PassengerExitUnityEvent);
            }
        }
    }
}
