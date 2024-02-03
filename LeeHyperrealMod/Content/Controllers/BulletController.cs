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
            YELLOW,
            NONE
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
        public BulletType ConsumeColouredBullet() 
        {
            if (ColouredBulletList.Count == 0) 
            {
                return BulletType.NONE;
            }

            BulletType type = ColouredBulletList[0];
            ColouredBulletList.RemoveAt(0);
            uiController.AdvanceBulletState(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed > 10 ? 10 : body.attackSpeed, true, false));
            return type;
        }

        public void GrantColouredBullet(BulletType bulletType) 
        {
            if (!(ColouredBulletList.Count > maxBulletAmount)) 
            {
                ColouredBulletList.Add(bulletType);
            }
            //Update the UI.
            uiController.SetBulletStates(ColouredBulletList);
            uiController.UpdateBulletStateTarget(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed > 10 ? 10 : body.attackSpeed, false, false));
        }

        public void GrantEnhancedBullet(int amount)
        {
            //No limit to enhanced bullet 
            enhancedBulletAmount += amount;
            //Update the UI.
            uiController.SetEnhancedBulletState(enhancedBulletAmount);
            uiController.UpdateBulletStateTarget(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed > 10 ? 10 : body.attackSpeed, false, false));
        }

        //Usually One bullet.
        public bool ConsumeEnhancedBullet(int amount) 
        {
            if (enhancedBulletAmount == 0) 
            {
                return false;
            }
            enhancedBulletAmount -= amount;
            uiController.AdvanceBulletState(new LeeHyperrealUIController.BulletState(enhancedBulletAmount, ColouredBulletList.ToList(), body.attackSpeed > 10 ? 10 : body.attackSpeed, false, true));

            return true;
        }
    }
}
