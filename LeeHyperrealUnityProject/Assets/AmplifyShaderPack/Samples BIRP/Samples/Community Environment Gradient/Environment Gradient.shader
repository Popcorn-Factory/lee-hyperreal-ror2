// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Community/Environment Gradient"
{
	Properties
	{
		_GradientHeight("GradientHeight", Range( 0 , 20)) = 6.4
		_Top_Y("Top_Y", Color) = (0.7259277,0.7647059,0.06185123,0)
		_Top_XZ("Top_XZ", Color) = (0.2569204,0.5525266,0.7279412,0)
		_Bot_Y("Bot_Y", Color) = (0.3877363,0.5955882,0.188311,0)
		_Bot_XZ("Bot_XZ", Color) = (0.7058823,0.2024221,0.2024221,0)
		_EdgeMultiplier("EdgeMultiplier", Range( 0 , 5)) = 1
		_R_AO_G_Edges("R_AO_G_Edges", 2D) = "white" {}
		_AO_Power("AO_Power", Range( 0 , 4)) = 1
		_EdgeColor("EdgeColor", Color) = (0.9411765,0.9197947,0.7474049,0)
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Smoothness("Smoothness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _EdgeColor;
		uniform float _EdgeMultiplier;
		uniform sampler2D _R_AO_G_Edges;
		uniform float _AO_Power;
		uniform float4 _Bot_XZ;
		uniform float4 _Bot_Y;
		uniform float4 _Top_XZ;
		uniform float4 _Top_Y;
		uniform float _GradientHeight;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = UnpackNormal( tex2D( _NormalMap, i.uv_texcoord ) );
			float4 tex2DNode13 = tex2D( _R_AO_G_Edges, i.uv_texcoord );
			float saferPower40 = abs( tex2DNode13.r );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_22_0 = abs( ase_worldNormal );
			float temp_output_23_0 = (( temp_output_22_0 * temp_output_22_0 )).y;
			float4 lerpResult17 = lerp( _Bot_XZ , _Bot_Y , temp_output_23_0);
			float4 lerpResult27 = lerp( _Top_XZ , _Top_Y , temp_output_23_0);
			float3 ase_worldPos = i.worldPos;
			float clampResult32 = clamp( ( ase_worldPos.y / _GradientHeight ) , 0.0 , 1.0 );
			float4 lerpResult28 = lerp( lerpResult17 , lerpResult27 , clampResult32);
			float4 temp_cast_0 = (0.0).xxxx;
			float4 temp_cast_1 = (1.0).xxxx;
			float4 clampResult42 = clamp( ( ( _EdgeColor * ( _EdgeMultiplier * tex2DNode13.g ) ) + ( pow( saferPower40 , _AO_Power ) * lerpResult28 ) ) , temp_cast_0 , temp_cast_1 );
			o.Albedo = clampResult42.rgb;
			o.Smoothness = _Smoothness;
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
Node;AmplifyShaderEditor.CommentaryNode;43;-2309.229,387.8848;Inherit;False;901.0599;287.59;Get World Y Vector Mask;4;23;8;22;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;8;-2272.451,474.9954;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;46;-2264.596,-210.1021;Inherit;False;730.3268;510.8144;Create the world gradient;6;7;2;5;32;33;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;22;-2001.508,487.0916;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2214.596,7.199674;Float;False;Property;_GradientHeight;GradientHeight;0;0;Create;True;0;0;0;False;0;False;6.4;3.32;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-2152.796,-160.1021;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1802.105,484.8918;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1757.627,730.2855;Inherit;False;897.6793;426.1704;Lerp the 2 Gradient Bottom Colors according to the above normals y vector;3;21;17;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1762.024,1189.983;Inherit;False;907.8201;534.3306;The same lerp for the Top Gradient Colors;3;27;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2167.653,-535.7055;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-1896.661,-81.79171;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-1710.304,780.3916;Float;False;Property;_Bot_XZ;Bot_XZ;4;0;Create;True;0;0;0;False;0;False;0.7058823,0.2024221,0.2024221,0;0.7058823,0.2024218,0.2024218,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;21;-1710.605,947.5924;Float;False;Property;_Bot_Y;Bot_Y;3;0;Create;True;0;0;0;False;0;False;0.3877363,0.5955882,0.188311,0;0.387736,0.595588,0.1883107,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;33;-1935.627,86.51085;Float;False;Constant;_Float0;Float 0;-1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1938.991,180.7123;Float;False;Constant;_Float1;Float 1;-1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-1699.706,1273.792;Float;False;Property;_Top_XZ;Top_XZ;2;0;Create;True;0;0;0;False;0;False;0.2569204,0.5525266,0.7279412,0;0,0.625,1,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;47;-831.4337,-898.4309;Inherit;False;732.6006;499.3974;Properties to affect the edge highlight;4;30;35;37;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;23;-1620.908,491.5916;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-1708.009,1484.99;Float;False;Property;_Top_Y;Top_Y;1;0;Create;True;0;0;0;False;0;False;0.7259277,0.7647059,0.06185123,0;0.7259277,0.7647059,0.06185098,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;48;-836.3126,-1205.842;Inherit;False;577.7001;260.6001;Properties to affect the AO;2;41;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1809.752,-980.1052;Inherit;False;886;278;Custom Map (Ambient Occlusion on Red Channel, Edges-like curvature map on Green Channel);1;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;27;-1096.107,1417.091;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-781.4337,-666.7295;Float;False;Property;_EdgeMultiplier;EdgeMultiplier;5;0;Create;True;0;0;0;False;0;False;1;0.06;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;54;-250.27,968.5449;Inherit;False;574.3599;190.4;Lerp the Bottom and Top Colors according to the world gradient;1;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;13;-1759.752,-930.1052;Inherit;True;Property;_R_AO_G_Edges;R_AO_G_Edges;6;0;Create;True;0;0;0;False;0;False;-1;None;69a6dbc88ce141c19b169f2a026c7aaf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;17;-1086.904,837.2902;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-786.3125,-1065.242;Float;False;Property;_AO_Power;AO_Power;7;0;Create;True;0;0;0;False;0;False;1;3.556;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;32;-1722.269,-84.3163;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;16.10875,-872.9755;Inherit;False;268.1501;198.07;Combine AO with multiply;1;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-458.5143,-542.0326;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-705.3331,-848.4308;Float;False;Property;_EdgeColor;EdgeColor;8;0;Create;True;0;0;0;False;0;False;0.9411765,0.9197947,0.7474049,0;0.9411765,0.9197947,0.7474049,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;28;-200.27,1018.545;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;40;-417.6125,-1155.842;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;267.7985,-587.8406;Inherit;False;273.22;179.4799;Combine Edge color with add;1;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-257.8333,-542.6294;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;66.10875,-822.9755;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;53;526.0432,467.4425;Inherit;False;431;239;Normal Map;1;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;1607.965,38.88491;Inherit;False;596.7905;477.5201;Created by Mourelas Konstantinos @mourelask - www.moure.xyz;1;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;568.7342,84.52158;Inherit;False;918;182;Final Clamp, you can disable it or rise the max value if you want to produce values higher than 1 for HDR;1;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;317.7985,-537.8406;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;576.0432,517.4425;Inherit;True;Property;_NormalMap;NormalMap;9;0;Create;True;0;0;0;False;0;False;-1;None;f3cf434890c84147bf7b07889efdd721;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;73;1623.977,282.1648;Inherit;False;Property;_Smoothness;Smoothness;10;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;42;618.7342,134.5216;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;74;1777.777,104.7652;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Community/Environment Gradient;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;8;0
WireConnection;15;0;22;0
WireConnection;15;1;22;0
WireConnection;5;0;7;2
WireConnection;5;1;2;0
WireConnection;23;0;15;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;27;2;23;0
WireConnection;13;1;11;0
WireConnection;17;0;19;0
WireConnection;17;1;21;0
WireConnection;17;2;23;0
WireConnection;32;0;5;0
WireConnection;32;1;33;0
WireConnection;32;2;34;0
WireConnection;30;0;37;0
WireConnection;30;1;13;2
WireConnection;28;0;17;0
WireConnection;28;1;27;0
WireConnection;28;2;32;0
WireConnection;40;0;13;1
WireConnection;40;1;41;0
WireConnection;35;0;36;0
WireConnection;35;1;30;0
WireConnection;39;0;40;0
WireConnection;39;1;28;0
WireConnection;38;0;35;0
WireConnection;38;1;39;0
WireConnection;9;1;11;0
WireConnection;42;0;38;0
WireConnection;42;1;33;0
WireConnection;42;2;34;0
WireConnection;74;0;42;0
WireConnection;74;1;9;0
WireConnection;74;4;73;0
ASEEND*/
//CHKSM=3A3ECDDBA51BCF39E91D3B60A72C9AB57F9E2CD9