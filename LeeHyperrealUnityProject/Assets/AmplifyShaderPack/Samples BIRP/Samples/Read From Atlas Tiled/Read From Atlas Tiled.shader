// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Read From Atlas Tiled"
{
	Properties
	{
		_Min1("Min", Vector) = (0,0,0,0)
		_Max1("Max", Vector) = (0,0,0,0)
		_TileSize1("TileSize", Vector) = (2,2,0,0)
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
		uniform float2 _Min1;
		uniform float4 _Atlas_ST;
		uniform float2 _TileSize1;
		uniform float2 _Max1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult68 = (float2(_Atlas_TexelSize.x , _Atlas_TexelSize.y));
			float2 temp_output_70_0 = ( appendResult68 * _Min1 );
			float2 uv_Atlas = i.uv_texcoord * _Atlas_ST.xy + _Atlas_ST.zw;
			o.Albedo = (tex2Dlod( _Atlas, float4( ( temp_output_70_0 + ( ( fmod( uv_Atlas , ( float2( 1,1 ) / _TileSize1 ) ) * ( ( _Max1 * appendResult68 ) - temp_output_70_0 ) ) * _TileSize1 ) ), 0, 0.0) )).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.TexelSizeNode;67;-1683.637,11.42152;Inherit;False;30;1;0;SAMPLER2D;;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;68;-1482.635,39.4215;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;66;-1503.635,174.4215;Float;False;Property;_Min1;Min;0;0;Create;True;0;0;0;False;0;False;0,0;257,257;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;65;-1501.635,-107.5786;Float;False;Property;_Max1;Max;1;0;Create;True;0;0;0;False;0;False;0,0;511,511;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1318.635,-22.57848;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1318.635,86.42151;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;84;-1501.334,-244.0786;Float;False;Property;_TileSize1;TileSize;2;0;Create;True;0;0;0;False;0;False;2,2;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;83;-1498.334,-364.0787;Float;False;Constant;_Vector1;Vector 0;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;-1133.185,-21.36888;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;59;-1322.334,-360.0787;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;81;-961.173,-13.58277;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-1419.534,-498.6787;Inherit;False;0;30;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;78;-656.04,133.113;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;77;-625.3019,98.61523;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;82;-963.173,-266.5829;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FmodOpNode;85;-1123.934,-380.7489;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-922.8352,-377.8787;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;75;-625.0095,-181.1272;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-778.7354,-258.4786;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;74;-624.372,-212.6423;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-561.8275,-281.5057;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-567.825,-183.0558;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-396.339,-306.8254;Inherit;True;Property;_Atlas;Atlas;3;0;Create;True;0;0;0;False;0;False;-1;None;c1efbea8a190455497f6910632f58675;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StickyNoteNode;86;-1684.452,-241.7191;Inherit;False;168;102;TileSize;;0,0,0,1;Value to set amount of tiling to perform.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;87;-1686.319,-94.21907;Inherit;False;171.5674;100;Max;;0,0,0,1;Maximum pixel coordinates from section to tile.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;88;-1680.157,180.7809;Inherit;False;165.4053;104.6216;Min;;0,0,0,1;Minimum pixel coordinates from section to tile.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;89;-1152.63,-79.4461;Inherit;False;157;167;;;0,0,0,1;Size;0;0
Node;AmplifyShaderEditor.StickyNoteNode;90;-380.0613,-118.3715;Inherit;False;285;132;Atlas;;0,0,0,1;Texture containing atlas/spritesheet to perform sampling of specified section. ;0;0
Node;AmplifyShaderEditor.StickyNoteNode;91;-364.0613,-510.3713;Inherit;False;421;124;Atlas Tiled;;0,0,0,1;This sample tiles a specific section of a spritesheet/atlas. ;0;0
Node;AmplifyShaderEditor.SwizzleNode;92;-82.41846,-307.0378;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;106.7639,-302.1298;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Read From Atlas Tiled;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;67;1
WireConnection;68;1;67;2
WireConnection;69;0;65;0
WireConnection;69;1;68;0
WireConnection;70;0;68;0
WireConnection;70;1;66;0
WireConnection;73;0;69;0
WireConnection;73;1;70;0
WireConnection;59;0;83;0
WireConnection;59;1;84;0
WireConnection;81;0;73;0
WireConnection;78;0;70;0
WireConnection;77;0;78;0
WireConnection;82;0;81;0
WireConnection;85;0;60;0
WireConnection;85;1;59;0
WireConnection;71;0;85;0
WireConnection;71;1;82;0
WireConnection;75;0;77;0
WireConnection;72;0;71;0
WireConnection;72;1;84;0
WireConnection;74;0;75;0
WireConnection;76;0;74;0
WireConnection;76;1;72;0
WireConnection;30;1;76;0
WireConnection;30;2;79;0
WireConnection;92;0;30;0
WireConnection;0;0;92;0
ASEEND*/
//CHKSM=215E403D60BAC1D1177912C6911E3D2AE2C10AE0