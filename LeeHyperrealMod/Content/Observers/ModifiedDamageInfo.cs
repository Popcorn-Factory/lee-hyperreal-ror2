using RoR2;
using System;
using System.Collections.Generic;
using System.Text;

namespace LeeHyperrealMod.Content.Observers
{
    //Need pair object to setup network connections to measure ping and apply damage after x time.
    public class ModifiedDamageInfo
    {
        public DamageInfo damageInfo;
        public double timestamp;
        public int rttAtTimeOfDamage; // Round trip time to player in milliseconds ( divide by 1000 to get seconds )
        public HealthComponent healthComponent;

        public ModifiedDamageInfo(DamageInfo damageInfo, double timestamp, int rttAtTimeOfDamage, HealthComponent healthComponent)
        {
            this.damageInfo = damageInfo;
            this.timestamp = timestamp;
            this.rttAtTimeOfDamage = rttAtTimeOfDamage;
            this.healthComponent = healthComponent;
        }
    }
}
