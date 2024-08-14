using EntityStates;

namespace LeeHyperrealMod.SkillStates
{
    internal class LeeHyperrealSpawnState : BaseState
    {
        internal float duration = 3.66f;

        public override void OnEnter()
        {
            base.OnEnter();
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (fixedAge >= duration && base.isAuthority) 
            {
                base.outer.SetNextStateToMain();
            }
        }
        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
