// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI Hyperreal health"
{
	Properties
	{
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample2;
		uniform sampler2D _TextureSample1;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color111 = IsGammaSpace() ? float4(0,1,1,0) : float4(0,1,1,0);
			float2 uv_TexCoord96 = i.uv_texcoord * float2( 0.4,0.4 );
			float2 panner98 = ( _Time.w * float2( 0.1,0.05 ) + uv_TexCoord96);
			float4 tex2DNode94 = tex2D( _TextureSample2, panner98 );
			float4 temp_output_1_0_g9 = tex2DNode94;
			float4 color113 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_output_2_0_g9 = color113;
			float temp_output_11_0_g9 = distance( temp_output_1_0_g9 , temp_output_2_0_g9 );
			float4 lerpResult21_g9 = lerp( color111 , temp_output_1_0_g9 , saturate( ( ( temp_output_11_0_g9 - 1.0 ) / max( 0.18 , 1E-05 ) ) ));
			o.Emission = lerpResult21_g9.rgb;
			o.Alpha = 1;
			float2 uv_TexCoord26 = i.uv_texcoord * float2( 7,1.5 );
			float2 panner23 = ( _Time.w * float2( -0.2,-0.1 ) + uv_TexCoord26);
			clip( ( tex2D( _TextureSample1, panner23 ).a * tex2DNode94.a ) - _Cutoff );
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
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-931.5479,-158.4107;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;89;-1127.696,351.6823;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;23;-676.6076,139.0696;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;91;-1151.114,46.76254;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;-0.2,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;97;-764.8693,1299.853;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;98;-313.7808,1087.24;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;99;-788.2872,994.9327;Inherit;False;Constant;_Vector2;Vector 0;3;0;Create;True;0;0;0;False;0;False;0.1,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;95;104.3652,116.9672;Inherit;False;Color Mask;-1;;7;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-571.7211,747.7595;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;100;-868.9402,582.553;Inherit;False;Constant;_Vector3;Vector 1;3;0;Create;True;0;0;0;False;0;False;0.4,0.4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;94;-274.6373,-332.9521;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;None;428a7dc9e6ae19d47811d31f195e669b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;111;-162.5572,-96.30637;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;113;-165.1633,122.6573;Inherit;False;Constant;_Color3;Color 3;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;114;454.8367,83.65735;Inherit;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;318.8367,376.6573;Inherit;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;0;False;0;False;0.18;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;112;61.04285,-277.8064;Inherit;False;Replace Color;-1;;9;896dccb3016c847439def376a728b869;1,12,0;5;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;87.37634,-516.4681;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;65;335.9698,-437.7402;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;UI Hyperreal health;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Overlay;;Overlay;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;32;10;25;True;1;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;2;1,0,0,0;VertexOffset;False;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;True;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;58;-282.468,-610.2484;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;1d227b4ae90d026498f580708d48d522;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;92;-1192.767,-345.6172;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;7,1.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;26;0;92;0
WireConnection;23;0;26;0
WireConnection;23;2;91;0
WireConnection;23;1;89;4
WireConnection;98;0;96;0
WireConnection;98;2;99;0
WireConnection;98;1;97;4
WireConnection;96;0;100;0
WireConnection;94;1;98;0
WireConnection;112;1;94;0
WireConnection;112;2;113;0
WireConnection;112;3;111;0
WireConnection;112;4;114;0
WireConnection;112;5;115;0
WireConnection;110;0;58;4
WireConnection;110;1;94;4
WireConnection;65;2;112;0
WireConnection;65;10;110;0
WireConnection;58;1;23;0
ASEEND*/
//CHKSM=6F3A8C80DA6E5A83211EF191CCDD821DBF10D545