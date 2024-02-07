using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.YellowOrb
{
    internal class YellowOrbEntry : BaseSkillState
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

            if (base.isAuthority) 
            {
                if (bulletController.inSnipeStance)
                {
                    bulletController.UnsetSnipeStance();
                }

                //Domain state
                if (domainController.GetDomainState()) 
                {
                    if (moveStrength > 0)
                    {
                        //Set state accordingly.

                        //Grant stack if hitting the right amount
                        if (moveStrength == 3)
                        {
                            domainController.GrantIntuitionStack(1);
                            bulletController.GrantColouredBullet(BulletController.BulletType.YELLOW);
                        }
                        this.outer.SetState(new YellowOrbDomain { moveStrength = moveStrength });
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
                        this.outer.SetState(new YellowOrb { moveStrength = moveStrength });
                        if (moveStrength == 3)
                        { 
                            bulletController.GrantColouredBullet(BulletController.BulletType.YELLOW);
                        }
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
