using RoR2;
using RoR2.UI;
using UnityEngine;

namespace LeeHyperrealMod.Content.Notifications
{
    //Shamelessly stolen from HUNK: thank you for making my job easier ROB
    internal class LeeHyperrealNotification : GenericNotification
    {
        public void SetText(string newToken)
        {
            this.titleText.token = LeeHyperrealPlugin.DEVELOPER_PREFIX + "ITEM_EFFECT_TITLE";
            this.descriptionText.token = newToken;

            this.iconImage.texture = LeeHyperrealMod.Modules.Survivors.LeeHyperreal.staticBodyPrefab.GetComponent<CharacterBody>().portraitIcon;

            this.titleTMP.color = Modules.StaticValues.bodyColor;
        }
    }
}
