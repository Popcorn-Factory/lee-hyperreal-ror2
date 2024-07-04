// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Sonar Scan"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_SonarColor("Sonar Color", Color) = (0,0,0,0)
		_Speed("Speed", Float) = 0
		_Brightness("Brightness", Float) = 0
		_Curve("Curve", Float) = 0
		_FadeDistance("Fade Distance", Float) = 0
		_FadeRange("Fade Range", Float) = 0

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float4 _SonarColor;
			uniform float _Speed;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Brightness;
			uniform float _Curve;
			uniform float _FadeDistance;
			uniform float _FadeRange;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float clampDepth1 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float4 lerpResult5 = lerp( float4(0,0,0,0) , _SonarColor , ( pow( ( frac( ( ( _Time.y * _Speed ) + clampDepth1 ) ) + _Brightness ) , _Curve ) * ( 1.0 - saturate( ( ( clampDepth1 - _FadeDistance ) / _FadeRange ) ) ) ));
				

				finalColor = saturate( lerpResult5 );

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
Node;AmplifyShaderEditor.CommentaryNode;25;-122.3636,45.19291;Inherit;False;1148.089;453.2876;;9;7;6;8;9;14;12;16;13;15;Sonar pulse;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-132.8,609.4215;Inherit;False;1111.4;309.5991;;6;19;18;21;20;22;23;Sonar range of effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-80.3636,108.1929;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-72.36359,192.1929;Float;False;Property;_Speed;Speed;1;0;Create;True;0;0;0;False;0;False;0;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;1;-383.8998,491.6473;Inherit;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;118.6363,128.1929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-82.8,774.4215;Float;False;Property;_FadeDistance;Fade Distance;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;303.7362,273.2931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;130.2,659.4215;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;211.1999,784.4215;Float;False;Property;_FadeRange;Fade Range;5;0;Create;True;0;0;0;False;0;False;0;1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;478.7255,324.4805;Float;False;Property;_Brightness;Brightness;2;0;Create;True;0;0;0;False;0;False;0;0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;392.2002,669.4215;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;12;489.8526,185.132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;597.2003,714.4215;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;681.7249,383.4805;Float;False;Property;_Curve;Curve;3;0;Create;True;0;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;672.325,169.4805;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;791.5998,809.0206;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;845.7246,189.4805;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;1081.133,126.1374;Float;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;1091.836,553.6883;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;1093.496,348.2963;Float;False;Property;_SonarColor;Sonar Color;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.7902222,0,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;5;1452.731,372.1962;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;26;1656.272,451.8782;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1963.058,389.3879;Float;False;True;-1;2;ASEMaterialInspector;0;9;AmplifyShaderPack/Sonar Scan;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;True;0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;9;1;1;0
WireConnection;18;0;1;0
WireConnection;18;1;19;0
WireConnection;20;0;18;0
WireConnection;20;1;21;0
WireConnection;12;0;9;0
WireConnection;22;0;20;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;23;0;22;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;17;0;15;0
WireConnection;17;1;23;0
WireConnection;5;0;4;0
WireConnection;5;1;2;0
WireConnection;5;2;17;0
WireConnection;26;0;5;0
WireConnection;0;0;26;0
ASEEND*/
//CHKSM=4CA99E07B540A94E7633E823E2552F5E815F6C54