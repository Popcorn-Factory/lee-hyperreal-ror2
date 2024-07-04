// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Dithering Fade BlueNoise"
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
		[Header(DITHER)][NoScaleOffset][SingleLineTexture][Space(10)]_BlueNoise("Blue Noise", 2D) = "white" {}
		_StartDitheringFade("Start Dithering Fade", Float) = 0
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
		uniform sampler2D _BlueNoise;
		float4 _BlueNoise_TexelSize;
		uniform float _Cutoff = 0.5;


inline float DitherNoiseTex( float4 screenPos, sampler2D noiseTexture, float4 noiseTexelSize )
{
	float dither = tex2Dlod( noiseTexture, float4(screenPos.xy * _ScreenParams.xy * noiseTexelSize.xy, 0, 0) ).g;
	float ditherRate = noiseTexelSize.x * noiseTexelSize.y;
	dither = ( 1 - ditherRate ) * dither + ditherRate;
	return dither;
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
			float temp_output_73_0 = ( _StartDitheringFade + _ProjectionParams.y );
			float temp_output_76_0 = ( ( i.eyeDepth + -temp_output_73_0 ) / ( _EndDitheringFade - temp_output_73_0 ) );
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float dither78 = DitherNoiseTex(ase_screenPosNorm, _BlueNoise, _BlueNoise_TexelSize);
			clip( ( temp_output_76_0 - round( dither78 ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;69;-1108.72,184.7456;Inherit;False;1614.084;976.9716;Scale depth from start to end;21;74;89;101;100;99;78;68;93;92;77;76;81;73;82;72;71;70;91;90;79;75;;0,0,0,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;68;-574.2061,742.6176;Float;True;Property;_BlueNoise;Blue Noise;36;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;DITHER;0;0;False;1;Space(10);False;None;58bfd706299646e6a342bd9b037dfeda;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;81;-1056.332,473.6708;Float;False;Property;_StartDitheringFade;Start Dithering Fade;37;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;78;-306.485,720.0706;Inherit;False;2;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ProjectionParams;77;-1054.525,550.0781;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-834.6561,477.2029;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;89;2.580619,727.6149;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;72;-673.269,354.3222;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-681.1376,439.6755;Float;False;Property;_EndDitheringFade;End Dithering Fade;38;0;Create;False;0;0;0;False;0;False;1;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;101;251.4829,753.7465;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;74;-1003.114,295.2718;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-464.8839,451.5754;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-528.1841,293.7761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;99;270.7614,720.1116;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-319.476,294.0915;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;100;275.2061,363.4282;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;79;350.7184,289.189;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;75;-1047.935,689.0276;Inherit;False;170.3619;100;Near Plane;;0,0,0,1;Correction for near plane clipping;0;0
Node;AmplifyShaderEditor.FunctionNode;80;232.3005,-92.22832;Inherit;False;Material Sample;2;;3;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,0,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.IntNode;83;773.4773,-169.2574;Inherit;False;Property;_Cull;Render Face;1;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StickyNoteNode;90;0.4396055,611.4913;Inherit;False;196.3811;103.092;Round Node;;0,0,0,1;With the Round Node, we make every pixel either black or white.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;91;-309.9654,843.2056;Inherit;False;480.8519;290.1625;Dither Node;;0.0471698,0.0471698,0.0471698,1;The Dither Node converts a grayscale image to a black and white image using a uniform grid dither pattern.$$$4x4 Bayer: $Uses a 4x4 matrix to create 16 unique dither layers$$8x8 Bayer: $Uses an 8x8 matrix to create 64 unique dither layers$$Noise Texture: $Uses the respective Pattern port to create dither according to a precomputed noise pattern (ie: higher size Bayer patterns or Blue noise patterns)$;0;0
Node;AmplifyShaderEditor.StickyNoteNode;93;-175.5353,428.843;Inherit;False;256.2769;100;One Minus Node;;0,0,0,1;useful for changing direction from Fade-In to Fade-Out ;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;581.3981,131.4664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;102;687.9149,285.8565;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;92;-175.05,358.6065;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;772.3151,-92.97414;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Dithering Fade BlueNoise;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;78;1;68;0
WireConnection;78;3;68;1
WireConnection;73;0;81;0
WireConnection;73;1;77;2
WireConnection;89;0;78;0
WireConnection;72;0;73;0
WireConnection;101;0;89;0
WireConnection;70;0;82;0
WireConnection;70;1;73;0
WireConnection;71;0;74;0
WireConnection;71;1;72;0
WireConnection;99;0;101;0
WireConnection;76;0;71;0
WireConnection;76;1;70;0
WireConnection;100;0;99;0
WireConnection;79;0;76;0
WireConnection;79;1;100;0
WireConnection;84;0;80;8
WireConnection;102;0;79;0
WireConnection;92;0;76;0
WireConnection;0;0;80;1
WireConnection;0;1;80;6
WireConnection;0;3;80;5
WireConnection;0;5;80;4
WireConnection;0;10;102;0
ASEEND*/
//CHKSM=69A5825D1196DF22025FD7982E0300B63F56C3B9