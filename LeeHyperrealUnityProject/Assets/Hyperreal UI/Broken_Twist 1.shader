// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Broken_Twist"
{
	Properties
	{
		_NormalTex("NormalTex", 2D) = "white" {}
		_NormalIntensity("NormalIntensity", Range( 0 , 59)) = -50
		_NormalV("NormalV", Float) = 0
		_NormalU("NormalU", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _TextureSample0;
		uniform sampler2D _NormalTex;
		uniform float _NormalU;
		uniform float _NormalV;
		uniform float4 _NormalTex_ST;
		uniform float _NormalIntensity;
		uniform sampler2D _TextureSample1;


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
			float3 ase_worldPos = i.worldPos;
			float4 temp_cast_0 = (distance( _WorldSpaceCameraPos , ase_worldPos )).xxxx;
			float4 appendResult98 = (float4(1.0 , 1.0 , 0.0 , 0.0));
			float4 lerpResult86 = lerp( temp_cast_0 , appendResult98 , 1.0);
			float temp_output_110_0 = floor( ( _Time.y / 0.2 ) );
			float2 temp_cast_1 = (temp_output_110_0).xx;
			float dotResult4_g7 = dot( temp_cast_1 , float2( 12.9898,78.233 ) );
			float lerpResult10_g7 = lerp( 0.5 , 1.0 , frac( ( sin( dotResult4_g7 ) * 43758.55 ) ));
			float2 temp_cast_2 = (temp_output_110_0).xx;
			float dotResult4_g8 = dot( temp_cast_2 , float2( 12.9898,78.233 ) );
			float lerpResult10_g8 = lerp( 0.5 , 1.0 , frac( ( sin( dotResult4_g8 ) * 43758.55 ) ));
			float4 appendResult134 = (float4(lerpResult10_g7 , lerpResult10_g8 , 0.0 , 0.0));
			float2 temp_cast_4 = (temp_output_110_0).xx;
			float dotResult4_g6 = dot( temp_cast_4 , float2( 12.9898,78.233 ) );
			float lerpResult10_g6 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g6 ) * 43758.55 ) ));
			float temp_output_111_0 = ( _Time.x * lerpResult10_g6 );
			float4 appendResult123 = (float4(temp_output_111_0 , ( temp_output_111_0 * 1.3 ) , 0.0 , 0.0));
			float2 uv_TexCoord112 = i.uv_texcoord * ( appendResult134 * 1.0 ).xy + appendResult123.xy;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 ScreenUV16 = ( ase_grabScreenPosNorm / ase_grabScreenPosNorm.a );
			float2 appendResult12 = (float2(_NormalU , _NormalV));
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float2 panner9 = ( 1.0 * _Time.y * appendResult12 + uv_NormalTex);
			float4 Normal15 = ( tex2D( _NormalTex, panner9 ) * ( _NormalIntensity / distance( _WorldSpaceCameraPos , ase_worldPos ) ) );
			float2 uv_TexCoord135 = i.uv_texcoord * ( appendResult134 * 1.0 ).xy + ( 1.0 * appendResult123 ).xy;
			float2 appendResult44 = (float2(( ( (0.95 + (tex2D( _TextureSample0, uv_TexCoord112 ).r - 0.0) * (1.05 - 0.95) / (1.0 - 0.0)) * (ScreenUV16).x ) + Normal15 ).r , ( (0.95 + (tex2D( _TextureSample1, uv_TexCoord135 ).r - 0.0) * (1.05 - 0.95) / (1.0 - 0.0)) * (ScreenUV16).y )));
			float4 screenColor2 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( lerpResult86 * float4( appendResult44, 0.0 , 0.0 ) ).xy);
			o.Emission = screenColor2.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2943.12,-629.1853;Inherit;False;0;4;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;12;-2870.391,-354.2229;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;59;-2586.597,-262.5145;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;61;-2418.197,-82.00134;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-2323.722,-357.6477;Inherit;False;Property;_NormalIntensity;NormalIntensity;2;0;Create;True;0;0;0;False;0;False;-50;0;0;59;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;60;-2251.993,-215.1848;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;1;-3115.943,-1034.796;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-2550.18,-511.2222;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;3;-2777.668,-973.1945;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;4;-2273.922,-597.8491;Inherit;True;Property;_NormalTex;NormalTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-2014.186,-284.9043;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1904.094,-550.1935;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;80;-1154.403,-1222.329;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;82;-825.709,-1166.134;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1076.281,-272.5533;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2986.99,-75.77048;Inherit;False;Property;_Chromaticdispersion;Chromatic dispersion;6;0;Create;True;0;0;0;False;0;False;0;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;26;-841.7139,270.6107;Inherit;False;Global;_GrabScreen2;Grab Screen 2;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;22;-844.9141,69.0107;Inherit;False;Global;_GrabScreen1;Grab Screen 1;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-2954.143,32.91621;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1230.215,14.83849;Inherit;False;16;ScreenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-998.9141,64.0107;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1750.502,367.328;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1717.693,9.472983;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;49;-2064.694,-103.5421;Inherit;False;InstancedProperty;_Vector0;Vector 0;7;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1565.038,350.7382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1226.815,89.43849;Inherit;False;15;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1223.015,301.4385;Inherit;False;15;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-556.3643,-36.67538;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-1891.266,171.6998;Inherit;False;35;Chromaticdispersion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1382.704,346.0553;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-1559.492,55.44235;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-995.7139,265.6107;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-2378.838,-8.302074;Inherit;False;Chromaticdispersion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-1227.015,216.4385;Inherit;False;16;ScreenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1381.284,132.6189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2371.608,-977.6909;Inherit;False;ScreenUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1724.572,-548.2921;Inherit;False;Normal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;2;-622.4096,-283.2668;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-3068.391,-368.2228;Inherit;False;Property;_NormalU;NormalU;4;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;42;-1523.617,-452.7646;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;-1514.934,-143.5352;Inherit;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-1816.495,-339.5804;Inherit;False;16;ScreenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1283.095,-308.0587;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1387.326,-838.3846;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;-698.0943,-841.6789;Inherit;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-1506.57,-284.3965;Inherit;False;15;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3066.391,-296.2227;Inherit;False;Property;_NormalV;NormalV;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-883.0289,-465.7019;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1258.308,-495.1718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-1112.308,-417.1718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-906.799,-821.7737;Inherit;False;Constant;_Float5;Float 5;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-878.1989,-711.2737;Inherit;False;Constant;_Float6;Float 5;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-742.9988,-1073.974;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1159.065,-770.8473;Inherit;False;Property;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;86;-500.0845,-1134.038;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1096.864,-626.898;Inherit;False;Property;_Float4;Float 4;9;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;36;-2651.438,-22.90202;Inherit;False;Property;_ChromaticPower;ChromaticPower;5;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;81;-1107.162,-998.968;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;107;583.9604,-727.6273;Inherit;True;Property;_TextureSample1;Texture Sample 0;11;0;Create;True;0;0;0;False;0;False;-1;None;48d147b4598f15e4aa801c9bc8fa8d64;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;110;1142.96,-564.6272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;108;863.9614,-622.6273;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;114;1095.96,-478.6275;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;958.96,-434.6275;Inherit;False;Constant;_Float7;Float 7;11;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;126;732.9608,-494.6276;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;1136.285,-1145.498;Inherit;False;Constant;_Float13;Float 13;11;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;128;1512.217,-384.9594;Inherit;False;Random Range;-1;;5;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;129;1188.217,-177.9594;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;122;1534.96,-585.6273;Inherit;False;Constant;_Float12;Float 12;11;0;Create;True;0;0;0;False;0;False;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;109;1303.959,-610.6273;Inherit;False;Random Range;-1;;6;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;130;1767.217,-565.9591;Inherit;False;Random Range;-1;;7;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;131;1793.217,-415.9594;Inherit;False;Random Range;-1;;8;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;1578.218,-497.9595;Inherit;False;Constant;_Float14;Float 14;11;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;1641.217,-426.9594;Inherit;False;Constant;_Float15;Float 14;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;123;1563.961,-900.6273;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;1286.217,-904.9592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;1180.96,-706.6273;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;1445.959,-725.6273;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;1049.217,-899.9592;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;1252.96,-1058.628;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;134;1952.219,-718.9592;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;1287.217,-805.9592;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;1832.217,-952.9592;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;137;1514.217,-1071.96;Inherit;False;Constant;_Float16;Float 16;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;1773.217,-1049.96;Inherit;False;Constant;_Float17;Float 16;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;116;514.9606,-927.6273;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;355.663,-501.2719;Inherit;False;Constant;_Float11;Float 8;11;0;Create;True;0;0;0;False;0;False;1.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;345.6629,-556.2715;Inherit;False;Constant;_Float10;Float 8;11;0;Create;True;0;0;0;False;0;False;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;337.6629,-630.2721;Inherit;False;Constant;_Float9;Float 8;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;309.6628,-695.2724;Inherit;False;Constant;_Float8;Float 8;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;687.7825,-1124.874;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;48d147b4598f15e4aa801c9bc8fa8d64;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;145;-277.0518,-264.7446;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Broken_Twist;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;Overlay;;Overlay;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;60;0;59;0
WireConnection;60;1;61;0
WireConnection;9;0;8;0
WireConnection;9;2;12;0
WireConnection;3;0;1;0
WireConnection;3;1;1;4
WireConnection;4;1;9;0
WireConnection;62;0;6;0
WireConnection;62;1;60;0
WireConnection;5;0;4;0
WireConnection;5;1;62;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;44;0;7;0
WireConnection;44;1;95;0
WireConnection;26;0;25;0
WireConnection;22;0;21;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;29;0
WireConnection;32;0;38;0
WireConnection;32;1;33;0
WireConnection;27;0;2;1
WireConnection;27;1;22;2
WireConnection;27;2;26;3
WireConnection;27;3;2;4
WireConnection;34;0;38;0
WireConnection;34;1;32;0
WireConnection;31;0;30;0
WireConnection;31;1;38;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;25;2;34;0
WireConnection;35;0;36;0
WireConnection;29;0;31;0
WireConnection;29;1;38;0
WireConnection;16;0;3;0
WireConnection;15;0;5;0
WireConnection;2;0;56;0
WireConnection;42;0;17;0
WireConnection;43;0;17;0
WireConnection;7;0;93;0
WireConnection;7;1;18;0
WireConnection;56;0;86;0
WireConnection;56;1;44;0
WireConnection;93;0;116;0
WireConnection;93;1;42;0
WireConnection;95;0;126;0
WireConnection;95;1;43;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;86;0;82;0
WireConnection;86;1;98;0
WireConnection;86;2;88;0
WireConnection;36;1;28;0
WireConnection;36;0;37;1
WireConnection;107;1;135;0
WireConnection;110;0;114;0
WireConnection;114;0;108;2
WireConnection;114;1;115;0
WireConnection;126;0;107;1
WireConnection;126;1;117;0
WireConnection;126;2;118;0
WireConnection;126;3;119;0
WireConnection;126;4;120;0
WireConnection;128;1;129;2
WireConnection;109;1;110;0
WireConnection;130;1;110;0
WireConnection;130;2;132;0
WireConnection;130;3;133;0
WireConnection;131;1;110;0
WireConnection;131;2;132;0
WireConnection;131;3;133;0
WireConnection;123;0;111;0
WireConnection;123;1;124;0
WireConnection;136;0;137;0
WireConnection;136;1;123;0
WireConnection;111;0;108;1
WireConnection;111;1;109;0
WireConnection;124;0;111;0
WireConnection;124;1;122;0
WireConnection;135;0;138;0
WireConnection;135;1;136;0
WireConnection;112;0;139;0
WireConnection;112;1;123;0
WireConnection;134;0;130;0
WireConnection;134;1;131;0
WireConnection;138;0;134;0
WireConnection;138;1;137;0
WireConnection;139;0;134;0
WireConnection;139;1;141;0
WireConnection;116;0;106;1
WireConnection;116;1;117;0
WireConnection;116;2;118;0
WireConnection;116;3;119;0
WireConnection;116;4;120;0
WireConnection;106;1;112;0
WireConnection;145;2;2;0
ASEEND*/
//CHKSM=7FA2C330A44F956A69BF6C5DCA9A1C4CBDCB012F