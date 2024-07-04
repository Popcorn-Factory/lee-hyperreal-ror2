// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/AmplifyShaderPack/Terrain/Snow AddPass"
{
	Properties
	{
		[Toggle(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)] _EnableInstancedPerPixelNormal("Enable Instanced Per-Pixel Normal", Float) = 0
		[HideInInspector]_TerrainHolesTexture("_TerrainHolesTexture", 2D) = "white" {}
		[HideInInspector]_Control("Control", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal0", 2D) = "bump" {}
		[HideInInspector]_NormalScale0("NormalScale0", Float) = 1
		[HideInInspector]_Mask0("Mask0", 2D) = "gray" {}
		[HideInInspector]_Metallic0("Metallic0", Range( 0 , 1)) = 0
		[HideInInspector]_Smoothness0("Smoothness 0", Range( 0 , 1)) = 0
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Normal1("Normal1", 2D) = "bump" {}
		[HideInInspector]_NormalScale1("NormalScale1", Float) = 1
		[HideInInspector]_Mask1("Mask1", 2D) = "gray" {}
		[HideInInspector]_Metallic1("Metallic1", Range( 0 , 1)) = 0
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 0
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal2", 2D) = "bump" {}
		[HideInInspector]_NormalScale2("NormalScale2", Float) = 1
		[HideInInspector]_Mask2("Mask2", 2D) = "gray" {}
		[HideInInspector]_Metallic2("Metallic2", Range( 0 , 1)) = 0
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 0
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal3", 2D) = "bump" {}
		[HideInInspector]_NormalScale3("_NormalScale3", Float) = 1
		[HideInInspector]_Mask3("Mask3", 2D) = "gray" {}
		[HideInInspector]_Metallic3("Metallic3", Range( 0 , 1)) = 0
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 0
		[Header(SNOW)][ToggleUI]_SnowEnable("ENABLE", Float) = 0
		[SingleLineTexture]_SnowMapSplat("Splat Mask", 2D) = "white" {}
		_SnowColor("Tint", Color) = (1,1,1,0)
		_SnowBrightness("Brightness", Range( 0 , 1)) = 1
		[Space(5)]_SnowSaturation("Saturation", Range( 0 , 1)) = 0
		[SingleLineTexture]_SnowMapBaseColor("BaseColor", 2D) = "white" {}
		_SnowMainUVs("Main UVs", Vector) = (0.002,0.002,0,0)
		[Normal][SingleLineTexture]_SnowMapNormal("Normal Map", 2D) = "bump" {}
		_SnowNormalStrength("Normal Strength", Float) = 2
		[ToggleUI][Space(10)]_SnowSplatREnable("ENABLE CHANNEL RED", Float) = 0
		_SnowSplatRSplatBias("Splat Bias", Float) = 1
		_SnowSplatRMin("Min", Float) = -0.5
		_SnowSplatRMax("Max", Float) = 1
		_SnowSplatRBlendStrength("Blend Strength", Range( 0 , 5)) = 0
		_SnowSplatRBlendFalloff("Blend Falloff", Range( 0 , 10)) = 0
		_SnowSplatRBlendFactor("Blend Factor", Range( 0 , 10)) = 0
		[ToggleUI][Space(10)]_SnowSplatGEnable("ENABLE CHANNEL GREEN", Float) = 0
		_SnowSplatGSplatBias("Splat Bias", Float) = 1
		_SnowSplatGMin("Min", Float) = -0.5
		_SnowSplatGMax("Max", Float) = 1
		_SnowSplatGBlendStrength("Blend Strength", Range( 0 , 5)) = 0
		_SnowSplatGBlendFalloff("Blend Falloff", Range( 0 , 10)) = 0
		_SnowSplatGBlendFactor("Blend Factor", Range( 0 , 10)) = 0
		[ToggleUI][Space(10)]_SnowSplatBEnable("ENABLE CHANNEL BLUE", Float) = 0
		_SnowSplatBSplatBias("Splat Bias", Float) = 1
		_SnowSplatBMin("Min", Float) = -0.5
		_SnowSplatBMax("Max", Float) = 1
		_SnowSplatBBlendStrength("Blend Strength", Range( 0 , 5)) = 0
		_SnowSplatBBlendFalloff("Blend Falloff", Range( 0 , 10)) = 0
		_SnowSplatBBlendFactor("Blend Factor", Range( 0 , 10)) = 0
		[ToggleUI][Space(10)]_SnowSplatAEnable("ENABLE CHANNEL ALPHA", Float) = 0
		_SnowSplatASplatBias("Splat Bias", Float) = 1
		_SnowSplatAMin("Min", Float) = -0.5
		_SnowSplatAMax("Max", Float) = 1
		_SnowSplatABlendStrength("Blend Strength", Range( 0 , 5)) = 0
		_SnowSplatABlendFalloff("Blend Falloff", Range( 0 , 10)) = 0
		_SnowSplatABlendFactor("Blend Factor", Range( 0 , 10)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-99" "IgnoreProjector" = "True" "TerrainCompatible"="True" "IgnoreProjector"="True" }
		Cull Back
		ZTest LEqual
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.5
		#pragma multi_compile_instancing
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#pragma multi_compile_local __ _NORMALMAP
		#pragma multi_compile_local_fragment __ _ALPHATEST_ON
		#pragma multi_compile_fog
		#pragma editor_sync_compilation
		#pragma target 3.0
		#pragma exclude_renderers gles
		#define TERRAIN_SPLATMAP_COMMON_CGINC_INCLUDED
		#include "TerrainSplatmapCommon.cginc"
		#define TERRAIN_SPLAT_ADDPASS
		#define TERRAIN_STANDARD_SHADER
		#pragma shader_feature_local _MASKMAP
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha vertex:vertexDataFunc  decal:blend finalcolor:SplatmapFinalColor
		struct Input
		{
			float2 vertexToFrag286_g5;
			float2 uv_texcoord;
			float2 vertexToFrag851_g5;
			float3 worldPos;
		};

		#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
			sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
			sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
		#endif//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
			UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
		CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
				float4 _TerrainHeightmapScale;//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
		CBUFFER_END//ASE Terrain Instancing
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
		uniform float4 _Control_ST;
		SamplerState sampler_Control;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal0);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat0);
		uniform float4 _Splat0_ST;
		SamplerState sampler_Normal0;
		uniform half _NormalScale0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal1);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat1);
		uniform float4 _Splat1_ST;
		uniform half _NormalScale1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal2);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat2);
		uniform float4 _Splat2_ST;
		uniform half _NormalScale2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal3);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat3);
		uniform float4 _Splat3_ST;
		uniform half _NormalScale3;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SnowMapSplat);
		uniform float4 _SnowMapSplat_ST;
		SamplerState sampler_SnowMapSplat;
		uniform half _SnowSplatRSplatBias;
		uniform half _SnowSplatGSplatBias;
		uniform half _SnowSplatBSplatBias;
		uniform half _SnowSplatASplatBias;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SnowMapNormal);
		uniform float4 _SnowMainUVs;
		SamplerState sampler_SnowMapNormal;
		uniform half _SnowNormalStrength;
		uniform half _SnowSplatREnable;
		uniform half _SnowSplatGEnable;
		uniform half _SnowSplatBEnable;
		uniform half _SnowSplatAEnable;
		uniform half _SnowEnable;
		SamplerState sampler_Splat0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
		uniform float4 _TerrainHolesTexture_ST;
		SamplerState sampler_TerrainHolesTexture;
		uniform half4 _SnowColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SnowMapBaseColor);
		SamplerState sampler_SnowMapBaseColor;
		uniform half _SnowSaturation;
		uniform half _SnowBrightness;
		uniform half _SnowSplatRBlendFactor;
		uniform half _SnowSplatRBlendFalloff;
		uniform half _SnowSplatRBlendStrength;
		uniform half _SnowSplatRMin;
		uniform half _SnowSplatRMax;
		uniform half _SnowSplatGBlendFactor;
		uniform half _SnowSplatGBlendFalloff;
		uniform half _SnowSplatGBlendStrength;
		uniform half _SnowSplatGMin;
		uniform half _SnowSplatGMax;
		uniform half _SnowSplatBBlendFactor;
		uniform half _SnowSplatBBlendFalloff;
		uniform half _SnowSplatBBlendStrength;
		uniform half _SnowSplatBMin;
		uniform half _SnowSplatBMax;
		uniform half _SnowSplatABlendFactor;
		uniform half _SnowSplatABlendFalloff;
		uniform half _SnowSplatABlendStrength;
		uniform half _SnowSplatAMin;
		uniform half _SnowSplatAMax;
		uniform float _Metallic0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask0);
		SamplerState sampler_Mask0;
		uniform float _Metallic1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask1);
		uniform float _Metallic2;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask2);
		uniform float _Metallic3;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask3);
		uniform float _Smoothness0;
		uniform float _Smoothness1;
		uniform float _Smoothness2;
		uniform float _Smoothness3;


		void SplatmapFinalColor( Input SurfaceIn, SurfaceOutputStandard SurfaceOut, inout fixed4 FinalColor )
		{
			FinalColor *= SurfaceOut.Alpha;
		}


void ApplyMeshModification( inout appdata_full v )
{
	#if defined(UNITY_INSTANCING_ENABLED) && !defined(SHADER_API_D3D11_9X)
		float2 patchVertex = v.vertex.xy;
		float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);
		
		float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
		float4 uvoffset = instanceData.xyxy * uvscale;
		uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
		float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
		
		float hm = UnpackHeightmap(tex2Dlod(_TerrainHeightmapTexture, float4(sampleCoords, 0, 0)));
		v.vertex.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
		v.vertex.y = hm * _TerrainHeightmapScale.y;
		v.vertex.w = 1.0f;
		
		v.texcoord.xy = (patchVertex.xy * uvscale.zw + uvoffset.zw);
		v.texcoord3 = v.texcoord2 = v.texcoord1 = v.texcoord;
		
		#ifdef TERRAIN_INSTANCED_PERPIXEL_NORMAL
			v.normal = float3(0, 1, 0);
			//data.tc.zw = sampleCoords;
		#else
			float3 nor = tex2Dlod(_TerrainNormalmapTexture, float4(sampleCoords, 0, 0)).xyz;
			v.normal = 2.0f * nor - 1.0f;
		#endif
	#endif
}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			ApplyMeshModification(v);;
			float localCalculateTangentsStandard706_g5 = ( 0.0 );
			{
			v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
			v.tangent.w = -1;
			}
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_707_0_g5 = ( localCalculateTangentsStandard706_g5 + ase_vertexNormal );
			v.normal = temp_output_707_0_g5;
			float4 appendResult704_g5 = (float4(cross( ase_vertexNormal , float3(0,0,1) ) , -1.0));
			v.tangent = appendResult704_g5;
			float2 break291_g5 = _Control_ST.zw;
			float2 appendResult293_g5 = (float2(( break291_g5.x + 0.001 ) , ( break291_g5.y + 0.0001 )));
			o.vertexToFrag286_g5 = ( ( v.texcoord.xy * _Control_ST.xy ) + appendResult293_g5 );
			o.vertexToFrag851_g5 = ( ( v.texcoord.xy * (_SnowMainUVs).xy ) + (_SnowMainUVs).zw );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode283_g5 = SAMPLE_TEXTURE2D( _Control, sampler_Control, i.vertexToFrag286_g5 );
			float dotResult278_g5 = dot( tex2DNode283_g5 , half4(1,1,1,1) );
			float localSplatClip276_g5 = ( dotResult278_g5 );
			float SplatWeight276_g5 = dotResult278_g5;
			{
			#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
				clip(SplatWeight276_g5 == 0.0f ? -1 : 1);
			#endif
			}
			float4 Control26_g5 = ( tex2DNode283_g5 / ( localSplatClip276_g5 + 0.001 ) );
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float4 Normal0341_g5 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, uv_Splat0 );
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float4 Normal1378_g5 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, uv_Splat1 );
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float4 Normal2356_g5 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, uv_Splat2 );
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 Normal3398_g5 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, uv_Splat3 );
			float4 weightedBlendVar473_g5 = Control26_g5;
			float3 weightedBlend473_g5 = ( weightedBlendVar473_g5.x*UnpackScaleNormal( Normal0341_g5, _NormalScale0 ) + weightedBlendVar473_g5.y*UnpackScaleNormal( Normal1378_g5, _NormalScale1 ) + weightedBlendVar473_g5.z*UnpackScaleNormal( Normal2356_g5, _NormalScale2 ) + weightedBlendVar473_g5.w*UnpackScaleNormal( Normal3398_g5, _NormalScale3 ) );
			float3 break513_g5 = weightedBlend473_g5;
			float3 appendResult514_g5 = (float3(break513_g5.x , break513_g5.y , ( break513_g5.z + 0.001 )));
			#ifdef _TERRAIN_INSTANCED_PERPIXEL_NORMAL
				float3 staticSwitch503_g5 = appendResult514_g5;
			#else
				float3 staticSwitch503_g5 = appendResult514_g5;
			#endif
			float2 uv_SnowMapSplat = i.uv_texcoord * _SnowMapSplat_ST.xy + _SnowMapSplat_ST.zw;
			float4 tex2DNode717_g5 = SAMPLE_TEXTURE2D( _SnowMapSplat, sampler_SnowMapSplat, uv_SnowMapSplat );
			float4 appendResult723_g5 = (float4(( tex2DNode717_g5.r * _SnowSplatRSplatBias ) , ( tex2DNode717_g5.g * _SnowSplatGSplatBias ) , ( tex2DNode717_g5.b * _SnowSplatBSplatBias ) , ( tex2DNode717_g5.a * _SnowSplatASplatBias )));
			float4 SnowSplatRGBA728_g5 = appendResult723_g5;
			float2 temp_output_850_0_g5 = ( i.vertexToFrag851_g5 * 100.0 );
			float3 SnowNormal858_g5 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _SnowMapNormal, sampler_SnowMapNormal, temp_output_850_0_g5 ), _SnowNormalStrength );
			float SnowEnableRChannel925_g5 = _SnowSplatREnable;
			float3 lerpResult976_g5 = lerp( staticSwitch503_g5 , SnowNormal858_g5 , SnowEnableRChannel925_g5);
			float SnowEnableGChannel896_g5 = _SnowSplatGEnable;
			float3 lerpResult978_g5 = lerp( staticSwitch503_g5 , SnowNormal858_g5 , SnowEnableGChannel896_g5);
			float SnowEnableBChannel897_g5 = _SnowSplatBEnable;
			float3 lerpResult979_g5 = lerp( staticSwitch503_g5 , SnowNormal858_g5 , SnowEnableBChannel897_g5);
			float SnowEnableAChannel899_g5 = _SnowSplatAEnable;
			float3 lerpResult982_g5 = lerp( staticSwitch503_g5 , SnowNormal858_g5 , SnowEnableAChannel899_g5);
			float4 weightedBlendVar975_g5 = SnowSplatRGBA728_g5;
			float3 weightedBlend975_g5 = ( weightedBlendVar975_g5.x*lerpResult976_g5 + weightedBlendVar975_g5.y*lerpResult978_g5 + weightedBlendVar975_g5.z*lerpResult979_g5 + weightedBlendVar975_g5.w*lerpResult982_g5 );
			float SnowEnable932_g5 = _SnowEnable;
			float3 lerpResult1005_g5 = lerp( staticSwitch503_g5 , weightedBlend975_g5 , SnowEnable932_g5);
			o.Normal = lerpResult1005_g5;
			float4 tex2DNode414_g5 = SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, uv_Splat0 );
			float3 Splat0342_g5 = (tex2DNode414_g5).rgb;
			float4 tex2DNode420_g5 = SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, uv_Splat1 );
			float3 Splat1379_g5 = (tex2DNode420_g5).rgb;
			float4 tex2DNode417_g5 = SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, uv_Splat2 );
			float3 Splat2357_g5 = (tex2DNode417_g5).rgb;
			float4 tex2DNode423_g5 = SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, uv_Splat3 );
			float3 Splat3390_g5 = (tex2DNode423_g5).rgb;
			float4 weightedBlendVar9_g5 = Control26_g5;
			float3 weightedBlend9_g5 = ( weightedBlendVar9_g5.x*Splat0342_g5 + weightedBlendVar9_g5.y*Splat1379_g5 + weightedBlendVar9_g5.z*Splat2357_g5 + weightedBlendVar9_g5.w*Splat3390_g5 );
			float3 localClipHoles453_g5 = ( weightedBlend9_g5 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float Hole453_g5 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole453_g5 == 0.0f ? -1 : 1);
			#endif
			}
			float3 temp_output_12_0_g6 = (SAMPLE_TEXTURE2D( _SnowMapBaseColor, sampler_SnowMapBaseColor, temp_output_850_0_g5 )).rgb;
			float dotResult28_g6 = dot( float3(0.2126729,0.7151522,0.072175) , temp_output_12_0_g6 );
			float3 temp_cast_6 = (dotResult28_g6).xxx;
			float3 lerpResult31_g6 = lerp( temp_cast_6 , temp_output_12_0_g6 , ( 1.0 - _SnowSaturation ));
			float3 SnowBaseColor842_g5 = ( (_SnowColor).rgb * lerpResult31_g6 * _SnowBrightness );
			float4 break727_g5 = appendResult723_g5;
			float SnowSplatR732_g5 = break727_g5.x;
			float saferPower802_g5 = abs( max( ( SnowSplatR732_g5 * ( 1.0 + _SnowSplatRBlendFactor ) ) , 0.0 ) );
			float lerpResult804_g5 = lerp( 0.0 , pow( saferPower802_g5 , ( 1.0 - _SnowSplatRBlendFalloff ) ) , (-1.0 + (_SnowSplatRBlendStrength - 0.0) * (0.0 - -1.0) / (1.0 - 0.0)));
			float3 ase_worldPos = i.worldPos;
			float3 WorldPosition812_g5 = ase_worldPos;
			float smoothstepResult823_g5 = smoothstep( _SnowSplatRMin , _SnowSplatRMax , WorldPosition812_g5.y);
			float lerpResult817_g5 = lerp( 0.0 , saturate( lerpResult804_g5 ) , smoothstepResult823_g5);
			float SnowSplatRMask818_g5 = lerpResult817_g5;
			float3 lerpResult912_g5 = lerp( localClipHoles453_g5 , SnowBaseColor842_g5 , SnowSplatRMask818_g5);
			float3 lerpResult894_g5 = lerp( localClipHoles453_g5 , lerpResult912_g5 , _SnowSplatREnable);
			float SnowSplatG733_g5 = break727_g5.y;
			float saferPower782_g5 = abs( max( ( SnowSplatG733_g5 * ( 1.0 + _SnowSplatGBlendFactor ) ) , 0.0 ) );
			float lerpResult783_g5 = lerp( 0.0 , pow( saferPower782_g5 , ( 1.0 - _SnowSplatGBlendFalloff ) ) , (-1.0 + (_SnowSplatGBlendStrength - 0.0) * (0.0 - -1.0) / (1.0 - 0.0)));
			float smoothstepResult832_g5 = smoothstep( _SnowSplatGMin , _SnowSplatGMax , WorldPosition812_g5.y);
			float lerpResult794_g5 = lerp( 0.0 , saturate( lerpResult783_g5 ) , smoothstepResult832_g5);
			float SnowSplatGMask800_g5 = lerpResult794_g5;
			float3 lerpResult910_g5 = lerp( localClipHoles453_g5 , SnowBaseColor842_g5 , SnowSplatGMask800_g5);
			float3 lerpResult892_g5 = lerp( localClipHoles453_g5 , lerpResult910_g5 , _SnowSplatGEnable);
			float SnowSplatB734_g5 = break727_g5.z;
			float saferPower759_g5 = abs( max( ( SnowSplatB734_g5 * ( 1.0 + _SnowSplatBBlendFactor ) ) , 0.0 ) );
			float lerpResult760_g5 = lerp( 0.0 , pow( saferPower759_g5 , ( 1.0 - _SnowSplatBBlendFalloff ) ) , (-1.0 + (_SnowSplatBBlendStrength - 0.0) * (0.0 - -1.0) / (1.0 - 0.0)));
			float smoothstepResult834_g5 = smoothstep( _SnowSplatBMin , _SnowSplatBMax , WorldPosition812_g5.y);
			float lerpResult793_g5 = lerp( 0.0 , saturate( lerpResult760_g5 ) , smoothstepResult834_g5);
			float SnowSplatBMask799_g5 = lerpResult793_g5;
			float3 lerpResult917_g5 = lerp( localClipHoles453_g5 , SnowBaseColor842_g5 , SnowSplatBMask799_g5);
			float3 lerpResult918_g5 = lerp( localClipHoles453_g5 , lerpResult917_g5 , _SnowSplatBEnable);
			float SnowSplatA735_g5 = break727_g5.w;
			float saferPower729_g5 = abs( max( ( SnowSplatA735_g5 * ( 1.0 + _SnowSplatABlendFactor ) ) , 0.0 ) );
			float lerpResult747_g5 = lerp( 0.0 , pow( saferPower729_g5 , ( 1.0 - _SnowSplatABlendFalloff ) ) , (-1.0 + (_SnowSplatABlendStrength - 0.0) * (0.0 - -1.0) / (1.0 - 0.0)));
			float smoothstepResult836_g5 = smoothstep( _SnowSplatAMin , _SnowSplatAMax , WorldPosition812_g5.y);
			float lerpResult776_g5 = lerp( 0.0 , saturate( lerpResult747_g5 ) , smoothstepResult836_g5);
			float SnowSplatAMask777_g5 = lerpResult776_g5;
			float3 lerpResult916_g5 = lerp( localClipHoles453_g5 , SnowBaseColor842_g5 , SnowSplatAMask777_g5);
			float3 lerpResult898_g5 = lerp( localClipHoles453_g5 , lerpResult916_g5 , _SnowSplatAEnable);
			float4 weightedBlendVar900_g5 = SnowSplatRGBA728_g5;
			float3 weightedBlend900_g5 = ( weightedBlendVar900_g5.x*lerpResult894_g5 + weightedBlendVar900_g5.y*lerpResult892_g5 + weightedBlendVar900_g5.z*lerpResult918_g5 + weightedBlendVar900_g5.w*lerpResult898_g5 );
			float3 lerpResult924_g5 = lerp( localClipHoles453_g5 , weightedBlend900_g5 , _SnowEnable);
			o.Albedo = lerpResult924_g5;
			float4 tex2DNode416_g5 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, uv_Splat0 );
			float Mask0R334_g5 = tex2DNode416_g5.r;
			float4 tex2DNode422_g5 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, uv_Splat1 );
			float Mask1R370_g5 = tex2DNode422_g5.r;
			float4 tex2DNode419_g5 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, uv_Splat2 );
			float Mask2R359_g5 = tex2DNode419_g5.r;
			float4 tex2DNode425_g5 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, uv_Splat3 );
			float Mask3R388_g5 = tex2DNode425_g5.r;
			float4 weightedBlendVar536_g5 = Control26_g5;
			float weightedBlend536_g5 = ( weightedBlendVar536_g5.x*max( _Metallic0 , Mask0R334_g5 ) + weightedBlendVar536_g5.y*max( _Metallic1 , Mask1R370_g5 ) + weightedBlendVar536_g5.z*max( _Metallic2 , Mask2R359_g5 ) + weightedBlendVar536_g5.w*max( _Metallic3 , Mask3R388_g5 ) );
			o.Metallic = weightedBlend536_g5;
			float4 appendResult1168_g5 = (float4(_Smoothness0 , _Smoothness1 , _Smoothness2 , _Smoothness3));
			float Splat0A435_g5 = tex2DNode414_g5.a;
			float Mask1A369_g5 = tex2DNode422_g5.a;
			float Mask2A360_g5 = tex2DNode419_g5.a;
			float Mask3A391_g5 = tex2DNode425_g5.a;
			float4 appendResult1169_g5 = (float4(Splat0A435_g5 , Mask1A369_g5 , Mask2A360_g5 , Mask3A391_g5));
			float dotResult1166_g5 = dot( ( appendResult1168_g5 * appendResult1169_g5 ) , Control26_g5 );
			o.Smoothness = dotResult1166_g5;
			float Mask0G409_g5 = tex2DNode416_g5.g;
			float Mask1G371_g5 = tex2DNode422_g5.g;
			float Mask2G358_g5 = tex2DNode419_g5.g;
			float Mask3G389_g5 = tex2DNode425_g5.g;
			float4 weightedBlendVar602_g5 = Control26_g5;
			float weightedBlend602_g5 = ( weightedBlendVar602_g5.x*saturate( ( ( ( Mask0G409_g5 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) + weightedBlendVar602_g5.y*saturate( ( ( ( Mask1G371_g5 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) + weightedBlendVar602_g5.z*saturate( ( ( ( Mask2G358_g5 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) + weightedBlendVar602_g5.w*saturate( ( ( ( Mask3G389_g5 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) );
			o.Occlusion = saturate( weightedBlend602_g5 );
			o.Alpha = dotResult278_g5;
		}

		ENDCG
		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
		UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
	}
	Fallback "Hidden/TerrainEngine/Splatmap/Diffuse-AddPass"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CustomExpressionNode;46;645.7527,-133.7308;Float;False;FinalColor *= SurfaceOut.Alpha@;7;Create;3;True;SurfaceIn;OBJECT;0;In;Input;Float;False;True;SurfaceOut;OBJECT;0;In;SurfaceOutputStandard;Float;False;True;FinalColor;OBJECT;0;InOut;fixed4;Float;False;SplatmapFinalColor;False;True;0;;False;4;0;FLOAT;0;False;1;OBJECT;0;False;2;OBJECT;0;False;3;OBJECT;0;False;2;FLOAT;0;OBJECT;4
Node;AmplifyShaderEditor.FunctionNode;74;333.8652,42.77539;Inherit;False;Terrain 4 Layer;1;;5;a8a57459582f78d4ca5db58f601fb616;4,504,1,102,1,669,1,668,1;0;8;FLOAT3;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;282;FLOAT3;709;FLOAT4;701
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;644.0565,42.11808;Float;False;True;-1;3;ASEMaterialInspector;0;0;Standard;Hidden/AmplifyShaderPack/Terrain/Snow AddPass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;-99;True;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Hidden/TerrainEngine/Splatmap/Diffuse-AddPass;0;-1;-1;-1;2;TerrainCompatible=True;IgnoreProjector=True;False;0;0;False;;-1;0;False;;12;Pragma;instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd;False;;Custom;False;0;0;;Pragma;multi_compile_local __ _NORMALMAP;False;;Custom;False;0;0;;Pragma;multi_compile_local_fragment __ _ALPHATEST_ON;False;;Custom;False;0;0;;Pragma;multi_compile_fog;False;;Custom;False;0;0;;Pragma;editor_sync_compilation;False;;Custom;False;0;0;;Pragma;target 3.0;False;;Custom;False;0;0;;Pragma;exclude_renderers gles;False;;Custom;False;0;0;;Define;TERRAIN_SPLATMAP_COMMON_CGINC_INCLUDED;False;;Custom;False;0;0;;Include;TerrainSplatmapCommon.cginc;False;;Custom;False;0;0;;Define;TERRAIN_SPLAT_ADDPASS;False;;Custom;False;0;0;;Define;TERRAIN_STANDARD_SHADER;False;;Custom;False;0;0;;Pragma;shader_feature_local _MASKMAP;False;;Custom;False;0;0;;2;decal:blend;finalcolor:SplatmapFinalColor;0;True;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;74;0
WireConnection;0;1;74;14
WireConnection;0;3;74;56
WireConnection;0;4;74;45
WireConnection;0;5;74;200
WireConnection;0;9;74;282
WireConnection;0;12;74;709
WireConnection;0;16;74;701
ASEEND*/
//CHKSM=82D93FE52D05AC374C26F2548A75E2BB27CA8783