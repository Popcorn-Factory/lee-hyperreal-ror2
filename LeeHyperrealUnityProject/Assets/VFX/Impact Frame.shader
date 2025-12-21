// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Violet/ImpactFrame"
{
	Properties
	{
		_SaturationMult("Saturation Mult", Range( 0 , 1)) = 0
		_ColorValueMult("Color Value Mult", Range( 0 , 10)) = 0
		_Fadeimpact("Fade impact", Range( 0 , 1)) = 0
		_FadeDistancefloor("Fade Distance floor", Range( 0 , 20)) = 13
		_FloorDistanceMultiplier("Floor Distance Multiplier", Range( 0 , 2)) = 0.1
		_OutlineThickness("Outline Thickness", Range( 0 , 20)) = 5
		_OutlineDepthMult("Outline Depth Mult", Range( 0 , 5)) = 1
		_OutlineDepthBias("Outline Depth Bias", Range( 0 , 10)) = 1
		_OutlineEmissionPower("Outline Emission Power", Range( 0 , 10)) = 1
		_OutlineCutoff("Outline Cutoff", Range( 0 , 10)) = 1
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
		#pragma target 3.5
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow 
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
		uniform float _OutlineThickness;
		uniform float _OutlineDepthMult;
		uniform float _OutlineDepthBias;
		uniform float _OutlineCutoff;
		uniform float _ColorValueMult;
		uniform float _Fadeimpact;
		uniform float _FadeDistancefloor;
		uniform float _FloorDistanceMultiplier;


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
			float clampDepth47_g177 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
			float smoothstepResult46_g177 = smoothstep( 0.0 , 0.2 , clampDepth47_g177);
			float2 temp_output_3_0_g177 = ase_screenPosNorm.xy;
			float eyeDepth21_g177 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_3_0_g177, 0.0 , 0.0 ).xy ));
			float4 appendResult136 = (float4(( 1.0 / _ScreenParams.x ) , ( 1.0 / _ScreenParams.y ) , 0.0 , 0.0));
			float3 break9_g177 = ( appendResult136 * _OutlineThickness ).xyz;
			float4 appendResult10_g177 = (float4(break9_g177.x , break9_g177.z , 0.0 , 0.0));
			float eyeDepth5_g177 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g177, 0.0 , 0.0 ) - appendResult10_g177 ).xy ));
			float eyeDepth13_g177 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g177, 0.0 , 0.0 ) + appendResult10_g177 ).xy ));
			float4 appendResult20_g177 = (float4(break9_g177.z , break9_g177.y , 0.0 , 0.0));
			float eyeDepth17_g177 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g177, 0.0 , 0.0 ) + appendResult20_g177 ).xy ));
			float eyeDepth16_g177 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( float4( temp_output_3_0_g177, 0.0 , 0.0 ) - appendResult20_g177 ).xy ));
			float clampResult153 = clamp( pow( abs( ( saturate( ( smoothstepResult46_g177 * ( abs( ( eyeDepth21_g177 - eyeDepth5_g177 ) ) + abs( ( eyeDepth21_g177 - eyeDepth13_g177 ) ) + abs( ( eyeDepth21_g177 - eyeDepth17_g177 ) ) + abs( ( eyeDepth21_g177 - eyeDepth16_g177 ) ) ) ) ) * _OutlineDepthMult ) ) , _OutlineDepthBias ) , 0.0 , 1.0 );
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
Node;AmplifyShaderEditor.SmoothstepOpNode;207;1452.409,235.9677;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;196;1185.218,329.0782;Inherit;False;1;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;147;-1472.606,-409.6395;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;148;-1346.075,-364.2182;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-1606.707,-438.8391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;150;-1745.134,-442.083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;153;-1215.568,-470.6799;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;84;498.9612,354.362;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-4494.654,906.4674;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;4,0.01;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;211;-5047.418,874.4214;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;212;-4794.229,866.0433;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;233;-4827.431,597.8344;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;215;-4261.905,941.906;Inherit;False;Polar Coordinates;-1;;160;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;234;-3956.133,1003.296;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DistanceOpNode;235;-3741.396,960.7601;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-3502.646,937.4332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;232;-4603.085,611.5569;Inherit;False;Random Range;-1;;176;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.2;False;3;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;-3979.274,681.8345;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;217;-4273.607,657.2957;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;208;-1961.806,-463.4052;Inherit;False;Sobel Sample Depth;-1;;177;4bc080cdcd856fd4fa538597069d3287;0;2;6;FLOAT3;0,0,0;False;3;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;87;-202.7318,1317.632;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;78;15.08527,1260.265;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;3;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;86;-413.3516,1262.963;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;118;19.48127,1092.079;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;82;319.8783,1328.126;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;119;338.5553,1207.925;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;85;521.1191,1338.297;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;117;503.1117,1189.645;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;126;850.6218,1387.489;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;91;659.1378,1340.595;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;207.3464,1707.516;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;114;465.8777,1532.681;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;-144.7922,1652.665;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;92;-462.4459,1649.196;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;95;-402.7077,1736.595;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;97;32.94963,1677.296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;104;526.4396,1697.935;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;518.0106,2010.034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-382.1891,1960.607;Inherit;False;Property;_FadeDistancefloor;Fade Distance floor;4;0;Create;True;0;0;0;False;0;False;13;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;222.6121,2061.137;Inherit;False;Property;_FloorDistanceMultiplier;Floor Distance Multiplier;5;0;Create;True;0;0;0;False;0;False;0.1;0.25;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;238;-1617.788,547.5527;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;239;-1364.377,546.7542;Inherit;False;ConstantBiasScale;-1;;178;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;240;-1090.792,519.7176;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;3.7,261;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;242;-857.8804,514.7422;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;138;-2486.247,-733.5483;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-2125.719,-473.9055;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;140;-2502.914,-626.8817;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenParams;137;-2809.943,-818.7845;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;136;-2272.59,-699.5198;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-2831.195,-589.1816;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-1625.896,-314.9151;Inherit;False;Property;_OutlineDepthBias;Outline Depth Bias;8;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-1973.683,-330.3152;Inherit;False;Property;_OutlineDepthMult;Outline Depth Mult;7;0;Create;True;0;0;0;False;0;False;1;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-2498.973,-473.5222;Inherit;False;Property;_OutlineThickness;Outline Thickness;6;0;Create;True;0;0;0;False;0;False;5;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-436.1877,96.71889;Inherit;False;Property;_SaturationMult;Saturation Mult;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-576.2839,-176.8537;Inherit;False;Property;_Fadeimpact;Fade impact;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-591.5702,-334.7999;Inherit;False;Property;_ColorValueMult;Color Value Mult;1;0;Create;True;0;0;0;False;0;False;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-183.1084,-361.3095;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;245;489.2711,-523.1951;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;61;35.37871,-372.0277;Inherit;False;3;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;60;237.4299,-370.1321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;51;-527.1741,-53.90469;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;156;-1117.7,-605.5945;Inherit;False;Property;_OutlineEmissionPower;Outline Emission Power;9;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-459.9758,-569.2333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-263.0819,-465.3859;Inherit;False;Property;_OutlineCutoff;Outline Cutoff;11;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;72;877.4775,-56.92243;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Unlit;Violet/ImpactFrame;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;False;Off;2;False;;7;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;4;True;Opaque;;Overlay;All;12;all;True;True;True;True;0;False;;True;128;False;;128;False;;255;False;;5;False;;5;False;;0;False;;0;False;;5;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;3;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;51;1
WireConnection;52;1;63;0
WireConnection;52;2;66;0
WireConnection;63;0;51;2
WireConnection;63;1;62;0
WireConnection;66;0;245;0
WireConnection;66;1;51;3
WireConnection;66;2;67;0
WireConnection;41;0;44;0
WireConnection;207;0;196;0
WireConnection;147;0;145;0
WireConnection;148;0;147;0
WireConnection;148;1;149;0
WireConnection;145;0;150;0
WireConnection;145;1;146;0
WireConnection;150;0;208;0
WireConnection;153;0;148;0
WireConnection;84;0;52;0
WireConnection;84;1;41;0
WireConnection;84;2;126;0
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
WireConnection;208;6;141;0
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
WireConnection;239;3;238;0
WireConnection;240;0;239;0
WireConnection;242;1;240;0
WireConnection;138;0;139;0
WireConnection;138;1;137;1
WireConnection;141;0;136;0
WireConnection;141;1;142;0
WireConnection;140;0;139;0
WireConnection;140;1;137;2
WireConnection;136;0;138;0
WireConnection;136;1;140;0
WireConnection;64;0;51;3
WireConnection;64;1;65;0
WireConnection;245;0;158;0
WireConnection;245;1;246;0
WireConnection;245;2;158;0
WireConnection;245;3;60;0
WireConnection;245;4;60;0
WireConnection;61;0;64;0
WireConnection;60;0;61;0
WireConnection;51;0;41;0
WireConnection;158;0;156;0
WireConnection;158;1;153;0
WireConnection;72;2;84;0
ASEEND*/
//CHKSM=8DCC19F9B5E7638AB44BCDB281B5A5373E477CD5