using EntityStates;
using EntityStates.GolemMonster;
using MonoMod.RuntimeDetour;
using RoR2;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class ParryMonitor : MonoBehaviour
    {
        private bool PauseTrigger = false;
        public bool ShouldDoBigParry = false;
        public CharacterBody body;
        public InputBankTest inputBank;
        public EntityStateMachine weaponESM;
        private ModelLocator modelLocator;

        public void Start()
        {
            body = GetComponent<CharacterBody>();
            inputBank = GetComponent<InputBankTest>();
            modelLocator = gameObject.GetComponent<ModelLocator>();
            EntityStateMachine[] stateMachines = gameObject.GetComponents<EntityStateMachine>();

            foreach (EntityStateMachine esm in stateMachines)
            {
                if (esm.customName == "Weapon")
                {
                    weaponESM = esm;
                }
            }

            Hook();
        }

        private void Hook()
        {
            On.EntityStates.GolemMonster.FireLaser.OnEnter += FireLaser_OnEnter;
        }

        private void Unhook() 
        {
            On.EntityStates.GolemMonster.FireLaser.OnEnter -= FireLaser_OnEnter;
        }

        private void FireLaser_OnEnter(On.EntityStates.GolemMonster.FireLaser.orig_OnEnter orig, EntityStates.GolemMonster.FireLaser self)
        {
            orig(self);

            Ray ray = self.modifiedAimRay;

            CheckLaserParry(ray);
        }

        private void CheckLaserParry(Ray ray)
        {

            RaycastHit raycastHit;

            if (Physics.Raycast(ray, out raycastHit, 1000f, LayerIndex.world.mask | LayerIndex.defaultLayer.mask | LayerIndex.entityPrecise.mask))
            {
                GameObject hitGameObject = raycastHit.transform.GetComponent<HurtBox>()?.healthComponent.gameObject;

                if (!hitGameObject)
                {
                    hitGameObject = raycastHit.transform.GetComponent<HealthComponent>()?.gameObject;
                }
                
                ParryMonitor parryMonitor = hitGameObject?.GetComponent<ParryMonitor>();

                //Debug.LogWarning($"tran {raycastHit.transform}, " +
                //    $"hurt {raycastHit.transform.GetComponent<HurtBox>()}, " +
                //    $"health {raycastHit.transform.GetComponent<HurtBox>()?.healthComponent.gameObject}, " +
                //    $"{hitGameObject?.GetComponent<ParryMonitor>()}");

                if (parryMonitor)
                {
                    if (body && body.HasBuff(Modules.Buffs.parryBuff)) 
                    {
                        //Trigger parry.
                        ShootParriedLaser();
                    }
                }
            }
        }

        //private void ParryLasers()
        //{
        //    if (this.usingBash)
        //        return;

        //    if (enforcerNet.parries <= 0)
        //        return;

        //    Util.PlayAttackSpeedSound(Sounds.BashDeflect, EnforcerPlugin.VRAPICompat.IsLocalVRPlayer(characterBody) ? EnforcerPlugin.VRAPICompat.GetShieldMuzzleObject() : gameObject, UnityEngine.Random.Range(0.9f, 1.1f));

        //    for (int i = 0; i < enforcerNet.parries; i++)
        //    {
        //        //using drOctagonapus monobehaviour to start the coroutine, however any monobehaviour would work
        //        this.shieldComponent.drOctagonapus.StartCoroutine(ShootParriedLaser(i * parryInterval));
        //    }

        //    enforcerNet.parries = 0;

        //    if (!this.hasDeflected)
        //    {
        //        this.hasDeflected = true;

        //        if (Config.sirenOnDeflect.Value)
        //            Util.PlaySound(Sounds.SirenDeflect, base.gameObject);

        //        base.characterBody.GetComponent<EnforcerLightController>().FlashLights(3);
        //        base.characterBody.GetComponent<EnforcerLightControllerAlt>().FlashLights(3);
        //    }
        //}

        private void ShootParriedLaser()
        {
            Ray aimRay = inputBank.GetAimRay();

            Vector3 point = aimRay.GetPoint(1000);
            Vector3 laserDirection = point - transform.position;
            weaponESM.SetState(new EntityStates.GolemMonster.FireLaser {laserDirection = laserDirection });
        }


        public void SetPauseTrigger(bool val) 
        {
            PauseTrigger = val;
        }

        public bool GetPauseTrigger() 
        {
            return PauseTrigger;
        }

        public void OnDestroy() 
        {
            Unhook();
        }
    }
}
