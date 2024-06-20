using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealDisplayController : MonoBehaviour
    {
        Animator animator;
        ChildLocator childLocator;
        Transform bornPackTransform;
        int selectedNum;
        bool playedSound;

        public void Awake() 
        {
            animator = GetComponent<Animator>();
            childLocator = GetComponent<ChildLocator>();

            bornPackTransform = childLocator.FindChild("LeeBornAnimPack");

            selectedNum = GenerateRandomNum();
            SetDisableClone();

            if (AkSoundEngine.IsInitialized())
            {
                AkSoundEngine.SetRTPCValue("Volume_Lee_Voice", Modules.Config.voiceVolume.Value);
            }
        }

        public void SetDisableClone() 
        {
            if (bornPackTransform)
            {
                for (int i = 0; i < bornPackTransform.childCount; i++)
                {
                    if (i != selectedNum - 1)
                    {
                        bornPackTransform.GetChild(selectedNum - 1).gameObject.SetActive(true);
                    }
                    else
                    {
                        bornPackTransform.GetChild(selectedNum - 1).gameObject.SetActive(false);
                    }
                }
            }
        }

        public void OnEnable() 
        {
            selectedNum = GenerateRandomNum();
            playedSound = false;
            SetDisableClone();
        }

        public int GenerateRandomNum() 
        {
            int chosen = UnityEngine.Random.Range(1, 5);// 1 to 4 bruh

            return chosen;
        }

        public void Update() 
        {
            if (animator) 
            {
                animator.SetInteger("SelectSpawnTrigger", selectedNum);
            }
            if (!playedSound && Modules.Config.voiceEnabled.Value) 
            {
                playedSound = true;
                if (Modules.Config.voiceLanguageOption.Value == Modules.Config.VoiceLanguage.ENG)
                {
                    Util.PlaySound("Play_Lee_Intro_Voice_EN", this.gameObject);
                }
                else 
                {
                    Util.PlaySound("Play_Lee_Intro_Voice_JP", this.gameObject);
                }
            }
        }
    }
}
