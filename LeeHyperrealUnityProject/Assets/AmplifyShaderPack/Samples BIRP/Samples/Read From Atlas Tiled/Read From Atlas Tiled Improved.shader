// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Read From Atlas Tiled Improved"
{
	Properties
	{
		_Min("Min", Vector) = (0,0,0,0)
		_Max("Max", Vector) = (0,0,0,0)
		_TileSize("TileSize", Vector) = (2,2,0,0)
		_Atlas("Atlas", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Atlas;
		float4 _Atlas_TexelSize;
		uniform float2 _Min;
		uniform float4 _Atlas_ST;
		uniform float2 _TileSize;
		uniform float2 _Max;


		inline float2 MyCustomExpression61( float2 A, float2 B )
		{
			return frac(A/B)*B;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult62 = (float2(_Atlas_TexelSize.x , _Atlas_TexelSize.y));
			float2 temp_output_22_0 = ( appendResult62 * _Min );
			float2 uv_Atlas = i.uv_texcoord * _Atlas_ST.xy + _Atlas_ST.zw;
			float2 A61 = uv_Atlas;
			float2 B61 = ( float2( 1,1 ) / _TileSize );
			float2 localMyCustomExpression61 = MyCustomExpression61( A61 , B61 );
			o.Albedo = (tex2Dlod( _Atlas, float4( ( temp_output_22_0 + ( ( localMyCustomExpression61 * ( ( _Max * appendResult62 ) - temp_output_22_0 ) ) * _TileSize ) ), 0, 0.0) )).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.TexelSizeNode;19;-1738.502,61.69999;Inherit;False;30;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-1555.5,-54.29998;Float;False;Property;_Max;Max;1;0;Create;True;0;0;0;False;0;False;0,0;511,511;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;13;-1555.5,217.6999;Float;False;Property;_Min;Min;0;0;Create;True;0;0;0;False;0;False;0,0;257,257;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;62;-1537.5,89.69994;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1373.5,27.7;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1373.5,136.6999;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;56;-1553.199,-313.8001;Float;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;50;-1556.199,-193.8;Float;False;Property;_TileSize;TileSize;2;0;Create;True;0;0;0;False;0;False;2,2;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;38;-1189.05,26.90957;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;-1377.199,-309.8001;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;72;-1032.038,20.69568;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;70;-721.9049,167.3915;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1471.399,-443.4002;Inherit;False;0;30;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;68;-696.1668,132.8937;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;73;-1034.038,-232.3043;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;61;-1216,-336;Float;False;frac(A/B)*B;2;Create;2;True;A;FLOAT2;0,0;In;;Float;False;True;B;FLOAT2;0,0;In;;Float;False;My Custom Expression;True;False;0;;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-980.3,-334.1001;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;71;-693.8744,-148.8487;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-833.6003,-208.2;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;69;-693.2369,-183.3638;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-616.6924,-231.2271;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-604.6899,-135.7773;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-430.3275,-258.8995;Inherit;True;Property;_Atlas;Atlas;3;0;Create;True;0;0;0;False;0;False;-1;None;c906244cc4d24a2a82cb5def2d05890c;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StickyNoteNode;64;-1733.302,-189.9095;Inherit;False;168;102;TileSize;;0,0,0,1;Value to set amount of tiling to perform.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;65;-1735.169,-48.40955;Inherit;False;171.5674;100;Max;;0,0,0,1;Maximum pixel coordinates from section to tile.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;66;-1733.007,229.5904;Inherit;False;165.4053;104.6216;Min;;0,0,0,1;Minimum pixel coordinates from section to tile.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;67;-1213.48,-40.63661;Inherit;False;157;167;;;0,0,0,1;Size;0;0
Node;AmplifyShaderEditor.StickyNoteNode;74;-430.912,-66.56189;Inherit;False;285;132;Atlas;;0,0,0,1;Texture containing atlas/spritesheet to perform sampling of specified section. ;0;0
Node;AmplifyShaderEditor.StickyNoteNode;75;-419.912,-518.5619;Inherit;False;425;195;Atlas Tiled;;0,0,0,1;This sample tiles a specific section of a spritesheet/atlas. $$Improved Read From Atlas$material performs a more bit complex sampling that is less prone to mip issues.;0;0
Node;AmplifyShaderEditor.SwizzleNode;76;-118.8296,-258.3039;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;74.59196,-253.2457;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Read From Atlas Tiled Improved;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;62;0;19;1
WireConnection;62;1;19;2
WireConnection;23;0;14;0
WireConnection;23;1;62;0
WireConnection;22;0;62;0
WireConnection;22;1;13;0
WireConnection;38;0;23;0
WireConnection;38;1;22;0
WireConnection;54;0;56;0
WireConnection;54;1;50;0
WireConnection;72;0;38;0
WireConnection;70;0;22;0
WireConnection;68;0;70;0
WireConnection;73;0;72;0
WireConnection;61;0;12;0
WireConnection;61;1;54;0
WireConnection;42;0;61;0
WireConnection;42;1;73;0
WireConnection;71;0;68;0
WireConnection;53;0;42;0
WireConnection;53;1;50;0
WireConnection;69;0;71;0
WireConnection;40;0;69;0
WireConnection;40;1;53;0
WireConnection;30;1;40;0
WireConnection;30;2;58;0
WireConnection;76;0;30;0
WireConnection;0;0;76;0
ASEEND*/
//CHKSM=F5E62FD138C8F3F9FEA654030856F15DF4839C6B