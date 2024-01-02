Shader "Unlit/XEffect"
{
    Properties
    {
        _MainTex ("主贴图(_MainTex)", 2D) = "white" {}
		_MainTexColor ("主贴图颜色(_MainTexColor)", Color) = (1,1,1,1)
		[HideInInspector] _MainTex_ST ("主贴图UV", Vector) = (1,1,0,0)
		_MainRotation ("主贴图旋转(_MainRotation)", Float) = 0
		_MainRotationParams ("主贴图旋转(_MainRotationParams)", Vector) = (1,0,0,1)
		_SecondTex ("次贴图(_SecondTex)", 2D) = "white" {}
		[HideInInspector] _SecondTex_ST ("次贴图UV", Vector) = (1,1,0,0)
		_SecondRotation ("次贴图旋转(_SecondRotation)", Float) = 0
		_SecondRotationParams ("次贴图旋转(_SecondRotationParams)", Vector) = (1,0,0,1)
		_TintColor ("颜色(_TintColor)", Color) = (1,1,1,1)
		_SecondColor ("次贴图颜色(_SecondColor)", Color) = (1,1,1,1)
		_EffectBrightness ("亮度(_EffectBrightness)", Range(0, 50)) = 1.5
		_EffectBrightnessR ("R通道亮度(_EffectBrightnessR)", Range(0, 50)) = 1
		_EffectBrightnessG ("G通道亮度(_EffectBrightnessG)", Range(0, 50)) = 1
		_EffectBrightnessB ("B通道亮度(_EffectBrightnessB)", Range(0, 50)) = 1
		_MaskTex ("遮罩(_MaskTex)", 2D) = "white" {}
		[HideInInspector] _MaskTex_ST ("遮罩UV", Vector) = (1,1,0,0)
		_MaskRotation ("遮罩旋转(_MaskRotation)", Float) = 0
		_MaskRotationParams ("遮罩旋转(_MaskRotationParams)", Vector) = (1,0,0,1)
		_RimColor ("边缘光 颜色(_RimColor)", Color) = (0,0,0,1)
		_RimRange ("边缘光 范围(_RimRange)", Float) = 0
		_DissolutionTex ("消融贴图(_DissolutionTex)", 2D) = "white" {}
		[HideInInspector] _DissolutionTex_ST ("消融贴图UV", Vector) = (1,1,0,0)
		_DissolutionRotation ("消融贴图旋转(_DissolutionRotation)", Float) = 0
		_DissolutionRotationParams ("消融贴图旋转(_DissolutionRotationParams)", Vector) = (1,0,0,1)
		_DissolutionThreshold ("消融阀值(_DissolutionThreshold)", Float) = 0.5
		_DissolutionSoftness ("消融过渡(_DissolutionSoftness)", Float) = 0.5
		_DissolutionColor ("消融顔色(_DissolutionColor)", Color) = (1,0,0,1)
		_FlowTex ("流动贴图(_FlowTex)", 2D) = "gray" {}
		[HideInInspector] _FlowTex_ST ("流动贴图UV", Vector) = (1,1,0,0)
		_FlowSpeed ("流动速度(_FlowSpeed)", Vector) = (0.1,0.1,-0.1,0.1)
		_FlowIntensity ("流动强度(_FlowIntensity)", Float) = 0.5
		_ShakeVertexData ("顶点抖动方向和频率(_ShakeVertexData)", Vector) = (1,0,0,3)
		_ShakeVertexNoiseFrequancy ("顶点抖动锯齿-频率(_ShakeVertexNoiseFrequancy)", Float) = 20
		_ShakeVertexNoiseIntensity ("顶点抖动锯齿-强度(_ShakeVertexNoiseIntensity)", Float) = 0.2
		_ShakeVertexScrollSpeed ("顶点抖动锯齿-滚动速度(_ShakeVertexScrollSpeed)", Float) = 3
		_SpecialEffectIntensity ("强度(_SpecialEffectIntensity)", Range(0, 1)) = 0
		_IceTex ("冰冻贴图(_IceTex)", 2D) = "white" {}
		_IceNoise ("冰冻噪声(_IceNoise)", 2D) = "white" {}
		_FireNoise ("灼烧噪声(_FireNoise)", 2D) = "white" {}
		_HideDistance ("隐藏距离(_HideDistance)", Float) = 2
		_ShowDistance ("显示距离(_ShowDistance)", Float) = 20
		_ParallaxScale ("视差强度(_ParallaxScale)", Float) = 0.5
		 _ParallaxZOffset ("视差Z偏移(大角度时减少重复)(_ParallaxZOffset)", Float) = 0
		 _ParallaxMaskUV ("视差影响遮罩UV(_ParallaxMaskUV)", Float) = 0
		_ParallaxDissolutionUV ("视差影响溶解UV(_ParallaxDissolutionUV)", Float) = 0
		_VAT_Tex ("顶点动画贴图(_VAT_Tex)", 2D) = "white" {}
		_VAT_Frame ("frame(_VAT_Frame)", Range(0, 1)) = 0
		_VAT_MaxBound ("Max(_VAT_MaxBound)", Vector) = (0,0,0,1)
		_VAT_MinBound ("Min(_VAT_MinBound)", Vector) = (0,0,0,1)
		_VAT_FrameCount ("帧数(_VAT_FrameCount)", Float) = 0
		_VAT_VertexSize ("vertexSize(_VAT_VertexSize)", Float) = 0
		_VAT_Blend ("强度(_VAT_Blend)", Range(0, 1)) = 1
		_VAT_VertexSampleCount ("VertexSampleCount(_VAT_VertexSampleCount)", Float) = 1
		_VertexOffset_Tex ("顶点偏移贴图(_VertexOffset_Tex)", 2D) = "white" {}
		_VertexOffset_Speed_R ("顶点偏移速度r(_VertexOffset_Speed_R)", Range(-1, 1)) = 1
		_VertexOffset_Strength_R ("顶点偏移强度r(_VertexOffset_Strength_R)", Range(-1, 1)) = 1
		_VertexOffset_Speed_G ("顶点偏移速度g(_VertexOffset_Speed_G)", Range(-1, 1)) = 1
		_VertexOffset_Strength_G ("顶点偏移强度r(_VertexOffset_Strength_G)", Range(-1, 1)) = 1
		_VertexOffset_AlphaMask ("顶点色a通道遮罩强度(_VertexOffset_AlphaMask)", Range(0, 1)) = 1
		_DepthFadeDistance ("扫描线宽度(_DepthFadeDistance)", Range(0, 3)) = 1
		_DepthFade ("扫描线过渡(_DepthFade)", Range(0, 4)) = 1
		_DepthMatchColor ("扫描线颜色(_DepthMatchColor)", Vector) = (1,1,1,1)
		_ZOffset ("深度偏移(_ZOffset)", Float) = 0
		[HideInInspector] _RenderType ("渲染类型", Float) = 3000
		[HideInInspector] _AlphaTest ("透明度剔除", Float) = 0
		[HideInInspector] _BlendMode ("混合模式", Float) = 1
		[MaterialEnum(None,0,Front,1,Back,2)] _CullMode ("剔除模式(_CullMode)", Float) = 2
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend(_SrcBlend)", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend(_DstBlend)", Float) = 10
		[HideInInspector] _ZWrite ("深度写入", Float) = 0
		[HideInInspector] _ZTest ("深度测试", Float) = 4
	    _MaskIndex ("模板测试通道(_MaskIndex)", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _MaskCompareFunction ("模版测试比较函数(_MaskCompareFunction)", Float) = 8
		_StencilReadMask ("模板读取遮罩(_StencilReadMask)", Float) = 255
		_ColorMask ("颜色写入掩码(_ColorMask)", Float) = 15
		[HideInInspector] IF_MaskFlowMapKeyword ("遮罩流动强度缩放", Range(0, 2)) = 0
		[HideInInspector] IF_DissolutionFlowMap ("", Float) = 0
		[HideInInspector] IF_MainTexFlowMap ("", Float) = 1
		 _CustomAlpha ("自定义透明值(_CustomAlpha)", Range(0, 1)) = 1
		_DetailAlphaTestMask ("角色Alphatest透明图(_DetailAlphaTestMask)", 2D) = "white" {}
		_DetailAlphaTestValue ("角色Alphatest透明度剔除(_DetailAlphaTestValue)", Float) = 0

    }
    SubShader {
        
		LOD 100
		Tags { "AlphaType" = "Effect" "IGNOREPROJECTOR" = "true" "MirrorType" = "Effect" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
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
		//AlphaTest [_AlphaTest]
		Pass 
		{

			CGPROGRAM
			#define cmp -
			#pragma vertex vert
			#pragma fragment frag
			//#pragma target 3.0
			#pragma multi_compile_instancing
			//#pragma multi_compile_particles
			#pragma multi_compile_fog
			
			#pragma multi_compile _ _AlphaTest_ON _ALPHABLEND_ON _ADDITIVE_ON _MULTIPLY_ON
			#pragma multi_compile _ _RIM_LERP _RIM_LERP_WITH_ALPHA _RIM_MASK 
			#pragma multi_compile _ _DISSOLUTION _DISSOLUTION_SCREEN_UV _DISSOLUTION_UV2
			#pragma multi_compile _ _MASKUV0 _MASKUV1 _MASK_SCREEN_UV
			#pragma multi_compile _ _MAINTEX_DISABLE _MAINTEX_SCREEN_UV
			
			#pragma shader_feature _XSHAKE_VERTEX
			
			#pragma shader_feature _XFIRE
			#pragma shader_feature _USE_HEIGHT_FOG
			#pragma shader_feature _DepthMatch
			#pragma shader_feature _XCLIP_RECT
			#pragma shader_feature _FLOWMAP
			#pragma shader_feature _VERTEX_ALPHA_OFF
			#pragma shader_feature XFOG_DISABLED
			#pragma shader_feature _SECOND_TEX
			#pragma shader_feature _RADIAL_MASK_UV
			#pragma shader_feature _XUIFONT
			#pragma shader_feature _VERTEX_RGB_OFF
			#pragma shader_feature _XCUSTOM_DATA_FOR_UV
			#pragma shader_feature _XDISTANCE_FADE
			#pragma shader_feature _XICE
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "UnityInstancing.cginc"
			uniform sampler2D _MainTex;
			uniform fixed4 _MainTexColor;
			uniform float4 _MainTex_ST;
			uniform float _MainRotation;
			uniform float4 _MainRotationParams;
			uniform sampler2D _SecondTex;
			uniform float4 _SecondTex_ST;
			uniform float _SecondRotation;
			uniform float4 _SecondRotationParams;
			uniform float4 _SecondColor;
			uniform float4 _TintColor;
			uniform float _EffectBrightness;
			uniform float _EffectBrightnessR;
			uniform float _EffectBrightnessG;
			uniform float _EffectBrightnessB;
			uniform sampler2D _MaskTex;
			uniform float4 _MaskTex_ST;
			uniform float _MaskRotation;
			uniform float4 _MaskRotationParams;
			uniform float4 _RimColor;
			uniform float _RimRange;
			uniform sampler2D _DissolutionTex;
			uniform float4 _DissolutionTex_ST;
			uniform float _DissolutionRotation;
			uniform float4 _DissolutionRotationParams;
			uniform float _DissolutionThreshold;
			uniform float _DissolutionSoftness;
			uniform float4 _DissolutionColor;
			uniform sampler2D _FlowTex;
			uniform float4 _FlowTex_ST;
			uniform float4 _FlowSpeed;
			uniform float _FlowIntensity;
			uniform float4 _ShakeVertexData;
			uniform float _ShakeVertexNoiseFrequancy;
			uniform float _ShakeVertexNoiseIntensity;
			uniform float _ShakeVertexScrollSpeed;
			uniform float _SpecialEffectIntensity;
			uniform sampler2D _IceTex;
			uniform sampler2D _IceNoise;
			uniform sampler2D _FireNoise;
			uniform float _HideDistance;
			uniform float _ShowDistance;
			uniform float _ParallaxScale;
			uniform float _ParallaxZOffset;
			uniform float _ParallaxMaskUV;
			uniform float _ParallaxDissolutionUV;
			uniform sampler2D _VAT_Tex;
			uniform float4 _VAT_Tex_ST;
			uniform float _VAT_Frame;
			uniform float4 _VAT_MaxBound;
			uniform float4 _VAT_MinBound;
			uniform float _VAT_FrameCount;
			uniform float _VAT_VertexSize;
			uniform float _VAT_Blend;
			uniform float _VAT_VertexSampleCount;
			uniform sampler2D _VertexOffset_Tex;
			uniform float4 _VertexOffset_Tex_ST;
			uniform float _VertexOffset_Speed_R;
			uniform float _VertexOffset_Strength_R;
			uniform float _VertexOffset_Speed_G;
			uniform float _VertexOffset_Strength_G;
			uniform float _VertexOffset_AlphaMask;
			uniform float _DepthFadeDistance;
			uniform float _DepthFade;
			uniform float4 _DepthMatchColor;
			float _AlphaTest;
			uniform float _ZOffset;
			uniform float IF_MaskFlowMapKeyword;
			uniform float IF_DissolutionFlowMap;
			uniform float IF_MainTexFlowMap;
			uniform float _CustomAlpha;
			uniform sampler2D _DetailAlphaTestMask;
			uniform float4 _DetailAlphaTestMask_ST;
			uniform float _DetailAlphaTestValue;
			float _CharDistanceFogIntensity;
			
			struct appdata_t
			{
				float4 vertex : POSITION0;
				fixed4 color : COLOR0;
				#if _RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA || _XICE
					float3 normal : NORMAL;
				#endif
				float4 uv0 : TEXCOORD0;
				#if _DISSOLUTION_UV2 || _XCUSTOM_DATA_FOR_UV || _MASKUV1
					float4 uv1 : TEXCOORD1;
				#endif
				#if _XCUSTOM_DATA_FOR_UV
					float4 uv2 : TEXCOORD2;
				#endif

			};
			struct v2f
			{
				float4 svPOS : SV_POSITION;
				fixed4 color : COLOR0;
				float4 texcoord : TEXCOORD0;
				#if _DISSOLUTION || _DISSOLUTION_UV2 || _DISSOLUTION_SCREEN_UV
					float3 texcoord1 : TEXCOORD1;
					#endif
				//#if _RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA||_XDISTANCE_FADE||_XICE
				//	float4 uv2 : TEXCOORD2;
				//	float4 uv3 : TEXCOORD3;
				//	#endif
				#if _RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA || _XDISTANCE_FADE || _XICE || _XCUSTOM_DATA_FOR_UV || _USE_HEIGHT_FOG
					float4 texcoord2 : TEXCOORD2;
				#endif
				#if _RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA || _XDISTANCE_FADE || _XICE
					float4 texcoord3 : TEXCOORD3;
				#endif
				#if _FLOWMAP
					float4 texcoord4 : TEXCOORD4;
				#endif
				#if !XFOG_DISABLED
					float4 depth : TEXCOORD5;
				#endif
				#if _XCLIP_RECT
					float4 texcoord6 : TEXCOORD6;
				#endif
				#if _MAINTEX_SCREEN_UV
					float4 texcoord7 : TEXCOORD7;
				#endif
				#if _DepthMatch
					float texcoord8 : TEXCOORD8;
				#endif
			};
			//#if _BlendMode == 0
			//	Blend = One Zero, One Zero
			//	ZWrite = 1
			//	_AlphaTest_ON = 0
			//	_MULTIPLY_ON = 0
			//	_ALPHABLEND_ON = 0
			//	_ADDITIVE_ON = 0
			//#elif _BlendMode == 2
			//	 _ADDITIVE_ON = 1
			//#elif _BlendMode == 3
			//	_ALPHABLEND_ON = 1
			//#elif _BlendMode == 1
			//	_AlphaTest_ON = 1
			//#endif

			//#ifdef _ALPHABLEND_ON
			//	Blend = SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			//	ZWrite = 0
			//	_ADDITIVE_ON = 0
			//	_AlphaTest_ON = 0
			//	_MULTIPLY_ON = 0
			//#endif

			//#ifdef _ADDITIVE_ON
			//	Blend = SrcAlpha One, SrcAlpha One
			//	ZWrite = 0
			//	_MULTIPLY_ON = 0
			//	_AlphaTest_ON = 0
			//	_ALPHABLEND_ON = 0
			//#endif
			//#ifdef _AlphaTest_ON
			//	Blend = One Zero, One Zero
			//	ZWrite = 1
			//	_MULTIPLY_ON = 0
			//	_ADDITIVE_ON = 0
			//	_ALPHABLEND_ON = 0
			//#endif
			//#ifdef _MULTIPLY_ON
			//	Blend = One OneMinusSrcAlpha, One OneMinusSrcAlpha
			//	ZWrite = 0
			//	_ALPHABLEND_ON = 0
			//	_AlphaTest_ON = 0
			//	_ADDITIVE_ON = 0
			//#endif
			//#ifdef _MAINTEX_DISABLE
			//	_MAINTEX_SCREEN_UV = 0
			//#endif
			//#ifdef _DISSOLUTION_SCREEN_UV
			//	_DISSOLUTION = 0
			//#endif
				

			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				//UNITY_SETUP_INSTANCE_ID(v);
				
				float4 matrixStuff,tempMatrix,tempMatrix2,matrixStuff2;
				float lDepth;
				float4 screenUV0,screenUV1,screenUV2;
				float4 maskUVx4;
				float4 dissolx4;
				float4 flowx4;
				float4 rimx4_1; 
				float4 rimx4_2 = float4(0,0,0,0); 
				float4 rimx4_3; 
				float4 rimx4_4;
				float xShake1, xShake2;
				float3 xShake3;
				#if _XSHAKE_VERTEX
					xShake1 = _Time.y * _ShakeVertexData.w;
					xShake1 = frac(xShake1);
					xShake1 = xShake1 + -0.5;
					xShake1 = abs(xShake1) * 4 + -1;
				#endif	
				matrixStuff = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
				matrixStuff = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + matrixStuff;
				matrixStuff = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + matrixStuff;
				matrixStuff2 = matrixStuff;
				#if !_RIM_LERP && !_RIM_MASK && !_RIM_LERP_WITH_ALPHA && !_USE_HEIGHT_FOG&&!_XDISTANCE_FADE&&!_XICE
					matrixStuff = matrixStuff + unity_ObjectToWorld._m03_m13_m23_m33;
					tempMatrix = matrixStuff.yyyy * UNITY_MATRIX_VP._m01_m11_m21_m31;
					tempMatrix = UNITY_MATRIX_VP._m00_m10_m20_m30 * matrixStuff.xxxx + tempMatrix;
					tempMatrix = UNITY_MATRIX_VP._m02_m12_m22_m32 * matrixStuff.zzzz + tempMatrix;
					matrixStuff = UNITY_MATRIX_VP._m03_m13_m23_m33 * matrixStuff.wwww + tempMatrix;
				#elif (_RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA||_USE_HEIGHT_FOG||_XDISTANCE_FADE||_XICE) && !_DepthMatch
					tempMatrix = matrixStuff + unity_ObjectToWorld._m03_m13_m23_m33;
					o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.www + matrixStuff.xyz;
					matrixStuff = tempMatrix.yyyy * UNITY_MATRIX_VP._m01_m11_m21_m31;
					matrixStuff = UNITY_MATRIX_VP._m00_m10_m20_m30 * tempMatrix.xxxx + matrixStuff;
					matrixStuff = UNITY_MATRIX_VP._m02_m12_m22_m32 * tempMatrix.zzzz + matrixStuff;
					matrixStuff = UNITY_MATRIX_VP._m03_m13_m23_m33 * tempMatrix.wwww + matrixStuff;
				#elif _RIM_LERP_WITH_ALPHA && _DepthMatch
					tempMatrix = matrixStuff + unity_ObjectToWorld._m03_m13_m23_m33;
					tempMatrix2 = tempMatrix.yyyy * UNITY_MATRIX_VP._m03_m13_m23_m33;
					tempMatrix2 = UNITY_MATRIX_VP._m00_m10_m20_m30 * tempMatrix.xxxx + tempMatrix2;
					tempMatrix2 = UNITY_MATRIX_VP._m02_m12_m22_m32 * tempMatrix.zzzz + tempMatrix2;
					tempMatrix = UNITY_MATRIX_VP._m03_m13_m23_m33 * tempMatrix.wwww + tempMatrix2;
					matrixStuff = tempMatrix;
				#endif
				#if _XSHAKE_VERTEX
					xShake2 = _Time.y * _ShakeVertexScrollSpeed;
					xShake2 = matrixStuff.y * _ShakeVertexNoiseFrequancy + xShake2;
					xShake2 = cos(xShake2);
					xShake2 = xShake2 * _ShakeVertexNoiseIntensity;
					xShake1 = xShake2 * xShake1 + xShake1;
					xShake3 =  xShake1.xxx * _ShakeVertexData.xyz + matrixStuff.xyz;
					o.svPOS.w = matrixStuff.w;
					o.svPOS.xy = xShake3.xy;
				#else
					o.svPOS.xyw = matrixStuff.xyw;
				#endif
				lDepth = -_ZOffset * -0.00100000005 + matrixStuff.z;
				o.svPOS.z = lDepth;
				#if !XFOG_DISABLED
					o.depth = lDepth;
				#endif
				#if _XCLIP_RECT
					o.texcoord6 = matrixStuff;
				#endif
				o.color = v.color;

				#if _MASK_SCREEN_UV || _MAINTEX_SCREEN_UV || _DISSOLUTION_SCREEN_UV
					screenUV1 = unity_CameraProjection._m01_m11_m21_m31.xyxy * unity_WorldToCamera._m01_m11_m21_m31.yyyy;
					screenUV1 = unity_CameraProjection._m00_m10_m20_m30.xyxy * unity_WorldToCamera._m01_m11_m21_m31.xxxx + screenUV1;
					screenUV1 = unity_CameraProjection._m02_m12_m22_m32.xyxy * unity_WorldToCamera._m01_m11_m21_m31.zzzz + screenUV1;
					screenUV1 = unity_CameraProjection._m03_m13_m23_m33.xyxy * unity_WorldToCamera._m01_m11_m21_m31.wwww + screenUV1;
					screenUV1 = screenUV1 * unity_ObjectToWorld._m03_m13_m23_m33.yyyy;
					screenUV2 = unity_CameraProjection._m01_m11_m21_m31.xyxy * unity_WorldToCamera._m00_m10_m20_m30.yyyy;
					screenUV2 = unity_CameraProjection._m00_m10_m20_m30.xyxy * unity_WorldToCamera._m00_m10_m20_m30.xxxx + screenUV2;
					screenUV2 = unity_CameraProjection._m02_m12_m22_m32.xyxy * unity_WorldToCamera._m00_m10_m20_m30.zzzz + screenUV2;
					screenUV2 = unity_CameraProjection._m03_m13_m23_m33.xyxy * unity_WorldToCamera._m00_m10_m20_m30.wwww + screenUV2;
					screenUV1 = screenUV2 * unity_ObjectToWorld._m03_m13_m23_m33.xxxx + screenUV1;
					screenUV2 = unity_CameraProjection._m01_m11_m21_m31.xyxy * unity_WorldToCamera._m02_m12_m22_m32.yyyy;
					screenUV2 = unity_CameraProjection._m00_m10_m20_m30.xyxy * unity_WorldToCamera._m02_m12_m22_m32.xxxx + screenUV2;
					screenUV2 = unity_CameraProjection._m02_m12_m22_m32.xyxy * unity_WorldToCamera._m02_m12_m22_m32.zzzz + screenUV2;
					screenUV2 = unity_CameraProjection._m03_m13_m23_m33.xyxy * unity_WorldToCamera._m02_m12_m22_m32.wwww + screenUV2;
					screenUV1 = screenUV2 * unity_ObjectToWorld._m03_m13_m23_m33.zzzz + screenUV1;
					screenUV2 = unity_CameraProjection._m01_m11_m21_m31.xyxy * unity_WorldToCamera._m03_m13_m23_m33.yyyy;
					screenUV2 = unity_CameraProjection._m00_m10_m20_m30.xyxy * unity_WorldToCamera._m03_m13_m23_m33.xxxx + screenUV2;
					screenUV2 = unity_CameraProjection._m02_m12_m22_m32.xyxy * unity_WorldToCamera._m03_m13_m23_m33.zzzz + screenUV2;
					screenUV2 = unity_CameraProjection._m03_m13_m23_m33.xyxy * unity_WorldToCamera._m03_m13_m23_m33.wwww + screenUV2;
					screenUV1 = screenUV1 + screenUV2;
					screenUV0 = matrixStuff.xyxy + -screenUV1;
					screenUV0 = screenUV0 / _ScreenParams.xyxy;
					#if _MASK_SCREEN_UV && !_MAINTEX_SCREEN_UV && !_DISSOLUTION_SCREEN_UV
						o.texcoord.xy = screenUV0.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
					#elif _DISSOLUTION_SCREEN_UV && !_MAINTEX_SCREEN_UV && !_MASK_SCREEN_UV
						screenUV0 = screenUV0 * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
						screenUV0 = screenUV0 * _DissolutionRotationParams;
						o.texcoord1.xy = screenUV0.yw + screenUV0.xz;
						
					#elif _MAINTEX_SCREEN_UV && !_DISSOLUTION_SCREEN_UV && !_MASK_SCREEN_UV
						o.texcoord7.xy = screenUV0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					#elif _MASK_SCREEN_UV && _DISSOLUTION_SCREEN_UV && !_MAINTEX_SCREEN_UV
						o.texcoord.zw = screenUV0.zw * _MaskTex_ST.xy + _MaskTex_ST.zw;
						screenUV0 = screenUV0 * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
						screenUV0 = screenUV0 * _DissolutionRotationParams;
						o.texcoord1.xy = screenUV0.yw + screenUV0.xz;
						
					#elif _MASK_SCREEN_UV && _MAINTEX_SCREEN_UV && !_DISSOLUTION_SCREEN_UV
						o.texcoord.zw = screenUV0.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
						o.texcoord7.xy = screenUV0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					#elif _MASK_SCREEN_UV && _DISSOLUTION_SCREEN_UV && _MAINTEX_SCREEN_UV
						o.texcoord.zw = screenUV0.zw * _MaskTex_ST.xy + _MaskTex_ST.zw;
						screenUV1 = screenUV0 * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
						o.texcoord7.xy = screenUV0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
						screenUV0 = screenUV1 * _DissolutionRotationParams;
						o.texcoord1.xy = screenUV0.yw + screenUV0.xz;
						
					#endif
				#endif

				#if _MASKUV0 || _MASKUV1
					#if _MASKUV0
						maskUVx4 = v.uv0.xyxy * _MaskTex_ST.xyxy+_MaskTex_ST.zwzw;
					#elif _MASKUV1
						maskUVx4 = v.uv1.xyxy * _MaskTex_ST.xyxy+_MaskTex_ST.zwzw;
					#endif
					maskUVx4 = maskUVx4 * _MaskRotationParams;
					o.texcoord.zw = maskUVx4.yw + maskUVx4.xz;
				#endif
				#if !_XCUSTOM_DATA_FOR_UV
					o.texcoord.xy = v.uv0.xy;
				#else
					o.texcoord.xy = v.uv0.xy + v.uv1.xy;
				#endif

				#if !_MASKUV0 && !_MASK_SCREEN_UV
					o.texcoord.zw = float2(0,0);
				#endif

				#if _XCUSTOM_DATA_FOR_UV
					o.texcoord1.xy = float2(0,0);
					o.texcoord1.z = v.uv2.x;
				#endif

				#if _DISSOLUTION
					dissolx4 = v.uv0.xyxy * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
					dissolx4 = dissolx4 * _DissolutionRotationParams;
					o.texcoord1.xy = dissolx4.yw + dissolx4.xz;
				#elif _DISSOLUTION_UV2
					dissolx4 = v.uv1.xyxy * _DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
					dissolx4 = dissolx4 * _DissolutionRotationParams;
					o.texcoord1.xy = dissolx4.yw + dissolx4.xz;
				#endif

				#if _FLOWMAP
					flowx4 = v.uv0.xyxy * _FlowTex_ST.xyxy + _FlowTex_ST.zwzw;
					o.texcoord4 = _FlowSpeed * _Time.yyyy + flowx4;
				#endif

				#if (_RIM_LERP || _RIM_MASK || _RIM_LERP_WITH_ALPHA||_XICE) && !_DepthMatch
					rimx4_1.x = dot(v.normal.xyz, v.normal.xyz);
					rimx4_1.x = rsqrt(rimx4_1.x);
					rimx4_1.xyz = rimx4_1.xxx * v.normal.xyz;
					rimx4_2.x = dot(rimx4_1.xyz, unity_WorldToObject._m00_m10_m20_m30.xyz);
					rimx4_2.y = dot(rimx4_1.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
					rimx4_2.z = dot(rimx4_1.xyz, unity_WorldToObject._m02_m12_m22_m32.xyz);
					rimx4_1.x = dot(rimx4_2,rimx4_2);
					rimx4_1.x = rsqrt(rimx4_1.x);
					o.texcoord3.xyz = rimx4_1.xxx * rimx4_2.xyz;
				#elif _RIM_LERP_WITH_ALPHA && _DepthMatch
					o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23_m33.xyz * v.vector.www + matrixStuff2.xyz;
					rimx4_1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vector.wwww + matrixStuff2;
					rimx4_2.x = dot(v.normal.xyz,v.normal.xyz);
					rimx4_2.x = rsqrt(rimx4_2.x);
					rimx4_2.xyz = rimx4_2.xxx * v.normal.xyz;
					rimx4_3.x = dot(rimx4_2.xyz,unity_WorldToObject._m00_m10_m20_m30.xyz);
					rimx4_3.y = dot(rimx4_2.xyz, unity_WorldToObject._m01_m11_m21_m31.xyz);
					rimx4_3.z = dot(rimx4_2.xyz,unity_WorldToObject._m02_m12_m22_m32.xyz);
					rimx4_2.x = dot(rimx4_3.xyz,rimx4_3.xyz);
					rimx4_2.x = rsqrt(rimx4_2.x);
					o.texcoord3.xyz = rimx4_2.xxx * rimx4_3.xyz;
					rimx4_2 = rimx4_1.yyyy * UNITY_MATRIX_V._m01_m11_m21_m31;
					rimx4_2 = UNITY_MATRIX_V._m00_m10_m20_m30 * rimx4_1.xxxx+rimx4_2;
					rimx4_2 = UNITY_MATRIX_V._m02_m12_m22_m32 * rimx4_1.zzzz+rimx4_2;
					rimx4_1 = UNITY_MATRIX_V._m03_m13_m23_m33 * rimx4_1.wwww + rimx4_2;
					rimx4_2.xyz = rimx4_1.yyy * UNITY_MATRIX_P._m01_m11_m21_m31.xyw;
					rimx4_2.xyz = UNITY_MATRIX_P._m00_m10_m20_m30.xyw * rimx4_1.xxx+rimx4_2.xyz;
					rimx4_2.xyz = UNITY_MATRIX_P._m02_m12_m22_m32.xyw * rimx4_1.zzz+rimx4_2.xyz;
					rimx4_1.xyw = UNITY_MATRIX_P._m03_m13_m23_m33.xyw * rimx4_1.www + rimx4_2.xyz;
					o.texcoord8.z = -rimx4_1.x;
					rimx4_2.xz = rimx4_1.xw * float2(0.5,0.5);
					rimx4_1.x = rimx4_1.y * _ProjectionParams.x;
					o.texcoord8.w = rimx4_1.w;
					rimx4_2.w = rimx4_1.x * 0.5;
					o.texcoord8.xy = rimx4_2.zz+rimx4_2.xw;
				#endif

				return o;
			}	
//			v2f vert(appdata_t v)
//			{
//				v2f o;
//				float4 r0,r1,r2;
//				//#if _XSHAKE_VERTEX
//				//	r0.x = _Time.y * _ShakeVertexData.w;
//				//	r0.x = frac(r0.x);
//				//	r0.x = -0.5 + r0.x;
//				//	r0.x = abs(ro.x)*4-1;
//				//	r1 = unity_ObjectToWorld._m01_m11_m21_m31 * v.vertex.yyyy;
//				//	r1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + r1;
//				//	r1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + r1;
//				//	r1 = unity_ObjectToWorld[3] + r1;
//				//	r2 = UNITY_MATRIX_VP[1]*r1.yyyy;
//				//	r2 = UNITY_MATRIX_VP._m00_m10_m20_m30*r1.xxxx + r2;
//				//	r2 = UNITY_MATRIX_VP[2]*r1.zzzz+r2;
//				//	r1 = UNITY_MATRIX_VP[3]*r1.wwww+r2;
//				//#else
//					r0 = unity_ObjectToWorld._m01_m11_m21_m31 * v.vertex.yyyy;
//					r0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + r0;
//					r0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + r0;
//					//#if _RIM_LERP
//					//	r1 = unity_ObjectToWorld[3] + r0;
//					//	o.texcoord2.xyz = unity_ObjectToWorld[3].xyz * v.vertex.www + r0.xyz;
//					//	r0 = UNITY_MATRIX_VP[1]*r1.yyyy;
//					//	r0 = UNITY_MATRIX_VP[0]*r1.xxxx + r0;
//					//	r0 = UNITY_MATRIX_VP[2]*r1.zzzz + r0;
//					//	r0 = UNITY_MATRIX_VP[3]*r1.wwww + r0;
//					//#else
//						r0 = unity_ObjectToWorld._m03_m13_m23_m33 + r0;
//						r1 = UNITY_MATRIX_VP._m01_m11_m21_m31 * r0.yyyy;
//						r1 = UNITY_MATRIX_VP._m00_m10_m20_m30 * r0.xxxx + r1;
//						r1 = UNITY_MATRIX_VP._m02_m12_m22_m32 * r0.zzzz + r1;
//						r0 = UNITY_MATRIX_VP._m03_m13_m23_m33  * r0.wwww + r1;
////					#endif
//	//			#endif
//				o.svPOS.xyw = r0.xyw;
//				//#if _XCLIP_RECT
//				//	o.texcoord6 = r0;
//				//#endif
//				r0.x = -_ZOffset * -0.001 + r0.z;
//				o.svPOS.z = r0.x;
//				o.depth.x = r0.x;
//				o.color = v.color;
//				o.texcoord.xy = v.uv0.xy;
//				o.texcoord.zw = float2(0,0);
//				//#if _RIM_LERP
//				//	r0.x = dot(v.normal.xyz,v.normal.xyz);
//				//	ro.x = rsqrt(r0.x);
//				//	r0.xyz = v.normal.xyz*r0.xxx;
//				//	r1.x = dot(r0.xyz,unity_WorldToObject[0].xyz);
//				//	r1.y = dot(r0.xyz,unity_WorldToObject[1].xyz);
//				//	r1.z = dot(r0.xyz,unity_WorldToObject[2].xyz);
//				//	r0.x = dot(r1.xyz,r1.xyz);
//				//	r0.x = rsqrt(r0.x);
//				//	o.texcoord3 = r1.xyz * r0.xxx
//				//#endif
//				//#if _DISSOLUTION
//				//	r0 = v.uv0.xyxy*_DissolutionTex_ST.xyxy + _DissolutionTex_ST.zwzw;
//				//	r0 = _DissolutionRotationParams*r0;
//				//	o.texcoord1.xy = r0.xz + r0.yw;
//				//#endif
//				//#if _FLOWMAP
//				//	r0.xyzw = v.uv0.xyxy * _FlowTex_ST.xyxy+_FlowTex_ST.zwzw;
//				//	o.texcoord4 = _FlowSpeed * _Time.yyyy+r0;
//				//#endif
//				return o;
//			}

			fixed4 frag (v2f i) : SV_Target
			{
				
				
				float4 sv_target = float4(0,0,0,0); 
				//float4 t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12;
				float4 r0,r1,r2,r3,r4,r5;
				float fog;
				float4 uvTemp1,uvTemp2;
				float2 uvx2_1,uvx2_2;
				float4 tex4_1,tex4_2,tex4_3,tex4_4;
				float4 mainTex;
				float4 color1 = float4(0,0,0,0);
				float4 color2,color3,color4,rimLerpAlphaColor;
				float4 xclip1,xclip2;
				float xclipx1;
				float4 texColorPreBright = float4(0,0,0,0);
				float4 texColorPostBright = float4(0,0,0,0);
				float4 rimLerpx4_1 = float4(0,0,0,0);
				float4 rimLerpx4_2 = float4(0,0,0,0);
				float4 dissolx4_1, dissolx4_2;
				float4 flow1,flow2;
				float2 flowx2;
				float4 secondTex4 = float4(0,0,0,0);
				float2 secondTexUV = float2(0,0);
				float4 icex4_1,icex4_2;
				float4 firex4;
				float firex1;
				float2 dissolUV = float4(0,0,0,0);
				float4 dissolTex;
				float4 distanceFade;
				float4 heightFog1, heightFog2;
				float4 depthx4_1, depthx4_2, depthx4_3;
				float4 secondColor = float4(0,0,0,0);
				float4 tempColor1, tempColor2,tempColor3,tempColor4;
				float4 rimMaskColor;
				float4 dissolTexCol;
				float2 maskUV;
				float4 xIceColor;
				float3 effectBrightColor;
				float4 earlyMaskTex = float4(0,0,0,0);
				float4 earlyDissolTex;
				float4 flow3;
				float4 radialx4;
				float2 radialx2;
				float4 radialMaskTex;
				float radialAlpha;
				bool alphaSaturated = false;
				//float4 xUIFont
				float3 tempColorx3_1 = float3(0,0,0);
				float3 tempColorx3_2 = float3(0,0,0);
				float tempAlpha1 = 0;
				float tempAlpha2,tempAlpha3;
				#if !XFOG_DISABLED && !_ADDITIVE_ON && !_USE_HEIGHT_FOG
					fog = i.depth / _ProjectionParams.y;
					fog = 1 + -fog;
					fog = _ProjectionParams.z * fog;
					fog = max(fog,0);
					fog = saturate(fog * unity_FogParams.z + unity_FogParams.w);
					fog = 1 + -fog;
					fog = _CharDistanceFogIntensity * fog;
				#endif
				
				#if _XDISTANCE_FADE
					distanceFade.x = -_HideDistance + _ShowDistance;
					distanceFade.y = 9.99999975e-05 >= abs(distanceFade.x);
					distanceFade.y = distanceFade.y ? 1:0;
					distanceFade.z = 9.99999975e-05 + -distanceFade.x;
					distanceFade.x = distanceFade.y * distanceFade.z + distanceFade.x;
					distanceFade.yzw = -_WorldSpaceCameraPos.xyz + i.texcoord2.xyz;
					distanceFade.y = abs(distanceFade.y) + abs(distanceFade.z);
					distanceFade.y = distanceFade.y + abs(distanceFade.w);
					distanceFade.y = -_HideDistance + distanceFade.y;
					distanceFade.x = saturate(distanceFade.y / distanceFade.x);
				#endif
				#if _XICE
					icex4_1.x = dot(i.texcoord3.xyz,i.texcoord3.xyz);
					icex4_1.x = rsqrt(icex4_1.x);
					icex4_1.x = i.texcoord3.y * icex4_1.x + -0.400000006;
					icex4_1.x = saturate(2.85714293 * icex4_1.x);
					icex4_1.y = icex4_1.x * (-2) + 3;
					icex4_1.x = icex4_1.x * icex4_1.x;
					icex4_1.x = icex4_1.y * icex4_1.x;
					icex4_1.yz = i.texcoord2.xz + i.texcoord2.xz;
					icex4_2 = tex2D(_IceNoise,icex4_1.yz);
					icex4_1.x = icex4_2.x * icex4_1.x;
					icex4_2 = tex2D(_IceTex,i.texcoord.xy);
					icex4_1.yzw = float3(1,1,1) + (-icex4_2.xyz);
					icex4_1.xyz = icex4_1.xxx * icex4_1.yzw + icex4_2.xyz;
				#endif
				#if _XFIRE
					firex4 = tex2D(_FireNoise,i.texcoord.xy);
					firex1 = _Time.y * 0.400000006 + (-firex4.y);
					firex1 = frac(firex1);
					firex1 = -0.5 + firex1;
					firex1 = 1.5 * abs(firex1);
					firex1 = firex1 * firex1;
					firex1 = _SpecialEffectIntensity * firex1;
				#endif

				#if _RADIAL_MASK_UV && (_MASKUV0||_MASKUV1)
					radialx4.xy = i.texcoord.zw * float2(2,2) + float2(-1,-1);
					radialx4.z = max(abs(radialx4.y),abs(radialx4.x));
					radialx4.z = 1 / radialx4.z;
					radialx4.w = min(abs(radialx4.y),abs(radialx4.x));
					radialx4.z = radialx4.w * radialx4.z;
					radialx4.w = radialx4.z * radialx4.z;
					radialx2.x = radialx4.w * 0.0208350997 + -0.0851330012;
					radialx2.x = radialx4.w * radialx2.x + 0.180141002;
					radialx2.x = radialx4.w * radialx2.x + -0.330299497;
					radialx4.w = radialx4.w * radialx2.x + 0.999866009;
					radialx2.x = radialx4.z * radialx4.w;
					radialx2.x = radialx2.x * -2 + 1.57079601;
					radialx2.y = abs(radialx4.y)<abs(radialx4.x);
					radialx2.x = radialx2.y ? radialx2.x : 0;
					radialx4.z = radialx4.z * radialx4.w + radialx2.x;
					radialx4.w = radialx4.y < -radialx4.y;
					radialx4.w = radialx4.w ? -3.141593f : 0;
					radialx4.z = radialx4.z + radialx4.w;
					radialx4.w = min(radialx4.y,radialx4.x);
					radialx4.w = radialx4.w < -radialx4.w;
					radialx2.x = max(radialx4.y,radialx4.x);
					radialx4.x = dot(radialx4.xy,radialx4.xy);
					radialx4.x = sqrt(radialx4.x);
					radialx2.x = radialx2.x >= -radialx2.x;
					radialx4.w = radialx4.w ?  radialx2.x : 0;
					radialx4.z = radialx4.w ? -radialx4.z : radialx4.z;
					radialx4.y = radialx4.z * 0.159154907 + 0.5;

					maskUV = radialx4.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
					#if !_FLOWMAP
						radialMaskTex = tex2D(_MaskTex,maskUV);
					#endif
				#endif
				#if _XCLIP_RECT
					xclip1.x = 0>=_ProjectionParams.x;
					xclip1.x = xclip1.x ? 1:0;
					xclip2.xy = i.svPOS.xy / _ScreenParams.xy;
					xclip1.y = xclip2.y * -2 + 1;
					xclip1.x = xclip1.x * xclip1.y + xclip2.y;
					xclip2.z = 1 + -xclip1.x;
					xclip1 = -_XClipRect._m00_m10_m20_m30 + xclip2.xzxz;
					xclip2 = -_XClipRect._m01_m11_m21_m31 + xclip2.xzxz;
					xclipx1 = dot(xclip1.xy,xclip1.xy);
					xclipx1 = rsqrt(xclipx1);
					xclip1.xy = xclipx1.xx * xclip1.xy;
					xclip1.x = dot(xclip1.xy, _XClipRect._m02_m12);
					xclip1.x = xclip1.x >=0;
					xclip1.y = dot(xclip1.zw,xclip1.zw);
					xclip1.y = rsqrt(xclip1.y);
					xclip1.yz = xclip2.yz * xclip1.yy;
					xclip1.y = dot(xclip1.yz,_XClipRect._m22_m32);
					xclip1.y = xclip1.y>=0;
					xclip1.xy = xclip1.xy?float2(1,1):0
					xclip1.x = xclip1.x * xclip1.y;
					xclip1.y = dot(xclip2.xy,xclip2.xy);
					xclip1.y = rsqrt(xclip1.y);
					xclip1.yz = xclip2.xy * xclip1.yy;
					xclip1.y = dot(xclip1.yz, _XClipRect._m03_m13);
					xclip1.y = (xclip1.y >=0);
					xclip1.y = xclip1.y ? 1:0;
					xclip1.x = xclip1.x * xclip1.y;
					xclip1.y = dot(xclip2.zw,xclip2.zw);
					xclip1.y = rsqrt(xclip1.y);
					xclip1.yz = xclip2.zw*xclip1.yy;
					xclip1.y = dot(xclip1.yz,_XClipRect._m23_m33);
					xclip1.y = (xclip1.y>=0);
					xclip1.y = xclip1.y ? 1:0;
					xclip1.x = xclip1.x * xclip1.y;
				#endif
				#if _RIM_LERP||_RIM_MASK||_RIM_LERP_WITH_ALPHA
					rimLerpx4_1.xyz = _WorldSpaceCameraPos.xyz + (-i.texcoord2.xyz);
					rimLerpx4_1.w = dot(rimLerpx4_1.xyz,rimLerpx4_1.xyz);
					rimLerpx4_1.w = rsqrt(rimLerpx4_1.w);
					rimLerpx4_1.xyz = rimLerpx4_1.xyz * rimLerpx4_1.www;
					rimLerpx4_1.w = dot(i.texcoord3.xyz,i.texcoord3.xyz);
					rimLerpx4_1.w = rsqrt(rimLerpx4_1.w);
					rimLerpx4_2.xyz = i.texcoord3.xyz * rimLerpx4_1.www;
					rimLerpx4_1.x = dot(rimLerpx4_1.xyz,rimLerpx4_2.xyz);
					rimLerpx4_1.x = min(rimLerpx4_1.x,0.980000019);
					rimLerpx4_1.y = -rimLerpx4_1.x + 1;
					rimLerpx4_1.x = _RimRange+(-abs(rimLerpx4_1.x));
					rimLerpx4_1.x = max(rimLerpx4_1.x,0);
					rimLerpx4_1.y = -rimLerpx4_1.x*rimLerpx4_1.x+rimLerpx4_1.y;
					rimLerpx4_1.x = rimLerpx4_1.x*rimLerpx4_1.x;
					rimLerpx4_1.x = rimLerpx4_1.x*rimLerpx4_1.y+rimLerpx4_1.x;
					#if _RIM_MASK
						rimMaskColor = _RimColor * rimLerpx4_1.xxxx;
						rimMaskColor.xyz = _EffectBrightness.xxx * rimMaskColor.xyz;

					#endif
					
				#endif
				

				#if _FLOWMAP
					flow1 = tex2D(_FlowTex,i.texcoord4.xy);
					flow2 = tex2D(_FlowTex,i.texcoord4.zw);
					flow1 = flow2.xyxy + flow1.xyxy;
					flow1 = float4(-1,-1,-1,-1) + flow1;
					#if _RADIAL_MASK_UV && (_MASKUV0||_MASKUV1)
						radialx2 = flow1.xy * _FlowIntensity.xx;
						maskUV = radialx2 * IF_MaskFlowMapKeyword.xx + maskUV;
						radialMaskTex = tex2D(_MaskTex,maskUV);
					#endif
					

				#endif
				#if !_MAINTEX_DISABLE && !_XUIFONT
					#if _MAINTEX_SCREEN_UV
						uvTemp1 = _MainRotationParams * i.texcoord7.xyyz;
						uvx2_1 = uvTemp1.xz + uvTemp1.yw;
					#else
						#if _SECOND_TEX
							secondTex4 = i.texcoord.xyxy * _SecondTex_ST.xyxy + _SecondTex_ST.zwzw;
							#if _FLOWMAP
								#if _XCUSTOM_DATA_FOR_UV
									flow3.x = _FlowIntensity + i.texcoord1.z;
									secondTex4 = flow1 * flow3.xxxx + secondTex4;
									flow1 = flow1 * flow3.xxxx;
								#else
									secondTex4 = flow1 * _FlowIntensity.xxxx + secondTex4;
								#endif
								#if _DISSOLUTION || _DISSOLUTION_UV2 || _DISSOLUTION_SCREEN_UV 
									dissolUV = flow1.zw * _FlowIntensity.xx;
								#endif
							#endif
							secondTex4 = _SecondRotationParams * secondTex4;
							secondTexUV = secondTex4.xz + secondTex4.yw;
							secondTex4 = tex2D(_SecondTex,secondTexUV);
							#if _ADDITIVE_ON && _FLOWMAP
								secondColor = secondTex4 * _SecondColor;
								secondColor.xyz = secondColor.xyz * secondColor.www;
							#endif
						
						
						
						#endif
						uvTemp1 = i.texcoord.xyxy * _MainTex_ST.xyxy + _MainTex_ST.zwzw;
						#if _FLOWMAP
							flow1 = flow1 * _FlowIntensity.xxxx;
							uvTemp1 = flow1 * IF_MainTexFlowMap.xxxx + uvTemp1;
							#if _DISSOLUTION || _DISSOLUTION_UV2 || _DISSOLUTION_SCREEN_UV
								dissolUV = flow1.xy * IF_DissolutionFlowMap.xx + i.texcoord1.xy;
								earlyDissolTex = tex2D(_DissolutionTex,dissolUV);
							#endif
							#if _MASKUV0||_MASKUV1
								#if _RADIAL_MASK_UV
									earlyMaskTex = radialMaskTex;
								#else
									maskUV = flow1.xy * IF_MaskFlowMapKeyword + i.texcoord.zw;
									earlyMaskTex = tex2D(_MaskTex,maskUV);
								#endif
							#endif
						#endif
						uvTemp1 = _MainRotationParams * uvTemp1;
						uvx2_1 = uvTemp1.xz + uvTemp1.yw;
					#endif
					
					mainTex = tex2D(_MainTex,uvx2_1);
					
					color1 = _MainTexColor * mainTex;
					
						#if _SECOND_TEX
							#if _ADDITIVE_ON && _FLOWMAP
								tempAlpha2 = mainTex.w * _MainTexColor.w + secondColor.w;
								secondColor.w = min(tempAlpha2,1);
								secondColor.xyz = color1.xyz * color1.www + secondColor.xyz;
								texColorPreBright = _TintColor * secondColor;
							#else
								secondColor = secondTex4 * _SecondColor + -color1;
								tempAlpha2 = _SecondColor.w * secondTex4.w;
								secondColor = tempAlpha2.xxxx * secondColor + color1;
							
								texColorPreBright = _TintColor * secondColor;
								
							#endif
						#else
							texColorPreBright = _TintColor * color1;
						#endif
						#if _RIM_MASK
							texColorPostBright.xyz = _EffectBrightness.xxx * texColorPreBright.xyz;
						#elif _RIM_LERP_WITH_ALPHA
							#if _VERTEX_ALPHA_OFF
								#if _SECOND_TEX && !_MASKUV0&&!_MASKUV1
									tempAlpha2 = -_TintColor.w * secondColor.w + _RimColor.w;
								#elif _SECOND_TEX && (_MASKUV0||_MASKUV1)
									rimLerpx4_2.y = earlyMaskTex.x * texColorPreBright.w;
									rimLerpx4_2.z = -texColorPreBright.w * earlyMaskTex.x + _RimColor.w;
								#else
									tempColor1 = _MainTexColor * mainTex;
									tempAlpha2 = -_TintColor.w * tempColor1.w + _RimColor.w;
								#endif
							#else
								#if _SECOND_TEX && (_MASKUV0||_MASKUV1)
									rimLerpx4_2.y = earlyMaskTex.x * texColorPreBright.w;
									rimLerpx4_2.z = -texColorPreBright.w * earlyMaskTex.x + _RimColor.w;
								#elif !_SECOND_TEX && !_MASKUV0 && !_MASKUV1 && (_DISSOLUTION||_DISSOLUTION_UV2||_DISSOLUTION_SCREEN_UV)
									tempColor1 = _MainTexColor * mainTex;
									tempAlpha2 = -_TintColor.w * tempAlpha1 + _RimColor.w;
								#else
									rimLerpx4_2.y = i.color.w * texColorPreBright.w;
									rimLerpx4_2.z = -texColorPreBright.w * i.color.w + _RimColor.w;
								#endif
							#endif
							#if !_DepthMatch
								rimLerpAlphaColor.xyz = _EffectBrightness.xxx * texColorPreBright.xyz;
							#else
								texColorPostBright.xyz = texColorPreBright.xyz * _EffectBrightness.xxx;
							#endif
						#else
							texColorPostBright.xyz = _EffectBrightness.xxx * texColorPreBright.xyz;
						#endif
					
					//#endif
				
				#else 
					#if _FLOWMAP
						flow1 = flow1 * _FlowIntensity.xxxx;
						#if _DISSOLUTION||_DISSOLUTION_UV2||_DISSOLUTION_SCREEN_UV
							dissolUV = flow1.zw * IF_DissolutionFlowMap.xx + i.texcoord1.xy;
							earlyDissolTex = tex2D(_DissolutionTex,dissolUV);
						#endif
						#if _MASKUV0 || _MASKUV1 || _MASK_SCREEN_UV
							maskUV = flow1.xy * IF_MaskFlowMapKeyword.xx + i.texcoord.zw;
							earlyMaskTex = tex2D(_MaskTex,maskUV);
						#endif
						
					#endif
					#if _RIM_MASK
						color1 = _RimColor * rimLerpx4_1.xxxx;
						color1.xyz = _EffectBrightness.xxx * color1.xyz;
						texColorPostBright.xyz = _TintColor.xyz * _EffectBrightness.xxx;
					#else
						texColorPostBright.xyz = _EffectBrightness.xxx * _TintColor.xyz;
					#endif
					#if _XUIFONT
						uvTemp1 = i.texcoord.xyxy * _MainTex_ST.xyxy + _MainTex_ST.zwzw;
						#if _FLOWMAP
							uvTemp1 = flow1 * IF_MainTexFlowMap.xxxx + uvTemp1;
						#endif
						uvTemp1 = _MainRotationParams * uvTemp1;
						uvx2_1 = uvTemp1.xz + uvTemp1.yw;
						mainTex = tex2D(_MainTex,uvx2_1);
						tempAlpha1 = _MainTexColor.w * mainTex.w;
						tempAlpha1 = _TintColor.w * tempAlpha1;
						tempAlpha1 = i.color.w * tempAlpha1;
						sv_target.w = saturate(_CustomAlpha * tempAlpha1);
					#endif
				#endif
				#if _DISSOLUTION || _DISSOLUTION_UV2 || _DISSOLUTION_SCREEN_UV
					dissolx4_1.x = max(_DissolutionSoftness,9.99999975e-05);
					dissolx4_1.y = 1 + dissolx4_1.x;
					#if _VERTEX_ALPHA_OFF
						dissolx4_1.x = _DissolutionThreshold * dissolx4_1.y + -dissolx4_1.x;
						dissolx4_1.y = _DissolutionThreshold * dissolx4_1.y + -dissolx4_1.x;
					#else
						dissolx4_1.x = i.color.w * dissolx4_1.y + -dissolx4_1.x;
						dissolx4_1.y = i.color.w * dissolx4_1.y + -dissolx4_1.x;
					#endif
					#if _FLOWMAP
						#if _SecondTex
							dissolTex = earlyDissolTex;
						#else
							dissolTex = tex2D(_DissolutionTex,dissolUV.xy);
						#endif
					#else
						dissolTex = tex2D(_DissolutionTex, i.texcoord1.xy);
					#endif
					dissolx4_1.x = dissolTex.x + -dissolx4_1.x;
					dissolx4_1.y = 1 / dissolx4_1.y;
					
					
					dissolx4_1.x = saturate(dissolx4_1.x * dissolx4_1.y);
					dissolx4_1.y = dissolx4_1.x * -2 + 3;
					dissolx4_1.x = dissolx4_1.x * dissolx4_1.x;
					dissolx4_1.x = dissolx4_1.y * dissolx4_1.x;
					dissolx4_1.x = min(dissolx4_1.x,1);
				#endif
				#if _DepthMatch
						
						
						
						color2.xyz = i.color.xyz * texColorPostBright.xyz;
						depthx4_2.w = rimLerpx4_1.x * rimLerpx4_2.z + rimLerpx4_2.y;
						color3.yzw = _RimColor.xyz * _EffectBrightness.xxx + -color2.xyz;
						depthx4_2.xyz = rimLerpx4_1.xxx * color3.yzw + color2.xyz;
						depthx4_1 = _DepthMatchColor + -depthx4_2;
						depthx4_3.xy = i.texcoord8.xy / i.texcoord8.ww;
						depthx4_3 = tex2D(_CameraDepthTexture,depthx4_3.xy);
						depthx4_3.x = dot(depthx4_3, float4(1,0.00392156886,1.53787005e-05,6.03086292e-08));
						depthx4_3.x = depthx4_3.x * _ProjectionParams.z + -i.texcoord8.z;
						depthx4_3.y = abs(depthx4_3.x) / _DepthFadeDistance;
						depthx4_3.x = _DepthFadeDistance >= abs(depthx4_3.x);
						depthx4_3.x = depthx4_3.x ? 1:0;
						depthx4_3.y = 1 + -depthx4_3.y;
						depthx4_3.y = depthx4_3.x * depthx4_3.y;
						depthx4_3.z = 1 / _DepthFade;
						depthx4_3.y = saturate(depthx4_3.y * depthx4_3.z);
						depthx4_3.z = depthx4_3.y * -2 + 3;
						depthx4_3.y = depthx4_3.y * depthx4_3.y;
						depthx4_3.y = depthx4_3.z * depthx4_3.y;
						depthx4_1 = depthx4_3.yyyy * depthx4_1;
						depthx4_1 = depthx4_3.xxxx * depthx4_1 + depthx4_2;
				#endif
				

					float4 preEffectBrightCol;
					float4 multColor1, multColor2;
					bool preEffectDef = false;
					#if !_MAINTEX_DISABLE
						

							#if !_DISSOLUTION && !_DISSOLUTION_UV2 && !_DISSOLUTION_SCREEN_UV&&!_RIM_MASK&&!_AlphaTest_ON&&!_XUIFONT
								
									
									tempAlpha1 = i.color.w * texColorPreBright.w;
								
								
									
									//tempAlpha1 = saturate(1.871 * tempAlpha1);

								
							#endif
							#if _AlphaTest_ON
								tempAlpha1 = texColorPreBright.w * i.color.w  - _AlphaTest;
								clip(tempAlpha1);
								texColorPostBright.w = texColorPreBright.w;
								tempColor1 = i.color * texColorPostBright;
							#endif
							#if _XICE
								tempColorx3_1 = -texColorPostBright.xyz * i.color.xyz + icex4_1.xyz;
								tempColorx3_2 = i.color.xyz * texColorPostBright.xyz;
								tempColorx3_1 = _SpecialEffectIntensity.xxx * tempColorx3_1 + tempColorx3_2;
								

							#endif
							#if _RIM_MASK
								tempColor1 = i.color * texColorPostBright;
								tempColor2 = tempColor1 * rimMaskColor;
								tempAlpha1 = tempColor2.w;
								//tempAlpha1 = saturate(1.871 * tempColor2.w);
							#endif
							#if _RIM_LERP_WITH_ALPHA
								tempColorx3_1 = i.color.xyz * rimLerpAlphaColor.xyz;
								#if _VERTEX_ALPHA_OFF && !((_MASKUV0||_MASKUV1)&&_SECOND_TEX)
									tempAlpha1 = rimLerpx4_1.x * tempAlpha2 + texColorPreBright.w;
								#elif !_VERTEX_ALPHA_OFF && !_SECOND_TEX && !(_MASKUV0||_MASKUV1)&&(_DISSOLUTION||_DISSOLUTION_UV2||_DISSOLUTION_SCREEN_UV)
									tempAlpha1 = rimLerpx4_1.x * tempAlpha2 + texColorPreBright.w;
								#else 
									tempAlpha1 = rimLerpx4_1.x * rimLerpx4_2.z + rimLerpx4_2.y;
								#endif
								#if !_DISSOLUTION && !_DISSOLUTION_UV2 && !_DISSOLUTION_SCREEN_UV&&!alphaSaturated
									tempAlpha1 = saturate(1.871 * tempAlpha1);
									alphaSaturated = true;
								#endif
								//tempColor2.w = tempAlpha1;
								tempColorx3_2 = _RimColor.xyz * _EffectBrightness.xxx + -tempColorx3_1;
								tempColorx3_1 = rimLerpx4_1.xxx * tempColorx3_2 + tempColorx3_1;
							#endif
							#if !_RIM_MASK && !_VERTEX_RGB_OFF && !_RIM_LERP_WITH_ALPHA && !_XICE
								tempColorx3_1 = i.color.xyz * texColorPostBright.xyz;
							#endif
							#if _MULTIPLY_ON
								multColor1 = float4(-0.5,-0.5,-0.5,-0.5) + float4(tempColorx3_1.x,tempColorx3_1.y,tempColorx3_1.z,tempAlpha1);
								multColor2 = tempAlpha1.xxxx * multColor1 + float4(0.5,0.5,0.5,0.5);
								tempColorx3_1 = multColor2.xyz;
								tempAlpha1 = multColor2.w;
							#endif
							#if _RIM_LERP
								tempColor1.xyz = _RimColor.xyz * _EffectBrightness.xxx + -tempColorx3_1;
								tempColorx3_1 = rimLerpx4_1.xxx * tempColor1.xyz + tempColorx3_1;
							#endif
							#if _MASKUV0 || _MASKUV1 || _MASK_SCREEN_UV
								#if _FLOWMAP
									
									tempColor1 = earlyMaskTex;
								#else
									tempColor1 = tex2D(_MaskTex,i.texcoord.zw);
								#endif
								#if !_RIM_LERP_WITH_ALPHA
									if(tempAlpha1!=0){
										tempAlpha1 = tempColor1.x * tempAlpha1;
									}
									else{
										tempAlpha1 = tempColor1.x * texColorPreBright.w;
									}
								#endif

								//tempAlpha1 = saturate(1.871 * tempAlpha1);
							#endif
							#if _DISSOLUTION || _DISSOLUTION_UV2 || _DISSOLUTION_SCREEN_UV
								#if !_MASKUV0 && !_MASKUV1 && !_MASK_SCREEN_UV
									if(tempAlpha1==0){
										tempAlpha1 = texColorPreBright.w;
									}
								#endif
								tempColor1.xyz = _DissolutionColor.xyz * _EffectBrightness.xxx + -tempColorx3_1;
								tempColor1.w = 0;

								tempColor1 = _DissolutionColor.wwww * tempColor1 + float4(tempColorx3_1.x,tempColorx3_1.y,tempColorx3_1.z,0);
								
									tempColor3 = float4(tempColorx3_1.x,tempColorx3_1.y,tempColorx3_1.z,tempAlpha1);
								
								tempColor2 = tempColor1 + -tempColor3;
								tempColor4 = dissolx4_1.xxxx * tempColor2 + tempColor3;
								dissolTexCol = tempColor4;
								preEffectBrightCol = dissolTexCol;
								preEffectDef = true;
								tempAlpha1 = dissolTexCol.w;
								//tempAlpha1 = saturate(1.871 * dissolTexCol.w);
							#endif
							// #if !preEffectDef
							// 	preEffectBrightCol = 
							// #endif
							#if !_RIM_MASK
								#if _VERTEX_RGB_OFF
									effectBrightColor = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * texColorPostBright.xyz;
								#else
									#if _RIM_LERP_WITH_ALPHA&&!_DISSOLUTION && !_DISSOLUTION_UV2 && !_DISSOLUTION_SCREEN_UV && !_SECOND_TEX
										effectBrightColor = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * tempColorx3_2;
									#elif (_DISSOLUTION || _DISSOLUTION_UV2 || _DISSOLUTION_SCREEN_UV)
										effectBrightColor = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * dissolTexCol.xyz;
									#else
										effectBrightColor = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * tempColorx3_1;

									#endif
								#endif
							#else
								effectBrightColor = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * tempColor2.xyz;
							#endif
							
							#if _XCLIP_RECT
								tempAlpha1 = tempAlpha1 * xclip1.x;
							#endif
							#if !alphaSaturated && !_XUIFONT
								
									tempAlpha1 = saturate(1.871 * tempAlpha1);
							#endif
							#if !XFOG_DISABLED && !_ALPHABLEND_ON && !_ADDITIVE_ON && !_AlphaTest_ON && !_MULTIPLY_ON
								#if !_RIM_LERP_WITH_ALPHA
									color4 = unity_FogColor + -float4(effectBrightColor.x,effectBrightColor.y,effectBrightColor.z,tempAlpha1);

									color1 = fog.xxxx * color4 + float4(effectBrightColor.x,effectBrightColor.y,effectBrightColor.z,tempAlpha1);
								#else
									tempColor2.xyz = effectBrightColor;
									tempColor2.w = tempAlpha1;
									tempColor1 = unity_FogColor + -tempColor2;
									color1 = fog.xxxx * tempColor1 + tempColor2;
								#endif
								tempAlpha1 = color1.w;
								#if _XDISTANCE_FADE
									tempAlpha1 = distanceFade.X * tempAlpha1;
								#endif
								sv_target.w = saturate(_CustomAlpha * tempAlpha1);
							#elif !XFOG_DISABLED && (_ALPHABLEND_ON || _MULTIPLY_ON)
								#if _XDISTANCE_FADE
									tempAlpha1 = distanceFade.X * tempAlpha1;
								#endif
								#if !_XUIFONT
									sv_target.w = saturate(_CustomAlpha * tempAlpha1);
								#endif
								#if !_VERTEX_RGB_OFF&&!_DISSOLUTION&&!_DISSOLUTION_UV2&&!_DISSOLUTION_SCREEN_UV
									color4.xyz = -tempColorx3_1 * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
									color1.xyz = fog.xxx * color4.xyz + effectBrightColor;
								#elif (_DISSOLUTION||_DISSOLUTION_UV2||_DISSOLUTION_SCREEN_UV)
									color4.xyz = -preEffectBrightCol.xyz * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
									color1.xyz = fog.xxx * color4.xyz + effectBrightColor;
								#else
									color4.xyz = -texColorPostBright.xyz * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
									color1.xyz = fog.xxx * color4.xyz + effectBrightColor;
								#endif
							#elif (XFOG_DISABLED && !_ALPHABLEND_ON && !_ADDITIVE_ON && !_AlphaTest_ON && !_MULTIPLY_ON)||(_ADDITIVE_ON && !XFOG_DISABLED)||(XFOG_DISABLED && _ALPHABLEND_ON) ||( XFOG_DISABLED && _ADDITIVE_ON) 
								#if _XDISTANCE_FADE
									tempAlpha1 = distanceFade.X * tempAlpha1;
								#endif
								sv_target.w = saturate(_CustomAlpha * tempAlpha1);
								color1.xyz = effectBrightColor;
							
							#endif
							
							color1.xyz = max(color1.xyz,float3(0,0,0));
							sv_target.xyz = min(color1.xyz,float3(500,500,500));
						
					#elif _MAINTEX_DISABLE
						
							#if !_VERTEX_RGB_OFF
								tempColorx3_1 = i.color.xyz * texColorPostBright.xyz;
							#endif
							
							#if _RIM_MASK
								tempColor2.xyz = tempColorx3_1 * texColorPostBright.xyz;
								tempColorx3_1 = tempColor2.xyz;
							#endif
							#if _RIM_LERP || _RIM_LERP_WITH_ALPHA
								tempColor1.xyz = _RimColor.xyz * _EffectBrightness.xxx + -tempColorx3_1;
								tempColorx3_1 = rimLerpx4_1.xxx * tempColor1.xyz + tempColorx3_1;
							#endif
							#if _DISSOLUTION || _DISSOLUTION_UV2 || _DISSOLUTION_SCREEN_UV
								tempColor1.xyz = _DissolutionColor.xyz * _EffectBrightness.xxx + -tempColorx3_1;
								tempColor1.w = 0;
								tempColor1 = _DissolutionColor.wwww * tempColor1 + float4(tempColorx3_1.x,tempColorx3_1.y,tempColorx3_1.z,0);
								#if (_MASKUV0|| _MASKUV1 || _MASK_SCREEN_UV)&&_FLOWMAP
								
									tempAlpha1 = earlyMaskTex.x * _TintColor.w;
								#else
									tempAlpha1 = _TintColor.w;
								#endif
								tempColor1 = tempColor1 + -float4(tempColorx3_1.x,tempColorx3_1.y,tempColorx3_1.z,tempAlpha1);

								tempColorx3_1.xyz = dissolx4_1.xxx * tempColor1.xyz + tempColorx3_1;
								tempAlpha1 = dissolx4_1.x * tempColor1.w + tempAlpha1;
								tempAlpha1 = saturate(1.871 * tempAlpha1);
							#endif
							#if !_VERTEX_RGB_OFF
								effectBrightColor = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * tempColorx3_1;
							#else
								effectBrightColor = float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) * texColorPostBright.xyz;
							#endif
							#if !_DISSOLUTION && !_DISSOLUTION_UV2 && !_DISSOLUTION_SCREEN_UV
								#if _VERTEX_ALPHA_OFF
									tempAlpha1 = saturate(1.871 * _TintColor.w);
								#elif _MASKUV0 || _MASKUV1 || _MASK_SCREEN_UV
									tempAlpha1 = _TintColor.w * i.color.w;
									#if !_FLOWMAP
										tempAlpha2 = tempAlpha1;
										tempColor1 = tex2D(_MaskTex,i.texcoord.zw);
										tempAlpha1 = tempColor1.x * tempAlpha1;
										tempAlpha1 = -tempAlpha2 * tempColor1.x + _RimColor.w;
										tempAlpha2 = tempColor1.x * tempAlpha2;
										tempAlpha1 = rimLerpx4_1.x * tempAlpha1 + tempAlpha2;
										tempAlpha1 = saturate(1.871 * tempAlpha1);
									#endif
									#if _RIM_LERP_WITH_ALPHA && _FLOWMAP
										tempAlpha1 = -texColorPreBright.w * i.color.w + _RimColor.w;
									#endif
								#else
									tempAlpha1 = _TintColor.w * i.color.w;
									#if _RIM_MASK
										tempAlpha1  =tempAlpha1 * color1.w;

									#endif
									#if _RIM_LERP_WITH_ALPHA
										
										tempAlpha3 = -_TintColor.w * i.color.w + _RimColor.w;
										tempAlpha1 = rimLerpx4_1.x * tempAlpha3 + tempAlpha1;
									#endif
									tempAlpha1 = saturate(1.871 * tempAlpha1);
								#endif
							#endif
							
							
							#if !XFOG_DISABLED && !_ALPHABLEND_ON && !_ADDITIVE_ON && !_AlphaTest_ON && !_MULTIPLY_ON
								
									color4 = unity_FogColor + -float4(effectBrightColor.x,effectBrightColor.y,effectBrightColor.z,tempAlpha1);
									color1 = fog.xxxx * color4 + float4(effectBrightColor.x,effectBrightColor.y,effectBrightColor.z,tempAlpha1);
								
								sv_target.w = saturate(_CustomAlpha * color1.w);
							#elif !XFOG_DISABLED && _ALPHABLEND_ON
								
									sv_target.w = saturate(_CustomAlpha * tempAlpha1);
									color4.xyz = -tempColorx3_1 * float3(_EffectBrightnessR,_EffectBrightnessG,_EffectBrightnessB) + unity_FogColor.xyz;
									color1.xyz = fog.xxx * color4.xyz + effectBrightColor;
							#elif XFOG_DISABLED && !_ALPHABLEND_ON && !_ADDITIVE_ON && !_AlphaTest_ON && !_MULTIPLY_ON
								sv_target.w = saturate(_CustomAlpha * tempAlpha1);
							#elif XFOG_DISABLED && _ALPHABLEND_ON
								sv_target.w = saturate(_CustomAlpha * tempAlpha1);

							#endif
							#if XFOG_DISABLED
								color1.xyz = effectBrightColor;
							#endif
							color1.xyz = max(color1.xyz,float3(0,0,0));
							sv_target.xyz = min(color1.xyz,float3(500,500,500));
						
					#endif
				

				

					
				return sv_target;
			}
			ENDCG
		}
    }
}
