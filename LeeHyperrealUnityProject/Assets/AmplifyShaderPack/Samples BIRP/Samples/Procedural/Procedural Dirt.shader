// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Procedural Dirt"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_ConcreteTint("Concrete Tint", Color) = (1,1,1,0)
		_BaseAlbedo("Base Albedo", 2D) = "white" {}
		_BaseNormal("Base Normal", 2D) = "bump" {}
		_ConcreteNormalIntensity("Concrete Normal Intensity", Range( 0 , 2)) = 0
		_BaseSmoothnessMix("Base Smoothness Mix", 2D) = "white" {}
		_ConcreteSmoothnessIntensity("Concrete Smoothness Intensity", Range( 0 , 5)) = 0
		_SmoothnessAOBase("Smoothness AO Base", 2D) = "white" {}
		_BaseDisplacement("Base Displacement", 2D) = "white" {}
		_ConcreteDisplacement("Concrete Displacement", Range( 0 , 2)) = 0
		_DirtTint("Dirt Tint", Color) = (0,0,0,0)
		_TopAlbedo("Top Albedo", 2D) = "white" {}
		_TopNormal("Top Normal", 2D) = "bump" {}
		_DirtNormalIntensity("Dirt Normal Intensity", Range( 0 , 2)) = 1
		_TopSmoothnessAO("Top Smoothness AO", 2D) = "white" {}
		_DirtSmoothnessIntensity("Dirt Smoothness Intensity", Range( 0 , 2)) = 0
		_TopDisplacement("Top Displacement", 2D) = "white" {}
		_DirtDisplacement("Dirt Displacement", Range( 0 , 2)) = 0
		_Rotation("Rotation", Range( 0 , 360)) = 0
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_Offset("Offset", Vector) = (0,0,0,0)
		_MaskGain("Mask Gain", Float) = 0
		_MaskDetailScale("Mask Detail Scale", Float) = 20.33
		_MaskShapeScale("Mask Shape Scale", Float) = 20.33
		_MaskConstrast("Mask Constrast", Float) = 0
		_BlendStrength("Blend Strength", Float) = 12.42
		_NoiseTileX("Noise Tile X", Range( 0 , 10)) = 1
		_NoiseTileY("Noise Tile Y", Range( 0 , 10)) = 1
		_NoiseoffsetX("Noise offset X", Range( 0 , 10)) = 1
		_NoiseoffsetY("Noise offset Y", Range( 0 , 10)) = 1
		_MaskTilingX("Mask Tiling X", Range( 0 , 10)) = -0.5
		_MaskTilingY("Mask Tiling Y", Range( 0 , 10)) = -0.53
		_MaskPositionX("Mask Position X", Range( -1 , 1)) = -0.5
		_MaskPositionY("Mask Position Y", Range( -1 , 1)) = -0.53
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TopDisplacement;
		uniform float2 _Tiling;
		uniform float2 _Offset;
		uniform float _Rotation;
		uniform float _DirtDisplacement;
		uniform sampler2D _BaseDisplacement;
		uniform float4 _BaseDisplacement_ST;
		uniform float _ConcreteDisplacement;
		uniform float _MaskShapeScale;
		uniform float _NoiseTileX;
		uniform float _NoiseTileY;
		uniform float _NoiseoffsetX;
		uniform float _NoiseoffsetY;
		uniform float _MaskDetailScale;
		uniform float _MaskTilingX;
		uniform float _MaskTilingY;
		uniform float _MaskPositionX;
		uniform float _MaskPositionY;
		uniform float _MaskGain;
		uniform float _MaskConstrast;
		uniform float _BlendStrength;
		uniform sampler2D _TopNormal;
		uniform float _DirtNormalIntensity;
		uniform sampler2D _BaseNormal;
		uniform float4 _BaseNormal_ST;
		uniform float _ConcreteNormalIntensity;
		uniform float4 _DirtTint;
		uniform sampler2D _TopAlbedo;
		uniform float4 _ConcreteTint;
		uniform sampler2D _BaseAlbedo;
		uniform float4 _BaseAlbedo_ST;
		uniform sampler2D _TopSmoothnessAO;
		uniform float _DirtSmoothnessIntensity;
		uniform sampler2D _BaseSmoothnessMix;
		uniform float4 _BaseSmoothnessMix_ST;
		uniform float _ConcreteSmoothnessIntensity;
		uniform sampler2D _SmoothnessAOBase;
		uniform float4 _SmoothnessAOBase_ST;
		uniform float _EdgeLength;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_TexCoord16 = v.texcoord.xy * _Tiling + _Offset;
			float cos17 = cos( radians( _Rotation ) );
			float sin17 = sin( radians( _Rotation ) );
			float2 rotator17 = mul( uv_TexCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
			float2 UVManipulation97 = rotator17;
			float4 temp_cast_0 = (0.16).xxxx;
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_BaseDisplacement = v.texcoord * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
			float4 temp_cast_2 = (0.16).xxxx;
			float simpleNoise218 = SimpleNoise( v.texcoord.xy*_MaskShapeScale );
			float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
			float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
			float2 uv_TexCoord147 = v.texcoord.xy * appendResult204.xy + appendResult211.xy;
			float simpleNoise146 = SimpleNoise( uv_TexCoord147*_MaskDetailScale );
			float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
			float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
			float2 uv_TexCoord41 = v.texcoord.xy * appendResult210.xy + appendResult207.xy;
			float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate( (0.0 + (abs( length( uv_TexCoord41 ) ) - _MaskGain) * (1.0 - 0.0) / (_MaskConstrast - _MaskGain)) ) ))*4)+(abs( saturate( (0.0 + (abs( length( uv_TexCoord41 ) ) - _MaskGain) * (1.0 - 0.0) / (_MaskConstrast - _MaskGain)) ) )*2),_BlendStrength));
			float DirtMask94 = saturate( HeightMask163 );
			float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( ase_vertexNormal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( ase_vertexNormal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
			v.vertex.xyz += lerpResult141.rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord16 = i.uv_texcoord * _Tiling + _Offset;
			float cos17 = cos( radians( _Rotation ) );
			float sin17 = sin( radians( _Rotation ) );
			float2 rotator17 = mul( uv_TexCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
			float2 UVManipulation97 = rotator17;
			float2 uv_BaseNormal = i.uv_texcoord * _BaseNormal_ST.xy + _BaseNormal_ST.zw;
			float simpleNoise218 = SimpleNoise( i.uv_texcoord*_MaskShapeScale );
			float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
			float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
			float2 uv_TexCoord147 = i.uv_texcoord * appendResult204.xy + appendResult211.xy;
			float simpleNoise146 = SimpleNoise( uv_TexCoord147*_MaskDetailScale );
			float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
			float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
			float2 uv_TexCoord41 = i.uv_texcoord * appendResult210.xy + appendResult207.xy;
			float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate( (0.0 + (abs( length( uv_TexCoord41 ) ) - _MaskGain) * (1.0 - 0.0) / (_MaskConstrast - _MaskGain)) ) ))*4)+(abs( saturate( (0.0 + (abs( length( uv_TexCoord41 ) ) - _MaskGain) * (1.0 - 0.0) / (_MaskConstrast - _MaskGain)) ) )*2),_BlendStrength));
			float DirtMask94 = saturate( HeightMask163 );
			float3 lerpResult103 = lerp( UnpackScaleNormal( tex2D( _TopNormal, UVManipulation97 ), _DirtNormalIntensity ) , UnpackScaleNormal( tex2D( _BaseNormal, uv_BaseNormal ), _ConcreteNormalIntensity ) , DirtMask94);
			float3 normalizeResult105 = normalize( lerpResult103 );
			o.Normal = normalizeResult105;
			float2 uv_BaseAlbedo = i.uv_texcoord * _BaseAlbedo_ST.xy + _BaseAlbedo_ST.zw;
			float4 lerpResult93 = lerp( ( _DirtTint * tex2D( _TopAlbedo, UVManipulation97 ) ) , ( _ConcreteTint * tex2D( _BaseAlbedo, uv_BaseAlbedo ) ) , DirtMask94);
			o.Albedo = lerpResult93.rgb;
			float4 tex2DNode221 = tex2D( _TopSmoothnessAO, UVManipulation97 );
			float2 uv_BaseSmoothnessMix = i.uv_texcoord * _BaseSmoothnessMix_ST.xy + _BaseSmoothnessMix_ST.zw;
			float lerpResult107 = lerp( ( tex2DNode221.r * _DirtSmoothnessIntensity ) , ( tex2D( _BaseSmoothnessMix, uv_BaseSmoothnessMix ).r * _ConcreteSmoothnessIntensity ) , DirtMask94);
			o.Smoothness = lerpResult107;
			float2 uv_SmoothnessAOBase = i.uv_texcoord * _SmoothnessAOBase_ST.xy + _SmoothnessAOBase_ST.zw;
			float lerpResult109 = lerp( tex2DNode221.g , tex2D( _SmoothnessAOBase, uv_SmoothnessAOBase ).g , DirtMask94);
			o.Occlusion = lerpResult109;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;154;-5018.101,-1775.289;Inherit;False;3268.632;1540.805;;32;94;199;163;214;215;164;146;176;148;147;175;181;211;174;173;204;202;213;212;203;42;41;210;207;209;206;205;208;216;217;218;219;Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;209;-4823.639,-811.7718;Inherit;False;Property;_MaskTilingY;Mask Tiling Y;35;0;Create;True;0;0;0;False;0;False;-0.53;1.65;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-4823.208,-892.7173;Inherit;False;Property;_MaskTilingX;Mask Tiling X;34;0;Create;True;0;0;0;False;0;False;-0.5;0.95;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-4808.754,-703.4656;Inherit;False;Property;_MaskPositionX;Mask Position X;36;0;Create;True;0;0;0;False;0;False;-0.5;-0.478;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-4812.641,-620.5048;Inherit;False;Property;_MaskPositionY;Mask Position Y;37;0;Create;True;0;0;0;False;0;False;-0.53;-0.865;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;210;-4512.165,-865.9325;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;207;-4505.197,-682.7255;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-4341.742,-1044.133;Inherit;False;Property;_NoiseoffsetX;Noise offset X;32;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-4276.965,-808.2484;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;202;-4346.444,-1221.506;Inherit;False;Property;_NoiseTileX;Noise Tile X;30;0;Create;True;0;0;0;False;0;False;1;1.69;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-4343.592,-1142.666;Inherit;False;Property;_NoiseTileY;Noise Tile Y;31;0;Create;True;0;0;0;False;0;False;1;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-4338.89,-965.2939;Inherit;False;Property;_NoiseoffsetY;Noise offset Y;33;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;42;-3983.321,-806.2738;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;211;-3987.47,-1017.628;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;204;-3992.172,-1195.001;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;216;-3767.737,-1423.248;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;155;-3091.992,698.2906;Inherit;False;1172.656;565.6147;Comment;8;97;17;15;16;14;11;12;13;UVManipulation;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;181;-3747.243,-803.5353;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;-3758.544,-1132.55;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;174;-3702.34,-501.4245;Inherit;False;Property;_MaskConstrast;Mask Constrast;28;0;Create;True;0;0;0;False;0;False;0;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-3708.772,-1004.985;Inherit;False;Property;_MaskDetailScale;Mask Detail Scale;26;0;Create;True;0;0;0;False;0;False;20.33;445.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-3704.092,-581.5981;Inherit;False;Property;_MaskGain;Mask Gain;25;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-3735.83,-1279.988;Inherit;False;Property;_MaskShapeScale;Mask Shape Scale;27;0;Create;True;0;0;0;False;0;False;20.33;42.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;218;-3508.308,-1390.754;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;175;-3433.021,-805.9408;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;146;-3469.47,-1097.361;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2945.255,1118.733;Inherit;False;Property;_Rotation;Rotation;22;0;Create;True;0;0;0;False;0;False;0;93.8;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;12;-2962.306,783.9305;Inherit;False;Property;_Tiling;Tiling;23;0;Create;True;0;0;0;False;0;False;0,0;8,8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;13;-2963.856,935.8307;Inherit;False;Property;_Offset;Offset;24;0;Create;True;0;0;0;False;0;False;0,0;1.2,-1.16;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-3204.561,-1230.563;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;176;-3103.269,-805.972;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;15;-2604.252,1121.833;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-2699.693,834.2204;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-2632.152,983.8803;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;215;-2898.133,-807.1904;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;214;-2961.729,-1093.432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-3114.492,-567.5173;Inherit;False;Property;_BlendStrength;Blend Strength;29;0;Create;True;0;0;0;False;0;False;12.42;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;17;-2413.621,962.3356;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;159;-2323.128,1415.839;Inherit;False;1903.4;756.8439;Comment;15;102;133;19;136;139;138;26;137;24;25;142;29;140;141;222;Displacement;1,1,1,1;0;0
Node;AmplifyShaderEditor.HeightMapBlendNode;163;-2722.756,-832.2081;Inherit;True;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2184.177,958.171;Inherit;False;UVManipulation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;158;-1624.268,347.4995;Inherit;False;1066.73;919.4935;Comment;11;101;22;86;85;108;30;89;91;109;107;221;Smoothness AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-1922.626,1489.443;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;199;-2385.87,-831.9152;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;157;-3148.413,-68.5793;Inherit;False;1242.905;635.3945;Comment;8;100;27;88;92;103;105;106;223;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;156;-1645.482,-643.9425;Inherit;False;1428.41;767.9967;Comment;9;99;23;87;84;96;31;90;93;220;Diffuse;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-3087.478,80.98169;Inherit;False;Property;_DirtNormalIntensity;Dirt Normal Intensity;17;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-3092.233,293.3958;Inherit;False;Property;_ConcreteNormalIntensity;Concrete Normal Intensity;8;0;Create;True;0;0;0;False;0;False;0;0.793;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-3027.828,-18.57928;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1603.002,-360.6579;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;222;-1668.23,1466.162;Inherit;True;Property;_TopDisplacement;Top Displacement;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-2178.54,-836.4619;Inherit;False;DirtMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-1925.267,1819.369;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;133;-2299.836,1735.416;Inherit;True;Property;_BaseDisplacement;Base Displacement;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;101;-1553.994,612.0929;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1362.033,1547.871;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;139;-1743.931,1740.638;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-1186.695,1467.08;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;137;-1982.814,1979.332;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;84;-1095.908,-105.9455;Inherit;True;Property;_BaseAlbedo;Base Albedo;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;85;-1339.768,938.6093;Inherit;True;Property;_BaseSmoothnessMix;Base Smoothness Mix;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;138;-1790.267,2056.682;Float;False;Property;_ConcreteDisplacement;Concrete Displacement;13;0;Create;True;0;0;0;False;0;False;0;0.048;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;24;-1425.578,1707.834;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;-1019.563,-287.159;Inherit;False;Property;_ConcreteTint;Concrete Tint;5;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;23;-1314.51,-593.9422;Inherit;False;Property;_DirtTint;Dirt Tint;14;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.9056604,0.8656673,0.6707013,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;220;-1345.901,-386.9845;Inherit;True;Property;_TopAlbedo;Top Albedo;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;223;-2771.301,0.8844757;Inherit;True;Property;_TopNormal;Top Normal;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;92;-2758.038,246.7007;Inherit;True;Property;_BaseNormal;Base Normal;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;106;-2633.919,450.8155;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1362.563,1146.994;Inherit;False;Property;_ConcreteSmoothnessIntensity;Concrete Smoothness Intensity;10;0;Create;True;0;0;0;False;0;False;0;1.82;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1280.404,838.6312;Inherit;False;Property;_DirtSmoothnessIntensity;Dirt Smoothness Intensity;19;0;Create;True;0;0;0;False;0;False;0;0.92;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;221;-1342.352,585.2834;Inherit;True;Property;_TopSmoothnessAO;Top Smoothness AO;18;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;26;-1209.789,1775.897;Float;False;Property;_DirtDisplacement;Dirt Displacement;21;0;Create;True;0;0;0;False;0;False;0;0.425;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-864.2493,1951.121;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1420.571,1956.777;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-714.7032,-281.6397;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-728.5899,-409.8623;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-727.2669,-137.3801;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;91;-1338.983,397.4994;Inherit;True;Property;_SmoothnessAOBase;Smoothness AO Base;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-931.9745,787.0861;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;103;-2313.208,191.426;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1008.839,956.5584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-863.3362,1685.279;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-980.194,1077.941;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;105;-2080.508,190.0555;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;93;-482.0733,-323.4037;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;109;-739.5387,507.1312;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;141;-601.7291,1763.037;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;107;-742.1283,876.0302;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;230;331.9753,168.96;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Procedural Dirt;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;210;0;208;0
WireConnection;210;1;209;0
WireConnection;207;0;205;0
WireConnection;207;1;206;0
WireConnection;41;0;210;0
WireConnection;41;1;207;0
WireConnection;42;0;41;0
WireConnection;211;0;212;0
WireConnection;211;1;213;0
WireConnection;204;0;202;0
WireConnection;204;1;203;0
WireConnection;181;0;42;0
WireConnection;147;0;204;0
WireConnection;147;1;211;0
WireConnection;218;0;216;0
WireConnection;218;1;217;0
WireConnection;175;0;181;0
WireConnection;175;1;173;0
WireConnection;175;2;174;0
WireConnection;146;0;147;0
WireConnection;146;1;148;0
WireConnection;219;0;218;0
WireConnection;219;1;146;0
WireConnection;176;0;175;0
WireConnection;15;0;11;0
WireConnection;16;0;12;0
WireConnection;16;1;13;0
WireConnection;215;0;176;0
WireConnection;214;0;219;0
WireConnection;17;0;16;0
WireConnection;17;1;14;0
WireConnection;17;2;15;0
WireConnection;163;0;214;0
WireConnection;163;1;215;0
WireConnection;163;2;164;0
WireConnection;97;0;17;0
WireConnection;199;0;163;0
WireConnection;222;1;102;0
WireConnection;94;0;199;0
WireConnection;139;0;133;0
WireConnection;139;1;136;0
WireConnection;25;0;222;0
WireConnection;25;1;19;0
WireConnection;220;1;99;0
WireConnection;223;1;100;0
WireConnection;223;5;27;0
WireConnection;92;5;88;0
WireConnection;221;1;101;0
WireConnection;140;0;139;0
WireConnection;140;1;137;0
WireConnection;140;2;138;0
WireConnection;90;0;87;0
WireConnection;90;1;84;0
WireConnection;31;0;23;0
WireConnection;31;1;220;0
WireConnection;30;0;221;1
WireConnection;30;1;22;0
WireConnection;103;0;223;0
WireConnection;103;1;92;0
WireConnection;103;2;106;0
WireConnection;89;0;85;1
WireConnection;89;1;86;0
WireConnection;29;0;25;0
WireConnection;29;1;24;0
WireConnection;29;2;26;0
WireConnection;105;0;103;0
WireConnection;93;0;31;0
WireConnection;93;1;90;0
WireConnection;93;2;96;0
WireConnection;109;0;221;2
WireConnection;109;1;91;2
WireConnection;109;2;108;0
WireConnection;141;0;29;0
WireConnection;141;1;140;0
WireConnection;141;2;142;0
WireConnection;107;0;30;0
WireConnection;107;1;89;0
WireConnection;107;2;108;0
WireConnection;230;0;93;0
WireConnection;230;1;105;0
WireConnection;230;4;107;0
WireConnection;230;5;109;0
WireConnection;230;11;141;0
ASEEND*/
//CHKSM=0A84715ABDBBFF0CBEFBFA7A126185CAEC82B651