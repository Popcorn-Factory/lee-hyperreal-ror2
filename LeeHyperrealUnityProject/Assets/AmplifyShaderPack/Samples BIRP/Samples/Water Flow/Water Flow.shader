// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Water Flow"
{
	Properties
	{
		_Size("Size", Range( 0 , 10)) = 1
		_FlowMap("Flow Map", 2D) = "white" {}
		_FlowSpeed("Flow Speed", Float) = 0
		_FlowStrength("Flow Strength", Vector) = (0,0,0,0)
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 1)) = 0
		_NormalStrength("Normal Strength", Range( 0 , 1)) = 0
		_Tiling("Tiling", Float) = 1
		_RiverColor("River Color", Color) = (0.5235849,0.8206437,1,0)
		_FadeDistance("Fade Distance", Float) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float4 _RiverColor;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Normal;
		uniform float _Tiling;
		uniform float _Size;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float2 _FlowStrength;
		uniform float _FlowSpeed;
		uniform float _NormalScale;
		uniform float _NormalStrength;
		uniform float _Metallic;
		uniform float _Smoothness;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FadeDistance;


inline float4 ASE_ComputeGrabScreenPos( float4 pos )
{
	#if UNITY_UV_STARTS_AT_TOP
	float scale = -1.0;
	#else
	float scale = 1.0;
	#endif
	float4 o = pos;
	o.y = pos.w * 0.5f;
	o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
	return o;
}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 temp_cast_1 = (_Tiling).xx;
			float2 uv_TexCoord26 = i.uv_texcoord * temp_cast_1;
			float2 temp_output_4_0_g21 = (( uv_TexCoord26 / _Size )).xy;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 temp_output_17_0_g21 = _FlowStrength;
			float mulTime22_g21 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g21 = frac( mulTime22_g21 );
			float2 temp_output_11_0_g21 = ( temp_output_4_0_g21 + ( -((tex2D( _FlowMap, uv_FlowMap )).rg*2.0 + -1.0) * temp_output_17_0_g21 * temp_output_27_0_g21 ) );
			float temp_output_55_0_g21 = _NormalScale;
			float2 temp_output_12_0_g21 = ( temp_output_4_0_g21 + ( -((tex2D( _FlowMap, uv_FlowMap )).rg*2.0 + -1.0) * temp_output_17_0_g21 * frac( ( mulTime22_g21 + 0.5 ) ) ) );
			float3 lerpResult9_g21 = lerp( UnpackScaleNormal( tex2D( _Normal, temp_output_11_0_g21 ), temp_output_55_0_g21 ) , UnpackScaleNormal( tex2D( _Normal, temp_output_12_0_g21 ), temp_output_55_0_g21 ) , ( abs( ( temp_output_27_0_g21 - 0.5 ) ) / 0.5 ));
			float4 screenColor49 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( (ase_grabScreenPosNorm).xy ,  0.0 ) + ( lerpResult9_g21 * _NormalStrength ) ).xy);
			o.Albedo = ( _RiverColor * screenColor49 ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth59 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth59 = saturate( ( screenDepth59 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FadeDistance ) );
			o.Alpha = distanceDepth59;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				float4 screenPos : TEXCOORD3;
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.screenPos = IN.screenPos;
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
Node;AmplifyShaderEditor.RangedFloatNode;27;-1089.6,313.4001;Inherit;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1095.199,525.8004;Inherit;True;Property;_FlowMap;Flow Map;3;0;Create;True;0;0;0;False;0;False;-1;None;857a3925d05e5ff4f82825804691c22e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.Vector2Node;25;-1079.199,717.8004;Inherit;False;Property;_FlowStrength;Flow Strength;5;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SwizzleNode;8;-807.2,541.8004;Inherit;False;FLOAT2;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1095.199,429.8001;Inherit;False;Property;_NormalScale;Normal Scale;7;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1079.199,109.8;Inherit;True;Property;_Normal;Normal;6;0;Create;True;0;0;0;False;0;False;None;b253eb6675e043b9870a2bbd48feb6f8;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-951.2,301.8001;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1079.199,861.8004;Inherit;False;Property;_FlowSpeed;Flow Speed;4;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-388.175,639.53;Inherit;False;Property;_NormalStrength;Normal Strength;8;0;Create;True;0;0;0;False;0;False;0;0.094;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;62;-402.4769,355.0725;Inherit;False;Flow;0;;21;acad10cc8145e1f4eb8042bebe2d9a42;2,50,1,51,1;6;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;48;-414.0238,123.406;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;52;-175.0238,158.406;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-108.175,490.53;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;88.9762,284.406;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;44;58.5979,-88.01421;Inherit;False;Property;_RiverColor;River Color;10;0;Create;True;0;0;0;False;0;False;0.5235849,0.8206437,1,0;0.4158506,0.7720793,0.990566,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ScreenColorNode;49;246.9762,244.406;Inherit;False;Global;_GrabScreen0;Grab Screen 0;8;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;0.2246094,652.6239;Inherit;False;Property;_FadeDistance;Fade Distance;11;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;59;237.2976,561.0507;Inherit;False;True;True;False;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;507.9473,169.3208;Inherit;False;Property;_Metallic;Metallic;13;0;Create;True;0;0;0;False;0;False;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;435.9762,54.40601;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;439.7763,294.4708;Inherit;False;Property;_Smoothness;Smoothness;12;0;Create;True;0;0;0;False;0;False;0;0.33;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;830.5793,81.59274;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Water Flow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;26;0;27;0
WireConnection;62;5;3;0
WireConnection;62;2;26;0
WireConnection;62;55;42;0
WireConnection;62;18;8;0
WireConnection;62;17;25;0
WireConnection;62;24;22;0
WireConnection;52;0;48;0
WireConnection;55;0;62;0
WireConnection;55;1;56;0
WireConnection;51;0;52;0
WireConnection;51;1;55;0
WireConnection;49;0;51;0
WireConnection;59;0;60;0
WireConnection;50;0;44;0
WireConnection;50;1;49;0
WireConnection;0;0;50;0
WireConnection;0;3;58;0
WireConnection;0;4;57;0
WireConnection;0;9;59;0
ASEEND*/
//CHKSM=350E737D017822B1F4A7F18CC2F41CA5FAFECB4B