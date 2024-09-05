using RoR2;
using RoR2.UI;

namespace LeeHyperrealMod.Content.Notifications
{
    //Shamelessly stolen from HUNK: thank you for making my job easier ROB
    internal class LeeHyperrealNotification : GenericNotification
    {
        public void SetText(string title, string desc)
        {
            this.titleText.token = title;
            this.descriptionText.token = desc;

            this.iconImage.texture = LeeHyperrealMod.Modules.Survivors.LeeHyperreal.staticBodyPrefab.GetComponent<CharacterBody>().portraitIcon;

            this.titleTMP.color = Modules.StaticValues.bodyColor;
        }
    }
}
