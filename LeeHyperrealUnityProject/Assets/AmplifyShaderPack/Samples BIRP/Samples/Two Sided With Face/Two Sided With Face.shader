// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Two Sided With Face"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Mask("Mask", 2D) = "white" {}
		_FrontAlbedo("Front Albedo", 2D) = "white" {}
		_FrontNormalMap("Front Normal Map", 2D) = "bump" {}
		_FrontColor("Front Color", Color) = (1,0.6691177,0.6691177,0)
		_BackAlbedo("Back Albedo", 2D) = "white" {}
		_BackNormalMap("Back Normal Map", 2D) = "bump" {}
		_BackColor("Back Color", Color) = (0,0,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEIsFrontFacing : VFACE;
		};

		uniform sampler2D _FrontNormalMap;
		uniform sampler2D _BackNormalMap;
		uniform sampler2D _FrontAlbedo;
		uniform float4 _FrontColor;
		uniform sampler2D _BackAlbedo;
		uniform float4 _BackColor;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 switchResult3 = (((i.ASEIsFrontFacing>0)?(UnpackNormal( tex2D( _FrontNormalMap, i.uv_texcoord ) )):(UnpackNormal( tex2D( _BackNormalMap, i.uv_texcoord ) ))));
			o.Normal = switchResult3;
			float4 switchResult2 = (((i.ASEIsFrontFacing>0)?(( tex2D( _FrontAlbedo, i.uv_texcoord ) * _FrontColor )):(( tex2D( _BackAlbedo, i.uv_texcoord ) * _BackColor ))));
			o.Albedo = switchResult2.rgb;
			o.Alpha = 1;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			clip( tex2D( _Mask, uv_Mask ).a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1152,-512;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;21;-928,-432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;22;-928,-432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;24;-928,224;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;25;-928,416;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;10;-864,208;Inherit;True;Property;_FrontNormalMap;Front Normal Map;3;0;Create;True;0;0;0;False;0;False;-1;None;b91e3e42ac594b849bc5700ddfa92aa0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;11;-864,400;Inherit;True;Property;_BackNormalMap;Back Normal Map;6;0;Create;True;0;0;0;False;0;False;-1;None;8ec217f770e34536be4d0dee12abb7a6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;20;-928,-432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwitchByFaceNode;3;-384,208;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;23;-928,-128;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;4;-864,-528;Inherit;True;Property;_FrontAlbedo;Front Albedo;2;0;Create;True;0;0;0;False;0;False;-1;None;6633e66536f148a281a9fcaa7ef60863;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;5;-800,-336;Float;False;Property;_FrontColor;Front Color;4;0;Create;True;0;0;0;False;0;False;1,0.6691177,0.6691177,0;1,0,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;8;-864,-160;Inherit;True;Property;_BackAlbedo;Back Albedo;5;0;Create;True;0;0;0;False;0;False;-1;None;f0325b098cd84bc1a847391f531b3007;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;7;-800,32;Float;False;Property;_BackColor;Back Color;7;0;Create;True;0;0;0;False;0;False;0,0,1,0;0,0,1,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;16;-128,208;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-400,336;Inherit;True;Property;_Mask;Mask;1;0;Create;True;0;0;0;False;0;False;-1;None;4a78764018124872b6f511e00fb51f97;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-512,-528;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-512,-160;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;17;-128,-384;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;19;-64,432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2;-304,-528;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;15;-112,-432;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;18;-48,-192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;80,-528;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Two Sided With Face;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1195.744,-592;Inherit;False;1176.662;1211.936;Inspired by 2Side Sample by The Four Headed Cat;0;Two Sided Shader using Switch by Face;0,0,0,1;0;0
WireConnection;21;0;14;0
WireConnection;22;0;14;0
WireConnection;24;0;21;0
WireConnection;25;0;22;0
WireConnection;10;1;24;0
WireConnection;11;1;25;0
WireConnection;20;0;14;0
WireConnection;3;0;10;0
WireConnection;3;1;11;0
WireConnection;23;0;20;0
WireConnection;4;1;14;0
WireConnection;8;1;23;0
WireConnection;16;0;3;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;17;0;16;0
WireConnection;19;0;1;4
WireConnection;2;0;6;0
WireConnection;2;1;9;0
WireConnection;15;0;17;0
WireConnection;18;0;19;0
WireConnection;0;0;2;0
WireConnection;0;1;15;0
WireConnection;0;10;18;0
ASEEND*/
//CHKSM=1B52B5DDB8AC3155432CD37F4394FE2729ED4CEF