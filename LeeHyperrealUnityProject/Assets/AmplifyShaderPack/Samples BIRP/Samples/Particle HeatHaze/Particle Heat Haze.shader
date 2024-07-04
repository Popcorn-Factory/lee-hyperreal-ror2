// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Particle HeatHaze"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_HazeVSpeed("Haze VSpeed", Float) = 0
		_HazeMask("HazeMask", 2D) = "white" {}
		_Distortion("Distortion", 2D) = "bump" {}
		_HazeHFreq("Haze HFreq", Float) = 0
		_HazeNormalIntensity("HazeNormalIntensity", Range( 0 , 1)) = 0.1
		_HazeHAmp("Haze HAmp", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			GrabPass{ "_GrabScreen0" }

			Pass {
			
				CGPROGRAM
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
				#else
				#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
				#endif

				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					float4 ase_texcoord3 : TEXCOORD3;
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabScreen0 )
				uniform sampler2D _Distortion;
				uniform float _HazeHAmp;
				uniform float _HazeHFreq;
				uniform float _HazeVSpeed;
				uniform float _HazeNormalIntensity;
				uniform sampler2D _HazeMask;
				uniform float4 _HazeMask_ST;
				inline float4 ASE_ComputeGrabScreenPos( float4 pos )
				{
					#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
					#else
					float scale = 1.0;
					#endif
					float4 o = pos;
					o.y = pos.w * 0.5f;
					o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
					return o;
				}
				


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
					float4 screenPos = ComputeScreenPos(ase_clipPos);
					o.ase_texcoord3 = screenPos;
					

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float4 screenPos = i.ase_texcoord3;
					float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
					float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
					float mulTime101 = _Time.y * _HazeHFreq;
					float mulTime38 = _Time.y * _HazeVSpeed;
					float2 appendResult112 = (float2(( _HazeHAmp * cos( mulTime101 ) ) , -mulTime38));
					float2 texCoord91 = i.texcoord.xy * float2( 1,1 ) + appendResult112;
					float4 screenColor27 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabScreen0,( ase_grabScreenPosNorm + float4( ( UnpackNormal( tex2D( _Distortion, texCoord91 ) ) * _HazeNormalIntensity ) , 0.0 ) ).xy/( ase_grabScreenPosNorm + float4( ( UnpackNormal( tex2D( _Distortion, texCoord91 ) ) * _HazeNormalIntensity ) , 0.0 ) ).w);
					float2 uv_HazeMask = i.texcoord.xy * _HazeMask_ST.xy + _HazeMask_ST.zw;
					float4 appendResult113 = (float4(( (i.color).rgb * (screenColor27).rgb * (_TintColor).rgb ) , ( i.color.a * (_TintColor).a * tex2D( _HazeMask, uv_HazeMask ).r )));
					

					fixed4 col = appendResult113;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;97;-1248,672;Float;False;Property;_HazeHFreq;Haze HFreq;3;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;101;-1072,672;Inherit;False;1;0;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1264,768;Float;False;Property;_HazeVSpeed;Haze VSpeed;0;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;43;-864,672;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;38;-1072,768;Inherit;False;1;0;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-912,592;Float;False;Property;_HazeHAmp;Haze HAmp;5;0;Create;True;0;0;0;False;0;False;0;0.005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;93;-720,768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-720,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;112;-560,752;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-384,704;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;71;-128,672;Inherit;True;Property;_Distortion;Distortion;2;0;Create;True;0;0;0;False;0;False;-1;None;eca6e6758d6a4dc39ac6f36fd58cd4b1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;73;240,752;Float;False;Property;_HazeNormalIntensity;HazeNormalIntensity;4;0;Create;True;0;0;0;False;0;False;0.1;0.26;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;544,672;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;60;480,480;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;35;736,656;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;46;1072,736;Inherit;False;0;0;_TintColor;Shader;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;58;1088,512;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;27;864,656;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;0;False;0;False;Object;-1;True;True;False;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;110;1285.83,899.8317;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;1414.973,968.7048;Inherit;True;Property;_HazeMask;HazeMask;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.VertexColorNode;111;1537.447,779.4488;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;107;1280,736;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;108;1280,656;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;106;1280,512;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1760,880;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1462.605,637.5998;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;1925.733,637.1848;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;26;2100.971,638.9128;Float;False;True;-1;2;ASEMaterialInspector;0;11;AmplifyShaderPack/Particle HeatHaze;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;;2;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;False;False;True;2;False;;True;3;False;;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;101;0;97;0
WireConnection;43;0;101;0
WireConnection;38;0;42;0
WireConnection;93;0;38;0
WireConnection;99;0;98;0
WireConnection;99;1;43;0
WireConnection;112;0;99;0
WireConnection;112;1;93;0
WireConnection;91;1;112;0
WireConnection;71;1;91;0
WireConnection;72;0;71;0
WireConnection;72;1;73;0
WireConnection;35;0;60;0
WireConnection;35;1;72;0
WireConnection;27;0;35;0
WireConnection;110;0;46;0
WireConnection;107;0;46;0
WireConnection;108;0;27;0
WireConnection;106;0;58;0
WireConnection;109;0;111;4
WireConnection;109;1;110;0
WireConnection;109;2;50;1
WireConnection;28;0;106;0
WireConnection;28;1;108;0
WireConnection;28;2;107;0
WireConnection;113;0;28;0
WireConnection;113;3;109;0
WireConnection;26;0;113;0
ASEEND*/
//CHKSM=B42E41F8376DE6E95A549CB788C70A18AB251FC7