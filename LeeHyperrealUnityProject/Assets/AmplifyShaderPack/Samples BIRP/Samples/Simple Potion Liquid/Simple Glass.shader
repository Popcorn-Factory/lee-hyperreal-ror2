// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Simple Glass"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)]_Cull("Render Face", Int) = 2
		_Color("Color", Color) = (0,0,0,0)
		_SpecularStrength("Specular Strength", Range( 0 , 1)) = 0.04
		_SmoothnessStrength("Smoothness Strength", Range( 0 , 1)) = 0
		_GlassChromaticAberration("Chromatic Aberration", Range( 0 , 0.3)) = 0
		_RefractionIndex("Refraction Index", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_Cull]
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile _ALPHAPREMULTIPLY_ON
		#pragma surface surf StandardSpecular keepalpha finalcolor:RefractionF addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
		};

		uniform float _GlassChromaticAberration;
		uniform int _Cull;
		uniform float4 _Color;
		uniform half _SpecularStrength;
		uniform float _SmoothnessStrength;
		uniform sampler2D _GrabTexture;
		uniform half _RefractionIndex;

		inline float4 Refraction( Input i, SurfaceOutputStandardSpecular o, float indexOfRefraction, float chomaticAberration ) {
			float3 worldNormal = o.Normal;
			float4 screenPos = i.screenPos;
			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif
			float halfPosW = screenPos.w * 0.5;
			screenPos.y = ( screenPos.y - halfPosW ) * _ProjectionParams.x * scale + halfPosW;
			#if SHADER_API_D3D9 || SHADER_API_D3D11
				screenPos.w += 0.00000000001;
			#endif
			float2 projScreenPos = ( screenPos / screenPos.w ).xy;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 refractionOffset = ( indexOfRefraction - 1.0 ) * mul( UNITY_MATRIX_V, float4( worldNormal, 0.0 ) ) * ( 1.0 - dot( worldNormal, worldViewDir ) );
			float2 cameraRefraction = float2( refractionOffset.x, refractionOffset.y );
			float4 redAlpha = tex2D( _GrabTexture, ( projScreenPos + cameraRefraction ) );
			float green = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 - chomaticAberration ) ) ) ).g;
			float blue = tex2D( _GrabTexture, ( projScreenPos + ( cameraRefraction * ( 1.0 + chomaticAberration ) ) ) ).b;
			return float4( redAlpha.r, green, blue, redAlpha.a );
		}

		void RefractionF( Input i, SurfaceOutputStandardSpecular o, inout half4 color )
		{
			#ifdef UNITY_PASS_FORWARDBASE
			float RefracionIndex16 = ( 1.0 - _RefractionIndex );
			color.rgb = color.rgb + Refraction( i, o, RefracionIndex16, _GlassChromaticAberration ) * ( 1 - color.a );
			color.a = 1;
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Normal = float3(0,0,1);
			float3 temp_output_6_0 = (_Color).rgb;
			o.Albedo = temp_output_6_0;
			o.Emission = temp_output_6_0;
			half3 temp_cast_0 = (_SpecularStrength).xxx;
			o.Specular = temp_cast_0;
			o.Smoothness = _SmoothnessStrength;
			o.Alpha = _Color.a;
			o.Normal = o.Normal + 0.00001 * i.screenPos * i.worldPos;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.CommentaryNode;3;-1232,192;Inherit;False;789.422;500.8361;Refraction;11;19;18;17;16;15;14;13;5;4;23;24;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1200,432;Half;False;Property;_RefractionIndex;Refraction Index;9;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-912,432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-688,432;Inherit;False;RefracionIndex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-448,0;Float;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2358491,0.2358491,0.2358491,0.222;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StickyNoteNode;5;-1152,592;Inherit;False;198.5707;100;Refraction Distance;;0.009433985,0.009433985,0.009433985,1;HDRP;0;0
Node;AmplifyShaderEditor.WireNode;21;-84.59272,148.5614;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;23;-912,320;Inherit;False;228;100;Refraction Color;;0,0,0,1;URP HDRP;0;0
Node;AmplifyShaderEditor.ColorNode;14;-1136,240;Half;False;Property;_RefractionColor;Refraction Color;8;1;[HDR];Create;False;0;0;0;False;0;False;0.2941177,0.2941177,0.2941177,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwizzleNode;13;-912,240;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-688,240;Inherit;False;RefractedColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1136,512;Half;False;Property;_RefractionDistance;Refraction Distance;10;0;Create;False;0;0;0;False;0;False;5;1.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-688,512;Inherit;False;RefractionDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-944,608;Inherit;False;Property;_GlassChromaticAberration;Chromatic Aberration;5;0;Create;False;0;0;0;True;0;False;0;0;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-320,352;Inherit;False;16;RefracionIndex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;-320,432;Inherit;False;4;RefractedColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-352,512;Inherit;False;17;RefractionDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-384,272;Float;False;Property;_SmoothnessStrength;Smoothness Strength;4;0;Create;True;0;0;0;False;0;False;0;0.931;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-384,192;Half;False;Property;_SpecularStrength;Specular Strength;3;0;Create;False;0;0;0;False;0;False;0.04;0.747;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;6;-208,0;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;12;0,-80;Inherit;False;Property;_MaskClipValue;Mask Clip Value;1;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;22;0,-160;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;AmplifyShaderPack/Simple Glass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;True;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;5;False;;10;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;6;-1;0;False;0;0;True;_Cull;-1;0;True;_MaskClipValue;0;0;0;False;0.1;True;_GlassChromaticAberration;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;15;0
WireConnection;16;0;19;0
WireConnection;21;0;7;4
WireConnection;13;0;14;0
WireConnection;4;0;13;0
WireConnection;17;0;18;0
WireConnection;6;0;7;0
WireConnection;0;0;6;0
WireConnection;0;2;6;0
WireConnection;0;3;8;0
WireConnection;0;4;9;0
WireConnection;0;8;11;0
WireConnection;0;9;21;0
ASEEND*/
//CHKSM=DC9825F717D77FCD3BCEB02097F74A1E07C8362F