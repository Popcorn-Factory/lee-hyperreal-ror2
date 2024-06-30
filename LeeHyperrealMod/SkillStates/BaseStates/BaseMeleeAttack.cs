using EntityStates;
using RoR2.CharacterAI;
using LeeHyperrealMod.Content.Controllers;
using R2API.Networking;
using RoR2;
using RoR2.Audio;
using System;
using UnityEngine;
using UnityEngine.Networking;
using LeeHyperrealMod.Modules.Networking;
using LeeHyperrealMod.Modules;
using R2API.Networking.Interfaces;
using System.Collections.Generic;
using System.Linq;
using RoR2.Projectile;
using UnityEngine.UIElements;

namespace LeeHyperrealMod.SkillStates.BaseStates
{
    public class BaseMeleeAttack : BaseSkillState
    {
        public int swingIndex;

        protected string hitboxName = "Sword";

        protected DamageType damageType = DamageType.Generic;
        protected float damageCoefficient = 3.5f;
        protected float procCoefficient = 1f;
        protected float pushForce = 300f;
        protected Vector3 bonusForce = Vector3.zero;
        protected float baseDuration = 1f;
        protected float attackStartTime = 0.02f;
        protected float attackEndTime = 0.4f;
        protected float baseEarlyExitTime = 0.4f;
        protected float hitStopDuration = 0.012f;
        protected float attackRecoil = 0.75f;
        protected float hitHopVelocity = 4f;
        protected bool cancelled = false;
        protected float moveCancelEndTime = 0.41f;

        protected string swingSoundString = "";
        protected string hitSoundString = "";
        protected string muzzleString = "SwingCenter";
        protected GameObject swingEffectPrefab;
        protected GameObject hitEffectPrefab;
        protected NetworkSoundEventIndex impactSound;

        private float earlyExitTime;
        public float bufferActiveTime;
        public float duration;
        private bool hasFired;
        private float hitPauseTimer;
        private OverlapAttack attack;
        protected bool inHitPause;
        private bool hasHopped;
        protected float stopwatch;
        protected Animator animator;
        private BaseState.HitStopCachedState hitStopCachedState;
        private Vector3 storedVelocity;

        internal int attackAmount;
        private float partialAttack;
        private HitBoxGroup hitBoxGroup;
        internal OrbController orbController;

        internal bool enableParry;
        internal float parryLength;
        internal float parryTiming;
        internal float parryProjectileTiming;
        internal float parryProjectileTimingEnd;
        internal bool parryTriggered;
        internal float parryPauseLength = 0.75f;
        internal ParryMonitor parryMonitor;
        internal bool parryFreeze;
        internal Collider[] targetList;

        internal BulletController bulletController;

        internal bool bufferTriggerNextState;

        public float xzMovementMultiplier = 1f;

        internal float swingScale = 1.25f;

        public Transform ParryTransform = null;


        public override void OnEnter()
        {
            base.OnEnter();
            parryMonitor = base.gameObject.GetComponent<ParryMonitor>();
            orbController = base.gameObject.GetComponent<OrbController>();
            bulletController = base.gameObject.GetComponent<BulletController>();
            this.duration = this.baseDuration / 1f; //this.attackSpeedStat;
            this.earlyExitTime = this.baseEarlyExitTime / 1f; //this.attackSpeedStat;
            this.hasFired = false;
            this.animator = base.GetModelAnimator();
            base.characterBody.outOfCombatStopwatch = 0f;
            this.animator.SetBool("attacking", true);
            this.animator.SetFloat("attack.playbackRate", 1f);

            attackAmount = (int)this.attackSpeedStat;
            if (attackAmount < 1) 
            {
                attackAmount = 1;
            }
            partialAttack = (float)(this.attackSpeedStat - (float)attackAmount);


            hitBoxGroup = null;
            Transform modelTransform = base.GetModelTransform();

            if (modelTransform)
            {
                hitBoxGroup = Array.Find<HitBoxGroup>(modelTransform.GetComponents<HitBoxGroup>(), (HitBoxGroup element) => element.groupName == this.hitboxName);
            }

            this.PlayAttackAnimation();

            //base.StartAimMode(this.duration, true);
            this.characterDirection.moveVector = base.inputBank.aimDirection;
            this.characterDirection.forward = base.inputBank.aimDirection;

        }

        protected virtual void PlayAttackAnimation()
        {
            base.PlayCrossfade("Gesture, Override", "Slash" + (1 + swingIndex), "attack.playbackRate", this.duration, 0.05f);
        }

        private void Deflect()
        {
            Vector3 parryPosition = base.gameObject.transform.position + (characterDirection.forward + Vector3.up * 1f) * 2f;
            if (ParryTransform) 
            {
                parryPosition = ParryTransform.position;
            }
            Collider[] array = Physics.OverlapSphere(parryPosition, Modules.StaticValues.parryProjectileRadius, LayerIndex.projectile.mask);

            for (int i = 0; i < array.Length; i++)
            {
                ProjectileController pc = array[i].GetComponentInParent<ProjectileController>();
                if (pc)
                {
                    if (pc.owner != gameObject)
                    {
                        Ray aimRay = base.GetAimRay();

                        pc.owner = gameObject;

                        FireProjectileInfo info = new FireProjectileInfo()
                        {
                            projectilePrefab = pc.gameObject,
                            position = pc.gameObject.transform.position,
                            rotation = Util.QuaternionSafeLookRotation(aimRay.direction),
                            owner = base.characterBody.gameObject,
                            damage = base.characterBody.damage * Modules.StaticValues.parryProjectileDamageMultiplier,
                            force = 200f,
                            crit = base.RollCrit(),
                            damageColorIndex = DamageColorIndex.Default,
                            target = null,
                            speedOverride = 120f,
                            fuseOverride = -1f
                        };
                        ProjectileManager.instance.FireProjectile(info);

                        new PlaySoundNetworkRequest(characterBody.netId, "Play_Normal_parry").Send(NetworkDestination.Clients);
                        EffectManager.SpawnEffect(Modules.ParticleAssets.normalParry,
                            new EffectData
                            {
                                origin = parryPosition,
                                scale = 2f,
                                rotation = Quaternion.LookRotation(GetAimRay().direction.normalized, Vector3.up)
                            },
                            true);

                        bulletController.GrantEnhancedBullet(Modules.StaticValues.enhancedBulletGrantOnProjectileParry);
                        Destroy(pc.gameObject);
                    }
                }
            }
        }

        public override void OnExit()
        {
            if (!this.hasFired && !this.cancelled) this.FireAttack();

            //base.characterBody.ApplyBuff(Modules.Buffs.parryBuff.buffIndex, 0);
            parryMonitor.SetPauseTrigger(false);

            base.OnExit();

            this.characterBody.SetAimTimer(0);
            this.animator.SetBool("attacking", false);
        }

        protected virtual void PlaySwingEffect()
        {
            if (swingEffectPrefab) 
            {
                ModelLocator component = gameObject.GetComponent<ModelLocator>();
                if (component && component.modelTransform)
                {
                    ChildLocator component2 = component.modelTransform.GetComponent<ChildLocator>();
                    if (component2)
                    {
                        int childIndex = component2.FindChildIndex(muzzleString);
                        Transform transform = component2.FindChild(childIndex);
                        if (transform)
                        {
                            EffectData effectData = new EffectData
                            {
                                origin = transform.position,
                                scale = swingScale,
                            };
                            effectData.SetChildLocatorTransformReference(gameObject, childIndex);
                            EffectManager.SpawnEffect(swingEffectPrefab, effectData, true);
                        }
                    }
                }

            }
            //EffectManager.SimpleMuzzleFlash(this.swingEffectPrefab, base.gameObject, this.muzzleString, true);
        }

        protected virtual void OnHitEnemyAuthority()
        {
            Util.PlaySound(this.hitSoundString, base.gameObject);

            if (!this.hasHopped)
            {
                if (base.characterMotor && !base.characterMotor.isGrounded && this.hitHopVelocity > 0f)
                {
                    base.SmallHop(base.characterMotor, this.hitHopVelocity);
                }

                this.hasHopped = true;
            }

            if (!this.inHitPause && this.hitStopDuration > 0f)
            {
                this.storedVelocity = base.characterMotor.velocity;
                this.hitStopCachedState = base.CreateHitStopCachedState(base.characterMotor, this.animator, "attack.playbackRate");
                this.hitPauseTimer = this.hitStopDuration / this.attackSpeedStat;
                this.inHitPause = true;
            }
        }

        internal virtual void TriggerHitPause(float duration) 
        {
            if (!this.inHitPause && this.hitStopDuration > 0f)
            {
                this.storedVelocity = base.characterMotor.velocity;
                this.hitStopCachedState = base.CreateHitStopCachedState(base.characterMotor, this.animator, "attack.playbackRate");
                this.hitPauseTimer = duration;
                this.inHitPause = true;
            }
        }

        public void TriggerEnemyFreeze()
        {
            if (!parryFreeze)
            {
                //set the parryFreeze so we don't need to freeze/unfreeze everything every frame.
                parryFreeze = true;

                BullseyeSearch search = new BullseyeSearch
                {
                    teamMaskFilter = TeamMask.GetEnemyTeams(characterBody.teamComponent.teamIndex),
                    filterByLoS = false,
                    searchOrigin = characterBody.corePosition,
                    searchDirection = UnityEngine.Random.onUnitSphere,
                    sortMode = BullseyeSearch.SortMode.Distance,
                    maxDistanceFilter = 100f,
                    maxAngleFilter = 360f
                };

                search.RefreshCandidates();
                search.FilterOutGameObject(characterBody.gameObject);

                List<HurtBox> target = search.GetResults().ToList<HurtBox>();
                foreach (HurtBox singularTarget in target)
                {
                    if (singularTarget.healthComponent && singularTarget.healthComponent.body)
                    {
                        //stop time for all enemies within this radius

                        new SetFreezeOnBodyRequest(singularTarget.healthComponent.body.masterObjectId, StaticValues.bigParryFreezeDuration).Send(NetworkDestination.Clients);
                    }
                }
            }

        }

        private void FireAttack()
        {
            if (!this.hasFired)
            {
                this.hasFired = true;
                Util.PlayAttackSpeedSound(this.swingSoundString, base.gameObject, this.attackSpeedStat);

                if (base.isAuthority)
                {
                    this.PlaySwingEffect();
                    base.AddRecoil(-1f * this.attackRecoil, -2f * this.attackRecoil, -0.5f * this.attackRecoil, 0.5f * this.attackRecoil);
                    for (int i = 0; i < attackAmount; i++)
                    {
                        // Create Attack, fire it, do the on hit enemy authority.
                        this.attack = new OverlapAttack();
                        this.attack.damageType = this.damageType;
                        this.attack.attacker = base.gameObject;
                        this.attack.inflictor = base.gameObject;
                        this.attack.teamIndex = base.GetTeam();
                        this.attack.damage = this.damageCoefficient * this.damageStat;
                        this.attack.procCoefficient = this.procCoefficient;
                        this.attack.hitEffectPrefab = this.hitEffectPrefab;
                        this.attack.forceVector = this.bonusForce / attackAmount;
                        this.attack.pushAwayForce = this.pushForce / attackAmount;
                        this.attack.hitBoxGroup = hitBoxGroup;
                        this.attack.isCrit = base.RollCrit();
                        this.attack.impactSound = this.impactSound;
                        if (this.attack != null) 
                        {
                            if (this.attack.Fire())
                            {
                                this.OnHitEnemyAuthority();
                            }
                        }
                    }
                    if (partialAttack > 0.0f) 
                    {
                        // Create Attack, fire it, do the on hit enemy authority, partaial damage on final 
                        this.attack = new OverlapAttack();
                        this.attack.damageType = this.damageType;
                        this.attack.attacker = base.gameObject;
                        this.attack.inflictor = base.gameObject;
                        this.attack.teamIndex = base.GetTeam();
                        this.attack.damage = this.damageCoefficient * this.damageStat * partialAttack;
                        this.attack.procCoefficient = this.procCoefficient * partialAttack;
                        this.attack.hitEffectPrefab = this.hitEffectPrefab;
                        this.attack.forceVector = this.bonusForce * partialAttack / attackAmount;
                        this.attack.pushAwayForce = this.pushForce * partialAttack / attackAmount;
                        this.attack.hitBoxGroup = hitBoxGroup;
                        this.attack.isCrit = base.RollCrit();
                        this.attack.impactSound = this.impactSound;
                        if (this.attack != null)
                        {
                            if (this.attack.Fire())
                            {
                                this.OnHitEnemyAuthority();
                            }
                        }
                    }
                }
            }
        }

        protected virtual void SetNextState()
        {
            int index = this.swingIndex;
            if (index == 0) index = 1;
            else index = 0;

            this.outer.SetNextState(new BaseMeleeAttack
            {
                swingIndex = index
            });
        }

        public override void FixedUpdate()
        {
            base.FixedUpdate();

            this.hitPauseTimer -= Time.fixedDeltaTime;

            if (enableParry)
            {
                if (this.stopwatch >= duration * parryProjectileTiming && base.isAuthority && this.stopwatch <= this.duration * parryProjectileTimingEnd) 
                {
                    Deflect();
                }
                if (this.stopwatch >= this.duration * parryTiming && base.isAuthority && !parryTriggered) 
                {
                    parryTriggered = true;
                    base.characterBody.ApplyBuff(Modules.Buffs.parryBuff.buffIndex, 1, parryLength);
                }

                if (base.isAuthority && parryMonitor.GetPauseTrigger()) 
                {
                    //Check the parry monitor, if at any time it's enabled trigger the pause.
                    //Consume value.
                    parryMonitor.SetPauseTrigger(false);
                    //Trigger the hitpause.

                    if (parryMonitor.ShouldDoBigParry)
                    {
                        parryMonitor.ShouldDoBigParry = false;
                        //Determine if it's big pause or not.
                        TriggerHitPause(1.2f);
                        TriggerEnemyFreeze();
                        Vector3 position = base.gameObject.transform.position + (characterDirection.forward + Vector3.up * 1f) * 2f;
                        new PlaySoundNetworkRequest(characterBody.netId, "Play_Big_parry").Send(NetworkDestination.Clients);
                        if (ParryTransform) 
                        {
                            position = ParryTransform.position;
                        }
                        EffectManager.SpawnEffect(Modules.ParticleAssets.bigParry, 
                            new EffectData 
                            { 
                                origin = position, 
                                scale = 2f 
                            }, true);
                    }
                    else 
                    {
                        TriggerHitPause(parryPauseLength);

                        new PlaySoundNetworkRequest(characterBody.netId, "Play_Normal_parry").Send(NetworkDestination.Clients);
                        Vector3 position = base.gameObject.transform.position + (characterDirection.forward + Vector3.up * 1f) * 2f;

                        if (ParryTransform)
                        {
                            position = ParryTransform.position;
                        }
                        EffectManager.SpawnEffect(Modules.ParticleAssets.normalParry, 
                            new EffectData 
                            { 
                                origin = position, 
                                scale = 2f, 
                                rotation = Quaternion.LookRotation(GetAimRay().direction.normalized, Vector3.up) 
                            }, 
                            true);
                    }

                    bulletController.GrantEnhancedBullet(Modules.StaticValues.enhancedBulletGrantOnDamageParry);
                }
            }

            if (this.hitPauseTimer <= 0f && this.inHitPause)
            {
                base.ConsumeHitStopCachedState(this.hitStopCachedState, base.characterMotor, this.animator);
                this.inHitPause = false;
                base.characterMotor.velocity = this.storedVelocity;
            }

            if (!this.inHitPause)
            {
                this.stopwatch += Time.fixedDeltaTime;
            }
            else
            {
                if (base.characterMotor) base.characterMotor.velocity = Vector3.zero;
                if (this.animator) this.animator.SetFloat("attack.playbackRate", 0f);
            }

            if (this.stopwatch >= (this.duration * this.attackStartTime) && this.stopwatch <= (this.duration * this.attackEndTime))
            {
                this.FireAttack();
            }

            if (this.stopwatch >= this.duration && base.isAuthority)
            {
                this.outer.SetNextStateToMain();
                return;
            }
        }


        public override void Update()
        {
            base.Update();

            if (base.inputBank.skill3.down && base.inputBank.skill4.down && base.isAuthority)
            {
                Modules.BodyInputCheckHelper.CheckForOtherInputs(skillLocator, isAuthority, inputBank);
            }

            if (this.stopwatch >= (this.duration * this.bufferActiveTime) && base.isAuthority) 
            {
                if (base.inputBank.skill1.down) 
                {
                    bufferTriggerNextState = true;
                }
            }
            
            if (this.stopwatch >= (this.duration * this.earlyExitTime) && base.isAuthority)
            {
                //Check this first.
                if (base.inputBank.skill1.down || bufferTriggerNextState)
                {
                    if (!this.hasFired) this.FireAttack();
                    this.SetNextState();
                    return;
                }

                Modules.BodyInputCheckHelper.CheckForOtherInputs(base.skillLocator, isAuthority, base.inputBank);
            }

            if (this.stopwatch >= (this.duration * this.moveCancelEndTime) && base.isAuthority) 
            {
                if (base.inputBank.moveVector != new Vector3(0, 0, 0)) 
                {
                    if (!this.hasFired) this.FireAttack();
                    this.outer.SetNextStateToMain();
                    return;
                }
            }
        }


        public override InterruptPriority GetMinimumInterruptPriority()
        {
            return InterruptPriority.Skill;
        }

        public override void OnSerialize(NetworkWriter writer)
        {
            base.OnSerialize(writer);
            writer.Write(this.swingIndex);
            writer.Write(this.xzMovementMultiplier);
        }

        public override void OnDeserialize(NetworkReader reader)
        {
            base.OnDeserialize(reader);
            this.swingIndex = reader.ReadInt32();
            this.xzMovementMultiplier = reader.ReadSingle();
        }

        //Plan
        // Just fucking copy the goddamn code from enforcer to clone prefabs to fire back at enemies etc.
        // Grant buff in specified window and any hits received in this buff window should trigger the "pause"
        // the pause is just gonna be a fucking hitstop cache and negate damage.
    }
}