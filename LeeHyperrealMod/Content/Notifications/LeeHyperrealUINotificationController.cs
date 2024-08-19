using System;
using UnityEngine;
using RoR2;
using RoR2.UI;
using LeeHyperrealMod.Content.Notifications;

namespace LeeHyperrealMod.Modules.Notifications
{
    // ROB how the fuck does this shit work, this controller is never referenced anywhere else in code.
    internal class LeeHyperrealUINotificationController : MonoBehaviour
    {
        public HUD hud;
        public GameObject genericNotificationPrefab;
        public LeeHyperrealNotification currentNotification;
        public CharacterMaster targetMaster;
        public LeeHyperrealNotificationQueue notificationQueue;

        public void OnEnable()
        {
            CharacterMaster.onCharacterMasterLost += this.OnCharacterMasterLost;
        }

        public void OnDisable()
        {
            CharacterMaster.onCharacterMasterLost -= this.OnCharacterMasterLost;
            this.CleanUpCurrentMaster();
        }

        public void Update()
        {
            if (this.hud.targetMaster != this.targetMaster)
            {
                this.SetTargetMaster(this.hud.targetMaster);
            }

            if (this.currentNotification && this.notificationQueue)
            {
                this.currentNotification.SetNotificationT(this.notificationQueue.GetCurrentNotificationT());
            }
        }

        private void SetUpNotification(CharacterMasterNotificationQueue.NotificationInfo notificationInfo)
        {
            this.currentNotification = UnityEngine.Object.Instantiate<GameObject>(this.genericNotificationPrefab).GetComponent<LeeHyperrealNotification>();

            //The horror, an Object!
            var obj = (Modules.StaticValues.CustomItemEffect)notificationInfo.data;
            if (obj != null)
            {
                this.currentNotification.SetText(obj.titleToken, obj.descToken);
            }

            this.currentNotification.GetComponent<RectTransform>().SetParent(base.GetComponent<RectTransform>(), false);
        }

        private void OnCurrentNotificationChanged(LeeHyperrealNotificationQueue notificationQueue)
        {
            this.ShowCurrentNotification(notificationQueue);
        }

        private void ShowCurrentNotification(LeeHyperrealNotificationQueue notificationQueue)
        {
            this.DestroyCurrentNotification();
            CharacterMasterNotificationQueue.NotificationInfo notificationInfo = notificationQueue.GetCurrentNotification();
            if (notificationInfo != null)
            {
                this.SetUpNotification(notificationInfo);
            }
        }

        private void DestroyCurrentNotification()
        {
            if (this.currentNotification)
            {
                UnityEngine.Object.Destroy(this.currentNotification.gameObject);
                this.currentNotification = null;
            }
        }

        private void SetTargetMaster(CharacterMaster newMaster)
        {
            this.DestroyCurrentNotification();
            this.CleanUpCurrentMaster();
            this.targetMaster = newMaster;
            if (newMaster)
            {
                this.notificationQueue = LeeHyperrealNotificationQueue.GetNotificationQueueForMaster(newMaster);
                this.notificationQueue.onCurrentNotificationChanged += this.OnCurrentNotificationChanged; //GODDAMN IT THAT'S WHERE THIS ALL STARTS
                this.ShowCurrentNotification(this.notificationQueue);
            }
        }

        private void OnCharacterMasterLost(CharacterMaster master)
        {
            if (master == this.targetMaster)
            {
                this.CleanUpCurrentMaster();
            }
        }

        private void CleanUpCurrentMaster()
        {
            if (this.notificationQueue)
            {
                this.notificationQueue.onCurrentNotificationChanged -= this.OnCurrentNotificationChanged;
            }
            this.notificationQueue = null;
            this.targetMaster = null;
        }
    }
}