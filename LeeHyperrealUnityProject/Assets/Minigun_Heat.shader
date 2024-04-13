// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Minigun Heat"
{
	Properties
	{
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_MetallicPower("Metallic Power", Range( 0 , 1)) = 0
		_HeatLength("Heat Length", Range( 0 , 2.3)) = 1
		_glowstrength("glow strength", Range( 0 , 15)) = 1
		[HDR]_Heat1Color("Heat 1 Color", Color) = (0,0,0,0)
		_Heat1offset("Heat 1 offset", Vector) = (0.17,0,0,0)
		_Heat1Thickness("Heat 1 Thickness", Vector) = (1,1.24,0,0)
		_Heat1lengthmulti("Heat 1 length multi", Float) = 1
		[HDR]_Heat2Color("Heat 2 Color", Color) = (0,0,0,0)
		_Heat2offset("Heat 2 offset", Vector) = (0.1,0,0,0)
		_Heat2Thickness("Heat 2 Thickness", Vector) = (0,0,0,0)
		_Heat2lengthmulti("Heat2 length multi", Float) = 1
		[HDR]_Heat3Color("Heat 3 Color", Color) = (0,0,0,0)
		_Heat3offset("Heat 3 offset", Vector) = (0.1,0,0,0)
		_Heat3Thickness("Heat 3 Thickness", Vector) = (0,0,0,0)
		_heat3lengthmulti("heat 3 length multi", Float) = 1
		_AlbedoMainTex("Albedo Main Tex", 2D) = "white" {}
		_Heat1("Heat 1", 2D) = "white" {}
		_Heat2("Heat 2", 2D) = "white" {}
		_Heat3("Heat 3", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _AlbedoMainTex;
		uniform float4 _AlbedoMainTex_ST;
		uniform float _glowstrength;
		uniform float4 _Heat2Color;
		uniform sampler2D _Heat2;
		uniform float2 _Heat2Thickness;
		uniform float _HeatLength;
		uniform float2 _Heat2offset;
		uniform float _Heat2lengthmulti;
		uniform float4 _Heat1Color;
		uniform sampler2D _Heat1;
		uniform float2 _Heat1Thickness;
		uniform float2 _Heat1offset;
		uniform float _Heat1lengthmulti;
		uniform sampler2D _Heat3;
		uniform float2 _Heat3Thickness;
		uniform float2 _Heat3offset;
		uniform float _heat3lengthmulti;
		uniform float4 _Heat3Color;
		uniform float _MetallicPower;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_AlbedoMainTex = i.uv_texcoord * _AlbedoMainTex_ST.xy + _AlbedoMainTex_ST.zw;
			o.Albedo = tex2D( _AlbedoMainTex, uv_AlbedoMainTex ).rgb;
			float clampResult56 = clamp( _glowstrength , 1.0 , 1.0 );
			float2 temp_cast_1 = (_Heat2Thickness.y).xx;
			float2 temp_cast_2 = (( _HeatLength * _Heat2offset.x * _Heat2lengthmulti )).xx;
			float2 uv_TexCoord27 = i.uv_texcoord * temp_cast_1 + temp_cast_2;
			float2 temp_cast_3 = (( _Heat1offset.x * _HeatLength * _Heat1lengthmulti )).xx;
			float2 uv_TexCoord8 = i.uv_texcoord * _Heat1Thickness + temp_cast_3;
			float4 lerpResult46 = lerp( ( ( clampResult56 * _Heat2Color ) * tex2D( _Heat2, uv_TexCoord27 ) * _glowstrength ) , ( _Heat1Color * tex2D( _Heat1, uv_TexCoord8 ) * ( _glowstrength / 2.0 ) ) , float4( 0.5188679,0.5188679,0.5188679,1 ));
			float2 temp_cast_4 = (_Heat3Thickness.y).xx;
			float2 uv_TexCoord69 = i.uv_texcoord * temp_cast_4 + ( _Heat3offset * _HeatLength * _heat3lengthmulti );
			float clampResult73 = clamp( 0.0 , 1.0 , 1.0 );
			float4 lerpResult75 = lerp( lerpResult46 , ( tex2D( _Heat3, uv_TexCoord69 ) * ( clampResult73 * _Heat3Color ) * _glowstrength ) , float4( 0.2830189,0.2830189,0.2830189,0 ));
			o.Emission = lerpResult75.rgb;
			o.Metallic = ( float3(0.56,0.57,0.58) * _MetallicPower ).x;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.Vector2Node;28;-2841.625,275.4084;Inherit;False;Property;_Heat2offset;Heat 2 offset;9;0;Create;True;0;0;0;False;0;False;0.1,0;0.126,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;18;-2215.286,-837.3259;Inherit;False;Property;_Heat1offset;Heat 1 offset;5;0;Create;True;0;0;0;False;0;False;0.17,0;0.19,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;58;-2923.018,-191.1045;Inherit;False;Property;_HeatLength;Heat Length;2;0;Create;True;0;0;0;False;0;False;1;2.3;0;2.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2693.119,497.1726;Inherit;False;Property;_Heat2lengthmulti;Heat2 length multi;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2511.611,-773.6138;Inherit;False;Property;_Heat1lengthmulti;Heat 1 length multi;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1966.241,-728.0884;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2559.241,305.9116;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-2088.41,131.0162;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;37;-2631.333,-13.43301;Inherit;False;Property;_Heat2Thickness;Heat 2 Thickness;10;0;Create;True;0;0;0;False;0;False;0,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;66;-2759.09,1100.474;Inherit;False;Property;_Heat3offset;Heat 3 offset;13;0;Create;True;0;0;0;False;0;False;0.1,0;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;65;-2611.584,1324.238;Inherit;False;Property;_heat3lengthmulti;heat 3 length multi;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-961.5037,-529.1151;Inherit;False;Property;_glowstrength;glow strength;3;0;Create;True;0;0;0;False;0;False;1;1.17;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;49;-2349.314,-997.5154;Inherit;False;Property;_Heat1Thickness;Heat 1 Thickness;6;0;Create;True;0;0;0;False;0;False;1,1.24;1.5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1729.38,-737.9868;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2477.706,1132.977;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1366.691,1103.863;Inherit;False;Constant;_Float3;Float 1;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;56;-1869.41,51.01624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-2122.598,-63.50102;Inherit;False;Property;_Heat2Color;Heat 2 Color;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;67;-2549.798,813.6329;Inherit;False;Property;_Heat3Thickness;Heat 3 Thickness;14;0;Create;True;0;0;0;False;0;False;0,0;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-2329.708,279.2493;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-1387.755,-587.5249;Inherit;False;Constant;_Float2;Float 2;11;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-2418.481,-645.4867;Inherit;False;Property;_Heat1Color;Heat 1 Color;4;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.7490196,0.1670133,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-2248.173,1106.315;Inherit;False;0;-1;2;3;2;OBJECT;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;73;-1149.691,1025.863;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;70;-1402.879,911.3456;Inherit;False;Property;_Heat3Color;Heat 3 Color;12;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.7490196,0.7490196,0.7490196,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-1917.704,328.2487;Inherit;True;Property;_Heat2;Heat 2;18;0;Create;True;0;0;0;False;0;False;-1;None;2352bca9943c85c4597e1272f7ee747d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;61;-1212.755,-584.5249;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1837.251,-204.8911;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;-2321.99,-295.8142;Inherit;True;Property;_Heat1;Heat 1;17;0;Create;True;0;0;0;False;0;False;-1;None;cafd9192b69a7dd40b25e89c228ceae3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1635.838,-354.9242;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-1117.532,769.9555;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1452.025,-24.10898;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;-1767.142,731.1827;Inherit;True;Property;_Heat3;Heat 3;19;0;Create;True;0;0;0;False;0;False;-1;None;2352bca9943c85c4597e1272f7ee747d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1294.301,479.5565;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;46;-886.3223,-150.2903;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0.5188679,0.5188679,0.5188679,1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;79;-490.287,514.4235;Inherit;False;Metal Reflectance;-1;;1;55ea54ba7a9d52c4a8bf7b3e01e6ae77;1,38,0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-583.287,592.4235;Inherit;False;Property;_MetallicPower;Metallic Power;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;75;-559.2218,-58.32867;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0.2830189,0.2830189,0.2830189,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;38;-1127.969,34.56448;Inherit;False;ColorBurn;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;77;-569.9918,134.169;Inherit;True;Property;_AlbedoMainTex;Albedo Main Tex;16;0;Create;True;0;0;0;False;0;False;-1;None;b8d005f520b53b64e845244f376ae0f7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;78;-582.287,388.4235;Inherit;False;Property;_Smoothness;Smoothness;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-217.487,423.6232;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-23,10.3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Minigun Heat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;60;0;18;1
WireConnection;60;1;58;0
WireConnection;60;2;76;0
WireConnection;59;0;58;0
WireConnection;59;1;28;1
WireConnection;59;2;63;0
WireConnection;8;0;49;0
WireConnection;8;1;60;0
WireConnection;68;0;66;0
WireConnection;68;1;58;0
WireConnection;68;2;65;0
WireConnection;56;0;51;0
WireConnection;56;1;57;0
WireConnection;27;0;37;2
WireConnection;27;1;59;0
WireConnection;69;0;67;2
WireConnection;69;1;68;0
WireConnection;73;1;72;0
WireConnection;24;1;27;0
WireConnection;61;0;51;0
WireConnection;61;1;62;0
WireConnection;52;0;56;0
WireConnection;52;1;31;0
WireConnection;7;1;8;0
WireConnection;9;0;10;0
WireConnection;9;1;7;0
WireConnection;9;2;61;0
WireConnection;71;0;73;0
WireConnection;71;1;70;0
WireConnection;32;0;52;0
WireConnection;32;1;24;0
WireConnection;32;2;51;0
WireConnection;64;1;69;0
WireConnection;74;0;64;0
WireConnection;74;1;71;0
WireConnection;74;2;51;0
WireConnection;46;0;32;0
WireConnection;46;1;9;0
WireConnection;75;0;46;0
WireConnection;75;1;74;0
WireConnection;81;0;79;0
WireConnection;81;1;80;0
WireConnection;0;0;77;0
WireConnection;0;2;75;0
WireConnection;0;3;81;0
WireConnection;0;4;78;0
ASEEND*/
//CHKSM=9C113B1C923CA811FEA9539F83AD8CFA9886E0A9