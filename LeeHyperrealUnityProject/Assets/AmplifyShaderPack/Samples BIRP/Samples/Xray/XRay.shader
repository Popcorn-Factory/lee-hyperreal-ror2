// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Xray"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[Header(SURFACE INPUTS)]_BaseColor("Base Color", Color) = (1,1,1,0)
		_Brightness("Brightness", Range( 0 , 2)) = 1
		[SingleLineTexture]_MainTex("BaseColor Map", 2D) = "white" {}
		_MainUVs("Main UVs", Vector) = (1,1,0,0)
		[Normal][SingleLineTexture]_BumpMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Float) = 1
		[SingleLineTexture]_MetallicGlossMap("Metallic Map", 2D) = "white" {}
		_MetallicStrength("Metallic Strength", Range( 0 , 1)) = 0
		[SingleLineTexture]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		_OcclusionStrengthAO("Occlusion Strength", Range( 0 , 1)) = 0
		[SingleLineTexture]_SmoothnessMap("Smoothness Map", 2D) = "white" {}
		_SmoothnessStrength("Smoothness Strength", Range( 0 , 1)) = 0
		_XRayIntensity("XRay Intensity", Float) = 1
		[Header(XRAY)][Space(10)]_XRayPower("XRay Power", Float) = 0
		_XRayColor("XRay Color", Color) = (0,0,0,0)
		_XRayScale("XRay Scale", Float) = 0
		_XRayBias("XRay Bias", Float) = 0
		_XRayThickness("XRay Thickness", Range( 0 , 0.5)) = 0
		_XRayDistance("XRay Distance", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0"}
		ZWrite Off
		ZTest Always
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog alpha:fade  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		#include "UnityCG.cginc"
		
		
		
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};
		uniform float _XRayBias;
		uniform float _XRayScale;
		uniform float _XRayPower;
		uniform float4 _XRayColor;
		uniform half _XRayIntensity;
		uniform half _XRayThickness;
		uniform half _XRayDistance;
		
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float4 unityObjectToClipPos25 = UnityObjectToClipPos( ase_vertexNormal );
			float outlineVar = ( _XRayThickness * min( unityObjectToClipPos25.w , _XRayDistance ) );
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV4 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode4 = ( _XRayBias + _XRayScale * pow( 1.0 - fresnelNdotV4, _XRayPower ) );
			o.Emission = ( fresnelNode4 * (_XRayColor).rgb );
			o.Alpha = ( fresnelNode4 * _XRayColor.a * _XRayIntensity );
			o.Normal = float3(0,0,-1);
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+1" }
		Cull [_Cull]
		ZWrite On
		ZTest Equal
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _Cull;
		uniform sampler2D _BumpMap;
		uniform float4 _MainUVs;
		uniform half _NormalStrength;
		uniform half4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform float _MetallicStrength;
		uniform sampler2D _MetallicGlossMap;
		uniform half _SmoothnessStrength;
		uniform sampler2D _SmoothnessMap;
		uniform half _OcclusionStrengthAO;
		uniform sampler2D _OcclusionMap;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_133_0_g1 = ( ( i.uv_texcoord * (_MainUVs).xy ) + (_MainUVs).zw );
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, temp_output_133_0_g1 ), _NormalStrength );
			float4 tex2DNode21_g1 = tex2D( _MainTex, temp_output_133_0_g1 );
			float3 temp_output_89_0_g1 = ( (_BaseColor).rgb * (tex2DNode21_g1).rgb * _Brightness );
			o.Albedo = temp_output_89_0_g1;
			o.Metallic = ( _MetallicStrength * (tex2D( _MetallicGlossMap, temp_output_133_0_g1 )).rgb ).x;
			o.Smoothness = ( _SmoothnessStrength * (tex2D( _SmoothnessMap, temp_output_133_0_g1 )).rgb ).x;
			o.Occlusion = saturate( ( ( 1.0 - _OcclusionStrengthAO ) * (tex2D( _OcclusionMap, temp_output_133_0_g1 )).rgb ) ).x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;18;-1491.319,-38.2028;Inherit;False;1059.143;901.1983;XRay;16;22;23;21;25;24;20;26;27;9;3;7;11;12;4;15;10;;0,0,0,1;0;0
Node;AmplifyShaderEditor.NormalVertexDataNode;23;-1422.708,568.6511;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;25;-1239.045,569.4053;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1347.768,11.7972;Float;False;Property;_XRayBias;XRay Bias;39;0;Create;True;0;0;0;False;0;False;0;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1224.386,729.9371;Half;False;Property;_XRayDistance;XRay Distance;41;0;Create;False;1;;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1359.419,167.0246;Float;False;Property;_XRayPower;XRay Power;36;1;[Header];Create;True;1;XRAY;0;0;False;1;Space(10);False;0;1.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1356.884,91.00397;Float;False;Property;_XRayScale;XRay Scale;38;0;Create;True;0;0;0;False;0;False;0;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-1275.548,256.235;Float;False;Property;_XRayColor;XRay Color;37;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.2969999,1,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.FresnelNode;4;-1161.141,27.07248;Inherit;True;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;27;-1040.722,255.0946;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMinOpNode;21;-1003.877,659.6557;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1145.591,489.459;Half;False;Property;_XRayThickness;XRay Thickness;40;0;Create;False;1;;0;0;False;0;False;0;0.001;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1050.451,414.0627;Half;False;Property;_XRayIntensity;XRay Intensity;35;0;Create;False;0;0;0;False;0;False;1;1.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-853.4857,235.5902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-852.7676,328.7974;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-848.5008,490.7335;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;19;-404.5558,-44.13163;Inherit;False;Material Sample;1;;1;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,0,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.OutlineNode;3;-672.5096,229.6344;Inherit;False;0;True;Transparent;2;7;Back;True;True;True;True;0;False;;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;28;2.772364,-132.0531;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4.025802,-45;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Xray;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;Back;1;False;;5;False;;False;1;False;;1;False;;True;0;Opaque;0.5;True;True;1;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;23;0
WireConnection;4;1;12;0
WireConnection;4;2;11;0
WireConnection;4;3;7;0
WireConnection;27;0;9;0
WireConnection;21;0;25;4
WireConnection;21;1;22;0
WireConnection;10;0;4;0
WireConnection;10;1;27;0
WireConnection;15;0;4;0
WireConnection;15;1;9;4
WireConnection;15;2;26;0
WireConnection;24;0;20;0
WireConnection;24;1;21;0
WireConnection;3;0;10;0
WireConnection;3;2;15;0
WireConnection;3;1;24;0
WireConnection;0;0;19;1
WireConnection;0;1;19;6
WireConnection;0;3;19;3
WireConnection;0;4;19;2
WireConnection;0;5;19;4
WireConnection;0;11;3;0
ASEEND*/
//CHKSM=B2DE1B6DB5E831DA59FE2B7383D84FA4B92FCEF0