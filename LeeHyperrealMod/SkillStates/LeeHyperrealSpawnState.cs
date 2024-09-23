using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.SkillStates.BaseStates;
using RoR2;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UIElements.UIR;
using static LeeHyperrealMod.Content.Controllers.WeaponModelHandler;

namespace LeeHyperrealMod.SkillStates
{
    internal class LeeHyperrealSpawnState : BaseRootMotionMoverState
    {
        internal float duration = 7.5f;
        internal float enableModel = 0.39f;
        internal float moveCancelFrac = 0.8f;
        internal float fireFrac = 0.52f;
        internal float weaponTransition = 0.55f;
        internal float gravityOff = 0.6f;
        internal float aimModeFrac = 0.35f;
        internal bool modelSpawned;
        internal bool hasWeaponTransitioned;
        internal bool hasFired;
        internal Vector3 blastPosition;
        internal WeaponModelHandler weaponModelHandler;
        internal CharacterGravityParameters oldGravParams;
        internal CharacterGravityParameters gravParams;

        public override void OnEnter()
        {
            base.OnEnter();
            weaponModelHandler = gameObject.GetComponent<WeaponModelHandler>();
            rmaMultiplier = 1f;
            blastPosition = transform.position;

            weaponModelHandler.TransitionState(WeaponState.SUBMACHINE, false);
            weaponModelHandler.SetStateForModelAndSubmachine(false);
            base.PlayAnimation("Body", "Stage Intro", "attack.playbackRate", duration);
            Util.PlaySound("Play_Stage_Intro", gameObject.transform.GetChild(0).gameObject);

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;

            if (NetworkServer.active)
            {
                //Set Invincibility cause fuck you.
                characterBody.SetBuffCount(Modules.Buffs.invincibilityBuff.buffIndex, 1);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
            if (fixedAge <= duration * aimModeFrac)
            {
                base.characterDirection.forward = inputBank.aimDirection;
                base.characterDirection.moveVector = inputBank.aimDirection;
            }

            if (fixedAge >= duration * enableModel && !modelSpawned) 
            {
                modelSpawned = true;

                weaponModelHandler.SetStateForModelAndSubmachine(true);
                weaponModelHandler.TransitionState(WeaponState.RIFLE);
            }

            if (fixedAge >= duration * gravityOff) 
            {
                base.characterMotor.gravityParameters = oldGravParams;
            }

            if (fixedAge > duration * fireFrac && !hasFired) 
            {
                hasFired = true;

                if (base.isAuthority)
                {
                    ModelLocator component = base.modelLocator;
                    Transform muzzlePos = null;
                    if (component && component.modelTransform)
                    {
                        ChildLocator component2 = component.modelTransform.GetComponent<ChildLocator>();
                        if (component2)
                        {
                            muzzlePos = component2.FindChild("RifleTip");
                        }
                    }

                    EffectData effectData = new EffectData
                    {
                        origin = muzzlePos.position,
                        rotation = Quaternion.LookRotation(((blastPosition - muzzlePos.position).normalized + Vector3.down * 0.35f).normalized, Vector3.up),
                    };
                    EffectManager.SpawnEffect(Modules.ParticleAssets.blueOrbShot, effectData, true);

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
                        attackerFiltering = AttackerFiltering.NeverHitSelf
                    }.Fire();
                }
            }

            if (fixedAge >= duration * weaponTransition && !hasWeaponTransitioned) 
            {
                hasWeaponTransitioned = true;
                weaponModelHandler.TransitionState(WeaponState.SUBMACHINE);
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

        public override void OnExit()
        {
            base.OnExit();
            base.characterMotor.gravityParameters = oldGravParams;
            if (NetworkServer.active) 
            {
                characterBody.SetBuffCount(Modules.Buffs.invincibilityBuff.buffIndex, 0);
            }

            if (weaponModelHandler && !hasWeaponTransitioned) 
            {
                weaponModelHandler.TransitionState(WeaponState.SUBMACHINE);
            }

            if (weaponModelHandler && !modelSpawned) 
            {
                weaponModelHandler.SetStateForModelAndSubmachine(true);
            }
        }
        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Frozen;
        }
    }
}
