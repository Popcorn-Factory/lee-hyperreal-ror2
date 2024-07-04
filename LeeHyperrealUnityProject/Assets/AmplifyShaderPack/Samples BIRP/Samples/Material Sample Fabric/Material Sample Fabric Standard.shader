// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Material Sample Fabric Standard"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		_BaseColor1("Base Color Fornt Face", Color) = (0.7294118,0.7294118,0.7294118,0)
		_BaseBrightnessFrontFace("Brightness Front Face", Range( 0 , 2)) = 1
		_BaseColorBackFace("Base Color Back Face", Color) = (0.7294118,0.7294118,0.7294118,0)
		_BaseBrightnessBackFace("Brightness Back Face", Range( 0 , 2)) = 1
		[SingleLineTexture]_MainTex("BaseColor Map", 2D) = "white" {}
		[ToggleUI]_BaseAffectUVchannel0("Affect UV channel 0", Float) = 1
		[ToggleUI]_BaseAffectUVchannel1("Affect UV channel 1", Float) = 0
		[ToggleUI]_BaseAffectUVchannel2("Affect UV channel 2", Float) = 0
		[ToggleUI]_BaseAffectUVchannel3("Affect UV channel 3", Float) = 0
		_BaseMainUV("Base Main UV", Vector) = (1,1,0,0)
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Range( 0 , 2)) = 1
		[SingleLineTexture]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		_OcclusionStrengthAO("Occlusion Strength", Range( 0 , 1)) = 0
		[SingleLineTexture]_SmoothnessMap("Smoothness Map", 2D) = "white" {}
		_SmoothnessStrength("Smoothness Strength", Range( 0 , 1)) = 0
		[Header(SPECULAR)][SingleLineTexture]_SpecularMap("Specular Map", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_SpecularStrength("Specular Strength", Range( 0 , 1)) = 0.04
		_SpecularColorWeight("Specular Color Weight", Float) = 1
		_SpecularColorIOR("Specular Color IOR", Float) = 0
		[Header(THREAD MASK)][ToggleUI][Space(15)]_ThreadMaskEnable("Enable Thread Map", Float) = 0
		[Normal][SingleLineTexture]_ThreadNormalMap("Thread Normal Map", 2D) = "bump" {}
		_ThreadNormalStrength("Thread Normal Strength", Range( 0 , 2)) = 0.5
		[ToggleUI]_ThreadMaskUVAffectchannel0("Affect UV channel 0", Float) = 1
		[ToggleUI]_ThreadMaskUVAffectchannel1("Affect UV channel 1", Float) = 0
		[ToggleUI]_ThreadMaskUVAffectchannel2("Affect UV channel 2", Float) = 0
		[ToggleUI]_ThreadMaskUVAffectchannel3("Affect UV channel 3", Float) = 0
		_ThreadMaskUV("Thread Mask UV", Vector) = (1,1,0,0)
		[SingleLineTexture]_ThreadMaskMap("Thread Mask Map", 2D) = "white" {}
		_ThreadMaskOcclusionStrength("Thread Occlusion Strength", Range( 0 , 1)) = 0
		_ThreadMaskSmoothnessStrength("Thread Smoothness Strength", Range( 0 , 1)) = 0
		[Header(FUZZ MASK)][ToggleUI][Space(15)]_FuzzMaskEnable("Enable Fuzz Mask", Float) = 0
		[HDR][Space(10)]_FuzzMaskColor("Fuzz Mask Color", Color) = (0.7294118,0.7294118,0.7294118,0)
		[SingleLineTexture]_FuzzMaskMap("Fuzz Mask Map", 2D) = "white" {}
		_FuzzMaskUV("Fuzz Mask UV", Vector) = (4,4,0,0)
		_FuzzMaskStrength("Fuzz Mask Strength", Range( 0 , 1)) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float2 vertexToFrag422_g25;
			float2 vertexToFrag432_g25;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 vertexToFrag427_g25;
		};

		uniform int _Cull;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
		uniform half _BaseAffectUVchannel0;
		uniform half _BaseAffectUVchannel1;
		uniform half _BaseAffectUVchannel2;
		uniform half _BaseAffectUVchannel3;
		uniform half4 _BaseMainUV;
		SamplerState sampler_BumpMap;
		uniform half _NormalStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ThreadNormalMap);
		uniform half _ThreadMaskUVAffectchannel0;
		uniform half _ThreadMaskUVAffectchannel1;
		uniform half _ThreadMaskUVAffectchannel2;
		uniform half _ThreadMaskUVAffectchannel3;
		uniform half4 _ThreadMaskUV;
		uniform half _ThreadNormalStrength;
		uniform half _ThreadMaskEnable;
		uniform half4 _BaseColor1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
		SamplerState sampler_MainTex;
		uniform half _BaseBrightnessFrontFace;
		uniform half4 _BaseColorBackFace;
		uniform half _BaseBrightnessBackFace;
		uniform half4 _FuzzMaskColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_FuzzMaskMap);
		uniform half4 _FuzzMaskUV;
		SamplerState sampler_FuzzMaskMap;
		uniform half _FuzzMaskStrength;
		uniform half _FuzzMaskEnable;
		uniform float4 _SpecularColor;
		uniform float _SpecularColorWeight;
		uniform float _SpecularColorIOR;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecularMap);
		SamplerState sampler_SpecularMap;
		uniform half _SpecularStrength;
		uniform half _OcclusionStrengthAO;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_OcclusionMap);
		SamplerState sampler_OcclusionMap;
		uniform half _ThreadMaskOcclusionStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ThreadMaskMap);
		SamplerState sampler_ThreadMaskMap;
		uniform half _SmoothnessStrength;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SmoothnessMap);
		SamplerState sampler_SmoothnessMap;
		uniform half _ThreadMaskSmoothnessStrength;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.vertexToFrag422_g25 = ( ( ( ( ( v.texcoord.xy * _BaseAffectUVchannel0 ) + ( v.texcoord1.xy * _BaseAffectUVchannel1 ) ) + ( ( v.texcoord2.xy * _BaseAffectUVchannel2 ) + ( v.texcoord3.xy * _BaseAffectUVchannel3 ) ) ) * (_BaseMainUV).xy ) + (_BaseMainUV).zw );
			float2 temp_output_412_0_g25 = ( ( ( v.texcoord.xy * _ThreadMaskUVAffectchannel0 ) + ( v.texcoord1.xy * _ThreadMaskUVAffectchannel1 ) ) + ( ( v.texcoord2.xy * _ThreadMaskUVAffectchannel2 ) + ( v.texcoord3.xy * _ThreadMaskUVAffectchannel3 ) ) );
			o.vertexToFrag432_g25 = ( ( temp_output_412_0_g25 * (_ThreadMaskUV).xy ) + (_ThreadMaskUV).zw );
			o.vertexToFrag427_g25 = ( ( temp_output_412_0_g25 * (_FuzzMaskUV).xy ) + (_FuzzMaskUV).zw );
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 UVBase420_g25 = i.vertexToFrag422_g25;
			float2 UVThread440_g25 = i.vertexToFrag432_g25;
			float layeredBlendVar482_g25 = 0.5;
			float3 layeredBlend482_g25 = ( lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, UVBase420_g25 ), _NormalStrength ),UnpackScaleNormal( SAMPLE_TEXTURE2D( _ThreadNormalMap, sampler_BumpMap, UVThread440_g25 ), _ThreadNormalStrength ) , layeredBlendVar482_g25 ) );
			float3 break481_g25 = layeredBlend482_g25;
			float3 appendResult479_g25 = (float3(break481_g25.x , break481_g25.y , ( break481_g25.z + 0.001 )));
			float3 lerpResult485_g25 = lerp( UnpackScaleNormal( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, UVBase420_g25 ), _NormalStrength ) , appendResult479_g25 , _ThreadMaskEnable);
			o.Normal = lerpResult485_g25;
			float4 tex2DNode21_g25 = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, UVBase420_g25 );
			float3 temp_output_73_0_g25 = (tex2DNode21_g25).rgb;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult460_g25 = dot( ase_normWorldNormal , ase_worldViewDir );
			float TwoSidedSign443_g25 = (1.0 + (sign( dotResult460_g25 ) - -1.0) * (0.0 - 1.0) / (1.0 - -1.0));
			float3 lerpResult505_g25 = lerp( ( (_BaseColor1).rgb * temp_output_73_0_g25 * _BaseBrightnessFrontFace ) , ( (_BaseColorBackFace).rgb * temp_output_73_0_g25 * _BaseBrightnessBackFace ) , TwoSidedSign443_g25);
			float3 temp_cast_3 = (0.0).xxx;
			float2 UVFuzz441_g25 = i.vertexToFrag427_g25;
			float3 lerpResult382_g25 = lerp( temp_cast_3 , ( (_FuzzMaskColor).rgb * SAMPLE_TEXTURE2D( _FuzzMaskMap, sampler_FuzzMaskMap, UVFuzz441_g25 ).r ) , _FuzzMaskStrength);
			float3 lerpResult388_g25 = lerp( lerpResult505_g25 , saturate( ( lerpResult505_g25 + lerpResult382_g25 ) ) , _FuzzMaskEnable);
			o.Albedo = lerpResult388_g25;
			float3 BaseColor565_g25 = lerpResult388_g25;
			float3 temp_output_202_0_g25 = (_SpecularColor).rgb;
			float temp_output_265_0_g25 = ( ( 1.0 - _SpecularColorIOR ) / ( _SpecularColorIOR + 1.0 ) );
			float3 temp_output_176_0_g25 = ( ( 1.0 - _OcclusionStrengthAO ) * (SAMPLE_TEXTURE2D( _OcclusionMap, sampler_OcclusionMap, UVBase420_g25 )).rgb );
			float3 temp_cast_4 = (( 1.0 - _ThreadMaskOcclusionStrength )).xxx;
			float4 tex2DNode493_g25 = SAMPLE_TEXTURE2D( _ThreadMaskMap, sampler_ThreadMaskMap, UVBase420_g25 );
			float MASK_R_Thread492_g25 = tex2DNode493_g25.r;
			float3 lerpResult561_g25 = lerp( temp_output_176_0_g25 , temp_cast_4 , MASK_R_Thread492_g25);
			float EnableThreadMap534_g25 = _ThreadMaskEnable;
			float3 lerpResult542_g25 = lerp( temp_output_176_0_g25 , ( temp_output_176_0_g25 + lerpResult561_g25 ) , EnableThreadMap534_g25);
			float3 temp_output_144_0_g25 = saturate( lerpResult542_g25 );
			float3 Occlusion571_g25 = temp_output_144_0_g25;
			o.Specular = ( BaseColor565_g25 * ( ( ( temp_output_202_0_g25 * _SpecularColorWeight ) * ( temp_output_265_0_g25 * temp_output_265_0_g25 ) ) * (SAMPLE_TEXTURE2D( _SpecularMap, sampler_SpecularMap, UVBase420_g25 )).rgb * _SpecularStrength ) * Occlusion571_g25 );
			float3 temp_output_175_0_g25 = ( _SmoothnessStrength * (SAMPLE_TEXTURE2D( _SmoothnessMap, sampler_SmoothnessMap, UVBase420_g25 )).rgb );
			float3 temp_cast_5 = (_ThreadMaskSmoothnessStrength).xxx;
			float MASK_G_Thread491_g25 = tex2DNode493_g25.g;
			float3 lerpResult560_g25 = lerp( temp_output_175_0_g25 , temp_cast_5 , MASK_G_Thread491_g25);
			float3 lerpResult526_g25 = lerp( temp_output_175_0_g25 , ( temp_output_175_0_g25 + lerpResult560_g25 ) , EnableThreadMap534_g25);
			o.Smoothness = saturate( lerpResult526_g25 ).x;
			o.Occlusion = temp_output_144_0_g25.x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.IntNode;14;133.6357,15.30719;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;34;-266.323,92.28116;Inherit;False;Material Sample Fabirc;1;;25;17ec3236ec20390488bb6a4bcf57c048;5,263,1,486,1,527,1,543,1,389,1;0;8;FLOAT3;1;FLOAT3;6;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;129.9,91.3;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Material Sample Fabric Standard;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;True;True;True;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;34;1
WireConnection;0;1;34;6
WireConnection;0;3;34;5
WireConnection;0;4;34;2
WireConnection;0;5;34;4
ASEEND*/
//CHKSM=CDCF0DE6A7909B0559C9CFCDB0C4DD30C56F35E1