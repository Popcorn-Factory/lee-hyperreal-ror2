// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Parallax Mapping Iterations"
{
	Properties
	{
		_Tiling("Tiling", Float) = 4
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 2)) = 1
		_Metallic("Metallic", 2D) = "white" {}
		_MetallicAmount("Metallic Amount", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", 2D) = "white" {}
		_SmoothnessScale("Smoothness Scale", Float) = 0
		_Occlusion("Occlusion", 2D) = "white" {}
		_Parallax("Parallax", Range( 0 , 0.1)) = 0
		_HeightMap("HeightMap", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

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

		UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal);
		uniform float _Tiling;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_HeightMap);
		uniform half4 _HeightMap_ST;
		SamplerState sampler_HeightMap;
		uniform float _Parallax;
		SamplerState sampler_Normal;
		uniform float _NormalScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Albedo);
		SamplerState sampler_Albedo;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Metallic);
		SamplerState sampler_Metallic;
		uniform float _MetallicAmount;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Smoothness);
		SamplerState sampler_Smoothness;
		uniform float _SmoothnessScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Occlusion);
		SamplerState sampler_Occlusion;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord117 = i.uv_texcoord * temp_cast_0;
			float2 uv_HeightMap = i.uv_texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			half2 Offset4 = ( ( SAMPLE_TEXTURE2D( _HeightMap, sampler_HeightMap, uv_HeightMap ).r - 1 ) * i.viewDir.xy * _Parallax ) + uv_TexCoord117;
			half2 Offset49 = ( ( SAMPLE_TEXTURE2D( _HeightMap, sampler_HeightMap, Offset4 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset4;
			half2 Offset52 = ( ( SAMPLE_TEXTURE2D( _HeightMap, sampler_HeightMap, Offset49 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset49;
			half2 Offset54 = ( ( SAMPLE_TEXTURE2D( _HeightMap, sampler_HeightMap, Offset52 ).r - 1 ) * i.viewDir.xy * _Parallax ) + Offset52;
			float2 Offset13 = Offset54;
			o.Normal = UnpackScaleNormal( SAMPLE_TEXTURE2D( _Normal, sampler_Normal, Offset13 ), _NormalScale );
			o.Albedo = SAMPLE_TEXTURE2D( _Albedo, sampler_Albedo, Offset13 ).rgb;
			o.Metallic = ( SAMPLE_TEXTURE2D( _Metallic, sampler_Metallic, Offset13 ).r + _MetallicAmount );
			o.Smoothness = ( SAMPLE_TEXTURE2D( _Smoothness, sampler_Smoothness, Offset13 ).r * _SmoothnessScale );
			o.Occlusion = SAMPLE_TEXTURE2D( _Occlusion, sampler_Occlusion, Offset13 ).r;
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
Version=19501
Node;AmplifyShaderEditor.TexturePropertyNode;122;-1913.972,102.5429;Inherit;True;Property;_HeightMap;HeightMap;10;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;21;-1660.413,-1.306639;Float;False;Property;_Tiling;Tiling;0;0;Create;True;0;0;0;False;0;False;4;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;123;-1647.379,101.9918;Inherit;True;Property;_TextureSample0;Texture Sample 0;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TextureCoordinatesNode;117;-1509.444,-19.47979;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1562.916,-101.8583;Float;False;Property;_Parallax;Parallax;9;0;Create;True;0;0;0;False;0;False;0;0.01;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-1470.768,-249.0926;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ParallaxMappingNode;4;-1252.559,106.5818;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;125;-1035.547,261.0483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;72;-1060.582,275.9047;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;74;-1021.581,271.2047;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;124;-1677.547,291.0483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;126;-1055.547,291.0483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;71;-1701.182,316.3046;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;127;-1280.547,304.0483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;50;-1644.681,328.5053;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;73;-1302.282,326.9047;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;49;-1250.685,331.5046;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;129;-1035.547,468.0483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;76;-1059.081,489.5047;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;78;-1022.882,476.6046;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;128;-1643.547,511.0483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;130;-1053.547,508.0483;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;75;-1682.281,531.0044;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;131;-1267.547,522.0482;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;51;-1634.028,547.1047;Inherit;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;77;-1288.682,554.5045;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;52;-1246.432,549.7041;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;133;-1036.547,688.0482;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;80;-1051.081,717.4045;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;135;-1015.547,701.0482;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;132;-1628.547,728.0482;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;82;-1038.881,733.2043;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;79;-1672.382,751.1042;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;134;-1265.547,749.0482;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;81;-1284.581,772.9043;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;53;-1631.028,766.1044;Inherit;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ParallaxMappingNode;54;-1244.032,770.1039;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-956.2183,776.168;Float;False;Offset;1;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-789.9542,-103.0543;Inherit;False;13;Offset;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-895.4999,107.2;Float;False;Property;_NormalScale;Normal Scale;3;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-592,56.2;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;150f7373df6f4344af67cbc5f1f2ccc2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;11;-593.3,241.7;Inherit;True;Property;_Metallic;Metallic;4;0;Create;True;0;0;0;False;0;False;-1;None;5dba1978ccdc494cb240063b53a396df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;41;-291.2999,338.8001;Float;False;Property;_MetallicAmount;Metallic Amount;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-589.4,438.7;Inherit;True;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;0;False;0;False;-1;None;c7d62dd1f3674b85ba6502ab04da839d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;38;-240.2999,529.3001;Float;False;Property;_SmoothnessScale;Smoothness Scale;7;0;Create;True;0;0;0;False;0;False;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-572.5002,635.2999;Inherit;True;Property;_Occlusion;Occlusion;8;0;Create;True;0;0;0;False;0;False;-1;None;5204631b057d4ea8a1060f2fe75afcf1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;1;-592,-128;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;07738f0e3d274495837c31040b762233;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;40;4.400794,275.8004;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-0.7987897,463.1015;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;137;110.5728,585.2897;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;138;89.77283,58.79012;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;218.4998,-124.9265;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Parallax Mapping Iterations;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;True;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;123;0;122;0
WireConnection;123;7;122;1
WireConnection;117;0;21;0
WireConnection;4;0;117;0
WireConnection;4;1;123;1
WireConnection;4;2;9;0
WireConnection;4;3;8;0
WireConnection;125;0;4;0
WireConnection;72;0;125;0
WireConnection;74;0;4;0
WireConnection;124;0;72;0
WireConnection;126;0;74;0
WireConnection;71;0;124;0
WireConnection;127;0;126;0
WireConnection;50;0;122;0
WireConnection;50;1;71;0
WireConnection;50;7;122;1
WireConnection;73;0;127;0
WireConnection;49;0;73;0
WireConnection;49;1;50;1
WireConnection;49;2;9;0
WireConnection;49;3;8;0
WireConnection;129;0;49;0
WireConnection;76;0;129;0
WireConnection;78;0;49;0
WireConnection;128;0;76;0
WireConnection;130;0;78;0
WireConnection;75;0;128;0
WireConnection;131;0;130;0
WireConnection;51;0;122;0
WireConnection;51;1;75;0
WireConnection;51;7;122;1
WireConnection;77;0;131;0
WireConnection;52;0;77;0
WireConnection;52;1;51;1
WireConnection;52;2;9;0
WireConnection;52;3;8;0
WireConnection;133;0;52;0
WireConnection;80;0;133;0
WireConnection;135;0;52;0
WireConnection;132;0;80;0
WireConnection;82;0;135;0
WireConnection;79;0;132;0
WireConnection;134;0;82;0
WireConnection;81;0;134;0
WireConnection;53;0;122;0
WireConnection;53;1;79;0
WireConnection;53;7;122;1
WireConnection;54;0;81;0
WireConnection;54;1;53;1
WireConnection;54;2;9;0
WireConnection;54;3;8;0
WireConnection;13;0;54;0
WireConnection;5;1;136;0
WireConnection;5;5;6;0
WireConnection;11;1;136;0
WireConnection;12;1;136;0
WireConnection;7;1;136;0
WireConnection;1;1;136;0
WireConnection;40;0;11;1
WireConnection;40;1;41;0
WireConnection;100;0;12;1
WireConnection;100;1;38;0
WireConnection;137;0;7;1
WireConnection;138;0;5;0
WireConnection;0;0;1;0
WireConnection;0;1;138;0
WireConnection;0;3;40;0
WireConnection;0;4;100;0
WireConnection;0;5;137;0
ASEEND*/
//CHKSM=4A22785BE70171E075045A8F57750363E8FC9EF1