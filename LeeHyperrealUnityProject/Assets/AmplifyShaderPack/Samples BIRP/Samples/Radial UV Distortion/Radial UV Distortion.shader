// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Radial UV Distortion"
{
	Properties
	{
		_NoiseMap("Noise Map", 2D) = "white" {}
		_NoiseMapStrength("NoiseMapStrength", Range( 0 , 1)) = 0
		_RingPannerSpeed("RingPannerSpeed", Vector) = (0,0,0,0)
		_NoiseMapSize("NoiseMapSize", Vector) = (512,512,0,0)
		_NoiseMapPannerSpeed("NoiseMapPannerSpeed", Vector) = (0,0,0,0)
		_BaseTexture("Base Texture", 2D) = "white" {}
		_Tint("Tint", Color) = (0,0,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_OffsetMultiplier("Offset Multiplier", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BaseTexture;
		uniform sampler2D _NoiseMap;
		uniform float2 _NoiseMapSize;
		uniform float2 _NoiseMapPannerSpeed;
		uniform float _NoiseMapStrength;
		uniform float2 _RingPannerSpeed;
		uniform float _OffsetMultiplier;
		uniform float4 _Tint;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_output_1_0_g33 = _NoiseMapSize;
			float2 appendResult10_g33 = (float2(( (temp_output_1_0_g33).x * v.texcoord.xy.x ) , ( v.texcoord.xy.y * (temp_output_1_0_g33).y )));
			float2 temp_output_11_0_g33 = _NoiseMapPannerSpeed;
			float2 panner18_g33 = ( ( (temp_output_11_0_g33).x * _Time.y ) * float2( 1,0 ) + v.texcoord.xy);
			float2 panner19_g33 = ( ( _Time.y * (temp_output_11_0_g33).y ) * float2( 0,1 ) + v.texcoord.xy);
			float2 appendResult24_g33 = (float2((panner18_g33).x , (panner19_g33).y));
			float2 temp_output_47_0_g33 = _RingPannerSpeed;
			float2 uv_TexCoord78_g33 = v.texcoord.xy * float2( 2,2 );
			float2 temp_output_31_0_g33 = ( uv_TexCoord78_g33 - float2( 1,1 ) );
			float2 appendResult39_g33 = (float2(frac( ( atan2( (temp_output_31_0_g33).x , (temp_output_31_0_g33).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g33 )));
			float2 panner54_g33 = ( ( (temp_output_47_0_g33).x * _Time.y ) * float2( 1,0 ) + appendResult39_g33);
			float2 panner55_g33 = ( ( _Time.y * (temp_output_47_0_g33).y ) * float2( 0,1 ) + appendResult39_g33);
			float2 appendResult58_g33 = (float2((panner54_g33).x , (panner55_g33).y));
			float4 tex2DNode276 = tex2Dlod( _BaseTexture, float4( ( ( (tex2Dlod( _NoiseMap, float4( ( appendResult10_g33 + appendResult24_g33 ), 0, 0.0) )).rg * _NoiseMapStrength ) + ( float2( 1,1 ) * appendResult58_g33 ) ), 0, 0.0) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( tex2DNode276 * float4( ase_vertexNormal , 0.0 ) ) * _OffsetMultiplier ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color326 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			o.Albedo = color326.rgb;
			float2 temp_output_1_0_g33 = _NoiseMapSize;
			float2 appendResult10_g33 = (float2(( (temp_output_1_0_g33).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g33).y )));
			float2 temp_output_11_0_g33 = _NoiseMapPannerSpeed;
			float2 panner18_g33 = ( ( (temp_output_11_0_g33).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g33 = ( ( _Time.y * (temp_output_11_0_g33).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g33 = (float2((panner18_g33).x , (panner19_g33).y));
			float2 temp_output_47_0_g33 = _RingPannerSpeed;
			float2 uv_TexCoord78_g33 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_31_0_g33 = ( uv_TexCoord78_g33 - float2( 1,1 ) );
			float2 appendResult39_g33 = (float2(frac( ( atan2( (temp_output_31_0_g33).x , (temp_output_31_0_g33).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g33 )));
			float2 panner54_g33 = ( ( (temp_output_47_0_g33).x * _Time.y ) * float2( 1,0 ) + appendResult39_g33);
			float2 panner55_g33 = ( ( _Time.y * (temp_output_47_0_g33).y ) * float2( 0,1 ) + appendResult39_g33);
			float2 appendResult58_g33 = (float2((panner54_g33).x , (panner55_g33).y));
			float4 tex2DNode276 = tex2D( _BaseTexture, ( ( (tex2D( _NoiseMap, ( appendResult10_g33 + appendResult24_g33 ) )).rg * _NoiseMapStrength ) + ( float2( 1,1 ) * appendResult58_g33 ) ) );
			o.Emission = ( _Tint * tex2DNode276 ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.TexturePropertyNode;233;-42.89906,8.61548;Float;True;Property;_NoiseMap;Noise Map;0;0;Create;True;0;0;0;False;0;False;None;937c2d88ef9b4e889d5a0a6a952c1a4b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;239;6.337746,197.0628;Float;False;Property;_NoiseMapSize;NoiseMapSize;3;0;Create;True;0;0;0;False;0;False;512,512;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;241;-57.02807,314.3693;Float;False;Property;_NoiseMapPannerSpeed;NoiseMapPannerSpeed;4;0;Create;True;0;0;0;False;0;False;0,0;1.61,-0.43;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;234;-94.70015,431.8932;Float;False;Property;_NoiseMapStrength;NoiseMapStrength;1;0;Create;True;0;0;0;False;0;False;0;0.6162086;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;279;30.39875,502.1828;Float;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;240;-19.48774,618.8047;Float;False;Property;_RingPannerSpeed;RingPannerSpeed;2;0;Create;True;0;0;0;False;0;False;0,0;0.1,-1.27;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;316;270.8383,13.6351;Inherit;False;RadialUVDistortion;-1;;33;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;;False;1;FLOAT2;0,0;False;11;FLOAT2;0,0;False;65;FLOAT;0;False;68;FLOAT2;0,0;False;47;FLOAT2;0,0;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;276;709.5342,-11.55294;Inherit;True;Property;_BaseTexture;Base Texture;5;0;Create;True;0;0;0;False;0;False;-1;None;468c5859e2a9496ea1afdbc5cfce02ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.NormalVertexDataNode;325;838.3358,252.7099;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;317;798.2264,-184.4143;Float;False;Property;_Tint;Tint;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.682353,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;322;1042.337,229.7943;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;324;1284.632,304.2061;Inherit;False;Property;_OffsetMultiplier;Offset Multiplier;8;0;Create;True;0;0;0;False;0;False;0;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;323;1474.892,226.317;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;1063.514,-27.07267;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;319;1332.206,139.2089;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;326;1380.968,-209.75;Inherit;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;230;1705.613,-78.70673;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Radial UV Distortion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;1;32;10;25;False;0.8;True;2;5;False;;10;False;;0;1;False;;1;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;316;60;233;0
WireConnection;316;1;239;0
WireConnection;316;11;241;0
WireConnection;316;65;234;0
WireConnection;316;68;279;0
WireConnection;316;47;240;0
WireConnection;276;1;316;0
WireConnection;322;0;276;0
WireConnection;322;1;325;0
WireConnection;323;0;322;0
WireConnection;323;1;324;0
WireConnection;318;0;317;0
WireConnection;318;1;276;0
WireConnection;230;0;326;0
WireConnection;230;2;318;0
WireConnection;230;4;319;0
WireConnection;230;11;323;0
ASEEND*/
//CHKSM=E13ADA4C421FCE3EA4AD499325E814F8F16F7DD4