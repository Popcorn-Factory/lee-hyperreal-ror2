// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Simple Potion Liquid"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		_MaskClipValue("Mask Clip Value", Float) = 0
		_Speed("Speed", Float) = 0
		_Size("Size", Float) = 0.1
		_Height("Height", Float) = 0
		_Falloff("Falloff", Float) = 0.02
		_Opacity("Opacity", Float) = 0.76
		_Color("Color", Color) = (1,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull]
		ZWrite On
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		AlphaToMask On
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float3 worldPos;
		};

		uniform int _Cull;
		uniform float4 _Color;
		uniform float _Speed;
		uniform float _Size;
		uniform float _Height;
		uniform float _Falloff;
		uniform float _Opacity;
		uniform float _MaskClipValue;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 temp_output_25_0 = (_Color).rgb;
			o.Albedo = temp_output_25_0;
			o.Emission = temp_output_25_0;
			float4 transform7 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float4 temp_output_5_0 = ( transform7 - float4( ase_worldPos , 0.0 ) );
			float mulTime2 = _Time.y * _Speed;
			float4 temp_cast_2 = (( 1.0 - _Height )).xxxx;
			float4 clampResult18 = clamp( ( ( ( ( temp_output_5_0 * sin( mulTime2 ) * _Size ) + (temp_output_5_0).y ) - temp_cast_2 ) / _Falloff ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Alpha = ( clampResult18 * _Opacity ).x;
			clip( _MaskClipValue - _Cull );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;1;0,-128;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;0;False;0;False;0;7.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;160,-128;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;7;16,0;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;8;48,176;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;3;368,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;5;272,64;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;6;272,-16;Float;False;Property;_Size;Size;3;0;Create;True;0;0;0;False;0;False;0.1;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;464,64;Inherit;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;512,160;Float;False;Property;_Height;Height;4;0;Create;True;0;0;0;False;0;False;0;1.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;512,-64;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;12;672,160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;704,-64;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;848,-64;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;16;864,64;Float;False;Property;_Falloff;Falloff;5;0;Create;True;0;0;0;False;0;False;0.02;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;1056,-64;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;18;1264,-64;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;20;1248,64;Float;False;Property;_Opacity;Opacity;6;0;Create;True;0;0;0;False;0;False;0.76;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;1392,-272;Float;False;Property;_Color;Color;7;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0.02273111,0,0;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;1472,-64;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;23;1472,64;Inherit;False;Property;_MaskClipValue;Mask Clip Value;1;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;25;1616,-272;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;24;1792,-352;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1792,-272;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Simple Potion Liquid;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Front;1;False;;7;False;;False;0.6;False;;2.65;False;;True;0;Custom;0.08;True;False;1;True;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;5;False;;10;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;True;0;0;True;_Cull;-1;0;True;_Cull;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;5;0;7;0
WireConnection;5;1;8;0
WireConnection;10;0;5;0
WireConnection;4;0;5;0
WireConnection;4;1;3;0
WireConnection;4;2;6;0
WireConnection;12;0;13;0
WireConnection;9;0;4;0
WireConnection;9;1;10;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;14;0;11;0
WireConnection;14;1;16;0
WireConnection;18;0;14;0
WireConnection;21;0;18;0
WireConnection;21;1;20;0
WireConnection;25;0;22;0
WireConnection;0;0;25;0
WireConnection;0;2;25;0
WireConnection;0;9;21;0
WireConnection;0;10;23;0
ASEEND*/
//CHKSM=E3BC3AA369995E44DB82A4146331CC17B966454A