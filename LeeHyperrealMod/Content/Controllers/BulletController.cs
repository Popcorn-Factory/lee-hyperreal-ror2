using RoR2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class BulletController : MonoBehaviour
    {
        public enum BulletType 
        {
            BLUE,
            RED,
            YELLOW
        }

        public List<BulletType> ColouredBulletList;
        public const int maxBulletAmount = 5;
        public int enhancedBulletAmount;
        public CharacterBody body;
        public LeeHyperrealUIController uiController;

        public void Awake() 
        {
            ColouredBulletList = new List<BulletType>();
            body = gameObject.GetComponent<CharacterBody>();
        }

        public void Start() 
        {

            uiController = gameObject.GetComponent<LeeHyperrealUIController>();
        }

        public void Update() 
        {
            
        }

        //Consumes from the front of the list.
        public void ConsumeColouredBullet() 
        {
            ColouredBulletList.RemoveAt(0);
            uiController.AdvanceBulletState(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed > 10 ? 10 : body.attackSpeed, true));
        }

        public void GrantColouredBullet(BulletType bulletType) 
        {
            if (!(ColouredBulletList.Count > maxBulletAmount)) 
            {
                ColouredBulletList.Add(bulletType);
            }
            //Update the UI.
            uiController.SetBulletStates(ColouredBulletList);
        }

        public void GrantEnhancedBullet(int amount)
        {
            //No limit to enhanced bullet 
            enhancedBulletAmount += amount;
            //Update the UI.
            uiController.SetEnhancedBulletState(enhancedBulletAmount);
        }

        //Usually One bullet.
        public void ConsumeEnhancedBullet(int amount) 
        {
            enhancedBulletAmount -= amount;
            uiController.AdvanceBulletState(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed > 10 ? 10 : body.attackSpeed, false));
        }
    }
}
