// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Vector Displacement Simple"
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
		[SingleLineTexture]_SpecularMap("Specular Map", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_SpecularStrength("Specular Strength", Range( 0 , 1)) = 0.04
		[SingleLineTexture]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		_OcclusionStrengthAO("Occlusion Strength", Range( 0 , 1)) = 0
		[SingleLineTexture]_SmoothnessMap("Smoothness Map", 2D) = "white" {}
		_SmoothnessStrength("Smoothness Strength", Range( 0 , 1)) = 0
		[Header(VECTOR DISPLACEMENT)][SingleLineTexture]_VDMMap("VDM Map", 2D) = "white" {}
		_ExtrudeAmount("Extrude Amount", Range( 0 , 1)) = 0.1
		_BaseColorVDM("Base Color", Color) = (0.9245283,0.9245283,0.9245283,0)
		[SingleLineTexture]_MainTexVDM("Base Map", 2D) = "white" {}
		_VDMUVs("VDM UVs", Vector) = (1,1,0,0)
		[Normal][SingleLineTexture]_BumpMapVDM("Normal Map", 2D) = "bump" {}
		_NormalStrengthVDM("Normal Strength", Float) = 0.95
		[Header(TESSELLATION)]_TessellationStrength("Tessellation Strength", Range( 0.0001 , 100)) = 100
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _Cull;
		uniform sampler2D _VDMMap;
		uniform float4 _VDMUVs;
		uniform float _ExtrudeAmount;
		uniform sampler2D _BumpMap;
		uniform float4 _MainUVs;
		uniform half _NormalStrength;
		uniform sampler2D _BumpMapVDM;
		uniform half _NormalStrengthVDM;
		uniform sampler2D _MainTexVDM;
		uniform half4 _BaseColor;
		uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform half4 _BaseColorVDM;
		uniform float4 _SpecularColor;
		uniform sampler2D _SpecularMap;
		uniform half _SpecularStrength;
		uniform half _SmoothnessStrength;
		uniform sampler2D _SmoothnessMap;
		uniform half _OcclusionStrengthAO;
		uniform sampler2D _OcclusionMap;
		uniform half _TessellationStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			half4 temp_cast_0 = (_TessellationStrength).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_output_334_0 = ( ( v.texcoord.xy * (_VDMUVs).xy ) + (_VDMUVs).zw );
			float4 tex2DNode347 = tex2Dlod( _VDMMap, float4( temp_output_334_0, 0, 0.0) );
			float3 appendResult354 = (float3(tex2DNode347.r , tex2DNode347.b , tex2DNode347.g));
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			half tangentSign = v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
			float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * tangentSign;
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float3 tangentTobjectDir364 = mul( unity_WorldToObject, float4( mul( ase_tangentToWorldFast, appendResult354 ), 0 ) ).xyz;
			float temp_output_368_0 = (0.0 + (_ExtrudeAmount - 0.0) * (5.0 - 0.0) / (100.0 - 0.0));
			float3 VDMVertexOffset378 = ( tangentTobjectDir364 * temp_output_368_0 );
			v.vertex.xyz += VDMVertexOffset378;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 temp_output_133_0_g2 = ( ( i.uv_texcoord * (_MainUVs).xy ) + (_MainUVs).zw );
			float3 Normal392 = UnpackScaleNormal( tex2D( _BumpMap, temp_output_133_0_g2 ), _NormalStrength );
			float2 temp_output_334_0 = ( ( i.uv_texcoord * (_VDMUVs).xy ) + (_VDMUVs).zw );
			float4 tex2DNode336 = tex2D( _MainTexVDM, temp_output_334_0 );
			float BaseMap_Alpha365 = tex2DNode336.a;
			float3 lerpResult357 = lerp( Normal392 , (UnpackScaleNormal( tex2D( _BumpMapVDM, temp_output_334_0 ), _NormalStrengthVDM )).yxz , BaseMap_Alpha365);
			float3 normalizeResult358 = normalize( lerpResult357 );
			float3 break356 = normalizeResult358;
			float3 appendResult346 = (float3(break356.x , break356.y , ( break356.z + 0.001 )));
			float temp_output_368_0 = (0.0 + (_ExtrudeAmount - 0.0) * (5.0 - 0.0) / (100.0 - 0.0));
			float VDMMask413 = ( 0.0 == temp_output_368_0 ? 0.0 : 1.0 );
			float3 lerpResult361 = lerp( Normal392 , appendResult346 , VDMMask413);
			float3 VDMNormal379 = lerpResult361;
			o.Normal = VDMNormal379;
			float4 tex2DNode21_g2 = tex2D( _MainTex, temp_output_133_0_g2 );
			float3 temp_output_89_0_g2 = ( (_BaseColor).rgb * (tex2DNode21_g2).rgb * _Brightness );
			float3 BaseColor385 = temp_output_89_0_g2;
			float4 lerpResult339 = lerp( float4( BaseColor385 , 0.0 ) , ( float4( (_BaseColorVDM).rgb , 0.0 ) * tex2DNode336 ) , tex2DNode336.a);
			float4 lerpResult324 = lerp( float4( BaseColor385 , 0.0 ) , lerpResult339 , VDMMask413);
			float4 VDMBaseColor394 = lerpResult324;
			o.Albedo = VDMBaseColor394.rgb;
			float3 temp_output_202_0_g2 = (_SpecularColor).rgb;
			o.Specular = ( temp_output_202_0_g2 * (tex2D( _SpecularMap, temp_output_133_0_g2 )).rgb * _SpecularStrength );
			o.Smoothness = ( _SmoothnessStrength * (tex2D( _SmoothnessMap, temp_output_133_0_g2 )).rgb ).x;
			o.Occlusion = saturate( ( ( 1.0 - _OcclusionStrengthAO ) * (tex2D( _OcclusionMap, temp_output_133_0_g2 )).rgb ) ).x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;400;-2829.118,-4107.301;Inherit;False;2936.729;2031.174;Vector Displacement  Mapping;50;365;348;379;413;378;418;416;349;360;376;346;356;355;361;393;358;357;353;362;327;369;368;375;347;364;354;367;414;363;344;343;342;333;334;394;374;388;384;324;386;339;326;336;380;335;340;325;417;423;426;;0,0,0,1;0;0
Node;AmplifyShaderEditor.Vector4Node;344;-2726.708,-3869.335;Inherit;False;Property;_VDMUVs;VDM UVs;39;0;Create;False;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;342;-2543.189,-3893.294;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;363;-2602.275,-4017.54;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;333;-2380.241,-3915.024;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;343;-2543.189,-3810.293;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;334;-2235.627,-3831.063;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;419;-2090.432,-3783.696;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;423;-2090.432,-3780.696;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;421;-2087.432,-3656.696;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;424;-2077.25,-2907.523;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;376;-2338.166,-2933.242;Inherit;True;Property;_BumpMapVDM;Normal Map;40;2;[Normal];[SingleLineTexture];Create;False;0;0;0;False;0;False;None;876de209eecfa1d46b133f7f6abeda72;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;374;-2339.197,-3701.378;Inherit;True;Property;_MainTexVDM;Base Map;38;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;897c9014cba411f47bd7278a4bc3d31e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;336;-2018.365,-3700.608;Inherit;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;353;-1930.917,-2739.866;Half;False;Property;_NormalStrengthVDM;Normal Strength;41;0;Create;False;1;;0;0;False;0;False;0.95;1.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;408;264.4659,-4075.851;Inherit;False;Material Sample;1;;2;09f1910db887ebd4cb569d6c76c63be3;4,251,0,216,0,263,0,346,1;0;12;FLOAT3;1;FLOAT3;6;FLOAT3;372;FLOAT3;328;FLOAT3;3;FLOAT3;5;FLOAT3;2;FLOAT3;4;FLOAT;8;FLOAT;71;FLOAT;72;FLOAT3;378
Node;AmplifyShaderEditor.SamplerNode;362;-2017.299,-2931.416;Inherit;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.UnpackScaleNormalNode;360;-1686.225,-2926.257;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;392;599.262,-4060.432;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;365;-1669.243,-3522.608;Inherit;False;BaseMap_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;393;-1267.308,-3034.2;Inherit;False;392;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;349;-1443.241,-2931.483;Inherit;False;FLOAT3;1;0;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;348;-1303.489,-2836.943;Inherit;False;365;BaseMap_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;369;-1862.572,-3394.98;Float;False;Property;_ExtrudeAmount;Extrude Amount;36;0;Create;True;1;;0;0;False;0;False;0.1;0.212;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;357;-1080.379,-2947.705;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;420;-2093.432,-3775.696;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;340;-1945.446,-3866.038;Half;False;Property;_BaseColorVDM;Base Color;37;0;Create;False;0;0;0;False;0;False;0.9245283,0.9245283,0.9245283,0;0.9245283,0.9245283,0.9245283,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TFHCRemapNode;368;-1540.291,-3388.355;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;3;FLOAT;0;False;4;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;358;-922.9582,-2945.799;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;422;-2082.432,-3214.696;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;375;-2353.227,-3242.497;Inherit;True;Property;_VDMMap;VDM Map;35;2;[Header];[SingleLineTexture];Create;False;1;VECTOR DISPLACEMENT;0;0;False;0;False;None;cfedd5f350467c44195a77151e768abd;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SwizzleNode;335;-1689.645,-3865.838;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;388;-1213.528,-3577.427;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;347;-2025.702,-3242.012;Inherit;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.Compare;327;-1323.962,-3415.995;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;356;-755.6452,-2943.475;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;385;599.505,-4139.19;Inherit;False;BaseColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;426;-836.7802,-2767.173;Float;False;Constant;_Float8;Float 7;9;0;Create;True;0;0;0;False;0;False;0.001;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;-1504.591,-3717.059;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;386;-1288.103,-3807.369;Inherit;False;385;BaseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;384;-1178.951,-3616.314;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;354;-1710.799,-3213.683;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;355;-622.3745,-2848.82;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;413;-1141.711,-3413.763;Inherit;False;VDMMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;339;-1103.453,-3739.691;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;414;-1103.272,-3621.228;Inherit;False;413;VDMMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;364;-1562.436,-3218.444;Inherit;False;Tangent;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;346;-499.8301,-2944.626;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;-487.8634,-2822.319;Inherit;False;413;VDMMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;324;-907.4956,-3802.025;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;-1327.945,-3213.161;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;361;-319.683,-3024.425;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;417;-1233.521,-2574.077;Inherit;False;982.4349;347.2087;Example VDM Mask;6;415;366;387;395;337;396;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;394;-735.7462,-3808.521;Inherit;False;VDMBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;378;-1175.169,-3217.689;Inherit;False;VDMVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;379;-141.231,-3028.616;Inherit;False;VDMNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode;325;-1503.653,-3040.354;Inherit;False;194.7;100;Swizzle;;0,0,0,1;Swizzled normal map axis X and Y;0;0
Node;AmplifyShaderEditor.StickyNoteNode;396;-892.5032,-2442.815;Inherit;False;197.9399;100;Emission;;0,0,0,1;Emission Map can be added based on users need$;0;0
Node;AmplifyShaderEditor.SwizzleNode;380;-1688.99,-3699.531;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;337;-650.7689,-2515.354;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;387;-970.7343,-2518.661;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;366;-1182.107,-2517.352;Half;False;Constant;_UVMappingMaskEmissive;Mask Emissive;9;1;[HideInInspector];Create;False;1;;0;0;False;0;False;0.003921569,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;415;-840.3036,-2327.869;Inherit;False;413;VDMMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;395;-477.6725,-2519.837;Inherit;False;VDMEmission;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode;418;-1162.475,-3490.245;Inherit;False;212.5168;176.4097;;;0,0,0,1;Mask;0;0
Node;AmplifyShaderEditor.IntNode;402;1035.755,-4161.938;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;776.7102,-3809.491;Inherit;False;378;VDMVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;406;717.3461,-3731.587;Half;False;Property;_TessellationStrength;Tessellation Strength;42;1;[Header];Create;False;1;TESSELLATION;0;0;False;0;False;100;96.3;0.0001;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;812.7993,-4064.612;Inherit;False;379;VDMNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;399;798.5217,-4138.857;Inherit;False;394;VDMBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StickyNoteNode;425;-901.4811,-2828.441;Inherit;False;247.1831;141.1;to avoid nan after normalizing;;0,0,0,1;mixedNormal.z += 1e-5f@;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;308;1032.716,-4081.919;Float;False;True;-1;6;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Vector Displacement Simple;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;True;True;True;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;1;10;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;342;0;344;0
WireConnection;333;0;363;0
WireConnection;333;1;342;0
WireConnection;343;0;344;0
WireConnection;334;0;333;0
WireConnection;334;1;343;0
WireConnection;419;0;334;0
WireConnection;423;0;334;0
WireConnection;421;0;419;0
WireConnection;424;0;423;0
WireConnection;336;0;374;0
WireConnection;336;1;421;0
WireConnection;336;7;374;1
WireConnection;362;0;376;0
WireConnection;362;1;424;0
WireConnection;362;7;376;1
WireConnection;360;0;362;0
WireConnection;360;1;353;0
WireConnection;392;0;408;6
WireConnection;365;0;336;4
WireConnection;349;0;360;0
WireConnection;357;0;393;0
WireConnection;357;1;349;0
WireConnection;357;2;348;0
WireConnection;420;0;334;0
WireConnection;368;0;369;0
WireConnection;358;0;357;0
WireConnection;422;0;420;0
WireConnection;335;0;340;0
WireConnection;388;0;336;4
WireConnection;347;0;375;0
WireConnection;347;1;422;0
WireConnection;347;7;375;1
WireConnection;327;1;368;0
WireConnection;356;0;358;0
WireConnection;385;0;408;1
WireConnection;326;0;335;0
WireConnection;326;1;336;0
WireConnection;384;0;388;0
WireConnection;354;0;347;1
WireConnection;354;1;347;3
WireConnection;354;2;347;2
WireConnection;355;0;356;2
WireConnection;355;1;426;0
WireConnection;413;0;327;0
WireConnection;339;0;386;0
WireConnection;339;1;326;0
WireConnection;339;2;384;0
WireConnection;364;0;354;0
WireConnection;346;0;356;0
WireConnection;346;1;356;1
WireConnection;346;2;355;0
WireConnection;324;0;386;0
WireConnection;324;1;339;0
WireConnection;324;2;414;0
WireConnection;367;0;364;0
WireConnection;367;1;368;0
WireConnection;361;0;393;0
WireConnection;361;1;346;0
WireConnection;361;2;416;0
WireConnection;394;0;324;0
WireConnection;378;0;367;0
WireConnection;379;0;361;0
WireConnection;337;0;387;0
WireConnection;337;2;415;0
WireConnection;387;0;366;0
WireConnection;395;0;337;0
WireConnection;308;0;399;0
WireConnection;308;1;398;0
WireConnection;308;3;408;5
WireConnection;308;4;408;2
WireConnection;308;5;408;4
WireConnection;308;11;397;0
WireConnection;308;14;406;0
ASEEND*/
//CHKSM=F5F80ACCC249962827B20835E262EB279BF042FA