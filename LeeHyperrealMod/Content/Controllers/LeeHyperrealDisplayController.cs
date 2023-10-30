using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealDisplayController : MonoBehaviour
    {
        Animator animator;
        int selectedNum;

        public void Awake() 
        {
            animator = GetComponent<Animator>();

            selectedNum = GenerateRandomNum();
        }

        public void OnEnable() 
        {
            selectedNum = GenerateRandomNum();
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
        }
    }
}
