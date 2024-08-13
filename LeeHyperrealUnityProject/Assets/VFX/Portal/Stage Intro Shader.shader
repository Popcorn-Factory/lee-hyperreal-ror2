// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Stage Intro Shader"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_emissionmult("emission mult", Range( 0 , 20)) = 1
		_speedportal("speed portal", Range( -10 , 10)) = -0.2
		_speedparalax("speed paralax", Range( -10 , 10)) = -0.2
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Paralaxoffsetscale("Paralax offset scale", Range( 0 , 10)) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float12("Float 12", Range( 0 , 3)) = 2.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
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

		uniform sampler2D _TextureSample0;
		uniform float _speedportal;
		uniform sampler2D _TextureSample3;
		uniform float _speedparalax;
		uniform float _Float12;
		uniform float _Paralaxoffsetscale;
		uniform float _emissionmult;
		uniform sampler2D _TextureSample1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float4 appendResult30 = (float4(( _Time.y * _speedportal ) , ( _Time.y * 0.05 ) , 0.0 , 0.0));
			float2 uv_TexCoord40 = i.uv_texcoord * float2( 2,1 ) + appendResult30.xy;
			float4 appendResult16 = (float4(( _Time.y * _speedparalax ) , ( _Time.y * 0.0 ) , 0.0 , 0.0));
			float2 uv_TexCoord19 = i.uv_texcoord * float2( 2,1 ) + appendResult16.xy;
			float cos18 = cos( _Float12 );
			float sin18 = sin( _Float12 );
			float2 rotator18 = mul( uv_TexCoord19 - float2( 0.5,0.5 ) , float2x2( cos18 , -sin18 , sin18 , cos18 )) + float2( 0.5,0.5 );
			float4 tex2DNode26 = tex2D( _TextureSample3, rotator18 );
			float2 paralaxOffset35 = ParallaxOffset( tex2DNode26.g , _Paralaxoffsetscale , i.viewDir );
			float temp_output_56_0 = ( _Time.y * -0.1 );
			float4 appendResult44 = (float4(temp_output_56_0 , ( temp_output_56_0 * -0.5 ) , 0.0 , 0.0));
			float2 uv_TexCoord58 = i.uv_texcoord * float2( 1,1 ) + appendResult44.xy;
			float4 temp_cast_3 = (-2.0).xxxx;
			float4 temp_cast_4 = (2.5).xxxx;
			o.Emission = ( tex2D( _TextureSample0, ( uv_TexCoord40 + ( i.uv_texcoord + paralaxOffset35 ) ) ) * _emissionmult * (temp_cast_3 + (tex2D( _TextureSample1, uv_TexCoord58 ) - float4( 0,0,0,0 )) * (temp_cast_4 - temp_cast_3) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) ).rgb;
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
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Stage Intro Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;1;-622,-62;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;bf43e88be8c510748a7ce4306714b0b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-228,22;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-3545.261,426.2816;Inherit;False;Property;_heightdistance;height distance;11;0;Create;True;0;0;0;False;0;False;0;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-3017.262,522.2819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-3877.308,223.3056;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-4037.308,239.3057;Inherit;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ParallaxMappingNode;12;-3694.095,20.73895;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-4158.094,-43.26111;Inherit;False;Property;_Paralax;Paralax;6;0;Create;True;0;0;0;False;0;False;0;0.3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;14;-4062.095,52.73877;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3970.635,1355.114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-4068.176,1111.874;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-4184.201,1495.61;Inherit;False;Constant;_Float10;Float 1;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;18;-3482.874,976.8042;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-3141.875,1244.804;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;20;-4655.817,1086.945;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-4303.728,1220.62;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3580.875,1365.804;Inherit;False;Property;_Float12;Float 12;13;0;Create;True;0;0;0;False;0;False;2.1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-4604.552,1428.381;Inherit;False;Property;_speedparalax;speed paralax;4;0;Create;True;0;0;0;False;0;False;-0.2;0.3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;24;-3767.875,1206.804;Inherit;False;Constant;_Vector3;Vector 3;17;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;25;-3705.143,1490.921;Inherit;False;Constant;_tilingparalax;tiling paralax;17;0;Create;True;0;0;0;False;0;False;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;26;-3270.563,781.4277;Inherit;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;0;False;0;False;-1;None;0dad9e7949ffefd48954a1359652102c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;27;-2200.309,635.8434;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;28;-2025.132,-149.1059;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;29;-2436.786,156.7655;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-1944.682,111.443;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2179.35,145.0875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2374.059,410.9504;Inherit;False;Property;_speedportal;speed portal;2;0;Create;True;0;0;0;False;0;False;-0.2;-0.3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2060.708,495.1787;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;34;-2338.277,951.8487;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;35;-1925.278,867.8487;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2373.277,755.8492;Inherit;False;Property;_Paralaxoffsetscale;Paralax offset scale;7;0;Create;True;0;0;0;False;0;False;0;0.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-1621.276,787.8492;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1568.788,474.6197;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1847.139,354.6831;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1557.971,42.53638;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;42;679.0021,-890.5389;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-595.6685,-1077.727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-693.2115,-1320.967;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-809.2378,-937.2313;Inherit;False;Constant;_Float5;Float 1;2;0;Create;True;0;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;682.4122,-406.8725;Inherit;False;Constant;_Float7;Float 7;6;0;Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-568.9893,-612.92;Inherit;False;Property;_emissionstrength;emission strength;3;0;Create;True;0;0;0;False;0;False;2;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-418.8557,-907.507;Inherit;False;Constant;_Float9;Float 9;6;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;49;-587.8557,-774.507;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;101.3447,-834.5527;Inherit;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;0;False;0;False;-1;None;65cb3e533a728e446bf24e500fbde44f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;51;-114.8557,-683.507;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-392.8557,-840.507;Inherit;False;Property;_minimumemission;minimum emission;10;0;Create;True;0;0;0;False;0;False;0;0.6;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-383.8557,-723.507;Inherit;False;Property;_maximumemission;maximum emission;12;0;Create;True;0;0;0;False;0;False;0;4;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1122.588,-1021.46;Inherit;False;Constant;_Float6;Float 6;3;0;Create;True;0;0;0;False;0;False;-0.1;0.2;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;55;-1185.316,-1275.644;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-927.8788,-1287.322;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;57;-773.6617,-1581.516;Inherit;False;Constant;_Vector1;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-413.7338,-1409.986;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-604.6717,196.6081;Inherit;False;Property;_emissionmult;emission mult;1;0;Create;True;0;0;0;False;0;False;1;1.434783;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;524.2062,-490.8415;Inherit;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
WireConnection;0;2;2;0
WireConnection;1;1;38;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;2;2;42;0
WireConnection;9;0;8;0
WireConnection;9;1;26;1
WireConnection;10;0;26;3
WireConnection;12;0;10;0
WireConnection;12;1;9;0
WireConnection;12;2;13;0
WireConnection;12;3;14;0
WireConnection;15;0;20;2
WireConnection;15;1;17;0
WireConnection;16;0;21;0
WireConnection;16;1;15;0
WireConnection;18;0;19;0
WireConnection;18;1;24;0
WireConnection;18;2;22;0
WireConnection;19;0;25;0
WireConnection;19;1;16;0
WireConnection;21;0;20;2
WireConnection;21;1;23;0
WireConnection;26;1;18;0
WireConnection;30;0;31;0
WireConnection;30;1;39;0
WireConnection;31;0;29;2
WireConnection;31;1;32;0
WireConnection;35;0;26;2
WireConnection;35;1;36;0
WireConnection;35;2;34;0
WireConnection;37;0;27;0
WireConnection;37;1;35;0
WireConnection;38;0;40;0
WireConnection;38;1;37;0
WireConnection;39;0;29;2
WireConnection;39;1;33;0
WireConnection;40;0;28;0
WireConnection;40;1;30;0
WireConnection;42;0;50;0
WireConnection;42;3;41;0
WireConnection;42;4;46;0
WireConnection;43;0;56;0
WireConnection;43;1;45;0
WireConnection;44;0;56;0
WireConnection;44;1;43;0
WireConnection;50;1;58;0
WireConnection;51;0;49;4
WireConnection;51;1;48;0
WireConnection;51;3;52;0
WireConnection;51;4;53;0
WireConnection;56;0;55;2
WireConnection;56;1;54;0
WireConnection;58;0;57;0
WireConnection;58;1;44;0
ASEEND*/
//CHKSM=980295DAB33479DE8E5F6868F99B4EFF147D7033