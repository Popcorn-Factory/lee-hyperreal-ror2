// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Community/Melting"
{
	Properties
	{
		[HDR]_BaseColor("Base Color", Color) = (0.05136246,0.1295507,0.2794118,0)
		[NoScaleOffset]_BaseNormal("Base Normal", 2D) = "bump" {}
		[HDR]_Color1("Color 1", Color) = (1,0,0,0)
		[HDR]_Color2("Color 2", Color) = (1,1,0,0)
		[NoScaleOffset]_DisplaceNoise("Displace Noise", 2D) = "white" {}
		_NoiseScale("NoiseScale", Range( 0 , 0.1)) = 0
		_Limit("Limit", Range( 0 , 3)) = 2
		_Oscillation("Oscillation", Range( 0 , 3)) = 2
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_NoiseMultiply("Noise Multiply", Float) = 0
		[Toggle]_AnimatedMelt("Animated Melt", Float) = 1
		_ManualControl("Manual Control", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _DisplaceNoise;
		uniform float _AnimatedMelt;
		uniform float _ManualControl;
		uniform float _Oscillation;
		uniform float _Limit;
		uniform float _NoiseScale;
		uniform float _NoiseMultiply;
		uniform sampler2D _BaseNormal;
		uniform float4 _BaseColor;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _Metallic;
		uniform float _Smoothness;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			half3 ase_vertexNormal = v.normal.xyz;
			half dotResult78 = dot( ase_vertexNormal , float3(0,1,0) );
			float3 ase_vertex3Pos = v.vertex.xyz;
			half2 appendResult61 = (half2(( ase_vertex3Pos.x + (( _AnimatedMelt )?( ( ( _SinTime.z * _Oscillation ) + _Limit ) ):( _ManualControl )) ) , ase_vertex3Pos.z));
			half4 tex2DNode58 = tex2Dlod( _DisplaceNoise, float4( ( appendResult61 * _NoiseScale ), 0, 0.0) );
			half temp_output_72_0 = ( ( tex2DNode58.g * _NoiseMultiply ) + (( _AnimatedMelt )?( ( ( _SinTime.z * _Oscillation ) + _Limit ) ):( _ManualControl )) );
			float Vertex1106 = ase_vertex3Pos.y;
			half4 appendResult82 = (half4(0.0 , ( ( dotResult78 * 0.05 ) + min( ( temp_output_72_0 - Vertex1106 ) , 0.0 ) ) , 0.0 , 0.0));
			half smoothstepResult88 = smoothstep( ( temp_output_72_0 - 0.2 ) , ( temp_output_72_0 + 0.2 ) , Vertex1106);
			float SmoothStep2112 = smoothstepResult88;
			v.vertex.xyz += ( appendResult82 * SmoothStep2112 ).xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseNormal122 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _BaseNormal, uv_BaseNormal122 ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			half2 appendResult61 = (half2(( ase_vertex3Pos.x + (( _AnimatedMelt )?( ( ( _SinTime.z * _Oscillation ) + _Limit ) ):( _ManualControl )) ) , ase_vertex3Pos.z));
			half4 tex2DNode58 = tex2D( _DisplaceNoise, ( appendResult61 * _NoiseScale ) );
			half temp_output_72_0 = ( ( tex2DNode58.g * _NoiseMultiply ) + (( _AnimatedMelt )?( ( ( _SinTime.z * _Oscillation ) + _Limit ) ):( _ManualControl )) );
			float Vertex1106 = ase_vertex3Pos.y;
			half smoothstepResult92 = smoothstep( ( temp_output_72_0 - 0.5 ) , ( temp_output_72_0 + 0.5 ) , Vertex1106);
			float SmoothStep1110 = smoothstepResult92;
			o.Albedo = ( _BaseColor * saturate( ( 1.0 - ( 5.0 * SmoothStep1110 ) ) ) ).rgb;
			half4 temp_cast_1 = (tex2DNode58.g).xxxx;
			half smoothstepResult88 = smoothstep( ( temp_output_72_0 - 0.2 ) , ( temp_output_72_0 + 0.2 ) , Vertex1106);
			float SmoothStep2112 = smoothstepResult88;
			half4 lerpResult56 = lerp( _Color1 , ( _Color2 * CalculateContrast(0.0,temp_cast_1) ) , SmoothStep2112);
			o.Emission = ( lerpResult56 * SmoothStep1110 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
Node;AmplifyShaderEditor.SinTimeNode;101;-3810.807,914.866;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;68;-3813.511,1111.719;Float;False;Property;_Oscillation;Oscillation;8;0;Create;True;0;0;0;False;0;False;2;2.24;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-3483.519,960.7067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-3620.55,1231.97;Float;False;Property;_Limit;Limit;7;0;Create;True;0;0;0;False;0;False;2;2.78;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-3324.453,832.0427;Float;False;Property;_ManualControl;Manual Control;13;0;Create;True;0;0;0;False;0;False;0;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-3270.364,945.3262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;103;-2928,640;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;124;-2960,832;Float;False;Property;_AnimatedMelt;Animated Melt;12;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2700.144,650.3508;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2538.026,889.3254;Float;False;Property;_NoiseScale;NoiseScale;6;0;Create;True;0;0;0;False;0;False;0;0.0527;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-2531.79,763.9691;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-2338.073,713.1436;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;58;-2153.503,727.1264;Inherit;True;Property;_DisplaceNoise;Displace Noise;5;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4d85556227fd4d5a8f034d10f4261675;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;121;-1974.133,1046.565;Float;False;Property;_NoiseMultiply;Noise Multiply;11;0;Create;True;0;0;0;False;0;False;0;1.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;70;-1250.901,939.8544;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1739.151,913.1738;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1197.014,1453.799;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1036.462,953.9698;Float;False;Vertex1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1166.786,1657.16;Float;False;Constant;_Float6;Float 6;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;90;-883.028,1622.163;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-893.2176,1756.326;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-904.8461,1532.988;Inherit;False;106;Vertex1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;92;-453.3835,1645.252;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1122.48,1256.421;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-220.0436,1604.104;Float;False;SmoothStep1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-815.2325,1180.366;Inherit;False;106;Vertex1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;74;-796.3981,1264.791;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;77;-1085.352,753.415;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;76;-1093.539,569.2209;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-757.7103,1383.554;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;88;-567.4893,1335.979;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-823.8184,785.6821;Float;False;Constant;_Float3;Float 3;5;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-762.6805,1045.517;Float;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1116.777,-123.0787;Inherit;False;110;SmoothStep1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;78;-835.7063,646.4243;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1132.116,-217.6887;Float;False;Constant;_AlbedoSmoothness;Albedo Smoothness;1;0;Create;True;0;0;0;False;0;False;5;14.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;85;-767.7754,941.9226;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-839.1805,-121.5225;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-611.5348,666.8034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;54;-1124.427,163.7239;Float;False;Property;_Color2;Color 2;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,0,0;12.51701,11.65377,0,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleContrastOpNode;57;-1099.259,384.6501;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMinOpNode;84;-550.3973,921.5436;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-273.1816,1330.431;Float;False;SmoothStep2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-794.4365,229.4424;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-395.8549,811.1561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;-1127.241,-41.60062;Float;False;Property;_Color1;Color 1;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;1.354,0.3081514,0,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;49;-654.6093,-104.7433;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-751.7337,380.0894;Inherit;False;112;SmoothStep2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-445.7439,384.5448;Inherit;False;110;SmoothStep1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-192.5783,887.3002;Inherit;False;112;SmoothStep2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-209.8739,697.6317;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;48;-425.2932,-113.1329;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;-1134.215,-431.9377;Float;False;Property;_BaseColor;Base Color;1;1;[HDR];Create;True;0;0;0;False;0;False;0.05136246,0.1295507,0.2794118,0;0.2647056,0.2647056,0.2647056,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;56;-513.6298,187.4719;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-212.7563,103.5981;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;115;31.33832,348.154;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;0;False;0;False;0;0.6536242;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;45.73086,680.5845;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;59;-3136.419,683.5956;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;116;43.33832,235.154;Float;False;Property;_Metallic;Metallic;10;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;122;-240.494,-92.57401;Inherit;True;Property;_BaseNormal;Base Normal;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;bec834914d444ee688f9583988f45e43;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-209.9603,-191.4359;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;15;645.6053,-17.79857;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Community/Melting;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;5;False;;7;False;;5;False;;5;False;;1;False;0.1;1,1,0,0;VertexScale;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;67;0;101;3
WireConnection;67;1;68;0
WireConnection;62;0;67;0
WireConnection;62;1;69;0
WireConnection;124;0;123;0
WireConnection;124;1;62;0
WireConnection;60;0;103;1
WireConnection;60;1;124;0
WireConnection;61;0;60;0
WireConnection;61;1;103;3
WireConnection;64;0;61;0
WireConnection;64;1;63;0
WireConnection;58;1;64;0
WireConnection;120;0;58;2
WireConnection;120;1;121;0
WireConnection;72;0;120;0
WireConnection;72;1;124;0
WireConnection;106;0;70;2
WireConnection;90;0;72;0
WireConnection;90;1;89;0
WireConnection;91;0;72;0
WireConnection;91;1;89;0
WireConnection;92;0;108;0
WireConnection;92;1;90;0
WireConnection;92;2;91;0
WireConnection;110;0;92;0
WireConnection;74;0;72;0
WireConnection;74;1;71;0
WireConnection;75;0;72;0
WireConnection;75;1;71;0
WireConnection;88;0;107;0
WireConnection;88;1;74;0
WireConnection;88;2;75;0
WireConnection;78;0;76;0
WireConnection;78;1;77;0
WireConnection;85;0;72;0
WireConnection;85;1;106;0
WireConnection;50;0;51;0
WireConnection;50;1;111;0
WireConnection;80;0;78;0
WireConnection;80;1;79;0
WireConnection;57;1;58;2
WireConnection;84;0;85;0
WireConnection;84;1;86;0
WireConnection;112;0;88;0
WireConnection;55;0;54;0
WireConnection;55;1;57;0
WireConnection;81;0;80;0
WireConnection;81;1;84;0
WireConnection;49;0;50;0
WireConnection;82;1;81;0
WireConnection;48;0;49;0
WireConnection;56;0;53;0
WireConnection;56;1;55;0
WireConnection;56;2;114;0
WireConnection;65;0;56;0
WireConnection;65;1;109;0
WireConnection;83;0;82;0
WireConnection;83;1;113;0
WireConnection;47;0;52;0
WireConnection;47;1;48;0
WireConnection;15;0;47;0
WireConnection;15;1;122;0
WireConnection;15;2;65;0
WireConnection;15;3;116;0
WireConnection;15;4;115;0
WireConnection;15;11;83;0
ASEEND*/
//CHKSM=1BA0BC50D9B2BF1C912E981CFD6E29B745230D06