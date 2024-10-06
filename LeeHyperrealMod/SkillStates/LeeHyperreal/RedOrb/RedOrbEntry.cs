using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.RedOrb
{
    internal class RedOrbEntry : BaseSkillState
    {
        LeeHyperrealDomainController domainController;
        OrbController orbController;
        BulletController bulletController;
        public int moveStrength;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();
            domainController = base.gameObject.GetComponent<LeeHyperrealDomainController>();
            bulletController = base.gameObject.GetComponent<BulletController>();
            characterMotor.velocity.y = 0f;

            if (bulletController.inSnipeStance)
            {
                bulletController.UnsetSnipeStance();
            }

            if (base.isAuthority) 
            {
                if (orbController)
                {
                    orbController.isExecutingSkill = true;
                }

                if (domainController.GetDomainState())
                {
                    if (moveStrength > 0)
                    {
                        //Set state accordingly.

                        //Grant stack if hitting the right amount
                        if (moveStrength >= 3)
                        {
                            domainController.GrantIntuitionStack(1);
                            domainController.AddEnergy(Modules.StaticValues.energyReturnedPer3ping);
                        }
                        this.outer.SetNextState(new RedOrbDomain { moveStrength = moveStrength });
                        return;
                    }
                    else
                    {
                        base.PlayAnimation("Body", "BufferEmpty");
                        this.outer.SetNextStateToMain();
                        return;
                    }
                }
                else 
                {
                    if (moveStrength > 0)
                    {
                        if (moveStrength >= 3)
                        {
                            bulletController.GrantColouredBullet(BulletController.BulletType.RED);
                        }
                        this.outer.SetNextState(new RedOrb { moveStrength = moveStrength });

 
                        return;
                    }
                    else
                    {
                        base.PlayAnimation("Body", "BufferEmpty");
                        this.outer.SetNextStateToMain();
                        return;
                    }
                }
            }
        }

        public override void OnExit()
        {
            base.OnExit();
            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
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
