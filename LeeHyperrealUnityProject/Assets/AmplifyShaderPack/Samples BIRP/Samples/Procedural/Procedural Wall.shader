// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Procedural Wall"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 12
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 1
		_Slope("Slope", Range( 0 , 0.2)) = 0.2
		_Noise("Noise", 2D) = "white" {}
		_PatternSize("Pattern Size", Vector) = (0,0,0,0)
		_NoiseIntensity("Noise Intensity", Range( 0 , 1)) = 0
		_BrickTiling("Brick Tiling", Float) = 0
		_BrickHeight("Brick Height", Range( 0 , 1)) = 0
		_InnerAlbedo("Inner Albedo", 2D) = "white" {}
		_InnerNormal("Inner Normal", 2D) = "bump" {}
		_BrickAlbedo("Brick Albedo", 2D) = "white" {}
		_BrickNormal("Brick Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_Cull]
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _Cull;
		uniform float _NoiseIntensity;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float2 _PatternSize;
		uniform float _Slope;
		uniform float _BrickTiling;
		uniform float _BrickHeight;
		uniform sampler2D _InnerNormal;
		uniform float4 _InnerNormal_ST;
		uniform sampler2D _BrickNormal;
		uniform float4 _BrickNormal_ST;
		uniform sampler2D _InnerAlbedo;
		uniform float4 _InnerAlbedo_ST;
		uniform sampler2D _BrickAlbedo;
		uniform float4 _BrickAlbedo_ST;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _TessPhongStrength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_Noise = v.texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 temp_output_27_0 = ( float2( 0.5,0.5 ) - ( _PatternSize * 0.5 ) );
			float2 temp_output_6_0 = ( _BrickTiling * v.texcoord.xy );
			float temp_output_10_0 = (temp_output_6_0).y;
			float2 appendResult20 = (float2(( ( step( 1.0 , fmod( temp_output_10_0 , 2.0 ) ) * 0.5 ) + (temp_output_6_0).x ) , temp_output_10_0));
			float2 temp_output_17_0 = frac( appendResult20 );
			float2 smoothstepResult29 = smoothstep( temp_output_27_0 , ( temp_output_27_0 + _Slope ) , temp_output_17_0);
			float2 smoothstepResult32 = smoothstep( temp_output_27_0 , ( temp_output_27_0 + _Slope ) , ( 1.0 - temp_output_17_0 ));
			float2 temp_output_48_0 = ( smoothstepResult29 * smoothstepResult32 );
			float BoxValue65 = ( ( _NoiseIntensity * (tex2Dlod( _Noise, float4( uv_Noise, 0, 0.0) ).r*2.0 + -1.0) ) + ( (temp_output_48_0).x * (temp_output_48_0).y ) );
			v.vertex.xyz += ( ase_vertexNormal * BoxValue65 * _BrickHeight );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_InnerNormal = i.uv_texcoord * _InnerNormal_ST.xy + _InnerNormal_ST.zw;
			float2 uv_BrickNormal = i.uv_texcoord * _BrickNormal_ST.xy + _BrickNormal_ST.zw;
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 temp_output_27_0 = ( float2( 0.5,0.5 ) - ( _PatternSize * 0.5 ) );
			float2 temp_output_6_0 = ( _BrickTiling * i.uv_texcoord );
			float temp_output_10_0 = (temp_output_6_0).y;
			float2 appendResult20 = (float2(( ( step( 1.0 , fmod( temp_output_10_0 , 2.0 ) ) * 0.5 ) + (temp_output_6_0).x ) , temp_output_10_0));
			float2 temp_output_17_0 = frac( appendResult20 );
			float2 smoothstepResult29 = smoothstep( temp_output_27_0 , ( temp_output_27_0 + _Slope ) , temp_output_17_0);
			float2 smoothstepResult32 = smoothstep( temp_output_27_0 , ( temp_output_27_0 + _Slope ) , ( 1.0 - temp_output_17_0 ));
			float2 temp_output_48_0 = ( smoothstepResult29 * smoothstepResult32 );
			float BoxValue65 = ( ( _NoiseIntensity * (tex2D( _Noise, uv_Noise ).r*2.0 + -1.0) ) + ( (temp_output_48_0).x * (temp_output_48_0).y ) );
			float3 lerpResult55 = lerp( UnpackNormal( tex2D( _InnerNormal, uv_InnerNormal ) ) , UnpackNormal( tex2D( _BrickNormal, uv_BrickNormal ) ) , BoxValue65);
			o.Normal = UnpackNormal( float4( lerpResult55 , 0.0 ) );
			float2 uv_InnerAlbedo = i.uv_texcoord * _InnerAlbedo_ST.xy + _InnerAlbedo_ST.zw;
			float2 uv_BrickAlbedo = i.uv_texcoord * _BrickAlbedo_ST.xy + _BrickAlbedo_ST.zw;
			float4 lerpResult52 = lerp( tex2D( _InnerAlbedo, uv_InnerAlbedo ) , tex2D( _BrickAlbedo, uv_BrickAlbedo ) , BoxValue65);
			o.Albedo = lerpResult52.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;63;-2961.114,-165.6622;Inherit;False;3169.926;960.1747;Box Pattern;23;65;72;1;76;77;74;75;83;49;51;50;48;90;33;89;88;30;32;47;29;43;18;87;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-2897.039,-37.94015;Inherit;False;1667.097;336.1958;Brick Tile;16;17;84;85;20;22;15;7;9;10;16;14;11;12;6;5;2;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2820.357,32.48289;Float;False;Property;_BrickTiling;Brick Tiling;10;0;Create;True;0;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-2858.132,111.2049;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2633.132,87.60349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-2463.151,20.33275;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2407.139,127.0596;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2119.127,89.54697;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;7;-2255.739,115.0592;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;-1777.349,325.2432;Inherit;False;488.3132;307.9025;ScaledSize;4;27;28;3;25;;0,0,0,1;0;0
Node;AmplifyShaderEditor.StepOpNode;11;-1973.127,90.54697;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;22;-1575.754,63.40115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;14;-1842.128,90.54697;Inherit;False;0.5;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;16;-2457.93,203.9406;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;84;-1554.189,79.4017;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-1745.961,492.3773;Float;False;Property;_PatternSize;Pattern Size;8;0;Create;True;0;0;0;False;0;False;0,0;0.9,0.9;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1694.129,173.5468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;85;-1552.189,213.4016;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;25;-1753.201,375.2432;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleNode;28;-1579.674,499.1437;Inherit;False;0.5;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1502.129,171.5468;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1428.271,382.0934;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1526.724,656.9179;Float;False;Property;_Slope;Slope;6;0;Create;True;0;0;0;False;0;False;0.2;0.025;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;17;-1358.129,170.5469;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;88;-1099.286,415.256;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;47;-1208.994,533.8785;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1196.251,440.9966;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;89;-1083.286,435.2559;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1199.459,601.201;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;90;-1188.286,158.8195;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;29;-1033.627,360.676;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;32;-1035.243,475.7459;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-849.0321,368.1593;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-1032.288,181.5229;Float;False;Constant;_Float2;Float 2;11;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1028.65,111.8461;Float;False;Constant;_Float5;Float 5;9;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1182.218,-77.45734;Inherit;True;Property;_Noise;Noise;7;0;Create;True;0;0;0;False;0;False;-1;None;62695c15a49d430abd2ae1471c72b1c7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ComponentMaskNode;50;-676.686,366.2149;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;51;-678.1112,439.4114;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;74;-845.296,-50.91021;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-577.6346,-96.82584;Float;False;Property;_NoiseIntensity;Noise Intensity;9;0;Create;True;0;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-468.0406,395.687;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-289.8824,-74.65907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-143.8823,370.3409;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;224.7131,-171.2445;Inherit;False;790.6564;967.2255;Albedo+Normal based on pattern;9;68;58;52;55;57;56;66;53;54;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;82;558.8813,811.4237;Inherit;False;457.262;358.3835;Vertex Offset based on pattern;4;62;67;61;60;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-9.882339,367.3409;Float;False;BoxValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;273.6057,333.1258;Inherit;True;Property;_InnerNormal;Inner Normal;13;0;Create;True;0;0;0;False;0;False;-1;None;b91e3e42ac594b849bc5700ddfa92aa0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;57;274.6057,521.1262;Inherit;True;Property;_BrickNormal;Brick Normal;15;0;Create;True;0;0;0;False;0;False;-1;None;8ec217f770e34536be4d0dee12abb7a6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;68;397.7179,707.6033;Inherit;False;65;BoxValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;61;672.2355,861.4236;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;67;679.8813,997.1284;Inherit;False;65;BoxValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;581.0826,1068.807;Float;False;Property;_BrickHeight;Brick Height;11;0;Create;True;0;0;0;False;0;False;0;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;625.4622,499.8596;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;891.1438,858.9736;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;53;277.839,67.35526;Inherit;True;Property;_BrickAlbedo;Brick Albedo;14;0;Create;True;0;0;0;False;0;False;-1;None;f0325b098cd84bc1a847391f531b3007;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;66;400.1123,258.506;Inherit;False;65;BoxValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;58;795.4622,499.8596;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;93;1077.648,850.1359;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;54;278.1387,-121.2445;Inherit;True;Property;_InnerAlbedo;Inner Albedo;12;0;Create;True;0;0;0;False;0;False;-1;None;6633e66536f148a281a9fcaa7ef60863;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;52;631.6627,49.88497;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;91;1052.741,153.1041;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;92;1082.901,439.3321;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;94;1170.477,-27.43976;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1169.146,50.25999;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Procedural Wall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;0;12;10;25;True;1;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;2;0
WireConnection;6;1;5;0
WireConnection;10;0;6;0
WireConnection;7;0;10;0
WireConnection;7;1;9;0
WireConnection;11;0;12;0
WireConnection;11;1;7;0
WireConnection;22;0;10;0
WireConnection;14;0;11;0
WireConnection;16;0;6;0
WireConnection;84;0;22;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;85;0;84;0
WireConnection;28;0;3;0
WireConnection;20;0;15;0
WireConnection;20;1;85;0
WireConnection;27;0;25;0
WireConnection;27;1;28;0
WireConnection;17;0;20;0
WireConnection;88;0;27;0
WireConnection;47;0;17;0
WireConnection;30;0;27;0
WireConnection;30;1;43;0
WireConnection;89;0;88;0
WireConnection;33;0;27;0
WireConnection;33;1;43;0
WireConnection;90;0;17;0
WireConnection;29;0;90;0
WireConnection;29;1;27;0
WireConnection;29;2;30;0
WireConnection;32;0;47;0
WireConnection;32;1;89;0
WireConnection;32;2;33;0
WireConnection;48;0;29;0
WireConnection;48;1;32;0
WireConnection;50;0;48;0
WireConnection;51;0;48;0
WireConnection;74;0;1;1
WireConnection;74;1;75;0
WireConnection;74;2;83;0
WireConnection;49;0;50;0
WireConnection;49;1;51;0
WireConnection;76;0;77;0
WireConnection;76;1;74;0
WireConnection;72;0;76;0
WireConnection;72;1;49;0
WireConnection;65;0;72;0
WireConnection;55;0;56;0
WireConnection;55;1;57;0
WireConnection;55;2;68;0
WireConnection;60;0;61;0
WireConnection;60;1;67;0
WireConnection;60;2;62;0
WireConnection;58;0;55;0
WireConnection;93;0;60;0
WireConnection;52;0;54;0
WireConnection;52;1;53;0
WireConnection;52;2;66;0
WireConnection;91;0;58;0
WireConnection;92;0;93;0
WireConnection;0;0;52;0
WireConnection;0;1;91;0
WireConnection;0;11;92;0
ASEEND*/
//CHKSM=486C7CC453ABA305075819820C01D2E9637F5143