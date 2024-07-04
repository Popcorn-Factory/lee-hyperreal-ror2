// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Stencil Portal Refraction Panel"
{
	Properties
	{
		_PortalColor("Portal Color", Color) = (0.003838672,0.5220588,0.243292,0)
		_DistortionValue("Distortion Value", Range( 0 , 1)) = 0.292
		_DistortionMap("Distortion Map", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+100" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard alpha:fade keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _DistortionMap;
		uniform float4 _DistortionMap_ST;
		uniform float _DistortionValue;
		uniform float4 _PortalColor;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 normalizedClip21 = ase_grabScreenPosNorm;
			float2 uv_DistortionMap = i.uv_texcoord * _DistortionMap_ST.xy + _DistortionMap_ST.zw;
			float cos33 = cos( _Time.y );
			float sin33 = sin( _Time.y );
			float2 rotator33 = mul( uv_DistortionMap - float2( 0.5,0.5 ) , float2x2( cos33 , -sin33 , sin33 , cos33 )) + float2( 0.5,0.5 );
			float4 screenColor8 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( normalizedClip21 + float4( ( UnpackNormal( tex2D( _DistortionMap, rotator33 ) ) * _DistortionValue ) , 0.0 ) ).xy/( normalizedClip21 + float4( ( UnpackNormal( tex2D( _DistortionMap, rotator33 ) ) * _DistortionValue ) , 0.0 ) ).w);
			o.Emission = ( screenColor8 * _PortalColor ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.Vector2Node;35;-1152,304;Float;False;Constant;_Vector0;Vector 0;-1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1152,176;Inherit;False;0;29;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;36;-1153.522,435.0121;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;33;-831.5794,259.398;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GrabScreenPosition;39;-521.3355,-27.96944;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;29;-542.58,195.399;Inherit;True;Property;_DistortionMap;Distortion Map;2;0;Create;True;0;0;0;False;0;False;-1;None;161b0899cec643d9b2a5b72bb8e1788b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;31;-544,400;Float;False;Property;_DistortionValue;Distortion Value;1;0;Create;True;0;0;0;False;0;False;0.292;0.033;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-128.7738,261.0988;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-256,-16;Float;False;normalizedClip;-1;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;36.62508,137.2995;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;8;224.0004,85.8997;Float;False;Global;_ScreenGrab0;Screen Grab 0;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;True;False;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;37;231.2177,270.9001;Float;False;Property;_PortalColor;Portal Color;0;0;Create;True;0;0;0;False;0;False;0.003838672,0.5220588,0.243292,0;0,1,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;504.2176,117.4984;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;704.4994,-13;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Stencil Portal Refraction Panel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;100;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;34;0
WireConnection;33;1;35;0
WireConnection;33;2;36;2
WireConnection;29;1;33;0
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;21;0;39;0
WireConnection;30;0;21;0
WireConnection;30;1;32;0
WireConnection;8;0;30;0
WireConnection;38;0;8;0
WireConnection;38;1;37;0
WireConnection;0;2;38;0
ASEEND*/
//CHKSM=8F44B57DCC4AD4AC5D53A587FDCF23D66B38B40C