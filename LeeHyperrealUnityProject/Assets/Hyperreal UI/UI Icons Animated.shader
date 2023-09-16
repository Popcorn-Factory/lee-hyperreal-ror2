// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI Icons Animated"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color47 = IsGammaSpace() ? float4(0,0.2463689,1,1) : float4(0,0.04943452,1,1);
			float4 color42 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 panner24 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + i.uv_texcoord);
			float simplePerlin2D32 = snoise( panner24*15.07 );
			simplePerlin2D32 = simplePerlin2D32*0.5 + 0.5;
			float blendOpSrc36 = simplePerlin2D32;
			float blendOpDest36 = simplePerlin2D32;
			float4 temp_cast_0 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest36) / max( blendOpSrc36, 0.00001) ) ) ))).xxxx;
			float4 temp_output_1_0_g9 = temp_cast_0;
			float4 color41 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
			float4 temp_output_2_0_g9 = color41;
			float temp_output_11_0_g9 = distance( temp_output_1_0_g9 , temp_output_2_0_g9 );
			float4 lerpResult21_g9 = lerp( color42 , temp_output_1_0_g9 , saturate( ( ( temp_output_11_0_g9 - 1.0 ) / max( 0.0 , 1E-05 ) ) ));
			float4 temp_output_40_0 = lerpResult21_g9;
			float4 temp_output_1_0_g7 = temp_output_40_0;
			float4 color46 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float4 temp_output_2_0_g7 = color46;
			float temp_output_11_0_g7 = distance( temp_output_1_0_g7 , temp_output_2_0_g7 );
			float4 lerpResult21_g7 = lerp( color47 , temp_output_1_0_g7 , saturate( ( ( temp_output_11_0_g7 - 1.1 ) / max( 0.0 , 1E-05 ) ) ));
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 tex2DNode22 = tex2D( _TextureSample1, uv_TextureSample1 );
			float4 temp_cast_1 = (( tex2DNode22.a * 1.28 )).xxxx;
			float4 temp_cast_2 = (0.0).xxxx;
			float4 temp_cast_3 = (1.0).xxxx;
			float4 clampResult127 = clamp( ( lerpResult21_g7 - temp_cast_1 ) , temp_cast_2 , temp_cast_3 );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			float4 temp_output_77_0 = ( ( clampResult127 * 10.0 ) + tex2DNode1 );
			o.Albedo = temp_output_77_0.rgb;
			o.Emission = temp_output_77_0.rgb;
			float4 temp_cast_6 = (tex2DNode22.a).xxxx;
			float4 temp_cast_7 = (tex2DNode22.a).xxxx;
			float4 temp_cast_8 = (0.0).xxxx;
			float4 temp_cast_9 = (1.0).xxxx;
			float4 clampResult87 = clamp( ( ( temp_output_40_0 - temp_cast_6 ) - temp_cast_7 ) , temp_cast_8 , temp_cast_9 );
			o.Alpha = ( clampResult87 + tex2DNode1.a ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-859.3862,213.7567;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;-110.5864,389.2569;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-340.6863,755.8566;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;15.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;24;-508.5504,335.81;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;36;176.8362,329.7607;Inherit;False;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;183.4443,-43.1997;Inherit;False;Constant;_Color3;Color 3;2;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;42;137.9442,144.0003;Inherit;False;Constant;_Color4;Color 4;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;544.8442,446.9003;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;45;830.4437,-127.6999;Inherit;False;Replace Color;-1;;7;896dccb3016c847439def376a728b869;1,12,0;5;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;46;385.8436,-295.3998;Inherit;False;Constant;_Color5;Color 5;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;47;682.2435,-325.2998;Inherit;False;Constant;_Color6;Color 6;2;0;Create;True;0;0;0;False;0;False;0,0.2463689,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;817.4435,222.0001;Inherit;False;Constant;_Float4;Float 4;2;0;Create;True;0;0;0;False;0;False;1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;40;477.2439,56.90017;Inherit;False;Replace Color;-1;;9;896dccb3016c847439def376a728b869;1,12,0;5;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;22;477.4882,-776.2101;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;73e1df5b705e7524e9f64771191e6608;3b061c0b580e3f240b0eb7f32145ed82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;-759.5494,-851.3073;Inherit;False;Constant;_Float6;Float 6;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-547.6496,-853.9069;Inherit;False;Constant;_Float8;Float 6;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;85;132.251,-449.6081;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;86;412.7515,-547.1082;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;87;-298.5487,-986.5081;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-94,-357;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;UI Icons Animated;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.11;True;False;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;2;5;False;;10;False;;1;False;;0;False;;0;False;6.09;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-915.8785,-596.343;Inherit;False;Constant;_Float9;Float 9;2;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-512.1955,-143.28;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-706.3126,-628.9069;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1019.381,-332.3546;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;9f25085223a9a174e88249e2b5cd503a;9f25085223a9a174e88249e2b5cd503a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-445.3182,-417.5385;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;27;-1195.426,257.3188;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,-0.5;0,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;5.756866,-722.2929;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;126;483.5757,-852.9803;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;1.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;258.5757,-917.9803;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;127;-308.4243,-719.9803;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
WireConnection;32;0;24;0
WireConnection;32;1;34;0
WireConnection;24;0;28;0
WireConnection;24;2;27;0
WireConnection;36;0;32;0
WireConnection;36;1;32;0
WireConnection;45;1;40;0
WireConnection;45;2;46;0
WireConnection;45;3;47;0
WireConnection;45;4;48;0
WireConnection;40;1;36;0
WireConnection;40;2;41;0
WireConnection;40;3;42;0
WireConnection;40;4;43;0
WireConnection;85;0;40;0
WireConnection;85;1;22;4
WireConnection;86;0;85;0
WireConnection;86;1;22;4
WireConnection;87;0;86;0
WireConnection;87;1;84;0
WireConnection;87;2;83;0
WireConnection;0;0;77;0
WireConnection;0;2;77;0
WireConnection;0;9;60;0
WireConnection;60;0;87;0
WireConnection;60;1;1;4
WireConnection;88;0;127;0
WireConnection;88;1;89;0
WireConnection;77;0;88;0
WireConnection;77;1;1;0
WireConnection;58;0;45;0
WireConnection;58;1;125;0
WireConnection;125;0;22;4
WireConnection;125;1;126;0
WireConnection;127;0;58;0
WireConnection;127;1;84;0
WireConnection;127;2;83;0
ASEEND*/
//CHKSM=A66021475F2D36726C8CF311CF09E0DBAD1E1CDB