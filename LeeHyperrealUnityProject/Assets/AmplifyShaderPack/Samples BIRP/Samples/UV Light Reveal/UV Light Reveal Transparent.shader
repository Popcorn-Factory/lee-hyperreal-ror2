// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/UV Light Reveal Transparent"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[HideInInspector]_MaskClipValue("Mask Clip Value", Float) = 0.15
		_AlphaCutoffBias("Alpha Cutoff Bias", Range( 0 , 1)) = 0.5
		[HDR]_EmissiveColor("Emissive Color", Color) = (1,1,1,0)
		_UVLight00Brightness("Brightness", Range( 0 , 5)) = 1
		_UVTexture("UV Texture", 2D) = "white" {}
		_ColortoBeFiltered("Color to Be Filtered", Color) = (0.4039216,0,1,1)
		_DifferenceThreshold("Difference Threshold", Range( 0 , 0.05)) = 0
		_UVLight00ThresholdTemp("Threshold Reveal Color Temp", Range( 0 , 1)) = 0.175
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _Cull;
		uniform float _MaskClipValue;
		uniform half4 _EmissiveColor;
		uniform sampler2D _UVTexture;
		uniform float4 _UVTexture_ST;
		uniform float _UVLight00ThresholdTemp;
		uniform float4 _ColortoBeFiltered;
		uniform float _DifferenceThreshold;
		uniform half _UVLight00Brightness;
		uniform half _AlphaCutoffBias;


		float3 Blackbody52( float Temperature )
		{
			float3 color = float3(255.0, 255.0, 255.0);
			color.x = 56100000. * pow(Temperature,(-3.0 / 2.0)) + 148.0;
			color.y = 100.04 * log(Temperature) - 623.6;
			if (Temperature > 6500.0) color.y = 35200000.0 * pow(Temperature,(-3.0 / 2.0)) + 184.0;
			color.z = 194.18 * log(Temperature) - 1448.6;
			color = clamp(color, 0.0, 255.0)/255.0;
			if (Temperature < 1000.0) color *= Temperature/1000.0;
			return color;
		}


		float3 ASESafeNormalize(float3 inVec)
		{
			float dp3 = max(1.175494351e-38, dot(inVec, inVec));
			return inVec* rsqrt(dp3);
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_UVTexture = i.uv_texcoord * _UVTexture_ST.xy + _UVTexture_ST.zw;
			float4 tex2DNode19 = tex2D( _UVTexture, uv_UVTexture );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float lerpResult54 = lerp( 1000.0 , 7800.0 , _UVLight00ThresholdTemp);
			float Temperature52 = lerpResult54;
			float3 localBlackbody52 = Blackbody52( Temperature52 );
			float3 normalizeResult7 = ASESafeNormalize( (( ( ase_lightColor.rgb * ase_lightColor.a ) * localBlackbody52 )).xyz );
			float3 normalizeResult8 = ASESafeNormalize( (_ColortoBeFiltered).rgb );
			float dotResult1 = dot( normalizeResult7 , normalizeResult8 );
			float temp_output_2_0 = ( _WorldSpaceLightPos0.w *  ( dotResult1 - _DifferenceThreshold > 1.0 ? 0.0 : dotResult1 - _DifferenceThreshold <= 1.0 && dotResult1 + _DifferenceThreshold >= 1.0 ? 1.0 : 0.0 )  );
			float3 temp_output_44_0 = ( (_EmissiveColor).rgb * ( (tex2DNode19).rgb * temp_output_2_0 ) * _UVLight00Brightness );
			o.Albedo = temp_output_44_0;
			o.Emission = temp_output_44_0;
			clip( ( tex2DNode19.a * temp_output_2_0 ) - ( 1.0 - _AlphaCutoffBias ));
			o.Alpha = saturate( 0.0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;56;-1463.954,49.51366;Inherit;False;Constant;_1;1000;2;0;Create;True;0;0;0;False;0;False;1000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1474.936,123.2769;Inherit;False;Constant;_;7800;2;0;Create;True;0;0;0;False;0;False;7800;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1576.823,195.6139;Inherit;False;Property;_UVLight00ThresholdTemp;Threshold Reveal Color Temp;8;0;Create;False;0;0;0;False;0;False;0.175;0.212;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-1273.881,54.40234;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;52;-1058.312,54.31427;Inherit;False;float3 color = float3(255.0, 255.0, 255.0)@$color.x = 56100000. * pow(Temperature,(-3.0 / 2.0)) + 148.0@$color.y = 100.04 * log(Temperature) - 623.6@$if (Temperature > 6500.0) color.y = 35200000.0 * pow(Temperature,(-3.0 / 2.0)) + 184.0@$color.z = 194.18 * log(Temperature) - 1448.6@$color = clamp(color, 0.0, 255.0)/255.0@$if (Temperature < 1000.0) color *= Temperature/1000.0@$return color@;3;Create;1;True;Temperature;FLOAT;1000;In;;Inherit;False;Blackbody;True;False;0;;False;1;0;FLOAT;1000;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;75;-814.2797,68.65469;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;18;-1170.831,-198.0189;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;74;-810.0207,-84.6683;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-971.8246,-175.9645;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-761.2837,-180.3568;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;9;-764.1873,-86.35132;Float;False;Property;_ColortoBeFiltered;Color to Be Filtered;6;0;Create;True;0;0;0;False;0;False;0.4039216,0,1,1;0.4039212,0,1,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwizzleNode;17;-552.924,-87.50162;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;16;-558.4612,-183.4337;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;7;-391.6578,-178.8267;Inherit;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;8;-394.2471,-83.99021;Inherit;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-244.5203,-18.33928;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-384.3657,55.11069;Float;False;Property;_DifferenceThreshold;Difference Threshold;7;0;Create;True;0;0;0;False;0;False;0;0.0207;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1;-226.2244,-132.8816;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;4;-69.58995,-134.0529;Inherit;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;81;198.7335,-108.6757;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-124.6095,-593.5845;Inherit;True;Property;_UVTexture;UV Texture;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;80;182.6223,-273.0291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;11;-72.76258,-389.8568;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;69;313.8232,-416.1234;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;200.3369,-365.8883;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;559.1343,-303.0188;Half;False;Property;_AlphaCutoffBias;Alpha Cutoff Bias;2;0;Create;False;1;;0;0;False;0;False;0.5;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;20;189.1676,-593.706;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;377.9216,-389.2845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;61;835.2442,-299.572;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;552.7966,-723.8121;Half;False;Property;_EmissiveColor;Emissive Color;3;1;[HDR];Create;False;0;0;0;False;0;False;1,1,1,0;2,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;380.8322,-588.5075;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClipNode;60;996.1367,-410.031;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;26;804.4238,-723.7484;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;59;691.1205,-515.5484;Half;False;Property;_UVLight00Brightness;Brightness;4;0;Create;False;1;;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;33;-1187.87,-269.9321;Inherit;False;347.307;209.4912;;;0,0,0,1;Returns additional light Color;0;0
Node;AmplifyShaderEditor.StickyNoteNode;76;-1058.385,123.506;Inherit;False;472.4147;174.6465;BackBody Node;;0.1132075,0.1132075,0.1132075,1;see http://www.vendian.org/mncharity/dir3/blackbody/;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;1014.812,-609.6042;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;62;1186.918,-398.2047;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;21;1350.213,-759.3519;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;1347.983,-684.6453;Inherit;False;Property;_MaskClipValue;Mask Clip Value;1;1;[HideInInspector];Create;True;1;;0;0;True;0;False;0.15;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1351.113,-604.9473;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/UV Light Reveal Transparent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;True;_MaskClipValue;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;56;0
WireConnection;54;1;55;0
WireConnection;54;2;57;0
WireConnection;52;0;54;0
WireConnection;75;0;52;0
WireConnection;74;0;75;0
WireConnection;10;0;18;1
WireConnection;10;1;18;2
WireConnection;58;0;10;0
WireConnection;58;1;74;0
WireConnection;17;0;9;0
WireConnection;16;0;58;0
WireConnection;7;0;16;0
WireConnection;8;0;17;0
WireConnection;1;0;7;0
WireConnection;1;1;8;0
WireConnection;4;0;1;0
WireConnection;4;1;5;0
WireConnection;4;3;5;0
WireConnection;4;5;6;0
WireConnection;81;0;4;0
WireConnection;80;0;81;0
WireConnection;69;0;19;4
WireConnection;2;0;11;2
WireConnection;2;1;80;0
WireConnection;20;0;19;0
WireConnection;48;0;69;0
WireConnection;48;1;2;0
WireConnection;61;0;51;0
WireConnection;34;0;20;0
WireConnection;34;1;2;0
WireConnection;60;1;48;0
WireConnection;60;2;61;0
WireConnection;26;0;25;0
WireConnection;44;0;26;0
WireConnection;44;1;34;0
WireConnection;44;2;59;0
WireConnection;62;0;60;0
WireConnection;0;0;44;0
WireConnection;0;2;44;0
WireConnection;0;9;62;0
ASEEND*/
//CHKSM=125112338E2A5C7A1ACC4CA86B31EAF2EE9B697A