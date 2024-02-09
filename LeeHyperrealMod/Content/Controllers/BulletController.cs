using RoR2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UIElements.UIR;
using static RoR2.CameraTargetParams;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class BulletController : MonoBehaviour
    {
        public enum BulletType 
        {
            BLUE,
            RED,
            YELLOW,
            NONE
        }

        public List<BulletType> ColouredBulletList;
        public const int maxBulletAmount = 5;
        public int enhancedBulletAmount;

        public bool inSnipeStance = false;
        public SkillLocator skillLocator;

        public CharacterBody body;
        public CharacterMotor motor;
        public LeeHyperrealUIController uiController;
        public CameraTargetParams cameraTargetParams;
        public CameraParamsOverrideHandle handle;
        CharacterGravityParameters gravParams;

        //Debug
        //public Animator animator;
        //public ModelLocator modelLocator;
        //public string[] strings = {"Idle", "StopRun", "Run", "Sprint", "Jump", "AscendDescend", "IdleIn", "BufferEmpty"};

        public void Awake() 
        {
            ColouredBulletList = new List<BulletType>();
            body = gameObject.GetComponent<CharacterBody>();
            motor = gameObject.GetComponent<CharacterMotor>();
            skillLocator = gameObject.GetComponent<SkillLocator>();
            cameraTargetParams = GetComponent<CameraTargetParams>();
            //Debug
            //modelLocator = gameObject.GetComponent<ModelLocator>();
            //animator = modelLocator.modelTransform.gameObject.GetComponent<Animator>();
        }

        public void Start() 
        {
            inSnipeStance = false;
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
        }

        public void Update() 
        {

            //Debug
            //foreach (string str in strings) 
            //{
            //    if (animator.GetCurrentAnimatorStateInfo(0).IsName(str)) 
            //    {
            //        Chat.AddMessage($"{str}: spr:{animator.GetBool("isSprinting")} mov:{animator.GetBool("isMoving")} gro:{animator.GetBool("isGrounded")}");
            //    }
            //}
        }

        public void SetSnipeStance() 
        {
            if (body.hasEffectiveAuthority) 
            {
                inSnipeStance = true;
                skillLocator.primary.SetSkillOverride(skillLocator.primary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.SnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
                skillLocator.secondary.SetSkillOverride(skillLocator.secondary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.ExitSnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);

                gravParams = new CharacterGravityParameters();
                gravParams.environmentalAntiGravityGranterCount = 1;
                gravParams.channeledAntiGravityGranterCount = 1;
                motor.gravityParameters = gravParams;

                if (Modules.Config.changeCameraPos.Value) 
                {
                    CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
                    cameraParamsData.maxPitch = 30;
                    cameraParamsData.minPitch = -30;
                    cameraParamsData.idealLocalCameraPos = new Vector3(Modules.Config.horizontalCameraPosition.Value, Modules.Config.verticalCameraPosition.Value, Modules.Config.depthCameraPosition.Value);

                    CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
                    {
                        cameraParamsData = cameraParamsData,
                        priority = 0,
                    };

                    handle = cameraTargetParams.AddParamsOverride(request, 0.4f);
                }
            }
        }

        public void UnsetSnipeStance() 
        {
            if (body.hasEffectiveAuthority) 
            {
                inSnipeStance = false;
                skillLocator.primary.UnsetSkillOverride(skillLocator.primary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.SnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
                skillLocator.secondary.UnsetSkillOverride(skillLocator.secondary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.ExitSnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);

                gravParams = new CharacterGravityParameters();
                gravParams.environmentalAntiGravityGranterCount = 0;
                gravParams.channeledAntiGravityGranterCount = 0;
                motor.gravityParameters = gravParams;

                if (Modules.Config.changeCameraPos.Value)
                {
                    cameraTargetParams.RemoveParamsOverride(handle);
                }
            }
        }

        //Consumes from the front of the list.
        public BulletType ConsumeColouredBullet() 
        {
            if (ColouredBulletList.Count == 0) 
            {
                return BulletType.NONE;
            }

            BulletType type = ColouredBulletList[0];
            ColouredBulletList.RemoveAt(0);
            //uiController.SetBulletStates(ColouredBulletList);
            uiController.AdvanceBulletState(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed * 1.5f, true, false));
            return type;
        }

        public void GrantColouredBullet(BulletType bulletType) 
        {
            if (!(ColouredBulletList.Count > maxBulletAmount)) 
            {
                ColouredBulletList.Add(bulletType);
            }
            //Update the UI.
            uiController.SetBulletStates(ColouredBulletList);
            //uiController.UpdateBulletStateTarget(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed * 1.5f, false, false));
        }

        public void GrantEnhancedBullet(int amount)
        {
            //No limit to enhanced bullet 
            enhancedBulletAmount += amount;
            //Update the UI.
            uiController.SetEnhancedBulletState(enhancedBulletAmount);
            //uiController.UpdateBulletStateTarget(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed * 1.5f, false, false));
        }

        //Usually One bullet.
        public bool ConsumeEnhancedBullet(int amount) 
        {
            if (enhancedBulletAmount == 0) 
            {
                return false;
            }
            enhancedBulletAmount -= amount;
            //uiController.SetEnhancedBulletState(enhancedBulletAmount);
            uiController.AdvanceBulletState(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed * 1.5f, false, true));

            return true;
        }
    }
}
