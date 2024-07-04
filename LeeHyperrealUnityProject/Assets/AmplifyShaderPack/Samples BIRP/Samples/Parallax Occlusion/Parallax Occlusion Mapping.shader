// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Parallax Occlusion Mapping"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0.5
		_Metallic("Metallic", 2D) = "white" {}
		_Roughness("Roughness", 2D) = "white" {}
		_RoughScale("Rough Scale", Float) = 0.5
		_Occlusion("Occlusion", 2D) = "white" {}
		_HeightMap("HeightMap", 2D) = "white" {}
		_Scale("Scale", Range( 0 , 1)) = 0.4247461
		_CurvatureU("Curvature U", Range( 0 , 100)) = 0
		_CurvatureV("Curvature V", Range( 0 , 30)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[Header(Parallax Occlusion Mapping)]
		_CurvFix("Curvature Bias", Range( 0 , 1)) = 1
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
		#pragma target 4.0
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
			float3 worldNormal;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _HeightMap;
		uniform float _Scale;
		uniform float _CurvFix;
		uniform float _CurvatureU;
		uniform float _CurvatureV;
		uniform float4 _HeightMap_ST;
		uniform float _NormalScale;
		uniform sampler2D _Metallic;
		uniform float _RoughScale;
		uniform sampler2D _Roughness;
		uniform sampler2D _Occlusion;


inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, int sidewallSteps, float parallax, float refPlane, float2 tilling, float2 curv, int index )
{
	float3 result = 0;
	int stepIndex = 0;
	int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
	float layerHeight = 1.0 / numSteps;
	float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
	uvs.xy += refPlane * plane;
	float2 deltaTex = -plane * layerHeight;
	float2 prevTexOffset = 0;
	float prevRayZ = 1.0f;
	float prevHeight = 0.0f;
	float2 currTexOffset = deltaTex;
	float currRayZ = 1.0f - layerHeight;
	float currHeight = 0.0f;
	float intersection = 0;
	float2 finalTexOffset = 0;
	while ( stepIndex < numSteps + 1 )
	{
	 	result.z = dot( curv, currTexOffset * currTexOffset );
	 	currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r * ( 1 - result.z );
	 	if ( currHeight > currRayZ )
	 	{
	 	 	stepIndex = numSteps + 1;
	 	}
	 	else
	 	{
	 	 	stepIndex++;
	 	 	prevTexOffset = currTexOffset;
	 	 	prevRayZ = currRayZ;
	 	 	prevHeight = currHeight;
	 	 	currTexOffset += deltaTex;
	 	 	currRayZ -= layerHeight * ( 1 - result.z ) * (1+_CurvFix);
	 	}
	}
	int sectionSteps = sidewallSteps;
	int sectionIndex = 0;
	float newZ = 0;
	float newHeight = 0;
	while ( sectionIndex < sectionSteps )
	{
	 	intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
	 	finalTexOffset = prevTexOffset + intersection * deltaTex;
	 	newZ = prevRayZ - intersection * layerHeight;
	 	newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
	 	if ( newHeight > newZ )
	 	{
	 	 	currTexOffset = finalTexOffset;
	 	 	currHeight = newHeight;
	 	 	currRayZ = newZ;
	 	 	deltaTex = intersection * deltaTex;
	 	 	layerHeight = intersection * layerHeight;
	 	}
	 	else
	 	{
	 	 	prevTexOffset = finalTexOffset;
	 	 	prevHeight = newHeight;
	 	 	prevRayZ = newZ;
	 	 	deltaTex = ( 1 - intersection ) * deltaTex;
	 	 	layerHeight = ( 1 - intersection ) * layerHeight;
	 	}
	 	sectionIndex++;
	}
	#ifdef UNITY_PASS_SHADOWCASTER
	if ( unity_LightShadowBias.z == 0.0 )
	{
	#endif
	 	if ( result.z > 1 )
	 	 	clip( -1 );
	#ifdef UNITY_PASS_SHADOWCASTER
	}
	#endif
	return uvs.xy + finalTexOffset;
}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 appendResult47 = (float2(_CurvatureU , _CurvatureV));
			float2 OffsetPOM8 = POM( _HeightMap, uv_Albedo, ddx(uv_Albedo), ddy(uv_Albedo), ase_worldNormal, ase_worldViewDir, i.viewDir, 128, 128, 10, _Scale, 0, _HeightMap_ST.xy, appendResult47, 0 );
			float2 customUVs39 = OffsetPOM8;
			float2 temp_output_40_0 = ddx( uv_Albedo );
			float2 temp_output_41_0 = ddy( uv_Albedo );
			o.Normal = UnpackScaleNormal( tex2D( _Normal, customUVs39, temp_output_40_0, temp_output_41_0 ), _NormalScale );
			o.Albedo = tex2D( _Albedo, customUVs39, temp_output_40_0, temp_output_41_0 ).rgb;
			o.Metallic = tex2D( _Metallic, customUVs39, temp_output_40_0, temp_output_41_0 ).r;
			o.Smoothness = ( 1.0 - ( _RoughScale * tex2D( _Roughness, customUVs39, temp_output_40_0, temp_output_41_0 ).r ) );
			o.Occlusion = tex2D( _Occlusion, customUVs39, temp_output_40_0, temp_output_41_0 ).r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0
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
Node;AmplifyShaderEditor.RangedFloatNode;43;-1504,384;Float;False;Property;_CurvatureU;Curvature U;9;0;Create;True;0;0;0;False;0;False;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1504,464;Float;False;Property;_CurvatureV;Curvature V;10;0;Create;True;0;0;0;False;0;False;0;0;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;15;-1296,192;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;47;-1168,368;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-1729,0.5;Float;True;Property;_HeightMap;HeightMap;7;0;Create;True;0;0;0;False;0;False;None;085af6efd01d48aaa9981d4b8d75ecce;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;13;-1448,78.5;Float;False;Property;_Scale;Scale;8;0;Create;True;0;0;0;False;0;False;0.4247461;0.095;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1384,-81.5;Inherit;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;8;-1032.9,-21.1;Inherit;False;0;128;False;;128;False;;10;0.02;0;False;1,1;True;10,0;11;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;7;SAMPLERSTATE;;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;8;INT;0;False;9;INT;0;False;10;INT;0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdyOpNode;41;-656,-96;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-752,-240;Float;False;customUVs;1;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdxOpNode;40;-656,-160;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;192,256;Float;False;Property;_RoughScale;Rough Scale;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;64,336;Inherit;True;Property;_Roughness;Roughness;4;0;Create;True;0;0;0;False;0;False;-1;None;b6a6c7bc322040c5b1fed27b535af25f;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;21;64,528;Inherit;True;Property;_Occlusion;Occlusion;6;0;Create;True;0;0;0;False;0;False;-1;None;d6dd85c78644495f98c427634c7d81e7;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;24;-292.5285,-343.4738;Float;False;Property;_NormalScale;Normal Scale;2;0;Create;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;384,256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;64,-320;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;4998839cc7304cff87a29e2535dd1bbb;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;29;620.7496,395.8717;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;64,64;Inherit;True;Property;_Metallic;Metallic;3;0;Create;True;0;0;0;False;0;False;-1;None;0f1be42ec7d6427fbeb99bb7a4480d54;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;14;64,-128;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;None;0e5318892134427a92eb01a797250708;True;0;True;bump;Auto;True;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;42;496,80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;780.7046,-269.0693;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Parallax Occlusion Mapping;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;43;0
WireConnection;47;1;45;0
WireConnection;8;0;10;0
WireConnection;8;1;9;0
WireConnection;8;2;13;0
WireConnection;8;3;15;0
WireConnection;8;5;47;0
WireConnection;41;0;10;0
WireConnection;39;0;8;0
WireConnection;40;0;10;0
WireConnection;20;1;39;0
WireConnection;20;3;40;0
WireConnection;20;4;41;0
WireConnection;21;1;39;0
WireConnection;21;3;40;0
WireConnection;21;4;41;0
WireConnection;26;0;25;0
WireConnection;26;1;20;1
WireConnection;11;1;39;0
WireConnection;11;3;40;0
WireConnection;11;4;41;0
WireConnection;29;0;21;1
WireConnection;23;1;39;0
WireConnection;23;3;40;0
WireConnection;23;4;41;0
WireConnection;14;1;39;0
WireConnection;14;3;40;0
WireConnection;14;4;41;0
WireConnection;14;5;24;0
WireConnection;42;0;26;0
WireConnection;0;0;11;0
WireConnection;0;1;14;0
WireConnection;0;3;23;1
WireConnection;0;4;42;0
WireConnection;0;5;29;0
ASEEND*/
//CHKSM=9B463ECC42D6BFF717F20D83BC914E7625DEAB6A