// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Sprite Mask"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_ScreenMap("Screen Map", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_ScreenTiling("Screen Tiling", Float) = 0
		_CustomUVs("Custom UVs", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _KEYWORD0_ON


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _ScreenMap;
			uniform float _ScreenTiling;
			uniform sampler2D _Mask;
			uniform float4 _CustomUVs;
			uniform float4 _AlphaTex_ST;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				//Calculate new billboard vertex position and normal;
				float3 upCamVec = float3( 0, 1, 0 );
				float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
				float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
				float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
				IN.ase_normal = normalize( mul( float4( IN.ase_normal , 0 ), rotationCamMatrix )).xyz;
				IN.ase_tangent.xyz = normalize( mul( float4( IN.ase_tangent.xyz , 0 ), rotationCamMatrix )).xyz;
				//This unfortunately must be made to take non-uniform scaling into account;
				//Transform to world coords, apply rotation and transform back to local;
				IN.vertex = mul( IN.vertex , unity_ObjectToWorld );
				IN.vertex = mul( IN.vertex , rotationCamMatrix );
				IN.vertex = mul( IN.vertex , unity_WorldToObject );
				float4 ase_clipPos = UnityObjectToClipPos(IN.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				OUT.ase_texcoord1 = screenPos;
				
				
				IN.vertex.xyz += 0; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float4 screenPos = IN.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 texCoord48 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult44 = (float2((0.0 + (texCoord48.x - _CustomUVs.x) * (1.0 - 0.0) / (_CustomUVs.z - _CustomUVs.x)) , (0.0 + (texCoord48.y - _CustomUVs.y) * (1.0 - 0.0) / (_CustomUVs.w - _CustomUVs.y))));
				float4 lerpResult20 = lerp( tex2DNode2 , tex2D( _ScreenMap, ( (ase_screenPosNorm).xy * _ScreenTiling ) ) , tex2D( _Mask, appendResult44 ).r);
				float2 uv_AlphaTex = IN.texcoord.xy * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
				#ifdef _KEYWORD0_ON
				float staticSwitch9 = tex2D( _AlphaTex, uv_AlphaTex ).a;
				#else
				float staticSwitch9 = tex2DNode2.a;
				#endif
				float4 appendResult6 = (float4((lerpResult20).rgb , staticSwitch9));
				float4 appendResult25 = (float4((( appendResult6 * IN.color * _Color )).xyz , tex2DNode2.a));
				
				fixed4 c = appendResult25;
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;51;-1802.111,-1052.2;Inherit;False;1312.402;669.4019;;8;46;44;49;50;48;45;43;18;Remap UVs to match mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1945.601,-207.0965;Inherit;False;917.006;381.7991;Comment;5;23;24;22;14;57;Fetch screen position;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;57;-1920.197,-138.3137;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-1676.612,-509.1988;Float;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;43;-1752.111,-833.0957;Float;False;Property;_CustomUVs;Custom UVs;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1743.011,-994.7976;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1677.01,-599.1984;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-913.1967,-138.2966;Inherit;False;974.797;704.4963;;7;1;3;2;4;20;9;5;Combine all textures;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;49;-1382.61,-740.5983;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;-1379.309,-1002.2;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;22;-1662,-121.097;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1886.606,59.7028;Float;False;Property;_ScreenTiling;Screen Tiling;2;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1136.91,-801.4982;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1503.903,-66.79694;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-863.1967,177.4005;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-924.6993,-700.197;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;-1;None;cef710f3d13a49d89a56416bda8a9c61;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;3;-832.8002,383.2996;Inherit;False;0;0;_AlphaTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1349.595,-56.79973;Inherit;True;Property;_ScreenMap;Screen Map;0;0;Create;True;0;0;0;False;0;False;-1;None;aab8de1052c54173b3d61e7f8b05aedf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;2;-670.201,96.29993;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;20;-308.7964,-88.29664;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-670.4998,336.1997;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;54;99.70008,-69.0003;Inherit;False;821.6934;608.0103;;6;12;6;13;26;25;53;Apply Tint;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;5;-92.3997,-51.5002;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;9;-224,240;Float;False;Property;_KEYWORD0_ON;Keyword 0;6;0;Create;False;0;0;0;False;0;False;0;0;0;False;ETC1_EXTERNAL_ALPHA;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;53;205.2041,429.0099;Inherit;False;0;0;_Color;Shader;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;6;178.5,-19.0003;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexColorNode;12;149.7001,227.2002;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;398.4996,6.999654;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;26;562.9934,10.30279;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BillboardNode;56;972.7048,258.8051;Inherit;False;Cylindrical;False;True;0;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;748.3942,40.50196;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1038.105,-20.79832;Float;False;True;-1;2;ASEMaterialInspector;0;10;AmplifyShaderPack/Sprite Mask;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;49;0;48;1
WireConnection;49;1;43;1
WireConnection;49;2;43;3
WireConnection;49;3;45;0
WireConnection;49;4;46;0
WireConnection;50;0;48;2
WireConnection;50;1;43;2
WireConnection;50;2;43;4
WireConnection;50;3;45;0
WireConnection;50;4;46;0
WireConnection;22;0;57;0
WireConnection;44;0;49;0
WireConnection;44;1;50;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;18;1;44;0
WireConnection;14;1;23;0
WireConnection;2;0;1;0
WireConnection;20;0;2;0
WireConnection;20;1;14;0
WireConnection;20;2;18;1
WireConnection;4;0;3;0
WireConnection;5;0;20;0
WireConnection;9;1;2;4
WireConnection;9;0;4;4
WireConnection;6;0;5;0
WireConnection;6;3;9;0
WireConnection;13;0;6;0
WireConnection;13;1;12;0
WireConnection;13;2;53;0
WireConnection;26;0;13;0
WireConnection;25;0;26;0
WireConnection;25;3;2;4
WireConnection;0;0;25;0
WireConnection;0;1;56;0
ASEEND*/
//CHKSM=9580CD2AA52ED626DD1E31C7D9FD44B52545E9C0