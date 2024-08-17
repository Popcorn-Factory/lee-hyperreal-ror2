using RoR2;
using RoR2.UI;
using UnityEngine;

namespace LeeHyperrealMod.Content.Notifications
{
    internal class LeeHyperrealNotification : GenericNotification
    {
        public void SetText(string newToken)
        {
            this.titleText.token = LeeHyperrealPlugin.DEVELOPER_PREFIX + "ITEM_EFFECT_TITLE";
            this.descriptionText.token = newToken;

            this.iconImage.texture = LeeHyperrealMod.Modules.Survivors.LeeHyperreal.staticBodyPrefab.GetComponent<CharacterBody>().portraitIcon;

            this.titleTMP.color = new Color(0.4f, 1f, 1f);
        }
    }
}
