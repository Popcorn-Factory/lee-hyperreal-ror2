using RoR2;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealDisplayController : MonoBehaviour
    {
        Animator animator;
        int selectedNum;
        bool playedSound;

        public void Awake() 
        {
            animator = GetComponent<Animator>();

            selectedNum = GenerateRandomNum();

            if (AkSoundEngine.IsInitialized())
            {
                AkSoundEngine.SetRTPCValue("Volume_Lee_Voice", Modules.Config.voiceVolume.Value);
            }
        }

        public void OnEnable() 
        {
            selectedNum = GenerateRandomNum();
            playedSound = false;
        }

        public int GenerateRandomNum() 
        {
            int chosen = UnityEngine.Random.Range(1, 5);

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
