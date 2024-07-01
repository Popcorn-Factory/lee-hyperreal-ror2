using EntityStates;
using LeeHyperrealMod.Content.Controllers;
using LeeHyperrealMod.Modules.Networking;
using LeeHyperrealMod.SkillStates.BaseStates;
using R2API.Networking.Interfaces;
using RoR2;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal.DomainShift
{
    internal class DomainEnterState : BaseRootMotionMoverState
    {
        private LeeHyperrealDomainController domainController;
        private WeaponModelHandler weaponModelHandler;
        private Vector3 aoePos;
        private float duration = 4.06f;
        private BlastAttack blastAttack;
        private BulletAttack bulletAttack;
        private float triggerBlastFrac = 0.16f;
        private bool hasFired;
        private float moveMagnitude = 10f;
        private float moveCancelFrac = 0.37f;
        private bool startedGrounded = false;

        private float groundedMovementFrac = 0.2f;
        private float groundedMovementMagnitude = 5f;
        private Vector3 groundedMovementDir;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.3f;

        public bool shouldForceUpwards;

        /*
        Domain shift
        Sets isDomain in domain controller
        Move player back slightly
        Play effect? 
            Effect should be handled in controller I guess lel
        Do shooting thing where you jumped from.
        AOE where you started the move
         */
        public override void OnEnter()
        {
            base.OnEnter();
            domainController = this.GetComponent<LeeHyperrealDomainController>();
            weaponModelHandler = this.GetComponent<WeaponModelHandler>();
            aoePos = this.gameObject.transform.position;

            bulletAttack = new BulletAttack
            {
                bulletCount = 1,
                // Calculate aim vector before firing 
                //aimVector = aimRay.direction,
                //origin = aimRay.origin,
                damage = Modules.StaticValues.domainShiftBulletDamageCoefficient * this.damageStat,
                damageColorIndex = DamageColorIndex.Default,
                damageType = DamageType.Generic,
                falloffModel = BulletAttack.FalloffModel.DefaultBullet,
                maxDistance = Modules.StaticValues.snipeRange,
                force = Modules.StaticValues.snipeForce,
                hitMask = LayerIndex.CommonMasks.bullet,
                minSpread = 0f,
                maxSpread = 0f,
                isCrit = base.RollCrit(),
                owner = base.gameObject,
                smartCollision = false,
                procChainMask = default(ProcChainMask),
                procCoefficient = Modules.StaticValues.snipeProcCoefficient,
                radius = 0.75f,
                sniper = false,
                stopperMask = LayerIndex.CommonMasks.bullet,
                weapon = null,
                spreadPitchScale = 0f,
                spreadYawScale = 0f,
                queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                hitEffectPrefab = Modules.ParticleAssets.transitionEffectHit,
            };

            blastAttack = new BlastAttack
            {
                attacker = base.gameObject,
                inflictor = null,
                teamIndex = TeamIndex.Player,
                position = aoePos,
                radius = Modules.StaticValues.domainShiftBlastRadius,
                falloffModel = BlastAttack.FalloffModel.Linear,
                baseDamage = this.damageStat * Modules.StaticValues.domainShiftCoefficient,
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = this.RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = 1f,

            };

            startedGrounded = isGrounded;

            groundedMovementDir = base.characterDirection.forward * -1f;


            //base.characterMotor.velocity = base.characterDirection.forward * -1f * moveMagnitude;
            PlayAnimation();

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            Transform baseTransform = childLocator.FindChild("BaseTransform");

            if (shouldForceUpwards) 
            {
                // Move 5 units back, 3 units up
                Vector3 newPosition = new Vector3(0,0,0);
                Vector3 direction = (base.characterDirection.forward * -1f) + (Vector3.up * 0.6f);
                float magnitude = Modules.StaticValues.forceUpwardsMagnitude;
                direction = direction.normalized;

                newPosition = base.gameObject.transform.position + (direction * magnitude);

                base.characterMotor.Motor.MoveCharacter(newPosition);
            }

            EffectData transitionEffect = new EffectData
            {
                origin = baseTransform.position,
                rotation = baseTransform.rotation,
                scale = 1.25f
            };

            if (base.isAuthority) 
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_ex_timestop").Send(R2API.Networking.NetworkDestination.Clients);
            }

            transitionEffect.SetChildLocatorTransformReference(gameObject, childLocator.FindChildIndex("BaseTransform"));

            EffectManager.SpawnEffect(Modules.ParticleAssets.transitionEffectLee,
                transitionEffect,
                true);

            weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.RIFLE);
            weaponModelHandler.SetLaserState(true);
        }

        public void PlayAnimation() 
        {
            base.PlayCrossfade("Body", "EnterDomainSnipe", "attack.playbackRate", duration, 0.03f);
        }

        public override void OnExit()
        {
            base.OnExit();

            base.characterMotor.gravityParameters = oldGravParams;
            base.PlayAnimation("Body", "BufferEmpty");
            if (weaponModelHandler.GetState() != WeaponModelHandler.WeaponState.SUBMACHINE)
            {
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
                weaponModelHandler.SetLaserState(false);
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();
        }

        public override void Update()
        {
            base.Update();

            if (base.age >= duration * turnOffGravityFrac)
            {
                base.characterMotor.gravityParameters = oldGravParams;
            }

            if (base.age >= duration * moveCancelFrac && base.isAuthority) 
            {
                if (inputBank.moveVector != Vector3.zero) 
                {
                    base.outer.SetNextStateToMain();
                    return;
                }
            }

            if (base.age >= duration * triggerBlastFrac && base.isAuthority) 
            {
                if (!hasFired) 
                {
                    hasFired = true;

                    bulletAttack.aimVector = (aoePos - base.gameObject.transform.position).normalized;
                    bulletAttack.origin = base.gameObject.transform.position;
                    //Spawn the effect for the bullet.
                    EffectManager.SpawnEffect(Modules.ParticleAssets.Snipe, 
                        new EffectData 
                        {
                            origin = bulletAttack.origin,
                            rotation = Quaternion.LookRotation(bulletAttack.aimVector),
                            scale = 1.25f,
                        },
                        true);
                    bulletAttack.Fire();
                    new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_ex_timestop_break").Send(R2API.Networking.NetworkDestination.Clients);


                    //Draw a ray to the ground and spawn a blast there too.
                    RaycastHit hit;
                    if (Physics.Raycast(transform.position, bulletAttack.aimVector, out hit, Mathf.Infinity, RoR2.LayerIndex.world.mask)) 
                    {
                        //Blast attack at position specified on hit.
                        blastAttack.position = hit.point;
                        BlastAttack.Result result = blastAttack.Fire();
                        if (result.hitCount > 0)
                        {
                            OnHitEnemyAuthority(result);
                        }

                        //Play Ground blast effect.
                        EffectManager.SpawnEffect(Modules.ParticleAssets.transitionEffectGround,
                            new EffectData
                            {
                                origin = hit.point,
                                scale = 1.5f,
                            },
                            true);
                    }


                    domainController.EnableDomain();
                    if (weaponModelHandler.GetState() != WeaponModelHandler.WeaponState.SUBMACHINE)
                    {
                        weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
                        weaponModelHandler.SetLaserState(false);
                    }
                }

            }

            if (base.age >= duration * 0.41f && base.isAuthority) 
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }

            if (base.age >= duration && base.isAuthority) 
            {
                base.outer.SetNextStateToMain();
            }
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            // Lock player into animation for a sizeable section of the skill
            if (base.age >= duration * 0.41f)
            {
                return InterruptPriority.Frozen;
            }
            else 
            {
                return InterruptPriority.Skill;
            }
            
        }

        public void OnHitEnemyAuthority(BlastAttack.Result result) 
        {
            foreach (BlastAttack.HitPoint hitPoint in result.hitPoints) 
            {
                EffectManager.SpawnEffect(Modules.ParticleAssets.transitionEffectHit, 
                    new EffectData 
                    {
                        origin = hitPoint.hitPosition,
                        scale = 2f
                    },
                    true);
            }
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(shouldForceUpwards);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            this.shouldForceUpwards = reader.ReadBoolean();
        }
    }
}
