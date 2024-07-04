// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Terrain/Simple"
{
	Properties
	{
		[Header(FOG)][ToggleUI]_EnableFog("Enable Fog", Float) = 0
		_FogFill("Fog Fill", Range( 0 , 1)) = 0
		_FogHeight("Fog Height", Range( 0 , 1)) = 0.1
		_FogSmoothness("Fog Smoothness", Range( 0.01 , 1)) = 0.75
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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-100" "TerrainCompatible"="True" }
		Cull Back
		ZTest LEqual
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.5
		#pragma multi_compile_instancing
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#pragma multi_compile_local __ _NORMALMAP
		#pragma shader_feature_local _MASKMAP
		#pragma multi_compile_local_fragment __ _ALPHATEST_ON
		#pragma multi_compile_fog
		#pragma editor_sync_compilation
		#pragma target 3.0
		#pragma exclude_renderers gles
		#define TERRAIN_SPLATMAP_COMMON_CGINC_INCLUDED
		#include "UnityPBSLighting.cginc"
		#include "TerrainSplatmapCommon.cginc"
		#define TERRAIN_STANDARD_SHADER
		#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha vertex:vertexDataFunc  finalcolor:SplatmapFinalColor
		struct Input
		{
			float2 vertexToFrag286_g13;
			float2 uv_texcoord;
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
		uniform half _EnableFog;
		SamplerState sampler_Splat0;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
		uniform float4 _TerrainHolesTexture_ST;
		SamplerState sampler_TerrainHolesTexture;
		uniform half _FogHeight;
		uniform half _FogSmoothness;
		uniform half _FogFill;
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
			float localCalculateTangentsStandard706_g13 = ( 0.0 );
			{
			v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
			v.tangent.w = -1;
			}
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_707_0_g13 = ( localCalculateTangentsStandard706_g13 + ase_vertexNormal );
			v.normal = temp_output_707_0_g13;
			float4 appendResult704_g13 = (float4(cross( ase_vertexNormal , float3(0,0,1) ) , -1.0));
			v.tangent = appendResult704_g13;
			float2 break291_g13 = _Control_ST.zw;
			float2 appendResult293_g13 = (float2(( break291_g13.x + 0.001 ) , ( break291_g13.y + 0.0001 )));
			o.vertexToFrag286_g13 = ( ( v.texcoord.xy * _Control_ST.xy ) + appendResult293_g13 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode283_g13 = SAMPLE_TEXTURE2D( _Control, sampler_Control, i.vertexToFrag286_g13 );
			float dotResult278_g13 = dot( tex2DNode283_g13 , half4(1,1,1,1) );
			float localSplatClip276_g13 = ( dotResult278_g13 );
			float SplatWeight276_g13 = dotResult278_g13;
			{
			#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
				clip(SplatWeight276_g13 == 0.0f ? -1 : 1);
			#endif
			}
			float4 Control26_g13 = ( tex2DNode283_g13 / ( localSplatClip276_g13 + 0.001 ) );
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float4 Normal0341_g13 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, uv_Splat0 );
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float4 Normal1378_g13 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, uv_Splat1 );
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float4 Normal2356_g13 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, uv_Splat2 );
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 Normal3398_g13 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, uv_Splat3 );
			float4 weightedBlendVar473_g13 = Control26_g13;
			float3 weightedBlend473_g13 = ( weightedBlendVar473_g13.x*UnpackScaleNormal( Normal0341_g13, _NormalScale0 ) + weightedBlendVar473_g13.y*UnpackScaleNormal( Normal1378_g13, _NormalScale1 ) + weightedBlendVar473_g13.z*UnpackScaleNormal( Normal2356_g13, _NormalScale2 ) + weightedBlendVar473_g13.w*UnpackScaleNormal( Normal3398_g13, _NormalScale3 ) );
			float3 break513_g13 = weightedBlend473_g13;
			float3 appendResult514_g13 = (float3(break513_g13.x , break513_g13.y , ( break513_g13.z + 0.001 )));
			#ifdef _TERRAIN_INSTANCED_PERPIXEL_NORMAL
				float3 staticSwitch503_g13 = appendResult514_g13;
			#else
				float3 staticSwitch503_g13 = appendResult514_g13;
			#endif
			float3 NormalOut80 = staticSwitch503_g13;
			float3 temp_output_76_0 = (unity_FogColor).rgb;
			float3 lerpResult78 = lerp( NormalOut80 , ( NormalOut80 * temp_output_76_0 ) , NormalOut80);
			float3 lerpResult75 = lerp( NormalOut80 , lerpResult78 , _EnableFog);
			o.Normal = lerpResult75;
			float4 tex2DNode414_g13 = SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, uv_Splat0 );
			float3 Splat0342_g13 = (tex2DNode414_g13).rgb;
			float4 tex2DNode420_g13 = SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, uv_Splat1 );
			float3 Splat1379_g13 = (tex2DNode420_g13).rgb;
			float4 tex2DNode417_g13 = SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, uv_Splat2 );
			float3 Splat2357_g13 = (tex2DNode417_g13).rgb;
			float4 tex2DNode423_g13 = SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, uv_Splat3 );
			float3 Splat3390_g13 = (tex2DNode423_g13).rgb;
			float4 weightedBlendVar9_g13 = Control26_g13;
			float3 weightedBlend9_g13 = ( weightedBlendVar9_g13.x*Splat0342_g13 + weightedBlendVar9_g13.y*Splat1379_g13 + weightedBlendVar9_g13.z*Splat2357_g13 + weightedBlendVar9_g13.w*Splat3390_g13 );
			float3 localClipHoles453_g13 = ( weightedBlend9_g13 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float Hole453_g13 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole453_g13 == 0.0f ? -1 : 1);
			#endif
			}
			float3 BaseColorOut79 = localClipHoles453_g13;
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult66 = normalize( ase_worldPos );
			float saferPower59 = abs( (0.0 + (abs( normalizeResult66.y ) - 0.0) * (1.0 - 0.0) / (_FogHeight - 0.0)) );
			float lerpResult68 = lerp( saturate( pow( saferPower59 , ( 1.0 - _FogSmoothness ) ) ) , 0.0 , _FogFill);
			float3 lerpResult70 = lerp( temp_output_76_0 , BaseColorOut79 , lerpResult68);
			float3 lerpResult58 = lerp( BaseColorOut79 , lerpResult70 , _EnableFog);
			o.Albedo = lerpResult58;
			float4 tex2DNode416_g13 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, uv_Splat0 );
			float Mask0R334_g13 = tex2DNode416_g13.r;
			float4 tex2DNode422_g13 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, uv_Splat1 );
			float Mask1R370_g13 = tex2DNode422_g13.r;
			float4 tex2DNode419_g13 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, uv_Splat2 );
			float Mask2R359_g13 = tex2DNode419_g13.r;
			float4 tex2DNode425_g13 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, uv_Splat3 );
			float Mask3R388_g13 = tex2DNode425_g13.r;
			float4 weightedBlendVar536_g13 = Control26_g13;
			float weightedBlend536_g13 = ( weightedBlendVar536_g13.x*max( _Metallic0 , Mask0R334_g13 ) + weightedBlendVar536_g13.y*max( _Metallic1 , Mask1R370_g13 ) + weightedBlendVar536_g13.z*max( _Metallic2 , Mask2R359_g13 ) + weightedBlendVar536_g13.w*max( _Metallic3 , Mask3R388_g13 ) );
			o.Metallic = weightedBlend536_g13;
			float4 appendResult1168_g13 = (float4(_Smoothness0 , _Smoothness1 , _Smoothness2 , _Smoothness3));
			float Splat0A435_g13 = tex2DNode414_g13.a;
			float Mask1A369_g13 = tex2DNode422_g13.a;
			float Mask2A360_g13 = tex2DNode419_g13.a;
			float Mask3A391_g13 = tex2DNode425_g13.a;
			float4 appendResult1169_g13 = (float4(Splat0A435_g13 , Mask1A369_g13 , Mask2A360_g13 , Mask3A391_g13));
			float dotResult1166_g13 = dot( ( appendResult1168_g13 * appendResult1169_g13 ) , Control26_g13 );
			o.Smoothness = dotResult1166_g13;
			float Mask0G409_g13 = tex2DNode416_g13.g;
			float Mask1G371_g13 = tex2DNode422_g13.g;
			float Mask2G358_g13 = tex2DNode419_g13.g;
			float Mask3G389_g13 = tex2DNode425_g13.g;
			float4 weightedBlendVar602_g13 = Control26_g13;
			float weightedBlend602_g13 = ( weightedBlendVar602_g13.x*saturate( ( ( ( Mask0G409_g13 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) + weightedBlendVar602_g13.y*saturate( ( ( ( Mask1G371_g13 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) + weightedBlendVar602_g13.z*saturate( ( ( ( Mask2G358_g13 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) + weightedBlendVar602_g13.w*saturate( ( ( ( Mask3G389_g13 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) ) ) );
			o.Occlusion = saturate( weightedBlend602_g13 );
			o.Alpha = dotResult278_g13;
		}

		ENDCG
		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
		UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
	}

	Dependency "BaseMapShader"="Hidden/AmplifyShaderPack/Terrain/Simple BasePass"
	Dependency "AddPassShader"="Hidden/AmplifyShaderPack/Terrain/Simple AddPass"
	Fallback "Nature/Terrain/Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.WorldPosInputsNode;74;-1376,832;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;66;-1184,832;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;65;-1024,832;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;64;-896,944;Half;False;Constant;_Float41;Float 39;55;0;Create;True;1;;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;60;-864,864;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1024,1024;Half;False;Property;_FogHeight;Fog Height;2;0;Create;True;1;;0;0;False;0;False;0.1;0.41;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-896,1104;Half;False;Constant;_Float42;Float 40;55;0;Create;True;1;;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1024,1200;Half;False;Property;_FogSmoothness;Fog Smoothness;3;0;Create;True;1;;0;0;False;0;False;0.75;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;49;64,64;Inherit;False;Terrain 4 Layer;5;;13;a8a57459582f78d4ca5db58f601fb616;4,504,1,102,1,669,0,668,0;0;8;FLOAT3;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;282;FLOAT3;709;FLOAT4;701
Node;AmplifyShaderEditor.TFHCRemapNode;72;-720,864;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;61;-704,1200;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;59;-528,864;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;71;-464,672;Inherit;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;320,64;Inherit;False;NormalOut;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-208,592;Inherit;False;80;NormalOut;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;69;-368,864;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-384,960;Half;False;Constant;_Float43;Float 41;55;0;Create;True;1;;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-512,1040;Half;False;Property;_FogFill;Fog Fill;1;0;Create;True;1;;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;76;-192,672;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;320,-32;Inherit;False;BaseColorOut;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-48,512;Inherit;False;80;NormalOut;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-16,592;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;68;-208,864;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-272,768;Inherit;False;79;BaseColorOut;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;78;160,576;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;70;-32,704;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;63;224,880;Half;False;Property;_EnableFog;Enable Fog;0;2;[Header];[ToggleUI];Create;True;1;FOG;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;144,784;Inherit;False;79;BaseColorOut;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;75;368,512;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;58;384,688;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;87;544,512;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;88;560,672;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode;50;656,528;Inherit;False;757.9001;428.2;BIRP First Pass;;0,0,0,1;Additional Directives:$$#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd$#pragma multi_compile_local __ _NORMALMAP$#pragma shader_feature_local _MASKMAP$#pragma multi_compile_local_fragment __ _ALPHATEST_ON$#pragma multi_compile_fog$#pragma editor_sync_compilation$#pragma target 3.0$#pragma exclude_renderers gles$#define TERRAIN_SPLATMAP_COMMON_CGINC_INCLUDED$#include UnityPBSLighting.cginc$#include TerrainSplatmapCommon.cginc$#define TERRAIN_STANDARD_SHADER$#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard$$$Custom SubShader Tags:$$TerrainCompatible = True$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;52;642.0813,-247.3737;Inherit;False;262;102;SplatmapFinalColor;;0,0,0,1;Additional Surface Options:$finalcolor:SplatmapFinalColor;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;45;643.3015,-133.2568;Float;False;FinalColor *= SurfaceOut.Alpha@;7;Create;3;True;SurfaceIn;OBJECT;0;In;Input;Float;False;True;SurfaceOut;OBJECT;0;In;SurfaceOutputStandard;Float;False;True;FinalColor;OBJECT;0;InOut;fixed4;Float;False;SplatmapFinalColor;False;True;0;;False;4;0;FLOAT;0;False;1;OBJECT;0;False;2;OBJECT;0;False;3;OBJECT;0;False;2;FLOAT;0;OBJECT;4
Node;AmplifyShaderEditor.WireNode;85;544,128;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;86;560,96;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;645.0565,40.11808;Float;False;True;-1;3;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Terrain/Simple;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;-100;True;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Nature/Terrain/Diffuse;4;-1;-1;-1;1;TerrainCompatible=True;False;2;BaseMapShader=Hidden/AmplifyShaderPack/Terrain/Simple BasePass;AddPassShader=Hidden/AmplifyShaderPack/Terrain/Simple AddPass;0;False;;-1;0;False;;13;Pragma;instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd;False;;Custom;False;0;0;;Pragma;multi_compile_local __ _NORMALMAP;False;;Custom;False;0;0;;Pragma;shader_feature_local _MASKMAP;False;;Custom;False;0;0;;Pragma;multi_compile_local_fragment __ _ALPHATEST_ON;False;;Custom;False;0;0;;Pragma;multi_compile_fog;False;;Custom;False;0;0;;Pragma;editor_sync_compilation;False;;Custom;False;0;0;;Pragma;target 3.0;False;;Custom;False;0;0;;Pragma;exclude_renderers gles;False;;Custom;False;0;0;;Define;TERRAIN_SPLATMAP_COMMON_CGINC_INCLUDED;False;;Custom;False;0;0;;Include;UnityPBSLighting.cginc;False;;Custom;False;0;0;;Include;TerrainSplatmapCommon.cginc;False;;Custom;False;0;0;;Define;TERRAIN_STANDARD_SHADER;False;;Custom;False;0;0;;Define;TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard;False;;Custom;False;0;0;;1;finalcolor:SplatmapFinalColor;0;True;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;66;0;74;0
WireConnection;65;0;66;0
WireConnection;60;0;65;1
WireConnection;72;0;60;0
WireConnection;72;1;64;0
WireConnection;72;2;57;0
WireConnection;72;3;64;0
WireConnection;72;4;62;0
WireConnection;61;0;56;0
WireConnection;59;0;72;0
WireConnection;59;1;61;0
WireConnection;80;0;49;14
WireConnection;69;0;59;0
WireConnection;76;0;71;0
WireConnection;79;0;49;0
WireConnection;77;0;82;0
WireConnection;77;1;76;0
WireConnection;68;0;69;0
WireConnection;68;1;67;0
WireConnection;68;2;55;0
WireConnection;78;0;81;0
WireConnection;78;1;77;0
WireConnection;78;2;81;0
WireConnection;70;0;76;0
WireConnection;70;1;83;0
WireConnection;70;2;68;0
WireConnection;75;0;81;0
WireConnection;75;1;78;0
WireConnection;75;2;63;0
WireConnection;58;0;84;0
WireConnection;58;1;70;0
WireConnection;58;2;63;0
WireConnection;87;0;75;0
WireConnection;88;0;58;0
WireConnection;85;0;87;0
WireConnection;86;0;88;0
WireConnection;0;0;86;0
WireConnection;0;1;85;0
WireConnection;0;3;49;56
WireConnection;0;4;49;45
WireConnection;0;5;49;200
WireConnection;0;9;49;282
WireConnection;0;12;49;709
WireConnection;0;16;49;701
ASEEND*/
//CHKSM=3E9BC0608B3DB3DB751508D61D0C0EDD96C1EB08