using EntityStates;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.Networking;
using UnityEngine;
using RoR2;
using EntityStates.SurvivorPod;

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

            if (!base.survivorPodController)
            {
                return;
            }
            if (NetworkServer.active && base.vehicleSeat && base.vehicleSeat.currentPassengerBody)
            {
                base.vehicleSeat.EjectPassenger(currentPassengerBody.gameObject);
            }

            portalAnimator.SetTrigger("Transition");

            if (currentPassengerBody.hasEffectiveAuthority) 
            {
                currentPassengerBody.GetComponent<EntityStateMachine>().SetNextState(new LeeHyperrealSpawnState { });
            }
        }
        
        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (NetworkServer.active && (!base.vehicleSeat || !base.vehicleSeat.currentPassengerBody))
            {
                this.outer.SetNextStateToMain();
            }
        }
    }
}
