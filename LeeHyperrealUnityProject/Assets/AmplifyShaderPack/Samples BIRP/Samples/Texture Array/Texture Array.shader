// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Texture Array"
{
	Properties
	{
		_TextureArrayAlbedo("Texture Array Albedo", 2DArray) = "white" {}
		_TextureArrayNormal("Texture Array Normal", 2DArray) = "white" {}
		_AlbedoIndex("Albedo Index", Float) = 3
		_NormalIndex("Normal Index", Float) = 0
		_RoughnessIndex("Roughness Index", Float) = 0
		_OcclusionIndex("Occlusion Index", Float) = 1
		_NormalScale("Normal Scale", Float) = 1
		_RoughScale("Rough Scale", Range( 0 , 1)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.5
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D_ARRAY(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D_ARRAY(tex,samplertex,coord) tex2DArray(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArrayNormal);
		uniform float4 _TextureArrayNormal_ST;
		uniform float _NormalIndex;
		SamplerState sampler_TextureArrayNormal;
		uniform float _NormalScale;
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_TextureArrayAlbedo);
		uniform float4 _TextureArrayAlbedo_ST;
		uniform float _AlbedoIndex;
		SamplerState sampler_TextureArrayAlbedo;
		uniform float _RoughnessIndex;
		uniform float _RoughScale;
		uniform float _OcclusionIndex;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TextureArrayNormal = i.uv_texcoord;
			o.Normal = UnpackScaleNormal( SAMPLE_TEXTURE2D_ARRAY( _TextureArrayNormal, sampler_TextureArrayNormal, float3(uv_TextureArrayNormal,_NormalIndex) ), _NormalScale );
			float2 uv_TextureArrayAlbedo = i.uv_texcoord;
			o.Albedo = SAMPLE_TEXTURE2D_ARRAY( _TextureArrayAlbedo, sampler_TextureArrayAlbedo, float3(uv_TextureArrayAlbedo,_AlbedoIndex) ).rgb;
			o.Smoothness = ( SAMPLE_TEXTURE2D_ARRAY( _TextureArrayAlbedo, sampler_TextureArrayAlbedo, float3(uv_TextureArrayAlbedo,_RoughnessIndex) ).r * _RoughScale );
			o.Occlusion = SAMPLE_TEXTURE2D_ARRAY( _TextureArrayAlbedo, sampler_TextureArrayAlbedo, float3(uv_TextureArrayAlbedo,_OcclusionIndex) ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;109;-560,64;Float;False;Property;_RoughnessIndex;Roughness Index;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-556.4009,-362.0616;Float;False;Property;_AlbedoIndex;Albedo Index;2;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-544,320;Float;False;Property;_OcclusionIndex;Occlusion Index;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-304,240;Float;False;Property;_RoughScale;Rough Scale;7;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-564.995,-189.7364;Float;False;Property;_NormalIndex;Normal Index;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-560,-80;Float;False;Property;_NormalScale;Normal Scale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;105;-313.5995,21.78386;Inherit;True;Property;_TextureArray2;Texture Array 2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;108;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;99.54906,25.52966;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;-320,320;Inherit;True;Property;_TextureArray3;Texture Array 3;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;108;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;103;-304,-192;Inherit;True;Property;_TextureArrayNormal;Texture Array Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;108;-311.4424,-432.2489;Inherit;True;Property;_TextureArrayAlbedo;Texture Array Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;407.6068,-183.0747;Float;False;True;-1;3;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Texture Array;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;105;6;109;0
WireConnection;117;0;105;1
WireConnection;117;1;118;0
WireConnection;104;6;110;0
WireConnection;103;5;123;0
WireConnection;103;6;111;0
WireConnection;108;6;113;0
WireConnection;0;0;108;0
WireConnection;0;1;103;0
WireConnection;0;4;117;0
WireConnection;0;5;104;1
ASEEND*/
//CHKSM=3D1DA5A6DBFFB6C00C219B88C8DAEF1AE099F1B0