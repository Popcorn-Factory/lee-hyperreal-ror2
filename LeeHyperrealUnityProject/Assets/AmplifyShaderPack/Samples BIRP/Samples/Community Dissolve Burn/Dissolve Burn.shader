// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Community/Dissolve Burn"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_DisolveGuide("Disolve Guide", 2D) = "white" {}
		_BurnRamp("Burn Ramp", 2D) = "white" {}
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_Intensity("Intensity", Float) = 0
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		[Toggle]_AnimateDissolve("Animate Dissolve", Float) = 0
		_Dissolvescrollspeed("Dissolve scroll speed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _AnimateDissolve;
		uniform float _DissolveAmount;
		uniform sampler2D _DisolveGuide;
		uniform float2 _Dissolvescrollspeed;
		uniform sampler2D _BurnRamp;
		uniform float4 _Color0;
		uniform float _Intensity;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 panner156 = ( 1.0 * _Time.y * _Dissolvescrollspeed + i.uv_texcoord);
			float4 tex2DNode2 = tex2D( _DisolveGuide, panner156 );
			float temp_output_73_0 = ( (-0.6 + (( 1.0 - (( _AnimateDissolve )?( saturate( _SinTime.y ) ):( ( _DissolveAmount * (0.75 + (_SinTime.w - -1.0) * (1.0 - 0.75) / (1.0 - -1.0)) ) )) ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2DNode2.r );
			float clampResult113 = clamp( (-4.0 + (temp_output_73_0 - 0.0) * (4.0 - -4.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_130_0 = ( 1.0 - clampResult113 );
			float2 appendResult115 = (float2(temp_output_130_0 , 0.0));
			o.Emission = ( ( ( temp_output_130_0 * tex2D( _BurnRamp, appendResult115 ) ) * _Color0 ) * _Intensity ).rgb;
			o.Alpha = 1;
			clip( temp_output_73_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.SinTimeNode;137;-2293.961,409.7205;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;138;-2150.961,430.7205;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;139;-1980.96,320.2403;Inherit;False;Property;_AnimateDissolve;Animate Dissolve;8;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-1756.464,323.082;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;111;-1590.941,324.8665;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1708.069,486.8878;Inherit;True;Property;_DisolveGuide;Disolve Guide;3;0;Create;True;0;0;0;False;0;False;-1;None;4bd6618be485426998392fc8a5e9bc18;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-1384.195,322.3685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;112;-1212.462,104.4556;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;113;-998.247,104.2204;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;-840.8419,104.2659;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;115;-666.1989,186.5039;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;114;-526.2758,160.6235;Inherit;True;Property;_BurnRamp;Burn Ramp;4;0;Create;True;0;0;0;False;0;False;-1;None;e2216e52e64b498b961c693f564d4d0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;136;-82.56501,173.5112;Inherit;False;Property;_Color0;Color 0;7;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;2.758805,1.039968,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-223.6027,99.9725;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;153;-2120.2,695.39;Inherit;False;1260.469;416.3964;Example disolve with smoothstep;10;149;147;148;146;145;144;152;151;150;143;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;137.3729,101.5387;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;134;272.4806,187.9861;Inherit;False;Property;_Intensity;Intensity;6;0;Create;True;0;0;0;False;0;False;0;11.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;140;48,384;Inherit;False;566.545;140.4858;ASE/Community/Dissolve Burn;;0,0,0,1;Created by $The Four Headed Cat fourheadedcat - www.twitter.com/fourheadedcat;0;0
Node;AmplifyShaderEditor.StickyNoteNode;141;-521.9326,36.87599;Inherit;False;253.5562;103;Burn Effect - Emission;;0,0,0,1;Burn Ramp;0;0
Node;AmplifyShaderEditor.StickyNoteNode;142;-1932.506,494.1086;Inherit;False;217;119.1;Disolve Guide;;0.009433985,0.009433985,0.009433985,1;Disolve Guide is our opacity mask used to guide the dissolve thru alpha ;0;0
Node;AmplifyShaderEditor.StickyNoteNode;143;-2074.407,951.7864;Inherit;False;260.6453;137.3962;;;0,0,0,1;Sine Time gives us an ossilating value between -1 and 1.  ;0;0
Node;AmplifyShaderEditor.StickyNoteNode;150;-1733.2,934.39;Inherit;False;312;160;;;0,0,0,1;Then we multiply and add to change the range to 0 to 1.5.  Then we create our smoothstep edge values by subtracting 0.5 and 0.47.  This gives us a small 0.03 blending range.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;151;-1397.407,907.2566;Inherit;False;471.7653;187.0736;Smoothstep Node;;0,0,0,1;Using the Min and Max values, we can control where the blend happens.  $$Smoothstep is a math formula for taking a linear input and applying a slow-in and slow-out curve to it.$$It's most commonly used to smoothly turn things on or off.;0;0
Node;AmplifyShaderEditor.StickyNoteNode;152;-1216,752;Inherit;False;380;144;;;0,0,0,1;The animated Edge values coming into the Smoothstep node create a disolve effect from our Disolve Guide texture, because we're sliding the blend range back and forth.;0;0
Node;AmplifyShaderEditor.SinTimeNode;144;-2075.2,815.39;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-1875.2,839.39;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-1725.2,839.39;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;148;-1567.2,837.39;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;147;-1570.2,745.39;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;149;-1399.2,791.39;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;154;-1008,224;Inherit;False;313;136;;;0,0,0,1;Here we take the X component of our UV which is the left position in our burn ramp texture. We take the dissolve amount value to pan into color black shutting off emission;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;410.7635,99.8139;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;131;244.2129,-107.6356;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;abfd39fa1d6a42ba9b322e4301333932;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;240.8442,-304.386;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;85e3723e62d44f758723754190c67911;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StickyNoteNode;155;-1485.573,211.9426;Inherit;False;203;100;;;0,0,0,1;Add node into UV is our coordinates for offset ;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;639.386,79.88044;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AmplifyShaderPack/Community/Dissolve Burn;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;3;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;0;4;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;1;False;;1;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.PannerNode;156;-2258.925,593.6451;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;157;-2547.925,519.6451;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;158;-2519.925,708.6451;Inherit;False;Property;_Dissolvescrollspeed;Dissolve scroll speed;9;0;Create;True;0;0;0;False;0;False;0,0;0.5,-2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;4;-2398.524,242.7163;Float;False;Property;_DissolveAmount;Dissolve Amount;5;0;Create;True;0;0;0;False;0;False;0;0.6147826;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-2015.968,174.2909;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;160;-2288.968,-15.70911;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;161;-1763.968,46.29089;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.75;False;4;FLOAT;1;False;1;FLOAT;0
WireConnection;138;0;137;2
WireConnection;139;0;163;0
WireConnection;139;1;138;0
WireConnection;71;0;139;0
WireConnection;111;0;71;0
WireConnection;2;1;156;0
WireConnection;73;0;111;0
WireConnection;73;1;2;1
WireConnection;112;0;73;0
WireConnection;113;0;112;0
WireConnection;130;0;113;0
WireConnection;115;0;130;0
WireConnection;114;1;115;0
WireConnection;126;0;130;0
WireConnection;126;1;114;0
WireConnection;135;0;126;0
WireConnection;135;1;136;0
WireConnection;145;0;144;2
WireConnection;146;0;145;0
WireConnection;148;0;146;0
WireConnection;147;0;146;0
WireConnection;149;0;2;1
WireConnection;149;1;147;0
WireConnection;149;2;148;0
WireConnection;133;0;135;0
WireConnection;133;1;134;0
WireConnection;0;0;78;0
WireConnection;0;1;131;0
WireConnection;0;2;133;0
WireConnection;0;10;73;0
WireConnection;156;0;157;0
WireConnection;156;2;158;0
WireConnection;163;0;4;0
WireConnection;163;1;161;0
WireConnection;161;0;160;4
ASEEND*/
//CHKSM=AAD67CD3CB6054F9FED5A2904E52B9D0CC2DF7FE