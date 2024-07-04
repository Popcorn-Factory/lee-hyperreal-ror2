// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Unlit With Lightmap"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
	LOD 0
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		CGINCLUDE
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
		ENDCG
		Pass
		{
			
			Tags { "LightMode"="VertexLMRGBM" "RenderType"="Opaque" }
			Name "Unlit LM"
			CGPROGRAM
			
			#pragma target 2.0
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				float2 texCoord2_g7 = v.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 vertexToFrag10_g7 = ( ( texCoord2_g7 * (unity_LightmapST).xy ) + (unity_LightmapST).zw );
				o.ase_texcoord.xy = vertexToFrag10_g7;
				
				o.ase_texcoord.zw = v.ase_texcoord.xy;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( i );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );
				fixed4 finalColor;
				float2 vertexToFrag10_g7 = i.ase_texcoord.xy;
				float4 tex2DNode7_g7 = UNITY_SAMPLE_TEX2D( unity_Lightmap, vertexToFrag10_g7 );
				float3 decodeLightMap6_g7 = DecodeLightmap(tex2DNode7_g7);
				float2 uv_MainTex = i.ase_texcoord.zw * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult8 = (float4(( decodeLightMap6_g7 * (tex2D( _MainTex, uv_MainTex )).rgb ) , 1.0));
				
				
				finalColor = appendResult8;
				return finalColor;
			}
			ENDCG
		}
		
		Pass
		{
			
			Tags { "LightMode"="VertexLM" "RenderType"="Opaque" }
			Name "Unlit LM Mobile"
			CGPROGRAM
			
			#pragma target 2.0
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float2 texCoord2_g7 = v.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 vertexToFrag10_g7 = ( ( texCoord2_g7 * (unity_LightmapST).xy ) + (unity_LightmapST).zw );
				o.ase_texcoord.xy = vertexToFrag10_g7;
				
				o.ase_texcoord.zw = v.ase_texcoord.xy;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( i );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );
				fixed4 finalColor;
				float2 vertexToFrag10_g7 = i.ase_texcoord.xy;
				float4 tex2DNode7_g7 = UNITY_SAMPLE_TEX2D( unity_Lightmap, vertexToFrag10_g7 );
				float3 decodeLightMap6_g7 = DecodeLightmap(tex2DNode7_g7);
				float2 uv_MainTex = i.ase_texcoord.zw * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult8 = (float4(( decodeLightMap6_g7 * (tex2D( _MainTex, uv_MainTex )).rgb ) , 1.0));
				
				
				finalColor = appendResult8;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.SamplerNode;5;-464.1202,37.97169;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;0;False;0;False;-1;None;aab8de1052c54173b3d61e7f8b05aedf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwizzleNode;30;-91.37158,37.4086;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;32;-160.4124,-33.86099;Inherit;False;FetchLightmapValue;0;;7;43de3d4ae59f645418fdd020d1b8e78e;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;92.27861,-34.62788;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;100.9786,65.4722;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;283.3786,-35.12809;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;16;445.9998,-34;Float;False;True;-1;2;ASEMaterialInspector;0;6;AmplifyShaderPack/Unlit With Lightmap;899e609c083c74c4ca567477c39edef0;True;Unlit LM;0;0;Unlit LM;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;LightMode=VertexLMRGBM;RenderType=Opaque=RenderType;True;0;False;0;;0;0;Standard;0;0;2;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;17;371.8,-33.8;Float;False;False;-1;2;ASEMaterialInspector;0;8;ASECustomTemplateShaders/UnlitLM;899e609c083c74c4ca567477c39edef0;True;Unlit LM Mobile;0;1;Unlit LM Mobile;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;LightMode=VertexLM;RenderType=Opaque=RenderType;True;0;False;0;;0;0;Standard;0;False;0
WireConnection;30;0;5;0
WireConnection;7;0;32;0
WireConnection;7;1;30;0
WireConnection;8;0;7;0
WireConnection;8;3;9;0
WireConnection;16;0;8;0
ASEEND*/
//CHKSM=9923F1688033B93F918BCF68EF024C884BA05043