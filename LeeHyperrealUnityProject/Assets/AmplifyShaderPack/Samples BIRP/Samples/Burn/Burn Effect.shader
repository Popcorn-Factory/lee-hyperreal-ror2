// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Burn Effect"
{
	Properties
	{
		_AlbedoMix("Albedo Mix", Range( 0 , 1)) = 0.5
		_CharcoalMix("Charcoal Mix", Range( 0 , 1)) = 1
		_EmberColorTint("Ember Color Tint", Color) = (0.9926471,0.6777384,0,1)
		_Albedo("Albedo", 2D) = "white" {}
		_Normals("Normals", 2D) = "bump" {}
		_BaseEmber("Base Ember", Range( 0 , 1)) = 0
		_GlowEmissionMultiplier("Glow Emission Multiplier", Range( 0 , 30)) = 1
		_GlowColorIntensity("Glow Color Intensity", Range( 0 , 10)) = 0
		_BurnOffset("Burn Offset", Range( 0 , 5)) = 1
		_CharcoalNormalTile("Charcoal Normal Tile", Range( 2 , 5)) = 5
		_BurnTilling("Burn Tilling", Range( 0.1 , 1)) = 1
		_GlowBaseFrequency("Glow Base Frequency", Range( 0 , 5)) = 1.1
		_GlowOverride("Glow Override", Range( 0 , 10)) = 1
		_Masks("Masks", 2D) = "white" {}
		_BurntTileNormals("Burnt Tile Normals", 2D) = "white" {}
		_Smoothness("Smoothness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		ZTest LEqual
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normals;
		uniform sampler2D _BurntTileNormals;
		uniform float _CharcoalNormalTile;
		uniform float _CharcoalMix;
		uniform sampler2D _Masks;
		uniform float _BurnOffset;
		uniform float _BurnTilling;
		uniform sampler2D _Albedo;
		uniform float _AlbedoMix;
		uniform float _BaseEmber;
		uniform float4 _EmberColorTint;
		uniform float _GlowColorIntensity;
		uniform float _GlowBaseFrequency;
		uniform float _GlowOverride;
		uniform float _GlowEmissionMultiplier;
		uniform half _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			half4 tex2DNode83 = tex2D( _BurntTileNormals, ( i.uv_texcoord * _CharcoalNormalTile ) );
			half4 appendResult182 = (half4(1.0 , tex2DNode83.g , 0.0 , tex2DNode83.r));
			half2 panner9 = ( _BurnOffset * float2( 1,0.5 ) + ( i.uv_texcoord * _BurnTilling ));
			half4 tex2DNode98 = tex2D( _Masks, panner9 );
			half MaskR194 = tex2DNode98.r;
			half temp_output_19_0 = ( _CharcoalMix + MaskR194 );
			half3 lerpResult103 = lerp( UnpackNormal( tex2D( _Normals, i.uv_texcoord ) ) , UnpackNormal( appendResult182 ) , temp_output_19_0);
			half3 Normal188 = lerpResult103;
			o.Normal = Normal188;
			half4 tex2DNode80 = tex2D( _Albedo, i.uv_texcoord );
			half4 temp_cast_0 = (0.0).xxxx;
			half4 lerpResult28 = lerp( ( tex2DNode80 * _AlbedoMix ) , temp_cast_0 , temp_output_19_0);
			half BurntA209 = tex2DNode83.a;
			half MaskG200 = tex2DNode98.g;
			half4 lerpResult148 = lerp( ( float4(0.718,0.0627451,0,1) * ( BurntA209 * 2.95 ) ) , ( float4(0.647,0.06297875,0,1) * ( BurntA209 * 4.2 ) ) , MaskG200);
			half4 lerpResult152 = lerp( lerpResult28 , ( ( lerpResult148 * MaskR194 ) * _BaseEmber ) , ( MaskR194 * 1.0 ));
			half4 BaseColor186 = lerpResult152;
			o.Albedo = BaseColor186.rgb;
			half4 temp_cast_2 = (0.0).xxxx;
			half4 temp_cast_3 = (100.0).xxxx;
			half4 clampResult176 = clamp( ( ( MaskR194 * ( ( ( ( _EmberColorTint * _GlowColorIntensity ) * ( ( sin( ( _Time.y * _GlowBaseFrequency ) ) * 0.5 ) + ( _GlowOverride * ( MaskR194 * BurntA209 ) ) ) ) * MaskG200 ) * BurntA209 ) ) * _GlowEmissionMultiplier ) , temp_cast_2 , temp_cast_3 );
			half4 Emission190 = clampResult176;
			o.Emission = Emission190.rgb;
			half Smoothness192 = ( tex2DNode80.a * _Smoothness );
			o.Smoothness = Smoothness192;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.TextureCoordinatesNode;179;-2864,-368;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;180;-2896,-960;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;219;-2624,-256;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;203;-2656,-896;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;220;-2624,-96;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2864,-16;Float;False;Property;_CharcoalNormalTile;Charcoal Normal Tile;9;0;Create;True;0;0;0;False;0;False;5;2;2;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;204;-2656,-624;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2880,-560;Float;False;Property;_BurnTilling;Burn Tilling;10;0;Create;True;0;0;0;False;0;False;1;0.484;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-2560,-96;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2576,-624;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2688,-464;Float;False;Property;_BurnOffset;Burn Offset;8;0;Create;True;0;0;0;False;0;False;1;0.22;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;83;-2176,-128;Inherit;True;Property;_BurntTileNormals;Burnt Tile Normals;14;0;Create;True;0;0;0;False;0;False;-1;None;2fb1b14b4e2147e4a580f44624c73725;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PannerNode;9;-2384,-624;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;209;-1856,32;Inherit;False;BurntA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;98;-2176,-640;Inherit;True;Property;_Masks;Masks;13;0;Create;True;0;0;0;False;0;False;-1;None;21b9f4e0af3140a99ef0bc5a43d58a97;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;212;-1344,-1168;Inherit;False;209;BurntA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-1424,-1088;Float;False;Constant;_R2;R2;-1;0;Create;True;0;0;0;False;0;False;4.2;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-1872,-640;Inherit;False;MaskR;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-1056,-1168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;134;-1120,-1344;Float;False;Constant;_ColorNode39134;ColorNode 39 134;-1;0;Create;True;0;0;0;False;0;False;0.647,0.06297875,0,1;0,0,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TimeNode;67;-2576,576;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-2640,720;Float;False;Property;_GlowBaseFrequency;Glow Base Frequency;11;0;Create;True;0;0;0;False;0;False;1.1;2.35;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-864,-1344;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2320,592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-2352,896;Inherit;False;194;MaskR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-2304,976;Inherit;False;209;BurntA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;-1344,-1456;Inherit;False;209;BurntA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1440,-1376;Float;False;Constant;_R2144;R2 144;-1;0;Create;True;0;0;0;False;0;False;2.95;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;216;-714.8248,-1349.196;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinOpNode;66;-2160,592;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2192,704;Float;False;Constant;_GlowDuration;Glow Duration;-1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-2160,896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-2640,800;Float;False;Property;_GlowOverride;Glow Override;12;0;Create;True;0;0;0;False;0;False;1;1.07;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-1872,-544;Inherit;False;MaskG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;147;-1152,-1616;Float;False;Constant;_ColorNode39134147;ColorNode39134 147;-1;0;Create;True;0;0;0;False;0;False;0.718,0.0627451,0,1;0,0,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-1056,-1456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;217;-704,-1520;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-2000,800;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2000,592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2624,480;Float;False;Property;_GlowColorIntensity;Glow Color Intensity;7;0;Create;True;0;0;0;False;0;False;0;3.66;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;73;-2560,304;Float;False;Property;_EmberColorTint;Ember Color Tint;2;0;Create;True;0;0;0;False;0;False;0.9926471,0.6777384,0,1;0.966,0.1062517,0.004325263,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-864,-1616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;218;-672,-1552;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-640,-1520;Inherit;False;200;MaskG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;174;-1840,592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2288,304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;148;-464,-1616;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-320,-1520;Inherit;False;194;MaskR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-1968,-208;Float;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1696,304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;-1696,416;Inherit;False;200;MaskG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;129;-1156.004,-768;Inherit;False;414.0976;218.5289;Mix Base Albedo;3;19;13;198;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-144,-1616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-256,-1424;Float;False;Property;_BaseEmber;Base Ember;5;0;Create;True;0;0;0;False;0;False;0;0.371;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;-1808,-128;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1488,304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;-1472,416;Inherit;False;209;BurntA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-2176,-992;Inherit;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;0;False;0;False;-1;None;85e3723e62d44f758723754190c67911;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;35;-1408,-912;Float;False;Property;_AlbedoMix;Albedo Mix;0;0;Create;True;0;0;0;False;0;False;0.5;0.356;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-1040,-640;Inherit;False;194;MaskR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1136,-720;Float;False;Property;_CharcoalMix;Charcoal Mix;1;0;Create;True;0;0;0;False;0;False;1;0.713;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;64,-1616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;181;-976,-128;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1248,304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-1280,224;Inherit;False;194;MaskR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1104,-992;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-944,-896;Float;False;Constant;_RangedFloatNode27;_RangedFloatNode27;-1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;207;240,-1536;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-64,-896;Inherit;False;194;MaskR;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-160,-816;Float;False;Constant;_RangedFloatNode156;RangedFloatNode 156;-1;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-848,-720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;222;-704,-128;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1072,304;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-1200,416;Float;False;Property;_GlowEmissionMultiplier;Glow Emission Multiplier;6;0;Create;True;0;0;0;False;0;False;1;21.9;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;-656,-992;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-2048,-768;Inherit;False;Property;_Smoothness;Smoothness;15;0;Create;True;0;0;0;False;0;False;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;208;240,-1008;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;128,-896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;-2176,-400;Inherit;True;Property;_Normals;Normals;4;0;Create;True;0;0;0;False;0;False;-1;None;abfd39fa1d6a42ba9b322e4301333932;True;2;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;221;-704,-320;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-896,304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-896,416;Float;False;Constant;_RangedFloatNode177;RangedFloatNode 177;-1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-896,496;Float;False;Constant;_RangedFloatNode178;RangedFloatNode 178;-1;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-1840,-784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;320,-992;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;103;-640,-400;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;176;-592,304;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;-1680,-784;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;480,-992;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;188;-480,-400;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-432,304;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;832,-1024;Inherit;False;186;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;832,-944;Inherit;False;188;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;832,-864;Inherit;False;190;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;800,-784;Inherit;False;192;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1088,-1024;Half;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Burn Effect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;219;0;179;0
WireConnection;203;0;180;0
WireConnection;220;0;219;0
WireConnection;204;0;203;0
WireConnection;5;0;220;0
WireConnection;5;1;6;0
WireConnection;7;0;204;0
WireConnection;7;1;11;0
WireConnection;83;1;5;0
WireConnection;9;0;7;0
WireConnection;9;1;10;0
WireConnection;209;0;83;4
WireConnection;98;1;9;0
WireConnection;194;0;98;1
WireConnection;137;0;212;0
WireConnection;137;1;138;0
WireConnection;136;0;134;0
WireConnection;136;1;137;0
WireConnection;68;0;67;2
WireConnection;68;1;76;0
WireConnection;216;0;136;0
WireConnection;66;0;68;0
WireConnection;171;0;199;0
WireConnection;171;1;211;0
WireConnection;200;0;98;2
WireConnection;145;0;213;0
WireConnection;145;1;144;0
WireConnection;217;0;216;0
WireConnection;170;0;169;0
WireConnection;170;1;171;0
WireConnection;69;0;66;0
WireConnection;69;1;95;0
WireConnection;146;0;147;0
WireConnection;146;1;145;0
WireConnection;218;0;217;0
WireConnection;174;0;69;0
WireConnection;174;1;170;0
WireConnection;65;0;73;0
WireConnection;65;1;77;0
WireConnection;148;0;146;0
WireConnection;148;1;218;0
WireConnection;148;2;202;0
WireConnection;70;0;65;0
WireConnection;70;1;174;0
WireConnection;149;0;148;0
WireConnection;149;1;197;0
WireConnection;182;0;183;0
WireConnection;182;1;83;2
WireConnection;182;3;83;1
WireConnection;101;0;70;0
WireConnection;101;1;201;0
WireConnection;80;1;180;0
WireConnection;151;0;149;0
WireConnection;151;1;150;0
WireConnection;181;0;182;0
WireConnection;106;0;101;0
WireConnection;106;1;210;0
WireConnection;34;0;80;0
WireConnection;34;1;35;0
WireConnection;207;0;151;0
WireConnection;19;0;13;0
WireConnection;19;1;198;0
WireConnection;222;0;181;0
WireConnection;127;0;195;0
WireConnection;127;1;106;0
WireConnection;28;0;34;0
WireConnection;28;1;27;0
WireConnection;28;2;19;0
WireConnection;208;0;207;0
WireConnection;154;0;196;0
WireConnection;154;1;156;0
WireConnection;82;1;179;0
WireConnection;221;0;222;0
WireConnection;157;0;127;0
WireConnection;157;1;158;0
WireConnection;184;0;80;4
WireConnection;184;1;185;0
WireConnection;152;0;28;0
WireConnection;152;1;208;0
WireConnection;152;2;154;0
WireConnection;103;0;82;0
WireConnection;103;1;221;0
WireConnection;103;2;19;0
WireConnection;176;0;157;0
WireConnection;176;1;177;0
WireConnection;176;2;178;0
WireConnection;192;0;184;0
WireConnection;186;0;152;0
WireConnection;188;0;103;0
WireConnection;190;0;176;0
WireConnection;0;0;187;0
WireConnection;0;1;189;0
WireConnection;0;2;191;0
WireConnection;0;4;193;0
ASEEND*/
//CHKSM=64394887C7FC4908BAF03FDC171A347AC3A987A0