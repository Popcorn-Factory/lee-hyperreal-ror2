// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "outline portal"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_speedportal("speed portal", Range( -10 , 10)) = -0.2
		_speedportal1("speed portal", Range( -10 , 10)) = -0.2
		_speedportal2("speed portal", Range( -10 , 10)) = -0.2
		_rotationfire("rotation fire", Range( 0 , 4)) = 1.57
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float _speedportal;
		uniform float _rotationfire;
		uniform sampler2D _TextureSample2;
		uniform float _speedportal2;
		uniform sampler2D _TextureSample1;
		uniform float _speedportal1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult8 = (float4(( _Time.y * _speedportal ) , ( _Time.y * 2.0 ) , 0.0 , 0.0));
			float2 uv_TexCoord11 = i.uv_texcoord * float2( 1,1 ) + appendResult8.xy;
			float cos13 = cos( _rotationfire );
			float sin13 = sin( _rotationfire );
			float2 rotator13 = mul( uv_TexCoord11 - float2( 0.5,0.5 ) , float2x2( cos13 , -sin13 , sin13 , cos13 )) + float2( 0.5,0.5 );
			float4 tex2DNode1 = tex2D( _TextureSample0, rotator13 );
			o.Emission = tex2DNode1.rgb;
			float4 appendResult39 = (float4(( _Time.y * _speedportal2 ) , ( _Time.y * 0.0 ) , 0.0 , 0.0));
			float2 uv_TexCoord43 = i.uv_texcoord * float2( 1,1 ) + appendResult39.xy;
			float4 tex2DNode31 = tex2D( _TextureSample2, uv_TexCoord43 );
			float4 appendResult24 = (float4(( _Time.y * _speedportal1 ) , ( _Time.y * 0.0 ) , 0.0 , 0.0));
			float2 uv_TexCoord28 = i.uv_texcoord * float2( 1,1 ) + appendResult24.xy;
			float4 tex2DNode4 = tex2D( _TextureSample1, uv_TexCoord28 );
			float blendOpSrc30 = tex2DNode31.a;
			float blendOpDest30 = tex2DNode4.a;
			float lerpBlendMode30 = lerp(blendOpDest30,( 1.0 - ( ( 1.0 - blendOpDest30) / max( blendOpSrc30, 0.00001) ) ),0.001);
			float blendOpSrc54 = ( saturate( lerpBlendMode30 ));
			float blendOpDest54 = tex2DNode1.a;
			float lerpBlendMode54 = lerp(blendOpDest54,( 1.0 - ( ( 1.0 - blendOpDest54) / max( blendOpSrc54, 0.00001) ) ),0.3);
			o.Alpha = ( saturate( lerpBlendMode54 ));
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;outline portal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RotatorNode;13;-1531.264,331.1283;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;15;-1811.264,335.1283;Inherit;False;Constant;_Vector1;Vector 1;4;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;14;-1781.264,545.1283;Inherit;False;Property;_rotationfire;rotation fire;6;0;Create;True;0;0;0;False;0;False;1.57;3.18;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;16;-2908.918,164.3334;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;17;-2652.918,334.3334;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2695.918,541.3334;Inherit;False;Constant;_Float3;Float 0;5;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2945.918,328.3334;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2853.918,497.3334;Inherit;False;Constant;_Float2;Float 0;5;0;Create;True;0;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-2047.531,-297.7111;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;7;-2459.186,8.159848;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1967.082,-37.16252;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2201.749,-3.518048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2396.458,262.3447;Inherit;False;Property;_speedportal;speed portal;3;0;Create;True;0;0;0;False;0;False;-0.2;1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1687.604,-126.1817;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-507.4997,-600.1926;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;63a0442bc7cd1ee46b6c4cf7f06ba4aa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-85.1134,-782.839;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;70281b315ebb7f748915d52bf42b620d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;21;-1087.486,-1006.786;Inherit;False;Constant;_Vector2;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-909.494,-502.9981;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;23;-1499.141,-700.9156;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1007.037,-746.2379;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1241.704,-712.5936;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1436.413,-446.7308;Inherit;False;Property;_speedportal1;speed portal;4;0;Create;True;0;0;0;False;0;False;-0.2;3;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1123.062,-362.5023;Inherit;False;Constant;_Float4;Float 1;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-727.5591,-835.2571;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;36;-514.2502,-1861.781;Inherit;False;Constant;_Vector3;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-336.2582,-1357.993;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;38;-925.9053,-1555.911;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;39;-433.8011,-1601.233;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-668.4683,-1567.589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-863.1772,-1301.726;Inherit;False;Property;_speedportal2;speed portal;5;0;Create;True;0;0;0;False;0;False;-0.2;-1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-549.8263,-1217.497;Inherit;False;Constant;_Float6;Float 1;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-154.3233,-1690.252;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1124.639,88.72681;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;78ea9dd59ff8e4146a394ca8243904ae;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1959.239,167.0774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-534.4948,-335.0182;Inherit;False;Constant;_Float5;Float 5;7;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;246.094,-399.9293;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2159.983,399.0614;Inherit;False;Constant;_Float7;Float 7;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;30;-220.9712,-372.6772;Inherit;False;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;54;-413.3235,272.0347;Inherit;False;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-843.3962,462.0335;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
WireConnection;0;2;1;0
WireConnection;0;9;54;0
WireConnection;13;0;11;0
WireConnection;13;1;15;0
WireConnection;13;2;14;0
WireConnection;17;0;16;4
WireConnection;17;1;18;0
WireConnection;17;3;19;0
WireConnection;17;4;20;0
WireConnection;8;0;9;0
WireConnection;8;1;6;0
WireConnection;9;0;7;2
WireConnection;9;1;10;0
WireConnection;11;0;5;0
WireConnection;11;1;8;0
WireConnection;4;1;28;0
WireConnection;31;1;43;0
WireConnection;22;0;23;2
WireConnection;22;1;27;0
WireConnection;24;0;25;0
WireConnection;24;1;22;0
WireConnection;25;0;23;2
WireConnection;25;1;26;0
WireConnection;28;0;21;0
WireConnection;28;1;24;0
WireConnection;37;0;38;2
WireConnection;37;1;42;0
WireConnection;39;0;40;0
WireConnection;39;1;37;0
WireConnection;40;0;38;2
WireConnection;40;1;41;0
WireConnection;43;0;36;0
WireConnection;43;1;39;0
WireConnection;1;1;13;0
WireConnection;6;0;7;2
WireConnection;6;1;53;0
WireConnection;49;0;4;4
WireConnection;49;1;31;4
WireConnection;30;0;31;4
WireConnection;30;1;4;4
WireConnection;30;2;32;0
WireConnection;54;0;30;0
WireConnection;54;1;1;4
WireConnection;54;2;55;0
ASEEND*/
//CHKSM=5CBB7CA6D958661FE4110A154287C6B1E216D919