// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Material Sample Translucent"
{
	Properties
	{
		[Header(SURFACE OPTIONS)][Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[Header(SURFACE INPUTS)]_BaseColor("Base Color", Color) = (1,1,1,0)
		_Brightness("Brightness", Range( 0 , 2)) = 1
		[SingleLineTexture]_MainTex("BaseColor Map", 2D) = "white" {}
		_MainUVs("Main UVs", Vector) = (1,1,0,0)
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Float) = 1
		[SingleLineTexture]_SpecularMap("Specular Map", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_SpecularStrength("Specular Strength", Range( 0 , 1)) = 0.04
		_SpecularColorWeight("Specular Color Weight", Float) = 1
		_SpecularColorIOR("Specular Color IOR", Float) = 0
		[SingleLineTexture]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		_OcclusionStrengthAO("Occlusion Strength", Range( 0 , 1)) = 0
		[SingleLineTexture]_SmoothnessMap("Smoothness Map", 2D) = "white" {}
		_SmoothnessStrength("Smoothness Strength", Range( 0 , 1)) = 0
		[HDR][Header(TRANSLUCENCY)]_TranslucencyColor("Translucency Color", Color) = (0.5,0.5,0.5,1)
		_TranslucencyStrength("Translucency Strength", Float) = 1
		[SingleLineTexture]_ThicknessMaskMap("Thickness Mask Map", 2D) = "white" {}
		_ThicknessMaskStrength("Thickness Mask Strength", Range( 0 , 1.5)) = 1
		_ThicknessMaskFeather("Thickness Mask Feather", Range( 0 , 1)) = 1
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_Cull]
		ZTest LEqual
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecularCustom keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardSpecularCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half3 Specular;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform int _Cull;
		uniform sampler2D _BumpMap;
		uniform half4 _MainUVs;
		uniform half _NormalStrength;
		uniform half4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform half4 _SpecularColor;
		uniform half _SpecularColorWeight;
		uniform half _SpecularColorIOR;
		uniform sampler2D _SpecularMap;
		uniform half _SpecularStrength;
		uniform half _SmoothnessStrength;
		uniform sampler2D _SmoothnessMap;
		uniform half _OcclusionStrengthAO;
		uniform sampler2D _OcclusionMap;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform half4 _TranslucencyColor;
		uniform float _TranslucencyStrength;
		uniform sampler2D _ThicknessMaskMap;
		uniform half4 _ThicknessMaskMap_ST;
		uniform half _ThicknessMaskFeather;
		uniform half _ThicknessMaskStrength;

		inline half4 LightingStandardSpecularCustom(SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi )
		{
			#if !defined(DIRECTIONAL)
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandardSpecular r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Specular = s.Specular;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandardSpecular (r, viewDir, gi) + c;
		}

		inline void LightingStandardSpecularCustom_GI(SurfaceOutputStandardSpecularCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardSpecularCustom o )
		{
			half2 temp_output_133_0_g2 = ( ( i.uv_texcoord * (_MainUVs).xy ) + (_MainUVs).zw );
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, temp_output_133_0_g2 ), _NormalStrength );
			half4 tex2DNode21_g2 = tex2D( _MainTex, temp_output_133_0_g2 );
			half3 temp_output_89_0_g2 = ( (_BaseColor).rgb * (tex2DNode21_g2).rgb * _Brightness );
			o.Albedo = temp_output_89_0_g2;
			half3 temp_output_202_0_g2 = (_SpecularColor).rgb;
			half temp_output_265_0_g2 = ( ( 1.0 - _SpecularColorIOR ) / ( _SpecularColorIOR + 1.0 ) );
			o.Specular = ( ( ( temp_output_202_0_g2 * _SpecularColorWeight ) * ( temp_output_265_0_g2 * temp_output_265_0_g2 ) ) * (tex2D( _SpecularMap, temp_output_133_0_g2 )).rgb * _SpecularStrength );
			o.Smoothness = ( _SmoothnessStrength * (tex2D( _SmoothnessMap, temp_output_133_0_g2 )).rgb ).x;
			o.Occlusion = saturate( ( ( 1.0 - _OcclusionStrengthAO ) * (tex2D( _OcclusionMap, temp_output_133_0_g2 )).rgb ) ).x;
			half4 color50 = IsGammaSpace() ? half4(0,0,0,0) : half4(0,0,0,0);
			float2 uv_ThicknessMaskMap = i.uv_texcoord * _ThicknessMaskMap_ST.xy + _ThicknessMaskMap_ST.zw;
			half3 lerpResult48 = lerp( (color50).rgb , saturate( ( (tex2D( _ThicknessMaskMap, uv_ThicknessMaskMap )).rgb / max( _ThicknessMaskFeather , 1E-05 ) ) ) , _ThicknessMaskStrength);
			half3 Translucency54 = ( (_TranslucencyColor).rgb * _TranslucencyStrength * lerpResult48 );
			o.Translucency = Translucency54;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;40;-2113.367,378.2621;Inherit;False;2124.629;854.9123;Translucency;17;58;57;56;55;54;53;52;51;50;49;48;47;46;45;44;43;42;;0,0,0,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;56;-2070.782,713.1445;Inherit;True;Property;_ThicknessMaskMap;Thickness Mask Map;37;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;d2fd9f8b51654f87b55f9b4a55249b1d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;43;-1629.857,989.2178;Float;False;Constant;_Float1;Float 0;0;0;Create;True;0;0;0;False;0;False;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-1784.636,713.4047;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;55;-1759.359,913.7775;Half;False;Property;_ThicknessMaskFeather;Thickness Mask Feather;39;0;Create;False;0;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;42;-1479.673,711.3251;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;44;-1476.139,917.2521;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;45;-1287.907,714.7217;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;50;-1373.415,517.2609;Inherit;False;Constant;_Mask;Mask;29;1;[HideInInspector];Create;True;1;;0;0;False;0;False;0,0,0,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwizzleNode;47;-1157.277,517.9067;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;49;-1151.015,715.5496;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;53;-836.6857,481.5788;Half;False;Property;_TranslucencyColor;Translucency Color;35;2;[HDR];[Header];Create;False;1;TRANSLUCENCY;0;0;False;0;False;0.5,0.5,0.5,1;1,0.1051431,0,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;57;-1262.08,830.2767;Half;False;Property;_ThicknessMaskStrength;Thickness Mask Strength;38;0;Create;False;1;;0;0;False;0;False;1;1;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;48;-951.6619,694.6536;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;52;-565.239,479.2328;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-633.9955,653.3895;Float;False;Property;_TranslucencyStrength;Translucency Strength;36;0;Create;False;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-365.9459,645.6119;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-207.7274,642.1716;Inherit;False;Translucency;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;19;-269.9073,-74.54143;Inherit;False;Material Sample;1;;2;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,1,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.IntNode;20;131.8353,-153.6521;Inherit;False;Property;_Cull;Render Face;0;2;[Header];[Enum];Create;False;1;SURFACE OPTIONS;0;1;Front,2,Back,1,Both,0;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-166.0713,215.9672;Inherit;False;54;Translucency;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;132.4658,-74.98228;Half;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Material Sample Translucent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;40;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;46;0;56;0
WireConnection;46;7;56;1
WireConnection;42;0;46;0
WireConnection;44;0;55;0
WireConnection;44;1;43;0
WireConnection;45;0;42;0
WireConnection;45;1;44;0
WireConnection;47;0;50;0
WireConnection;49;0;45;0
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;48;2;57;0
WireConnection;52;0;53;0
WireConnection;51;0;52;0
WireConnection;51;1;58;0
WireConnection;51;2;48;0
WireConnection;54;0;51;0
WireConnection;0;0;19;1
WireConnection;0;1;19;6
WireConnection;0;3;19;5
WireConnection;0;4;19;2
WireConnection;0;5;19;4
WireConnection;0;7;59;0
ASEEND*/
//CHKSM=ECF456B4083D9DB7A7074325B4361DC2F82BB5BA