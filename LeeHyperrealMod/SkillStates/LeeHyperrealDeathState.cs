﻿using EntityStates;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates
{
    internal class LeeHyperrealDeathState : GenericCharacterDeath
    {
        internal float triggerRagdollFrac = 0.97f;
        internal bool triggeredRagdoll = false;
        internal float duration = 3.66f;


        public override void OnEnter()
        {
            base.OnEnter();

            base.PlayAnimation("Death", "FullBody, Override", "attack.playbackRate", duration);
        }

        public override bool shouldAutoDestroy
        {
            get
            {
                return false;
            }
        }

        public void TriggerRagdoll()
        {
            triggeredRagdoll = true;
            Vector3 vector = Vector3.up * 3f;
            if (base.characterMotor)
            {
                vector += base.characterMotor.velocity;
                base.characterMotor.enabled = false;
            }
            if (base.cachedModelTransform)
            {
                RagdollController component = base.cachedModelTransform.GetComponent<RagdollController>();
                if (component)
                {
                    component.BeginRagdoll(Vector3.zero);
                }
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (base.fixedAge > duration * triggerRagdollFrac)
            {
                TriggerRagdoll();
            }

            if (base.fixedAge > duration) 
            {
                if (!triggeredRagdoll) 
                {
                    TriggerRagdoll();
                }
            }

            if (NetworkServer.active && base.fixedAge > 8f)
            {
                EntityState.Destroy(base.gameObject);
            }
        }
        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Death;
        }
    }
}