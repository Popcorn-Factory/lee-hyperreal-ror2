// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Local Position Cutoff"
{
	Properties
	{
		[Toggle]_UseObjectSpace("Use Object Space", Float) = 0
		_Distribution("Distribution", Range( 0.1 , 10)) = 1
		_SmoothnessFactor("SmoothnessFactor", Range( 0 , 1)) = 0
		_StartPoint("StartPoint", Range( -10 , 10)) = 0.75
		_UnderwaterInfluence("UnderwaterInfluence", Range( 0 , 1)) = 0
		_Tint("Tint", Color) = (0.5294118,0.4264289,0,0)
		_Normals("Normals", 2D) = "bump" {}
		_Albedo("Albedo", 2D) = "white" {}
		_Occlusion("Occlusion", 2D) = "white" {}
		_Metallic("Metallic", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normals;
		uniform float4 _Normals_ST;
		uniform float4 _Tint;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _UseObjectSpace;
		uniform float _StartPoint;
		uniform float _Distribution;
		uniform float _UnderwaterInfluence;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform float _SmoothnessFactor;
		uniform sampler2D _Occlusion;
		uniform float4 _Occlusion_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normals = i.uv_texcoord * _Normals_ST.xy + _Normals_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normals, uv_Normals ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_15_0 = saturate( ( ( (( _UseObjectSpace )?( ase_vertex3Pos.y ):( ase_worldPos.y )) + _StartPoint ) / _Distribution ) );
			float clampResult30 = clamp( temp_output_15_0 , _UnderwaterInfluence , 1.0 );
			float4 lerpResult52 = lerp( _Tint , tex2D( _Albedo, uv_Albedo ) , clampResult30);
			o.Albedo = lerpResult52.rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 temp_output_49_0 = ( tex2D( _Metallic, uv_Metallic ) + ( 1.0 - temp_output_15_0 ) );
			o.Metallic = temp_output_49_0.r;
			o.Smoothness = ( temp_output_49_0 * _SmoothnessFactor ).r;
			float2 uv_Occlusion = i.uv_texcoord * _Occlusion_ST.xy + _Occlusion_ST.zw;
			o.Occlusion = tex2D( _Occlusion, uv_Occlusion ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;27;-1294.719,489.6995;Inherit;False;1233.367;680.4214;Cutoff;11;47;30;54;50;15;16;14;5;2;59;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;59;-1228.231,559.0172;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;47;-1230.926,770.3738;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;60;-1049.161,665.2292;Inherit;False;Property;_UseObjectSpace;Use Object Space;0;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1173.403,935.2018;Float;False;Property;_StartPoint;StartPoint;3;0;Create;True;0;0;0;False;0;False;0.75;0.12;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-883.5765,834.8618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1180.403,1054.402;Float;False;Property;_Distribution;Distribution;1;0;Create;True;0;0;0;False;0;False;1;0.54;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-801.5034,955.6025;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-914.6158,-533.7644;Inherit;False;719.1993;462.2003;Color Stuff;4;20;19;17;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;15;-638.3052,934.9023;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;50;-347.6841,901.2353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-777.1836,748.0355;Float;False;Property;_UnderwaterInfluence;UnderwaterInfluence;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-528,-272;Inherit;True;Property;_Metallic;Metallic;9;0;Create;True;0;0;0;False;0;False;-1;None;f4ef9b0dca354d7aaf185497d6b77ea5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ClampOpNode;30;-417.7546,743.5257;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-528,-480;Inherit;True;Property;_Albedo;Albedo;7;0;Create;True;0;0;0;False;0;False;-1;None;3870bf0e58484ded877fb5a340656651;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-34.34885,121.0344;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;-512,-32;Float;False;Property;_Tint;Tint;5;0;Create;True;0;0;0;False;0;False;0.5294118,0.4264289,0,0;0.07954546,1,0,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;34;-108.9506,481.5498;Float;False;Property;_SmoothnessFactor;SmoothnessFactor;2;0;Create;True;0;0;0;False;0;False;0;0.648;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-46.25838,-56.83827;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;20;-864,-272;Inherit;True;Property;_Occlusion;Occlusion;8;0;Create;True;0;0;0;False;0;False;-1;None;13f3e59f57e6472b896dfcd08d4a1b91;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;160,224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-879.9675,-480.0001;Inherit;True;Property;_Normals;Normals;6;0;Create;True;0;0;0;False;0;False;-1;None;b253eb6675e043b9870a2bbd48feb6f8;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;432.1003,45.80003;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Local Position Cutoff;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;0;59;2
WireConnection;60;1;47;2
WireConnection;14;0;60;0
WireConnection;14;1;2;0
WireConnection;16;0;14;0
WireConnection;16;1;5;0
WireConnection;15;0;16;0
WireConnection;50;0;15;0
WireConnection;30;0;15;0
WireConnection;30;1;54;0
WireConnection;49;0;18;0
WireConnection;49;1;50;0
WireConnection;52;0;53;0
WireConnection;52;1;17;0
WireConnection;52;2;30;0
WireConnection;51;0;49;0
WireConnection;51;1;34;0
WireConnection;0;0;52;0
WireConnection;0;1;19;0
WireConnection;0;3;49;0
WireConnection;0;4;51;0
WireConnection;0;5;20;0
ASEEND*/
//CHKSM=ED5A1602D55F8285400859C677680352C3CC54E2