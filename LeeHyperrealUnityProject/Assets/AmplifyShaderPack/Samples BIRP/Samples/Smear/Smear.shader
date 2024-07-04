// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Smear"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Normal("Normal", 2D) = "bump" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_NoiseInfluence("Noise Influence", Range( 0 , 1)) = 0.5
		_NoiseHeightScale("Noise Height Scale", Range( 0 , 1)) = 0
		_NoiseTilling("Noise Tilling", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma exclude_renderers xboxseries playstation switch 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _NoiseTilling;
		uniform float _NoiseHeightScale;
		uniform float _NoiseInfluence;
		uniform float3 _Position;
		uniform float3 _PrevPosition;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Tint;
		uniform float _Metallic;
		uniform float _Smoothness;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float simplePerlin3D6 = snoise( ( ase_worldPos * _NoiseTilling ) );
			float lerpResult50 = lerp( 1.0 , ( 1.0 - ( simplePerlin3D6 * _NoiseHeightScale ) ) , _NoiseInfluence);
			float3 worldOffset30 = ( _Position - _PrevPosition );
			float3 normalizeResult8 = normalize( worldOffset30 );
			float3 localOffset31 = ( ase_worldPos - _Position );
			float3 normalizeResult9 = normalize( localOffset31 );
			float dotResult7 = dot( normalizeResult8 , normalizeResult9 );
			float smearDirection29 = dotResult7;
			float clampResult17 = clamp( smearDirection29 , -1.0 , 0.0 );
			float lerpResult18 = lerp( 1.0 , 0.0 , step( length( worldOffset30 ) , 0.0 ));
			float3 temp_cast_0 = (-1.0).xxx;
			float3 temp_cast_1 = (1.0).xxx;
			float3 clampResult32 = clamp( worldOffset30 , temp_cast_0 , temp_cast_1 );
			float3 finalVertexWorldPosition80 = ( ( lerpResult50 * -( ( -clampResult17 * lerpResult18 ) * clampResult32 ) ) + ase_worldPos );
			float3 worldToObj82 = mul( unity_WorldToObject, float4( finalVertexWorldPosition80, 1 ) ).xyz;
			v.vertex.xyz = worldToObj82;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = ( tex2D( _Albedo, uv_Albedo ) * _Tint ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;64;-1066.302,426.0999;Inherit;False;2542.91;626.3097;Use the difference from the current position to the previous to calculate the direction of the movement per vertex and bulge the "back" side of the model;20;44;35;14;32;21;34;33;18;20;17;19;29;7;9;8;30;31;5;11;10;Directional Bulge;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;62;-1698.862,214.1362;Inherit;False;262;403.7;Fed by a script;2;4;3;Global Vars;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;10;-1021.402,700.1005;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;3;-1648.862,433.8364;Float;False;Global;_PrevPosition;_PrevPosition;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;4;-1648.463,264.136;Float;False;Global;_Position;_Position;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-709.5005,611.8008;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;-713.6005,476.0999;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-540.4706,614.7126;Float;False;localOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-546.9704,482.3116;Float;False;worldOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;8;-213.6,489.5999;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;9;-208.6,593.3997;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;61;154.8572,-74.29308;Inherit;False;1328.2;369.5004;;9;49;52;6;60;51;58;59;50;55;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;7;29.80008,523.5001;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;49;204.8571,-24.29301;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;207.8894,541.513;Float;False;smearDirection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;238.3569,136.3071;Float;False;Property;_NoiseTilling;Noise Tilling;7;0;Create;True;0;0;0;False;0;False;5;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;19;-204.571,702.4123;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;20;44.20221,702.637;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;470.5566,11.40698;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;17;507.0296,519.3044;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;590.5559,120.4073;Float;False;Property;_NoiseHeightScale;Noise Height Scale;6;0;Create;True;0;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;686.6266,17.59553;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;1,1,1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-459.1702,824.5119;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;21;721.928,569.3127;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-459.7704,919.2119;Float;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;519.0634,655.2789;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;897.3571,25.50743;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;32;-228.0704,811.5126;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;887.1987,625.0007;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;1070.257,59.30745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;962.3575,169.0076;Float;False;Property;_NoiseInfluence;Noise Influence;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1088.226,784.013;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;44;1253.527,803.6124;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;50;1299.058,88.50768;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;65;1722.855,498.3999;Inherit;False;1166.783;452.0805;Add the bulge to the final position and convert the result to object space;5;80;39;40;48;82;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1792.329,625.2115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;40;1772.855,776.8003;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;39;1987.251,664.8444;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;2150.42,708.4609;Float;False;finalVertexWorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;67;2593.904,-245.8486;Float;False;Property;_Tint;Tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.7363322,0.470588,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;79;1721.318,153.161;Inherit;False;573.5995;302.0001;You can also mask the effect (ie: thicker areas smear less);2;77;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;66;2507.804,-468.8487;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;aab8de1052c54173b3d61e7f8b05aedf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TransformPositionNode;82;2656.68,690.056;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;2519.104,-48.44893;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;71;2571.201,260.3512;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0;0.372;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;2572.001,163.9511;Float;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;0;False;0;False;0;0.235;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;1771.318,203.1611;Inherit;True;Property;_SmearMask;Smear Mask;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;2901.904,-309.6486;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;2108.319,326.9612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3186.198,217.7999;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Smear;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;9;d3d11;glcore;gles;gles3;metal;vulkan;xboxone;ps4;ps5;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;20;True;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;0
WireConnection;11;1;4;0
WireConnection;5;0;4;0
WireConnection;5;1;3;0
WireConnection;31;0;11;0
WireConnection;30;0;5;0
WireConnection;8;0;30;0
WireConnection;9;0;31;0
WireConnection;7;0;8;0
WireConnection;7;1;9;0
WireConnection;29;0;7;0
WireConnection;19;0;30;0
WireConnection;20;0;19;0
WireConnection;52;0;49;0
WireConnection;52;1;51;0
WireConnection;17;0;29;0
WireConnection;6;0;52;0
WireConnection;21;0;17;0
WireConnection;18;2;20;0
WireConnection;60;0;6;0
WireConnection;60;1;58;0
WireConnection;32;0;30;0
WireConnection;32;1;33;0
WireConnection;32;2;34;0
WireConnection;14;0;21;0
WireConnection;14;1;18;0
WireConnection;59;0;60;0
WireConnection;35;0;14;0
WireConnection;35;1;32;0
WireConnection;44;0;35;0
WireConnection;50;1;59;0
WireConnection;50;2;55;0
WireConnection;48;0;50;0
WireConnection;48;1;44;0
WireConnection;39;0;48;0
WireConnection;39;1;40;0
WireConnection;80;0;39;0
WireConnection;82;0;80;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;77;0;78;1
WireConnection;0;0;68;0
WireConnection;0;1;69;0
WireConnection;0;3;70;0
WireConnection;0;4;71;0
WireConnection;0;11;82;0
ASEEND*/
//CHKSM=47727A76E39D2526BAE96B5A7EEFF9BAB2A358F1