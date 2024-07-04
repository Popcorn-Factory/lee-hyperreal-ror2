// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Tessellation"
{
	Properties
	{
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
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[Header(TESSELLATION)][Space(10)]_TessellationStrength("Tessellation Strength", Range( 0.0001 , 100)) = 1
		_TessellationDistanceMin("Tessellation Distance Min", Float) = 0
		_TessellationDistanceMax("Tessellation Distance Max ", Float) = 25
		[Header(DISPLACEMENT HEIGHT MAPPING)][SingleLineTexture][Space(10)]_ParallaxMap("Displacement Map", 2D) = "black" {}
		[SingleLineTexture]_ParallaxMapMask("Displacement Mask Map", 2D) = "white" {}
		_DisplacementStrength("Strength", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _Cull;
		uniform sampler2D _ParallaxMap;
		uniform float4 _ParallaxMap_ST;
		uniform half _DisplacementStrength;
		uniform sampler2D _ParallaxMapMask;
		uniform float4 _ParallaxMapMask_ST;
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
		uniform half _TessellationDistanceMin;
		uniform half _TessellationDistanceMax;
		uniform half _TessellationStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessellationDistanceMin,_TessellationDistanceMax,_TessellationStrength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_ParallaxMap = v.texcoord * _ParallaxMap_ST.xy + _ParallaxMap_ST.zw;
			float2 uv_ParallaxMapMask = v.texcoord * _ParallaxMapMask_ST.xy + _ParallaxMapMask_ST.zw;
			v.vertex.xyz += ( ( ase_vertexNormal * ( (tex2Dlod( _ParallaxMap, float4( uv_ParallaxMap, 0, 0.0) )).rgb * _DisplacementStrength ) ) * (tex2Dlod( _ParallaxMapMask, float4( uv_ParallaxMapMask, 0, 0.0) )).rgb );
			v.vertex.w = 1;
		}

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
Node;AmplifyShaderEditor.TexturePropertyNode;32;-1967.263,301.7405;Inherit;True;Property;_ParallaxMap;Displacement Map;38;2;[Header];[SingleLineTexture];Create;False;1;DISPLACEMENT HEIGHT MAPPING;0;0;False;1;Space(10);False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;39;-1980.083,570.521;Inherit;True;Property;_ParallaxMapMask;Displacement Mask Map;39;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;40;-1663.084,567.521;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwizzleNode;41;-1311.865,569.9087;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;33;-1662.312,302.1247;Inherit;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;43;-677.205,603.1266;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;34;-1345.993,301.3852;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1329.052,402.2212;Half;False;Property;_DisplacementStrength;Strength;40;0;Create;False;1;;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1031.271,308.6256;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;37;-979.9257,155.0146;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;42;-606.7681,579.6476;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-760.3162,285.5139;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;44;-593.9614,389.6817;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-294.5674,531.392;Half;False;Property;_TessellationDistanceMax;Tessellation Distance Max ;37;0;Create;False;1;;0;0;False;0;False;25;2000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-292.2451,457.6407;Half;False;Property;_TessellationDistanceMin;Tessellation Distance Min;36;0;Create;False;1;;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-308.6605,381.874;Half;False;Property;_TessellationStrength;Tessellation Strength;35;1;[Header];Create;False;1;TESSELLATION;0;0;False;1;Space(10);False;1;0.5;0.0001;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;31;271.726,-80.00882;Inherit;False;Property;_Cull;Render Face;34;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;30;-147.3753,-3.065447;Inherit;False;Material Sample;0;;1;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,0,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-534.4835,281.497;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;47;-13.20747,387.0777;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;29;261.7877,-2.83243;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Tessellation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;45;-2137.207,6.530386;Inherit;False;1772.622;815.522;DISPLACEMENT HEIGHT MAPPING;0;;0,0,0,1;0;0
WireConnection;40;0;39;0
WireConnection;40;7;32;1
WireConnection;41;0;40;0
WireConnection;33;0;32;0
WireConnection;33;7;32;1
WireConnection;43;0;41;0
WireConnection;34;0;33;0
WireConnection;38;0;34;0
WireConnection;38;1;35;0
WireConnection;42;0;43;0
WireConnection;36;0;37;0
WireConnection;36;1;38;0
WireConnection;44;0;42;0
WireConnection;22;0;36;0
WireConnection;22;1;44;0
WireConnection;47;0;50;0
WireConnection;47;1;49;0
WireConnection;47;2;48;0
WireConnection;29;0;30;1
WireConnection;29;1;30;6
WireConnection;29;3;30;3
WireConnection;29;4;30;2
WireConnection;29;5;30;4
WireConnection;29;11;22;0
WireConnection;29;14;47;0
ASEEND*/
//CHKSM=DBD48D02CAFE29F7115891355DC58AC5E2E7EEE2