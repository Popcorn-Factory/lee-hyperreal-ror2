using EntityStates;
using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.SkillStates
{
    internal class LeeHyperrealSpawnState : BaseState
    {
        internal float duration = 7.5f;
        internal float moveCancelFrac = 0.8f;
        internal float fireFrac = 0.52f;
        internal bool hasFired;
        internal Vector3 blastPosition;

        public override void OnEnter()
        {
            base.OnEnter();
            blastPosition = transform.position;
            base.PlayAnimation("Body", "Stage Intro", "attack.playbackRate", duration);
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (fixedAge > duration * fireFrac && !hasFired) 
            {
                hasFired = true;
                new BlastAttack
                {
                    attacker = base.gameObject,
                    inflictor = null,
                    teamIndex = base.GetTeam(),
                    position = blastPosition,
                    radius = Modules.StaticValues.blueOrbBlastRadius,
                    falloffModel = BlastAttack.FalloffModel.None,
                    baseDamage = this.damageStat * Modules.StaticValues.blueOrbBlastRadius,
                    baseForce = 1000f,
                    bonusForce = Vector3.zero,
                    crit = this.RollCrit(),
                    damageType = DamageType.Generic,
                    losType = BlastAttack.LoSType.None,
                    canRejectForce = false,
                    procChainMask = new ProcChainMask(),
                    procCoefficient = 1f,
                }.Fire();
            }

            if (fixedAge >= duration * moveCancelFrac && base.isAuthority) 
            {
                if (inputBank.moveVector != Vector3.zero)
                {
                    outer.SetNextStateToMain();
                    return;
                }
            }

            if (fixedAge >= duration && base.isAuthority) 
            {
                outer.SetNextStateToMain();
                return;
            }
        }
        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
