// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Material Sample Standard"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[Header(SURFACE INPUTS)]_BaseColor("Base Color", Color) = (1,1,1,0)
		_Brightness("Brightness", Range( 0 , 2)) = 1
		[SingleLineTexture]_MainTex("BaseColor Map", 2D) = "white" {}
		_MainUVs("Main UVs", Vector) = (1,1,0,0)
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Float) = 1
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_MetallicStrength("Metallic Strength", Range( 0 , 1)) = 0
		[SingleLineTexture]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		_OcclusionStrengthAO("Occlusion Strength", Range( 0 , 1)) = 0
		[SingleLineTexture]_SmoothnessMap("Smoothness Map", 2D) = "white" {}
		_SmoothnessStrength("Smoothness Strength", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _Cull;
		uniform sampler2D _BumpMap;
		uniform float4 _MainUVs;
		uniform half _NormalStrength;
		uniform half4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform float _MetallicStrength;
		uniform sampler2D _MetallicGlossMap;
		uniform half _SmoothnessStrength;
		uniform sampler2D _SmoothnessMap;
		uniform half _OcclusionStrengthAO;
		uniform sampler2D _OcclusionMap;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_133_0_g1 = ( ( i.uv_texcoord * (_MainUVs).xy ) + (_MainUVs).zw );
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, temp_output_133_0_g1 ), _NormalStrength );
			float4 tex2DNode21_g1 = tex2D( _MainTex, temp_output_133_0_g1 );
			float3 temp_output_89_0_g1 = ( (_BaseColor).rgb * (tex2DNode21_g1).rgb * _Brightness );
			o.Albedo = temp_output_89_0_g1;
			o.Metallic = ( _MetallicStrength * (tex2D( _MetallicGlossMap, temp_output_133_0_g1 )).rgb ).x;
			o.Smoothness = ( _SmoothnessStrength * (tex2D( _SmoothnessMap, temp_output_133_0_g1 )).rgb ).x;
			o.Occlusion = saturate( ( ( 1.0 - _OcclusionStrengthAO ) * (tex2D( _OcclusionMap, temp_output_133_0_g1 )).rgb ) ).x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.FunctionNode;22;-400.8913,-63.87687;Inherit;False;Material Sample;1;;1;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,0,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.IntNode;23;3.408918,-144.4768;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;21;3.700001,-63;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Material Sample Standard;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;True;True;True;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;22;1
WireConnection;21;1;22;6
WireConnection;21;3;22;3
WireConnection;21;4;22;2
WireConnection;21;5;22;4
ASEEND*/
//CHKSM=106AE5AAC6F171451ED7CAD10BF35F9CE9BB538F