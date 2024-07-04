// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Double Layer Custom Surface"
{
	Properties
	{
		_BaseColor1("Base Color 1", Color) = (1,0.9310344,0,0)
		_BaseColor2("Base Color 2", Color) = (1,0.9310344,0,0)
		_BaseMetallic("Base Metallic", Range( 0 , 1)) = 0
		_BaseSmoothness("Base Smoothness", Range( 0 , 1)) = 0
		_BaseOcclusion("Base Occlusion", Range( 0 , 1)) = 0
		_FlakesRGBcolorvariationAmask("Flakes (RGB = color variation, A = mask)", 2D) = "white" {}
		_FlakeColorVariationAmount("Flake Color Variation Amount", Range( 0 , 1)) = 0
		_FlakesColor1("Flakes Color 1", Color) = (1,0.9310344,0,0)
		_FlakesColor2("Flakes Color 2", Color) = (1,0.9310344,0,0)
		_FlakesMetallic("Flakes Metallic", Range( 0 , 1)) = 0
		_FlakesSmoothness("Flakes Smoothness", Range( 0 , 1)) = 0
		_FlakesNormal("Flakes Normal", 2D) = "bump" {}
		_FlakesBump("Flakes Bump", Range( 0 , 1)) = 0
		_CoatNormal("Coat Normal", 2D) = "bump" {}
		_CoatBump("Coat Bump", Range( 0 , 1)) = 0
		_CoatAmount("Coat Amount", Range( 0 , 1)) = 0
		_CoatSmoothness("Coat Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _BaseColor1;
		uniform float4 _BaseColor2;
		uniform float4 _FlakesColor1;
		uniform float4 _FlakesColor2;
		uniform sampler2D _FlakesRGBcolorvariationAmask;
		uniform float4 _FlakesRGBcolorvariationAmask_ST;
		uniform float _FlakeColorVariationAmount;
		uniform sampler2D _FlakesNormal;
		uniform float _FlakesBump;
		uniform float _BaseMetallic;
		uniform float _FlakesMetallic;
		uniform float _BaseSmoothness;
		uniform float _FlakesSmoothness;
		uniform float _BaseOcclusion;
		uniform sampler2D _CoatNormal;
		uniform float4 _CoatNormal_ST;
		uniform float _CoatBump;
		uniform float _CoatSmoothness;
		uniform float _CoatAmount;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV201 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode201 = ( 0.05 + 1.0 * pow( 1.0 - fresnelNdotV201, 1.0 ) );
			float4 lerpResult278 = lerp( _BaseColor1 , _BaseColor2 , fresnelNode201);
			float4 lerpResult277 = lerp( _FlakesColor1 , _FlakesColor2 , fresnelNode201);
			float2 uv_FlakesRGBcolorvariationAmask = i.uv_texcoord * _FlakesRGBcolorvariationAmask_ST.xy + _FlakesRGBcolorvariationAmask_ST.zw;
			float4 tex2DNode228 = tex2D( _FlakesRGBcolorvariationAmask, uv_FlakesRGBcolorvariationAmask );
			float4 lerpResult227 = lerp( lerpResult277 , tex2DNode228 , _FlakeColorVariationAmount);
			float FlakeMask284 = tex2DNode228.a;
			float4 lerpResult217 = lerp( lerpResult278 , lerpResult227 , FlakeMask284);
			s1.Albedo = lerpResult217.rgb;
			s1.Normal = normalize( WorldNormalVector( i , UnpackScaleNormal( tex2D( _FlakesNormal, uv_FlakesRGBcolorvariationAmask ), _FlakesBump ) ) );
			s1.Emission = float3( 0,0,0 );
			float lerpResult218 = lerp( _BaseMetallic , _FlakesMetallic , FlakeMask284);
			s1.Metallic = lerpResult218;
			float lerpResult232 = lerp( _BaseSmoothness , _FlakesSmoothness , FlakeMask284);
			s1.Smoothness = lerpResult232;
			float fresnelNdotV279 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode279 = ( 0.05 + 1.0 * pow( 1.0 - fresnelNdotV279, 5.0 ) );
			float lerpResult306 = lerp( i.vertexColor.r , 1.0 , _BaseOcclusion);
			s1.Occlusion = ( saturate( ( 1.0 - fresnelNode279 ) ) * lerpResult306 );

			data.light = gi.light;

			UnityGI gi1 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g1 = UnityGlossyEnvironmentSetup( s1.Smoothness, data.worldViewDir, s1.Normal, float3(0,0,0));
			gi1 = UnityGlobalIllumination( data, s1.Occlusion, s1.Normal, g1 );
			#endif

			float3 surfResult1 = LightingStandard ( s1, viewDir, gi1 ).rgb;
			surfResult1 += s1.Emission;

			#ifdef UNITY_PASS_FORWARDADD//1
			surfResult1 -= s1.Emission;
			#endif//1
			SurfaceOutputStandardSpecular s166 = (SurfaceOutputStandardSpecular ) 0;
			s166.Albedo = float3( 0,0,0 );
			float2 uv_CoatNormal = i.uv_texcoord * _CoatNormal_ST.xy + _CoatNormal_ST.zw;
			s166.Normal = normalize( WorldNormalVector( i , UnpackScaleNormal( tex2D( _CoatNormal, uv_CoatNormal ), _CoatBump ) ) );
			s166.Emission = float3( 0,0,0 );
			float3 temp_cast_1 = (1.0).xxx;
			s166.Specular = temp_cast_1;
			s166.Smoothness = _CoatSmoothness;
			s166.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi166 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g166 = UnityGlossyEnvironmentSetup( s166.Smoothness, data.worldViewDir, s166.Normal, float3(0,0,0));
			gi166 = UnityGlobalIllumination( data, s166.Occlusion, s166.Normal, g166 );
			#endif

			float3 surfResult166 = LightingStandardSpecular ( s166, viewDir, gi166 ).rgb;
			surfResult166 += s166.Emission;

			#ifdef UNITY_PASS_FORWARDADD//166
			surfResult166 -= s166.Emission;
			#endif//166
			float3 lerpResult208 = lerp( surfResult1 , surfResult166 , saturate( ( ( fresnelNode279 * _CoatAmount ) * lerpResult306 ) ));
			c.rgb = lerpResult208;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
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
Node;AmplifyShaderEditor.CommentaryNode;292;-728.1172,-256;Inherit;False;276.2172;240.9171;Dual Toning Factor;1;201;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;293;-415.0294,-557.9827;Inherit;False;1743.894;1264.802;Base Layer With Dual Toning Flakes;28;1;285;232;286;218;204;233;5;219;288;11;9;7;290;277;263;216;323;291;324;284;228;287;217;227;278;4;271;;0,0,0,1;0;0
Node;AmplifyShaderEditor.FresnelNode;201;-704,-208;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;280;80,1168;Inherit;False;1017.462;730.4462;Simple fresnel blend;12;238;307;301;306;298;296;279;47;237;308;327;299;Blend Factor;0,0,0,1;0;0
Node;AmplifyShaderEditor.ColorNode;216;-16,-512;Float;False;Property;_FlakesColor1;Flakes Color 1;7;0;Create;True;0;0;0;False;0;False;1,0.9310344,0,0;0.7352942,0.02162632,0.3612323,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;263;-16,-336;Float;False;Property;_FlakesColor2;Flakes Color 2;8;0;Create;True;0;0;0;False;0;False;1,0.9310344,0,0;0.02162628,0.05607833,0.7352942,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;288;176,-176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;277;240,-304;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;279;192,1344;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;323;400,-256;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-336,-96;Inherit;False;0;228;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;296;480,1232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;301;480,1536;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;307;512,1712;Float;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;384,1792;Float;False;Property;_BaseOcclusion;Base Occlusion;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;228;96,-112;Inherit;True;Property;_FlakesRGBcolorvariationAmask;Flakes (RGB = color variation, A = mask);5;0;Create;True;0;0;0;False;0;False;-1;None;67895d953be64bc4bd0b09b78633f920;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;291;400,-144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;298;720,1232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;306;720,1536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;271;448,-336;Float;False;Property;_BaseColor2;Base Color 2;1;0;Create;True;0;0;0;False;0;False;1,0.9310344,0,0;0.03503464,0.08247133,0.3970578,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;4;448,-512;Float;False;Property;_BaseColor1;Base Color 1;0;0;Create;True;0;0;0;False;0;False;1,0.9310344,0,0;0.3970578,0.1923269,0.03503461,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;448,16;Float;False;FlakeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;324;428.1206,-114.6458;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;290;448,96;Float;False;Property;_FlakeColorVariationAmount;Flake Color Variation Amount;6;0;Create;True;0;0;0;False;0;False;0;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;912,1232;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;448,1408;Float;False;Property;_CoatAmount;Coat Amount;15;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;278;720,-256;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;227;720,-128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;752,0;Inherit;False;284;FlakeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-208,208;Float;False;Property;_FlakesBump;Flakes Bump;12;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;219;144,352;Float;False;Property;_BaseMetallic;Base Metallic;2;0;Create;True;0;0;0;False;0;False;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;327;1056,1216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;720,1344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;144,432;Float;False;Property;_FlakesMetallic;Flakes Metallic;9;0;Create;True;0;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;144,512;Float;False;Property;_BaseSmoothness;Base Smoothness;3;0;Create;True;0;0;0;False;0;False;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;144,592;Float;False;Property;_FlakesSmoothness;Flakes Smoothness;10;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;448,480;Inherit;False;284;FlakeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;286;448,304;Inherit;False;284;FlakeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;281;-320,752;Inherit;False;695.3702;286.2969;This mirror layer that to mimc a coating layer;2;180;171;Coating Layer (Specular);0,0,0,1;0;0
Node;AmplifyShaderEditor.LerpOp;217;944,-144;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;128,160;Inherit;True;Property;_FlakesNormal;Flakes Normal;11;0;Create;True;0;0;0;False;0;False;-1;None;8f66c1c8460e4419a467d27f526fad23;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;218;640,352;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;640,512;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;328;1040,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;912,1344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;1;1088,144;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;322;1152,1344;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;180;-304,848;Float;False;Property;_CoatBump;Coat Bump;14;0;Create;True;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;171;0,800;Inherit;True;Property;_CoatNormal;Coat Normal;13;0;Create;True;0;0;0;False;0;False;-1;None;221db06f30ae4c25a257d852f88a374d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;211;880,896;Float;False;Constant;_Spec;Spec;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;752,976;Float;False;Property;_CoatSmoothness;Coat Smoothness;16;0;Create;True;0;0;0;False;0;False;0;0.95;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;325;1328,224;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;330;1328,1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;326;1344,736;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomStandardSurface;166;1088,768;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;329;1328,880;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;208;1408,768;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1616,528;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;AmplifyShaderPack/Double Layer Custom Surface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;288;0;201;0
WireConnection;277;0;216;0
WireConnection;277;1;263;0
WireConnection;277;2;288;0
WireConnection;323;0;277;0
WireConnection;296;0;279;0
WireConnection;228;1;9;0
WireConnection;291;0;323;0
WireConnection;298;0;296;0
WireConnection;306;0;301;1
WireConnection;306;1;307;0
WireConnection;306;2;238;0
WireConnection;284;0;228;4
WireConnection;324;0;291;0
WireConnection;299;0;298;0
WireConnection;299;1;306;0
WireConnection;278;0;4;0
WireConnection;278;1;271;0
WireConnection;278;2;201;0
WireConnection;227;0;324;0
WireConnection;227;1;228;0
WireConnection;227;2;290;0
WireConnection;327;0;299;0
WireConnection;237;0;279;0
WireConnection;237;1;47;0
WireConnection;217;0;278;0
WireConnection;217;1;227;0
WireConnection;217;2;287;0
WireConnection;7;1;9;0
WireConnection;7;5;11;0
WireConnection;218;0;219;0
WireConnection;218;1;5;0
WireConnection;218;2;286;0
WireConnection;232;0;233;0
WireConnection;232;1;204;0
WireConnection;232;2;285;0
WireConnection;328;0;327;0
WireConnection;308;0;237;0
WireConnection;308;1;306;0
WireConnection;1;0;217;0
WireConnection;1;1;7;0
WireConnection;1;3;218;0
WireConnection;1;4;232;0
WireConnection;1;5;328;0
WireConnection;322;0;308;0
WireConnection;171;5;180;0
WireConnection;325;0;1;0
WireConnection;330;0;322;0
WireConnection;326;0;325;0
WireConnection;166;1;171;0
WireConnection;166;3;211;0
WireConnection;166;4;172;0
WireConnection;329;0;330;0
WireConnection;208;0;326;0
WireConnection;208;1;166;0
WireConnection;208;2;329;0
WireConnection;0;13;208;0
ASEEND*/
//CHKSM=547F9E6AB2FC2DDE14250D7285E934017A5DFB7B