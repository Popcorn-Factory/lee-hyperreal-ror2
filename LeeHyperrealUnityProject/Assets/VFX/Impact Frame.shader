// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Violet/ImpactFrame"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_SaturationMult("Saturation Mult", Range( 0 , 1)) = 0
		_ColorValueMult("Color Value Mult", Range( 0 , 10)) = 0
		_Fadeimpact("Fade impact", Range( 0 , 1)) = 0
		_FadeDistancefloor("Fade Distance floor", Range( 0 , 20)) = 13
		_FloorDistanceMultiplier("Floor Distance Multiplier", Range( 0 , 2)) = 0.1
		_OutlineEmissionPower("Outline Emission Power", Range( 0 , 10)) = 1
		_OutlineThickness("Outline Thickness", Range( 0 , 20)) = 5
		_OutlineDepthMult("Outline Depth Mult", Range( 0 , 5)) = 1
		_OutlineDepthBias("Outline Depth Bias", Range( 0 , 10)) = 1
		_OutlineCutoff("Outline Cutoff", Range( 0 , 10)) = 1
		_ImpactUVStretch("Impact UV Stretch", Range( 0 , 15)) = 0
		_ImpactUVLineScale("Impact UV Line Scale", Float) = 50
		_ImpactUVTimeScale("Impact UV Time Scale", Range( 0 , 1)) = 1
		[Toggle]_DistortionUseObjectPosition("Distortion Use Object Position", Range( 0 , 1)) = 1
		[Toggle]_ImpactUVTimeUseFPSFloor("Impact UV Time Use FPS Floor", Float) = 0
		_ImpactUVTimeFPS("Impact UV Time FPS", Range( 0 , 240)) = 8
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+4" "IgnoreProjector" = "True" "DisableBatching" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		ZTest Always
		Stencil
		{
			Ref 128
			ReadMask 128
			CompFront Equal
			PassFront DecrSat
			CompBack Equal
		}
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			float3 viewDir;
			INTERNAL_DATA
			half ASEIsFrontFacing : VFACE;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _SaturationMult;
		uniform float _OutlineEmissionPower;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DistortionUseObjectPosition;
		uniform float _ImpactUVLineScale;
		uniform float _ImpactUVTimeUseFPSFloor;
		uniform float _ImpactUVTimeScale;
		uniform float _ImpactUVTimeFPS;
		uniform float _ImpactUVStretch;
		uniform float _OutlineThickness;
		uniform float _OutlineDepthMult;
		uniform float _OutlineDepthBias;
		uniform float _OutlineCutoff;
		uniform float _ColorValueMult;
		uniform float _Fadeimpact;
		uniform float _FadeDistancefloor;
		uniform float _FloorDistanceMultiplier;
		uniform float _EdgeLength;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

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


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline float2 ASESafeNormalize(float2 inVec)
		{
			float dp3 = max( 0.001f , dot( inVec , inVec ) );
			return inVec* rsqrt( dp3);
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor41 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPosNorm.xy);
			float3 hsvTorgb51 = RGBToHSV( screenColor41.rgb );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float clampDepth47_g179 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
			float smoothstepResult46_g179 = smoothstep( 0.0 , 0.2 , clampDepth47_g179);
			float2 appendResult251 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 _Vector1 = float2(0.5,0.5);
			float4 objectToClip278 = UnityObjectToClipPos(float3( 0,0,0 ));
			float3 objectToClip278NDC = objectToClip278.xyz/objectToClip278.w;
			float2 appendResult282 = (float2(objectToClip278NDC.x , objectToClip278NDC.y));
			float2 ifLocalVar361 = 0;
			if( 0.0 >= _DistortionUseObjectPosition )
				ifLocalVar361 = _Vector1;
			else
				ifLocalVar361 = ( ( ( appendResult282 / float2( 2,2 ) ) + float2( 0.5,-0.5 ) ) * float2( 1,-1 ) );
			float2 CenteredUV15_g182 = ( appendResult251 - ifLocalVar361 );
			float2 break17_g182 = CenteredUV15_g182;
			float2 appendResult23_g182 = (float2(( length( CenteredUV15_g182 ) * 0.03 * 2.0 ) , ( atan2( break17_g182.x , break17_g182.y ) * ( 1.0 / 6.28318548202515 ) * _ImpactUVLineScale )));
			float mulTime347 = _Time.y * _ImpactUVTimeScale;
			float ifLocalVar354 = 0;
			if( 0.0 >= _ImpactUVTimeUseFPSFloor )
				ifLocalVar354 = mulTime347;
			else
				ifLocalVar354 = floor( ( mulTime347 * _ImpactUVTimeFPS ) );
			float cos346 = cos( ifLocalVar354 );
			float sin346 = sin( ifLocalVar354 );
			float2 rotator346 = mul( appendResult23_g182 - float2( 0.5,0.5 ) , float2x2( cos346 , -sin346 , sin346 , cos346 )) + float2( 0.5,0.5 );
			float simplePerlin2D312 = snoise( rotator346*11.8 );
			simplePerlin2D312 = simplePerlin2D312*0.5 + 0.5;
			float3 objToWorld335 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 normalizeResult275 = ASESafeNormalize( ( ( ( appendResult251 - ifLocalVar361 ) * float2( 2,2 ) ) * float2( -1,-1 ) ) );
			float2 temp_output_3_0_g179 = ( appendResult251 + ( ( (0.0 + (simplePerlin2D312 - 0.0) * (_ImpactUVStretch - 0.0) / (1.0 - 0.0)) / distance( _WorldSpaceCameraPos , objToWorld335 ) ) * normalizeResult275 ) );
			float eyeDepth21_g179 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_3_0_g179, 0.0 , 0.0 ).xy ));
			float4 appendResult136 = (float4(( 1.0 / _ScreenParams.x ) , ( 1.0 / _ScreenParams.y ) , 0.0 , 0.0));
			float3 break9_g179 = ( appendResult136 * _OutlineThickness ).xyz;
			float4 appendResult10_g179 = (float4(break9_g179.x , break9_g179.z , 0.0 , 0.0));
			float eyeDepth5_g179 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g179, 0.0 , 0.0 ) - appendResult10_g179 ).xy ));
			float eyeDepth13_g179 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g179, 0.0 , 0.0 ) + appendResult10_g179 ).xy ));
			float4 appendResult20_g179 = (float4(break9_g179.z , break9_g179.y , 0.0 , 0.0));
			float eyeDepth17_g179 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g179, 0.0 , 0.0 ) + appendResult20_g179 ).xy ));
			float eyeDepth16_g179 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g179, 0.0 , 0.0 ) - appendResult20_g179 ).xy ));
			float clampResult153 = clamp( pow( abs( ( saturate( ( smoothstepResult46_g179 * ( abs( ( eyeDepth21_g179 - eyeDepth5_g179 ) ) + abs( ( eyeDepth21_g179 - eyeDepth13_g179 ) ) + abs( ( eyeDepth21_g179 - eyeDepth17_g179 ) ) + abs( ( eyeDepth21_g179 - eyeDepth16_g179 ) ) ) ) ) * _OutlineDepthMult ) ) , _OutlineDepthBias ) , 0.0 , 1.0 );
			float temp_output_158_0 = ( _OutlineEmissionPower * clampResult153 );
			float temp_output_60_0 = floor( ( ( hsvTorgb51.z * _ColorValueMult ) * 3 ) );
			float ifLocalVar245 = 0;
			if( temp_output_158_0 <= _OutlineCutoff )
				ifLocalVar245 = temp_output_60_0;
			else
				ifLocalVar245 = temp_output_158_0;
			float lerpResult66 = lerp( ifLocalVar245 , hsvTorgb51.z , _Fadeimpact);
			float3 hsvTorgb52 = HSVToRGB( float3(hsvTorgb51.x,( hsvTorgb51.y * _SaturationMult ),lerpResult66) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV118 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode118 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV118, 3.0 ) );
			float fresnelNdotV78 = dot( normalize( ase_worldNormal ), i.viewDir );
			float fresnelNode78 = ( 0.0 + 0.2 * pow( max( 1.0 - fresnelNdotV78 , 0.0001 ), 4.0 ) );
			float switchResult117 = (((i.ASEIsFrontFacing>0)?(( 1.0 - fresnelNode118 )):(fresnelNode78)));
			float clampResult85 = clamp( ( 1.0 - switchResult117 ) , 0.0 , 1.0 );
			float smoothstepResult91 = smoothstep( 0.0 , 0.75 , clampResult85);
			float eyeDepth92 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float smoothstepResult104 = smoothstep( 0.0 , 1.0 , ( ( ( 1.0 - ( eyeDepth92 - ase_screenPos.w ) ) + _FadeDistancefloor ) * _FloorDistanceMultiplier ));
			float switchResult114 = (((i.ASEIsFrontFacing>0)?(smoothstepResult104):(0.0)));
			float4 lerpResult84 = lerp( float4( hsvTorgb52 , 0.0 ) , screenColor41 , max( smoothstepResult91 , switchResult114 ));
			o.Emission = lerpResult84.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.HSVToRGBNode;52;256,-64;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-130.247,15.97661;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;66;-151.5662,-166.2892;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;44;-1095.333,4;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;41;-777.4249,71.42177;Inherit;False;Global;_GrabScreen0;Grab Screen 0;6;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;147;-1472.606,-409.6395;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;148;-1346.075,-364.2182;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;153;-1215.568,-470.6799;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;84;498.9612,354.362;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-1625.896,-314.9151;Inherit;False;Property;_OutlineDepthBias;Outline Depth Bias;14;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-1973.683,-330.3152;Inherit;False;Property;_OutlineDepthMult;Outline Depth Mult;13;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-436.1877,96.71889;Inherit;False;Property;_SaturationMult;Saturation Mult;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-576.2839,-176.8537;Inherit;False;Property;_Fadeimpact;Fade impact;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-183.1084,-361.3095;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;61;35.37871,-372.0277;Inherit;False;3;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;60;237.4299,-370.1321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;51;-527.1741,-53.90469;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;156;-1117.7,-605.5945;Inherit;False;Property;_OutlineEmissionPower;Outline Emission Power;11;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-5032.46,2307.848;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;4,0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;211;-5585.225,2275.802;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;212;-5332.036,2267.424;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;233;-5365.238,1999.215;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;215;-4799.711,2343.287;Inherit;False;Polar Coordinates;-1;;160;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;234;-4493.933,2404.677;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;235;-4279.197,2362.141;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-4040.445,2338.814;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;232;-5140.892,2012.938;Inherit;False;Random Range;-1;;176;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.2;False;3;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;-4517.075,2083.215;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;217;-4811.414,2058.677;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;238;-1846.723,2343.65;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;239;-1593.312,2342.852;Inherit;False;ConstantBiasScale;-1;;178;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;240;-1319.727,2315.815;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;3.7,261;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;242;-1086.813,2310.839;Inherit;True;Property;_TextureSample0;Texture Sample 0;22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StickyNoteNode;290;-3889.996,803.4455;Inherit;False;1053.497;395.2459;Direction To Object in Screen Space;;1,1,1,1;;0;0
Node;AmplifyShaderEditor.StickyNoteNode;332;-5065.804,692.2555;Inherit;False;1141.719;555.9642;Get Object Center In Screen Space;;1,1,1,1;;0;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-591.5702,-334.7999;Inherit;False;Property;_ColorValueMult;Color Value Mult;6;0;Create;True;0;0;0;False;0;False;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;208;-1985.806,-575.4052;Inherit;True;Sobel Sample Depth;-1;;179;4bc080cdcd856fd4fa538597069d3287;0;2;6;FLOAT3;0,0,0;False;3;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-1585.707,-438.8391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;150;-1715.134,-470.083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-263.0819,-465.3859;Inherit;False;Property;_OutlineCutoff;Outline Cutoff;15;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;245;418.6873,-542.3531;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-544.6268,-612.0285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;357;-3566.419,258.1263;Inherit;False;526.8882;505.6691;Distance To Camera;;1,1,1,1;;0;0
Node;AmplifyShaderEditor.StickyNoteNode;358;-5155.668,-320.3376;Inherit;False;2283.469;572.534;Distortion Lines;;1,1,1,1;;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;138;-2633.462,-865.572;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;140;-2650.129,-758.9055;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-2419.805,-831.5435;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-2150.72,-640.97;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-2507.152,-598.5362;Inherit;False;Property;_OutlineThickness;Outline Thickness;12;0;Create;True;0;0;0;False;0;False;5;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;359;-5250.496,-384.2921;Inherit;False;3089.14;1683.015;Impact UV Distortion;Impact UV Distortion;1,1,1,1;;0;0
Node;AmplifyShaderEditor.ScreenParams;137;-2957.158,-950.8082;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;139;-2978.41,-721.2053;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;318;-3358.556,-182.7519;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;339;-3023.555,32.17049;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;312;-3680.13,-263.7675;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;11.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;346;-3863.8,-241.2285;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;261;-4161.123,-264.4696;Inherit;True;Polar Coordinates;-1;;182;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0.03;False;4;FLOAT;20;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;354;-4086.321,-48.55054;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;348;-4340.105,125.3126;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;351;-4520.105,115.3127;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;347;-4740.105,25.31296;Inherit;False;1;0;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;275;-3146.686,865.7951;Inherit;True;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;-3381.281,865.5925;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;-1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;-3626.697,864.3251;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;271;-3852.092,863.6387;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;251;-4419.174,415.2774;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;334;-3514.146,314.0205;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;336;-3215.824,340.216;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;335;-3493.976,457.4196;Inherit;True;Object;World;True;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;319;-2738.942,384.6387;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;322;-2447.925,282.5511;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;250;-4634.84,395.7315;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;87;-1019.152,766.188;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;78;-801.3358,708.8214;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;3;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;86;-1229.772,711.5194;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;118;-796.9398,540.6362;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;82;-496.5423,776.682;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;119;-477.8651,656.4817;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;85;-295.3017,786.8531;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;117;-313.309,638.2018;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;126;34.20103,836.0448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;91;-157.2833,789.1511;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-609.0746,1156.071;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;114;-350.5428,981.2363;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;-961.2128,1101.22;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;95;-1219.128,1185.15;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;97;-783.4715,1125.851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;104;-289.9812,1146.49;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-298.4101,1458.589;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-1198.61,1409.162;Inherit;False;Property;_FadeDistancefloor;Fade Distance floor;9;0;Create;True;0;0;0;False;0;False;13;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-593.8089,1509.692;Inherit;False;Property;_FloorDistanceMultiplier;Floor Distance Multiplier;10;0;Create;True;0;0;0;False;0;False;0.1;0.25;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;92;-1292.867,1074.751;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;343;-4438.413,-200.5693;Inherit;False;Property;_ImpactUVLineScale;Impact UV Line Scale;17;0;Create;True;0;0;0;False;0;False;50;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;355;-4456.597,-72.36082;Inherit;False;Property;_ImpactUVTimeUseFPSFloor;Impact UV Time Use FPS Floor;20;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;349;-5074.105,23.31298;Inherit;False;Property;_ImpactUVTimeScale;Impact UV Time Scale;18;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;333;-3844.177,48.50102;Inherit;False;Property;_ImpactUVStretch;Impact UV Stretch;16;0;Create;True;0;0;0;False;0;False;0;0.02;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;72;877.4775,-56.92243;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;Unlit;Violet/ImpactFrame;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;False;Off;2;False;;7;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;4;True;Opaque;;Overlay;All;12;all;True;True;True;True;0;False;;True;128;False;;128;False;;255;False;;5;False;;5;False;;0;False;;0;False;;5;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;8;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;352;-4783.105,168.3123;Inherit;False;Property;_ImpactUVTimeFPS;Impact UV Time FPS;21;0;Create;True;0;0;0;False;0;False;8;0;0;240;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;278;-5025.703,1018.016;Inherit;True;Object;Clip;True;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;282;-4762.172,1115.237;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;330;-4561.549,1110.793;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;328;-4370.772,1089.93;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;331;-4230.282,1090.051;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;361;-4555.13,792.5073;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;362;-4787.414,898.728;Inherit;False;Constant;_Vector1;Vector 1;19;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;360;-4906.214,773.6718;Inherit;False;Property;_DistortionUseObjectPosition;Distortion Use Object Position;19;1;[Toggle];Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
WireConnection;52;0;51;1
WireConnection;52;1;63;0
WireConnection;52;2;66;0
WireConnection;63;0;51;2
WireConnection;63;1;62;0
WireConnection;66;0;245;0
WireConnection;66;1;51;3
WireConnection;66;2;67;0
WireConnection;41;0;44;0
WireConnection;147;0;145;0
WireConnection;148;0;147;0
WireConnection;148;1;149;0
WireConnection;153;0;148;0
WireConnection;84;0;52;0
WireConnection;84;1;41;0
WireConnection;84;2;126;0
WireConnection;64;0;51;3
WireConnection;64;1;65;0
WireConnection;61;0;64;0
WireConnection;60;0;61;0
WireConnection;51;0;41;0
WireConnection;221;0;217;0
WireConnection;221;1;212;0
WireConnection;212;0;211;1
WireConnection;212;1;211;2
WireConnection;233;0;211;1
WireConnection;215;1;212;0
WireConnection;234;0;215;0
WireConnection;235;0;211;1
WireConnection;236;0;232;0
WireConnection;236;1;235;0
WireConnection;232;1;233;0
WireConnection;218;0;215;0
WireConnection;218;1;217;0
WireConnection;217;0;232;0
WireConnection;239;3;238;0
WireConnection;240;0;239;0
WireConnection;242;1;240;0
WireConnection;208;6;141;0
WireConnection;208;3;322;0
WireConnection;145;0;150;0
WireConnection;145;1;146;0
WireConnection;150;0;208;0
WireConnection;245;0;158;0
WireConnection;245;1;246;0
WireConnection;245;2;158;0
WireConnection;245;3;60;0
WireConnection;245;4;60;0
WireConnection;158;0;156;0
WireConnection;158;1;153;0
WireConnection;138;0;139;0
WireConnection;138;1;137;1
WireConnection;140;0;139;0
WireConnection;140;1;137;2
WireConnection;136;0;138;0
WireConnection;136;1;140;0
WireConnection;141;0;136;0
WireConnection;141;1;142;0
WireConnection;318;0;312;0
WireConnection;318;4;333;0
WireConnection;339;0;318;0
WireConnection;339;1;336;0
WireConnection;312;0;346;0
WireConnection;346;0;261;0
WireConnection;346;2;354;0
WireConnection;261;1;251;0
WireConnection;261;2;361;0
WireConnection;261;4;343;0
WireConnection;354;1;355;0
WireConnection;354;2;347;0
WireConnection;354;3;347;0
WireConnection;354;4;348;0
WireConnection;348;0;351;0
WireConnection;351;0;347;0
WireConnection;351;1;352;0
WireConnection;347;0;349;0
WireConnection;275;0;289;0
WireConnection;289;0;284;0
WireConnection;284;0;271;0
WireConnection;271;0;251;0
WireConnection;271;1;361;0
WireConnection;251;0;250;1
WireConnection;251;1;250;2
WireConnection;336;0;334;0
WireConnection;336;1;335;0
WireConnection;319;0;339;0
WireConnection;319;1;275;0
WireConnection;322;0;251;0
WireConnection;322;1;319;0
WireConnection;78;0;86;0
WireConnection;78;4;87;0
WireConnection;82;0;117;0
WireConnection;119;0;118;0
WireConnection;85;0;82;0
WireConnection;117;0;119;0
WireConnection;117;1;78;0
WireConnection;126;0;91;0
WireConnection;126;1;114;0
WireConnection;91;0;85;0
WireConnection;102;0;97;0
WireConnection;102;1;103;0
WireConnection;114;0;104;0
WireConnection;96;0;92;0
WireConnection;96;1;95;4
WireConnection;97;0;96;0
WireConnection;104;0;120;0
WireConnection;120;0;102;0
WireConnection;120;1;121;0
WireConnection;72;2;84;0
WireConnection;282;0;278;1
WireConnection;282;1;278;2
WireConnection;330;0;282;0
WireConnection;328;0;330;0
WireConnection;331;0;328;0
WireConnection;361;1;360;0
WireConnection;361;2;362;0
WireConnection;361;3;362;0
WireConnection;361;4;331;0
ASEEND*/
//CHKSM=8B6722F63E864EFAF956C3F7B83F21CD3D9DC6BB