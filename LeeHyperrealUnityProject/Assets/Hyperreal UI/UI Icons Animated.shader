// Upgrade NOTE: upgraded instancing buffer 'UIIconsAnimated' to new syntax.

// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI Icons Animated"
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

        _OrbTexture("Orb Texture", 2D) = "white" {}
        _iconburnmask("icon burn mask", 2D) = "white" {}
        _firespeedXYonly(" fire speed XY only", Vector) = (0,-0.5,0,0)
        _noisescale("noise scale", Range( 0 , 30)) = 15.07
        _burnstrength("burn strength", Range( 0 , 5)) = 1
        _burncolor("burn color", Color) = (1,1,1,1)
        _emissionstrength("emission strength", Range( 0 , 1)) = 0
        [HideInInspector] _texcoord( "", 2D ) = "white" {}

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

        
        Pass
        {
            Name "Default"
        CGPROGRAM
            
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
                
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;

            uniform float4 _burncolor;
            uniform float2 _firespeedXYonly;
            uniform float _noisescale;
            uniform sampler2D _iconburnmask;
            uniform float _burnstrength;
            uniform sampler2D _OrbTexture;
            UNITY_INSTANCING_BUFFER_START(UIIconsAnimated)
            	UNITY_DEFINE_INSTANCED_PROP(float4, _iconburnmask_ST)
#define _iconburnmask_ST_arr UIIconsAnimated
            	UNITY_DEFINE_INSTANCED_PROP(float4, _OrbTexture_ST)
#define _OrbTexture_ST_arr UIIconsAnimated
            	UNITY_DEFINE_INSTANCED_PROP(float, _emissionstrength)
#define _emissionstrength_arr UIIconsAnimated
            UNITY_INSTANCING_BUFFER_END(UIIconsAnimated)
            float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
            float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
            float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
            float snoise( float2 v )
            {
            	const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
            	float2 i = floor( v + dot( v, C.yy ) );
            	float2 x0 = v - i + dot( i, C.xx );
            	float2 i1;
            	i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
            	float4 x12 = x0.xyxy + C.xxzz;
            	x12.xy -= i1;
            	i = mod2D289( i );
            	float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
            	float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
            	m = m * m;
            	m = m * m;
            	float3 x = 2.0 * frac( p * C.www ) - 1.0;
            	float3 h = abs( x ) - 0.5;
            	float3 ox = floor( x + 0.5 );
            	float3 a0 = x - ox;
            	m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
            	float3 g;
            	g.x = a0.x * x0.x + h.x * x0.y;
            	g.yz = a0.yz * x12.xz + h.yz * x12.yw;
            	return 130.0 * dot( m, g );
            }
            

            
            v2f vert(appdata_t v )
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                

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

                float4 color42 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
                float4 appendResult140 = (float4(( _firespeedXYonly.x * (0.975 + (_SinTime.z - -1.0) * (1.025 - 0.975) / (1.0 - -1.0)) ) , _firespeedXYonly.y , 0.0 , 0.0));
                float2 texCoord28 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
                float2 panner24 = ( 1.0 * _Time.y * appendResult140.xy + texCoord28);
                float simplePerlin2D32 = snoise( panner24*_noisescale );
                simplePerlin2D32 = simplePerlin2D32*0.5 + 0.5;
                float blendOpSrc36 = simplePerlin2D32;
                float blendOpDest36 = simplePerlin2D32;
                float4 temp_cast_1 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest36) / max( blendOpSrc36, 0.00001) ) ) ))).xxxx;
                float4 temp_output_1_0_g9 = temp_cast_1;
                float4 color41 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
                float4 temp_output_2_0_g9 = color41;
                float temp_output_11_0_g9 = distance( temp_output_1_0_g9 , temp_output_2_0_g9 );
                float4 lerpResult21_g9 = lerp( color42 , temp_output_1_0_g9 , saturate( ( ( temp_output_11_0_g9 - 1.0 ) / max( 0.0 , 1E-05 ) ) ));
                float4 temp_output_40_0 = lerpResult21_g9;
                float4 temp_output_1_0_g10 = temp_output_40_0;
                float4 color46 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
                float4 temp_output_2_0_g10 = color46;
                float temp_output_11_0_g10 = distance( temp_output_1_0_g10 , temp_output_2_0_g10 );
                float4 lerpResult21_g10 = lerp( _burncolor , temp_output_1_0_g10 , saturate( ( ( temp_output_11_0_g10 - 0.7 ) / max( 0.0 , 1E-05 ) ) ));
                float4 _iconburnmask_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_iconburnmask_ST_arr, _iconburnmask_ST);
                float2 uv_iconburnmask = IN.texcoord.xy * _iconburnmask_ST_Instance.xy + _iconburnmask_ST_Instance.zw;
                float4 tex2DNode22 = tex2D( _iconburnmask, uv_iconburnmask );
                float4 temp_cast_2 = (( tex2DNode22.a * 1.0 )).xxxx;
                float4 temp_cast_3 = (0.0).xxxx;
                float4 temp_cast_4 = (1.0).xxxx;
                float4 clampResult127 = clamp( ( lerpResult21_g10 - temp_cast_2 ) , temp_cast_3 , temp_cast_4 );
                float4 _OrbTexture_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_OrbTexture_ST_arr, _OrbTexture_ST);
                float2 uv_OrbTexture = IN.texcoord.xy * _OrbTexture_ST_Instance.xy + _OrbTexture_ST_Instance.zw;
                float4 tex2DNode1 = tex2D( _OrbTexture, uv_OrbTexture );
                float _emissionstrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_emissionstrength_arr, _emissionstrength);
                

                half4 color = ( ( ( clampResult127 * _burnstrength ) + tex2DNode1 ) * _emissionstrength_Instance );

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
Version=19201
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-859.3862,213.7567;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;32;-110.5864,389.2569;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;24;-508.5504,335.81;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;36;176.8362,329.7607;Inherit;False;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;183.4443,-43.1997;Inherit;False;Constant;_Color3;Color 3;2;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;42;137.9442,144.0003;Inherit;False;Constant;_Color4;Color 4;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;544.8442,446.9003;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;385.8436,-295.3998;Inherit;False;Constant;_Color5;Color 5;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;40;477.2439,56.90017;Inherit;False;Replace Color;-1;;9;896dccb3016c847439def376a728b869;1,12,0;5;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-759.5494,-851.3073;Inherit;False;Constant;_Float6;Float 6;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-547.6496,-853.9069;Inherit;False;Constant;_Float8;Float 6;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;85;132.251,-449.6081;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;86;412.7515,-547.1082;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;87;-298.5487,-986.5081;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-512.1955,-143.28;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-445.3182,-417.5385;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;5.756866,-722.2929;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;258.5757,-917.9803;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;127;-308.4243,-719.9803;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;128;206.576,-212.9802;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;126;561.8784,-953.9037;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;477.4882,-776.2101;Inherit;True;Property;_iconburnmask;icon burn mask;1;0;Create;True;0;0;0;False;0;False;-1;73e1df5b705e7524e9f64771191e6608;3b061c0b580e3f240b0eb7f32145ed82;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1019.381,-332.3546;Inherit;True;Property;_OrbTexture;Orb Texture;0;0;Create;True;0;0;0;False;0;False;-1;9f25085223a9a174e88249e2b5cd503a;6e3c8220e7fad6042af7d84fd4db5071;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-706.3126,-628.9069;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-492.2734,-626.5457;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1007.878,-614.343;Inherit;False;Property;_burnstrength;burn strength;4;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;45;830.4437,-127.6999;Inherit;False;Replace Color;-1;;10;896dccb3016c847439def376a728b869;1,12,0;5;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;48;817.4435,222.0001;Inherit;False;Constant;_Float4;Float 4;2;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;682.2435,-325.2998;Inherit;False;Property;_burncolor;burn color;5;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-461.9856,716.9567;Inherit;False;Property;_noisescale;noise scale;3;0;Create;True;0;0;0;False;0;False;15.07;17.5;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;134;-1173.501,693.668;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-1149.501,880.668;Inherit;False;Constant;_Float9;Float 5;8;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-1169.501,964.668;Inherit;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;0;False;0;False;0.975;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1191.501,1030.668;Inherit;False;Constant;_Float7;Float 5;8;0;Create;True;0;0;0;False;0;False;1.025;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-599.501,519.668;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;135;-876.501,828.668;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-879.501,557.668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-1229.823,453.0177;Inherit;False;Property;_firespeedXYonly; fire speed XY only;2;0;Create;True;0;0;0;False;0;False;0,-0.5;0.25,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;132;10.71829,-608.7729;Inherit;False;InstancedProperty;_emissionstrength;emission strength;6;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;145;-402.4241,105.4243;Inherit;False;Constant;_Color6;Color 6;7;0;Create;True;0;0;0;False;0;False;0.8396226,0.8396226,0.8396226,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;129;-218.4982,169.8019;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;146;-587.1279,98.42796;Inherit;False;Constant;_Float10;Float 10;7;0;Create;True;0;0;0;False;0;False;0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-294.5785,-163.0338;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-247.963,-427.9933;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;141;-13,-318;Float;False;True;-1;2;ASEMaterialInspector;0;3;UI Icons Animated;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;3;1;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;True;0;True;_ColorMask;False;False;False;False;False;False;False;True;True;0;True;_Stencil;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilOp;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;0;True;unity_GUIZTestMode;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;32;0;24;0
WireConnection;32;1;34;0
WireConnection;24;0;28;0
WireConnection;24;2;140;0
WireConnection;36;0;32;0
WireConnection;36;1;32;0
WireConnection;40;1;36;0
WireConnection;40;2;41;0
WireConnection;40;3;42;0
WireConnection;40;4;43;0
WireConnection;85;0;128;0
WireConnection;85;1;22;4
WireConnection;86;0;85;0
WireConnection;86;1;22;4
WireConnection;87;0;86;0
WireConnection;87;1;84;0
WireConnection;87;2;83;0
WireConnection;60;0;130;0
WireConnection;60;1;1;4
WireConnection;77;0;88;0
WireConnection;77;1;1;0
WireConnection;58;0;45;0
WireConnection;58;1;125;0
WireConnection;125;0;22;4
WireConnection;125;1;126;0
WireConnection;127;0;58;0
WireConnection;127;1;84;0
WireConnection;127;2;83;0
WireConnection;128;0;40;0
WireConnection;128;2;129;0
WireConnection;88;0;127;0
WireConnection;88;1;89;0
WireConnection;130;0;87;0
WireConnection;130;1;89;0
WireConnection;45;1;40;0
WireConnection;45;2;46;0
WireConnection;45;3;47;0
WireConnection;45;4;48;0
WireConnection;140;0;139;0
WireConnection;140;1;27;2
WireConnection;135;0;134;3
WireConnection;135;1;138;0
WireConnection;135;3;136;0
WireConnection;135;4;137;0
WireConnection;139;0;27;1
WireConnection;139;1;135;0
WireConnection;133;0;132;0
WireConnection;133;1;60;0
WireConnection;131;0;77;0
WireConnection;131;1;132;0
WireConnection;141;0;131;0
ASEEND*/
//CHKSM=5C6BDA0374F9A8E1BF3C0AA6A4A6D50C23A5CD19