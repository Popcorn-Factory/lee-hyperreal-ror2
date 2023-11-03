using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrbEntry : BaseSkillState
    {
        OrbController orbController;
        public int moveStrength;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();

            if (base.isAuthority) 
            {
                if (moveStrength > 0)
                {
                    this.outer.SetState(new RedOrb { moveStrength = moveStrength });
                    return;
                }
                else
                {
                    base.PlayAnimation("FullBody, Override", "BufferEmpty");
                    this.outer.SetNextStateToMain();
                    return;
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

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(this.moveStrength);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            this.moveStrength = reader.ReadInt32();
        }
    }
}
