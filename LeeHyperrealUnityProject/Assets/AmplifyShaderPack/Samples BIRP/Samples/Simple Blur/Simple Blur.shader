// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Simple Blur"
{
	Properties
	{
		[SingleLineTexture]_MainTex("BaseColor Map", 2D) = "white" {}
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		[Toggle]_ToggleBlur("Toggle Blur", Range( 0 , 1)) = 0
		_BlurSize("Blur Size", Range( 0 , 0.05)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_Cull]
		ZTest LEqual
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _Cull;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _BlurSize;
		uniform float _ToggleBlur;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 appendResult39 = (float2(0.0 , _BlurSize));
			float2 appendResult40 = (float2(_BlurSize , 0.0));
			float2 appendResult42 = (float2(_BlurSize , _BlurSize));
			float3 lerpResult31 = lerp( (tex2D( _MainTex, i.uv_texcoord )).rgb , ( ( ( ( (tex2D( _MainTex, uv_MainTex )).rgb * 0.4 ) + ( (tex2D( _MainTex, ( i.uv_texcoord + appendResult39 ) )).rgb * 0.2 ) ) + ( (tex2D( _MainTex, ( i.uv_texcoord + appendResult40 ) )).rgb * 0.2 ) ) + ( (tex2D( _MainTex, ( i.uv_texcoord + appendResult42 ) )).rgb * 0.2 ) ) , step( 0.5 , _ToggleBlur ));
			o.Albedo = lerpResult31;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;37;-2055.839,-267.2802;Float;False;Property;_BlurSize;Blur Size;3;0;Create;True;0;0;0;False;0;False;0;0.0123;0;0.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1750.958,-854.9788;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;39;-1704.334,-445.6361;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1496.351,-468.8293;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;58;-1624.997,-1063.89;Inherit;True;Property;_MainTex;BaseColor Map;0;1;[SingleLineTexture];Create;False;1;;0;0;False;0;False;None;58bfd706299646e6a342bd9b037dfeda;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1698.934,-255.136;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1489.2,-274.2021;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-1677.035,-59.83599;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;59;-1347.544,-691.6075;Inherit;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;60;-1345.132,-497.155;Inherit;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1504.032,-79.74943;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;61;-1341.132,-306.155;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;26;-992.9274,-429.3987;Float;False;Constant;_Float1;Float 1;-1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;70;-1025.823,-498.4959;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;69;-1028.286,-691.8239;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1000.499,-610.8986;Float;False;Constant;_Float0;Float 0;-1;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;62;-1343.132,-109.155;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;27;-839.4777,-228.7981;Float;False;Constant;_Float2;Float 2;-1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-838.3566,-490.6354;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;71;-1028.286,-307.6308;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-846.0012,-683.9993;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-667.5371,-305.301;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-613.1942,-37.92681;Float;False;Constant;_Float3;Float 3;-1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;72;-1018.434,-109.3772;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-669.0005,-683.3999;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-508.2426,-683.5433;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;47;-1352.415,-883.6583;Inherit;True;Property;_TextureSample13;Texture Sample 13;33;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-452.2673,-110.8916;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-598.0671,-944.4006;Float;False;Property;_ToggleBlur;Toggle Blur;2;1;[Toggle];Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-303.1075,-689.1954;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;35;-289.9422,-963.2598;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;68;-1023.36,-886.3829;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;31;-124.2013,-892.1536;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode;64;-1842.756,-1059.495;Inherit;False;205;100;Texture Sample;;0,0,0,1;Texture to be blurred.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;65;-455.9481,-828.4296;Inherit;False;267;101.3;Toggle Blur;;0,0,0,1;Toggles on/off the texture blur.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;66;-2046.755,-385.2465;Inherit;False;235.9991;102.2337;Blur Size;;0,0,0,1;Value that controls blur spreading.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;67;-125.7333,-1142.803;Inherit;False;278.7194;121.9006;Blur Offset;;0,0,0,1;This sample performs a really simple blur over a given texture.;0;0
Node;AmplifyShaderEditor.IntNode;63;77.83051,-965.4991;Inherit;False;Property;_Cull;Render Face;1;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;71.81346,-892.0983;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Simple Blur;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;3;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;1;37;0
WireConnection;38;0;9;0
WireConnection;38;1;39;0
WireConnection;40;0;37;0
WireConnection;41;0;9;0
WireConnection;41;1;40;0
WireConnection;42;0;37;0
WireConnection;42;1;37;0
WireConnection;59;0;58;0
WireConnection;59;7;58;1
WireConnection;60;0;58;0
WireConnection;60;1;38;0
WireConnection;60;7;58;1
WireConnection;43;0;9;0
WireConnection;43;1;42;0
WireConnection;61;0;58;0
WireConnection;61;1;41;0
WireConnection;61;7;58;1
WireConnection;70;0;60;0
WireConnection;69;0;59;0
WireConnection;62;0;58;0
WireConnection;62;1;43;0
WireConnection;62;7;58;1
WireConnection;22;0;70;0
WireConnection;22;1;26;0
WireConnection;71;0;61;0
WireConnection;21;0;69;0
WireConnection;21;1;25;0
WireConnection;23;0;71;0
WireConnection;23;1;27;0
WireConnection;72;0;62;0
WireConnection;13;0;21;0
WireConnection;13;1;22;0
WireConnection;14;0;13;0
WireConnection;14;1;23;0
WireConnection;47;0;58;0
WireConnection;47;1;9;0
WireConnection;47;7;58;1
WireConnection;24;0;72;0
WireConnection;24;1;28;0
WireConnection;15;0;14;0
WireConnection;15;1;24;0
WireConnection;35;1;32;0
WireConnection;68;0;47;0
WireConnection;31;0;68;0
WireConnection;31;1;15;0
WireConnection;31;2;35;0
WireConnection;0;0;31;0
ASEEND*/
//CHKSM=97FBCBEA4690F6FE7FC4477CEB13716919D8356C