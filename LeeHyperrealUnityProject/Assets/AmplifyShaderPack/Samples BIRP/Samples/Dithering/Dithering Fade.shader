// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Dithering Fade"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[Header(SURFACE INPUTS)]_BaseColor("Base Color", Color) = (1,1,1,0)
		_Brightness("Brightness", Range( 0 , 2)) = 1
		[SingleLineTexture]_MainTex("BaseColor Map", 2D) = "white" {}
		_MainUVs("Main UVs", Vector) = (1,1,0,0)
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Float) = 1
		[SingleLineTexture]_SpecularMap("Specular Map", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_SpecularStrength("Specular Strength", Range( 0 , 1)) = 0.04
		[SingleLineTexture]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		_OcclusionStrengthAO("Occlusion Strength", Range( 0 , 1)) = 0
		[Header(DITHER)][Space(10)]_StartDitheringFade("Start Dithering Fade", Float) = 0
		_EndDitheringFade("End Dithering Fade", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float eyeDepth;
			float4 screenPosition;
		};

		uniform int _Cull;
		uniform sampler2D _BumpMap;
		uniform float4 _MainUVs;
		uniform half _NormalStrength;
		uniform half4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform float4 _SpecularColor;
		uniform sampler2D _SpecularMap;
		uniform half _SpecularStrength;
		uniform half _OcclusionStrengthAO;
		uniform sampler2D _OcclusionMap;
		uniform float _StartDitheringFade;
		uniform float _EndDitheringFade;
		uniform float _Cutoff = 0.5;


inline float Dither8x8Bayer( int x, int y )
{
	const float dither[ 64 ] = {
		 1, 49, 13, 61,  4, 52, 16, 64,
		33, 17, 45, 29, 36, 20, 48, 32,
		 9, 57,  5, 53, 12, 60,  8, 56,
		41, 25, 37, 21, 44, 28, 40, 24,
		 3, 51, 15, 63,  2, 50, 14, 62,
		35, 19, 47, 31, 34, 18, 46, 30,
		11, 59,  7, 55, 10, 58,  6, 54,
		43, 27, 39, 23, 42, 26, 38, 22};
	int r = y * 8 + x;
	return dither[r] / 64; // same # of instructions as pre-dividing due to compiler magic
}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 temp_output_133_0_g3 = ( ( i.uv_texcoord * (_MainUVs).xy ) + (_MainUVs).zw );
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, temp_output_133_0_g3 ), _NormalStrength );
			float4 tex2DNode21_g3 = tex2D( _MainTex, temp_output_133_0_g3 );
			float3 temp_output_89_0_g3 = ( (_BaseColor).rgb * (tex2DNode21_g3).rgb * _Brightness );
			o.Albedo = temp_output_89_0_g3;
			float3 temp_output_202_0_g3 = (_SpecularColor).rgb;
			o.Specular = ( temp_output_202_0_g3 * (tex2D( _SpecularMap, temp_output_133_0_g3 )).rgb * _SpecularStrength );
			o.Occlusion = saturate( ( ( 1.0 - _OcclusionStrengthAO ) * (tex2D( _OcclusionMap, temp_output_133_0_g3 )).rgb ) ).x;
			o.Alpha = 1;
			float temp_output_65_0 = ( _StartDitheringFade + _ProjectionParams.y );
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen26 = abs( ase_screenPosNorm.xy ) * _ScreenParams.xy;
			float dither26 = Dither8x8Bayer( fmod(clipScreen26.x, 8), fmod(clipScreen26.y, 8) );
			clip( ( ( ( i.eyeDepth + -temp_output_65_0 ) / ( _EndDitheringFade - temp_output_65_0 ) ) - dither26 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;36;-208,288;Inherit;False;1119.881;604.261;Scale depth from start to end;12;31;30;27;26;19;34;68;15;65;33;28;29;;0,0,0,1;0;0
Node;AmplifyShaderEditor.ProjectionParams;19;-176,672;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-176,560;Float;False;Property;_StartDitheringFade;Start Dithering Fade;36;1;[Header];Create;True;1;DITHER;0;0;False;1;Space(10);False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;32,576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;33;192,448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;15;-176,384;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;192,528;Float;False;Property;_EndDitheringFade;End Dithering Fade;37;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;400,544;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;352,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;560,384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;26;576,496;Inherit;False;1;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;68;32,688;Inherit;False;175;115;Near Plane;;0,0,0,1;Correction for near plane clipping;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;768,384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;73;1155.338,-148.013;Inherit;False;Property;_Cull;Render Face;1;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;960,160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;71;640,-64;Inherit;False;Material Sample;2;;3;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,0,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1156.988,-66.38753;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Dithering Fade;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;65;0;30;0
WireConnection;65;1;19;2
WireConnection;33;0;65;0
WireConnection;29;0;31;0
WireConnection;29;1;65;0
WireConnection;28;0;15;0
WireConnection;28;1;33;0
WireConnection;34;0;28;0
WireConnection;34;1;29;0
WireConnection;27;0;34;0
WireConnection;27;1;26;0
WireConnection;72;0;71;8
WireConnection;0;0;71;1
WireConnection;0;1;71;6
WireConnection;0;3;71;5
WireConnection;0;5;71;4
WireConnection;0;10;27;0
ASEEND*/
//CHKSM=0834718A440D75D641D0F80A5E434329DA2E0C2D