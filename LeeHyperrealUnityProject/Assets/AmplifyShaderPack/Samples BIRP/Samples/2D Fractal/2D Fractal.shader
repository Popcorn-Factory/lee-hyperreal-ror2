// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/2D Fractal"
{
	Properties
	{
		_MaxIter("MaxIter", Int) = 0
		_Threshold("Threshold", Float) = 0
		_ZoomOffset("Zoom Offset", Float) = 2
		_ZoomScale("Zoom Scale", Float) = 3
		_Center("Center", Vector) = (-0.412,0.609,0,0)
		_ZoomBase("Zoom Base", Float) = 0.25
		[HDR]_Tint("Tint", Color) = (0,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Tint;
			uniform float _ZoomBase;
			uniform float _ZoomScale;
			uniform float _ZoomOffset;
			uniform float2 _Center;
			uniform int _MaxIter;
			uniform float _Threshold;
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float Mandlebrot24( float2 UV, int MaxIter, float Threshold )
			{
				float2 r = UV;
				int step = 0;
				for (int i = 0; i < MaxIter; i++) 
				{
					if (length(r) > Threshold) 
						break;
					
					r = mul( float2x2(r.x,-r.y,r.y,r.x) , r) + UV;
					step++;
				}
				return (float)step/(float)MaxIter;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float saferPower10 = abs( _ZoomBase );
				float2 texCoord12 = i.ase_texcoord1.xy * float2( 2,2 ) + float2( -1,-1 );
				float2 UV24 = ( ( pow( saferPower10 , (_SinTime.z*_ZoomScale + _ZoomOffset) ) * texCoord12 ) + _Center );
				int MaxIter24 = _MaxIter;
				float Threshold24 = _Threshold;
				float localMandlebrot24 = Mandlebrot24( UV24 , MaxIter24 , Threshold24 );
				float temp_output_22_0 = ( 1.0 - localMandlebrot24 );
				float3 appendResult21 = (float3(( 0.9 - ( 0.9 * temp_output_22_0 ) ) , temp_output_22_0 , temp_output_22_0));
				float3 break18 = appendResult21;
				float3 hsvTorgb19 = HSVToRGB( float3(break18.x,break18.y,break18.z) );
				
				
				finalColor = ( _Tint * float4( hsvTorgb19 , 0.0 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.RangedFloatNode;3;-3296,240;Float;False;Property;_ZoomScale;Zoom Scale;3;0;Create;True;0;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3296,320;Float;False;Property;_ZoomOffset;Zoom Offset;2;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;4;-3264,80;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;7;-2594.332,235.8613;Float;False;Constant;_Offset;Offset;6;0;Create;True;0;0;0;False;0;False;-1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;6;-2587.582,117.8615;Float;False;Constant;_Tiling;Tiling;6;0;Create;True;0;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;9;-3040,64;Float;False;Property;_ZoomBase;Zoom Base;5;0;Create;True;0;0;0;False;0;False;0.25;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;8;-3088,240;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2357.562,194.9853;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;-1,-1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;10;-2848,64;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2117.412,65.06446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;14;-2218.963,331.8865;Float;False;Property;_Center;Center;4;0;Create;True;0;0;0;False;0;False;-0.412,0.609;-0.766,-0.1009;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;2;-2672.707,-16.52525;Inherit;False;1068.148;744.2112;Calculating Fractal;4;17;31;29;30;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2038.062,553.9854;Float;False;Property;_Threshold;Threshold;1;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;16;-2030.562,480.9855;Float;False;Property;_MaxIter;MaxIter;0;0;Create;True;0;0;0;False;0;False;0;250;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1984,320;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;24;-1846.262,456.1854;Float;False;float2 r = UV@$int step = 0@$for (int i = 0@ i < MaxIter@ i++) ${$	if (length(r) > Threshold) $		break@$	$	r = mul( float2x2(r.x,-r.y,r.y,r.x) , r) + UV@$	step++@$}$return (float)step/(float)MaxIter@;1;Create;3;True;UV;FLOAT2;0,0;In;;Float;False;True;MaxIter;INT;0;In;;Float;False;True;Threshold;FLOAT;0;In;;Float;False;Mandlebrot;True;False;0;;False;3;0;FLOAT2;0,0;False;1;INT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1536,304;Float;False;Constant;_HueScale;HueScale;2;0;Create;True;0;0;0;False;0;False;0.9;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-1536,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1376,320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1392,240;Float;False;Constant;_HueOffset;HueOffset;3;0;Create;True;0;0;0;False;0;False;0.9;0.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-1216,304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-1042.276,423.2775;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;18;-892.276,422.2775;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.HSVToRGBNode;19;-752,416;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;27;-752,240;Inherit;False;Property;_Tint;Tint;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StickyNoteNode;29;-2304,480;Inherit;False;233;126;MaxIter;;0,0,0,1;The amount of iterations used to calculate the mandlebrot fractal thus affecting overall detail.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;30;-2288,624;Inherit;False;226;100;Threshold;;0,0,0,1;Sets how deep is to calculate the fractal.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;31;-2464,352;Inherit;False;228;110;Center;;0,0,0,1;Define the center point for the fractal generation.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;32;-3070.767,137.5635;Inherit;False;181;100;Zoom Base;;0,0,0,1;Base zoom for the fractal animation.;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-505.04,394.0304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StickyNoteNode;33;-270.8231,271.6676;Inherit;False;253;111;ASE Fractal MaxIter;;0.02830189,0.02830189,0.02830189,1;This sample proceduraly creates an animated 2D Mandlebrot fractal.;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-275,395;Float;False;True;-1;2;ASEMaterialInspector;100;5;AmplifyShaderPack/2D Fractal;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;RenderType=Opaque=RenderType;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3312.468,-9.701435;Inherit;False;614.0259;736.254;Animating Zoom;0;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;11;-1585.095,-17.20109;Inherit;False;1280.354;744.5106;Coloring the Fractal;0;;0,0,0,1;0;0
WireConnection;8;0;4;3
WireConnection;8;1;3;0
WireConnection;8;2;5;0
WireConnection;12;0;6;0
WireConnection;12;1;7;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;13;0;10;0
WireConnection;13;1;12;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;24;0;17;0
WireConnection;24;1;16;0
WireConnection;24;2;15;0
WireConnection;22;0;24;0
WireConnection;26;0;28;0
WireConnection;26;1;22;0
WireConnection;23;0;20;0
WireConnection;23;1;26;0
WireConnection;21;0;23;0
WireConnection;21;1;22;0
WireConnection;21;2;22;0
WireConnection;18;0;21;0
WireConnection;19;0;18;0
WireConnection;19;1;18;1
WireConnection;19;2;18;2
WireConnection;25;0;27;0
WireConnection;25;1;19;0
WireConnection;0;0;25;0
ASEEND*/
//CHKSM=85ED4A094366363F019FE0DF0340EDDDA26A4DA9