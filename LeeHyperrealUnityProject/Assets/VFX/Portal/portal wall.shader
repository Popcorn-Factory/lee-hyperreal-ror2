// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "portal wall"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_speedportal("speed portal", Range( -10 , 10)) = -0.2
		_speedparalax("speed paralax", Range( -10 , 10)) = -0.2
		_Float2("Float 2", Range( 0.99 , 2)) = 0.68
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_minimumemission("minimum emission", Range( 0 , 20)) = 0
		_maximumemission("maximum emission", Range( 0 , 20)) = 0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Paralaxoffsetscale("Paralax offset scale", Range( 0 , 10)) = 0
		_Float12("Float 12", Range( 0 , 3)) = 2.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref 1
		}
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
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
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform float _minimumemission;
		uniform float _maximumemission;
		uniform sampler2D _TextureSample0;
		uniform float _speedportal;
		uniform sampler2D _TextureSample3;
		uniform float _speedparalax;
		uniform float _Float12;
		uniform float _Paralaxoffsetscale;
		uniform sampler2D _TextureSample1;
		uniform float _Float2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float4 appendResult13 = (float4(( _Time.y * _speedportal ) , ( _Time.y * 0.05 ) , 0.0 , 0.0));
			float2 uv_TexCoord5 = i.uv_texcoord * float2( 2,1 ) + appendResult13.xy;
			float4 appendResult85 = (float4(( _Time.y * _speedparalax ) , ( _Time.y * 0.0 ) , 0.0 , 0.0));
			float2 uv_TexCoord144 = i.uv_texcoord * float2( 2,1 ) + appendResult85.xy;
			float cos139 = cos( _Float12 );
			float sin139 = sin( _Float12 );
			float2 rotator139 = mul( uv_TexCoord144 - float2( 0.5,0.5 ) , float2x2( cos139 , -sin139 , sin139 , cos139 )) + float2( 0.5,0.5 );
			float4 tex2DNode77 = tex2D( _TextureSample3, rotator139 );
			float2 paralaxOffset97 = ParallaxOffset( tex2DNode77.g , _Paralaxoffsetscale , i.viewDir );
			float temp_output_49_0 = ( _Time.y * -0.1 );
			float4 appendResult48 = (float4(temp_output_49_0 , ( temp_output_49_0 * -0.5 ) , 0.0 , 0.0));
			float2 uv_TexCoord45 = i.uv_texcoord * float2( 1,1 ) + appendResult48.xy;
			float4 temp_cast_3 = (-0.3).xxxx;
			float4 temp_cast_4 = (2.5).xxxx;
			o.Emission = ( (_minimumemission + (_SinTime.w - -1.0) * (_maximumemission - _minimumemission) / (1.0 - -1.0)) * tex2D( _TextureSample0, ( uv_TexCoord5 + ( i.uv_texcoord + paralaxOffset97 ) ) ) * (temp_cast_3 + (tex2D( _TextureSample1, uv_TexCoord45 ) - float4( 0,0,0,0 )) * (temp_cast_4 - temp_cast_3) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) ).rgb;
			o.Metallic = 1.0;
			float clampResult35 = clamp( floor( ( _Float2 - i.uv_texcoord.x ) ) , 0.0 , 1.0 );
			o.Alpha = clampResult35;
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
Version=19201
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1350.381,771.372;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;-1059.365,539.0262;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-572.6715,307.4212;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;36;-839.4734,397.0233;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1508.7,530.0329;Inherit;False;Property;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0.68;2;0.99;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;633.5609,-450.2505;Inherit;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;0;False;0;False;-0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;443.3568,-807.9479;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-649.379,-1327.395;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-831.3138,-995.1359;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;47;-1420.961,-1193.053;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;48;-928.8568,-1238.376;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1163.524,-1204.731;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1044.883,-854.6403;Inherit;False;Constant;_Float5;Float 1;2;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1358.233,-938.8688;Inherit;False;Constant;_Float6;Float 6;3;0;Create;True;0;0;0;False;0;False;-0.1;0.2;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;446.7669,-324.2815;Inherit;False;Constant;_Float7;Float 7;6;0;Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;55;-245.4799,-1020.255;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-491.2799,-865.6191;Inherit;False;Constant;_Float8;Float 8;6;0;Create;True;0;0;0;False;0;False;25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;52;-1009.307,-1498.925;Inherit;False;Constant;_Vector1;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;22;-804.6345,-530.329;Inherit;False;Property;_emissionstrength;emission strength;2;0;Create;True;0;0;0;False;0;False;2;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-654.501,-824.916;Inherit;False;Constant;_Float9;Float 9;6;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;59;-823.501,-691.916;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;58;-134.3006,-751.9617;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;65cb3e533a728e446bf24e500fbde44f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;60;-350.501,-600.916;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-628.501,-757.916;Inherit;False;Property;_minimumemission;minimum emission;7;0;Create;True;0;0;0;False;0;False;0;0.6;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-619.501,-640.916;Inherit;False;Property;_maximumemission;maximum emission;8;0;Create;True;0;0;0;False;0;False;0;2;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-471.8166,-170.6936;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-353.1617,112.9713;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-1105.82,-190.766;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-1291.638,160.5578;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-2043.639,128.5578;Inherit;False;Property;_Paralaxoffsetscale;Paralax offset scale;11;0;Create;True;0;0;0;False;0;False;0;0.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;97;-1595.64,240.5573;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;99;-1737.34,-29.54223;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.EdgeLengthTessNode;130;-819.8035,169.8934;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-1003.07,263.3498;Inherit;False;Constant;_Float11;Float 11;17;0;Create;True;0;0;0;False;0;False;200;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;96;-2008.639,324.5573;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-853.6622,-125.0895;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;bf43e88be8c510748a7ce4306714b0b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;93;-3215.623,-201.0098;Inherit;False;Property;_heightdistance;height distance;13;0;Create;True;0;0;0;False;0;False;0;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-2687.624,-105.0095;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-3547.67,-403.9858;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;80;-3707.67,-387.9857;Inherit;False;Property;_Tiling;Tiling;12;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ParallaxMappingNode;76;-3364.457,-606.5524;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-3828.455,-670.5525;Inherit;False;Property;_Paralax;Paralax;10;0;Create;True;0;0;0;False;0;False;0;0.3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;75;-3732.457,-574.5526;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-3640.996,727.823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-3738.537,484.5826;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3854.563,868.3184;Inherit;False;Constant;_Float10;Float 1;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;139;-3153.235,349.5128;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;144;-2812.237,617.513;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;84;-4326.179,459.6538;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-3974.089,593.3283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-3251.236,738.5129;Inherit;False;Property;_Float12;Float 12;14;0;Create;True;0;0;0;False;0;False;2.1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-4274.913,801.0896;Inherit;False;Property;_speedparalax;speed paralax;4;0;Create;True;0;0;0;False;0;False;-0.2;0.3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;140;-3438.236,579.5128;Inherit;False;Constant;_Vector3;Vector 3;17;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;145;-3375.505,863.63;Inherit;False;Constant;_tilingparalax;tiling paralax;17;0;Create;True;0;0;0;False;0;False;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;77;-2940.924,154.1363;Inherit;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;0;False;0;False;-1;None;0dad9e7949ffefd48954a1359652102c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-86.43594,-11.18001;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;portal wall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.36;True;True;0;True;TransparentCutout;;Transparent;All;12;all;True;True;True;True;0;False;;True;1;False;;255;False;;255;False;_Float3;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;5;False;;10;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.Vector2Node;33;-1562.164,-814.4914;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1384.171,-310.7026;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;7;-1973.818,-508.6202;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1481.714,-553.9426;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1716.381,-520.2981;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1911.09,-254.4354;Inherit;False;Property;_speedportal;speed portal;3;0;Create;True;0;0;0;False;0;False;-0.2;-0.3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1202.236,-642.9619;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1597.74,-170.207;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
WireConnection;26;0;25;0
WireConnection;26;1;24;1
WireConnection;35;0;36;0
WireConnection;36;0;26;0
WireConnection;39;0;58;0
WireConnection;39;3;43;0
WireConnection;39;4;54;0
WireConnection;45;0;52;0
WireConnection;45;1;48;0
WireConnection;46;0;49;0
WireConnection;46;1;50;0
WireConnection;48;0;49;0
WireConnection;48;1;46;0
WireConnection;49;0;47;2
WireConnection;49;1;51;0
WireConnection;55;1;56;0
WireConnection;58;1;45;0
WireConnection;60;0;59;4
WireConnection;60;1;61;0
WireConnection;60;3;62;0
WireConnection;60;4;63;0
WireConnection;21;0;60;0
WireConnection;21;1;4;0
WireConnection;21;2;39;0
WireConnection;91;0;5;0
WireConnection;91;1;100;0
WireConnection;100;0;99;0
WireConnection;100;1;97;0
WireConnection;97;0;77;2
WireConnection;97;1;98;0
WireConnection;97;2;96;0
WireConnection;130;0;132;0
WireConnection;4;1;91;0
WireConnection;94;0;93;0
WireConnection;94;1;77;1
WireConnection;81;0;77;3
WireConnection;76;0;81;0
WireConnection;76;1;94;0
WireConnection;76;2;79;0
WireConnection;76;3;75;0
WireConnection;83;0;84;2
WireConnection;83;1;87;0
WireConnection;85;0;86;0
WireConnection;85;1;83;0
WireConnection;139;0;144;0
WireConnection;139;1;140;0
WireConnection;139;2;143;0
WireConnection;144;0;145;0
WireConnection;144;1;85;0
WireConnection;86;0;84;2
WireConnection;86;1;88;0
WireConnection;77;1;139;0
WireConnection;0;2;21;0
WireConnection;0;3;37;0
WireConnection;0;9;35;0
WireConnection;14;0;7;2
WireConnection;14;1;15;0
WireConnection;13;0;11;0
WireConnection;13;1;14;0
WireConnection;11;0;7;2
WireConnection;11;1;10;0
WireConnection;5;0;33;0
WireConnection;5;1;13;0
ASEEND*/
//CHKSM=8625B57CD52A87AB5A58035FA205A4817AD7C983