// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Interior Mapping/LatLong"
{
	Properties
	{
		_RoomCountX("Room Count X", Float) = 4
		_RoomCountY("Room Count Y", Float) = 4
		[SingleLineTexture]_LatLongMap0("LatLong Map", 2D) = "white" {}
		_Brightness0("Brightness", Range( 0 , 2)) = 1
		[SingleLineTexture]_LatLongMap1("LatLong Map", 2D) = "white" {}
		_Brightness1("Brightness", Range( 0 , 2)) = 1
		[SingleLineTexture]_LatLongMap2("LatLong Map", 2D) = "white" {}
		_Brightness2("Brightness", Range( 0 , 2)) = 1
		[Header(FACADE)][ToggleUI]_EnableFacade("Enable Facade", Float) = 0
		[SingleLineTexture]_FacadeMap("Facade Map", 2D) = "white" {}
		_FacadeTilling("Facade Tilling", Vector) = (1,1,0,0)
		[SingleLineTexture]_Roof("Roof", 2D) = "white" {}
		_EmissiveIntensity("Emissive Intensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform sampler2D _LatLongMap0;
		uniform float _RoomCountX;
		uniform float _RoomCountY;
		uniform half _Brightness0;
		uniform sampler2D _LatLongMap1;
		uniform half _Brightness1;
		uniform sampler2D _LatLongMap2;
		uniform half _Brightness2;
		uniform sampler2D _FacadeMap;
		uniform float4 _FacadeTilling;
		uniform float _EnableFacade;
		uniform sampler2D _Roof;
		uniform float4 _Roof_ST;
		uniform half _EmissiveIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir182_g135 = mul( ase_worldToTangent, reflect( ase_worldViewDir , ase_normWorldNormal ));
			float3 temp_output_173_0_g135 = ( float3( 1,1,1 ) / ( worldToTangentDir182_g135 * float3( -1,1,1 ) ) );
			float2 temp_output_62_0_g135 = i.uv_texcoord;
			float2 appendResult182 = (float2(_RoomCountX , _RoomCountY));
			float2 temp_output_170_0_g135 = ( temp_output_62_0_g135 * appendResult182 );
			float2 temp_output_167_0_g135 = ( ( frac( temp_output_170_0_g135 ) * float2( 2,-2 ) ) - float2( 1,-1 ) );
			float3 appendResult199_g135 = (float3(temp_output_167_0_g135 , -1.0));
			float3 break197_g135 = ( abs( temp_output_173_0_g135 ) - ( temp_output_173_0_g135 * appendResult199_g135 ) );
			float2 appendResult192_g135 = (float2(( atan2( break197_g135.z , break197_g135.x ) + 1.570796 ) , ( ( -0.5 * UNITY_PI ) + asin( (worldToTangentDir182_g135).y ) )));
			float2 temp_output_417_56 = ( ( appendResult192_g135 + temp_output_167_0_g135 ) * float2( 0.1591549,-0.3183099 ) );
			float2 temp_output_417_201 = ddx( temp_output_62_0_g135 );
			float2 temp_output_417_202 = ddy( temp_output_62_0_g135 );
			float2 break164_g135 = floor( temp_output_170_0_g135 );
			float3 appendResult159_g135 = (float3(break164_g135.x , break164_g135.y , break164_g135.x));
			float dotResult158_g135 = dot( appendResult159_g135 , float3(127.1,311.7,74.7) );
			float3 appendResult124_g135 = (float3(break164_g135.y , break164_g135.x , break164_g135.x));
			float dotResult125_g135 = dot( appendResult124_g135 , float3(269.5,183.3,246.1) );
			float3 appendResult128_g135 = (float3(break164_g135.x , break164_g135.y , break164_g135.y));
			float dotResult127_g135 = dot( appendResult128_g135 , float3(113.5,271.9,124.6) );
			float3 appendResult126_g135 = (float3(dotResult158_g135 , dotResult125_g135 , dotResult127_g135));
			float3 break385 = round( frac( ( sin( appendResult126_g135 ) * 43758.55 ) ) );
			float4 lerpResult384 = lerp( ( tex2D( _LatLongMap0, temp_output_417_56, temp_output_417_201, temp_output_417_202 ) * _Brightness0 ) , ( tex2D( _LatLongMap1, temp_output_417_56, temp_output_417_201, temp_output_417_202 ) * _Brightness1 ) , break385.y);
			float4 lerpResult390 = lerp( lerpResult384 , ( tex2D( _LatLongMap2, temp_output_417_56, temp_output_417_201, temp_output_417_202 ) * _Brightness2 ) , break385.z);
			float3 temp_output_31_0 = (lerpResult390).rgb;
			float3 InteriorMapping403 = temp_output_31_0;
			float4 tex2DNode178 = tex2D( _FacadeMap, ( ( i.uv_texcoord * (_FacadeTilling).xy ) + (_FacadeTilling).zw ) );
			float fresnelNdotV27 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode27 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV27 , 0.0001 ), 0.1 ) );
			float temp_output_25_0 = ( ( tex2DNode178.a * 0.2 ) * ( 1.0 - fresnelNode27 ) );
			float3 lerpResult80 = lerp( (tex2DNode178).rgb , temp_output_31_0 , temp_output_25_0);
			float3 Facade86 = lerpResult80;
			float3 lerpResult408 = lerp( InteriorMapping403 , Facade86 , _EnableFacade);
			float2 uv_Roof = i.uv_texcoord * _Roof_ST.xy + _Roof_ST.zw;
			float4 lerpResult195 = lerp( float4( lerpResult408 , 0.0 ) , tex2D( _Roof, uv_Roof ) , ase_worldNormal.y);
			o.Albedo = lerpResult195.rgb;
			float3 Emission85 = ( ( ( temp_output_25_0 * temp_output_31_0 ) * round( break385.y ) ) * _EmissiveIntensity );
			float3 lerpResult411 = lerp( float3( 0,0,0 ) , Emission85 , _EnableFacade);
			float3 lerpResult203 = lerp( lerpResult411 , float3( 0,0,0 ) , ase_worldNormal.y);
			o.Emission = lerpResult203;
			float FacadeAlpha175 = tex2DNode178.a;
			float lerpResult412 = lerp( 0.0 , FacadeAlpha175 , _EnableFacade);
			float lerpResult204 = lerp( lerpResult412 , 0.0 , ase_worldNormal.y);
			o.Metallic = lerpResult204;
			o.Smoothness = lerpResult204;
			o.Alpha = 1;
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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
Node;AmplifyShaderEditor.TexCoordVertexDataNode;21;-2631.686,101.5328;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;180;-2702.235,728.3512;Inherit;False;Property;_RoomCountX;Room Count X;0;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-2703.423,802.0394;Inherit;False;Property;_RoomCountY;Room Count Y;1;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;398;-2400.619,162.8539;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;-2529.77,754.4984;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;399;-2397.202,720.6578;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;381;-2344.299,1101.124;Inherit;True;Property;_LatLongMap1;LatLong Map;4;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;48de6c31db55ac946a2eb4671db8c0d2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;308;-2344.047,906.6677;Inherit;True;Property;_LatLongMap0;LatLong Map;2;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;48de6c31db55ac946a2eb4671db8c0d2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;417;-2350.25,731.2563;Inherit;False;UV Interior LatLong;12;;135;50f8fdc498805ca4f82dcfe307e97b3c;0;2;62;FLOAT2;0,0;False;58;FLOAT2;1,1;False;4;FLOAT2;56;FLOAT2;201;FLOAT2;202;FLOAT3;61
Node;AmplifyShaderEditor.SamplerNode;303;-2049.472,905.6858;Inherit;True;Property;_TextureSample9;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;382;-2049.724,1100.142;Inherit;True;Property;_TextureSample10;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;396;-1742.928,1186.171;Half;False;Property;_Brightness1;Brightness;5;0;Create;False;1;;0;0;False;0;False;1;0.829;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;388;-2351.082,1300.464;Inherit;True;Property;_LatLongMap2;LatLong Map;6;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;48de6c31db55ac946a2eb4671db8c0d2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;395;-1734.554,975.0402;Half;False;Property;_Brightness0;Brightness;3;0;Create;False;1;;0;0;False;0;False;1;0.885;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;414;-2340.219,171.2385;Inherit;False;Property;_FacadeTilling;Facade Tilling;10;0;Create;True;0;0;0;False;0;False;1,1,0,0;2,2,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;389;-2056.507,1299.481;Inherit;True;Property;_TextureSample11;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;-1447.147,911.5038;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;386;-1451.329,1103.604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;397;-1742.928,1382.971;Half;False;Property;_Brightness2;Brightness;7;0;Create;False;1;;0;0;False;0;False;1;0.81;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;385;-1405.7,801.5403;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SwizzleNode;415;-2143.219,172.2385;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;384;-1242.32,914.4339;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;-1444.147,1301.504;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;400;-1293.905,1241.867;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1991.51,101.0095;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;416;-2144.219,239.2385;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;390;-1057.158,1275.15;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;413;-1851.316,223.0391;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;177;-1701.869,56.90602;Inherit;True;Property;_FacadeMap;Facade Map;9;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SwizzleNode;31;-891.1507,1270.716;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;178;-1439.713,189.3721;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FresnelNode;27;-1546.142,415.6824;Inherit;False;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1104.42,358.5286;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-1307.4,415.6824;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;404;-735.4983,1243.908;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-948.9343,389.3534;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;406;-747.2258,731.9032;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-698.5188,647.7185;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RoundOpNode;82;-695.0079,822.9309;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;405;-738.2256,1242.544;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;23;-954.9197,191.9138;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-520.1293,648.0744;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;407;-765.4988,457.0824;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;401;-488.754,748.3572;Half;False;Property;_EmissiveIntensity;Emissive Intensity;14;0;Create;False;1;;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;-723.4825,343.9058;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-236.1867,649.1227;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;20;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-548.3148,340.0391;Inherit;False;Facade;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-79.98962,646.7397;Inherit;False;Emission;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;403;-644.7704,1268.617;Inherit;False;InteriorMapping;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-1111.493,282.1353;Inherit;False;FacadeAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;193;-1392.342,-652.8132;Inherit;True;Property;_Roof;Roof;11;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;aab8de1052c54173b3d61e7f8b05aedf;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;174;-738.2293,-448.5724;Inherit;False;85;Emission;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-751.9572,-262.1953;Inherit;False;175;FacadeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;409;-758.6528,-764.2744;Inherit;False;403;InteriorMapping;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-721.5466,-693.8452;Inherit;False;86;Facade;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-734.6428,-870.849;Inherit;False;Property;_EnableFacade;Enable Facade;8;2;[Header];[ToggleUI];Create;True;1;FACADE;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;192;-1122.851,-652.2434;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;411;-514.1347,-466.6655;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;412;-508.9773,-278.9892;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;194;-454.5716,-124.3459;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;408;-506.1104,-757.513;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;195;-253.8103,-670.6556;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;203;-251.1513,-465.8329;Inherit;False;3;0;FLOAT3;1,1,1;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;204;-242.9325,-304.3791;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4.743328,-671.4097;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASE/Interior Mapping/LatLong;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;398;0;21;0
WireConnection;182;0;180;0
WireConnection;182;1;181;0
WireConnection;399;0;398;0
WireConnection;417;62;399;0
WireConnection;417;58;182;0
WireConnection;303;0;308;0
WireConnection;303;1;417;56
WireConnection;303;3;417;201
WireConnection;303;4;417;202
WireConnection;303;7;308;1
WireConnection;382;0;381;0
WireConnection;382;1;417;56
WireConnection;382;3;417;201
WireConnection;382;4;417;202
WireConnection;382;7;381;1
WireConnection;389;0;388;0
WireConnection;389;1;417;56
WireConnection;389;3;417;201
WireConnection;389;4;417;202
WireConnection;389;7;388;1
WireConnection;392;0;303;0
WireConnection;392;1;395;0
WireConnection;386;0;382;0
WireConnection;386;1;396;0
WireConnection;385;0;417;61
WireConnection;415;0;414;0
WireConnection;384;0;392;0
WireConnection;384;1;386;0
WireConnection;384;2;385;1
WireConnection;393;0;389;0
WireConnection;393;1;397;0
WireConnection;400;0;385;2
WireConnection;22;0;21;0
WireConnection;22;1;415;0
WireConnection;416;0;414;0
WireConnection;390;0;384;0
WireConnection;390;1;393;0
WireConnection;390;2;400;0
WireConnection;413;0;22;0
WireConnection;413;1;416;0
WireConnection;31;0;390;0
WireConnection;178;0;177;0
WireConnection;178;1;413;0
WireConnection;178;7;177;1
WireConnection;24;0;178;4
WireConnection;26;0;27;0
WireConnection;404;0;31;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;406;0;404;0
WireConnection;29;0;25;0
WireConnection;29;1;406;0
WireConnection;82;0;385;1
WireConnection;405;0;31;0
WireConnection;23;0;178;0
WireConnection;83;0;29;0
WireConnection;83;1;82;0
WireConnection;407;0;405;0
WireConnection;80;0;23;0
WireConnection;80;1;407;0
WireConnection;80;2;25;0
WireConnection;84;0;83;0
WireConnection;84;1;401;0
WireConnection;86;0;80;0
WireConnection;85;0;84;0
WireConnection;403;0;31;0
WireConnection;175;0;178;4
WireConnection;192;0;193;0
WireConnection;192;7;193;1
WireConnection;411;1;174;0
WireConnection;411;2;402;0
WireConnection;412;1;176;0
WireConnection;412;2;402;0
WireConnection;408;0;409;0
WireConnection;408;1;173;0
WireConnection;408;2;402;0
WireConnection;195;0;408;0
WireConnection;195;1;192;0
WireConnection;195;2;194;2
WireConnection;203;0;411;0
WireConnection;203;2;194;2
WireConnection;204;0;412;0
WireConnection;204;2;194;2
WireConnection;0;0;195;0
WireConnection;0;2;203;0
WireConnection;0;3;204;0
WireConnection;0;4;204;0
ASEEND*/
//CHKSM=9B782F29C3E771D15DD22C8F353894657FCAEC2B