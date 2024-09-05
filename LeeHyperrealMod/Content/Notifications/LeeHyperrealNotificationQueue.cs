using RoR2;
using System;
using UnityEngine;

namespace LeeHyperrealMod.Content.Notifications
{
    //Shamelessly stolen from HUNK: thank you for making my job easier ROB
    internal class LeeHyperrealNotificationQueue : MonoBehaviour
    {
        public const float firstNotificationLengthSeconds = 6f;
        public const float repeatNotificationLengthSeconds = 6f;
        private CharacterMasterNotificationQueue.TimedNotificationInfo notification;

        public event Action<LeeHyperrealNotificationQueue> onCurrentNotificationChanged; // Amazing, I gotta expose more actions next time.

        public static LeeHyperrealNotificationQueue GetNotificationQueueForMaster(CharacterMaster master)
        {
            if (master != null)
            {
                LeeHyperrealNotificationQueue characterMasterNotificationQueue = master.GetComponent<LeeHyperrealNotificationQueue>();
                if (!characterMasterNotificationQueue)
                {
                    characterMasterNotificationQueue = master.gameObject.AddComponent<LeeHyperrealNotificationQueue>();
                }
                return characterMasterNotificationQueue;
            }
            return null;
        }

        public static void PushNotification(CharacterMaster characterMaster, Modules.StaticValues.CustomItemEffect tokenPair)
        {
            // I trust this works only for the client player.
            if (!characterMaster.hasAuthority)
            {
                //Debug.LogError("Can't PushItemNotification for " + Util.GetBestMasterName(characterMaster) + " because they aren't local.");
                return;
            }

            LeeHyperrealNotificationQueue notificationQueueForMaster = GetNotificationQueueForMaster(characterMaster);
            if (notificationQueueForMaster)
            {
                notificationQueueForMaster.PushNotification(new CharacterMasterNotificationQueue.NotificationInfo(tokenPair, null), 6f);
            }
        }

        private void PushNotification(CharacterMasterNotificationQueue.NotificationInfo info, float duration)
        {
            this.notification = new CharacterMasterNotificationQueue.TimedNotificationInfo
            {
                notification = info,
                startTime = Run.instance.fixedTime,
                duration = duration,
            };

            Action<LeeHyperrealNotificationQueue> action = this.onCurrentNotificationChanged;
            if (action == null) return;
            action(this);
        }

        public float GetCurrentNotificationT()
        {
            return (Run.instance.fixedTime - this.notification.startTime) / this.notification.duration;
        }

        public CharacterMasterNotificationQueue.NotificationInfo GetCurrentNotification()
        {
            return this.notification?.notification;
        }
    }
}
