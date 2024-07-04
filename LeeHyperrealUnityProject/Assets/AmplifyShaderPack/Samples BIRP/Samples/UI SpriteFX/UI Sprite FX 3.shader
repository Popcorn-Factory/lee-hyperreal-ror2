// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/UI SpriteFX 3"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_Fire("Fire", 2D) = "black" {}
		[NoScaleOffset]_BlendFireMask("Blend Fire Mask", 2D) = "white" {}
		[NoScaleOffset][Normal]_DistortionNormalMap("Distortion Normal Map", 2D) = "bump" {}
		_DistortAmount("Distort Amount", Range( 0 , 1)) = 0
		[NoScaleOffset]_MainFX("Main FX", 2D) = "white" {}
		[NoScaleOffset]_EnergyFlow("Energy Flow", 2D) = "white" {}
		[NoScaleOffset]_Flow("Flow", 2D) = "white" {}
		[NoScaleOffset]_FlowDirection("Flow Direction", 2D) = "white" {}
		[NoScaleOffset]_Rotation("Rotation", 2D) = "black" {}
		[NoScaleOffset]_RotationMask("Rotation Mask", 2D) = "black" {}
		_RotationPosScale("Rotation Pos Scale", Vector) = (0,0,1,1)
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
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardUtils.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform sampler2D _Flow;
			uniform sampler2D _FlowDirection;
			uniform float4 _FlowDirection_ST;
			uniform float4 _MainTex_ST;
			uniform sampler2D _Fire;
			uniform sampler2D _DistortionNormalMap;
			uniform float4 _Fire_ST;
			uniform float _DistortAmount;
			uniform sampler2D _BlendFireMask;
			uniform sampler2D _MainFX;
			uniform sampler2D _EnergyFlow;
			uniform float4 _EnergyFlow_ST;
			uniform sampler2D _Rotation;
			uniform float4 _RotationPosScale;
			uniform sampler2D _RotationMask;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
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

				float2 uv_FlowDirection = IN.texcoord.xy * _FlowDirection_ST.xy + _FlowDirection_ST.zw;
				float4 tex2DNode14_g588 = tex2D( _FlowDirection, uv_FlowDirection );
				float2 appendResult20_g588 = (float2(tex2DNode14_g588.r , tex2DNode14_g588.g));
				float TimeVar197_g588 = _SinTime.w;
				float2 temp_cast_0 = (TimeVar197_g588).xx;
				float2 temp_output_18_0_g588 = ( appendResult20_g588 - temp_cast_0 );
				float4 tex2DNode72_g588 = tex2D( _Flow, temp_output_18_0_g588 );
				float4 _FlowTint = float4(0,0.213793,1,1);
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_output_192_0_g587 = ( tex2D( _MainTex, uv_MainTex ) * _Color );
				float2 uv_Fire = IN.texcoord.xy * _Fire_ST.xy + _Fire_ST.zw;
				float2 MainUvs222_g587 = uv_Fire;
				float4 tex2DNode65_g587 = tex2D( _DistortionNormalMap, MainUvs222_g587 );
				float4 appendResult82_g587 = (float4(0.0 , tex2DNode65_g587.g , 0.0 , tex2DNode65_g587.r));
				float2 temp_output_84_0_g587 = (UnpackScaleNormal( appendResult82_g587, _DistortAmount )).xy;
				float2 panner179_g587 = ( 1.0 * _Time.y * float2( 0,-0.1 ) + MainUvs222_g587);
				float2 temp_output_71_0_g587 = ( temp_output_84_0_g587 + panner179_g587 );
				float4 tex2DNode96_g587 = tex2D( _Fire, temp_output_71_0_g587 );
				float2 uv_BlendFireMask232_g587 = IN.texcoord.xy;
				float4 temp_output_192_0_g588 = ( temp_output_192_0_g587 + ( ( tex2DNode96_g587 * tex2DNode96_g587.a * tex2D( _BlendFireMask, uv_BlendFireMask232_g587 ).g ) * (temp_output_192_0_g587).a ) );
				float4 temp_output_192_0_g589 = ( ( ( tex2DNode72_g588 * tex2DNode14_g588.a ) * _FlowTint ) + temp_output_192_0_g588 );
				float2 uv_EnergyFlow = IN.texcoord.xy * _EnergyFlow_ST.xy + _EnergyFlow_ST.zw;
				float4 tex2DNode14_g589 = tex2D( _EnergyFlow, uv_EnergyFlow );
				float2 appendResult20_g589 = (float2(tex2DNode14_g589.r , tex2DNode14_g589.g));
				float2 appendResult753 = (float2(_SinTime.y , _SinTime.x));
				float2 temp_output_18_0_g589 = ( appendResult20_g589 - appendResult753 );
				float4 tex2DNode72_g589 = tex2D( _MainFX, temp_output_18_0_g589 );
				float4 temp_output_192_0_g590 = ( temp_output_192_0_g589 + ( ( ( tex2DNode72_g589 * tex2DNode14_g589.a ) * _FlowTint ) * (temp_output_192_0_g589).a ) );
				float4 temp_output_57_0_g590 = _RotationPosScale;
				float2 temp_output_2_0_g590 = (temp_output_57_0_g590).zw;
				float2 temp_cast_1 = (1.0).xx;
				float2 temp_output_13_0_g590 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g590).xy ) * temp_output_2_0_g590 ) + -( ( temp_output_2_0_g590 - temp_cast_1 ) * 0.5 ) );
				float TimeVar197_g590 = _Time.y;
				float cos17_g590 = cos( TimeVar197_g590 );
				float sin17_g590 = sin( TimeVar197_g590 );
				float2 rotator17_g590 = mul( temp_output_13_0_g590 - float2( 0.5,0.5 ) , float2x2( cos17_g590 , -sin17_g590 , sin17_g590 , cos17_g590 )) + float2( 0.5,0.5 );
				float4 tex2DNode97_g590 = tex2D( _Rotation, rotator17_g590 );
				float temp_output_115_0_g590 = step( ( (temp_output_13_0_g590).y + -0.5 ) , 0.0 );
				float lerpResult125_g590 = lerp( 1.0 , tex2D( _RotationMask, IN.texcoord.xy ).g , ( 1.0 - temp_output_115_0_g590 ));
				
				fixed4 c = ( temp_output_192_0_g590 + ( ( ( tex2DNode97_g590 * lerpResult125_g590 * tex2DNode97_g590.a ) * float4(0,0.3379312,1,1) ) * (temp_output_192_0_g590).a ) );
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
Node;AmplifyShaderEditor.CommentaryNode;534;-3812.597,-967.7968;Inherit;False;816.9041;849.1261;Base Sprite;4;477;476;528;529;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;110;-2213.504,-983.2322;Inherit;False;692.0699;868.2001;Layer 2 - Flow;5;74;73;72;775;768;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;773;-1509.053,-984.1273;Inherit;False;1127.358;876.1573;Layer 3 - Energy Field;9;776;777;774;778;730;753;741;731;770;;0,0,0,1;0;0
Node;AmplifyShaderEditor.ColorNode;74;-2115.028,-470.2112;Float;False;Constant;_FlowTint;Flow Tint;11;0;Create;True;0;0;0;False;0;False;0,0.213793,1,1;0,0,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;477;-3746.513,-914.1624;Inherit;True;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;109;-2972.992,-978.0172;Inherit;False;737.6416;866.2409;Layer 1 - Fire Distortion;6;725;69;68;554;509;767;;0,0,0,1;0;0
Node;AmplifyShaderEditor.WireNode;776;-1431.299,-451.5274;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;528;-3503.382,-920.5964;Inherit;True;Property;_TextureSample4;Texture Sample 4;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;476;-3348.488,-726.6215;Inherit;False;0;0;_Color;Shader;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;777;-1406.225,-503.2432;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;509;-2843.526,-863.1107;Float;True;Property;_Fire;Fire;7;0;Create;True;0;0;0;False;0;False;None;cd37cd05e6714e409187f7beed787a38;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;554;-2789.45,-674.7249;Float;False;Constant;_Vector0;Vector 0;27;0;Create;True;0;0;0;False;0;False;0,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;68;-2852.691,-562.4369;Float;True;Property;_DistortionNormalMap;Distortion Normal Map;9;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;None;e901190044a54e7186ca567492f42131;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;69;-2898.412,-371.1444;Float;False;Property;_DistortAmount;Distort Amount;10;0;Create;True;0;0;0;False;0;False;0;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;725;-2845.88,-300.6122;Float;True;Property;_BlendFireMask;Blend Fire Mask;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;fbda8092d7b84f87be3259ec87d72dd1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;529;-3156.235,-922.8755;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinTimeNode;741;-1104.864,-360.5791;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;774;-1398.66,-846.6949;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinTimeNode;775;-2040.137,-299.0684;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;72;-2136.722,-856.8315;Float;True;Property;_Flow;Flow;13;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;23812407c8521394694a4b92bd2e6b27;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;73;-2138.591,-670.4327;Float;True;Property;_FlowDirection;Flow Direction;14;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;90554b1a3d969c14786e293bc5de509c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;767;-2537.539,-928.3698;Inherit;False;UI-Sprite Effect Layer;0;;587;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,0,177,1,182,0,229,1,92,1,98,1,234,0,126,0,129,0,130,0,31,2;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.FunctionNode;768;-1867.251,-926.4327;Inherit;False;UI-Sprite Effect Layer;0;;588;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,1,234,0,126,0,129,0,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.CommentaryNode;105;-355.0984,-992;Inherit;False;725.5624;875.884;Layer 4 - Rotation Effect;5;59;60;56;81;769;;0,0,0,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;731;-1106.525,-569.14;Float;True;Property;_EnergyFlow;Energy Flow;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;09864a545cba1364687e7d30cf867f68;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;753;-928.8636,-360.5791;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;730;-1101.126,-769.5481;Float;True;Property;_MainFX;Main FX;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;5f18511402154bf18ca40b7406ed597e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;778;-1344.807,-862.7416;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;770;-693.0531,-936.1273;Inherit;False;UI-Sprite Effect Layer;0;;589;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,1,186,0,177,0,182,0,229,0,92,1,98,1,234,0,126,0,129,0,130,0,31,2;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.ColorNode;81;-210.2121,-850.9412;Float;False;Constant;_RotationTint;Rotation Tint;11;0;Create;True;0;0;0;False;0;False;0,0.3379312,1,1;0,0,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TexturePropertyNode;56;-229.3306,-686.7064;Float;True;Property;_Rotation;Rotation;15;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;2d68d658f4789a241a173ed536f6340e;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;60;-227.578,-498.4616;Float;True;Property;_RotationMask;Rotation Mask;16;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;fbda8092d7b84f87be3259ec87d72dd1;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector4Node;59;-203.7653,-311.6878;Float;False;Property;_RotationPosScale;Rotation Pos Scale;17;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0.92,3.52;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;769;98.94133,-929.4706;Inherit;False;UI-Sprite Effect Layer;0;;590;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,1,234,0,126,0,129,1,130,1,31,2;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;728;418.9873,-929.7706;Float;False;True;-1;2;ASEMaterialInspector;0;10;AmplifyShaderPack/UI SpriteFX 3;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;776;0;74;0
WireConnection;528;0;477;0
WireConnection;777;0;776;0
WireConnection;529;0;528;0
WireConnection;529;1;476;0
WireConnection;774;0;777;0
WireConnection;767;192;529;0
WireConnection;767;37;509;0
WireConnection;767;181;554;0
WireConnection;767;75;68;0
WireConnection;767;80;69;0
WireConnection;767;233;725;0
WireConnection;768;192;767;0
WireConnection;768;39;74;0
WireConnection;768;37;72;0
WireConnection;768;33;73;0
WireConnection;768;40;775;4
WireConnection;753;0;741;2
WireConnection;753;1;741;1
WireConnection;778;0;774;0
WireConnection;770;192;768;0
WireConnection;770;39;778;0
WireConnection;770;37;730;0
WireConnection;770;33;731;0
WireConnection;770;248;753;0
WireConnection;769;192;770;0
WireConnection;769;39;81;0
WireConnection;769;37;56;0
WireConnection;769;101;60;0
WireConnection;769;57;59;0
WireConnection;728;0;769;0
ASEEND*/
//CHKSM=D249950752D155D851F40794BEA71F475AB273A1