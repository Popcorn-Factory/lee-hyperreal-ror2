using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.Ultimate
{
    internal class UltimateEntry : EntityState
    {
        LeeHyperrealDomainController domainController;

        public override void OnEnter()
        {
            base.OnEnter();
            domainController = base.gameObject.GetComponent<LeeHyperrealDomainController>();

            if (base.isAuthority)
            {
                if (base.outer.state.GetMinimumInterruptPriority() != EntityStates.InterruptPriority.Death)
                {
                    if (domainController.GetDomainState())
                    {
                        this.outer.SetNextState(new UltimateDomain());
                    }
                    else
                    {
                        this.outer.SetNextState(new Ultimate());
                    }
                }
            }
        }

        public override void OnExit()
        {
            base.OnExit();
        }

        public override void Update()
        {
            base.Update();
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }

    }
}
