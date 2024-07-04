// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Orientation Based Sprite"
{
	Properties
	{
		_Spritesheet("Spritesheet", 2D) = "white" {}
		_Columns("Columns", Float) = 0
		_Rows("Rows", Float) = 0
		_AnimSpeed("Anim Speed", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.5
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 vertexToFrag37_g12;
		};

		uniform sampler2D _Spritesheet;
		uniform float _Rows;
		uniform float _Columns;
		uniform float _AnimSpeed;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 normalizeResult8_g12 = normalize( ( (float4( unity_ObjectToWorld[0][3],unity_ObjectToWorld[1][3],unity_ObjectToWorld[2][3],unity_ObjectToWorld[3][3] )).xyz - _WorldSpaceCameraPos ) );
			float3 break11_g12 = normalizeResult8_g12;
			float temp_output_41_0_g12 = _Rows;
			float temp_output_28_0_g12 = ( 1.0 / temp_output_41_0_g12 );
			float2 temp_output_43_0_g12 = v.texcoord.xy;
			float2 break44_g12 = temp_output_43_0_g12;
			float temp_output_45_0_g12 = _Columns;
			float2 appendResult36_g12 = (float2(( ( floor( ( ( atan2( break11_g12.z , break11_g12.x ) + UNITY_PI ) / ( 6.28318548202515 / temp_output_41_0_g12 ) ) ) * temp_output_28_0_g12 ) + ( temp_output_28_0_g12 * break44_g12.x ) ) , (( ( break44_g12.y + ( temp_output_45_0_g12 - fmod( ( 1.0 + round( ( _AnimSpeed * _Time.y ) ) ) , temp_output_45_0_g12 ) ) ) / temp_output_45_0_g12 )).x));
			o.vertexToFrag37_g12 = appendResult36_g12;
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			v.tangent.xyz = normalize( mul( float4( v.tangent.xyz , 0 ), rotationCamMatrix )).xyz;
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 temp_output_635_0 = tex2D( _Spritesheet, i.vertexToFrag37_g12 );
			o.Emission = (temp_output_635_0).rgb;
			o.Alpha = (temp_output_635_0).a;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;625;14677.47,683.2607;Float;False;Property;_Rows;Rows;2;0;Create;True;0;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;626;14673.59,753.8454;Float;False;Property;_Columns;Columns;1;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;628;14656.07,826.0577;Float;False;Property;_AnimSpeed;Anim Speed;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;622;14400.15,617.3531;Float;True;Property;_Spritesheet;Spritesheet;0;0;Create;True;0;0;0;False;0;False;None;8bad0b0ea8a87cd4ab57ff281be3b6df;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;635;14843.44,618.6252;Inherit;False;Orientation Based Sprite;-1;;12;39b23917f94c7994fb9f6c0ea9ccc6f9;1,46,1;6;40;SAMPLER2D;0.0;False;43;FLOAT2;0,0;False;48;FLOAT;0;False;41;FLOAT;1;False;45;FLOAT;1;False;42;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;623;15141.25,616.4166;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;624;15156.14,752.6461;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;542;15331.71,574.8088;Float;False;True;-1;3;ASEMaterialInspector;0;0;Unlit;AmplifyShaderPack/Orientation Based Sprite;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;True;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;635;40;622;0
WireConnection;635;41;625;0
WireConnection;635;45;626;0
WireConnection;635;42;628;0
WireConnection;623;0;635;0
WireConnection;624;0;635;0
WireConnection;542;2;623;0
WireConnection;542;9;624;0
ASEEND*/
//CHKSM=FB6A2C7BA25346085E0B2CFC196E894A8235C6AE