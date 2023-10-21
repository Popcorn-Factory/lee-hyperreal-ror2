// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32983,y:32593,varname:node_4013,prsc:2|diff-8298-OUT,normal-6552-RGB,clip-7768-OUT;n:type:ShaderForge.SFN_Tex2d,id:6552,x:32043,y:32273,ptovrint:False,ptlb:NormalTex,ptin:_NormalTex,varname:node_6552,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:68902ac633201f645af578784a011bd6,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Tex2d,id:3695,x:32474,y:32168,ptovrint:False,ptlb:AlbedoTex,ptin:_AlbedoTex,varname:node_3695,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bdc29119e6a29264eb9f3f0716a1fb13,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:7446,x:30946,y:32764,ptovrint:False,ptlb:transitionLerp,ptin:_transitionLerp,varname:node_7446,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5308763,max:1;n:type:ShaderForge.SFN_Tex2d,id:3625,x:32206,y:33038,ptovrint:False,ptlb:NoiseTex,ptin:_NoiseTex,varname:node_3625,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:d8afe1c1f7278ee48a3d94302d6c24e2,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Vector1,id:5741,x:32230,y:32807,varname:node_5741,prsc:2,v1:0;n:type:ShaderForge.SFN_Smoothstep,id:7768,x:32533,y:32958,varname:node_7768,prsc:2|A-5741-OUT,B-8782-OUT,V-3625-R;n:type:ShaderForge.SFN_ConstantLerp,id:8782,x:32042,y:32975,varname:node_8782,prsc:2,a:1,b:0|IN-1925-OUT;n:type:ShaderForge.SFN_RemapRange,id:1925,x:31780,y:32998,varname:node_1925,prsc:2,frmn:0,frmx:1,tomn:-1,tomx:1|IN-7446-OUT;n:type:ShaderForge.SFN_Fresnel,id:2053,x:32094,y:32476,varname:node_2053,prsc:2|EXP-3736-OUT;n:type:ShaderForge.SFN_Multiply,id:8298,x:32719,y:32377,varname:node_8298,prsc:2|A-3695-RGB,B-7062-OUT;n:type:ShaderForge.SFN_Color,id:412,x:31852,y:32680,ptovrint:False,ptlb:node_412,ptin:_node_412,varname:node_412,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0.9543438,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:7062,x:32380,y:32501,varname:node_7062,prsc:2|A-2053-OUT,B-9757-OUT;n:type:ShaderForge.SFN_If,id:3736,x:31877,y:32504,varname:node_3736,prsc:2|A-7446-OUT,B-6501-OUT,GT-3553-OUT,EQ-1826-OUT,LT-1826-OUT;n:type:ShaderForge.SFN_Vector1,id:6501,x:31254,y:32490,varname:node_6501,prsc:2,v1:0.5;n:type:ShaderForge.SFN_ConstantLerp,id:1826,x:31317,y:32571,varname:node_1826,prsc:2,a:0,b:2|IN-7446-OUT;n:type:ShaderForge.SFN_ConstantLerp,id:3553,x:31339,y:32896,varname:node_3553,prsc:2,a:2,b:0|IN-7446-OUT;n:type:ShaderForge.SFN_Color,id:1291,x:31852,y:32845,ptovrint:False,ptlb:node_1291,ptin:_node_1291,varname:node_1291,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Lerp,id:9757,x:32057,y:32737,varname:node_9757,prsc:2|A-412-RGB,B-1291-RGB,T-7446-OUT;proporder:6552-3695-7446-3625-412-1291;pass:END;sub:END;*/

Shader "Shader Forge/FadeIn" {
    Properties {
        _NormalTex ("NormalTex", 2D) = "bump" {}
        _AlbedoTex ("AlbedoTex", 2D) = "white" {}
        _transitionLerp ("transitionLerp", Range(0, 1)) = 0.5308763
        _NoiseTex ("NoiseTex", 2D) = "white" {}
        _node_412 ("node_412", Color) = (0,0.9543438,1,1)
        _node_1291 ("node_1291", Color) = (1,1,1,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _NormalTex; uniform float4 _NormalTex_ST;
            uniform sampler2D _AlbedoTex; uniform float4 _AlbedoTex_ST;
            uniform sampler2D _NoiseTex; uniform float4 _NoiseTex_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _transitionLerp)
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_412)
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_1291)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalTex_var = UnpackNormal(tex2D(_NormalTex,TRANSFORM_TEX(i.uv0, _NormalTex)));
                float3 normalLocal = _NormalTex_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float node_5741 = 0.0;
                float _transitionLerp_var = UNITY_ACCESS_INSTANCED_PROP( Props, _transitionLerp );
                float4 _NoiseTex_var = tex2D(_NoiseTex,TRANSFORM_TEX(i.uv0, _NoiseTex));
                float node_7768 = smoothstep( node_5741, lerp(1,0,(_transitionLerp_var*2.0+-1.0)), _NoiseTex_var.r );
                clip(node_7768 - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _AlbedoTex_var = tex2D(_AlbedoTex,TRANSFORM_TEX(i.uv0, _AlbedoTex));
                float node_3736_if_leA = step(_transitionLerp_var,0.5);
                float node_3736_if_leB = step(0.5,_transitionLerp_var);
                float node_1826 = lerp(0,2,_transitionLerp_var);
                float node_3736 = lerp((node_3736_if_leA*node_1826)+(node_3736_if_leB*lerp(2,0,_transitionLerp_var)),node_1826,node_3736_if_leA*node_3736_if_leB);
                float4 _node_412_var = UNITY_ACCESS_INSTANCED_PROP( Props, _node_412 );
                float4 _node_1291_var = UNITY_ACCESS_INSTANCED_PROP( Props, _node_1291 );
                float3 node_7062 = (pow(1.0-max(0,dot(normalDirection, viewDirection)),node_3736)*lerp(_node_412_var.rgb,_node_1291_var.rgb,_transitionLerp_var));
                float3 diffuseColor = (_AlbedoTex_var.rgb*node_7062);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _NormalTex; uniform float4 _NormalTex_ST;
            uniform sampler2D _AlbedoTex; uniform float4 _AlbedoTex_ST;
            uniform sampler2D _NoiseTex; uniform float4 _NoiseTex_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _transitionLerp)
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_412)
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_1291)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalTex_var = UnpackNormal(tex2D(_NormalTex,TRANSFORM_TEX(i.uv0, _NormalTex)));
                float3 normalLocal = _NormalTex_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float node_5741 = 0.0;
                float _transitionLerp_var = UNITY_ACCESS_INSTANCED_PROP( Props, _transitionLerp );
                float4 _NoiseTex_var = tex2D(_NoiseTex,TRANSFORM_TEX(i.uv0, _NoiseTex));
                float node_7768 = smoothstep( node_5741, lerp(1,0,(_transitionLerp_var*2.0+-1.0)), _NoiseTex_var.r );
                clip(node_7768 - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float4 _AlbedoTex_var = tex2D(_AlbedoTex,TRANSFORM_TEX(i.uv0, _AlbedoTex));
                float node_3736_if_leA = step(_transitionLerp_var,0.5);
                float node_3736_if_leB = step(0.5,_transitionLerp_var);
                float node_1826 = lerp(0,2,_transitionLerp_var);
                float node_3736 = lerp((node_3736_if_leA*node_1826)+(node_3736_if_leB*lerp(2,0,_transitionLerp_var)),node_1826,node_3736_if_leA*node_3736_if_leB);
                float4 _node_412_var = UNITY_ACCESS_INSTANCED_PROP( Props, _node_412 );
                float4 _node_1291_var = UNITY_ACCESS_INSTANCED_PROP( Props, _node_1291 );
                float3 node_7062 = (pow(1.0-max(0,dot(normalDirection, viewDirection)),node_3736)*lerp(_node_412_var.rgb,_node_1291_var.rgb,_transitionLerp_var));
                float3 diffuseColor = (_AlbedoTex_var.rgb*node_7062);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma target 3.0
            uniform sampler2D _NoiseTex; uniform float4 _NoiseTex_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _transitionLerp)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                float node_5741 = 0.0;
                float _transitionLerp_var = UNITY_ACCESS_INSTANCED_PROP( Props, _transitionLerp );
                float4 _NoiseTex_var = tex2D(_NoiseTex,TRANSFORM_TEX(i.uv0, _NoiseTex));
                float node_7768 = smoothstep( node_5741, lerp(1,0,(_transitionLerp_var*2.0+-1.0)), _NoiseTex_var.r );
                clip(node_7768 - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
