// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Material Sample Transparency"
{
	Properties
	{
		[Header(SURFACE OPTIONS)][Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		_Distortion("Distortion", 2D) = "bump" {}
		[HideInInspector][ToggleUI]_TransparentDepthPrepassEnable("_TransparentDepthPrepassEnable", Float) = 0
		_UVOffset1("UV Offset 1", Vector) = (-0.1,-0.1,-0.1,0)
		_UVOffset0("UV Offset 0", Vector) = (0.07,0.1,0.1,0)
		[HideInInspector][ToggleUI]_TransparentDepthPostpassEnable("_TransparentDepthPostpassEnable", Float) = 0
		_Cubemap("Cubemap", CUBE) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull]
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha 
		struct Input
		{
			float2 uv2_texcoord2;
			float3 worldRefl;
			INTERNAL_DATA
		};

		uniform half _TransparentDepthPrepassEnable;
		uniform half _TransparentDepthPostpassEnable;
		uniform int _Cull;
		uniform sampler2D _Distortion;
		uniform float4 _Distortion_ST;
		uniform samplerCUBE _Cubemap;
		uniform float3 _UVOffset0;
		uniform float3 _UVOffset1;
		uniform float _Smoothness;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv1_Distortion = i.uv2_texcoord2 * _Distortion_ST.xy + _Distortion_ST.zw;
			float3 tex2DNode60 = UnpackNormal( tex2D( _Distortion, uv1_Distortion ) );
			o.Normal = tex2DNode60;
			o.Albedo = float4(1,1,1,0).rgb;
			float3 newWorldReflection41 = WorldReflectionVector( i , tex2DNode60 );
			float3 appendResult44 = (float3(texCUBE( _Cubemap, ( newWorldReflection41 + _UVOffset0 ) ).r , texCUBE( _Cubemap, newWorldReflection41 ).g , texCUBE( _Cubemap, ( newWorldReflection41 + _UVOffset1 ) ).b));
			o.Emission = appendResult44;
			o.Metallic = 1.0;
			o.Smoothness = _Smoothness;
			o.Alpha = _Opacity;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.SamplerNode;60;-1059.974,-47.21064;Inherit;True;Property;_Distortion;Distortion;1;0;Create;True;0;0;0;False;0;False;-1;None;161b0899cec643d9b2a5b72bb8e1788b;True;1;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WorldReflectionVector;41;-707.8829,179.1167;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;42;-707.157,314.8879;Float;False;Property;_UVOffset0;UV Offset 0;5;0;Create;True;0;0;0;False;0;False;0.07,0.1,0.1;0.32,0.1,0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;43;-716.9905,567.8887;Float;False;Property;_UVOffset1;UV Offset 1;3;0;Create;True;0;0;0;False;0;False;-0.1,-0.1,-0.1;-0.19,-0.1,-0.1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-479.7564,180.288;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-482.6982,549.118;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;37;-327.3648,151.5421;Inherit;True;Property;_Cubemap;Cubemap;7;0;Create;True;0;0;0;False;0;False;-1;None;784d8a7d322a43baa027462fbd81f226;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;38;-327.1906,339.2853;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;784d8a7d322a43baa027462fbd81f226;True;0;False;white;Auto;False;Instance;37;Auto;Cube;8;0;SAMPLERCUBE;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;39;-327.1771,527.263;Inherit;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;0;False;0;False;-1;None;784d8a7d322a43baa027462fbd81f226;True;0;False;white;Auto;False;Instance;37;Auto;Cube;8;0;SAMPLERCUBE;0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;35;-950.0073,772.9343;Inherit;False;916.4255;552.5038;HDRP Depth Prepass Postpass;9;56;55;54;53;50;49;48;47;46;;0,0,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;23.59481,45.05619;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;46;-573.9237,826.3375;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-881.3293,894.6759;Half;False;Property;_HiddenPostpass;HiddenPostpass;8;1;[HideInInspector];Create;True;0;0;0;False;0;False;1;2.29;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;48;-569.6326,993.8872;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-381.5819,989.3342;Inherit;False;AlphaClipThresholdDepthPostpass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-397.5819,822.9343;Inherit;False;AlphaClipThresholdDepthPrepass;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;116.8691,343.9219;Inherit;False;50;AlphaClipThresholdDepthPrepass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;109.8691,415.9219;Inherit;False;49;AlphaClipThresholdDepthPostpass;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-900.0073,964.9689;Half;False;Property;_TransparentDepthPrepassEnable;_TransparentDepthPrepassEnable;2;2;[HideInInspector];[ToggleUI];Create;True;0;0;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-899.4122,1038.437;Half;False;Property;_TransparentDepthPostpassEnable;_TransparentDepthPostpassEnable;6;2;[HideInInspector];[ToggleUI];Create;True;0;0;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-884.3849,824.0981;Half;False;Property;_HiddenPrepass;HiddenPrepass;4;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;-0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;56;-900.5403,1116.666;Inherit;False;639;119;Hidden;;0,0,0,1;in ASE template Enable Transparent Depth Prepass and Postpass$$checkbox will show in the Rendering.HighDefinition.LightingShaderGraphGUI;0;0
Node;AmplifyShaderEditor.RangedFloatNode;58;145.4622,194.82;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;0;False;0;False;0;0.64;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;148.7835,269.312;Float;False;Property;_Opacity;Opacity;10;0;Create;True;0;0;0;False;0;False;1;0.358;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;61;163.5531,27.20734;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;34;568.8638,-141.8257;Inherit;False;Property;_Cull;Render Face;0;2;[Header];[Enum];Create;False;1;SURFACE OPTIONS;0;1;Front,2,Back,1,Both,0;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.ColorNode;45;220.4932,-202.4059;Float;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;57;147.7234,121.5513;Float;False;Constant;_Metallic;Metallic;1;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;556.7474,-67.82102;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Material Sample Transparency;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;60;0
WireConnection;36;0;41;0
WireConnection;36;1;42;0
WireConnection;40;0;41;0
WireConnection;40;1;43;0
WireConnection;37;1;36;0
WireConnection;38;1;41;0
WireConnection;39;1;40;0
WireConnection;44;0;37;1
WireConnection;44;1;38;2
WireConnection;44;2;39;3
WireConnection;46;0;55;0
WireConnection;46;1;47;0
WireConnection;46;2;53;0
WireConnection;48;0;55;0
WireConnection;48;1;47;0
WireConnection;48;2;54;0
WireConnection;49;0;48;0
WireConnection;50;0;46;0
WireConnection;61;0;44;0
WireConnection;0;0;45;0
WireConnection;0;1;60;0
WireConnection;0;2;61;0
WireConnection;0;3;57;0
WireConnection;0;4;58;0
WireConnection;0;9;59;0
ASEEND*/
//CHKSM=CDC527D11E302B848D464747F241B3CF32FBACC1