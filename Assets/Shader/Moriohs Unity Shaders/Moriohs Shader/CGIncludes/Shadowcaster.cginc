#ifndef SHADOWCASTER_INCLUDED
#define SHADOWCASTER_INCLUDED

// NOTE: had to split shadow functions into separate file,
// otherwise compiler gives trouble with LIGHTING_COORDS macro (in UnityStandardCore.cginc)


#include "UnityCG.cginc"
#include "UnityShaderVariables.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityStandardUtils.cginc"


float _Mode;
float group_toggle_BRDF;


#if defined(UNITY_USE_DITHER_MASK_FOR_ALPHABLENDED_SHADOWS)
#define UNITY_STANDARD_USE_DITHER_MASK 1
#endif

#ifdef UNITY_STEREO_INSTANCING_ENABLED
#define UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT 1
#endif


half4       _Color;
half        _Cutoff;
sampler2D   _MainTex;
float4      _MainTex_ST;
#ifdef UNITY_STANDARD_USE_DITHER_MASK
sampler3D   _DitherMaskLOD;
#endif

// Handle PremultipliedAlpha from Fade or Transparent shading mode
half        _Metallic;
sampler2D   _MetallicGlossMap;

half MetallicSetup_ShadowGetOneMinusReflectivity(half2 uv)
{
    const half metallicity = lerp(tex2D(_MetallicGlossMap, uv).r, 0, 1-(GammaToLinearSpaceExact(_Metallic)));
    return OneMinusReflectivityFromMetallic(metallicity);
}

struct VertexInput
{
    float4 color : COLOR; //Dissolve
    float4 vertex   : POSITION;
    float3 normal   : NORMAL;
    float2 uv0      : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct VertexOutputShadowCaster
{
    float2 uv0 : TEXCOORD0; //Dissolve
    centroid float4 color : COLOR; //Dissolve
    V2F_SHADOW_CASTER_NOPOS
    float2 tex : TEXCOORD1;
};
#ifdef UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT
struct VertexOutputStereoShadowCaster
{
    UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// We have to do these dances of outputting SV_POSITION separately from the vertex shader,
// and inputting VPOS in the pixel shader, since they both map to "POSITION" semantic on
// some platforms, and then things don't go well.


void vert (VertexInput v
    , out float4 opos : SV_POSITION
    , out VertexOutputShadowCaster o
    #ifdef UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT
    , out VertexOutputStereoShadowCaster os
    #endif
)
{
    UNITY_SETUP_INSTANCE_ID(v);
    #ifdef UNITY_STANDARD_USE_STEREO_SHADOW_OUTPUT_STRUCT
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(os);
    #endif
    TRANSFER_SHADOW_CASTER_NOPOS(o,opos)
    o.tex = TRANSFORM_TEX(v.uv0, _MainTex);
    o.color = v.color; //Dissolve
    o.uv0 = v.uv0; //Dissolve
}

static VertexOutputShadowCaster input; //Dissolve
#include "Dissolve.cginc" //Dissolve

half4 frag (UNITY_POSITION(vpos)
    , VertexOutputShadowCaster i
) : SV_Target
{
    #if defined(_SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A)
            half alpha = _Color.a;
        #else
            half alpha = tex2D(_MainTex, i.tex.xy).a * _Color.a;
        #endif
    if (_Mode == 1)
    {
        clip (alpha - _Cutoff);
    }
    if (_Mode == 2 || _Mode == 3)
    {
        if (_Mode == 3 && group_toggle_BRDF == 1)
        {
            //PreMultiplyAlpha(half3(0, 0, 0), alpha, MetallicSetup_ShadowGetOneMinusReflectivity(i.tex), outModifiedAlpha); //cant use cause internal shader keyword check
            const half oneMinusReflectivity = MetallicSetup_ShadowGetOneMinusReflectivity(i.tex);
            const half outModifiedAlpha = 1-oneMinusReflectivity + alpha*oneMinusReflectivity;
            
            alpha = outModifiedAlpha;
        }

        #if defined(UNITY_STANDARD_USE_DITHER_MASK)
        // Use dither mask for alpha blended shadows, based on pixel position xy
        // and alpha level. Our dither texture is 4x4x16.
        #ifdef LOD_FADE_CROSSFADE
        #define _LOD_FADE_ON_ALPHA
        alpha *= unity_LODFade.y;
        #endif
        half alphaRef = tex3D(_DitherMaskLOD, float3(vpos.xy*0.25,alpha*0.9375)).a;
        clip (alphaRef - 0.01);
        #else
        clip (alpha - _Cutoff);
        #endif
    }

    #ifdef LOD_FADE_CROSSFADE
        #ifdef _LOD_FADE_ON_ALPHA
            #undef _LOD_FADE_ON_ALPHA
        #else
            UnityApplyDitherCrossFade(vpos.xy);
        #endif
    #endif

    //if (group_toggle_Dissolve == 1) //Dissolve
    //{
    //    half DissolveOut = 0;
    //    Dissolve(DissolveOut);
    //    clip(1.0 - DissolveOut);
    //}
    
    SHADOW_CASTER_FRAGMENT(i)
}

#endif // UNITY_STANDARD_SHADOW_INCLUDED
