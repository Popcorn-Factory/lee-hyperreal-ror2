// Upgrade NOTE: upgraded instancing buffer 'Broken_Twist' to new syntax.

// Made with Amplify Shader Editor v1.9.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Broken_Twist"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        _NormalTex("NormalTex", 2D) = "white" {}
        _NormalIntensity("NormalIntensity", Range( 0 , 59)) = -50
        _NormalV("NormalV", Float) = 0
        _NormalU("NormalU", Float) = 0
        _TextureSample0("Texture Sample 0", 2D) = "white" {}
        _TextureSample1("Texture Sample 0", 2D) = "white" {}

    }

    SubShader
    {
		LOD 0

        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

        Stencil
        {
        	Ref [_Stencil]
        	ReadMask [_StencilReadMask]
        	WriteMask [_StencilWriteMask]
        	Comp [_StencilComp]
        	Pass [_StencilOp]
        }


        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]

        GrabPass{ }

        Pass
        {
            Name "Default"
        CGPROGRAM
            #if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
            #define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
            #else
            #define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
            #endif

            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP

            #include "UnityShaderVariables.cginc"
            #pragma multi_compile_instancing


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
                float4 ase_texcoord3 : TEXCOORD3;
                float4 ase_texcoord4 : TEXCOORD4;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
            uniform sampler2D _TextureSample0;
            uniform sampler2D _NormalTex;
            uniform float _NormalU;
            uniform float _NormalV;
            uniform float _NormalIntensity;
            uniform sampler2D _TextureSample1;
            UNITY_INSTANCING_BUFFER_START(Broken_Twist)
            	UNITY_DEFINE_INSTANCED_PROP(float4, _NormalTex_ST)
#define _NormalTex_ST_arr Broken_Twist
            UNITY_INSTANCING_BUFFER_END(Broken_Twist)
            inline float4 ASE_ComputeGrabScreenPos( float4 pos )
            {
            	#if UNITY_UV_STARTS_AT_TOP
            	float scale = -1.0;
            	#else
            	float scale = 1.0;
            	#endif
            	float4 o = pos;
            	o.y = pos.w * 0.5f;
            	o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
            	return o;
            }
            

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
                OUT.ase_texcoord3.xyz = ase_worldPos;
                float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
                float4 screenPos = ComputeScreenPos(ase_clipPos);
                OUT.ase_texcoord4 = screenPos;
                
                
                //setting value to unused interpolator channels and avoid initialization warnings
                OUT.ase_texcoord3.w = 0;

                v.vertex.xyz +=  float3( 0, 0, 0 ) ;

                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord = v.texcoord;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN ) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                float3 ase_worldPos = IN.ase_texcoord3.xyz;
                float4 temp_cast_0 = (distance( _WorldSpaceCameraPos , ase_worldPos )).xxxx;
                float4 appendResult98 = (float4(1.0 , 1.0 , 0.0 , 0.0));
                float4 lerpResult86 = lerp( temp_cast_0 , appendResult98 , 1.0);
                float temp_output_110_0 = floor( ( _Time.y / 0.2 ) );
                float2 temp_cast_1 = (temp_output_110_0).xx;
                float dotResult4_g7 = dot( temp_cast_1 , float2( 12.9898,78.233 ) );
                float lerpResult10_g7 = lerp( 0.5 , 1.0 , frac( ( sin( dotResult4_g7 ) * 43758.55 ) ));
                float2 temp_cast_2 = (temp_output_110_0).xx;
                float dotResult4_g8 = dot( temp_cast_2 , float2( 12.9898,78.233 ) );
                float lerpResult10_g8 = lerp( 0.5 , 1.0 , frac( ( sin( dotResult4_g8 ) * 43758.55 ) ));
                float4 appendResult134 = (float4(lerpResult10_g7 , lerpResult10_g8 , 0.0 , 0.0));
                float2 temp_cast_4 = (temp_output_110_0).xx;
                float dotResult4_g6 = dot( temp_cast_4 , float2( 12.9898,78.233 ) );
                float lerpResult10_g6 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g6 ) * 43758.55 ) ));
                float temp_output_111_0 = ( _Time.x * lerpResult10_g6 );
                float4 appendResult123 = (float4(temp_output_111_0 , ( temp_output_111_0 * 1.3 ) , 0.0 , 0.0));
                float2 texCoord112 = IN.texcoord.xy * ( appendResult134 * 0.6 ).xy + appendResult123.xy;
                float4 screenPos = IN.ase_texcoord4;
                float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
                float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
                float4 ScreenUV16 = ( ase_grabScreenPosNorm / ase_grabScreenPosNorm.a );
                float2 appendResult12 = (float2(_NormalU , _NormalV));
                float4 _NormalTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalTex_ST_arr, _NormalTex_ST);
                float2 uv_NormalTex = IN.texcoord.xy * _NormalTex_ST_Instance.xy + _NormalTex_ST_Instance.zw;
                float2 panner9 = ( 1.0 * _Time.y * appendResult12 + uv_NormalTex);
                float4 Normal15 = ( tex2D( _NormalTex, panner9 ) * ( _NormalIntensity / distance( _WorldSpaceCameraPos , ase_worldPos ) ) );
                float2 texCoord135 = IN.texcoord.xy * ( appendResult134 * 0.75 ).xy + ( 0.75 * appendResult123 ).xy;
                float2 appendResult44 = (float2(( ( (0.95 + (tex2D( _TextureSample0, texCoord112 ).r - 0.0) * (1.05 - 0.95) / (1.0 - 0.0)) * (ScreenUV16).x ) + Normal15 ).r , ( (0.95 + (tex2D( _TextureSample1, texCoord135 ).r - 0.0) * (1.05 - 0.95) / (1.0 - 0.0)) * (ScreenUV16).y )));
                float4 screenColor2 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( lerpResult86 * float4( appendResult44, 0.0 , 0.0 ) ).xy);
                

                half4 color = screenColor2;

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
    CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19200
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2943.12,-629.1853;Inherit;False;0;4;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;12;-2870.391,-354.2229;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;59;-2586.597,-262.5145;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;61;-2418.197,-82.00134;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-2323.722,-357.6477;Inherit;False;Property;_NormalIntensity;NormalIntensity;1;0;Create;True;0;0;0;False;0;False;-50;0;0;59;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;60;-2251.993,-215.1848;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;1;-3115.943,-1034.796;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-2550.18,-511.2222;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;3;-2777.668,-973.1945;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;4;-2273.922,-597.8491;Inherit;True;Property;_NormalTex;NormalTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-2014.186,-284.9043;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1904.094,-550.1935;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;80;-1154.403,-1222.329;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;81;-1107.162,-998.968;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;82;-825.709,-1166.134;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1076.281,-272.5533;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2986.99,-75.77048;Inherit;False;Property;_Chromaticdispersion;Chromatic dispersion;5;0;Create;True;0;0;0;False;0;False;0;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;26;-841.7139,270.6107;Inherit;False;Global;_GrabScreen2;Grab Screen 2;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;22;-844.9141,69.0107;Inherit;False;Global;_GrabScreen1;Grab Screen 1;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-2954.143,32.91621;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-1230.215,14.83849;Inherit;False;16;ScreenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-998.9141,64.0107;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1750.502,367.328;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1717.693,9.472983;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;49;-2064.694,-103.5421;Inherit;False;InstancedProperty;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1565.038,350.7382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1226.815,89.43849;Inherit;False;15;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1223.015,301.4385;Inherit;False;15;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-556.3643,-36.67538;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-1891.266,171.6998;Inherit;False;35;Chromaticdispersion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1382.704,346.0553;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-1559.492,55.44235;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-995.7139,265.6107;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-2378.838,-8.302074;Inherit;False;Chromaticdispersion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-1227.015,216.4385;Inherit;False;16;ScreenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1381.284,132.6189;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2371.608,-977.6909;Inherit;False;ScreenUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1724.572,-548.2921;Inherit;False;Normal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;2;-622.4096,-283.2668;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-3068.391,-368.2228;Inherit;False;Property;_NormalU;NormalU;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;42;-1523.617,-452.7646;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;-1514.934,-143.5352;Inherit;False;False;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-1816.495,-339.5804;Inherit;False;16;ScreenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1283.095,-308.0587;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1387.326,-838.3846;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;-698.0943,-841.6789;Inherit;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-1506.57,-284.3965;Inherit;False;15;Normal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3066.391,-296.2227;Inherit;False;Property;_NormalV;NormalV;2;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-883.0289,-465.7019;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1258.308,-495.1718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-1112.308,-417.1718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-906.799,-821.7737;Inherit;False;Constant;_Float5;Float 5;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-878.1989,-711.2737;Inherit;False;Constant;_Float6;Float 5;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-742.9988,-1073.974;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1159.065,-770.8473;Inherit;False;Property;_Float3;Float 3;7;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;86;-500.0845,-1134.038;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1096.864,-626.898;Inherit;False;Property;_Float4;Float 4;8;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;107;-537.3123,-529.4127;Inherit;True;Property;_TextureSample1;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;48d147b4598f15e4aa801c9bc8fa8d64;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;117;-753.3123,-553.4127;Inherit;False;Constant;_Float8;Float 8;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-725.3123,-488.4127;Inherit;False;Constant;_Float9;Float 8;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;110;21.68774,-366.4127;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;108;-257.3123,-424.4127;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;114;-25.31226,-280.4127;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-162.3123,-236.4127;Inherit;False;Constant;_Float7;Float 7;11;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;126;-388.3123,-296.4127;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-717.3123,-414.4127;Inherit;False;Constant;_Float10;Float 8;11;0;Create;True;0;0;0;False;0;False;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;15.01282,-947.2833;Inherit;False;Constant;_Float13;Float 13;11;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;-370.3123,-878.4127;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;None;48d147b4598f15e4aa801c9bc8fa8d64;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;36;-2651.438,-22.90202;Inherit;False;Property;_ChromaticPower;ChromaticPower;4;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;128;390.9447,-186.7446;Inherit;False;Random Range;-1;;5;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;129;66.9447,20.25537;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;116;-606.3123,-729.4127;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;413.6877,-387.4127;Inherit;False;Constant;_Float12;Float 12;11;0;Create;True;0;0;0;False;0;False;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;109;182.6877,-412.4127;Inherit;False;Random Range;-1;;6;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;130;645.9447,-367.7446;Inherit;False;Random Range;-1;;7;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;131;671.9447,-217.7446;Inherit;False;Random Range;-1;;8;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;456.9447,-299.7446;Inherit;False;Constant;_Float14;Float 14;11;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;519.9447,-228.7446;Inherit;False;Constant;_Float15;Float 14;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;123;442.6877,-702.4127;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;164.9447,-706.7446;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;59.68774,-508.4127;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;324.6877,-527.4127;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-72.0553,-701.7446;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;131.6877,-860.4127;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;134;830.9447,-520.7446;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;165.9447,-607.7446;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;710.9449,-754.7446;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;137;392.9447,-873.7446;Inherit;False;Constant;_Float16;Float 16;11;0;Create;True;0;0;0;False;0;False;0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;651.9449,-851.7446;Inherit;False;Constant;_Float17;Float 16;11;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-707.3123,-359.4127;Inherit;False;Constant;_Float11;Float 8;11;0;Create;True;0;0;0;False;0;False;1.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;142;-204,-129;Float;False;True;-1;2;ASEMaterialInspector;0;3;Broken_Twist;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;60;0;59;0
WireConnection;60;1;61;0
WireConnection;9;0;8;0
WireConnection;9;2;12;0
WireConnection;3;0;1;0
WireConnection;3;1;1;4
WireConnection;4;1;9;0
WireConnection;62;0;6;0
WireConnection;62;1;60;0
WireConnection;5;0;4;0
WireConnection;5;1;62;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;44;0;7;0
WireConnection;44;1;95;0
WireConnection;26;0;25;0
WireConnection;22;0;21;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;29;0
WireConnection;32;0;38;0
WireConnection;32;1;33;0
WireConnection;27;0;2;1
WireConnection;27;1;22;2
WireConnection;27;2;26;3
WireConnection;27;3;2;4
WireConnection;34;0;38;0
WireConnection;34;1;32;0
WireConnection;31;0;30;0
WireConnection;31;1;38;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;25;2;34;0
WireConnection;35;0;36;0
WireConnection;29;0;31;0
WireConnection;29;1;38;0
WireConnection;16;0;3;0
WireConnection;15;0;5;0
WireConnection;2;0;56;0
WireConnection;42;0;17;0
WireConnection;43;0;17;0
WireConnection;7;0;93;0
WireConnection;7;1;18;0
WireConnection;56;0;86;0
WireConnection;56;1;44;0
WireConnection;93;0;116;0
WireConnection;93;1;42;0
WireConnection;95;0;126;0
WireConnection;95;1;43;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;86;0;82;0
WireConnection;86;1;98;0
WireConnection;86;2;88;0
WireConnection;107;1;135;0
WireConnection;110;0;114;0
WireConnection;114;0;108;2
WireConnection;114;1;115;0
WireConnection;126;0;107;1
WireConnection;126;1;117;0
WireConnection;126;2;118;0
WireConnection;126;3;119;0
WireConnection;126;4;120;0
WireConnection;106;1;112;0
WireConnection;36;1;28;0
WireConnection;36;0;37;1
WireConnection;128;1;129;2
WireConnection;116;0;106;1
WireConnection;116;1;117;0
WireConnection;116;2;118;0
WireConnection;116;3;119;0
WireConnection;116;4;120;0
WireConnection;109;1;110;0
WireConnection;130;1;110;0
WireConnection;130;2;132;0
WireConnection;130;3;133;0
WireConnection;131;1;110;0
WireConnection;131;2;132;0
WireConnection;131;3;133;0
WireConnection;123;0;111;0
WireConnection;123;1;124;0
WireConnection;136;0;137;0
WireConnection;136;1;123;0
WireConnection;111;0;108;1
WireConnection;111;1;109;0
WireConnection;124;0;111;0
WireConnection;124;1;122;0
WireConnection;135;0;138;0
WireConnection;135;1;136;0
WireConnection;112;0;139;0
WireConnection;112;1;123;0
WireConnection;134;0;130;0
WireConnection;134;1;131;0
WireConnection;138;0;134;0
WireConnection;138;1;137;0
WireConnection;139;0;134;0
WireConnection;139;1;141;0
WireConnection;142;0;2;0
ASEEND*/
//CHKSM=38A1B114174CBE30777C20112FF1F54114CDBC65