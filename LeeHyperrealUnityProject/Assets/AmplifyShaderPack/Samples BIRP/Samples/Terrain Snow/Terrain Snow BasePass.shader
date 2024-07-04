// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/AmplifyShaderPack/Terrain/Snow BasePass"
{
	Properties
	{
		_Color("_Color", Color) = (0,0,0,0)
		_MainTex("_MainTex", 2D) = "white" {}
		_MetallicTex("_MetallicTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-100" "TerrainCompatible"="True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		#include "UnityPBSLighting.cginc"
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf Standard keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
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
		uniform half4 _Color;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
		uniform float4 _MainTex_ST;
		SamplerState sampler_MainTex;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MetallicTex);
		uniform float4 _MetallicTex_ST;
		SamplerState sampler_MetallicTex;


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
			float localCalculateTangentsStandard88_g1 = ( 0.0 );
			{
			v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
			v.tangent.w = -1;
			}
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_89_0_g1 = ( localCalculateTangentsStandard88_g1 + ase_vertexNormal );
			v.normal = temp_output_89_0_g1;
			float4 appendResult87_g1 = (float4(cross( ase_vertexNormal , float3(0,0,1) ) , -1.0));
			v.tangent = appendResult87_g1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode2_g1 = SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, uv_MainTex );
			float3 lerpResult61_g1 = lerp( (_Color).rgb , (tex2DNode2_g1).rgb , 1.0);
			o.Albedo = lerpResult61_g1;
			float2 uv_MetallicTex = i.uv_texcoord * _MetallicTex_ST.xy + _MetallicTex_ST.zw;
			o.Metallic = SAMPLE_TEXTURE2D( _MetallicTex, sampler_MetallicTex, uv_MetallicTex ).r;
			o.Smoothness = tex2DNode2_g1.a;
			o.Alpha = 1;
		}

		ENDCG
		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
		UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.FunctionNode;8;-256,0;Inherit;False;Terrain 4 Layer BasePass;0;;1;c8412200c39e42b47b386a0f238f572e;0;0;5;FLOAT3;58;FLOAT;51;FLOAT;52;FLOAT3;91;FLOAT4;92
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;130.1901,1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Hidden/AmplifyShaderPack/Terrain/Snow BasePass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;-100;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Diffuse;-1;-1;-1;-1;1;TerrainCompatible=True;False;0;0;False;;-1;0;False;;1;Include;UnityPBSLighting.cginc;False;;Custom;False;0;0;;0;0;True;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;8;58
WireConnection;0;3;8;51
WireConnection;0;4;8;52
WireConnection;0;12;8;91
WireConnection;0;16;8;92
ASEEND*/
//CHKSM=3861AF0BF6758C6F8AF6A3266989B230999A3F45