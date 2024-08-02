using EntityStates;
using RoR2;
using LeeHyperrealMod.Content.Controllers;
using UnityEngine;
using LeeHyperrealMod.SkillStates.BaseStates;
using UnityEngine.Networking;
using R2API.Networking;
using LeeHyperrealMod.Modules.Networking;
using R2API.Networking.Interfaces;

namespace LeeHyperrealMod.SkillStates.LeeHyperreal
{
    internal class BlueOrb : BaseRootMotionMoverState
    {
        OrbController orbController;
        BulletController bulletController;
        WeaponModelHandler weaponModelHandler;
        LeeHyperrealDomainController domainController;

        public float start = 0;
        public float earlyEnd = 0.38f;
        public float fireFrac = 0.22f;
        public float duration = 3.83f;
        public int moveStrength; //1-3
        public bool hasFired;

        internal BlastAttack blastAttack;
        internal int attackAmount;
        internal float partialAttack;
        internal BulletAttack bulletAttack;

        public float defaultMovementMultiplier = 1.5f;
        public float backwardsMovementMultiplier = 0.75f;
        public float forwardsMovementMultiplier = 2f;
        private float movementMultiplier;

        CharacterGravityParameters gravParams;
        CharacterGravityParameters oldGravParams;
        float turnOffGravityFrac = 0.298f;

        float movespeedScalingCap = 15f;

        float disableInvincibility = 0.43f;

        float orbCancelFrac = 0.24f;

        float heldPrimaryDown = 0.1f;
        float disallowTransition = 0.26f;
        float heldDownTimer = 0f;
        bool forceTransition = false;

        Vector3 OriginalPosition;


        float transitionWeaponFrac = 0.35f;
        bool hasTransitioned = false;

        public override void OnEnter()
        {
            base.OnEnter();
            orbController = base.gameObject.GetComponent<OrbController>();
            bulletController = base.gameObject.GetComponent<BulletController>();
            weaponModelHandler = base.gameObject.GetComponent<WeaponModelHandler>();
            domainController = base.gameObject.GetComponent<LeeHyperrealDomainController>();

            if (orbController) 
            {
                orbController.isExecutingSkill = true;
            }

            rmaMultiplier = movementMultiplier;

            base.characterMotor.velocity.y = 0f;

            //For some reason these functions are not being run on other machines.

            bulletController.UnsetSnipeStance();
            //if (base.isAuthority) 
            //{
            //    bulletController.UnsetSnipeStance();
            //}

            if (moveStrength == 3 && isAuthority && !domainController.GetDomainState())
            {
                bulletController.GrantColouredBullet(BulletController.BulletType.BLUE);
            }
            if (moveStrength == 3 && domainController.GetDomainState())
            {
                domainController.GrantIntuitionStack(1);
                domainController.AddEnergy(Modules.StaticValues.energyReturnedPer3ping);
            }

            attackAmount = (int)this.attackSpeedStat;
            if (attackAmount < 1)
            {
                attackAmount = 1;
            }
            partialAttack = (float)(this.attackSpeedStat - (float)attackAmount);

            OriginalPosition = base.gameObject.transform.position;

            blastAttack = new BlastAttack
            {
                attacker = base.gameObject,
                inflictor = null,
                teamIndex = base.GetTeam(),
                position = base.gameObject.transform.position + (GetAimRay().direction * 2.5f),
                radius = (moveStrength == 3 ? Modules.StaticValues.blueOrbTripleMultiplier : 1) * Modules.StaticValues.blueOrbBlastRadius,
                falloffModel = BlastAttack.FalloffModel.None,
                baseDamage = this.damageStat * Modules.StaticValues.blueOrbBlastRadius * (moveStrength == 3 ? Modules.StaticValues.blueOrbTripleMultiplier : 1),
                baseForce = 0f,
                bonusForce = Vector3.zero,
                crit = this.RollCrit(),
                damageType = DamageType.Generic,
                losType = BlastAttack.LoSType.None,
                canRejectForce = false,
                procChainMask = new ProcChainMask(),
                procCoefficient = 1f,
                impactEffect = EffectCatalog.FindEffectIndexFromPrefab(Modules.ParticleAssets.blueOrbHit)
            };


            //aimVector = aimRay.direction,
            //    origin = aimRay.origin,
            bulletAttack = new BulletAttack
            {
                bulletCount = (uint)attackAmount,
                damage = Modules.StaticValues.blueOrbShotCoefficient * this.damageStat,
                damageColorIndex = DamageColorIndex.Default,
                damageType = DamageType.Generic,
                falloffModel = BulletAttack.FalloffModel.DefaultBullet,
                maxDistance = Shoot.range,
                force = Shoot.force,
                hitMask = LayerIndex.CommonMasks.bullet,
                minSpread = 0f,
                maxSpread = 0f,
                isCrit = base.RollCrit(),
                owner = base.gameObject,
                muzzleName = "RifleEnd",
                smartCollision = false,
                procChainMask = default(ProcChainMask),
                procCoefficient = Modules.StaticValues.blueOrbProcCoefficient,
                radius = 0.75f,
                sniper = false,
                stopperMask = LayerIndex.CommonMasks.bullet,
                weapon = null,
                spreadPitchScale = 0f,
                spreadYawScale = 0f,
                queryTriggerInteraction = QueryTriggerInteraction.UseGlobal,
                hitEffectPrefab = Modules.ParticleAssets.blueOrbHit,
            };

            base.characterDirection.forward = inputBank.aimDirection;
            base.characterDirection.moveVector = inputBank.aimDirection;

            PlayAttackAnimation();

            oldGravParams = base.characterMotor.gravityParameters;
            gravParams = new CharacterGravityParameters();
            gravParams.environmentalAntiGravityGranterCount = 1;
            gravParams.channeledAntiGravityGranterCount = 1;

            characterMotor.gravityParameters = gravParams;

            rmaMultiplier = base.moveSpeedStat < movespeedScalingCap ? moveSpeedStat / 10f : movespeedScalingCap / 10f;

            if (rmaMultiplier < movementMultiplier) 
            {
                rmaMultiplier = movementMultiplier;
            }

            if (NetworkServer.active) 
            {
                base.characterBody.AddTimedBuff(Modules.Buffs.invincibilityBuff, duration * disableInvincibility);
            }

            if (base.isAuthority) 
            {
                new PlaySoundNetworkRequest(characterBody.netId, "Play_c_liRk4_skill_blue_shine").Send(NetworkDestination.Clients);
            }

            
            weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.RIFLE);
            weaponModelHandler.SetLaserState(true);
        }

        protected void PlayAttackAnimation()
        {
            base.PlayAnimation("Body", "blueOrb", "attack.playbackRate", duration);
        }

        public override void OnExit()
        {
            if (orbController)
            {
                orbController.isExecutingSkill = false;
            }
            base.characterMotor.gravityParameters = oldGravParams;
            if (NetworkServer.active)
            {
                base.characterBody.ClearTimedBuffs(Modules.Buffs.invincibilityBuff);
            }
            PlayAnimation("Body", "BufferEmpty");
            base.OnExit();

            if (weaponModelHandler.GetState() != WeaponModelHandler.WeaponState.SUBMACHINE) 
            {
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
                weaponModelHandler.SetLaserState(false);
            }
        }

        public override void Update()
        {
            if (base.isAuthority)
            {
                Vector3 forwardDirection = GetAimRay().direction;
                Vector3 backwardsDirection = forwardDirection * -1f;

                movementMultiplier = defaultMovementMultiplier;

                if (inputBank.moveVector == Vector3.zero)
                {
                    movementMultiplier = defaultMovementMultiplier;
                }
                else if (Vector3.Dot(backwardsDirection, inputBank.moveVector) >= 0.833f)
                {
                    movementMultiplier = backwardsMovementMultiplier;
                }
                else if (Vector3.Dot(forwardDirection, inputBank.moveVector) >= 0.833f)
                {
                    movementMultiplier = forwardsMovementMultiplier;
                }

                rmaMultiplier = movementMultiplier;
            }

            base.Update();

            if (base.age >= duration * transitionWeaponFrac && !hasTransitioned) 
            {
                hasTransitioned = true;
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
                weaponModelHandler.SetLaserState(false);
            }

            if (base.inputBank.skill1.down && base.isAuthority && base.age <= duration * disallowTransition)
            {
                heldDownTimer += Time.deltaTime;
                if (heldDownTimer > heldPrimaryDown && domainController.DomainEntryAllowed()) 
                {
                    //execute transition to domain... later.
                    forceTransition = true;
                }
            }
            else if (!base.inputBank.skill1.down && base.isAuthority) 
            {
                heldDownTimer = 0f;
            }

            if (base.age >= duration * disallowTransition && forceTransition && base.isAuthority) 
            {
                this.outer.SetNextState(new DomainShift.DomainEnterState { shouldForceUpwards = false });
                return;// disallow other stuff from running lol.
            }


            if (base.inputBank.skill3.down && base.inputBank.skill4.down && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (base.age >= duration * orbCancelFrac && base.isAuthority) 
            {
                if (orbController)
                {
                    orbController.isExecutingSkill = false;
                }
            }
            if (base.age >= duration * earlyEnd && base.isAuthority)
            {
                if (inputBank.moveVector != new Vector3()) 
                {
                    //Cancel
                    base.outer.SetNextStateToMain();
                    return;
                }
                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }


            if (base.age >= duration * turnOffGravityFrac)
            {
                base.characterMotor.gravityParameters = oldGravParams;
            }
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            //Able to be cancelled after this.
            

            if (base.fixedAge >= duration * fireFrac && base.isAuthority) 
            {
                if (!hasFired) 
                {
                    hasFired = true;
                    FireAttack();
                }
            }



            if (base.fixedAge >= duration)
            {
                this.outer.SetNextStateToMain();
                return;
            }
        }

        public void FireAttack()
        {
            if (!base.isAuthority) 
            {
                return;
            }
            ModelLocator component = base.modelLocator;
            Transform muzzlePos = null;
            if (component && component.modelTransform)
            {
                ChildLocator component2 = component.modelTransform.GetComponent<ChildLocator>();
                if (component2)
                {
                    muzzlePos = component2.FindChild(bulletAttack.muzzleName);
                }
            }

            bulletAttack.aimVector = ((OriginalPosition - muzzlePos.position).normalized + Vector3.down * 0.4f).normalized;
            bulletAttack.origin = muzzlePos.position;
            bulletAttack.Fire();

            EffectData effectData = new EffectData
            {
                origin = muzzlePos.position + Vector3.down * 2f,
                rotation = Quaternion.LookRotation(((OriginalPosition - muzzlePos.position).normalized + Vector3.down * 0.4f).normalized, Vector3.up),
            };
            EffectManager.SpawnEffect(Modules.ParticleAssets.blueOrbShot, effectData, true);

            //Calculate position where the floor is from where we are.
            RaycastHit hit;
            if (Physics.Raycast(muzzlePos.position, bulletAttack.aimVector, out hit, Mathf.Infinity, LayerIndex.world.mask))
            {
                EffectData BlueOrbGroundEffectData = new EffectData
                {
                    scale = 2f
                };
                EffectManager.SimpleEffect(Modules.ParticleAssets.blueOrbGroundHit, hit.point, Quaternion.identity, true);
            }

            for (int i = 0; i < attackAmount; i++) 
            {
                blastAttack.position = hit.point;
                BlastAttack.Result result = blastAttack.Fire();

                if (result.hitCount > 0) 
                {
                    OnHitEnemyAuthority();
                }
            }

            if (partialAttack > 0f) 
            {
                blastAttack.baseDamage = blastAttack.baseDamage * partialAttack;
                blastAttack.procCoefficient = blastAttack.procCoefficient * partialAttack;
                blastAttack.radius = blastAttack.radius * partialAttack;
                blastAttack.baseForce = blastAttack.baseForce * partialAttack;

                BlastAttack.Result result = blastAttack.Fire();

                if (result.hitCount > 0)
                {
                    OnHitEnemyAuthority();
                }
            }
        }

        public void OnHitEnemyAuthority() 
        {
            //Do something on hit.
        }

        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
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
