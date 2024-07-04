// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Parallax Window"
{
	Properties
	{
		[SingleLineTexture]_Mask("Mask", 2D) = "white" {}
		[SingleLineTexture]_Front("Front", 2D) = "white" {}
		_Specular("Specular", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[SingleLineTexture]_Middle("Middle", 2D) = "white" {}
		_MidDark("Mid Dark", Float) = 0.3
		_MidDepthScale("Mid Depth Scale", Range( 0 , 1)) = 0.3
		[SingleLineTexture]_Back("Back", 2D) = "white" {}
		_BackDark("Back Dark", Float) = 0.7
		_BackDepthScale("Back Depth Scale", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 2.5
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

		uniform sampler2D _Back;
		uniform float _BackDepthScale;
		uniform float _BackDark;
		uniform sampler2D _Middle;
		uniform float _MidDepthScale;
		uniform float _MidDark;
		uniform sampler2D _Mask;
		uniform sampler2D _Front;
		uniform float _Specular;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Normal = float3(0,0,1);
			half2 Offset75 = ( ( 0.0 - 1 ) * i.viewDir.xy * _BackDepthScale ) + i.uv_texcoord;
			half2 Offset76 = ( ( 0.0 - 1 ) * i.viewDir.xy * _MidDepthScale ) + i.uv_texcoord;
			half MaskG_Depth115 = tex2D( _Mask, Offset76 ).g;
			half3 lerpResult48 = lerp( ( (tex2D( _Back, Offset75 )).rgb * _BackDark ) , ( (tex2D( _Middle, Offset76 )).rgb * _MidDark ) , MaskG_Depth115);
			half MaskR116 = tex2D( _Mask, i.uv_texcoord ).r;
			half3 lerpResult58 = lerp( lerpResult48 , (tex2D( _Front, i.uv_texcoord )).rgb , MaskR116);
			o.Albedo = lerpResult58;
			half temp_output_87_0 = ( 1.0 - MaskR116 );
			half3 temp_cast_0 = (( temp_output_87_0 * _Specular )).xxx;
			o.Specular = temp_cast_0;
			o.Smoothness = ( temp_output_87_0 * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.5
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
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
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
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1021.42,-1281.455;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;51;-983.5194,-1432.983;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;128;-784.5581,-1199.168;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;130;-798.5581,-1363.168;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;107;-1097.125,-341.7402;Inherit;True;Property;_Mask;Mask;0;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;c872b3c26a0746d6bf78d72a97219610;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;114;-768.1707,-1089.109;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;129;-783.5581,-1193.168;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;131;-798.5581,-1361.168;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;132;-773.6438,-812.4906;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;133;-774.6438,-766.4906;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1043.944,-699.6749;Float;False;Property;_BackDepthScale;Back Depth Scale;9;0;Create;True;0;0;0;False;0;False;0;0.404;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;125;-502.6983,-311.8188;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ParallaxMappingNode;75;-700.2151,-822.913;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;124;-470.057,-356.7029;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;127;-737.5581,-1060.168;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;134;-763.6438,-498.4906;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;135;-769.6438,-551.4906;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1051.987,-430.4254;Float;False;Property;_MidDepthScale;Mid Depth Scale;6;0;Create;True;0;0;0;False;0;False;0.3;0.346;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;109;-1095.806,-1122.406;Inherit;True;Property;_Front;Front;1;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;795be3819bc943f1a76df62b635eb923;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;108;-1094.512,-890.1976;Inherit;True;Property;_Back;Back;7;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;ed8f29aaf6284591aa4827fba45b1f1c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;110;-377.4872,-892.1011;Inherit;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;113;-389.1624,-1117.406;Inherit;True;Property;_TextureSample4;Texture Sample 4;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;126;-466.6609,-1217.229;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ParallaxMappingNode;76;-697.0419,-539.5026;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;106;-1092.616,-623.2883;Inherit;True;Property;_Middle;Middle;4;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;accb8ee69e224c31938333e9767db87b;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;111;-395.1904,-625.4205;Inherit;True;Property;_TextureSample2;Texture Sample 2;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;123;-390.8496,-1307.489;Inherit;True;Property;_TextureSample5;Texture Sample 5;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;112;-400.8315,-343.3704;Inherit;True;Property;_TextureSample3;Texture Sample 3;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwizzleNode;150;-68.29872,-1117.415;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;154;-61.19095,-892.544;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;61;88.42287,-817.5484;Float;False;Property;_BackDark;Back Dark;8;0;Create;True;0;0;0;False;0;False;0.7;0.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;260.4841,-890.6387;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-65.14423,-298.2936;Inherit;False;MaskG_Depth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-62.6604,-1286.124;Inherit;False;MaskR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;155;-64.23296,-625.8689;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;64;88.74471,-551.8052;Float;False;Property;_MidDark;Mid Dark;5;0;Create;True;0;0;0;False;0;False;0.3;0.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;151;618.3954,-1077.011;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;260.1028,-621.6811;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;136;396.9352,-807.3286;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;685.157,-371.0128;Inherit;False;116;MaskR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;280.675,-507.0262;Inherit;False;115;MaskG_Depth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;152;652.0889,-1039.262;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;48;482.4169,-643.6926;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;536.6567,-510.3054;Inherit;False;116;MaskR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;742.5325,-291.7744;Float;False;Property;_Specular;Specular;2;0;Create;True;0;0;0;False;0;False;0;0.302;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;87;857.6475,-366.627;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;741.1901,-219.6163;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0;0.847;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;153;664.0242,-634.771;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;58;752.6898,-641.2009;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;50;1023.076,-525.9036;Float;False;Constant;_Vector0;Vector 0;-1;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StickyNoteNode;137;-1316.321,-885.2695;Inherit;False;211.2463;123.2736;Back;;0,0,0,1;Back room layer texture for the interior.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;138;-39.48919,-745.0349;Inherit;False;262.0659;100;;;0,0,0,1;Value to darken the back room layer interior color.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;139;-717.3309,-683.1554;Inherit;False;219.8209;102.4499;Back Depth Scale;;0,0,0,1;Scale value for the back room layer interior parallax effect.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;140;-1311.422,-618.2344;Inherit;False;207.5717;113.4742;Middle;;0.02830189,0.02830189,0.02830189,1;Middle room layer texture for the interior.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;141;974.8732,-884.4379;Inherit;False;521.637;215.047;Fake Interiors Free;;0,0,0,1;This sample combines a facade and room interior (with two layers)$$Texture using a parallax effect giving the illusion of a fake 3D interior. $$For a more complete sample take a look at our Fake Interiors package over the Unity Asset Store.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;142;-40.54898,-478.7441;Inherit;False;263.6157;102.7194;;;0,0,0,1;Value to darken the middle room layer interior color.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;143;-712.6259,-403.7371;Inherit;False;220.2377;103.3986;Mid Depth Scale;;0,0,0,1;Scale value for the middle room layer interior parallax effect.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;144;-1309.646,-1123.107;Inherit;False;202.1118;103.3986;Front;;0,0,0,1;Facade texture.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;145;-1416.99,-340.0237;Inherit;False;309.5699;185.2043;Mask;;0,0,0,1;Texture that controls where to show face and interior layers. $$R channel $Controls facade/interior$$G channel $Controls Back/Mid interior.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;146;433.8353,-296.1753;Inherit;False;273.4824;101.1329;Specular;;0.02830189,0.02830189,0.02830189,1;Overall specular strength. (takes Mask R channel into account);0;0
Node;AmplifyShaderEditor.StickyNoteNode;147;438.3668,-184.0215;Inherit;False;271.2167;100;Smoothness;;0,0,0,1;Overall smoothness strength. (takes Mask R channel into account);0;0
Node;AmplifyShaderEditor.StickyNoteNode;148;-62.13696,-1216.471;Inherit;False;256;115;Mask R;;0,0,0,1;Masking facade with interior;0;0
Node;AmplifyShaderEditor.StickyNoteNode;149;-68.5424,-225.012;Inherit;False;326.2001;100;Mask G Parallax Masking;;0,0,0,1;Parallax Masking the Middle and Back textures ;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;1042.971,-364.5944;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;1040.675,-276.096;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1281.25,-639.9696;Half;False;True;-1;1;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Parallax Window;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;128;0;9;0
WireConnection;130;0;51;0
WireConnection;114;0;9;0
WireConnection;129;0;9;0
WireConnection;131;0;51;0
WireConnection;132;0;128;0
WireConnection;133;0;130;0
WireConnection;125;0;107;0
WireConnection;75;0;132;0
WireConnection;75;2;54;0
WireConnection;75;3;133;0
WireConnection;124;0;125;0
WireConnection;127;0;114;0
WireConnection;134;0;131;0
WireConnection;135;0;129;0
WireConnection;110;0;108;0
WireConnection;110;1;75;0
WireConnection;113;0;109;0
WireConnection;113;1;127;0
WireConnection;126;0;124;0
WireConnection;76;0;135;0
WireConnection;76;2;49;0
WireConnection;76;3;134;0
WireConnection;111;0;106;0
WireConnection;111;1;76;0
WireConnection;123;0;126;0
WireConnection;123;1;9;0
WireConnection;112;0;107;0
WireConnection;112;1;76;0
WireConnection;150;0;113;0
WireConnection;154;0;110;0
WireConnection;59;0;154;0
WireConnection;59;1;61;0
WireConnection;115;0;112;2
WireConnection;116;0;123;1
WireConnection;155;0;111;0
WireConnection;151;0;150;0
WireConnection;63;0;155;0
WireConnection;63;1;64;0
WireConnection;136;0;59;0
WireConnection;152;0;151;0
WireConnection;48;0;136;0
WireConnection;48;1;63;0
WireConnection;48;2;117;0
WireConnection;87;0;122;0
WireConnection;153;0;152;0
WireConnection;58;0;48;0
WireConnection;58;1;153;0
WireConnection;58;2;121;0
WireConnection;88;0;87;0
WireConnection;88;1;73;0
WireConnection;89;0;87;0
WireConnection;89;1;74;0
WireConnection;0;0;58;0
WireConnection;0;1;50;0
WireConnection;0;3;88;0
WireConnection;0;4;89;0
ASEEND*/
//CHKSM=DA060A058A00B9D5B97FD50489FF66DBA42E9311