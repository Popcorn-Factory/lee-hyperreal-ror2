// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Normal Extrusion"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15.3
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_ExtrusionPoint("ExtrusionPoint", Float) = 0
		_ExtrusionAmount("Extrusion Amount", Range( -1 , 20)) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
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
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _ExtrusionPoint;
		uniform float _ExtrusionAmount;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( ase_vertexNormal * max( ( sin( ( ( ase_vertex3Pos.y + _Time.y ) / _ExtrusionPoint ) ) / _ExtrusionAmount ) , 0.0 ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.PosVertexDataNode;18;-1312,128;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;25;-1312,272;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1056,160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1056,256;Float;False;Property;_ExtrusionPoint;ExtrusionPoint;5;0;Create;True;0;0;0;False;0;False;0;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-832,160;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;20;-656,160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-832,256;Float;False;Property;_ExtrusionAmount;Extrusion Amount;6;0;Create;True;0;0;0;False;0;False;0.5;9.6;-1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;-464,160;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;26;-304,160;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;2;-304,0;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-384,-256;Inherit;True;Property;_Albedo;Albedo;7;0;Create;True;0;0;0;False;0;False;-1;None;aab8de1052c54173b3d61e7f8b05aedf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-48,16;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;128,-256;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Normal Extrusion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;15.3;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;18;2
WireConnection;22;1;25;2
WireConnection;19;0;22;0
WireConnection;19;1;21;0
WireConnection;20;0;19;0
WireConnection;24;0;20;0
WireConnection;24;1;3;0
WireConnection;26;0;24;0
WireConnection;4;0;2;0
WireConnection;4;1;26;0
WireConnection;0;0;1;0
WireConnection;0;11;4;0
ASEEND*/
//CHKSM=789C93A7721CAF99F0853CA6A1C757431FC60EB4