// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/UV Light Reveal"
{
	Properties
	{
		_BaseTexture("Base Texture", 2D) = "white" {}
		_UVTexture("UV Texture", 2D) = "white" {}
		_ColortoBeFiltered("Color to Be Filtered", Color) = (0.4039216,0,1,1)
		_DifferenceThreshold("Difference Threshold", Range( 0 , 0.05)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
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

		uniform sampler2D _BaseTexture;
		uniform float4 _BaseTexture_ST;
		uniform sampler2D _UVTexture;
		uniform float4 _UVTexture_ST;
		uniform float4 _ColortoBeFiltered;
		uniform float _DifferenceThreshold;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_BaseTexture = i.uv_texcoord * _BaseTexture_ST.xy + _BaseTexture_ST.zw;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_59_0 = ( ase_lightAtten * ase_lightColor.rgb );
			float2 uv_UVTexture = i.uv_texcoord * _UVTexture_ST.xy + _UVTexture_ST.zw;
			float3 normalizeResult116 = normalize( (( ase_lightColor.rgb * _WorldSpaceLightPos0.w )).xyz );
			float3 normalizeResult117 = normalize( (_ColortoBeFiltered).rgb );
			float dotResult96 = dot( normalizeResult116 , normalizeResult117 );
			c.rgb = ( ( (tex2D( _BaseTexture, uv_BaseTexture )).rgb * saturate( temp_output_59_0 ) ) + ( (tex2D( _UVTexture, uv_UVTexture )).rgb * ( ( temp_output_59_0 * _WorldSpaceLightPos0.w ) *  ( dotResult96 - _DifferenceThreshold > 1.0 ? 0.0 : dotResult96 - _DifferenceThreshold <= 1.0 && dotResult96 + _DifferenceThreshold >= 1.0 ? 1.0 : 0.0 )  ) ) );
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
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.WorldSpaceLightPos;54;-1030.7,238.2679;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightColorNode;84;-983.925,353.0915;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;87;-881.309,506.7495;Float;False;Property;_ColortoBeFiltered;Color to Be Filtered;2;0;Create;True;0;0;0;False;0;False;0.4039216,0,1,1;0.4039215,0,1,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-803.9946,360.3203;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;118;-648.8203,355.1183;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;119;-655.8203,503.1183;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;53;-737.0425,-95.75333;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;58;-701.4785,-27.09451;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.NormalizeNode;116;-462.2045,367.9525;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;117;-478.5048,507.5531;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;96;-303.6713,411.4413;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-524.0501,-95.73702;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-317.827,525.9836;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-457.6726,599.4335;Float;False;Property;_DifferenceThreshold;Difference Threshold;3;0;Create;True;0;0;0;False;0;False;0;0.0016;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-368.7076,241.8157;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCIf;100;-142.8967,410.27;Inherit;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-237.3876,88.70139;Inherit;True;Property;_UVTexture;UV Texture;1;0;Create;True;0;0;0;False;0;False;-1;None;c7ce7d93a6bcda44ca958725aba51363;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;51;-439.4546,-311.7754;Inherit;True;Property;_BaseTexture;Base Texture;0;0;Create;True;0;0;0;False;0;False;-1;None;85e3723e62d44f758723754190c67911;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;84.39776,237.5722;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;79;-115.8604,-96.81562;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;120;75.2229,89.67844;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;121;-132.7223,-311.4043;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;261.7195,91.5482;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;81.14888,-118.2763;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;446.2005,-122.8492;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;627.9716,-355.1388;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;AmplifyShaderPack/UV Light Reveal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;85;0;84;1
WireConnection;85;1;54;2
WireConnection;118;0;85;0
WireConnection;119;0;87;0
WireConnection;116;0;118;0
WireConnection;117;0;119;0
WireConnection;96;0;116;0
WireConnection;96;1;117;0
WireConnection;59;0;53;0
WireConnection;59;1;58;1
WireConnection;55;0;59;0
WireConnection;55;1;54;2
WireConnection;100;0;96;0
WireConnection;100;1;98;0
WireConnection;100;3;98;0
WireConnection;100;5;90;0
WireConnection;99;0;55;0
WireConnection;99;1;100;0
WireConnection;79;0;59;0
WireConnection;120;0;52;0
WireConnection;121;0;51;0
WireConnection;57;0;120;0
WireConnection;57;1;99;0
WireConnection;80;0;121;0
WireConnection;80;1;79;0
WireConnection;78;0;80;0
WireConnection;78;1;57;0
WireConnection;0;13;78;0
ASEEND*/
//CHKSM=675E4E0A023CDBC99BDE658C1FF6759BE1674772