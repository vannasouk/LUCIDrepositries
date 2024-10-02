#ifndef BASE_INCLUDED
#define BASE_INCLUDED

Texture2D _MainTex;
sampler sampler_MainTex;
float4 _MainTex_ST;
Texture2D _BumpMap;
float4 _BumpMap_ST;
Texture2D _DetailNormalMap;
float4 _DetailNormalMap_ST;
Texture2D _NormalMapMask;
float4 _NormalMapMask_ST;
Texture2D _Emission;
float4 _Emission_ST;
Texture2D _OcclusionMap;
float4 _OcclusionMap_ST;
Texture2D _MetallicGlossMap;
float4 _MetallicGlossMap_ST;
Texture2D _ReflectionMask;
float4 _ReflectionMask_ST;
samplerCUBE _BakedCubemap;
//Floats
float _ShaderOptimizerEnabled;
float _EmissionTint;
float _BumpScale;
float _DetailNormalMapScale;
float _ShadowLift;
float _ShadowSqueeze;
float _OcclusionStrength;
float _Metallic; //dont forget to do (GammaToLinearSpaceExact(_Metallic)) on all calls of this property
float _Glossiness;
float _Cutoff;
float _BRDFReflInheritAniso;
float _EnableGSAA;
float _GSAAVariance;
float _GSAAThreshold;
//Colors
fixed4 _Color;
fixed4 _EmissionColor;
//UV Switches
float _MainTexUVSwitch;
float _BumpMapUVSwitch;
float _DetailNormalMapUVSwitch;
float _NormalMapMaskUVSwitch;
float _EmissionUVSwitch;
float _SpecularMapUVSwitch;
float _OcclusionMapUVSwitch;
float _MetallicGlossMapUVSwitch;
float _ReflectionMaskUVSwitch;
float _SSSThickenessMapUVSwitch;
float _MatcapMaskUVSwitch;
//Anisotropy Specular
Texture2D _SpecularMap;
float4 _SpecularMap_ST;
float _SpecularIntensity;
float _SpecularArea;
float _SpecularSharpness;
float _SpecularAlbedoTint;
float _Anisotropy;
float _AnisoF0Reflectance;
float _AnisoFlickerFix;
//SSS
Texture2D _SSSThickenessMap;
float4 _SSSThickenessMap_ST;
float _SubsurfaceDistortionModifier;
float _SSSPower;
float _SSSTint;
float _SSSIntensity;
fixed4 _SSSColor;
//Matcap
Texture2D _MatcapMask;
float4 _MatcapMask_ST;
Texture2D _MatcapR1;
float4 _MatcapR1_ST;
float _MatcapR1smoothness;
fixed4 _MatcapR1Color;
float _MatcapR1Intensity;
float _MatcapR1Tint;
float _MatcapR1Mode;
int group_toggle_MatcapR1;
float _MatcapR1Blending;
Texture2D _MatcapG2;
float4 _MatcapG2_ST;
float _MatcapG2smoothness;
fixed4 _MatcapG2Color;
float _MatcapG2Intensity;
float _MatcapG2Tint;
float _MatcapG2Mode;
int group_toggle_MatcapG2;
float _MatcapG2Blending;
Texture2D _MatcapB3;
float4 _MatcapB3_ST;
float _MatcapB3smoothness;
fixed4 _MatcapB3Color;
float _MatcapB3Intensity;
float _MatcapB3Tint;
float _MatcapB3Mode;
int group_toggle_MatcapB3;
float _MatcapB3Blending;
Texture2D _MatcapA4;
float4 _MatcapA4_ST;
float _MatcapA4smoothness;
fixed4 _MatcapA4Color;
float _MatcapA4Intensity;
float _MatcapA4Tint;
float _MatcapA4Mode;
int group_toggle_MatcapA4;
float _MatcapA4Blending;
//Toggles
float group_toggle_SpecularAniso;
float group_toggle_BRDF;
float group_toggle_SSS;
float _GlossyReflections;
float _SpecularHighlights;
float _Mode;



#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityStandardUtils.cginc"
#include "UnityStandardBRDF.cginc"


struct appdata //VertexInput
{
    float4 vertex : POSITION;
    float2 uv0 : TEXCOORD0;
    float2 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    float2 uv3 : TEXCOORD3;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float4 color : COLOR;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f //VertexOutput
{
    float4 pos : SV_POSITION;
    centroid float4 color : COLOR;
    float2 uv0 : TEXCOORD0;
    float2 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    float2 uv3 : TEXCOORD3;
    float3 worldPos : TEXCOORD4;
    float4 tangent : TEXCOORD5;
    float3 bitangent : TEXCOORD6;
    float3 worldNormal : TEXCOORD7;
    float4 screenPos : TEXCOORD8;
    
    #if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
        UNITY_FOG_COORDS(9)
    #endif
    UNITY_SHADOW_COORDS(10)
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};
static v2f input;


v2f vert (appdata v)
{
    v2f o;
    UNITY_INITIALIZE_OUTPUT(v2f, o);
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.uv0 = v.uv0;
    o.uv1 = v.uv1;
    o.uv2 = v.uv2;
    o.uv3 = v.uv3;

    o.pos = UnityObjectToClipPos(v.vertex);
    o.screenPos = ComputeScreenPos(o.pos);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);
    o.tangent.xyz = UnityObjectToWorldDir(v.tangent.xyz);
    o.tangent.w = v.tangent.w * unity_WorldTransformParams.w; //tangentSign
    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
    o.bitangent = cross(o.worldNormal , o.tangent.xyz) * o.tangent.w;
    o.color = v.color;
    
    UNITY_TRANSFER_SHADOW(o, v.uv1.xy);
    UNITY_TRANSFER_FOG(o,o.pos);
    return o;
}

#include "Shadows.cginc"
#include "Utilities.cginc"
#include "LightingFunctions.cginc"
//#include "Dissolve.cginc"


float4 frag(v2f i, const uint facing : SV_IsFrontFace) : SV_Target
{   
    input = i;
    UNITY_SETUP_INSTANCE_ID(i)

    //Textures
    float4 NormalMapMask = NormalMapMaskSample();
    float3 tangentNormal = TangentNormalSample();
    tangentNormal = lerp(float3(0,0,1), tangentNormal, NormalMapMask.a);
    float3 detailedtangentNormal = DetailedTangentNormalSample();
    detailedtangentNormal = lerp(float3(0,0,1), detailedtangentNormal, NormalMapMask.g);
    tangentNormal = BlendNormals(tangentNormal, detailedtangentNormal);
    
    float4 Maintex = MainTexSample();
    //Textures end
    float alpha = Maintex.a * _Color.a;
    
    float3 worldNormal = i.worldNormal;
    float3 tangent = i.tangent.xyz;
    float3 bitangent = i.bitangent;
    UNITY_BRANCH
     if (!facing)
     {
         worldNormal = -worldNormal;
         tangent = -tangent;
         bitangent = -bitangent;
     }
    const float3 calcedNormal = normalize
    (
        tangentNormal.x * tangent +
        tangentNormal.y * bitangent +
        tangentNormal.z * worldNormal
    );
    worldNormal = calcedNormal;
    tangent = normalize(cross(bitangent, worldNormal));
    bitangent = normalize(cross(worldNormal, tangent));

    float3 bentNormal = worldNormal;
    if (_BRDFReflInheritAniso == 1) //BRDF Reflection Anisotropy
    {
        const float3 anisotropicDirection = _Anisotropy >= 0.0 ? bitangent : tangent;
        const float3 anisotropicTangent = cross(anisotropicDirection, calcViewDir());
        const float3 anisotropicNormal = cross(anisotropicTangent, anisotropicDirection);
        bentNormal = normalize(lerp(worldNormal, anisotropicNormal, _Anisotropy));
    }
    
    
    //Dot Products, Directions and Ambient Light
    const float3 halfVector = normalize(calcLightDir() + calcViewDir());
    half ndl = DotClamped(calcLightDir(), worldNormal);
    const half ndh = DotClamped(worldNormal, halfVector);
    const half ndv = abs(dot(worldNormal, calcViewDir()));
    const half ldh = DotClamped(calcLightDir(), halfVector);
    //half Ambientndl = DotClamped(calcLightDir(), worldNormal);
    float3 AmbientLight = BetterSH9(half4(worldNormal,1));
    AmbientLight = lerp(AmbientLight, float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) + float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0, _ShadowLift); //Toon stuff
    const float3 AmbientLightOccluded = AmbientLight * OcclusionMapSample();
    const float3 DiffuseAmbientLight = AmbientLightOccluded * Maintex;


    //Dot Products, Directions for Ambient
    const float3 halfVectorAmbient = normalize(calcLightDirAmbient() + calcViewDir());
    half ndlAmbient = DotClamped(calcLightDirAmbient(), worldNormal);
    const half ndhAmbient = DotClamped(worldNormal, halfVectorAmbient);
    const half ldhAmbient = DotClamped(calcLightDirAmbient(), halfVectorAmbient);
    
    
    //Lighting and Shadows
    LIGHT_ATTENUATION_NO_SHADOW_MUL(lightAttenNoShadows, i, i.worldPos.xyz); //never change lightAttenNoShadows!
    shadow = lerp(shadow, 1/_ShadowSqueeze, _ShadowLift);
    shadow = saturate(shadow * _ShadowSqueeze);
    ndl = saturate(ndl * _ShadowSqueeze);
    ndlAmbient = saturate(ndlAmbient * _ShadowSqueeze);
    const float3 Lighting = _LightColor0.rgb * lightAttenNoShadows * shadow; //for all features/effects that need correct and full Shadows all the time
    float3 LightingLiftedShadowsNdL = 0;
    if (_ShadowLift > 0) //Toon stuff and ndl/shadow caster * Lightcol combination. only for diffuse and diffuse like features/effects
    {
        LightingLiftedShadowsNdL = min(shadow, lerp(ndl, 1, _ShadowLift)) * _LightColor0.rgb * lightAttenNoShadows;
    }
    else
    {
        LightingLiftedShadowsNdL = shadow * lerp(ndl, 1, _ShadowLift) * _LightColor0.rgb * lightAttenNoShadows;
    }

    //Unity BRDF Utils
    half3 specColor = 0;
    half oneMinusReflectivity = 0;
    const half metallic = MetallicGlossMapSample().r * GammaToLinearSpaceExact(_Metallic);
    half smoothness = MetallicGlossMapSample().a * _Glossiness;
    //GSAA
    if (_EnableGSAA == 1)
    {
        smoothness = 1-GSAA_Filament(worldNormal, 1-smoothness, _GSAAVariance, _GSAAThreshold);
    }
    half3 GetDiffuseAndSpecularFromMetallic = DiffuseAndSpecularFromMetallic(Maintex, metallic, specColor, oneMinusReflectivity);
    GetDiffuseAndSpecularFromMetallic = lerp(GetDiffuseAndSpecularFromMetallic, Maintex, 1-ReflectionMaskSample());
    const half3 IndirectSpecular = calcIndirectSpecular(calcReflView(bentNormal), AmbientLight);

    
    //Vertex Lights
    half3 VertexLights = 0; //Diffuse Vertex Lights
    half3 VertexLightSpecular = 0; //Specular Highlights Aniso and BRDF Vertex Lights
    half3 VertexLightSSS = 0; // Vertex Light SubsurfaceScattering
    VertexLightSpecular = FinalVertexLight(worldNormal, ndv, Maintex, specColor, smoothness, tangent, bitangent, VertexLights, VertexLightSSS); //Vertex Light Diffuse + Specular + SSS from (FinalVertexLight out ports)

    //Unity BRDF Diffuse Base + Specular below separated
    half3 Base = 0; //Shading Base
    if (group_toggle_BRDF == 1)//If statement here to control else
    {
        Base = BRDF1(GetDiffuseAndSpecularFromMetallic, specColor, oneMinusReflectivity, smoothness, AmbientLightOccluded + VertexLights, shadow, lightAttenNoShadows, IndirectSpecular, Maintex.a, ndv, ndl, ldh);
    }
    else
    {
        if (_Mode == 3)
        {
            Base = lerp(0, Maintex * LightingLiftedShadowsNdL + DiffuseAmbientLight + VertexLights * Maintex, alpha);
        }
        else
        {
            Base = Maintex * LightingLiftedShadowsNdL + DiffuseAmbientLight + VertexLights * Maintex;
        }
    }
    //Specular Highlights GGX from Unity BRDF
    half3 SpecularBRDFPixel = calcSpecularBRDF(smoothness, specColor, ndl, ndv, ndh, ldh, Lighting);
    half3 AmbientSpecularBRDF = 0;
    if (max(max(_LightColor0.r, _LightColor0.g), _LightColor0.b) * _LightColor0.a == 0)
    {
        SpecularBRDFPixel = 0;
        AmbientSpecularBRDF = calcSpecularBRDF(smoothness, specColor, ndlAmbient, ndv, ndhAmbient, ldhAmbient, AmbientLight);
    }
    
    //Specular Highlights GGX Anisotropic from Filament
    half3 SpecularPixelAniso = calcDirectSpecular(ndl, ndh, ndv, ldh, calcLightDir(), Lighting, halfVector, Maintex, tangent, bitangent);
    half3 AmbientSpecularAniso = 0;
    if (max(max(_LightColor0.r, _LightColor0.g), _LightColor0.b) * _LightColor0.a == 0)
    {
        SpecularPixelAniso = 0;
        AmbientSpecularAniso = calcDirectSpecular(ndlAmbient, ndhAmbient, ndv, ldhAmbient, calcLightDirAmbient(), AmbientLight, halfVectorAmbient, Maintex, tangent, bitangent);
    }
    
    //SSS
    half3 SubsurceScattering = SSS(worldNormal, calcLightDir(), Lighting);
    half3 SubsurceScatteringAmbient = 0;
    if (max(max(_LightColor0.r, _LightColor0.g), _LightColor0.b) * _LightColor0.a == 0)
    {
        SubsurceScattering = 0;
        SubsurceScatteringAmbient = SSS(worldNormal, calcLightDirAmbient(), AmbientLightOccluded);
    }

    //Matcap
    half MatcapLightAbsobtion = 0;
    const half3 Matcap = calcMatcap(worldNormal, VertexLights, LightingLiftedShadowsNdL, AmbientLight, MatcapLightAbsobtion);
    
    Base = lerp(Matcap + Base, Matcap, MatcapLightAbsobtion);
    //Last Line for Final Output
    half3 finalColor = 0;
        #if defined (UNITY_PASS_FORWARDBASE)
        finalColor = EmissionSample() + VertexLightSpecular + AmbientSpecularAniso + AmbientSpecularBRDF + VertexLightSSS + SubsurceScatteringAmbient;
        #endif
        #if defined (UNITY_PASS_FORWARDBASE) || defined (UNITY_PASS_FORWARDADD)
        finalColor += Base + SpecularPixelAniso + SpecularBRDFPixel + SubsurceScattering;
        #endif
    
    //alpha
    if (_Mode == 1)
    {
        alpha = Maintex.a;
        clip (alpha - _Cutoff);
    }
    else if (_Mode == 2)
    {
        alpha = Maintex.a;
    }
    else if (_Mode == 3 && group_toggle_BRDF == 1)
    {
        alpha = lerp(Maintex.a, 1, GammaToLinearSpaceExact(_Metallic) * MetallicGlossMapSample()); //i have absolutely no idea if that's the way to do it but the result looked 1:1 the same as Standard Shader
    }
    else if (_Mode == 3 && group_toggle_BRDF == 0)
    {
        alpha = Maintex.a;
    }
    else
    {
        alpha = 1;
    }
    
    UNITY_APPLY_FOG(i.fogCoord, finalColor);
    
    //if (group_toggle_Dissolve == 1)
    //{
    //    half DissolveOut = 0;
    //    Dissolve(DissolveOut);
    //    clip(1.0 - DissolveOut);
    //}

    return float4(finalColor,alpha);
}
#endif//end