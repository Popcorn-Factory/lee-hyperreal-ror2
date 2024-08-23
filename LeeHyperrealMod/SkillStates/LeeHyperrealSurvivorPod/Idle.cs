using EntityStates.SurvivorPod;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperrealSurvivorPod
{
    internal class Idle : SurvivorPodBaseState
    {
        public override void OnEnter()
        {
            base.OnEnter();
            base.vehicleSeat.handleVehicleExitRequestServer.AddCallback(new CallbackCheck<bool, GameObject>.CallbackDelegate(this.HandleVehicleExitRequest));
        }

        private void HandleVehicleExitRequest(GameObject arg, ref bool? resultOverride)
        {
            base.survivorPodController.exitAllowed = false;
            this.outer.SetNextState(new ExitPortal());
            resultOverride = new bool?(true);
        }

        public override void FixedUpdate()
        {
            if (base.fixedAge > 0.25f)
            {
                base.survivorPodController.exitAllowed = true;
            }
            base.FixedUpdate();
        }

        public override void OnExit()
        {
            base.vehicleSeat.handleVehicleExitRequestServer.RemoveCallback(new CallbackCheck<bool, GameObject>.CallbackDelegate(this.HandleVehicleExitRequest));
            base.survivorPodController.exitAllowed = false;
        }
    }
}
