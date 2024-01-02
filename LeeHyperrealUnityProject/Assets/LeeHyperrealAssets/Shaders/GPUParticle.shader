Shader "Unlit/GPUParticle"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" {}
		_Intensity ("颜色强度", Range(0, 50)) = 1
		_R_Intensity ("R强度", Range(0, 50)) = 1
		_G_Intensity ("G强度", Range(0, 50)) = 1
		_B_Intensity ("B强度", Range(0, 50)) = 1
		_Alpha_Intensity ("Alpha 强度", Range(0, 20)) = 1
		[HideInInspector] _Progress ("Progress", Range(0.0, 1.0)) = 0.0
		[HideInInspector] _ColorIntensity ("Progress", Range(0, 10)) = 1
		[HideInInspector] _VelocityScale ("Velocity Scale", Range(0, 10)) = 1
		[HideInInspector] _AspectRatio ("As ratio", Range(0, 10)) = 1
		[Enum(UnityEngine.Rendering.ParticleBlendModes)] _BlendMode ("Blend Mode", Float) = 0
		[HideInInspector] _ZWrite ("Blend Mode", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _Src ("Source", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _Dst ("Destination", Float) = 6
		[HideInInspector] _ColorMask ("颜色写入掩码", Float) = 15
    }
    SubShader
    {
        Tags { "DisableBatching" = "true" "MirrorType" = "GPUParticle" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        name "Base"

            Blend [_Src] [_Dst]

        
        ZWrite [_ZWrite]
        ColorMask [_ColorMask]
        Pass{
            CGPROGRAM
            #define cmp - 
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma shader_feature S_BILLBOARD
            #pragma shader_feature BILLBOARD
            #pragma shader_feature DISABLE_MAIN
            #include "UnityCG.cginc"

            float _ColorIntensity;
			float _Intensity;
			float _R_Intensity;
			float _G_Intensity;
			float _B_Intensity;
			float _Alpha_Intensity;
            sampler2D _MainTex;
            float _Progress;

            float _VelocityScale;
            float _AspectRatio;
            float4 _MainTex_ST;
            struct v2f
            {
                float4 texcoord : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 svPOS : SV_POSITION;
            };

            

            v2f vert (appdata_full v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f,o);
                float4 r0 = float4(0,0,0,0);
                float4 r1 = float4(0,0,0,0);
                float4 r2 = float4(0,0,0,0);
                
                #if S_BILLBOARD && !TRIANGLE && !ROTATION && !DISABLE_MAIN && !SKYBOX_STAR  && !BILLBOARD && !TS_BILLBOARD && !H_BILLBORD
                    float4 r3 = float4(0,0,0,0);
                    o.texcoord = v.color;
                    o.texcoord1.xy = float2(1,1) + -v.texcoord.xy;
                    r0.xyz = unity_WorldToObject._m01_m11_m21_m31.yzx * unity_MatrixInvV._m02_m12_m22_m32.yyy;
                    r0.xyz = unity_WorldToObject._m00_m10_m20_m30.yzx * unity_MatrixInvV._m02_m12_m22_m32.xxx + r0.xyz;
                    r0.xyz = unity_WorldToObject._m02_m12_m22_m32.yzx * unity_MatrixInvV._m02_m12_m22_m32.zzz + r0.xyz;
                    r0.xyz = unity_WorldToObject._m03_m13_m23_m33.yzx * unity_MatrixInvV._m02_m12_m22_m32.www + r0.xyz;
                    r1.xyz = v.texcoord1.xyz * v.tangent.www;
                    r1.xyz = r1.xyz * _VelocityScale.xxx;
                    r2.xyz = r1.zxy * r0.xyz;
                    r0.xyz = r1.yzx * r0.yzx + -r2.xyz;
                    r0.w = dot(r0.xyz,r0.xyz);
                    r0.w = rsqrt(r0.w);
                    r0.xyz = r0.xyz * r0.www;
                    r0.xyz = r0.xyz * _AspectRatio.xxx;
                    r2.xy = float2(-0.5,-0.5) + v.texcoord.xy;
                    r0.xyz = r2.yyy * r0.xyz;
                    r2.yzw = v.tangent.xyz + -v.normal.xyz;
                    r0.w = v.texcoord2.y + -v.texcoord2.x;
                    r0.w = max(r0.w,9.99999975e-05);
                    r1.w = _Progress + -v.texcoord2.x;
                    r0.w = saturate(r1.w / r0.w);
                    r2.yzw = r0.www * r2.yzw + v.normal.xyz;
                    r3.xyz = v.normal.xyz + -v.vertex.xyz;
                    r3.xyz = r0.www * r3.xyz + v.vertex.xyz;
                    r2.yzw = -r3.xyz + r2.yzw;
                    r2.yzw = r0.www * r2.yzw + r3.xyz;
                    r1.xyz = r1.xyz * r2.xxx + r2.yzw;
                    r0.xyz = r0.xyz * v.texcoord1.www + r1.xyz;
                    r1 = unity_ObjectToWorld._m01_m11_m21_m31 * r0.yyyy;
                    r1 = unity_ObjectToWorld._m00_m10_m20_m30 * r0.xxxx + r1;
                    r0 = unity_ObjectToWorld._m02_m12_m22_m32 * r0.zzzz + r1;
                    r0 = unity_ObjectToWorld._m03_m13_m23_m33 + r0;
                    r1 = UNITY_MATRIX_VP._m01_m11_m21_m31 * r0.yyyy;
                    r1 = UNITY_MATRIX_VP._m00_m10_m20_m30 * r0.xxxx + r1;
                    r1 = UNITY_MATRIX_VP._m02_m12_m22_m32 * r0.zzzz + r1;
                    r0 = UNITY_MATRIX_VP._m03_m13_m23_m33 * r0.wwww + r1;
                    r1.x = _Progress >= v.texcoord2.x;
                    r1.y = v.texcoord2.y >= _Progress;
                    r1.xy = r1.xy ? float2(1,1) : 0;
                    r1.x = r1.x * r1.y;
                    o.svPOS = r1.xxxx * r0;
                #elif BILLBOARD && !TRIANGLE && !ROTATION && !DISABLE_MAIN && !SKYBOX_STAR  && !TS_BILLBOARD && !S_BILLBOARD && !H_BILLBORD
                    o.texcoord = v.color;
                    o.texcoord1.xy = float2(1,1) + -v.texcoord.xy;
                    r0.xyz = v.tangent.xyz + -v.normal.xyz;
                    r0.w = v.texcoord2.y + -v.texcoord2.x;
                    r0.w = max(r0.w,9.99999975e-05);
                    r1.x = _Progress + -v.texcoord2.x;
                    r0.w = saturate(r1.x / r0.w);
                    r0.xyz = r0.www * r0.xyz + v.normal.xyz;
                    r1.xyz = v.normal.xyz + -v.vertex.xyz;
                    r1.xyz = r0.www * r1.xyz + v.vertex.xyz;
                    r0.xyz = -r1.xyz + r0.xyz;
                    r0.xyz = r0.www * r0.xyz + r1.xyz;
                    r1 = unity_ObjectToWorld._m01_m11_m21_m31 * r0.yyyy;
                    r1 = unity_ObjectToWorld._m00_m10_m20_m30 * r0.xxxx + r1;
                    r0 = unity_ObjectToWorld._m02_m12_m22_m32 * r0.zzzz + r1;
                    r0 = unity_ObjectToWorld._m03_m13_m23_m33 + r0;
                    r1 = UNITY_MATRIX_V._m01_m11_m21_m31 * r0.yyyy;
                    r1 = UNITY_MATRIX_V._m00_m10_m20_m30 * r0.xxxx + r1;
                    r1 = UNITY_MATRIX_V._m02_m12_m22_m32 * r0.zzzz + r1;
                    r0 = UNITY_MATRIX_V._m03_m13_m23_m33 * r0.wwww + r1;
                    r1.xy = float2(-0.5,-0.5) + v.texcoord.xy;
                    r1.y = _AspectRatio * r1.y;
                    r2.xy = v.texcoord1.ww * r1.xy;
                    r2.zw = float2(0,0);
                    r0 = -r2 + r0;
                    r1 = UNITY_MATRIX_P._m01_m11_m21_m31 * r0.yyyy;
                    r1 = UNITY_MATRIX_P._m00_m10_m20_m30 * r0.xxxx + r1;
                    r1 = UNITY_MATRIX_P._m02_m12_m22_m32 * r0.zzzz + r1;
                    r0 = UNITY_MATRIX_P._m03_m13_m23_m33 * r0.wwww + r1;
                    r1.x = _Progress >= v.texcoord2.x;
                    r1.y = v.texcoord2.y >= _Progress;
                    r1.xy = r1.xy ? float2(1,1) : 0;
                    r1.x = r1.x * r1.y;
                    o.svPOS = r1.xxxx * r0;
                #elif DISABLE_MAIN && S_BILLBOARD && !TRIANGLE && !ROTATION && !SKYBOX_STAR  && !BILLBOARD && !TS_BILLBOARD && !H_BILLBORD
                    float4 r3 = float4(0,0,0,0);
                    o.texcoord = v.color;
                    r0.xyz = unity_WorldToObject._m01_m11_m21_m31.yzx * unity_MatrixInvV._m02_m12_m22_m32.yyy;
                    r0.xyz = unity_WorldToObject._m00_m10_m20_m30.yzx * unity_MatrixInvV._m02_m12_m22_m32.xxx + r0.xyz;
                    r0.xyz = unity_WorldToObject._m02_m12_m22_m32.yzx * unity_MatrixInvV._m02_m12_m22_m32.zzz + r0.xyz;
                    r0.xyz = unity_WorldToObject._m03_m13_m23_m33.yzx * unity_MatrixInvV._m02_m12_m22_m32.www + r0.xyz;
                    r1.xyz = v.texcoord1.xyz * v.tangent.www;
                    r1.xyz = r1.xyz * _VelocityScale.xxx;
                    r2.xyz = r1.zxy * r0.xyz;
                    r0.xyz = r1.yzx * r0.yzx + -r2.xyz;
                    r0.w = dot(r0.xyz,r0.xyz);
                    r0.w = rsqrt(r0.w);
                    r0.xyz = r0.xyz * r0.www;
                    r0.xyz = r0.xyz * _AspectRatio.xxx;
                    r2.xy = float2(-0.5,-0.5) + v.texcoord.xy;
                    r0.xyz = r2.yyy * r0.xyz;
                    r2.yzw = v.tangent.xyz + -v.normal.xyz;
                    r0.w = v.texcoord2.y + -v.texcoord2.x;
                    r0.w = max(r0.w,9.99999975e-05);
                    r1.w = _Progress + -v.texcoord2.x;
                    r0.w = saturate(r1.w / r0.w);
                    r2.yzw = r0.www * r2.yzw + v.normal.xyz;
                    r3.xyz = v.normal.xyz + -v.vertex.xyz;
                    r3.xyz = r0.www * r3.xyz + v.vertex.xyz;
                    r2.yzw = -r3.xyz + r2.yzw;
                    r2.yzw = r0.www * r2.yzw + r3.xyz;
                    r1.xyz = r1.xyz * r2.xxx + r2.yzw;
                    r0.xyz = r0.xyz * v.texcoord1.www + r1.xyz;
                    r1 = unity_ObjectToWorld._m01_m11_m21_m31 * r0.yyyy;
                    r1 = unity_ObjectToWorld._m00_m10_m20_m30 * r0.xxxx + r1;
                    r0 = unity_ObjectToWorld._m02_m12_m22_m32 * r0.zzzz + r1;
                    r0 = unity_ObjectToWorld._m03_m13_m23_m33 + r0;
                    r1 = UNITY_MATRIX_VP._m01_m11_m21_m31 * r0.yyyy;
                    r1 = UNITY_MATRIX_VP._m00_m10_m20_m30 * r0.xxxx + r1;
                    r1 = UNITY_MATRIX_VP._m02_m12_m22_m32 * r0.zzzz + r1;
                    r0 = UNITY_MATRIX_VP._m03_m13_m23_m33 * r0.wwww + r1;
                    r1.x = _Progress >= v.texcoord2.x;
                    r1.y = v.texcoord2.y >= _Progress;
                    r1.xy = r1.xy ? float2(1,1) : 0;
                    r1.x = r1.x * r1.y;
                    o.svPOS = r1.xxxx * r0;
                #endif
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 svTarget = float4(0,0,0,0);
                float4 r0 = float4(0,0,0,0);
                float4 r1 = float4(0,0,0,0);
                #if S_BILLBOARD && !TRIANGLE && !ROTATION && !DISABLE_MAIN && !SKYBOX_STAR  && !BILLBOARD && !TS_BILLBOARD && !H_BILLBORD
                    r0.x = _ColorIntensity * _Intensity;
                    r1 = tex2D(_MainTex,i.texcoord1.xy);
                    r1 = saturate(i.texcoord * r1);
                    r0.xyz = r1.xyz * r0.xxx;
                    r0.w = _Alpha_Intensity * r1.w;
                    r0.w = r0.w * r0.w;
                    svTarget.w = min(r0.w,1);
                    svTarget.xyz = float3(_R_Intensity,_G_Intensity,_B_Intensity) * r0.xyz;
                #elif BILLBOARD && !TRIANGLE && !ROTATION && !DISABLE_MAIN && !SKYBOX_STAR  && !TS_BILLBOARD && !S_BILLBOARD && !H_BILLBORD
                    r0.x = _ColorIntensity * _Intensity;
                    r1 = tex2D(_MainTex,i.texcoord1.xy);
                    r1 = saturate(i.texcoord * r1);
                    r0.xyz = r1.xyz * r0.xxx;
                    r0.w = _Alpha_Intensity * r1.w;
                    r0.w = r0.w * r0.w;
                    svTarget.w = min(r0.w,1);
                    svTarget.xyz = float3(_R_Intensity,_G_Intensity,_B_Intensity) * r0.xyz;
                #elif DISABLE_MAIN && S_BILLBOARD && !TRIANGLE && !ROTATION && !SKYBOX_STAR  && !BILLBOARD && !TS_BILLBOARD && !H_BILLBORD
                    r0.x = _ColorIntensity * _Intensity;
                    r1 = saturate(i.texcoord);
                    r0.xyz = r1.xyz * r0.xxx;
                    r0.w = _Alpha_Intensity * r1.w;
                    r0.w = r0.w * r0.w;
                    svTarget.w = min(r0.w,1);
                    svTarget.xyz = float3(_R_Intensity,_G_Intensity,_B_Intensity) * r0.xyz;
                #endif
                return svTarget;
            }
            ENDCG
        }
    }
}
