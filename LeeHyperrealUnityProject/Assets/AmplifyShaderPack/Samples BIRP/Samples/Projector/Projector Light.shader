// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Projector Light"
{
	Properties
	{
		_LightTex("LightTex", 2D) = "white" {}
		_FalloffTex("FalloffTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 0

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend DstColor One
		AlphaToMask Off
		Cull Back
		ColorMask RGB
		ZWrite Off
		ZTest LEqual
		Offset -1 , -1
		
		
		
		Pass
		{
			Name "SubShader 0 Pass 0"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_VERT_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color;
			uniform sampler2D _LightTex;
			float4x4 unity_Projector;
			uniform sampler2D _FalloffTex;
			float4x4 unity_ProjectorClip;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 vertexToFrag11 = mul( unity_Projector, v.vertex );
				o.ase_texcoord1 = vertexToFrag11;
				float4 vertexToFrag15 = mul( unity_ProjectorClip, v.vertex );
				o.ase_texcoord2 = vertexToFrag15;
				
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 vertexToFrag11 = i.ase_texcoord1;
				float4 tex2DNode18 = tex2D( _LightTex, ( (vertexToFrag11).xy / (vertexToFrag11).w ) );
				float4 appendResult25 = (float4(( float4( (_Color).rgb , 0.0 ) * tex2DNode18 ).rgb , ( 1.0 - tex2DNode18.a )));
				float4 vertexToFrag15 = i.ase_texcoord2;
				
				
				finalColor = ( appendResult25 * tex2D( _FalloffTex, ( (vertexToFrag15).xy / (vertexToFrag15).w ) ).a );
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
Node;AmplifyShaderEditor.UnityProjectorMatrixNode;8;-1392,0;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.PosVertexDataNode;10;-1424,64;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1216,0;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexToFragmentNode;11;-1072,0;Inherit;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;42;-816,0;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;43;-816,80;Inherit;False;FLOAT;3;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;13;-1408,464;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-608,0;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.UnityProjectorClipMatrixNode;9;-1408,384;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ColorNode;37;-480,-192;Float;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;18;-480,0;Inherit;True;Property;_LightTex;LightTex;0;0;Create;True;0;0;0;False;0;False;-1;None;151c3e6d90cb475da50cb18a0cba5832;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1216,384;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;41;-256,-192;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;30;-96,96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-96,-16;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexToFragmentNode;15;-1072,384;Inherit;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;64,-16;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;44;-784,384;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;45;-784,464;Inherit;False;FLOAT;3;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-608,384;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;39;217.9869,113.4419;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;34;-480,384;Inherit;True;Property;_FalloffTex;FalloffTex;1;0;Create;True;0;0;0;False;0;False;-1;None;45b7e6af29b14cb4908222b3d4c658f4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;40;221.3328,445.7945;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;272,448;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;38;432,448;Float;False;True;-1;2;ASEMaterialInspector;0;5;AmplifyShaderPack/Projector Light;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;SubShader 0 Pass 0;2;False;True;1;2;False;;1;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;2;False;;True;0;False;;True;True;-1;False;;-1;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;12;0;8;0
WireConnection;12;1;10;0
WireConnection;11;0;12;0
WireConnection;42;0;11;0
WireConnection;43;0;11;0
WireConnection;20;0;42;0
WireConnection;20;1;43;0
WireConnection;18;1;20;0
WireConnection;14;0;9;0
WireConnection;14;1;13;0
WireConnection;41;0;37;0
WireConnection;30;0;18;4
WireConnection;24;0;41;0
WireConnection;24;1;18;0
WireConnection;15;0;14;0
WireConnection;25;0;24;0
WireConnection;25;3;30;0
WireConnection;44;0;15;0
WireConnection;45;0;15;0
WireConnection;31;0;44;0
WireConnection;31;1;45;0
WireConnection;39;0;25;0
WireConnection;34;1;31;0
WireConnection;40;0;39;0
WireConnection;35;0;40;0
WireConnection;35;1;34;4
WireConnection;38;0;35;0
ASEEND*/
//CHKSM=5AA14228C6F3735C65C5D7677A8DFBFFA7B0FB1A