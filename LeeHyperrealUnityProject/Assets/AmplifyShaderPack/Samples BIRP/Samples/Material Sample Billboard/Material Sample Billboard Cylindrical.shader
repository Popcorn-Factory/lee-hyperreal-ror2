// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Material Sample Billboard Cylindrical"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 0
		[Header(ALPHA CLIPPING)]_AlphaCutoffBias("Alpha Cutoff Bias", Range( 0 , 1)) = 0.5
		[ToggleUI]_GlancingClipMode("Enable Clip Glancing Angle", Float) = 0
		[Header(COLOR)]_BaseColor("Base Color", Color) = (1,1,1,0)
		_Brightness("Brightness", Range( 0 , 2)) = 1
		_MainUVs("Main UVs", Vector) = (1,1,0,0)
		[Header(SURFACE INPUTS)][SingleLineTexture]_MainTex("Base Map", 2D) = "white" {}
		[Space(10)]_SmoothnessStrength("Smoothness Strength", Range( 0 , 1)) = 0
		[Space(10)]_OcclusionStrengthAO("Occlusion Strength", Range( 0 , 1)) = 0
		[Normal][SingleLineTexture][Space(10)]_BumpMap("Normal Map", 2D) = "bump" {}
		[Enum(Flip,0,Mirror,1,None,2)]_DoubleSidedNormalMode("Normal Mode", Float) = 0
		_NormalStrength("Normal Strength", Float) = 1
		[Header(SPECULAR)][ToggleUI]_SpecularEnable("ENABLE SPECULAR", Float) = 0
		[HDR]_SpecularColor("Specular Color", Color) = (0.06666667,0.06666667,0.05882353,0)
		[HideInInspector]_MaskClipValue2("Mask Clip Value", Float) = 0.45
		_SpecularWrapScale("Specular Wrap Scale", Range( 0 , 5)) = 0.85
		_SpecularWrapOffset("Specular Wrap Offset", Range( 0 , 3)) = 0
		_SpecularPower("Specular Power", Range( 0 , 35)) = 25
		_SpecularStrength("Specular Strength", Range( 0 , 15)) = 0.15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeBillboard"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.5
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			half ASEIsFrontFacing : VFACE;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform int _Cull;
		uniform half _DoubleSidedNormalMode;
		uniform sampler2D _BumpMap;
		uniform float4 _MainUVs;
		uniform half _NormalStrength;
		uniform half4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform half4 _SpecularColor;
		uniform half _SpecularWrapScale;
		uniform half _SpecularWrapOffset;
		uniform half _SpecularPower;
		uniform half _SpecularStrength;
		uniform half _SpecularEnable;
		uniform half _SmoothnessStrength;
		uniform half _OcclusionStrengthAO;
		uniform half _AlphaCutoffBias;
		uniform half _GlancingClipMode;
		uniform float _MaskClipValue2;


		float3 _NormalModefloat3switch( float m_switch, float3 m_Flip, float3 m_Mirror, float3 m_None )
		{
			if(m_switch ==0)
				return m_Flip;
			else if(m_switch ==1)
				return m_Mirror;
			else if(m_switch ==2)
				return m_None;
			else
			return float3(0,0,0);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			v.tangent.xyz = normalize( mul( float4( v.tangent.xyz , 0 ), rotationCamMatrix )).xyz;
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
			float3 localVetexOffsetBIRP1052_g38 = ( 0 );
			float3 _Vector0 = float3(0,0,0);
			{
			v.vertex.xyz += _Vector0;
			}
			v.vertex.xyz += localVetexOffsetBIRP1052_g38;
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult960_g38 = dot( ase_normWorldNormal , ase_worldViewDir );
			float3 lerpResult966_g38 = lerp( ase_vertexNormal , -ase_vertexNormal , step( dotResult960_g38 , -1.0 ));
			v.normal = lerpResult966_g38;
			float4 appendResult956_g38 = (float4(cross( ase_vertexNormal , float3(0,0,1) ) , -1.0));
			v.tangent = appendResult956_g38;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float m_switch1079_g38 = _DoubleSidedNormalMode;
			float2 temp_output_1623_0_g38 = ( ( i.uv_texcoord * (_MainUVs).xy ) + (_MainUVs).zw );
			float3 m_Flip1079_g38 = ( UnpackScaleNormal( tex2D( _BumpMap, temp_output_1623_0_g38 ), _NormalStrength ) * i.ASEIsFrontFacing );
			float3 break1074_g38 = UnpackScaleNormal( tex2D( _BumpMap, temp_output_1623_0_g38 ), _NormalStrength );
			float3 appendResult1084_g38 = (float3(break1074_g38.x , break1074_g38.y , ( break1074_g38.z * i.ASEIsFrontFacing )));
			float3 m_Mirror1079_g38 = appendResult1084_g38;
			float3 m_None1079_g38 = UnpackScaleNormal( tex2D( _BumpMap, temp_output_1623_0_g38 ), _NormalStrength );
			float3 local_NormalModefloat3switch1079_g38 = _NormalModefloat3switch( m_switch1079_g38 , m_Flip1079_g38 , m_Mirror1079_g38 , m_None1079_g38 );
			o.Normal = local_NormalModefloat3switch1079_g38;
			float4 tex2DNode3_g38 = tex2D( _MainTex, temp_output_1623_0_g38 );
			o.Albedo = ( (_BaseColor).rgb * (tex2DNode3_g38).rgb * _Brightness );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 Normal937_g38 = UnpackScaleNormal( tex2D( _BumpMap, temp_output_1623_0_g38 ), _NormalStrength );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult1120_g38 = dot( reflect( ase_worldlightDir , (WorldNormalVector( i , Normal937_g38 )) ) , -ase_worldViewDir );
			float temp_output_1144_0_g38 = (max( saturate( dotResult1120_g38 ) , 0.0 )*_SpecularWrapScale + _SpecularWrapOffset);
			float saferPower1116_g38 = abs( temp_output_1144_0_g38 );
			float3 lerpResult1117_g38 = lerp( float3(0,0,0) , saturate( ( ( (_SpecularColor).rgb * ( ase_lightColor.rgb * max( ase_lightColor.a , 0.0 ) ) ) * ( pow( saferPower1116_g38 , _SpecularPower ) * _SpecularStrength ) ) ) , _SpecularEnable);
			o.Specular = lerpResult1117_g38;
			o.Smoothness = saturate( _SmoothnessStrength );
			o.Occlusion = saturate( ( 1.0 - _OcclusionStrengthAO ) );
			float Alpha1243_g38 = tex2DNode3_g38.a;
			clip( Alpha1243_g38 - ( 1.0 - _AlphaCutoffBias ));
			float temp_output_1372_0_g38 = saturate( ( ( Alpha1243_g38 / max( fwidth( Alpha1243_g38 ) , 0.0001 ) ) + 0.5 ) );
			o.Alpha = temp_output_1372_0_g38;
			float3 normalizeResult1355_g38 = normalize( cross( ddy( ase_worldPos ) , ddx( ase_worldPos ) ) );
			float dotResult1335_g38 = dot( normalizeResult1355_g38 , ase_worldViewDir );
			float temp_output_1333_0_g38 = ( 1.0 - abs( dotResult1335_g38 ) );
			#ifdef UNITY_PASS_SHADOWCASTER
				float staticSwitch1329_g38 = 1.0;
			#else
				float staticSwitch1329_g38 = ( 1.0 - ( temp_output_1333_0_g38 * temp_output_1333_0_g38 ) );
			#endif
			float lerpResult1328_g38 = lerp( 1.0 , staticSwitch1329_g38 , _GlancingClipMode);
			clip( lerpResult1328_g38 - _MaskClipValue2 );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;37;128,-80;Inherit;False;Constant;_MaskClipValue2;Mask Clip Value;19;1;[HideInInspector];Create;True;1;;0;0;True;0;False;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;14;128,-160;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;48;-256,0;Inherit;False;Material Sample Billboard;1;;38;e113bea83f119734b93497bfc7434083;8,1406,0,1411,0,1412,0,1416,1,1415,1,1417,1,1414,1,885,1;0;13;FLOAT3;0;FLOAT3;556;FLOAT;56;FLOAT3;770;FLOAT;50;FLOAT;57;FLOAT;49;FLOAT;351;FLOAT;649;FLOAT;1692;FLOAT3;458;FLOAT3;967;FLOAT4;968
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;128,0;Float;False;True;-1;3;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Material Sample Billboard Cylindrical;False;False;False;False;False;False;False;False;False;False;False;False;True;False;True;False;False;False;True;True;True;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.45;True;True;0;True;TreeBillboard;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;True;_MaskClipValue2;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;48;0
WireConnection;0;1;48;556
WireConnection;0;3;48;770
WireConnection;0;4;48;50
WireConnection;0;5;48;57
WireConnection;0;9;48;49
WireConnection;0;10;48;351
WireConnection;0;11;48;458
WireConnection;0;12;48;967
WireConnection;0;16;48;968
ASEEND*/
//CHKSM=5E0CE076AE86A1AC399D51B5F9E6F3B5F3079B5F