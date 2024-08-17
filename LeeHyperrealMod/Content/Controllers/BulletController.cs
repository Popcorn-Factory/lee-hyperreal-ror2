using RoR2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.UIElements.UIR;
using static RoR2.AimAnimator;
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
        public AimAnimator aimAnimator;
        public CharacterDirection characterDirection;
        public Animator animator;
        public CharacterMotor motor;
        public LeeHyperrealUIController uiController;
        public CameraTargetParams cameraTargetParams;
        public WeaponModelHandler weaponModelHandler;
        public InputBankTest inputBank;
        public CameraParamsOverrideHandle handle;
        CharacterGravityParameters gravParams;
        private float maxPitch = 50f;

        private struct AimAngles
        {
            public float pitch;
            public float yaw;
        }

        AimAngles aimAngle;
        float lerpPitch;
        float lerpPitchVelocity;
        Transform BaseTransform;
        Transform RifleTip;
        Transform Center;
        public GameObject snipeAerialPlatform;

        //Debug
        public ModelLocator modelLocator;
        //public string[] strings = { "Idle", "StopRun", "Run", "Sprint", "Jump", "AscendDescend", "IdleIn", "BufferEmpty", "SnipePitchControl" };

        public void Awake() 
        {
            ColouredBulletList = new List<BulletType>();
            body = gameObject.GetComponent<CharacterBody>();
            characterDirection = gameObject.GetComponent<CharacterDirection>();
            motor = gameObject.GetComponent<CharacterMotor>();
            skillLocator = gameObject.GetComponent<SkillLocator>();
            cameraTargetParams = GetComponent<CameraTargetParams>();
            modelLocator = gameObject.GetComponent<ModelLocator>();
            inputBank = gameObject.GetComponent<InputBankTest>();
            animator = modelLocator.modelTransform.gameObject.GetComponent<Animator>();
            aimAnimator = modelLocator.modelTransform.gameObject.GetComponent<AimAnimator>();
            //Debug
            modelLocator = gameObject.GetComponent<ModelLocator>();
            animator = modelLocator.modelTransform.gameObject.GetComponent<Animator>();

            ChildLocator childLocator = modelLocator.modelTransform.gameObject.GetComponent<ChildLocator>();
            BaseTransform = childLocator.FindChild("BaseTransform");
            RifleTip = childLocator.FindChild("RifleTip");
            Center = childLocator.FindChild("Center");

            Hook();
        }

        private void Hook()
        {
            Modules.Config.changeCameraPos.SettingChanged += ChangeCameraPos_SettingChanged;
        }

        private void ChangeCameraPos_SettingChanged(object sender, EventArgs e)
        {
            if (inSnipeStance && body.hasEffectiveAuthority) 
            {
                if (Modules.Config.changeCameraPos.Value)
                {
                    CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
                    cameraParamsData.maxPitch = maxPitch;
                    cameraParamsData.minPitch = -maxPitch;
                    cameraParamsData.idealLocalCameraPos = new Vector3(Modules.Config.horizontalCameraPosition.Value, Modules.Config.verticalCameraPosition.Value, Modules.Config.depthCameraPosition.Value);

                    CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
                    {
                        cameraParamsData = cameraParamsData,
                        priority = 0.2f,
                    };

                    handle = cameraTargetParams.AddParamsOverride(request, 0.4f);
                }
                else
                {
                    cameraTargetParams.RemoveParamsOverride(handle);
                }
            }
        }

        private void Unhook()
        {
            Modules.Config.changeCameraPos.SettingChanged -= ChangeCameraPos_SettingChanged;
        }

        public void Start() 
        {
            inSnipeStance = false;
            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
            weaponModelHandler = gameObject.GetComponent<WeaponModelHandler>();
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

            //Chat.AddMessage("y-vel:" + motor.velocity.y);

            //Update the Pitch.
            UpdateAimAngle();
            UpdateAnimatorParameters(animator, aimAnimator.pitchRangeMin, aimAnimator.pitchRangeMax, aimAnimator.yawRangeMin, aimAnimator.yawRangeMax);
            if (snipeAerialPlatform) 
            {
                snipeAerialPlatform.transform.position = BaseTransform.transform.position;
            }
        }

        private void UpdateAimAngle()
        {
            Vector3 aimDirection = (this.inputBank ? this.inputBank.aimDirection : base.transform.forward);

            float y = this.characterDirection ? this.characterDirection.yaw : base.transform.eulerAngles.y;
            float x = this.characterDirection ? this.characterDirection.transform.eulerAngles.x : base.transform.eulerAngles.x;
            float z = this.characterDirection ? this.characterDirection.transform.eulerAngles.z : base.transform.eulerAngles.z;
            Vector3 eulerAngles2 = Util.QuaternionSafeLookRotation(aimDirection, base.transform.up).eulerAngles;
            Vector3 vector2 = aimDirection;
            Vector3 vector3 = new Vector3(x, y, z);
            vector2.y = 0f;
            aimAngle = new AimAngles
            {
                pitch = Mathf.Atan2(aimDirection.y, vector2.magnitude) * 57.29578f,
                yaw = AimAnimator.NormalizeAngle(eulerAngles2.y - vector3.y)
            };
        }

        public void UpdateAnimatorParameters(Animator animator, float pitchRangeMin, float pitchRangeMax, float yawRangeMin, float yawRangeMax)
        {
            float pitch = Mathf.Clamp(aimAngle.pitch, pitchRangeMin, pitchRangeMax);
            pitch = Remap(pitch, -maxPitch - 10f, maxPitch + 10f, 0f, 1f);

            if (pitch <= 0) 
            {
                pitch = 0f;
            }

            if (pitch >= 1f) 
            {
                pitch = 0.99f;
            }

            lerpPitch = Mathf.SmoothDamp(lerpPitch, pitch, ref lerpPitchVelocity, 0.2f, 1000f);

            //Chat.AddMessage($"pitch: {aimAngle.pitch} remapPitch: {pitch} aimDirection: {inputBank.aimDirection}");
            animator.SetFloat(AimAnimator.aimPitchCycleHash, lerpPitch);
        }

        public float Remap(float value, float low1, float high1, float low2, float high2) 
        {
            return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
        }

        public void SetSnipeStance(bool shouldTransition = true)    
        {
            inSnipeStance = true;
            if (body.hasEffectiveAuthority) 
            {
                uiController.SetSnipeStateCrosshair(true);
                skillLocator.primary.SetSkillOverride(skillLocator.primary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.SnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);
                skillLocator.secondary.SetSkillOverride(skillLocator.secondary, LeeHyperrealMod.Modules.Survivors.LeeHyperreal.ExitSnipeSkill, RoR2.GenericSkill.SkillOverridePriority.Contextual);

                gravParams = new CharacterGravityParameters();
                gravParams.environmentalAntiGravityGranterCount = 1;
                gravParams.channeledAntiGravityGranterCount = 1;
                motor.gravityParameters = gravParams;

                if (Modules.Config.changeCameraPos.Value) 
                {
                    CharacterCameraParamsData cameraParamsData = cameraTargetParams.currentCameraParamsData;
                    cameraParamsData.maxPitch = maxPitch;
                    cameraParamsData.minPitch = -maxPitch;
                    cameraParamsData.idealLocalCameraPos = new Vector3(Modules.Config.horizontalCameraPosition.Value, Modules.Config.verticalCameraPosition.Value, Modules.Config.depthCameraPosition.Value);

                    CameraTargetParams.CameraParamsOverrideRequest request = new CameraTargetParams.CameraParamsOverrideRequest
                    {
                        cameraParamsData = cameraParamsData,
                        priority = 0.2f,
                    };

                    handle = cameraTargetParams.AddParamsOverride(request, 0.4f);
                }

                body.aimOriginTransform = RifleTip;
            }

            if (shouldTransition) 
            {
                //Should set for everyone.
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.RIFLE);
                weaponModelHandler.SetLaserState(true);
            }

            if (animator)
            {
                animator.SetBool("isSniping", true);
            }
        }

        public void UnsetSnipeStance(bool shouldTransition = true)
        {
            inSnipeStance = false;
            if (body.hasEffectiveAuthority)
            {
                uiController.SetSnipeStateCrosshair(false);
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


                body.aimOriginTransform = Center;
            }


            if (snipeAerialPlatform)
            {
                snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
                snipeAerialPlatform = null;
            }

            if (shouldTransition) 
            {
                //Should set for everyone.
                weaponModelHandler.TransitionState(WeaponModelHandler.WeaponState.SUBMACHINE);
                weaponModelHandler.SetLaserState(false);
            }

            if (animator)
            {
                animator.SetBool("isSniping", false);
            }
        }

        public void SetUltimateStance() 
        {
            if (body.hasEffectiveAuthority) 
            {
                gravParams = new CharacterGravityParameters();
                gravParams.environmentalAntiGravityGranterCount = 1;
                gravParams.channeledAntiGravityGranterCount = 1;
                motor.gravityParameters = gravParams;
            }
        }

        public void UnsetUltimateStance() 
        {
            if (body.hasEffectiveAuthority)
            {
                gravParams = new CharacterGravityParameters();
                gravParams.environmentalAntiGravityGranterCount = 0;
                gravParams.channeledAntiGravityGranterCount = 0;
                motor.gravityParameters = gravParams;
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
            if (!(ColouredBulletList.Count >= maxBulletAmount)) 
            {
                ColouredBulletList.Add(bulletType);
            }
            //Update the UI.
            uiController.SetBulletStates(ColouredBulletList);
            //uiController.UpdateBulletStateTarget(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed * 1.5f, false, false));
        }

        public void GrantEnhancedBullet(int amount)
        {
            //Get Backup magazine count, add on top of enhanced bullet
            int secondaryCharges = (int)body.skillLocator.secondary.maxStock - 1;

            //No limit to enhanced bullet 
            enhancedBulletAmount += amount + secondaryCharges;
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

        public void OnDestroy() 
        {
            if (snipeAerialPlatform) 
            {
                snipeAerialPlatform.GetComponent<DestroyPlatformOnDelay>().StartDestroying();
            }
            Unhook();
        }
    }
}
