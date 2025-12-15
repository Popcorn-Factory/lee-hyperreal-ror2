using LeeHyperrealMod.Modules;
using RoR2;
using RoR2.SurvivorMannequins;
using UnityEngine;

namespace LeeHyperrealMod.Content.Controllers
{
    internal class LeeHyperrealDisplayController : MonoBehaviour
    {
        Animator animator;
        ChildLocator childLocator;
        Transform bornPackTransform;
        Transform baseTransform;
        SurvivorMannequinSlotController slotController;
        Loadout loadout;
        int selectedNum;
        bool playedSound;
        BodyIndex leeIndex;

        float duration = 6f;
        float timer = 0f;
        uint skinIndex;

        public void Awake() 
        {
            animator = GetComponent<Animator>();
            childLocator = GetComponent<ChildLocator>();
            slotController = this.gameObject.transform.parent.GetComponent<SurvivorMannequinSlotController>();
            loadout = slotController.currentLoadout;

            bornPackTransform = childLocator.FindChild("LeeBornAnimPack");
            baseTransform = childLocator.FindChild("BaseTransform"); 

            selectedNum = GenerateRandomNum();
            timer = 0f;
            SetDisableClone();

            leeIndex = BodyCatalog.FindBodyIndex("LeeHyperrealBody");
            skinIndex = loadout.bodyLoadoutManager.GetSkinIndex(leeIndex);
            SetNewSkinForAll();
        }

        public void SetDisableClone() 
        {
            if (bornPackTransform)
            {
                for (int i = 0; i < bornPackTransform.childCount; i++)
                {
                    if (i != selectedNum - 1)
                    {
                        bornPackTransform.GetChild(i).gameObject.SetActive(true);
                    }
                    else
                    {
                        bornPackTransform.GetChild(i).gameObject.SetActive(false);
                    }
                }
            }
        }

        public void OnEnable() 
        {
            selectedNum = GenerateRandomNum();
            playedSound = false;
            timer = 0f;
            if (animator) 
            {
                animator.SetBool("StartBlinking", false);
            }
            SetDisableClone();
        }

        public int GenerateRandomNum() 
        {
            int chosen = UnityEngine.Random.Range(1, 5);// 1 to 4 bruh
            return chosen;
        }

        public void Update() 
        {
            if (skinIndex != loadout.bodyLoadoutManager.GetSkinIndex(leeIndex)) 
            {
                skinIndex = loadout.bodyLoadoutManager.GetSkinIndex(leeIndex);
                SetNewSkinForAll();
            }

            if (timer >= duration)
            {
                if (animator)
                {
                    animator.SetBool("StartBlinking", true);
                }
            }
            else 
            {
                timer += Time.deltaTime;
            }
            if (animator) 
            {
                animator.SetInteger("SelectSpawnTrigger", selectedNum);
            }
            if (!playedSound) 
            {
                playedSound = true;
                if (Modules.Config.voiceEnabled.Value && !Modules.Survivors.LeeHyperreal.voiceDisabledSkins.Contains((int)skinIndex)) 
                {
                    if (Modules.Config.voiceLanguageOption.Value == Modules.Config.VoiceLanguage.ENG)
                    {
                        Util.PlaySound("Play_Lee_Intro_Voice_EN", this.gameObject);
                    }
                    else
                    {
                        Util.PlaySound("Play_Lee_Intro_Voice_JP", this.gameObject);
                    }
                }

                Util.PlaySound("Play_c_liRk4_act_born", this.gameObject);

                //Always play the effect on spawn, start the effect 2 on spawn 2.
                if (selectedNum == 2) 
                {
                    Object.Instantiate(Modules.ParticleAssets.RetrieveParticleEffect("displayLandingEffect", Modules.ParticleAssets.DEFAULT_PARTICLE_VARIANT), baseTransform.position, Quaternion.identity, baseTransform);
                }
            }
        }

        private void SetNewSkinForAll()
        {
            foreach (Transform obj in bornPackTransform) 
            {
                SetNewSkin(obj.gameObject, skinIndex);
            }
        }

        private void SetNewSkin(GameObject obj, uint skinIndex)
        {
            if (Modules.Config.loreMode.Value)
            {
                switch (skinIndex)
                {
                    case 0: // Set Prospector
                        SetProspectorSkin(obj);
                        break;
                    case 1:
                        SetComradeSkin(obj);
                        break;
                    case 4:
                        SetScarletSkin(obj);
                        break;
                    default:
                        SetDefaultLeeSkin(obj);
                        break;
                }
            }
            else 
            {
                switch (skinIndex)
                {
                    case 2:
                        SetScarletSkin(obj);
                        break;
                    case 3: // Set Prospector
                        SetProspectorSkin(obj);
                        break;
                    case 4:
                        SetComradeSkin(obj);
                        break;
                    default:
                        SetDefaultLeeSkin(obj);
                        break;
                }
            }
        }

        private void SetBKSkin(GameObject obj) 
        {
        
        }

        private void SetYiSkin(GameObject obj) 
        {
            SkinnedMeshRenderer box = obj.transform.Find("E3SuperliboxMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer submachine = obj.transform.Find("E3SuperligunMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer alpha = obj.transform.Find("R4LiangMd010011Alpha").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer body = obj.transform.Find("R4LiangMd010011Body").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer cloth = obj.transform.Find("R4LiangMd010011Cloth").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer down = obj.transform.Find("R4LiangMd010011Down").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer eye = obj.transform.Find("R4LiangMd010011Eye").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer face = obj.transform.Find("R4LiangMd010011Face").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer hair = obj.transform.Find("R4LiangMd010011Hair").gameObject.GetComponent<SkinnedMeshRenderer>();
            
            //disable specific objs
            box.gameObject.SetActive(true);
            submachine.gameObject.SetActive(true);
            alpha.gameObject.SetActive(false);
            body.gameObject.SetActive(false);
            cloth.gameObject.SetActive(false);
            down.gameObject.SetActive(false);
            eye.gameObject.SetActive(false);
            face.gameObject.SetActive(false);
            hair.gameObject.SetActive(false);
        }

        private void SetComradeSkin(GameObject obj)
        {
            SkinnedMeshRenderer box = obj.transform.Find("E3SuperliboxMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer submachine = obj.transform.Find("E3SuperligunMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer alpha = obj.transform.Find("R4LiangMd010011Alpha").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer body = obj.transform.Find("R4LiangMd010011Body").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer cloth = obj.transform.Find("R4LiangMd010011Cloth").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer down = obj.transform.Find("R4LiangMd010011Down").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer eye = obj.transform.Find("R4LiangMd010011Eye").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer face = obj.transform.Find("R4LiangMd010011Face").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer hair = obj.transform.Find("R4LiangMd010011Hair").gameObject.GetComponent<SkinnedMeshRenderer>();

            //disable specific objs
            box.gameObject.SetActive(true);
            submachine.gameObject.SetActive(true);
            alpha.gameObject.SetActive(false);
            body.gameObject.SetActive(true);
            cloth.gameObject.SetActive(true);
            down.gameObject.SetActive(false);
            eye.gameObject.SetActive(false);
            face.gameObject.SetActive(false);
            hair.gameObject.SetActive(true);

            //Replace Meshes
            box.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorBoxMesh");
            submachine.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorPistolMesh");
            body.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2Heart");
            cloth.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2BodyComrade");
            hair.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2HeadComrade");

            //Replace Materials with clone mats
            Material cloneComrade = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneComrade"));
            box.material = cloneComrade;
            submachine.material = cloneComrade;
            body.material = cloneComrade;
            cloth.material = cloneComrade;
            hair.material = cloneComrade;

            //Set Material color
            cloneComrade.SetColor("_Tint", Modules.ParticleAssets.ORANGE_PARTICLE.mainColor);
        }

        private void SetDefaultLeeSkin(GameObject obj) 
        {
            SkinnedMeshRenderer box = obj.transform.Find("E3SuperliboxMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer submachine = obj.transform.Find("E3SuperligunMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer alpha = obj.transform.Find("R4LiangMd010011Alpha").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer body = obj.transform.Find("R4LiangMd010011Body").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer cloth = obj.transform.Find("R4LiangMd010011Cloth").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer down = obj.transform.Find("R4LiangMd010011Down").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer eye = obj.transform.Find("R4LiangMd010011Eye").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer face = obj.transform.Find("R4LiangMd010011Face").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer hair = obj.transform.Find("R4LiangMd010011Hair").gameObject.GetComponent<SkinnedMeshRenderer>();

            //disable specific objs
            box.gameObject.SetActive(true);
            submachine.gameObject.SetActive(true);
            alpha.gameObject.SetActive(true);
            body.gameObject.SetActive(true);
            cloth.gameObject.SetActive(true);
            down.gameObject.SetActive(true);
            eye.gameObject.SetActive(true);
            face.gameObject.SetActive(true);
            hair.gameObject.SetActive(true);

            //Replace Meshes
            box.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeGunCaseMeshBlend");
            submachine.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeSubMachineGunMeshBlend");
            alpha.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeChestLegPlateMeshBlend");
            body.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeArmsMeshBlend");
            cloth.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeTorsoClothMeshBlend");
            down.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeLegsMeshBlend");
            eye.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeEyeMeshBlend");
            face.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeFaceMeshBlend");
            hair.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeHairMeshBlend");

            //Replace Materials with clone mats
            box.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneSuperBox");
            submachine.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("clonePistol");
            alpha.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneAlpha");
            body.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneBody");
            cloth.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneCloth");
            down.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneDown");
            eye.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneEye");
            face.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneFace");
            hair.material = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneHair");
        }

        private void SetScarletSkin(GameObject obj)
        {
            SkinnedMeshRenderer box = obj.transform.Find("E3SuperliboxMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer submachine = obj.transform.Find("E3SuperligunMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer alpha = obj.transform.Find("R4LiangMd010011Alpha").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer body = obj.transform.Find("R4LiangMd010011Body").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer cloth = obj.transform.Find("R4LiangMd010011Cloth").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer down = obj.transform.Find("R4LiangMd010011Down").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer eye = obj.transform.Find("R4LiangMd010011Eye").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer face = obj.transform.Find("R4LiangMd010011Face").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer hair = obj.transform.Find("R4LiangMd010011Hair").gameObject.GetComponent<SkinnedMeshRenderer>();

            //disable specific objs
            box.gameObject.SetActive(true);
            submachine.gameObject.SetActive(true);
            alpha.gameObject.SetActive(true);
            body.gameObject.SetActive(true);
            cloth.gameObject.SetActive(true);
            down.gameObject.SetActive(true);
            eye.gameObject.SetActive(true);
            face.gameObject.SetActive(true);
            hair.gameObject.SetActive(true);

            //Replace Meshes
            box.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("E3SuperliboxMd030011");
            submachine.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("E3SuperligunMd030011");
            alpha.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("R4LiangMd019011Alpha");
            body.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("R4LiangMd019011Body");
            cloth.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("R4LiangMd019011Cloth");
            down.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("R4LiangMd019011Down");
            eye.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeEyeMeshBlend");
            face.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("leeFaceMeshBlend");
            hair.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("R4LiangMd019011Hair");

            //Replace Materials with clone mats
            box.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneScarletBox") );
            submachine.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneScarletSemiGun"));
            alpha.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneAlpha"));
            body.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneScarletUpper"));
            cloth.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneScarletUpper"));
            down.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneScarletLower"));
            eye.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneEye"));
            face.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneFace"));
            hair.material = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneScarletHair"));

            box.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            submachine.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            alpha.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            body.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            cloth.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            down.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            eye.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            face.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
            hair.material.SetColor("_Tint", Modules.ParticleAssets.RED_PARTICLE.mainColor);
        }


        private void SetProspectorSkin(GameObject obj) 
        {
            SkinnedMeshRenderer box = obj.transform.Find("E3SuperliboxMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer submachine = obj.transform.Find("E3SuperligunMd010011").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer alpha = obj.transform.Find("R4LiangMd010011Alpha").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer body = obj.transform.Find("R4LiangMd010011Body").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer cloth = obj.transform.Find("R4LiangMd010011Cloth").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer down = obj.transform.Find("R4LiangMd010011Down").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer eye = obj.transform.Find("R4LiangMd010011Eye").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer face = obj.transform.Find("R4LiangMd010011Face").gameObject.GetComponent<SkinnedMeshRenderer>();
            SkinnedMeshRenderer hair = obj.transform.Find("R4LiangMd010011Hair").gameObject.GetComponent<SkinnedMeshRenderer>();

            //disable specific objs
            box.gameObject.SetActive(true);
            submachine.gameObject.SetActive(true);
            alpha.gameObject.SetActive(false);
            body.gameObject.SetActive(true);
            cloth.gameObject.SetActive(true);
            down.gameObject.SetActive(false);
            eye.gameObject.SetActive(false);
            face.gameObject.SetActive(false);
            hair.gameObject.SetActive(true);

            //Replace Meshes
            box.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorBoxMesh");
            submachine.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorPistolMesh");
            //alpha.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorBoxMesh");
            body.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2Heart");
            cloth.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorCloth");
            //down.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorBoxMesh");
            //eye.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorBoxMesh");
            //face.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2ProspectorBoxMesh");
            hair.sharedMesh = Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Mesh>("LeeRor2Head");

            //Replace Materials with clone mats
            Material cloneProspector = new Material(Modules.LeeHyperrealAssets.mainAssetBundle.LoadAsset<Material>("cloneProspector"));
            box.material = cloneProspector;
            submachine.material = cloneProspector;
            body.material = cloneProspector;
            cloth.material = cloneProspector;
            hair.material = cloneProspector;
        }
    }
}
