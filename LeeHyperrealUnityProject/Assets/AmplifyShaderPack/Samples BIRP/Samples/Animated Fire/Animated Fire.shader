// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Animated Fire"
{
	Properties
	{
		_FireTexture("Fire Texture", 2D) = "white" {}
		_BurnMask("Burn Mask", 2D) = "white" {}
		_FireIntensity("Fire Intensity", Float) = 2
		_FireSpeed("Fire Speed", Float) = 0
		_BurnMaskMult("Burn Mask Mult", Color) = (0,0,0,0)
		_FiretexMult("Fire tex Mult", Color) = (0,0,0,0)
		_BurnRate("Burn Rate", Vector) = (0,0,0,0)
		_edgedissolvestrength("edge dissolve strength", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BurnMask;
		uniform float2 _BurnRate;
		uniform float4 _BurnMaskMult;
		uniform sampler2D _FireTexture;
		uniform float _FireSpeed;
		uniform float4 _FiretexMult;
		uniform float _FireIntensity;
		uniform float _edgedissolvestrength;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 panner56 = ( 1.0 * _Time.y * _BurnRate + i.uv_texcoord);
			float2 temp_cast_0 = (_FireSpeed).xx;
			float cos46 = cos( 4.0 );
			float sin46 = sin( 4.0 );
			float2 rotator46 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos46 , -sin46 , sin46 , cos46 )) + float2( 0.5,0.5 );
			float2 panner2_g4 = ( _Time.x * temp_cast_0 + rotator46);
			float4 temp_output_55_0 = ( ( ( tex2D( _BurnMask, panner56 ) * _BurnMaskMult ) * ( tex2D( _FireTexture, panner2_g4 ) * _FiretexMult ) ) * ( _FireIntensity * ( ( _SinTime.w * _edgedissolvestrength ) + 1.5 ) ) );
			o.Emission = temp_output_55_0.rgb;
			o.Alpha = temp_output_55_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.WireNode;23;-647.882,191.9207;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;24;-638.5833,-81.25458;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;13;-528,-96;Inherit;True;Property;_Normals;Normals;5;0;Create;True;0;0;0;False;0;False;-1;None;abfd39fa1d6a42ba9b322e4301333932;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;34;-150.7605,64.81433;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;31;-132.7605,-179.1857;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;17;-528,-288;Inherit;True;Property;_Albedo;Albedo;4;0;Create;True;0;0;0;False;0;False;-1;None;85e3723e62d44f758723754190c67911;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-564,351;Inherit;True;Property;_Specular;Specular;6;0;Create;True;0;0;0;False;0;False;-1;None;f4ef9b0dca354d7aaf185497d6b77ea5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-992,-280;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1062.154,17.54565;Inherit;False;Property;_FireSpeed;Fire Speed;7;0;Create;True;0;0;0;False;0;False;0;29.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-884,189;Float;False;Property;_FireIntensity;Fire Intensity;3;0;Create;True;0;0;0;False;0;False;2;4.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1183.396,292.3824;Inherit;False;Property;_edgedissolvestrength;edge dissolve strength;11;0;Create;True;0;0;0;False;0;False;0;1.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;128,-288;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AmplifyShaderPack/Animated Fire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RotatorNode;46;-807.396,-20.61758;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;27;-85.6252,-201.5952;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;51;-982.1016,691.4966;Inherit;False;Property;_FiretexMult;Fire tex Mult;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.495283,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-1263.396,-71.61758;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-1279.579,634.3541;Inherit;False;Property;_BurnMaskMult;Burn Mask Mult;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4298683,0.8679245,0.8679245,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;55;-557,109;Inherit;False;Burn Effect;0;;4;05e3549071b9ccc4295de9c50416327f;0;7;28;FLOAT2;0,0;False;22;COLOR;1,1,1,1;False;23;COLOR;1,1,1,1;False;17;FLOAT;1;False;16;FLOAT;1;False;12;FLOAT;0;False;14;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;56;-830.7083,-499.5131;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;60;-1270.537,-474.417;Inherit;False;Property;_BurnRate;Burn Rate;10;0;Create;True;0;0;0;False;0;False;0,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;23;0;4;0
WireConnection;24;0;4;0
WireConnection;13;1;24;0
WireConnection;34;0;55;0
WireConnection;31;0;34;0
WireConnection;17;1;4;0
WireConnection;16;1;23;0
WireConnection;0;2;27;0
WireConnection;0;9;55;0
WireConnection;46;0;4;0
WireConnection;46;2;47;0
WireConnection;27;0;31;0
WireConnection;55;28;56;0
WireConnection;55;22;51;0
WireConnection;55;23;50;0
WireConnection;55;17;39;0
WireConnection;55;16;35;0
WireConnection;55;12;19;0
WireConnection;55;14;46;0
WireConnection;56;0;4;0
WireConnection;56;2;60;0
ASEEND*/
//CHKSM=1C9074A12E1FF0B737FFEEF396FCF84106D0EFB6