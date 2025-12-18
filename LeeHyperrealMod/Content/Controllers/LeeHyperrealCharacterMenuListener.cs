using MonoMod.RuntimeDetour;
using RoR2;
using RoR2.UI;
using RoR2.UI.SkinControllers;
using UnityEngine;
using UnityEngine.EventSystems;

namespace LeeHyperrealMod.Content.Controllers
{
    class LeeHyperrealCharacterMenuListener : MonoBehaviour
    {
        /*
            We need to observe when the survivor skin changes, and the current selected skin. 
         */

        GameObject LoadoutPanel;
        MPEventSystemLocator eventSystemLocator;
        UserProfile userProfile;
        Loadout loadout;
        BodyIndex leeIndex;



        public void Start() 
        {
            LoadoutPanel = this.gameObject.transform.Find("SafeArea/LeftHandPanel (Layer: Main)/SurvivorInfoPanel, Active (Layer: Secondary)/ContentPanel (Overview, Skills, Loadout)/LoadoutScrollContainer/LoadoutScrollPanel/LoadoutPanel").gameObject;
            Hook();

            eventSystemLocator = LoadoutPanel.GetComponent<MPEventSystemLocator>();
            MPEventSystem eventSystem = eventSystemLocator.eventSystem;

            if (eventSystem == null)
            {
                userProfile = null;
            }
            else
            {
                LocalUser localUser = eventSystem.localUser;
                userProfile = ((localUser != null) ? localUser.userProfile : null);
            }
            loadout = userProfile.loadout;
            leeIndex = BodyCatalog.FindBodyIndex("LeeHyperrealBody");
        }

        
        public void Unhook() 
        {
            On.RoR2.UI.SurvivorIconController.Update -= SurvivorIconController_Update;   
        }

        public void Hook()
        {
            On.RoR2.UI.SurvivorIconController.Update += SurvivorIconController_Update;
        }

        private void SurvivorIconController_Update(On.RoR2.UI.SurvivorIconController.orig_Update orig, SurvivorIconController self)
        {
            orig(self);

            if (self && self.survivorIcon && self.survivorBodyIndex == leeIndex) 
            {
                if (Modules.Config.loreMode.Value)
                {
                    switch (loadout.bodyLoadoutManager.GetSkinIndex(leeIndex))
                    {
                        case 0:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.prospectorSprite.texture;
                            break;
                        case 1:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.comradeSprite.texture;
                            break;
                        case 4:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.scarletSprite.texture;
                            break;
                        case 5:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.yiIconSprite.texture;
                            break;
                        case 6:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.bkIconSprite.texture;
                            break;
                        default:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.leeIconSprite.texture;
                            break;
                    }
                }
                else 
                {
                    switch (loadout.bodyLoadoutManager.GetSkinIndex(leeIndex))
                    {
                        case 2:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.scarletSprite.texture;
                            break;
                        case 3:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.prospectorSprite.texture;
                            break;
                        case 4:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.comradeSprite.texture;
                            break;
                        case 5:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.yiIconSprite.texture;
                            break;
                        case 6:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.bkIconSprite.texture;
                            break;
                        default:
                            self.survivorIcon.texture = Modules.LeeHyperrealAssets.leeIconSprite.texture;
                            break;
                    }
                }
            }
        }

        public void OnDestroy() 
        {
            Unhook();
        }
    }
}
