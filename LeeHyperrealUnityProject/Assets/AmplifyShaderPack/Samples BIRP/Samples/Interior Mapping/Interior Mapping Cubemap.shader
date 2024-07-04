// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Interior Mapping/Cubemap"
{
	Properties
	{
		_RoomCountX("Room Count X", Float) = 4
		_RoomCountY("Room Count Y", Float) = 4
		[SingleLineTexture]_InteriorCube("Interior Cube", CUBE) = "white" {}
		[Header(FACADE)][ToggleUI]_EnableFacade("Enable Facade", Float) = 0
		[SingleLineTexture]_FacadeMap("Facade Map", 2D) = "white" {}
		_FacadeTilling("Facade Tilling", Vector) = (1,1,0,0)
		_EmissiveIntensity("Emissive Intensity", Float) = 1
		[SingleLineTexture]_Roof("Roof", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
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
			float3 viewDir;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform samplerCUBE _InteriorCube;
		uniform float _RoomCountX;
		uniform float _RoomCountY;
		uniform sampler2D _FacadeMap;
		uniform float4 _FacadeTilling;
		uniform float _EnableFacade;
		uniform sampler2D _Roof;
		uniform float4 _Roof_ST;
		uniform half _EmissiveIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 temp_output_28_0_g126 = ( i.viewDir * float3( -1,1,1 ) );
			float3 temp_output_17_0_g126 = ( float3( 1,1,1 ) / temp_output_28_0_g126 );
			float2 appendResult182 = (float2(_RoomCountX , _RoomCountY));
			float2 temp_output_32_0_g126 = ( i.uv_texcoord * appendResult182 );
			float3 appendResult29_g126 = (float3(( ( frac( temp_output_32_0_g126 ) * float2( 2,-2 ) ) - float2( 1,-1 ) ) , -1.0));
			float3 break19_g126 = ( abs( temp_output_17_0_g126 ) - ( temp_output_17_0_g126 * appendResult29_g126 ) );
			float3 temp_output_30_0_g126 = ( ( min( min( break19_g126.x , break19_g126.y ) , break19_g126.z ) * temp_output_28_0_g126 ) + appendResult29_g126 );
			float2 break36_g126 = floor( temp_output_32_0_g126 );
			float3 appendResult10_g126 = (float3(break36_g126.x , break36_g126.y , break36_g126.x));
			float dotResult5_g126 = dot( appendResult10_g126 , float3(127.1,311.7,74.7) );
			float3 appendResult3_g126 = (float3(break36_g126.y , break36_g126.x , break36_g126.x));
			float dotResult4_g126 = dot( appendResult3_g126 , float3(269.5,183.3,246.1) );
			float3 appendResult8_g126 = (float3(break36_g126.x , break36_g126.y , break36_g126.y));
			float dotResult7_g126 = dot( appendResult8_g126 , float3(113.5,271.9,124.6) );
			float3 appendResult6_g126 = (float3(dotResult5_g126 , dotResult4_g126 , dotResult7_g126));
			float3 temp_output_39_0_g126 = round( frac( ( sin( appendResult6_g126 ) * 43758.55 ) ) );
			float3 break40_g126 = temp_output_39_0_g126;
			float3 lerpResult42_g126 = lerp( float3(-1,1,1) , float3(1,1,-1) , break40_g126.x);
			float3 lerpResult43_g126 = lerp( float3(1,1,1) , float3(-1,1,1) , break40_g126.y);
			float3 temp_output_89_0_g126 = ( temp_output_30_0_g126 * ( lerpResult42_g126 * lerpResult43_g126 ) );
			float3 lerpResult55_g126 = lerp( temp_output_89_0_g126 , (temp_output_89_0_g126).zyx , break40_g126.z);
			float3 break120_g126 = lerpResult55_g126;
			float3 appendResult121_g126 = (float3(break120_g126.x , ( break120_g126.y * -1.0 ) , break120_g126.z));
			float3 temp_output_31_0 = (texCUBElod( _InteriorCube, float4( appendResult121_g126, 0.0) )).rgb;
			float3 InteriorMapping406 = temp_output_31_0;
			float4 tex2DNode178 = tex2D( _FacadeMap, ( ( i.uv_texcoord * (_FacadeTilling).xy ) + (_FacadeTilling).zw ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV27 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode27 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV27 , 0.0001 ), 0.1 ) );
			float temp_output_25_0 = ( ( tex2DNode178.a * 0.2 ) * ( 1.0 - fresnelNode27 ) );
			float3 lerpResult80 = lerp( (tex2DNode178).rgb , temp_output_31_0 , temp_output_25_0);
			float3 Facade86 = lerpResult80;
			float3 lerpResult399 = lerp( InteriorMapping406 , Facade86 , _EnableFacade);
			float2 uv_Roof = i.uv_texcoord * _Roof_ST.xy + _Roof_ST.zw;
			float4 lerpResult405 = lerp( float4( lerpResult399 , 0.0 ) , tex2D( _Roof, uv_Roof ) , ase_worldNormal.y);
			o.Albedo = lerpResult405.rgb;
			float3 Emission85 = ( ( ( temp_output_25_0 * temp_output_31_0 ) * round( (temp_output_39_0_g126).y ) ) * _EmissiveIntensity );
			float3 lerpResult395 = lerp( float3( 0,0,0 ) , Emission85 , _EnableFacade);
			float3 lerpResult404 = lerp( lerpResult395 , float3( 0,0,0 ) , ase_worldNormal.y);
			o.Emission = lerpResult404;
			float FacadeAlpha175 = tex2DNode178.a;
			float lerpResult397 = lerp( 0.0 , FacadeAlpha175 , _EnableFacade);
			float lerpResult403 = lerp( lerpResult397 , 0.0 , ase_worldNormal.y);
			o.Metallic = lerpResult403;
			o.Smoothness = lerpResult403;
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
Node;AmplifyShaderEditor.TexCoordVertexDataNode;21;-1948.861,201.1267;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;387;-1568.707,271.9924;Inherit;False;Property;_FacadeTilling;Facade Tilling;5;0;Create;True;0;0;0;False;0;False;1,1,0,0;2,2,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;180;-2037.864,946.8691;Inherit;False;Property;_RoomCountX;Room Count X;0;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-2039.052,1020.557;Inherit;False;Property;_RoomCountY;Room Count Y;1;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;186;-1737.05,257.0649;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;384;-1371.707,272.9924;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;-1865.399,973.0163;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;187;-1732.427,923.0371;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;383;-1219.998,201.7634;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;386;-1372.707,339.9924;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;378;-1654.479,951.4177;Inherit;False;UV Interior Cubemap;-1;;126;22dbe19408af0d14db5aa16670d14906;1,59,1;2;62;FLOAT2;0,0;False;58;FLOAT2;1,1;False;2;FLOAT3;56;FLOAT3;61
Node;AmplifyShaderEditor.SimpleAddOpNode;385;-1079.804,323.793;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;388;-712.217,981.3679;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;177;-905.4621,129.3215;Inherit;True;Property;_FacadeMap;Facade Map;4;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;178;-631.3651,297.8752;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;389;-698.217,949.3679;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;78;-944.4854,762.4339;Inherit;True;Property;_InteriorCube;Interior Cube;2;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;LockedToCube;Cube;-1;0;2;SAMPLERCUBE;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FresnelNode;27;-737.7936,524.1855;Inherit;False;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-296.0719,467.0317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-499.0524,524.1854;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;122;-640.4485,764.6312;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToCube;False;Object;-1;MipLevel;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-140.5865,497.8565;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;31;-130.9638,763.6857;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;81;-148.6784,975.7328;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;82;14.01613,981.0561;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;63.21346,856.1479;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;23;-146.5719,300.4169;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;218.5422,959.7609;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;382;148.1217,1055.199;Half;False;Property;_EmissiveIntensity;Emissive Intensity;6;0;Create;False;1;;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;52.13768,451.0452;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;383.2361,958.9758;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;20;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;555.5333,953.6929;Inherit;False;Emission;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-298.1453,391.6384;Inherit;False;FacadeAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;220.1564,447.1785;Inherit;False;Facade;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;406;78.36826,765.6061;Inherit;False;InteriorMapping;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;396;-272.3471,-364.9544;Inherit;False;85;Emission;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;-286.075,-178.5773;Inherit;False;175;FacadeAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-268.7606,-787.231;Inherit;False;Property;_EnableFacade;Enable Facade;3;2;[Header];[ToggleUI];Create;True;1;FACADE;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;400;-290.7706,-676.6565;Inherit;False;406;InteriorMapping;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;401;-257.6644,-604.2272;Inherit;False;86;Facade;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;193;-888.3286,-569.7828;Inherit;True;Property;_Roof;Roof;7;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;aab8de1052c54173b3d61e7f8b05aedf;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;395;-48.25252,-383.0475;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;397;-43.09511,-195.3712;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;399;-40.22823,-673.8951;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;192;-611.246,-569.8152;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WorldNormalVector;407;8.577641,-29.43853;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;403;222.9497,-220.7611;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;404;214.7309,-382.2149;Inherit;False;3;0;FLOAT3;1,1,1;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;405;212.0719,-587.0376;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;464.73,-583.1663;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASE/Interior Mapping/Cubemap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;186;0;21;0
WireConnection;384;0;387;0
WireConnection;182;0;180;0
WireConnection;182;1;181;0
WireConnection;187;0;186;0
WireConnection;383;0;21;0
WireConnection;383;1;384;0
WireConnection;386;0;387;0
WireConnection;378;62;187;0
WireConnection;378;58;182;0
WireConnection;385;0;383;0
WireConnection;385;1;386;0
WireConnection;388;0;378;56
WireConnection;178;0;177;0
WireConnection;178;1;385;0
WireConnection;178;7;177;1
WireConnection;389;0;388;0
WireConnection;24;0;178;4
WireConnection;26;0;27;0
WireConnection;122;0;78;0
WireConnection;122;1;389;0
WireConnection;122;7;78;1
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;31;0;122;0
WireConnection;81;0;378;61
WireConnection;82;0;81;0
WireConnection;29;0;25;0
WireConnection;29;1;31;0
WireConnection;23;0;178;0
WireConnection;83;0;29;0
WireConnection;83;1;82;0
WireConnection;80;0;23;0
WireConnection;80;1;31;0
WireConnection;80;2;25;0
WireConnection;84;0;83;0
WireConnection;84;1;382;0
WireConnection;85;0;84;0
WireConnection;175;0;178;4
WireConnection;86;0;80;0
WireConnection;406;0;31;0
WireConnection;395;1;396;0
WireConnection;395;2;402;0
WireConnection;397;1;398;0
WireConnection;397;2;402;0
WireConnection;399;0;400;0
WireConnection;399;1;401;0
WireConnection;399;2;402;0
WireConnection;192;0;193;0
WireConnection;192;7;193;1
WireConnection;403;0;397;0
WireConnection;403;2;407;2
WireConnection;404;0;395;0
WireConnection;404;2;407;2
WireConnection;405;0;399;0
WireConnection;405;1;192;0
WireConnection;405;2;407;2
WireConnection;0;0;405;0
WireConnection;0;2;404;0
WireConnection;0;3;403;0
WireConnection;0;4;403;0
ASEEND*/
//CHKSM=5C495DD062AC77942EDFB9EC081DD26E708186A7