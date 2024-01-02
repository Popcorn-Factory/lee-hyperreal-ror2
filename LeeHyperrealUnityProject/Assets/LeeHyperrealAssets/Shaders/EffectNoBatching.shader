Shader "Unlit/EffectNoBatching"
{
    Properties
    {
        		_MainTex ("主贴图", 2D) = "white" {}
		_MainTexColor ("主贴图颜色", Vector) = (1,1,1,1)
		[HideInInspector] _MainTex_ST ("主贴图UV", Vector) = (1,1,0,0)
		_MainRotation ("主贴图旋转", Float) = 0
		_MainRotationParams ("主贴图旋转", Vector) = (1,0,0,1)
		_SecondTex ("次贴图", 2D) = "white" {}
		_SecondRotation ("次贴图旋转", Float) = 0
		_SecondRotationParams ("次贴图旋转", Vector) = (1,0,0,1)
		_TintColor ("颜色", Vector) = (1,1,1,1)
		_SecondColor ("次贴图颜色", Vector) = (1,1,1,1)
		_EffectBrightness ("亮度", Range(0, 50)) = 1.5
		_EffectBrightnessR ("R通道亮度", Range(0, 50)) = 1
		_EffectBrightnessG ("G通道亮度", Range(0, 50)) = 1
		_EffectBrightnessB ("B通道亮度", Range(0, 50)) = 1
		_MaskTex ("遮罩", 2D) = "white" {}
		[HideInInspector] _MaskTex_ST ("遮罩UV", Vector) = (1,1,0,0)
		_MaskRotation ("遮罩旋转", Float) = 0
		_MaskRotationParams ("遮罩旋转", Vector) = (1,0,0,1)
		_RimColor ("边缘光 颜色", Vector) = (0,0,0,1)
		_RimRange ("边缘光 范围", Float) = 0
		_DissolutionTex ("消融贴图", 2D) = "white" {}
		[HideInInspector] _DissolutionTex_ST ("消融贴图UV", Vector) = (1,1,0,0)
		_DissolutionRotation ("消融贴图旋转", Float) = 0
		_DissolutionRotationParams ("消融贴图旋转", Vector) = (1,0,0,1)
		_DissolutionThreshold ("消融阀值", Float) = 0.5
		_DissolutionSoftness ("消融过渡", Float) = 0.5
		_DissolutionColor ("消融顔色", Vector) = (1,0,0,1)
		_FlowTex ("流动贴图", 2D) = "gray" {}
		[HideInInspector] _FlowTex_ST ("流动贴图UV", Vector) = (1,1,0,0)
		_FlowSpeed ("流动速度", Vector) = (0.1,0.1,-0.1,0.1)
		_FlowIntensity ("流动强度", Float) = 0.5
		_ShakeVertexData ("顶点抖动方向和频率", Vector) = (1,0,0,3)
		_ShakeVertexNoiseFrequancy ("顶点抖动锯齿-频率", Float) = 20
		_ShakeVertexNoiseIntensity ("顶点抖动锯齿-强度", Float) = 0.2
		_ShakeVertexScrollSpeed ("顶点抖动锯齿-滚动速度", Float) = 3
		_SpecialEffectIntensity ("强度", Range(0, 1)) = 0
		_IceTex ("冰冻贴图", 2D) = "white" {}
		_IceNoise ("冰冻噪声", 2D) = "white" {}
		_FireNoise ("灼烧噪声", 2D) = "white" {}
		_HideDistance ("隐藏距离", Float) = 2
		_ShowDistance ("显示距离", Float) = 20
		_ParallaxScale ("视差强度", Float) = 0.5
		_ParallaxZOffset ("视差Z偏移(大角度时减少重复)", Float) = 0
		_ParallaxMaskUV ("视差影响遮罩UV", Float) = 0
		_ParallaxDissolutionUV ("视差影响溶解UV", Float) = 0
		_VAT_Tex ("顶点动画贴图", 2D) = "white" {}
		_VAT_Frame ("frame", Range(0, 1)) = 0
		_VAT_MaxBound ("Max", Vector) = (0,0,0,1)
		_VAT_MinBound ("Min", Vector) = (0,0,0,1)
		_VAT_FrameCount ("帧数", Float) = 0
		_VAT_VertexSize ("vertexSize", Float) = 0
		_VAT_Blend ("强度", Range(0, 1)) = 1
		_VAT_VertexSampleCount ("VertexSampleCount", Float) = 1
		_VertexOffset_Tex ("顶点偏移贴图", 2D) = "white" {}
		_VertexOffset_Speed_R ("顶点偏移速度r", Range(-1, 1)) = 1
		_VertexOffset_Strength_R ("顶点偏移强度r", Range(-1, 1)) = 1
		_VertexOffset_Speed_G ("顶点偏移速度g", Range(-1, 1)) = 1
		_VertexOffset_Strength_G ("顶点偏移强度r", Range(-1, 1)) = 1
		_VertexOffset_AlphaMask ("顶点色a通道遮罩强度", Range(0, 1)) = 1
		_ZOffset ("深度偏移", Float) = 0
		[HideInInspector] _RenderType ("渲染类型", Float) = 3000
		[HideInInspector] _AlphaTest ("透明度剔除", Float) = 0
		[HideInInspector] _BlendMode ("混合模式", Float) = 1
		[MaterialEnum(None,0,Front,1,Back,2)] _CullMode ("剔除模式", Float) = 2
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 10
		[HideInInspector] _ZWrite ("深度写入", Float) = 0
		[HideInInspector] _ZTest ("深度测试", Float) = 4
		_MaskIndex ("模板测试通道", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _MaskCompareFunction ("模版测试比较函数", Float) = 8
		_StencilReadMask ("模板读取遮罩", Float) = 255
		_ColorMask ("颜色写入掩码", Float) = 15
		[HideInInspector] IF_MaskFlowMapKeyword ("", Float) = 0
		[HideInInspector] IF_DissolutionFlowMap ("", Float) = 0
		[HideInInspector] IF_MainTexFlowMap ("", Float) = 1
		[HideInInspector] _CustomAlpha ("自定义透明值", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "AlphaType" = "Effect" "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "MirrorType" = "Effect" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
		Name "Base"
        Stencil 
		{
			Ref [_MaskIndex]
			ReadMask [_StencilReadMask]
			Comp [_MaskCompareFunction]
			Pass Keep
			Fail Keep
			ZFail Keep
		}
		Blend [_SrcBlend] [_DstBlend]
		ColorMask [_ColorMask]
		Cull [_CullMode]
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		Pass{
			CGPROGRAM
			#define cmp - 
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#pragma multi_compile_fog

			#pragma multi_compile _ _ALPHABLEND_ON _ADDITIVE_ON
			#pragma multi_compile _ _RIM_LERP _RIM_LERP_WITH_ALPHA _RIM_MASK 
			#pragma multi_compile _ _DISSOLUTION _DISSOLUTION_UV2
			#pragma multi_compile _ _MASKUV0 _MASKUV1
			#pragma multi_compile _ _MAINTEX_DISABLE _MAINTEX_SCREEN_UV
			#pragma target 3.0
			#pragma shader_feature XFOG_DISABLED
			#pragma shader_feature _VERTEX_OFFSET
			#pragma shader_feature _SECOND_TEX
			#pragma shader_feature _VERTEX_ALPHA_OFF
			#pragma shader_feature _FLOWMAP

			#include "UnityCG.cginc"
			#include "UnityInstancing.cginc"

			sampler2D _MainTex;
			float4 _MainTexColor;
			float4 _MainTex_ST;
			float _MainRotation;
			float4 _MainRotationParams;
			sampler2D _SecondTex;
			float _SecondRotation;
			float4 _SecondRotationParams;
			float4 _TintColor;
			float4 _SecondColor;
			float _EffectBrightness;
			float _EffectBrightnessR;
			float _EffectBrightnessG;
			float _EffectBrightnessB;
			sampler2D _MaskTex;
			float4 _MaskTex_ST;
			float _MaskRotation;
			float4 _MaskRotationParams;
			float4 _RimColor;
			float _RimRange;
			sampler2D _DissolutionTex;
			float4 _DissolutionTex_ST;
			float _DissolutionRotation;
			float4 _DissolutionRotationParams;
			float _DissolutionThreshold;
			float _DissolutionSoftness;
			float4 _DissolutionColor;
			sampler2D _FlowTex;
			float4 _FlowTex_ST;
			float4 _FlowSpeed;
			float _FlowIntensity;
			float4 _ShakeVertexData;
			float _ShakeVertexNoiseFrequancy;
			float _ShakeVertexNoiseIntensity;
			float _ShakeVertexScrollSpeed;
			float _SpecialEffectIntensity;
			sampler2D _IceTex;
			sampler2D _IceNoise;
			sampler2D _FireNoise;
			float _HideDistance;
			float _ShowDistance;
			float _ParallaxScale;
			float _ParallaxZOffset;
			float _ParallaxMaskUV;
			float _ParallaxDissolutionUV;
			sampler2D _VAT_Tex;
			float _VAT_Frame;
			float4 _VAT_MaxBound;
			float4 _VAT_MinBound;
			float _VAT_FrameCount;
			float _VAT_VertexSize;
			float _VAT_Blend;
			float _VAT_VertexSampleCount;
			float _CharDistanceFogIntensity;
			sampler2D _VertexOffset_Tex;
			float _VertexOffset_Speed_R;
			float _VertexOffset_Strength_R;
			float _VertexOffset_Speed_G;
			float _VertexOffset_Strength_G;
			float _VertexOffset_AlphaMask;
			float _ZOffset;
			float IF_MaskFlowMapKeyword;
			float IF_DissolutionFlowMap;
			float IF_MainTexFlowMap;
			float _CustomAlpha;
			float4 _VertexOffset_Tex_ST;
			float4 _SecondTex_ST;
			struct v2f
			{
				float4 svPOS : SV_POSITION;
				fixed4 color : COLOR0;
				float4 uv0 : TEXCOORD0;
				#if _DISSOLUTION || _DISSOLUTION_UV2 
					float4 uv1 : TEXCOORD1;
					#endif
				//#if _RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA||_XDISTANCE_FADE||_XICE
				//	float4 uv2 : TEXCOORD2;
				//	float4 uv3 : TEXCOORD3;
				//	#endif
				#if _RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA || _XDISTANCE_FADE || _XICE || _XCUSTOM_DATA_FOR_UV || _USE_HEIGHT_FOG
					float4 uv2 : TEXCOORD2;
				#endif
				#if _RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA || _XDISTANCE_FADE || _XICE || _VERTEX_OFFSET
					float4 uv3 : TEXCOORD3;
				#endif
				#if _FLOWMAP
					float4 uv4 : TEXCOORD4;
				#endif
				#if !XFOG_DISABLED
					float4 depth : TEXCOORD5;
				#endif
				
			};
			
			v2f vert(appdata_full v){
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f,o);
			float4 temp1;
			float4 temp2;
			float4 temp3;
			float tempF1;
			float tempF2;
			float tempF3;
			#if XFOG_DISABLED && _ALPHABLEND_ON && _MAINTEX_DISABLE && _VERTEX_OFFSET && !_RIM_LERP && !_DISSOLUTION && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !_MASKUV0 && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
				temp1.xy = _Time.yy * float2(_VertexOffset_Speed_R,_VertexOffset_Speed_G) + v.texcoord.xx;
				temp1.z = v.texcoord.y;
				temp1 = temp1.xzyz * _VertexOffset_Tex_ST.xyxy + _VertexOffset_Tex_ST.zwzw;
				temp2 = tex2Dlod(_VertexOffset_Tex,float4(temp1.zw,0,0));
				temp1 = tex2Dlod(_VertexOffset_Tex,float4(temp1.xy,0,0));
				temp1.y = _VertexOffset_Strength_G * temp1.y;
				temp1.x = temp1.x * _VertexOffset_Strength_R + temp1.y;
				temp1.y = v.color.w + -1;
				temp1.y = _VertexOffset_AlphaMask * temp1.y + 1;
				temp1.x = temp1.y * temp1.x;
				temp1.xyz = temp1.xxx * v.normal.xyz + v.vertex.xyz;
				temp2 = temp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
				temp2 = unity_ObjectToWorld._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp1 = unity_ObjectToWorld._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = unity_ObjectToWorld._m03_m13_m23_m33 + temp1;
				temp2 = UNITY_MATRIX_VP._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = UNITY_MATRIX_VP._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = UNITY_MATRIX_VP._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = UNITY_MATRIX_VP._m03_m13_m23_m33 * temp1.wwww + temp2;
				o.svPOS.z = -_ZOffset * -0.00100000005 + temp1.z;
				o.svPOS.xyw = temp1.xyw;
				o.color = v.color;
				o.uv0.xy = v.texcoord.xy;
				o.uv0.zw = float2(0,0);
				temp1.x = dot(v.normal.xyz, v.normal.xyz);
				temp1.x = rsqrt(temp1.x);
				temp1.xyz = v.normal.xyz * temp1.xxx;
				temp2.x = dot(temp1.xyz, unity_WorldToObject._m00_m10_m20_m30.xyz);
				temp2.y = dot(temp1.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
				temp2.z = dot(temp1.xyz, unity_WorldToObject._m02_m12_m22_m32.xyz);
				temp1.x = dot(temp2.xyz,temp2.xyz);
				temp1.x = rsqrt(temp1.x);
				o.uv3.xyz = temp2.xyz * temp1.xxx;
				

			#elif _ALPHABLEND_ON && _DISSOLUTION && _MASKUV0 && _SECOND_TEX && _VERTEX_OFFSET  && !_RIM_LERP && !_MAINTEX_DISABLE && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !XFOG_DISABLED && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
				temp1.xy = _Time.yy * float2(_VertexOffset_Speed_R,_VertexOffset_Speed_G) + v.texcoord.xx;
				temp1.z = v.texcoord.y;
				temp1 = temp1.xzyz * _VertexOffset_Tex_ST.xyxy + _VertexOffset_Tex_ST.zwzw;
				temp2 = tex2Dlod(_VertexOffset_Tex,float4(temp1.zw,0,0));
				temp1 = tex2Dlod(_VertexOffset_Tex,float4(temp1.xy,0,0));
				temp1.y = _VertexOffset_Strength_G * temp1.y;
				temp1.x = temp1.x * _VertexOffset_Strength_R + temp1.y;
				temp1.y = v.color.w + -1;
				temp1.y = _VertexOffset_AlphaMask * temp1.y + 1;
				temp1.x = temp1.y * temp1.x;
				temp1.xyz = temp1.xxx * v.normal.xyz + v.vertex.xyz;
				temp2 = temp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
				temp2 = unity_ObjectToWorld._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp1 = unity_ObjectToWorld._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = unity_ObjectToWorld._m03_m13_m23_m33 + temp1;
				temp2 = UNITY_MATRIX_VP._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = UNITY_MATRIX_VP._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = UNITY_MATRIX_VP._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = UNITY_MATRIX_VP._m03_m13_m23_m33 * temp1.wwww + temp2;
				o.svPOS.xyw = temp1.xyw;
				temp1.x = -_ZOffset * -0.00100000005 + temp1.z;
				o.svPOS.z = temp1.x;
				o.depth = temp1.x;
				o.color = v.color;
				temp1 = v.texcoord.xyxy * _MaskTex_ST.xyxy + _MaskTex_ST.zwzw;
				temp1 = _MaskRotationParams * temp1;
				o.uv0.zw = temp1.xz + temp1.yw;
				o.uv0.xy = v.texcoord.xy;
				temp1 = v.texcoord.xyxy * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
				temp1 = _DissolutionRotationParams * temp1;
				o.uv1.xy = temp1.xz + temp1.yw;
				temp1.x = dot(v.normal.xyz, v.normal.xyz);
				temp1.x = rsqrt(temp1.x);
				temp1.xyz = v.normal.xyz * temp1.xxx;
				temp2.x = dot(temp1.xyz, unity_WorldToObject._m00_m10_m20_m30.xyz);
				temp2.y = dot(temp1.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
				temp2.z = dot(temp1.xyz, unity_WorldToObject._m02_m12_m22_m32.xyz);
				temp1.x = dot(temp2.xyz,temp2.xyz);
				temp1.x = rsqrt(temp1.x);
				o.uv3.xyz = temp2.xyz * temp1.xxx;
			#elif _ALPHABLEND_ON && _MAINTEX_DISABLE && _MASKUV0 && _VERTEX_OFFSET && !_RIM_LERP  && !_DISSOLUTION && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !XFOG_DISABLED && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
				temp1.xy = _Time.yy * float2(_VertexOffset_Speed_R,_VertexOffset_Speed_G) + v.texcoord.xx;
				temp1.z = v.texcoord.y;
				temp1 = temp1.xzyz * _VertexOffset_Tex_ST.xyxy + _VertexOffset_Tex_ST.zwzw;
				temp2 = tex2Dlod(_VertexOffset_Tex,float4(temp1.zw,0,0));
				temp1 = tex2Dlod(_VertexOffset_Tex,float4(temp1.xy,0,0));
				temp1.y = _VertexOffset_Strength_G * temp1.y;
				temp1.x = temp1.x * _VertexOffset_Strength_R + temp1.y;
				temp1.y = v.color.w + -1;
				temp1.y = _VertexOffset_AlphaMask * temp1.y + 1;
				temp1.x = temp1.y * temp1.x;
				temp1.xyz = temp1.xxx * v.normal.xyz + v.vertex.xyz;
				temp2 = temp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
				temp2 = unity_ObjectToWorld._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp1 = unity_ObjectToWorld._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = unity_ObjectToWorld._m03_m13_m23_m33 + temp1;
				temp2 = UNITY_MATRIX_VP._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = UNITY_MATRIX_VP._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = UNITY_MATRIX_VP._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = UNITY_MATRIX_VP._m03_m13_m23_m33 * temp1.wwww + temp2;
				o.svPOS.xyw = temp1.xyw;
				temp1.x = -_ZOffset * -0.00100000005 + temp1.z;
				o.svPOS.z = temp1.x;
				o.depth = temp1.x;
				o.color = v.color;
				temp1 = v.texcoord.xyxy * _MaskTex_ST.xyxy + _MaskTex_ST.zwzw;
				temp1 = _MaskRotationParams * temp1;
				o.uv0.zw = temp1.xz + temp1.yw;
				o.uv0.xy = v.texcoord.xy;
				temp1.x = dot(v.normal.xyz, v.normal.xyz);
				temp1.x = rsqrt(temp1.x);
				temp1.xyz = v.normal.xyz * temp1.xxx;
				temp2.x = dot(temp1.xyz, unity_WorldToObject._m00_m10_m20_m30.xyz);
				temp2.y = dot(temp1.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
				temp2.z = dot(temp1.xyz, unity_WorldToObject._m02_m12_m22_m32.xyz);
				temp1.x = dot(temp2.xyz,temp2.xyz);
				temp1.x = rsqrt(temp1.x);
				o.uv3.xyz = temp2.xyz * temp1.xxx;
			#elif _ALPHABLEND_ON && _DISSOLUTION && _MAINTEX_DISABLE && _MASKUV0 && _VERTEX_ALPHA_OFF && _VERTEX_OFFSET && !_RIM_LERP && !_FLOWMAP && !XFOG_DISABLED && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
				temp1.xy = _Time.yy * float2(_VertexOffset_Speed_R,_VertexOffset_Speed_G) + v.texcoord.xx;
				temp1.z = v.texcoord.y;
				temp1 = temp1.xzyz * _VertexOffset_Tex_ST.xyxy + _VertexOffset_Tex_ST.zwzw;
				temp2 = tex2Dlod(_VertexOffset_Tex,float4(temp1.zw,0,0));
				temp1 = tex2Dlod(_VertexOffset_Tex,float4(temp1.xy,0,0));
				temp1.y = _VertexOffset_Strength_G * temp1.y;
				temp1.x = temp1.x * _VertexOffset_Strength_R + temp1.y;
				temp1.y = v.color.w + -1;
				temp1.y = _VertexOffset_AlphaMask * temp1.y + 1;
				temp1.x = temp1.y * temp1.x;
				temp1.xyz = temp1.xxx * v.normal.xyz + v.vertex.xyz;
				temp2 = temp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
				temp2 = unity_ObjectToWorld._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp1 = unity_ObjectToWorld._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = unity_ObjectToWorld._m03_m13_m23_m33 + temp1;
				temp2 = UNITY_MATRIX_VP._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = UNITY_MATRIX_VP._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = UNITY_MATRIX_VP._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = UNITY_MATRIX_VP._m03_m13_m23_m33 * temp1.wwww + temp2;
				o.svPOS.xyw = temp1.xyw;
				temp1.x = -_ZOffset * -0.00100000005 + temp1.z;
				o.svPOS.z = temp1.x;
				o.depth = temp1.x;
				o.color = v.color;
				temp1 = v.texcoord.xyxy * _MaskTex_ST.xyxy + _MaskTex_ST.zwzw;
				temp1 = _MaskRotationParams * temp1;
				o.uv0.zw = temp1.xz + temp1.yw;
				o.uv0.xy = v.texcoord.xy;
				temp1 = v.texcoord.xyxy * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
				temp1 = _DissolutionRotationParams * temp1;
				o.uv1.xy = temp1.xz + temp1.yw;
				temp1.x = dot(v.normal.xyz, v.normal.xyz);
				temp1.x = rsqrt(temp1.x);
				temp1.xyz = v.normal.xyz * temp1.xxx;
				temp2.x = dot(temp1.xyz, unity_WorldToObject._m00_m10_m20_m30.xyz);
				temp2.y = dot(temp1.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
				temp2.z = dot(temp1.xyz, unity_WorldToObject._m02_m12_m22_m32.xyz);
				temp1.x = dot(temp2.xyz,temp2.xyz);
				temp1.x = rsqrt(temp1.x);
				o.uv3.xyz = temp2.xyz * temp1.xxx;
			#elif XFOG_DISABLED && _ALPHABLEND_ON && _RIM_LERP_WITH_ALPHA && _VERTEX_OFFSET && !_RIM_LERP && !_MAINTEX_DISABLE && !_DISSOLUTION && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !_MASKUV0 && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
				temp1.xy = _Time.yy * float2(_VertexOffset_Speed_R,_VertexOffset_Speed_G) + v.texcoord.xx;
				temp1.z = v.texcoord.y;
				temp1 = temp1.xzyz * _VertexOffset_Tex_ST.xyxy + _VertexOffset_Tex_ST.zwzw;
				temp2 = tex2Dlod(_VertexOffset_Tex,float4(temp1.zw,0,0));
				temp1 = tex2Dlod(_VertexOffset_Tex,float4(temp1.xy,0,0));
				temp1.y = _VertexOffset_Strength_G * temp2.y;
				temp1.x = temp1.x * _VertexOffset_Strength_R + temp1.y;
				temp1.y = -1 + v.color.w;
				temp1.y = _VertexOffset_AlphaMask * temp1.x + 1;
				temp1.x = temp1.y * temp1.x;
				temp2.xyz = v.normal.xyz;
				temp2.w = 0;
				temp1 = temp1.xxxx * temp2 + v.vertex;
				temp2 = unity_ObjectToWorld._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = unity_ObjectToWorld._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = unity_ObjectToWorld._m02_m12_m22_m32 * temp1.zzzz + temp2;
				o.uv3.xyz = unity_ObjectToWorld._m03_m13_m23_m33.xyz * temp1.www + temp2.xyz;
				temp1 = unity_ObjectToWorld._m03_m13_m23_m33 + temp2;
				temp2 = UNITY_MATRIX_VP._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = UNITY_MATRIX_VP._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = UNITY_MATRIX_VP._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = UNITY_MATRIX_VP._m03_m13_m23_m33 * temp1.wwww + temp2;
				o.svPOS.z = -_ZOffset * -0.00100000005 + temp1.z;
				o.svPOS.xyw = temp1.xyw;
				o.color = v.color;
				o.uv0.xy = v.texcoord.xy;
				o.uv0.zw = float2(0,0);
				temp1.x = dot(v.normal.xyz, v.normal.xyz);
				temp1.x = rsqrt(temp1.x);
				temp1.xyz = v.normal.xyz * temp1.xxx;
				temp2.x = dot(temp1.xyz, unity_WorldToObject._m00_m10_m20_m30.xyz);
				temp2.y = dot(temp1.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
				temp2.z = dot(temp1.xyz, unity_WorldToObject._m02_m12_m22_m32.xyz);
				temp1.x = dot(temp2.xyz,temp2.xyz);
				temp1.x = rsqrt(temp1.x);
				o.uv3.xyz = temp2.xyz * temp1.xxx;
			#elif _ALPHABLEND_ON && _DISSOLUTION && _FLOWMAP && _MASKUV0 && _RIM_LERP_WITH_ALPHA && _SECOND_TEX && _VERTEX_OFFSET && !_RIM_LERP && !_MAINTEX_DISABLE && !_VERTEX_ALPHA_OFF && !XFOG_DISABLED && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
				temp1.xy = _Time.yy * float2(_VertexOffset_Speed_R,_VertexOffset_Speed_G) + v.texcoord.xx;
				temp1.z = v.texcoord.y;
				temp1 = temp1.xzyz * _VertexOffset_Tex_ST.xyxy + _VertexOffset_Tex_ST.zwzw;
				temp2 = tex2Dlod(_VertexOffset_Tex,float4(temp1.zw,0,0));
				temp1 = tex2Dlod(_VertexOffset_Tex,float4(temp1.xy,0,0));
				temp1.y = _VertexOffset_Strength_G * temp2.y;
				temp1.x = temp1.x * _VertexOffset_Strength_R + temp1.y;
				temp1.y = -1 + v.color.w;
				temp1.y = _VertexOffset_AlphaMask * temp1.x + 1;
				temp1.x = temp1.y * temp1.x;
				temp2.xyz = v.normal.xyz;
				temp2.w = 0;
				temp1 = temp1.xxxx * temp2 + v.vertex;
				temp2 = unity_ObjectToWorld._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = unity_ObjectToWorld._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = unity_ObjectToWorld._m02_m12_m22_m32 * temp1.zzzz + temp2;
				o.uv3.xyz = unity_ObjectToWorld._m03_m13_m23_m33.xyz * temp1.www + temp2.xyz;
				temp1 = unity_ObjectToWorld._m03_m13_m23_m33 + temp2;
				temp2 = UNITY_MATRIX_VP._m01_m11_m21_m31 * temp1.yyyy;
				temp2 = UNITY_MATRIX_VP._m00_m10_m20_m30 * temp1.xxxx + temp2;
				temp2 = UNITY_MATRIX_VP._m02_m12_m22_m32 * temp1.zzzz + temp2;
				temp1 = UNITY_MATRIX_VP._m03_m13_m23_m33 * temp1.wwww + temp2;
				o.svPOS.xyw = temp1.xyw;
				temp1.x = -_ZOffset * -0.00100000005 + temp1.z;
				o.svPOS.z = temp1.x;
				o.depth = temp1.x;
				o.color = v.color;
				temp1 = v.texcoord.xyxy * _MaskTex_ST.xyxy + _MaskTex_ST.zwzw;
				temp1 = _MaskRotationParams * temp1;
				o.uv0.zw = temp1.xz + temp1.yw;
				o.uv0.xy = v.texcoord.xy;
				temp1 = v.texcoord.xyxy * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
				temp1 = _DissolutionRotationParams * temp1;
				o.uv1.xy = temp1.xz + temp1.yw;
				temp1.x = dot(v.normal.xyz, v.normal.xyz);
				temp1.x = rsqrt(temp1.x);
				temp1.xyz = v.normal.xyz * temp1.xxx;
				temp2.x = dot(temp1.xyz, unity_WorldToObject._m00_m10_m20_m30.xyz);
				temp2.y = dot(temp1.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
				temp2.z = dot(temp1.xyz, unity_WorldToObject._m02_m12_m22_m32.xyz);
				temp1.x = dot(temp2.xyz,temp2.xyz);
				temp1.x = rsqrt(temp1.x);
				o.uv3.xyz = temp2.xyz * temp1.xxx;
				temp1 = v.texcoord.xyxy * _FlowTex_ST.xyxy + _FlowTex_ST.zwzw;
				o.uv4 = _FlowSpeed * _Time.yyyy + temp1;
			#endif
			return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				float4 sv_targ;
				float4 temp1 = float4(0,0,0,0);
				float4 temp2 = float4(0,0,0,0);
				float4 temp3 = float4(0,0,0,0);
				float4 temp4 = float4(0,0,0,0);
				float4 temp5 = float4(0,0,0,0);
				float tempF1;
				float tempF2;
				float tempF3;
				#if XFOG_DISABLED && _ALPHABLEND_ON && _MAINTEX_DISABLE && _VERTEX_OFFSET && !_RIM_LERP && !_DISSOLUTION && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !_MASKUV0 && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
					temp1.xyz = _TintColor.xyz * _EffectBrightness.xxx;
					temp1.xyz = i.color.xyz * temp1.xyz;
					temp1.xyz = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * temp1.xyz;
					temp1.xyz = max(temp1.xyz,float3(0,0,0));
					sv_targ.xyz = min(temp1.xyz,float3(500,500,500));
					temp1.w = _TintColor.w * i.color.w;
					temp1.w = saturate(1.871 * temp1.w);
					sv_targ.w = saturate(_CustomAlpha * temp1.w);
				#elif _ALPHABLEND_ON && _DISSOLUTION && _MASKUV0 && _SECOND_TEX && _VERTEX_OFFSET  && !_RIM_LERP && !_MAINTEX_DISABLE && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !XFOG_DISABLED && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
					temp1.x = max(_DissolutionSoftness,9.99999975e-05);
					temp1.y = 1 + temp1.x;
					temp1.x = i.color.w * temp1.y + -temp1.x;
					temp1.y = i.color.w * temp1.y + -temp1.x;
					temp1.y = 1 / temp1.y;
					temp2 = tex2D(_DissolutionTex,i.uv1.xy);
					temp1.x = temp2.x + -temp1.x;
					temp1.x = saturate(temp1.x * temp1.y);
					temp1.y = temp1.x * -2 +3;
					temp1.x = temp1.x * temp1.x;
					temp1.x = temp1.y * temp1.x;
					temp1.x = min(temp1.x,1);
					temp2 = i.uv0.xyxy * _MainTex_ST.xyxy + _MainTex_ST.zwzw;
					temp2 = _MainRotationParams * temp2;
					temp1.yz = temp2.xz + temp2.yw;
					temp2 = tex2D(_MainTex,temp1.yz);
					temp2 = _MainTexColor * temp2;
					temp3 = i.uv0.xyxy * _SecondTex_ST.xyxy + _SecondTex_ST.zwzw;
					temp3 = _SecondRotationParams * temp3;
					temp1.yz = temp3.xz + temp3.yw;
					temp3 = tex2D(_SecondTex,temp1.yz);
					temp4 = temp3 * _SecondColor + -temp2;
					temp1.y = _SecondColor.w * temp3.w;
					temp2 = temp1.yyyy * temp4 + temp2;
					temp2 = _TintColor * temp2;
					temp1.yzw = _EffectBrightness.xxx * temp2.xyz;
					temp3.xyz = i.color.xyz * temp1.yzw;
					temp4.xyz = _DissolutionColor.xyz * _EffectBrightness.xxx + -temp3.xyz;
					temp3.w = 0;
					temp4.w = 0;
					temp4 = _DissolutionColor.wwww * temp4 + temp3;
					temp5 = tex2D(_MaskTex,i.uv0.zw);
					temp3.w = temp5.x * temp2.w;
					temp2 = temp4 + -temp3;
					temp1 = temp1.xxxx * temp2 + temp3;
					temp2.xyz = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * temp1.xyz;
					temp1.xyz = -temp1.xyz * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
					temp1.w = saturate(1.871 * temp1.w);
					sv_targ.w = saturate(_CustomAlpha * temp1.w);
					temp1.w = i.depth / _ProjectionParams.y;
					temp1.w = 1 + -temp1.w;
					temp1.w = _ProjectionParams.z * temp1.w;
					temp1.w = max(temp1.w,0);
					temp1.w = saturate(temp1.w * unity_FogParams.z + unity_FogParams.w);
					temp1.w = 1 + -temp1.w;
					temp1.w = temp1.w * _CharDistanceFogIntensity;
					temp1.xyz = temp1.www * temp1.xyz + temp2.xyz;
					temp1.xyz = max(temp1.xyz,float3(0,0,0));
					sv_targ.xyz = min(temp1.xyz,float3(500,500,500));
				#elif _ALPHABLEND_ON && _MAINTEX_DISABLE && _MASKUV0 && _VERTEX_OFFSET && !_RIM_LERP  && !_DISSOLUTION && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !XFOG_DISABLED && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
					temp1.x = i.depth / _ProjectionParams.y;
					temp1.x = 1 + -temp1.x;
					temp1.x = _ProjectionParams.z * temp1.x;
					temp1.x = max(temp1.x,0);
					temp1.x = saturate(temp1.x * unity_FogParams.z + unity_FogParams.w);
					temp1.x = 1 + -temp1.x;
					temp1.x = temp1.x * _CharDistanceFogIntensity;
					temp1.yzw = _EffectBrightness.xxx * _TintColor.xyz;
					temp1.yzw = i.color.xyz * temp1.yzw;
					temp2.xyz = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * temp1.yzw;
					temp1.yzw = -temp1.yzw * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
					temp1.xyz = temp1.xxx * temp1.yzw + temp2.xyz;
					temp1.xyz = max(temp1.xyz,float3(0,0,0));
					sv_targ.xyz = min(temp1.xyz,float3(500,500,500));
					temp1.x = _TintColor.w * i.color.w;
					temp2 = tex2D(_MaskTex,i.uv0.zw);
					temp1.x = temp2.x * temp1.x;
					temp1.x = saturate(1.871 * temp1.x);
					sv_targ.w = saturate(_CustomAlpha * temp1.x);

				#elif _ALPHABLEND_ON && _DISSOLUTION && _MAINTEX_DISABLE && _MASKUV0 && _VERTEX_ALPHA_OFF && _VERTEX_OFFSET && !_RIM_LERP && !_FLOWMAP && !XFOG_DISABLED && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
					temp1.x = max(_DissolutionSoftness,9.99999975e-05);
					temp1.y = 1 + temp1.x;
					temp1.x = _DissolutionThreshold * temp1.y + -temp1.x;
					temp1.y = _DissolutionThreshold * temp1.y + -temp1.x;
					temp1.y = 1 / temp1.y;
					temp2 = tex2D(_DissolutionTex,i.uv1.xy);
					temp1.x = temp2.x + -temp1.x;
					temp1.x = saturate(temp1.x * temp1.y);
					temp1.y = temp1.x * -2 +3;
					temp1.x = temp1.x * temp1.x;
					temp1.x = temp1.y * temp1.x;
					temp1.x = min(temp1.x,1);
					temp2.w = 0;
					temp3.w = 0;
					temp1.yzw = _TintColor.xyz * _EffectBrightness.xxx;
					temp2.xyz = i.color.xyz * temp1.yzw;
					temp3.xyz = _DissolutionColor.xyz * _EffectBrightness.xxx + -temp2.xyz;
					temp3 = _DissolutionColor.wwww * temp3 + temp2;
					temp4 = tex2D(_MaskTex,i.uv0.zw);
					temp2.w = _TintColor.w * temp4.x;
					temp3 = temp3 + -temp2;
					temp1 = temp1.xxxx * temp3 + temp2;
					temp2.xyz = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * temp1.xyz;
					temp1.xyz = -temp1.xyz * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
					temp1.w = saturate(1.871 * temp1.w);
					sv_targ.w = saturate(_CustomAlpha * temp1.w);
					temp1.w = i.depth / _ProjectionParams.y;
					temp1.w = 1 + -temp1.w;
					temp1.w = _ProjectionParams.z * temp1.w;
					temp1.w = max(temp1.w,0);
					temp1.w = saturate(temp1.w * unity_FogParams.z + unity_FogParams.w);
					temp1.w = 1 + -temp1.w;
					temp1.w = temp1.w * _CharDistanceFogIntensity;
					temp1.xyz = temp1.www * temp1.xyz + temp2.xyz;
					temp1.xyz = max(temp1.xyz,float3(0,0,0));
					sv_targ.xyz = min(temp1.xyz,float3(500,500,500));
				#elif XFOG_DISABLED && _ALPHABLEND_ON && _RIM_LERP_WITH_ALPHA && _VERTEX_OFFSET && !_RIM_LERP && !_MAINTEX_DISABLE && !_DISSOLUTION && !_FLOWMAP && !_VERTEX_ALPHA_OFF && !_MASKUV0 && !_SECOND_TEX && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
					temp1.xyz = _WorldSpaceCameraPos.xyz + -i.uv2.xyz;
					temp1.w = dot(temp1.xyz,temp1.xyz);
					temp1.w = rsqrt(temp1.w);
					temp1.xyz = temp1.xyz * temp1.www;
					temp1.w = dot(i.uv3.xyz,i.uv3.xyz);
					temp1.w = rsqrt(temp1.w);
					temp2.xyz = i.uv3.xyz * temp1.www;
					temp1.x = dot(temp1.xyz, temp2.xyz);
					temp1.x = min(temp1.x,0.980000019);
					temp1.y = 1 + -temp1.x;
					temp1.x = _RimRange + -abs(temp1.x);
					temp1.x = max(temp1.x,0);
					temp1.y = -temp1.x * temp1.x + temp1.y;
					temp1.x = temp1.x * temp1.x;
					temp1.x = temp1.x * temp1.y + temp1.x;
					temp2 = i.uv0.xyxy * _MainTex_ST.xyxy + _MainTex_ST.zwzw;
					temp2 = _MainRotationParams * temp2;
					temp1.yz = temp2.xz + temp2.yw;
					temp2 = tex2D(_MainTex,temp1.yz);
					temp2 = _MainTexColor * temp2;
					temp2 = _TintColor * temp2;
					temp1.y = i.color.w * temp2.w;
					temp1.z = -temp2.w * i.color.w + _RimColor.w;
					temp2.xyz = _EffectBrightness.xxx * temp2.xyz;
					temp2.xyz = i.color.xyz * temp2.xyz;
					temp1.y = temp1.x * temp1.z + temp1.y;
					temp1.y = saturate(1.871 * temp1.y);
					sv_targ.w = saturate(_CustomAlpha * temp1.y);
					temp1.yzw = _RimColor.xyz * _EffectBrightness.xxx + -temp2.xyz;
					temp1.xyz = temp1.xxx * temp1.yzw + temp2.xyz;
					temp1.xyz = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * temp1.xyz;
					temp1.xyz = max(temp1.xyz,float3(0,0,0));
					sv_targ.xyz = min(temp1.xyz,float3(500,500,500));
				#elif _ALPHABLEND_ON && _DISSOLUTION && _FLOWMAP && _MASKUV0 && _RIM_LERP_WITH_ALPHA && _SECOND_TEX && _VERTEX_OFFSET && !_RIM_LERP && !_MAINTEX_DISABLE && !_VERTEX_ALPHA_OFF && !XFOG_DISABLED && !_RADIAL_MASK_UV && !_MASKUV1  && !_DISSOLUTION_UV2 && !_RIM_MASK && !_VERTEX_RGB_OFF && !_VERTEX_NORMAL_CUSTOM_UV && !_XDISTANCE_FADE && !_MAINTEX_SCREEN_UV && !_VAT
					temp1.xyz = _WorldSpaceCameraPos.xyz + -i.uv2.xyz;
					temp1.w = dot(temp1.xyz,temp1.xyz);
					temp1.w = rsqrt(temp1.w);
					temp1.xyz = temp1.xyz * temp1.www;
					temp1.w = dot(i.uv3.xyz,i.uv3.xyz);
					temp1.w = rsqrt(temp1.w);
					temp2.xyz = i.uv3.xyz * temp1.www;
					temp1.x = dot(temp1.xyz, temp2.xyz);
					temp1.x = min(temp1.x,0.980000019);
					temp1.y = 1 + -temp1.x;
					temp1.x = _RimRange + -abs(temp1.x);
					temp1.x = max(temp1.x,0);
					temp1.y = -temp1.x * temp1.x + temp1.y;
					temp1.x = temp1.x * temp1.x;
					temp1.x = temp1.x * temp1.y + temp1.x;
					temp2 = tex2D(_FlowTex,i.uv4.xy);
					temp3 = tex2D(_FlowTex,i.uv4.zw);
					temp1.yz = temp3.xy + temp2.xy;
					temp1.yz = float2(-1,-1) + temp1.yz;
					temp2 = i.uv0.xyxy * _SecondTex_ST.xyxy + _SecondTex_ST.zwzw;
					temp2 = temp1.yzyz * _FlowIntensity.xxxx + temp2;
					temp1.yz = _FlowIntensity.xx * temp1.yz;
					temp2 = _SecondRotationParams * temp2;
					temp2.xy = temp2.xz + temp2.yw;
					temp2 = tex2D(_SecondTex,temp2.xy);
					temp1.w = _SecondColor.w * temp2.w;
					temp3 = i.uv0.xyxy * _MainTex_ST.xyxy + _MainTex_ST.zwzw;
					temp3 = temp1.yzyz * IF_MainTexFlowMap.xxxx + temp3;
					temp3 = _MainRotationParams * temp3;
					temp3.xy = temp3.xz + temp3.yw;
					temp3 = tex2D(_MainTex,temp3.xy);
					temp3 = _MainTexColor * temp3;
					temp2 = temp1 * _SecondColor + -temp3;
					temp2 = temp1.wwww * temp2 + temp3;
					temp2 = _TintColor * temp2;
					temp3.xy = temp1.yz * IF_MaskFlowMapKeyword.xx + i.uv0.zw;
					temp1.yz = temp1.yz * IF_DissolutionFlowMap.xx + i.uv1.xy;
					temp4 = tex2D(_DissolutionTex, temp1.yz);
					temp3 = tex2D(_MaskTex,temp3.xy);
					temp1.y = temp3.x * temp2.w;
					temp1.z = -temp2.w * temp3.x + _RimColor.w;
					temp2.xyz = _EffectBrightness.xxx * temp2.xyz;
					temp2.xyz = i.color.xyz * temp2.xyz;
					temp3.w = temp1.x * temp1.z + temp1.y;
					temp1.yzw = _RimColor.xyz * _EffectBrightness.xxx + -temp2.xyz;
					temp1.xyz = temp1.xxx * temp1.yzw + temp2.xyz;
					temp2.xyz = _DissolutionColor.xyz * _EffectBrightness.xxx + -temp1.xyz;
					temp1.w = 0;
					temp2.w = 0;
					temp2 = _DissolutionColor.wwww * temp2 + temp1;
					temp3.xyz = temp1.xyz;
					temp1 = temp2 + -temp3;
					temp2.x = max(_DissolutionSoftness,9.99999975e-05);
					temp2.y = 1 + temp2.x;
					temp2.x = i.color.w * temp2.y + -temp2.x;
					temp2.y = i.color.w * temp2.y + -temp2.x;
					temp2.x = temp4.x + -temp2.x;
					temp2.y = 1 / temp2.y;
					temp2.x = saturate(temp2.x * temp2.y);
					temp2.y = temp2.x * -2 + 3;
					temp2.x = temp2.x * temp2.x;
					temp2.x = temp2.y * temp2.x;
					temp2.x = min(temp2.x,1);
					temp1 = temp2.xxxx * temp1 + temp3;
					temp2.xyz = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * temp1.xyz;
					temp1.xyz = -temp1.xyz * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
					temp1.w = saturate(1.871 * temp1.w);
					sv_targ.w = saturate(_CustomAlpha * temp1.w);
					temp1.w = i.depth / _ProjectionParams.y;
					temp1.w = 1 + -temp1.w;
					temp1.w = _ProjectionParams.z * temp1.w;
					temp1.w = max(temp1.w,0);
					temp1.w = saturate(temp1.w * unity_FogParams.z + unity_FogParams.w);
					temp1.w = 1 + -temp1.w;
					temp1.w = temp1.w * _CharDistanceFogIntensity;
					temp1.xyz = temp1.www * temp1.xyz + temp2.xyz;
					temp1.xyz = max(temp1.xyz,float3(0,0,0));
					sv_targ.xyz = min(temp1.xyz,float3(500,500,500));
				#else
					sv_targ = float4(0,0,0,1);
				#endif
				return sv_targ;
			}
			ENDCG
		}
    }
}
