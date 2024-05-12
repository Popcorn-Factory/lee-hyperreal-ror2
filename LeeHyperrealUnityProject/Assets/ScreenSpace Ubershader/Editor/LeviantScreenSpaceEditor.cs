//Made by Aidan_ogg#0001 for Leviant#8796
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

public class LeviantScreenSpaceEditor : ShaderGUI
{
    static string paypalURL = "https://www.paypal.me/LeviantTech";
    static Texture2D bannerTex;
    static GUIStyle linkStyle;
    static GUIStyle foldLabelStyle;
    static GUIStyle toggleStyle;
    static GUIStyle layoutStyle;
    static GUIStyle introLayoutStyle;
    static Dictionary<Category, GUIContent> labels;
    static int foldState;
    static bool useSliders;
    static Rect linkRect;
    bool firstCall = true;

    Material _material;
    MaterialProperty[] _props;
    MaterialEditor _materialEditor;

    //Main Settings
    bool warning;
    MaterialProperty Particle_Render;
    //Fade Settings
    MaterialProperty _MinRange;
    MaterialProperty _MaxRange;

    //Glitch
    int glitch_current_preset = -1;
    MaterialProperty Glitch;
    MaterialProperty _Glitch_Intensity;
    MaterialProperty _Glitch_BlockSize;
    MaterialProperty _Glitch_Macroblock;
    MaterialProperty _Glitch_Blocks;
    MaterialProperty _Glitch_Lines;
    MaterialProperty _Glitch_UPS;
    MaterialProperty _Glitch_ActiveTime;
    MaterialProperty _Glitch_PeriodTime;
    MaterialProperty _Glitch_Duration;
    MaterialProperty _Glitch_Displace;
    MaterialProperty _Glitch_Pixelization;
    MaterialProperty _Glitch_Shift;
    MaterialProperty _Glitch_Grayscale;
    MaterialProperty _Glitch_ColorShift;
    MaterialProperty _Glitch_Interleave;
    MaterialProperty _Glitch_BrokenBlock;
    MaterialProperty _Glitch_Posterization;
    MaterialProperty _Glitch_Displace_Chance;
    MaterialProperty _Glitch_Pixelization_Chance;
    MaterialProperty _Glitch_Shift_Chance;
    MaterialProperty _Glitch_Grayscale_Chance;
    MaterialProperty _Glitch_ColorShift_Chance;
    MaterialProperty _Glitch_Interleave_Chance;
    MaterialProperty _Glitch_BrokenBlock_Chance;
    MaterialProperty _Glitch_Posterization_Chance;
    //Zoom Settings
    MaterialProperty Magnification;
    MaterialProperty _Magnification;
    MaterialProperty _Gravitation;
    MaterialProperty _AngleStartFade;
    MaterialProperty _MaxAngle;

    //Girlscam
    MaterialProperty _SizeGirls;
    MaterialProperty _TimeGirls;

    //Rotation
    MaterialProperty ScreenRotation;
    MaterialProperty _ScreenRotation;
    MaterialProperty _ScreenRotationSpeed;

    //Screen Transform
    MaterialProperty _ScreenHorizontalFlip;
    MaterialProperty _ScreenVerticalFlip;

    //Screen Shake
    MaterialProperty Shake;
    MaterialProperty _ShakeTex;
    MaterialProperty _SIntensity_X;
    MaterialProperty _SIntensity_Y;
    MaterialProperty _ShakeScroll;
    MaterialProperty _ShakeWave;
    MaterialProperty _ShakeWaveSpeed;

    //Pixelation
    MaterialProperty Pixelization;
    MaterialProperty _PSize_X;
    MaterialProperty _PSize_Y;

    //Screen Distortion
    MaterialProperty Distorsion;
    MaterialProperty Wave_Distorsion;
    MaterialProperty Texture_Distorsion;
    MaterialProperty _DistorsionTex;
    MaterialProperty _DIntensity_X;
    MaterialProperty _DIntensity_Y;
    MaterialProperty _DistorsionScroll;
    MaterialProperty _DistorsionWave;
    MaterialProperty _DistorsionWaveSpeed;
    MaterialProperty _DistorsionWaveDensity;

    //Blur Settings
    MaterialProperty Blur;
    MaterialProperty Blur_Distorsion;
    MaterialProperty _Blur_Dithering;
    MaterialProperty _BlurColor;
    MaterialProperty _BlurRange;
    MaterialProperty _BlurRotation;
    MaterialProperty _BlurRotationSpeed;
    MaterialProperty _BlurIterations;
    MaterialProperty _BlurCenterOffset;
    MaterialProperty _BlurMask;

    //Chromatic Aberration
    MaterialProperty Chromatic_Aberration;
    MaterialProperty Aberration_Quality;
    MaterialProperty CA_Distorsion;
    MaterialProperty _CA_dithering;
    MaterialProperty _CA_amplitude;
    MaterialProperty _CA_iterations;
    MaterialProperty _CA_speed;
    MaterialProperty _CA_direction;
    MaterialProperty _CA_factor;
    MaterialProperty _CA_centerOffset;
    MaterialProperty _CA_mask;

    //Neon
    MaterialProperty Neon;
    MaterialProperty _NeonColor;
    MaterialProperty _NeonColorAlpha;
    MaterialProperty _NeonOrigColor;
    MaterialProperty _NeonOrigColorAlpha;
    MaterialProperty _NeonBrightness;
    MaterialProperty _NeonPosterization;
    MaterialProperty _NeonWidth;
    MaterialProperty _NeonGlow;

    //HSV Colour Space
    MaterialProperty HSV_Selection;
    MaterialProperty _TargetColor;
    MaterialProperty _HueRange;
    MaterialProperty _SaturationRange;
    MaterialProperty _LightnessRange;
    MaterialProperty _HueSmoothRange;
    MaterialProperty _SaturationSmoothRange;
    MaterialProperty _LightnessSmoothRange;
    MaterialProperty HSV_Desaturate_Selected;
    //Extra Settings
    MaterialProperty HSV_Transform;
    MaterialProperty _TransformColor;
    MaterialProperty _Hue;
    MaterialProperty _HueAnimationSpeed;
    MaterialProperty _Saturation;
    MaterialProperty _Lightness;

    //Colour Correction
    MaterialProperty Color_Tint;
    MaterialProperty ACES_Tonemapping;
    MaterialProperty _EmissionColor;
    MaterialProperty _Color;
    MaterialProperty _ColorAlpha;
    MaterialProperty _Grayscale;
    MaterialProperty _Contrast;
    MaterialProperty _Gamma;
    MaterialProperty _Brightness;
    MaterialProperty _RedInvert;
    MaterialProperty _GreenInvert;
    MaterialProperty _BlueInvert;

    //Posterization
    MaterialProperty Posterization;
    MaterialProperty _PosterizationSteps;

    //Dithering
    MaterialProperty Dithering;
    MaterialProperty Dithering_Colorize;
    MaterialProperty _DitheringMask;

    //Overlay Texture
    MaterialProperty Overlay_Texture;
    MaterialProperty Overlay_Grid;
    MaterialProperty _OverlayTex;
    MaterialProperty _OverlayTint;
    MaterialProperty _OverlayScroll;
    MaterialProperty _OverlayRotation;
    MaterialProperty _OverlayOpaque;
    MaterialProperty _OverlayTransparent;
    MaterialProperty Overlay_Texture_Sheet;
    MaterialProperty _OverlayColumns;
    MaterialProperty _OverlayRows;
    MaterialProperty _OverlayStartFrame;
    MaterialProperty _OverlayTotalFrames;
    MaterialProperty _OverlayAnimationSpeed;
    MaterialProperty _isGlitchActive;
    MaterialProperty _RGBGlitchBlocksPower;
    MaterialProperty _isRedActive;
    MaterialProperty _isGreenActive;
    MaterialProperty _isBlueActive;

    //Static
    MaterialProperty Static_Noise;
    MaterialProperty _StaticColour;
    MaterialProperty _StaticIntensity;
    MaterialProperty _StaticAlpha;
    MaterialProperty _StaticBrightness;
    MaterialProperty _MaskAmount;

    //Vignette
    MaterialProperty Vignette;
    MaterialProperty _VignetteColor;
    MaterialProperty _VignetteAlpha;
    MaterialProperty _VignetteWidth;
    MaterialProperty _VignetteShape;
    MaterialProperty _VignetteRounding;

    //Mask Texture
    MaterialProperty Mask_Texture;
    MaterialProperty Mask_Multisampling;
    MaterialProperty Mask_Noise;
    MaterialProperty _MaskTex;
    MaterialProperty _MaskColor;
    MaterialProperty _MaskAlpha;
    MaterialProperty _MaskScroll;

    //Stlyes
    GUIStyle friendStyle;

    static class Styles
    {
        public static GUIContent MainText = new GUIContent("Background Texture");
    }

    public class PropertySet
    {
        public string name;
        public PropertyType type;
        public Vector4 values;
        public PropertySet() { }
        public PropertySet(PropertySet.PropertyType ptype, Vector4 val) { type = ptype; values = val; }
        public PropertySet(PropertySet.PropertyType ptype, float val) { type = ptype; values.x = val; }

        public enum PropertyType
        {
            Color, Vector, Float, Range, TexEnv, Vector3, Quaternion, Int
        }

    }

    public class GlitchPresets
    {
        public static string[] name = new string[] { "Default", "DV", "Virtual Reality", "Desync", "Dark static noise", "Critical error" };
        static Dictionary<string, float>[] presets = new Dictionary<string, float>[6];
        static GlitchPresets()
        {
            presets[0] = new Dictionary<string, float>(30) //Default
            {
                { "Glitch", 1.0f },
                { "_Glitch_Intensity", 0.1f },
                { "_Glitch_BlockSize", 10.0f },
                { "_Glitch_Macroblock", 0.3f },
                { "_Glitch_Blocks", 0.25f },
                { "_Glitch_Lines", 0.5f },
                { "_Glitch_UPS", 15.0f },
                { "_Glitch_ActiveTime", 0.4f },
                { "_Glitch_PeriodTime", 6.0f },
                { "_Glitch_Duration", 0.4f },
                { "_Glitch_Displace", 0.02f },
                { "_Glitch_Pixelization", 0.8f },
                { "_Glitch_Shift", 0.05f },
                { "_Glitch_Grayscale", 1.0f },
                { "_Glitch_ColorShift", 0.1f },
                { "_Glitch_Interleave", 0.5f },
                { "_Glitch_BrokenBlock", 0.05f },
                { "_Glitch_Posterization", 0.9f },
                { "_Glitch_Displace_Chance", 0.01f },
                { "_Glitch_Pixelization_Chance", 1.0f },
                { "_Glitch_Shift_Chance", 0.05f },
                { "_Glitch_Grayscale_Chance", 0.1f },
                { "_Glitch_ColorShift_Chance", 1.0f },
                { "_Glitch_Interleave_Chance", 0.05f },
                { "_Glitch_BrokenBlock_Chance", 1.0f },
                { "_Glitch_Posterization_Chance", 1.0f },
            };
            presets[1] = new Dictionary<string, float>(30) //Packet loss
            {
                { "Glitch", 1.0f },
                { "_Glitch_Intensity", 0.4f },
                { "_Glitch_BlockSize", 20.0f },
                { "_Glitch_Macroblock", 0.6f },
                { "_Glitch_Blocks", 1.0f },
                { "_Glitch_Lines", 0.12f },
                { "_Glitch_UPS", 15.0f },
                { "_Glitch_ActiveTime", 1.0f },
                { "_Glitch_PeriodTime", 3.0f },
                { "_Glitch_Duration", 0.4f },
                { "_Glitch_Displace", 0.0f },
                { "_Glitch_Pixelization", 1.0f },
                { "_Glitch_Shift", 0.0f },
                { "_Glitch_Grayscale", 0.5f },
                { "_Glitch_ColorShift", 0.02f },
                { "_Glitch_Interleave", 0.2f },
                { "_Glitch_BrokenBlock", 0.0f },
                { "_Glitch_Posterization", 0.5f },
                { "_Glitch_Displace_Chance", 1.0f },
                { "_Glitch_Pixelization_Chance", 1.0f },
                { "_Glitch_Shift_Chance", 0.0f },
                { "_Glitch_Grayscale_Chance", 1.0f },
                { "_Glitch_ColorShift_Chance", 1.0f },
                { "_Glitch_Interleave_Chance", 0.1f },
                { "_Glitch_BrokenBlock_Chance", 0.0f },
                { "_Glitch_Posterization_Chance", 1.0f },
            };
            presets[2] = new Dictionary<string, float>(30) //Virtual Reality
            {
                { "Glitch", 1.0f },
                { "_Glitch_Intensity", 1.0f },
                { "_Glitch_BlockSize", 8.0f },
                { "_Glitch_Macroblock", 0.5f },
                { "_Glitch_Blocks", 0.4f },
                { "_Glitch_Lines", 0.1f },
                { "_Glitch_UPS", 15.0f },
                { "_Glitch_ActiveTime", 0.5f },
                { "_Glitch_PeriodTime", 3.0f },
                { "_Glitch_Duration", 0.4f },
                { "_Glitch_Displace", 0.02f },
                { "_Glitch_Pixelization", 0.6f },
                { "_Glitch_Shift", 0.0f },
                { "_Glitch_Grayscale", 0.0f },
                { "_Glitch_ColorShift", 0.05f },
                { "_Glitch_Interleave", 0.0f },
                { "_Glitch_BrokenBlock", 0.0f },
                { "_Glitch_Posterization", 0.0f },
                { "_Glitch_Displace_Chance", 0.1f },
                { "_Glitch_Pixelization_Chance", 1.0f },
                { "_Glitch_Shift_Chance", 0.0f },
                { "_Glitch_Grayscale_Chance", 0.0f },
                { "_Glitch_ColorShift_Chance", 1.0f },
                { "_Glitch_Interleave_Chance", 0.0f },
                { "_Glitch_BrokenBlock_Chance", 0.0f },
                { "_Glitch_Posterization_Chance", 0.0f },
            };
            presets[3] = new Dictionary<string, float>(30) //Desync
            {
                { "Glitch", 1.0f },
                { "_Glitch_Intensity", 0.5f },
                { "_Glitch_BlockSize", 3.0f },
                { "_Glitch_Macroblock", 0.5f },
                { "_Glitch_Blocks", 0.0f },
                { "_Glitch_Lines", 0.4f },
                { "_Glitch_UPS", 15.0f },
                { "_Glitch_ActiveTime", 1.0f },
                { "_Glitch_PeriodTime", 3.0f },
                { "_Glitch_Duration", 0.4f },
                { "_Glitch_Displace", 0.5f },
                { "_Glitch_Pixelization", 0.8f },
                { "_Glitch_Shift", 0.2f },
                { "_Glitch_Grayscale", 1.0f },
                { "_Glitch_ColorShift", 1.0f },
                { "_Glitch_Interleave", 0.2f },
                { "_Glitch_BrokenBlock", 1.0f },
                { "_Glitch_Posterization", 1.0f },
                { "_Glitch_Displace_Chance", 0.2f },
                { "_Glitch_Pixelization_Chance", 0.5f },
                { "_Glitch_Shift_Chance", 0.1f },
                { "_Glitch_Grayscale_Chance", 0.5f },
                { "_Glitch_ColorShift_Chance", 0.2f },
                { "_Glitch_Interleave_Chance", 0.2f },
                { "_Glitch_BrokenBlock_Chance", 0.05f },
                { "_Glitch_Posterization_Chance", 0.1f },
            };
            presets[4] = new Dictionary<string, float>(30) //Dark static noise
            {
                { "Glitch", 1.0f },
                { "_Glitch_Intensity", 0.9f },
                { "_Glitch_BlockSize", 100.0f },
                { "_Glitch_Macroblock", 0.8f },
                { "_Glitch_Blocks", 1.0f },
                { "_Glitch_Lines", 0.0f },
                { "_Glitch_UPS", 30.0f },
                { "_Glitch_ActiveTime", 1.0f },
                { "_Glitch_PeriodTime", 3.0f },
                { "_Glitch_Duration", 0.4f },
                { "_Glitch_Displace", 0.01f },
                { "_Glitch_Pixelization", 0.0f },
                { "_Glitch_Shift", 0.0f },
                { "_Glitch_Grayscale", 0.0f },
                { "_Glitch_ColorShift", 0.05f },
                { "_Glitch_Interleave", 0.0f },
                { "_Glitch_BrokenBlock", 0.0f },
                { "_Glitch_Posterization", 1.0f },
                { "_Glitch_Displace_Chance", 0.3f },
                { "_Glitch_Pixelization_Chance", 0.0f },
                { "_Glitch_Shift_Chance", 0.0f },
                { "_Glitch_Grayscale_Chance", 0.0f },
                { "_Glitch_ColorShift_Chance", 0.15f },
                { "_Glitch_Interleave_Chance", 0.0f },
                { "_Glitch_BrokenBlock_Chance", 0.0f },
                { "_Glitch_Posterization_Chance", 1.0f },
            };
            presets[5] = new Dictionary<string, float>(30) //Cancer
            {
                { "Glitch", 1.0f },
                { "_Glitch_Intensity", 1.0f },
                { "_Glitch_BlockSize", 6.0f },
                { "_Glitch_Macroblock", 0.5f },
                { "_Glitch_Blocks", 1.0f },
                { "_Glitch_Lines", 0.75f },
                { "_Glitch_UPS", 15.0f },
                { "_Glitch_ActiveTime", 1.0f },
                { "_Glitch_PeriodTime", 6.0f },
                { "_Glitch_Duration", 0.4f },
                { "_Glitch_Displace", 0.02f },
                { "_Glitch_Pixelization", 0.8f },
                { "_Glitch_Shift", 0.05f },
                { "_Glitch_Grayscale", 1.0f },
                { "_Glitch_ColorShift", 0.25f },
                { "_Glitch_Interleave", 1.0f },
                { "_Glitch_BrokenBlock", 0.25f },
                { "_Glitch_Posterization", 0.96f },
                { "_Glitch_Displace_Chance", 0.15f },
                { "_Glitch_Pixelization_Chance", 1.0f },
                { "_Glitch_Shift_Chance", 0.2f },
                { "_Glitch_Grayscale_Chance", 0.0f },
                { "_Glitch_ColorShift_Chance", 1.0f },
                { "_Glitch_Interleave_Chance", 1.0f },
                { "_Glitch_BrokenBlock_Chance", 0.75f },
                { "_Glitch_Posterization_Chance", 1.0f },
            };
        }

        internal static void ApplyPreset(MaterialProperty[] props, int index)
        {
            foreach (var prop in presets[index])
            {
                MaterialProperty mp = FindProperty(prop.Key, props);
                if (mp != null)
                    mp.floatValue = prop.Value;
            }
        }
    }

    enum Category
    {
        MainSettings,
        Glitch,
        ZoomSettings,
        Girlscam,
        Rotation,
        ScreenTransform,
        ScreenShake,
        Pixelation,
        ScreenDistortion,
        BlurSettings,
        ChromaticAberration,
        Neon,
        HSVColourSpace,
        ColourCorrection,
        Posterization,
        Dithering,
        OverlayTexture,
        Static,
        Vignette,
        MaskTexture,
        HELP,
        Credits
    }

    enum ZoomMode
    {
        OFF, SimpleScale, Zoom, ZoomFalloff, Centering, GravitationalLens
    }
    enum BlurMode
    {
        OFF, Horizontal, Star, Circle, Radial
    }
    enum ChromaticAberrationMode
    {
        OFF, Vector, Radial
    }
    enum ChromaticAberrationQuality
    {
        SimpleSplit, Multisampling
    }

    public LeviantScreenSpaceEditor()
    {

    }

    static LeviantScreenSpaceEditor()
    {

    }
    void AssignHeaderProperties()
    {
        Glitch = FindProperty("Glitch", _props);
        Magnification = FindProperty("Magnification", _props);
        _SizeGirls = FindProperty("_SizeGirls", _props);
        ScreenRotation = FindProperty("ScreenRotation", _props);
        _ScreenHorizontalFlip = FindProperty("_ScreenHorizontalFlip", _props);
        _ScreenVerticalFlip = FindProperty("_ScreenVerticalFlip", _props);
        Shake = FindProperty("Shake", _props);
        Pixelization = FindProperty("Pixelization", _props);
        Distorsion = FindProperty("Distorsion", _props);
        Blur = FindProperty("Blur", _props);
        Chromatic_Aberration = FindProperty("Chromatic_Aberration", _props);
        Neon = FindProperty("Neon", _props);
        HSV_Selection = FindProperty("HSV_Selection", _props);
        HSV_Transform = FindProperty("HSV_Transform", _props);
        Color_Tint = FindProperty("Color_Tint", _props);
        Posterization = FindProperty("Posterization", _props);
        Overlay_Texture = FindProperty("Overlay_Texture", _props);
        Static_Noise = FindProperty("Static_Noise", _props);
        Vignette = FindProperty("Vignette", _props);
        Mask_Texture = FindProperty("Mask_Texture", _props);
    }

    //Defines Styles (Fonts)
    public void defineStyles()
    {
        labels = new Dictionary<Category, GUIContent>(32)
        {
            { Category.MainSettings, new GUIContent("Main Settings") },
            { Category.Glitch, new GUIContent("Glitch") },
            { Category.ZoomSettings, new GUIContent("Zoom Settings") },
            { Category.Girlscam, new GUIContent("Girlscam") },
            { Category.Rotation, new GUIContent("Rotation") },
            { Category.ScreenTransform, new GUIContent("Screen Transform") },
            { Category.ScreenShake, new GUIContent("Screen Shake") },
            { Category.Pixelation, new GUIContent("Pixelation") },
            { Category.ScreenDistortion, new GUIContent("Screen Distortion") },
            { Category.BlurSettings, new GUIContent("Blur Settings") },
            { Category.ChromaticAberration, new GUIContent("Chromatic Aberration") },
            { Category.Neon, new GUIContent("Neon") },
            { Category.HSVColourSpace, new GUIContent("HSV Colour Space") },
            { Category.ColourCorrection, new GUIContent("Colour Correction") },
            { Category.Posterization, new GUIContent("Posterization") },
            { Category.Dithering, new GUIContent("Dithering") },
            { Category.OverlayTexture, new GUIContent("Overlay Texture") },
            { Category.Static, new GUIContent("Static") },
            { Category.Vignette, new GUIContent("Vignette") },
            { Category.MaskTexture, new GUIContent("Mask Texture") },
            { Category.HELP, new GUIContent("HELP!") },
            { Category.Credits, new GUIContent("Credits") }
        };

        bannerTex = Resources.Load<Texture2D>("LeviantHeaderNew");

        linkStyle = new GUIStyle();
        linkStyle.fontSize = 12;
        linkStyle.hover.textColor = Color.blue;
        linkStyle.alignment = TextAnchor.MiddleCenter;
        linkStyle.padding = new RectOffset(8, 8, 8, 8);

        foldLabelStyle = new GUIStyle(EditorStyles.foldout);
        foldLabelStyle.fontSize = 13;
        foldLabelStyle.fontStyle = FontStyle.Bold;
        foldLabelStyle.alignment = TextAnchor.MiddleLeft;
        foldLabelStyle.padding = new RectOffset(18, 2, 3, 3);

        toggleStyle = new GUIStyle(EditorStyles.toggle);
        toggleStyle.alignment = TextAnchor.MiddleRight;
        layoutStyle = new GUIStyle(EditorStyles.helpBox);
        layoutStyle.margin.left = 0;
        layoutStyle.margin.right = 0;
        layoutStyle.padding.left = 0;
        layoutStyle.padding.right = 0;
        introLayoutStyle = new GUIStyle();
    }
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        _material = materialEditor.target as Material;
        _props = props;
        _materialEditor = materialEditor;
        if(firstCall)
        {
            firstCall = false;
            Particle_Render = FindProperty("Particle_Render", _props);
            warning = CheckParticleSystem(false);
        }
        if (toggleStyle == null)
            defineStyles();

        AssignHeaderProperties();

        DrawGUI();

        Undo.RecordObject(_material, "Material Edition");
    }
    void DrawBanner()
    {
        if (bannerTex != null)
        {
            GUILayout.Space(3);
            Rect rect = GUILayoutUtility.GetRect(0, int.MaxValue, 100, 100);
            EditorGUI.DrawPreviewTexture(rect, bannerTex, null, ScaleMode.ScaleAndCrop);
            GUILayout.Space(3);
        }
    }

    void DrawGUI()
    {
        EditorGUILayout.BeginVertical();
        DrawBanner();   //Draws Banner Image

        if (BeginFold(Category.MainSettings, warning ? EditorGUIUtility.IconContent("console.warnicon") : null))
        {
            DrawMainSettings();
        }
        EndFold();

        if (BeginToggleFold(Category.Glitch, Glitch))
        {
            DrawGlitch();
        }
        EndFold();

        if (BeginFold(Category.ZoomSettings, Magnification))
        {
            DrawZoomSettings();
        }
        EndFold();

        if (BeginFold(Category.Girlscam, _SizeGirls))
        {
            DrawGirlscam();
        }
        EndFold();

        if (BeginToggleFold(Category.Rotation, ScreenRotation))
        {
            DrawRotation();
        }
        EndFold();

        if (BeginFold(Category.ScreenTransform, _ScreenHorizontalFlip, _ScreenVerticalFlip))
        {
            DrawScreenTransform();
        }
        EndFold();

        if (BeginToggleFold(Category.ScreenShake, Shake))
        {
            DrawScreenShake();
        }
        EndFold();

        if (BeginToggleFold(Category.Pixelation, Pixelization))
        {
            DrawPixelation();
        }
        EndFold();

        if (BeginToggleFold(Category.ScreenDistortion, Distorsion))
        {
            DrawScreenDistortion();
        }
        EndFold();

        if (BeginFold(Category.BlurSettings, Blur))
        {
            DrawBlurSettings();
        }
        EndFold();

        if (BeginFold(Category.ChromaticAberration, Chromatic_Aberration))
        {
            DrawChromaticAberration();
        }
        EndFold();

        if (BeginToggleFold(Category.Neon, Neon))
        {
            DrawNeon();
        }
        EndFold();

        if (BeginFold(Category.HSVColourSpace, HSV_Selection, HSV_Transform))
        {
            DrawHSVColourSpace();
        }
        EndFold();

        if (BeginToggleFold(Category.ColourCorrection, Color_Tint))
        {
            DrawColourCorrection();
        }
        EndFold();

        if (BeginToggleFold(Category.Posterization, Posterization))
        {
            DrawPosterization();
        }
        EndFold();

        if (BeginToggleFold(Category.OverlayTexture, Overlay_Texture))
        {
            DrawOverlayTexture();
        }
        EndFold();

        if (BeginToggleFold(Category.Static, Static_Noise))
        {
            DrawStatic();
        }
        EndFold();

        if (BeginToggleFold(Category.Vignette, Vignette))
        {
            DrawVignette();
        }
        EndFold();
        if (BeginToggleFold(Category.MaskTexture, Mask_Texture))
        {
            DrawMaskTexture();
        }
        EndFold();

        if (BeginFold(Category.HELP))
        {
            DrawHELP();
        }
        EndFold();

        if (BeginFold(Category.Credits))
        {
            DrawCredits();
        }
        EndFold();

        DrawLeviantPayPal();
        EditorGUILayout.EndVertical();
    }

    //applying dark or light theme text
    public void generateMessage(String textToDis, GUIStyle textStyle)
    {
        String colorModifier = "000000";
    }
    Vector4 Pow(Vector4 x, float p)
    {
        Vector4 result;
        result.x = Mathf.Pow(x.x, p);
        result.y = Mathf.Pow(x.y, p);
        result.z = Mathf.Pow(x.z, p);
        result.w = Mathf.Pow(x.w, p);
        return result;
    }
    float RNGPowL(float pow)
    {
        return Mathf.Pow(UnityEngine.Random.value, pow);
    }
    float RNGPowC(float min, float max, float pow)
    {
        float value = UnityEngine.Random.value * 2.0f - 1.0f;
        float sign = Mathf.Sign(value);
        return (Mathf.Pow(value * sign, pow) * sign * 0.5f + 0.5f) * (max - min) + min;
    }
    Vector4 V_RNGPowL(Vector4 min, Vector4 max, float pow)
    {
        Vector4 value;
        value.x = Mathf.Pow(UnityEngine.Random.value, pow);
        value.y = Mathf.Pow(UnityEngine.Random.value, pow);
        value.z = Mathf.Pow(UnityEngine.Random.value, pow);
        value.w = Mathf.Pow(UnityEngine.Random.value, pow);
        return Vector4.Scale(value, max - min) + min;
    }
    Vector4 V_RNGPowC(Vector4 min, Vector4 max, float pow)
    {
        Vector4 value;
        value.x = UnityEngine.Random.value;
        value.y = UnityEngine.Random.value;
        value.z = UnityEngine.Random.value;
        value.w = UnityEngine.Random.value;
        Vector4 sign;
        sign.x = Mathf.Sign(value.x);
        sign.y = Mathf.Sign(value.y);
        sign.z = Mathf.Sign(value.z);
        sign.w = Mathf.Sign(value.w);
        value = Vector4.Scale(Pow(Vector4.Scale(value, sign), pow), sign);
        value = value * 0.5f + Vector4.one * 0.5f;
        return Vector4.Scale(value, max - min) + min;
    }
    float poly5(float a, float b, float c, float d, float f, float g)
    {
        float x = UnityEngine.Random.value;
        float x2 = x * x;
        float x3 = x2 * x;
        float x4 = x2 * x2;
        float x5 = x4 * x;
        return a * x + b * x2 + c * x3 + d * x4 + f * x5 + g;
    }
    void RandomizeGlitch()
    {
        FindGlitchProperties();
        _Glitch_Intensity.floatValue = 1.0f;
        _Glitch_BlockSize.floatValue = poly5(24.0571f, 26.7186f, 94.8191f, -689.615f, 743.02f, 1.07337f);
        _Glitch_Macroblock.floatValue = RNGPowC(0, 1, 3.0f);
        _Glitch_Blocks.floatValue = RNGPowL(1.5f);
        _Glitch_Lines.floatValue = RNGPowL(2.0f);
        _Glitch_UPS.floatValue = RNGPowC(0, 30, 3.0f);
        _Glitch_ActiveTime.floatValue = RNGPowL(0.4f);
        _Glitch_PeriodTime.floatValue = 11.0f * Mathf.Exp(1.0f - 3.4f * UnityEngine.Random.value);

        _Glitch_Displace.floatValue = RNGPowL(4.0f);
        _Glitch_Pixelization.floatValue = RNGPowL(1.0f);
        _Glitch_Shift.floatValue = RNGPowL(4.0f);
        _Glitch_Grayscale.floatValue = RNGPowL(1.0f);
        _Glitch_ColorShift.floatValue = RNGPowL(2.0f);
        _Glitch_Interleave.floatValue = RNGPowL(2.5f);
        _Glitch_BrokenBlock.floatValue = RNGPowL(5.0f);
        _Glitch_Posterization.floatValue = RNGPowL(2.0f);

        _Glitch_Displace_Chance.floatValue = RNGPowL(3.0f);
        _Glitch_Pixelization_Chance.floatValue = RNGPowL(1.5f);
        _Glitch_Shift_Chance.floatValue = RNGPowL(3.0f);
        _Glitch_Grayscale_Chance.floatValue = RNGPowL(2.0f);
        _Glitch_ColorShift_Chance.floatValue = RNGPowL(1.5f);
        _Glitch_Interleave_Chance.floatValue = RNGPowL(2.0f);
        _Glitch_BrokenBlock_Chance.floatValue = RNGPowL(3.0f);
        _Glitch_Posterization_Chance.floatValue = RNGPowL(1.5f);
    }
    void RandomizeStatic()
    {
        FindStaticProperties();
        _StaticColour.colorValue = Color.Lerp(Color.white, UnityEngine.Random.ColorHSV(0, 1, 1, 1, 1, 1, 1, 1), RNGPowL(2.0f));
        _StaticIntensity.floatValue = RNGPowC(-1, 1, 1.0f);
        _StaticAlpha.floatValue = RNGPowL(1.0f);
        _StaticBrightness.floatValue = RNGPowL(0.5f);
        //_MaskAmount = FindProperty("_MaskAmount", _props);
    }
    void RandomizeShake()
    {
        FindShakeProperties();
        _SIntensity_X.floatValue = RNGPowL(4.0f);
        _SIntensity_Y.floatValue = RNGPowL(4.0f);
        _ShakeScroll.vectorValue = V_RNGPowC(new Vector4(-10, -10), new Vector4(10, 10), 2.0f);
        _ShakeWave.vectorValue = V_RNGPowL(Vector4.zero, new Vector4(0.1f, 0.1f), 5.0f);
        _ShakeWaveSpeed.vectorValue = V_RNGPowL(Vector4.zero, new Vector4(100.0f, 100.0f), 2.0f);
    }
    void RandomizeDistorsion()
    {
        FindDistorsionProperties();
        //Wave_Distorsion.floatValue = 1.0f;
        //Texture_Distorsion.floatValue = 0.0f;
        _DIntensity_X.floatValue = RNGPowL(4.0f);
        _DIntensity_Y.floatValue = RNGPowL(4.0f);
        _DistorsionScroll.vectorValue = V_RNGPowC(new Vector4(-10, -10), new Vector4(10, 10), 2.0f);
        _DistorsionWave.vectorValue = V_RNGPowL(Vector4.zero, new Vector4(0.1f, 0.1f), 4.0f);
        _DistorsionWaveSpeed.vectorValue = V_RNGPowC(new Vector4(-5.0f, -5.0f), new Vector4(5.0f, 5.0f), 3.0f);
        _DistorsionWaveDensity.vectorValue = V_RNGPowL(Vector4.zero, new Vector4(100.0f, 100.0f), 3.0f);
    }
    void RandomizeBlur()
    {
        if (Distorsion.floatValue == 0)
            RandomizeDistorsion();
        FindBlurProperties();
        Blur_Distorsion.floatValue = Mathf.FloorToInt(UnityEngine.Random.value * 1.2f);
        _Blur_Dithering.floatValue = 1.0f;
        _BlurColor.colorValue = Color.Lerp(Color.white, UnityEngine.Random.ColorHSV(0, 1, 1, 1, 1, 1, 1, 1), RNGPowL(2.0f));
        _BlurRange.floatValue = RNGPowL(3.0f);
        _BlurRotation.floatValue = RNGPowC(-1, 1, 1.0f);
        _BlurRotationSpeed.floatValue = RNGPowC(-100, 100, 4.0f);
        _BlurIterations.floatValue = UnityEngine.Random.Range(1, 128);
        _BlurCenterOffset.vectorValue = V_RNGPowC(new Vector4(-1.0f, -1.0f), new Vector4(1.0f, 1.0f), 1.0f);
        _BlurMask.floatValue = 1.0f;
    }
    void RandomizeChromatic()
    {
        FindChromaticProperties();
        Aberration_Quality.floatValue = Mathf.FloorToInt(UnityEngine.Random.value * 3.0f);
        CA_Distorsion.floatValue = Mathf.FloorToInt(UnityEngine.Random.value * 1.2f);
        _CA_dithering.floatValue = 1.0f;
        _CA_amplitude.floatValue = RNGPowL(3.0f);
        _CA_iterations.floatValue = UnityEngine.Random.Range(1, 128);
        _CA_speed.floatValue = 0;
        _CA_direction.vectorValue = V_RNGPowC(new Vector4(-1.0f, -1.0f), new Vector4(1.0f, 1.0f), 1.0f);
        _CA_factor.floatValue = RNGPowL(0.5f);
        _CA_centerOffset.vectorValue = V_RNGPowC(new Vector4(-1.0f, -1.0f), new Vector4(1.0f, 1.0f), 1.0f);
        _CA_mask.floatValue = 1.0f;
    }
    void RandomizeNeon()
    {
        FindNeonProperties();
        _NeonColor.colorValue = Color.Lerp(Color.white, UnityEngine.Random.ColorHSV(0, 1, 1, 1, 1, 1, 1, 1), RNGPowL(2.0f));
        _NeonColorAlpha = FindProperty("_NeonColorAlpha", _props);
        _NeonOrigColor.colorValue = Color.Lerp(Color.black, UnityEngine.Random.ColorHSV(0, 1, 1, 1, 1, 1, 1, 1), RNGPowL(2.0f));
        _NeonOrigColorAlpha = FindProperty("_NeonOrigColorAlpha", _props);
        _NeonBrightness.floatValue = UnityEngine.Random.value * 5.0f;
        _NeonPosterization.floatValue = UnityEngine.Random.value;
        _NeonWidth.floatValue = UnityEngine.Random.value * 5.0f + 1.0f;
        _NeonGlow.floatValue = UnityEngine.Random.value;
    }
    void RandomizeHSV()
    {
        FindHSVProperties();
        _TargetColor.colorValue = UnityEngine.Random.ColorHSV();
        _HueRange.floatValue = RNGPowL(3.0f);
        _SaturationRange.floatValue = RNGPowL(3.0f);
        _LightnessRange.floatValue = RNGPowL(3.0f);
        _HueSmoothRange.floatValue = RNGPowL(3.0f);
        _SaturationSmoothRange.floatValue = RNGPowL(3.0f);
        _LightnessSmoothRange.floatValue = RNGPowL(3.0f);
        HSV_Desaturate_Selected.floatValue = Mathf.FloorToInt(UnityEngine.Random.value * 2.0f);
        _TransformColor.colorValue = UnityEngine.Random.ColorHSV();
        _Hue.floatValue = RNGPowL(2.0f);
        _HueAnimationSpeed.floatValue = RNGPowL(2.0f);
        _Saturation.floatValue = RNGPowL(2.0f);
        _Lightness.floatValue = RNGPowL(2.0f);
    }
    void RandomizeCC()
    {
        FindCCProperties();
        ACES_Tonemapping.floatValue = Mathf.FloorToInt(UnityEngine.Random.value * 1.4f);
        _EmissionColor.colorValue = Color.Lerp(Color.black, UnityEngine.Random.ColorHSV(0, 1, 1, 1, 1, 1, 1, 1), RNGPowL(4.0f));
        _Color.colorValue = UnityEngine.Random.ColorHSV();
        _ColorAlpha.floatValue = RNGPowL(3.0f);
        _Grayscale.floatValue = RNGPowL(3.0f);
        _Contrast.vectorValue = V_RNGPowC(Vector4.zero, new Vector4(2.0f, 2.0f, 2.0f), 4.0f);
        _Gamma.vectorValue = V_RNGPowC(Vector4.zero, new Vector4(2.0f, 2.0f, 2.0f), 4.0f);
        _Brightness.vectorValue = V_RNGPowC(Vector4.zero, new Vector4(2.0f, 2.0f, 2.0f), 4.0f);
        _RedInvert.floatValue = RNGPowL(3.0f);
        _GreenInvert.floatValue = RNGPowL(3.0f);
        _BlueInvert.floatValue = RNGPowL(3.0f);
    }
    void ResetCC()
    {
        FindCCProperties();
        ACES_Tonemapping.floatValue = 0;
        _EmissionColor.colorValue = Color.black;
        _Color.colorValue = Color.black;
        _ColorAlpha.floatValue = 0;
        _Grayscale.floatValue = 0;
        _Contrast.vectorValue = Vector4.one;
        _Gamma.vectorValue =  Vector4.one;
        _Brightness.vectorValue = Vector4.one;
        _RedInvert.floatValue = 0;
        _GreenInvert.floatValue = 0;
        _BlueInvert.floatValue = 0;
    }
    void RandomizeVignette()
    {
        FindVignetteProperties();
        _VignetteColor.colorValue = Color.Lerp(Color.black, UnityEngine.Random.ColorHSV(0, 1, 1, 1, 1, 1, 1, 1), RNGPowL(3.0f));
        _VignetteAlpha.floatValue = RNGPowL(1.3f);
        _VignetteWidth.floatValue = RNGPowL(3.0f);
        _VignetteShape.floatValue = RNGPowC(-1, 1, 2.0f);
        _VignetteRounding.floatValue = UnityEngine.Random.value;
    }
    void RandomizeEffects()
    {
        const int maxEffects = 17;
        const int maxActiveEffects = 5;
        
        int activeCount = 1 + Mathf.FloorToInt(UnityEngine.Random.value * maxActiveEffects + 1.0f);
        int[] MyRandomArray = Enumerable.Range(0, maxEffects).OrderBy(x => UnityEngine.Random.value).ToArray();
        Func<int, float> rng = (int index) =>
        {
            return MyRandomArray[index] < activeCount ? 1.0f : 0.0f;
        };
        Glitch.floatValue = rng(0);
        if (Glitch.floatValue != 0)
            RandomizeGlitch();
        Magnification.floatValue = rng(1);
        if (Magnification.floatValue != 0)
            Magnification.floatValue = Mathf.FloorToInt(UnityEngine.Random.Range(0, 6));
        _SizeGirls.floatValue = rng(2);
        if (_SizeGirls.floatValue != 0)
            _SizeGirls.floatValue = UnityEngine.Random.value * 0.6f;
        ScreenRotation.floatValue = rng(3);
        Shake.floatValue = rng(4);
        if (Shake.floatValue != 0)
            RandomizeShake();
        Pixelization.floatValue = rng(5);
        Distorsion.floatValue = rng(6);
        if (Distorsion.floatValue != 0)
            RandomizeDistorsion();

        Blur.floatValue = rng(7);
        Chromatic_Aberration.floatValue = 0;
        if (Blur.floatValue != 0)
        {
            Blur.floatValue = Mathf.FloorToInt(UnityEngine.Random.Range(1, 5));
            RandomizeBlur();
        }
        else
        {
            Chromatic_Aberration.floatValue = rng(8);
            if (Chromatic_Aberration.floatValue != 0)
            {
                Chromatic_Aberration.floatValue = Mathf.FloorToInt(UnityEngine.Random.Range(1, 3));
                RandomizeChromatic();
            }
        }
        Neon.floatValue = rng(9);
        if (Neon.floatValue != 0)
            RandomizeNeon();
        HSV_Selection.floatValue = rng(10);
        HSV_Transform.floatValue = rng(11);
        if (HSV_Selection.floatValue != 0 || HSV_Transform.floatValue != 0)
            RandomizeHSV();
        Color_Tint.floatValue = rng(12);
        if (Color_Tint.floatValue != 0)
            RandomizeCC();
        else
            ResetCC();
        Posterization.floatValue = rng(13);
        Overlay_Texture.floatValue = rng(14);
        Static_Noise.floatValue = rng(15);
        if (Static_Noise.floatValue != 0)
            RandomizeStatic();
        Vignette.floatValue = rng(16);
        if (Vignette.floatValue != 0)
            RandomizeVignette();
    }
    void FindGlitchProperties()
    {
        _Glitch_Intensity = FindProperty("_Glitch_Intensity", _props);
        _Glitch_BlockSize = FindProperty("_Glitch_BlockSize", _props);
        _Glitch_Macroblock = FindProperty("_Glitch_Macroblock", _props);
        _Glitch_Blocks = FindProperty("_Glitch_Blocks", _props);
        _Glitch_Lines = FindProperty("_Glitch_Lines", _props);
        _Glitch_UPS = FindProperty("_Glitch_UPS", _props);
        _Glitch_ActiveTime = FindProperty("_Glitch_ActiveTime", _props);
        _Glitch_PeriodTime = FindProperty("_Glitch_PeriodTime", _props);
        _Glitch_Duration = FindProperty("_Glitch_Duration", _props);
        _Glitch_Displace = FindProperty("_Glitch_Displace", _props);
        _Glitch_Pixelization = FindProperty("_Glitch_Pixelization", _props);
        _Glitch_Shift = FindProperty("_Glitch_Shift", _props);
        _Glitch_Grayscale = FindProperty("_Glitch_Grayscale", _props);
        _Glitch_ColorShift = FindProperty("_Glitch_ColorShift", _props);
        _Glitch_Interleave = FindProperty("_Glitch_Interleave", _props);
        _Glitch_BrokenBlock = FindProperty("_Glitch_BrokenBlock", _props);
        _Glitch_Posterization = FindProperty("_Glitch_Posterization", _props);
        _Glitch_Displace_Chance = FindProperty("_Glitch_Displace_Chance", _props);
        _Glitch_Pixelization_Chance = FindProperty("_Glitch_Pixelization_Chance", _props);
        _Glitch_Shift_Chance = FindProperty("_Glitch_Shift_Chance", _props);
        _Glitch_Grayscale_Chance = FindProperty("_Glitch_Grayscale_Chance", _props);
        _Glitch_ColorShift_Chance = FindProperty("_Glitch_ColorShift_Chance", _props);
        _Glitch_Interleave_Chance = FindProperty("_Glitch_Interleave_Chance", _props);
        _Glitch_BrokenBlock_Chance = FindProperty("_Glitch_BrokenBlock_Chance", _props);
        _Glitch_Posterization_Chance = FindProperty("_Glitch_Posterization_Chance", _props);
    }
    void FindZoomProperties()
    {
        _Magnification = FindProperty("_Magnification", _props);
        _Gravitation = FindProperty("_Gravitation", _props);
        _AngleStartFade = FindProperty("_AngleStartFade", _props);
        _MaxAngle = FindProperty("_MaxAngle", _props);
    }
    void FindShakeProperties()
    {
        _ShakeTex = FindProperty("_ShakeTex", _props);
        _SIntensity_X = FindProperty("_SIntensity_X", _props);
        _SIntensity_Y = FindProperty("_SIntensity_Y", _props);
        _ShakeScroll = FindProperty("_ShakeScroll", _props);
        _ShakeWave = FindProperty("_ShakeWave", _props);
        _ShakeWaveSpeed = FindProperty("_ShakeWaveSpeed", _props);
    }
    void FindDistorsionProperties()
    {
        Wave_Distorsion = FindProperty("Wave_Distorsion", _props);
        Texture_Distorsion = FindProperty("Texture_Distorsion", _props);
        _DistorsionTex = FindProperty("_DistorsionTex", _props);
        _DIntensity_X = FindProperty("_DIntensity_X", _props);
        _DIntensity_Y = FindProperty("_DIntensity_Y", _props);
        _DistorsionScroll = FindProperty("_DistorsionScroll", _props);
        _DistorsionWave = FindProperty("_DistorsionWave", _props);
        _DistorsionWaveSpeed = FindProperty("_DistorsionWaveSpeed", _props);
        _DistorsionWaveDensity = FindProperty("_DistorsionWaveDensity", _props);
    }
    void FindBlurProperties()
    {
        Blur_Distorsion = FindProperty("Blur_Distorsion", _props);
        _Blur_Dithering = FindProperty("_Blur_Dithering", _props);
        _BlurColor = FindProperty("_BlurColor", _props);
        _BlurRange = FindProperty("_BlurRange", _props);
        _BlurRotation = FindProperty("_BlurRotation", _props);
        _BlurRotationSpeed = FindProperty("_BlurRotationSpeed", _props);
        _BlurIterations = FindProperty("_BlurIterations", _props);
        _BlurCenterOffset = FindProperty("_BlurCenterOffset", _props);
        _BlurMask = FindProperty("_BlurMask", _props);
    }
    void FindChromaticProperties()
    {
        Aberration_Quality = FindProperty("Aberration_Quality", _props);
        CA_Distorsion = FindProperty("CA_Distorsion", _props);
        _CA_dithering = FindProperty("_CA_dithering", _props);
        _CA_amplitude = FindProperty("_CA_amplitude", _props);
        _CA_iterations = FindProperty("_CA_iterations", _props);
        _CA_speed = FindProperty("_CA_speed", _props);
        _CA_direction = FindProperty("_CA_direction", _props);
        _CA_factor = FindProperty("_CA_factor", _props);
        _CA_centerOffset = FindProperty("_CA_centerOffset", _props);
        _CA_mask = FindProperty("_CA_mask", _props);
    }
    void FindNeonProperties()
    {
        _NeonColor = FindProperty("_NeonColor", _props);
        _NeonColorAlpha = FindProperty("_NeonColorAlpha", _props);
        _NeonOrigColor = FindProperty("_NeonOrigColor", _props);
        _NeonOrigColorAlpha = FindProperty("_NeonOrigColorAlpha", _props);
        _NeonBrightness = FindProperty("_NeonBrightness", _props);
        _NeonPosterization = FindProperty("_NeonPosterization", _props);
        _NeonWidth = FindProperty("_NeonWidth", _props);
        _NeonGlow = FindProperty("_NeonGlow", _props);
    }
    void FindHSVProperties()
    {
        _TargetColor = FindProperty("_TargetColor", _props);
        _HueRange = FindProperty("_HueRange", _props);
        _SaturationRange = FindProperty("_SaturationRange", _props);
        _LightnessRange = FindProperty("_LightnessRange", _props);
        _HueSmoothRange = FindProperty("_HueSmoothRange", _props);
        _SaturationSmoothRange = FindProperty("_SaturationSmoothRange", _props);
        _LightnessSmoothRange = FindProperty("_LightnessSmoothRange", _props);
        HSV_Desaturate_Selected = FindProperty("HSV_Desaturate_Selected", _props);
        _TransformColor = FindProperty("_TransformColor", _props);
        _Hue = FindProperty("_Hue", _props);
        _HueAnimationSpeed = FindProperty("_HueAnimationSpeed", _props);
        _Saturation = FindProperty("_Saturation", _props);
        _Lightness = FindProperty("_Lightness", _props);
    }
    void FindCCProperties()
    {
        ACES_Tonemapping = FindProperty("ACES_Tonemapping", _props);
        _EmissionColor = FindProperty("_EmissionColor", _props);
        _Color = FindProperty("_Color", _props);
        _ColorAlpha = FindProperty("_ColorAlpha", _props);
        _Grayscale = FindProperty("_Grayscale", _props);
        _Contrast = FindProperty("_Contrast", _props);
        _Gamma = FindProperty("_Gamma", _props);
        _Brightness = FindProperty("_Brightness", _props);
        _RedInvert = FindProperty("_RedInvert", _props);
        _GreenInvert = FindProperty("_GreenInvert", _props);
        _BlueInvert = FindProperty("_BlueInvert", _props);
    }
    void FindStaticProperties()
    {
        _StaticColour = FindProperty("_StaticColour", _props);
        _StaticIntensity = FindProperty("_StaticIntensity", _props);
        _StaticAlpha = FindProperty("_StaticAlpha", _props);
        _StaticBrightness = FindProperty("_StaticBrightness", _props);
        _MaskAmount = FindProperty("_MaskAmount", _props);
    }
    void FindVignetteProperties()
    {
        _VignetteColor = FindProperty("_VignetteColor", _props);
        _VignetteAlpha = FindProperty("_VignetteAlpha", _props);
        _VignetteWidth = FindProperty("_VignetteWidth", _props);
        _VignetteShape = FindProperty("_VignetteShape", _props);
        _VignetteRounding = FindProperty("_VignetteRounding", _props);
    }
    bool CheckParticleSystem(bool render)
    {
        bool warning = false;
        GameObject go = Selection.activeObject as GameObject;
        if (go != null)
        {
            ParticleSystemRenderer particles = go.GetComponent<ParticleSystemRenderer>();
            bool setupForParticles = Particle_Render.floatValue != 0.0f;
            if (setupForParticles)
            {
                if (particles != null)
                {
                    List<ParticleSystemVertexStream> streams = new List<ParticleSystemVertexStream>();
                    particles.GetActiveVertexStreams(streams);
                    bool correctSetup = particles.activeVertexStreamsCount >= 2 && streams.Contains(ParticleSystemVertexStream.Position) && streams.Contains(ParticleSystemVertexStream.Center);
                    if (!correctSetup)
                    {
                        warning = true;
                        if (!render) return warning;
                        EditorGUILayout.HelpBox("Particle System Renderer is using this material with incorrect Vertex Streams. Use Apply to System button to fix this", MessageType.Warning);
                        if (GUILayout.Button("Apply to System"))
                        {
                            if (!streams.Contains(ParticleSystemVertexStream.Position)) streams.Add(ParticleSystemVertexStream.Position);
                            if (!streams.Contains(ParticleSystemVertexStream.Center)) streams.Add(ParticleSystemVertexStream.Center);
                            particles.SetActiveVertexStreams(streams);
                        }
                    }
                }
                else
                {
                    warning = true;
                    if (!render) return warning;
                    EditorGUILayout.HelpBox("Shader rendered by Mesh Renderer, but using setup for particles. Shader will be appearing incorrectly!", MessageType.Warning);
                    if (GUILayout.Button("Fix now"))
                        Particle_Render.floatValue = 0.0f;
                }
            }
            else
            {
                if (particles != null)
                {
                    warning = true;
                    if (!render) return warning;
                    EditorGUILayout.HelpBox("Shader rendered by Particle System, but using setup for meshes. Shader will be appearing incorrectly!", MessageType.Warning);
                    if (GUILayout.Button("Fix now"))
                        Particle_Render.floatValue = 1.0f;
                }
            }
        }
        return warning;
    }
    void DrawMainSettings()
    {
        Particle_Render = FindProperty("Particle_Render", _props);
        _MinRange = FindProperty("_MinRange", _props);
        _MaxRange = FindProperty("_MaxRange", _props);

        _materialEditor.ShaderProperty(Particle_Render, "Setup for Particle System");
        warning = CheckParticleSystem(true);

        GUILayout.Label("Fade settings", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_MinRange, "Start fading");
        _materialEditor.ShaderProperty(_MaxRange, "End fading");
        GUILayout.Label("Editor settings", EditorStyles.boldLabel);
        useSliders = EditorGUILayout.Toggle("More SLIDERS!!!", useSliders);

        if (GUILayout.Button("Randomize all effects"))
            RandomizeEffects();
    }
    void DrawGlitch()
    {
        GUILayout.BeginHorizontal();
        EditorGUI.BeginChangeCheck();
        glitch_current_preset = EditorGUILayout.Popup("Preset", glitch_current_preset, GlitchPresets.name);
        if (EditorGUI.EndChangeCheck())
            GlitchPresets.ApplyPreset(_props, glitch_current_preset);
        if (GUILayout.Button("Randomize", GUILayout.MaxWidth(80)))
            RandomizeGlitch();
        GUILayout.EndHorizontal();
        GUILayout.Space(8);
        FindGlitchProperties();
        _materialEditor.ShaderProperty(_Glitch_Intensity, "Intensity");
        _materialEditor.ShaderProperty(_Glitch_BlockSize, "Block size");
        _materialEditor.ShaderProperty(_Glitch_Macroblock, "Macroblock subdivision");
        _materialEditor.ShaderProperty(_Glitch_Blocks, "Block Glitch");
        _materialEditor.ShaderProperty(_Glitch_Lines, "Line Glitch");
        _materialEditor.ShaderProperty(_Glitch_UPS, "Glitches per second");
        _materialEditor.ShaderProperty(_Glitch_ActiveTime, "Active Time");
        _materialEditor.ShaderProperty(_Glitch_PeriodTime, "Period Time");
        //_materialEditor.ShaderProperty(_Glitch_Duration, "Long duration chance");
        GUILayout.Label("Effect intensity", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_Glitch_Displace, "Displace");
        _materialEditor.ShaderProperty(_Glitch_Pixelization, "Pixelization");
        _materialEditor.ShaderProperty(_Glitch_Shift, "Shift");
        _materialEditor.ShaderProperty(_Glitch_Grayscale, "Grayscale");
        _materialEditor.ShaderProperty(_Glitch_ColorShift, "Color shift");
        _materialEditor.ShaderProperty(_Glitch_Interleave, "Interleave lines");
        _materialEditor.ShaderProperty(_Glitch_BrokenBlock, "Broken blocks");
        _materialEditor.ShaderProperty(_Glitch_Posterization, "Posterization");
        GUILayout.Label("Effect distribution", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_Glitch_Displace_Chance, "Displace");
        _materialEditor.ShaderProperty(_Glitch_Pixelization_Chance, "Pixelization");
        _materialEditor.ShaderProperty(_Glitch_Shift_Chance, "Shift");
        _materialEditor.ShaderProperty(_Glitch_Grayscale_Chance, "Grayscale");
        _materialEditor.ShaderProperty(_Glitch_ColorShift_Chance, "Color shift");
        _materialEditor.ShaderProperty(_Glitch_Interleave_Chance, "Interleave lines");
        _materialEditor.ShaderProperty(_Glitch_BrokenBlock_Chance, "Broken blocks");
        _materialEditor.ShaderProperty(_Glitch_Posterization_Chance, "Posterization");
        EditorGUILayout.HelpBox("The Glitch affects on others modules: Color Correction", MessageType.Info);
        GUILayout.Label("Digital Glitch v2", EditorStyles.miniBoldLabel);
    }
    void DrawZoomSettings()
    {
        FindZoomProperties();
        Magnification.floatValue = (float)(ZoomMode)EditorGUILayout.EnumPopup("Mode", (ZoomMode)Magnification.floatValue);
        _materialEditor.ShaderProperty(_Magnification, "Zoom/Scale");

        GUILayout.Label("Zoom ranges", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_Gravitation, "Gravitation range");
        _materialEditor.ShaderProperty(_AngleStartFade, "Angle range");
        _materialEditor.ShaderProperty(_MaxAngle, "Max Angle range");
    }
    void DrawGirlscam()
    {
        _TimeGirls = FindProperty("_TimeGirls", _props);

        _materialEditor.ShaderProperty(_SizeGirls, "Size");
        _materialEditor.ShaderProperty(_TimeGirls, "Time");

        GUILayout.Label("Looks best if you put Time to almost max and then adjust the Size to your liking.", EditorStyles.helpBox);
    }
    void DrawRotation()
    {
        _ScreenRotation = FindProperty("_ScreenRotation", _props);
        _ScreenRotationSpeed = FindProperty("_ScreenRotationSpeed", _props);

        _materialEditor.ShaderProperty(_ScreenRotation, "Angle");
        _materialEditor.ShaderProperty(_ScreenRotationSpeed, "Shake speed");
    }
    void DrawScreenTransform()
    {
        GUILayout.Label("Screen flip", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_ScreenHorizontalFlip, "Horizontal");
        _materialEditor.ShaderProperty(_ScreenVerticalFlip, "Vertical");
    }
    void DrawScreenShake()
    {
        FindShakeProperties();
        GUILayout.Label("Texture settings", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_ShakeTex, "Normal Map");
        _materialEditor.ShaderProperty(_SIntensity_X, "Intensity X");
        _materialEditor.ShaderProperty(_SIntensity_Y, "Intensity Y");
        if (useSliders)
        {
            _ShakeScroll.vectorValue = new Vector4(
                EditorGUILayout.Slider("Scroll X", _ShakeScroll.vectorValue.x, -10, 10),
                EditorGUILayout.Slider("Scroll Y", _ShakeScroll.vectorValue.y, -10, 10));

            GUILayout.Label("Wave settings", EditorStyles.boldLabel);
            _ShakeWave.vectorValue = new Vector4(
                EditorGUILayout.Slider("Offset X", _ShakeWave.vectorValue.x, 0, 0.25f),
                EditorGUILayout.Slider("Offset Y", _ShakeWave.vectorValue.y, 0, 0.25f));
            _ShakeWaveSpeed.vectorValue = new Vector4(
                EditorGUILayout.Slider("Speed X", _ShakeWaveSpeed.vectorValue.x, 0, 100),
                EditorGUILayout.Slider("Speed Y", _ShakeWaveSpeed.vectorValue.y, 0, 100));
        }
        else
        {
            _ShakeScroll.vectorValue = EditorGUILayout.Vector2Field("Scroll", _ShakeScroll.vectorValue);

            GUILayout.Label("Wave settings", EditorStyles.boldLabel);
            _ShakeWave.vectorValue = EditorGUILayout.Vector2Field("Offset", _ShakeWave.vectorValue);
            _ShakeWaveSpeed.vectorValue = EditorGUILayout.Vector2Field("Speed", _ShakeWaveSpeed.vectorValue);
        }
    }
    void DrawPixelation()
    {
        _PSize_X = FindProperty("_PSize_X", _props);
        _PSize_Y = FindProperty("_PSize_Y", _props);

        GUILayout.Label("Pixel size", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_PSize_X, "Width");
        _materialEditor.ShaderProperty(_PSize_Y, "Height");
    }
    void DrawScreenDistortion()
    {
        FindDistorsionProperties();
        GUILayout.Label("Texture settings", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(Texture_Distorsion, "Active");
        _materialEditor.ShaderProperty(_DistorsionTex, "Normal Map");
        _materialEditor.ShaderProperty(_DIntensity_X, "Horizontal distortion");
        _materialEditor.ShaderProperty(_DIntensity_Y, "Vertical distortion");
        if (useSliders)
        {
            _DistorsionScroll.vectorValue = new Vector4(
                EditorGUILayout.Slider("Scroll texture X", _DistorsionScroll.vectorValue.x, -10, 10),
                EditorGUILayout.Slider("Scroll texture Y", _DistorsionScroll.vectorValue.y, -10, 10));

            GUILayout.Label("Wave settings", EditorStyles.boldLabel);
            _materialEditor.ShaderProperty(Wave_Distorsion, "Active");
            _DistorsionWave.vectorValue = new Vector4(
                EditorGUILayout.Slider("Offset X", _DistorsionWave.vectorValue.x, 0, 0.1f),
                EditorGUILayout.Slider("Offset Y", _DistorsionWave.vectorValue.y, 0, 0.1f));
            _DistorsionWaveSpeed.vectorValue = new Vector4(
                EditorGUILayout.Slider("Speed X", _DistorsionWaveSpeed.vectorValue.x, 0, 20),
                EditorGUILayout.Slider("Speed Y", _DistorsionWaveSpeed.vectorValue.y, 0, 20));
            _DistorsionWaveDensity.vectorValue = new Vector4(
                EditorGUILayout.Slider("Density X", _DistorsionWaveDensity.vectorValue.x, 0, 10),
                EditorGUILayout.Slider("Density Y", _DistorsionWaveDensity.vectorValue.y, 0, 10));
        }
        else
        {
            _DistorsionScroll.vectorValue = EditorGUILayout.Vector2Field("Scroll texture", _DistorsionScroll.vectorValue);

            GUILayout.Label("Wave settings", EditorStyles.boldLabel);
            _materialEditor.ShaderProperty(Wave_Distorsion, "Active");
            _DistorsionWave.vectorValue = EditorGUILayout.Vector2Field("Offset", _DistorsionWave.vectorValue);
            _DistorsionWaveSpeed.vectorValue = EditorGUILayout.Vector2Field("Speed", _DistorsionWaveSpeed.vectorValue);
            _DistorsionWaveDensity.vectorValue = EditorGUILayout.Vector2Field("Density", _DistorsionWaveDensity.vectorValue);
        }
    }
    void DrawBlurSettings()
    {
        FindBlurProperties();
        Blur.floatValue = (float)(BlurMode)EditorGUILayout.EnumPopup("Mode", (BlurMode)Blur.floatValue);
        _materialEditor.ShaderProperty(Blur_Distorsion, "Use Distortion");
        _materialEditor.ShaderProperty(_Blur_Dithering, "Dithering");
        _materialEditor.ShaderProperty(_BlurColor, "Blur colour");
        _materialEditor.ShaderProperty(_BlurRange, "Offset");
        _materialEditor.ShaderProperty(_BlurRotation, "Rotation");
        _materialEditor.ShaderProperty(_BlurRotationSpeed, "Rotation speed");
        _materialEditor.ShaderProperty(_BlurIterations, "Samples");
        if (useSliders)
            _BlurCenterOffset.vectorValue = new Vector4(
                EditorGUILayout.Slider("Center offset X", _BlurCenterOffset.vectorValue.x, -1.0f, 1.0f),
                EditorGUILayout.Slider("Center offset Y", _BlurCenterOffset.vectorValue.y, -1.0f, 1.0f));
        else
            _BlurCenterOffset.vectorValue = EditorGUILayout.Vector2Field("Center offset", _BlurCenterOffset.vectorValue);
        _materialEditor.ShaderProperty(_BlurMask, "Mask effect");

        GUILayout.Label("Looks best if you put samples to max.", EditorStyles.helpBox);
    }
    void DrawChromaticAberration()
    {
        FindChromaticProperties();
        Chromatic_Aberration.floatValue = (float)(ChromaticAberrationMode)EditorGUILayout.EnumPopup("Mode", (ChromaticAberrationMode)Chromatic_Aberration.floatValue);
        Aberration_Quality.floatValue = (float)(ChromaticAberrationQuality)EditorGUILayout.EnumPopup("Quality", (ChromaticAberrationQuality)Aberration_Quality.floatValue);
        _materialEditor.ShaderProperty(CA_Distorsion, "Use distortion");
        _materialEditor.ShaderProperty(_CA_dithering, "Dithering");
        _materialEditor.ShaderProperty(_CA_amplitude, "Offset");
        _materialEditor.ShaderProperty(_CA_iterations, "Samples");
        _materialEditor.ShaderProperty(_CA_speed, "Animation speed");
        if (useSliders)
        {
            _CA_direction.vectorValue = new Vector4(
                EditorGUILayout.Slider("Vector direction X", _CA_direction.vectorValue.x, -1.0f, 1.0f),
                EditorGUILayout.Slider("Vector direction Y", _CA_direction.vectorValue.y, -1.0f, 1.0f));
            _materialEditor.ShaderProperty(_CA_factor, "Effect");
            _CA_centerOffset.vectorValue = new Vector4(
                EditorGUILayout.Slider("Radial center offset X", _CA_centerOffset.vectorValue.x, -1.0f, 1.0f),
                EditorGUILayout.Slider("Radial center offset Y", _CA_centerOffset.vectorValue.y, -1.0f, 1.0f));
        }
        else
        {
            _CA_direction.vectorValue = EditorGUILayout.Vector2Field("Vector direction", _CA_direction.vectorValue);
            _materialEditor.ShaderProperty(_CA_factor, "Effect");
            _CA_centerOffset.vectorValue = EditorGUILayout.Vector2Field("Radial center offset", _CA_centerOffset.vectorValue);
        }
        _materialEditor.ShaderProperty(_CA_mask, "Mask effect");
    }
    void DrawNeon()
    {
        FindNeonProperties();
        _materialEditor.ShaderProperty(_NeonColor, "Tint");
        _materialEditor.ShaderProperty(_NeonColorAlpha, "Intensity");
        _materialEditor.ShaderProperty(_NeonOrigColor, "Background colour");
        _materialEditor.ShaderProperty(_NeonOrigColorAlpha, "Background mix");
        _materialEditor.ShaderProperty(_NeonBrightness, "Brightness");
        _materialEditor.ShaderProperty(_NeonPosterization, "Posterization");
        _materialEditor.ShaderProperty(_NeonWidth, "Width");
        _materialEditor.ShaderProperty(_NeonGlow, "Glow");
    }
    void DrawHSVColourSpace()
    {
        FindHSVProperties();
        GUILayout.Label("Selection settings", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(HSV_Selection, "Selection enable");
        _materialEditor.ShaderProperty(_TargetColor, "Select colour");
        _materialEditor.ShaderProperty(_HueRange, "HUE range");
        _materialEditor.ShaderProperty(_SaturationRange, "Saturation range");
        _materialEditor.ShaderProperty(_LightnessRange, "Lightness range");
        _materialEditor.ShaderProperty(_HueSmoothRange, "HUE fade");
        _materialEditor.ShaderProperty(_SaturationSmoothRange, "Saturation fade");
        _materialEditor.ShaderProperty(_LightnessSmoothRange, "Lightness fade");
        _materialEditor.ShaderProperty(HSV_Desaturate_Selected, "Desaturate");

        GUILayout.Label("Transform settings", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(HSV_Transform, "Transform enable");
        _materialEditor.ShaderProperty(_TransformColor, "Transform colour");
        _materialEditor.ShaderProperty(_Hue, "HUE value");
        _materialEditor.ShaderProperty(_HueAnimationSpeed, "HUE animation speed");
        _materialEditor.ShaderProperty(_Saturation, "Saturation value");
        _materialEditor.ShaderProperty(_Lightness, "Lightness value");
    }
    void DrawColourCorrection()
    {
        FindCCProperties();
        _materialEditor.ShaderProperty(ACES_Tonemapping, "ACES tonemapping");
        _materialEditor.ShaderProperty(_EmissionColor, "Emission colour");
        _materialEditor.ShaderProperty(_Color, "Mix colour");
        _materialEditor.ShaderProperty(_ColorAlpha, "Mix factor");
        _materialEditor.ShaderProperty(_Grayscale, "Grayscale");
        if (useSliders)
        {
            GUILayout.Label("Contrast", EditorStyles.boldLabel);
            _Contrast.vectorValue = new Vector4(
                EditorGUILayout.Slider("Red", _Contrast.vectorValue.x, 0, 10),
                EditorGUILayout.Slider("Green", _Contrast.vectorValue.y, 0, 10),
                EditorGUILayout.Slider("Blue", _Contrast.vectorValue.z, 0, 10));

            GUILayout.Label("Gamma", EditorStyles.boldLabel);
            _Gamma.vectorValue = new Vector4(
                EditorGUILayout.Slider("Red", _Gamma.vectorValue.x, 0, 10),
                EditorGUILayout.Slider("Green", _Gamma.vectorValue.y, 0, 10),
                EditorGUILayout.Slider("Blue", _Gamma.vectorValue.z, 0, 10));

            GUILayout.Label("Brightness", EditorStyles.boldLabel);
            _Brightness.vectorValue = new Vector4(
                EditorGUILayout.Slider("Red", _Brightness.vectorValue.x, 0, 10),
                EditorGUILayout.Slider("Green", _Brightness.vectorValue.y, 0, 10),
                EditorGUILayout.Slider("Blue", _Brightness.vectorValue.z, 0, 10));

            GUILayout.Label("Invert", EditorStyles.boldLabel);
            _materialEditor.ShaderProperty(_RedInvert, "Red");
            _materialEditor.ShaderProperty(_GreenInvert, "Green");
            _materialEditor.ShaderProperty(_BlueInvert, "Blue");

        }
        else
        {
            _Contrast.vectorValue = EditorGUILayout.Vector3Field("Contrast", _Contrast.vectorValue);
            _Gamma.vectorValue = EditorGUILayout.Vector3Field("Gamma", _Gamma.vectorValue);
            _Brightness.vectorValue = EditorGUILayout.Vector3Field("Brightness", _Brightness.vectorValue);
            Vector3 invert = EditorGUILayout.Vector3Field("Invert", new Vector3(_RedInvert.floatValue, _GreenInvert.floatValue, _BlueInvert.floatValue));
            _RedInvert.floatValue = invert.x;
            _GreenInvert.floatValue = invert.y;
            _BlueInvert.floatValue = invert.z;
        }
        
    }
    void DrawPosterization()
    {
        _PosterizationSteps = FindProperty("_PosterizationSteps", _props);
        Dithering = FindProperty("Dithering", _props);
        Dithering_Colorize = FindProperty("Dithering_Colorize", _props);
        _DitheringMask = FindProperty("_DitheringMask", _props);

        _materialEditor.ShaderProperty(_PosterizationSteps, "Gradient steps");
        GUILayout.Label("Dithering", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(Dithering, "Dithering enable");
        _materialEditor.ShaderProperty(Dithering_Colorize, "Colorize");
        _materialEditor.ShaderProperty(_DitheringMask, "Dithering mask");
    }
    void DrawOverlayTexture()
    {
        Overlay_Grid = FindProperty("Overlay_Grid", _props);
        _OverlayTex = FindProperty("_OverlayTex", _props);
        _OverlayTint = FindProperty("_OverlayTint", _props);
        _OverlayScroll = FindProperty("_OverlayScroll", _props);
        _OverlayRotation = FindProperty("_OverlayRotation", _props);
        _OverlayOpaque = FindProperty("_OverlayOpaque", _props);
        _OverlayTransparent = FindProperty("_OverlayTransparent", _props);
        _isGlitchActive = FindProperty("_isGlitchActive", _props);
        _RGBGlitchBlocksPower = FindProperty("_RGBGlitchBlocksPower", _props);
        _isRedActive = FindProperty("_isRedActive", _props);
        _isGreenActive = FindProperty("_isGreenActive", _props);
        _isBlueActive = FindProperty("_isBlueActive", _props);

        Overlay_Texture_Sheet = FindProperty("Overlay_Texture_Sheet", _props);
        _OverlayColumns = FindProperty("_OverlayColumns", _props);
        _OverlayRows = FindProperty("_OverlayRows", _props);
        _OverlayStartFrame = FindProperty("_OverlayStartFrame", _props);
        _OverlayTotalFrames = FindProperty("_OverlayTotalFrames", _props);
        _OverlayAnimationSpeed = FindProperty("_OverlayAnimationSpeed", _props);


        _materialEditor.ShaderProperty(Overlay_Grid, "Image grid");
        _materialEditor.ShaderProperty(_OverlayTex, "Texture");
        _materialEditor.ShaderProperty(_OverlayTint, "Tint");
        _materialEditor.ShaderProperty(_OverlayOpaque, "Opaque");
        _materialEditor.ShaderProperty(_OverlayTransparent, "Transparent");
        _materialEditor.ShaderProperty(_OverlayRotation, "Rotation");
        if (useSliders)
        {
            _OverlayScroll.vectorValue = new Vector4(
                EditorGUILayout.Slider("Scroll vector X", _OverlayScroll.vectorValue.x, -10, 10),
                EditorGUILayout.Slider("Scroll vector Y", _OverlayScroll.vectorValue.y, -10, 10));
        }
        else
            _OverlayScroll.vectorValue = EditorGUILayout.Vector2Field("Scroll vector", _OverlayScroll.vectorValue);

        GUILayout.Label("Glitch Overlay", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_isGlitchActive, "Enable Glitch Overlay");
        _materialEditor.ShaderProperty(_RGBGlitchBlocksPower, "Glitch Power");
        _materialEditor.ShaderProperty(_isRedActive, "Toggle Red");
        _materialEditor.ShaderProperty(_isGreenActive, "Toggle Green");
        _materialEditor.ShaderProperty(_isBlueActive, "Toggle Blue");
        GUILayout.Label(
           "-Glitch Overlay Added by: Aidan_ogg#0001", EditorStyles.helpBox);

        GUILayout.Label("Texture sheet animation", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(Overlay_Texture_Sheet, "Enable");
        _materialEditor.ShaderProperty(_OverlayColumns, "Columns");
        _materialEditor.ShaderProperty(_OverlayRows, "Rows");
        _materialEditor.ShaderProperty(_OverlayStartFrame, "Start frame");
        _materialEditor.ShaderProperty(_OverlayTotalFrames, "Total frames");
        _materialEditor.ShaderProperty(_OverlayAnimationSpeed, "Animation speed");
    }
    void DrawStatic()
    {
        FindStaticProperties();
        _materialEditor.ShaderProperty(_StaticColour, "Color");
        _materialEditor.ShaderProperty(_StaticIntensity, new GUIContent("Intensity", "Noise amplitude"));
        GUILayout.Label("Extra settings", EditorStyles.boldLabel);
        _materialEditor.ShaderProperty(_StaticAlpha, new GUIContent("Alpha", "Effect scene color to noise"));
        _materialEditor.ShaderProperty(_StaticBrightness, new GUIContent("Brightness", "Scene light"));

        //GUILayout.Label("Looks best if you put Static Colour to white, put Static Alpha to 0.83, put Static Brightness to 4.2, and put Static Intensity to -0.6.", EditorStyles.helpBox);
        GUILayout.Label(
            "-Static Added by: Aidan_ogg#0001\n" +
            "-Updated by: Leviant#8796", EditorStyles.miniBoldLabel);
    }
    void DrawVignette()
    {
        FindVignetteProperties();
        _materialEditor.ShaderProperty(_VignetteColor, "Colour");
        _materialEditor.ShaderProperty(_VignetteAlpha, "Transparent");
        _materialEditor.ShaderProperty(_VignetteWidth, "Width");
        _materialEditor.ShaderProperty(_VignetteShape, "Shape");
        _materialEditor.ShaderProperty(_VignetteRounding, "Rounding");
    }
    void DrawMaskTexture()
    {
        Mask_Multisampling = FindProperty("Mask_Multisampling", _props);
        Mask_Noise = FindProperty("Mask_Noise", _props);
        _MaskTex = FindProperty("_MaskTex", _props);
        _MaskColor = FindProperty("_MaskColor", _props);
        _MaskAlpha = FindProperty("_MaskAlpha", _props);
        _MaskScroll = FindProperty("_MaskScroll", _props);

        _materialEditor.ShaderProperty(Mask_Multisampling, "Multisampling");
        _materialEditor.ShaderProperty(Mask_Noise, "Generate noise");
        _materialEditor.ShaderProperty(_MaskTex, "Mask");
        _materialEditor.ShaderProperty(_MaskColor, "Mix colour");
        _materialEditor.ShaderProperty(_MaskAlpha, "Mix factor");
        if (useSliders)
        {
            _MaskScroll.vectorValue = new Vector4(
                EditorGUILayout.Slider("Scroll vector X", _MaskScroll.vectorValue.x, -10, 10),
                EditorGUILayout.Slider("Scroll vector Y", _MaskScroll.vectorValue.y, -10, 10));
        }
        else
            _MaskScroll.vectorValue = EditorGUILayout.Vector2Field("Scroll vector", _MaskScroll.vectorValue);
    }
    void DrawHELP()
    {
        EditorGUI.indentLevel++;
        GUILayout.Label(
            "-If you have any questions DM us on Discord: Leviant#8796 & Aidan_ogg#0001\n" +
            "-Version 2.9\n" +
            "-Updated on 12/11/2019 @ 23:09 AM", EditorStyles.helpBox);
        EditorGUI.indentLevel--;
    }
    void DrawCredits()
    {
        EditorGUI.indentLevel++;
        GUILayout.Label(
            "-Made By: Leviant#8796\n" +
            "-Edited by: Aidan_ogg#0001\n" +
            "-Editor Created by: Aidan_ogg#0001", EditorStyles.helpBox);
        EditorGUI.indentLevel--;
    }
    //Draws Buttons
    void DrawLeviantPayPal()
    {
        if (LinkButton(paypalURL))
        {
            Application.OpenURL(paypalURL);
        }
    }
    bool LinkButton(string caption)
    {
        bool clicked = GUILayout.Button(caption, linkStyle);
        if (Event.current.type == EventType.Repaint)
            linkRect = GUILayoutUtility.GetLastRect();

        EditorGUIUtility.AddCursorRect(linkRect, MouseCursor.Link);

        return clicked;
    }
    static bool GetFoldState(Category c)
    {
        return (foldState & (1 << (int)c)) > 0;
    }
    static void SetFoldState(Category c, bool active)
    {
        if(active)
            foldState |= 1 << (int)c;
        else
            foldState &= ~(1 << (int)c);
    }
    static bool BeginFold(Category fold, params MaterialProperty[] toggles)
    {
        EditorGUILayout.BeginVertical(layoutStyle);
        EditorGUI.indentLevel++;

        //FoldoutforLeviant fold = FoldoutforLeviant.Get(bit);
        EditorGUILayout.BeginHorizontal(introLayoutStyle);
        bool active = EditorGUILayout.Foldout(GetFoldState(fold), labels[fold], true, foldLabelStyle);
        GUILayout.FlexibleSpace();
        if (EditorGUILayout.Toggle(" ", toggles.Any(toggle => toggle.floatValue != 0.0f), toggleStyle) == false)
            Array.ForEach(toggles, (MaterialProperty prop) => prop.floatValue = 0.0f);
        EditorGUILayout.EndHorizontal();
        SetFoldState(fold, active);

        return active;
    }
    static bool BeginToggleFold(Category fold, MaterialProperty toggle)
    {
        EditorGUILayout.BeginVertical(layoutStyle);
        EditorGUI.indentLevel++;

        //FoldoutforLeviant fold = FoldoutforLeviant.Get(bit);
        EditorGUILayout.BeginHorizontal(introLayoutStyle);
        bool active = EditorGUILayout.Foldout(GetFoldState(fold), labels[fold], true, foldLabelStyle);
        GUILayout.FlexibleSpace();
        toggle.floatValue = EditorGUILayout.Toggle(" ", toggle.floatValue != 0.0f, toggleStyle) ? 1.0f : 0.0f;
        EditorGUILayout.EndHorizontal();
        SetFoldState(fold, active);

        return active;
    }
    static bool BeginFold(Category fold, MaterialProperty toggle)
    {
        EditorGUILayout.BeginVertical(layoutStyle);
        EditorGUI.indentLevel++;

        //FoldoutforLeviant fold = FoldoutforLeviant.Get(bit);
        EditorGUILayout.BeginHorizontal(introLayoutStyle);
        bool active = EditorGUILayout.Foldout(GetFoldState(fold), labels[fold], true, foldLabelStyle);
        GUILayout.FlexibleSpace();
        if (EditorGUILayout.Toggle(" ", toggle.floatValue != 0.0f, toggleStyle) == false)
            toggle.floatValue = 0.0f;
        EditorGUILayout.EndHorizontal();

        SetFoldState(fold, active);
        return active;
    }
    static bool BeginFold(Category fold, GUIContent сontent)
    {
        EditorGUILayout.BeginVertical(layoutStyle);
        EditorGUI.indentLevel++;

        //FoldoutforLeviant fold = FoldoutforLeviant.Get(bit);
        EditorGUILayout.BeginHorizontal(introLayoutStyle);
        bool active = EditorGUILayout.Foldout(GetFoldState(fold), labels[fold], true, foldLabelStyle);
        GUILayout.FlexibleSpace();
        if (сontent != null)
            GUILayout.Box(сontent, GUIStyle.none);
        EditorGUILayout.EndHorizontal();
        SetFoldState(fold, active);
        return active;
    }
    static void EndFold()
    {
        EditorGUI.indentLevel--;
        EditorGUILayout.EndVertical();
    }
}
