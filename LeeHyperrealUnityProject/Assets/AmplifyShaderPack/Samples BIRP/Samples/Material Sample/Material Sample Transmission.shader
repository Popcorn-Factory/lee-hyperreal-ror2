// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Material Sample Transmission"
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
		[HDR][Header(TRANSMISSION)]_TransmissionColor("Transmission Color", Color) = (0.5,0.5,0.5,1)
		_TransmissionStrength("Transmission Strength", Float) = 1
		[SingleLineTexture]_TransmissionMaskMap("Transmission Mask Map", 2D) = "white" {}
		_TransmissionMaskStrength("Transmission Mask Strength", Range( 0 , 1.5)) = 1.466198
		_TransmissionMaskFeather("Transmission Mask Feather", Range( 0 , 1)) = 1
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
			half3 Transmission;
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
		uniform half4 _TransmissionColor;
		uniform float _TransmissionStrength;
		uniform sampler2D _TransmissionMaskMap;
		uniform half4 _TransmissionMaskMap_ST;
		uniform half _TransmissionMaskFeather;
		uniform half _TransmissionMaskStrength;

		inline half4 LightingStandardSpecularCustom(SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi )
		{
			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandardSpecular r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Specular = s.Specular;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandardSpecular (r, viewDir, gi) + d;
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
			half2 temp_output_133_0_g1 = ( ( i.uv_texcoord * (_MainUVs).xy ) + (_MainUVs).zw );
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, temp_output_133_0_g1 ), _NormalStrength );
			half4 tex2DNode21_g1 = tex2D( _MainTex, temp_output_133_0_g1 );
			half3 temp_output_89_0_g1 = ( (_BaseColor).rgb * (tex2DNode21_g1).rgb * _Brightness );
			o.Albedo = temp_output_89_0_g1;
			half3 temp_output_202_0_g1 = (_SpecularColor).rgb;
			half temp_output_265_0_g1 = ( ( 1.0 - _SpecularColorIOR ) / ( _SpecularColorIOR + 1.0 ) );
			o.Specular = ( ( ( temp_output_202_0_g1 * _SpecularColorWeight ) * ( temp_output_265_0_g1 * temp_output_265_0_g1 ) ) * (tex2D( _SpecularMap, temp_output_133_0_g1 )).rgb * _SpecularStrength );
			o.Smoothness = ( _SmoothnessStrength * (tex2D( _SmoothnessMap, temp_output_133_0_g1 )).rgb ).x;
			o.Occlusion = saturate( ( ( 1.0 - _OcclusionStrengthAO ) * (tex2D( _OcclusionMap, temp_output_133_0_g1 )).rgb ) ).x;
			half4 color42 = IsGammaSpace() ? half4(0,0,0,0) : half4(0,0,0,0);
			float2 uv_TransmissionMaskMap = i.uv_texcoord * _TransmissionMaskMap_ST.xy + _TransmissionMaskMap_ST.zw;
			half3 lerpResult38 = lerp( (color42).rgb , saturate( ( (tex2D( _TransmissionMaskMap, uv_TransmissionMaskMap )).rgb / max( _TransmissionMaskFeather , 1E-05 ) ) ) , _TransmissionMaskStrength);
			half3 Transmission47 = ( (_TransmissionColor).rgb * _TransmissionStrength * lerpResult38 );
			o.Transmission = Transmission47;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;30;-2127.104,392.0605;Inherit;False;2124.629;854.9123;Transmission;17;47;46;45;44;43;42;41;40;39;38;37;36;35;34;33;32;31;;0,0,0,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;40;-2084.52,725.943;Inherit;True;Property;_TransmissionMaskMap;Transmission Mask Map;37;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;d2fd9f8b51654f87b55f9b4a55249b1d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;32;-1643.594,1003.016;Float;False;Constant;_Float1;Float 0;0;0;Create;True;0;0;0;False;0;False;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-1798.373,727.2032;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;41;-1778.36,926.5763;Half;False;Property;_TransmissionMaskFeather;Transmission Mask Feather;39;0;Create;False;0;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;31;-1493.41,725.1235;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;33;-1489.876,931.0508;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;-1301.644,728.5201;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;42;-1387.152,531.0592;Inherit;False;Constant;_Mask;Mask;29;1;[HideInInspector];Create;True;1;;0;0;False;0;False;0,0,0,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;36;-1255.969,847.5483;Half;False;Property;_TransmissionMaskStrength;Transmission Mask Strength;38;0;Create;False;1;;0;0;False;0;False;1.466198;1;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;37;-1171.014,531.7051;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;39;-1164.752,729.3481;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;43;-835.1893,495.3772;Half;False;Property;_TransmissionColor;Transmission Color;35;2;[HDR];[Header];Create;False;1;TRANSMISSION;0;0;False;0;False;0.5,0.5,0.5,1;1,0.1051431,0,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;38;-965.3989,708.452;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;44;-599.0235,495.036;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-641.1686,663.256;Float;False;Property;_TransmissionStrength;Transmission Strength;36;0;Create;False;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-379.6828,659.4103;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-225.4738,655.9701;Inherit;False;Transmission;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;8;-270.568,-12.39949;Inherit;False;Material Sample;1;;1;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,1,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.IntNode;9;138.238,-95.52411;Inherit;False;Property;_Cull;Render Face;0;2;[Header];[Enum];Create;False;1;SURFACE OPTIONS;0;1;Front,2,Back,1,Both,0;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-164.6383,271.7361;Inherit;False;47;Transmission;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;127.9191,-12.46125;Half;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Material Sample Transmission;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;35;0;40;0
WireConnection;35;7;40;1
WireConnection;31;0;35;0
WireConnection;33;0;41;0
WireConnection;33;1;32;0
WireConnection;34;0;31;0
WireConnection;34;1;33;0
WireConnection;37;0;42;0
WireConnection;39;0;34;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;38;2;36;0
WireConnection;44;0;43;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;46;2;38;0
WireConnection;47;0;46;0
WireConnection;0;0;8;1
WireConnection;0;1;8;6
WireConnection;0;3;8;5
WireConnection;0;4;8;2
WireConnection;0;5;8;4
WireConnection;0;6;48;0
ASEEND*/
//CHKSM=814E5B645AD36145CA9ACD8AF9CA33A014732041