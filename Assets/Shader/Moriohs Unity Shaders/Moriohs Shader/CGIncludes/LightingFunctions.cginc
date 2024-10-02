#ifndef LIGHTINGFUNCTIONS_INCLUDED
#define LIGHTINGFUNCTIONS_INCLUDED

half3 calcDirectSpecular(const float ndl, const float ndh, const float vdn, const float ldh, const half3 LightDir, const half3 lightCol, const half3 halfVector, const float3 diffuseColor, const float3 tangent, const float3 bitangent)
{
    const half specularIntensity = _SpecularIntensity * SpecularMapSample().r;
    
    const float3 t = tangent;
    const float3 b = bitangent;
    const float ToV = dot(t, calcViewDir());
    const float BoV = dot(b, calcViewDir());
    const float ToL = dot(t, LightDir);
    const float BoL = dot(b, LightDir);

    float perceptualRoughness = SmoothnessToPerceptualRoughness(_SpecularArea);
    perceptualRoughness = clamp(perceptualRoughness, 0.089, 1.0);
    float roughness = PerceptualRoughnessToRoughness(perceptualRoughness);
    float rough = roughness * SpecularMapSample().b;
    
    float anisotropy = _Anisotropy;
    const float at = max(rough * (1.0 + anisotropy), 0.001);
    const float ab = max(rough * (1.0 - anisotropy), 0.001);
    const float V = V_SmithGGXCorrelated_Anisotropic(at, ab, ToV, BoV, ToL, BoL, vdn, ndl);
    const float D = D_GGX_Anisotropic(ndh, halfVector, tangent, bitangent, at, ab);
          float F = 1-F_Schlick(ldh,1-lerp(unity_ColorSpaceDielectricSpec.r, 1, _AnisoF0Reflectance));
    if (_AnisoFlickerFix == 1)
    {
        F = 1-F_Schlick(ldh,1-lerp(unity_ColorSpaceDielectricSpec.r, 1, _AnisoF0Reflectance) * ndl * ndh); //this is not mathematically correct, only use when needed
    }
    
    half3 specular = max(0, D * V * F * ndl * UNITY_PI);
    specular = lerp(specular, smoothstep(0.25, 0.26, specular), _SpecularSharpness) * lightCol * specularIntensity;
    if (group_toggle_SpecularAniso == 1)
    {
        specular *= lerp(1, diffuseColor, _SpecularAlbedoTint * SpecularMapSample().g);
    }
    else
    {
        specular = 0.0;
    }
    return specular;
}

half3 calcSpecularBRDF(half smoothness, half3 specColor, half ndl, half vdn, half ndh, half LdotH, half3 lightcolor)
{
    const float perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
    // Specular term
    // HACK: theoretically we should divide diffuseTerm by Pi and not multiply specularTerm!
    // BUT 1) that will make shader look significantly darker than Legacy ones
    // and 2) on engine side "Non-important" lights have to be divided by Pi too in cases when they are injected into ambient SH
    float roughness = PerceptualRoughnessToRoughness(perceptualRoughness);

    // GGX with roughtness to 0 would mean no specular at all, using max(roughness, 0.002) here to match HDrenderloop roughtness remapping.
    roughness = max(roughness, 0.002);
    const float V = SmithJointGGXVisibilityTerm (ndl, vdn, roughness);
    const float D = GGXTerm (ndh, roughness);

    float specularTerm = V*D * UNITY_PI; // Torrance-Sparrow model, Fresnel is applied later

    #   ifdef UNITY_COLORSPACE_GAMMA
    specularTerm = sqrt(max(1e-4h, specularTerm));
    #   endif

    // specularTerm * nl can be NaN on Metal in some cases, use max() to make sure it's a sane value
    specularTerm = max(0, specularTerm * ndl);
    // To provide true Lambert lighting, we need to be able to kill specular completely.
    specularTerm *= any(specColor) ? 1.0 : 0.0;

    #if defined(_SPECULARHIGHLIGHTS_OFF)
    specularTerm = 0.0;
    #endif
    
    return specularTerm * lightcolor * FresnelTerm(specColor, LdotH) * ReflectionMaskSample();
}

half3 SSS(half3 WorldNormal, half3 LightDir, half3 lightcolMulAttenNoNDL)
{
    const half3 a = WorldNormal * _SubsurfaceDistortionModifier;
    const half3 b = -(LightDir + a);
    const half c = saturate(dot(b, calcViewDir()));
    const half d = saturate(pow(c, _SSSPower));
    const half e = d * _SSSIntensity;
    const half3 diffuseMul = e * MainTexSample();
    const half3 diffuselerp = lerp(e, diffuseMul, _SSSTint);
    const half3 diffuseMulLight = diffuselerp * lightcolMulAttenNoNDL;
    half3 finalSSS = diffuseMulLight * _SSSColor * SSSThickenessMapSample();
    if (group_toggle_BRDF == 1)
    {
        finalSSS *= lerp(1, 1-MetallicGlossMapSample().r * ReflectionMaskSample(), GammaToLinearSpaceExact(_Metallic)); //need to make sure metallic areas are never affected by SSS
    }
    if (group_toggle_SSS == 1)
    {
        return finalSSS;
    }
    else
    {
        return 0.0;
    }
}

half3 FinalVertexLight(half3 worldNormal, half ndv, half3 diffuseColor, half3 specColor, half smoothness, half3 tangent, half3 bitangent, out half3 VertexLights, out half3 VLSubsurfaceScattering)
{
    half3 VertexLightSpecular = 0;
    VertexLights = 0;
    VLSubsurfaceScattering = 0;
    #ifdef LIGHTMAP_ON
        VertexLights = 0;
        #elif UNITY_SHOULD_SAMPLE_SH
            #ifdef VERTEXLIGHT_ON
                #ifdef UNITY_PASS_FORWARDBASE
                    half4 VLndl = 0;
                    half4 VLAtten = 0;
                    half3 VLDirOne = 0;
                    half3 VLDirTwo = 0;
                    half3 VLDirThree = 0;
                    half3 VLDirFour = 0;
                    VertexLights = Shade4PointLights(worldNormal, VLndl, VLAtten, VLDirOne, VLDirTwo, VLDirThree, VLDirFour) * OcclusionMapSample(); //populating VLDir*s
                    //VL1 Data
                    half3 VLhalfVector0 = Unity_SafeNormalize(VLDirOne + calcViewDir());
                    half VLndh0 = DotClamped(worldNormal, VLhalfVector0);
                    half ldh0 = DotClamped(VLDirOne, VLhalfVector0);
                    //VL2 Data
                    half3 VLhalfVector1 = Unity_SafeNormalize(VLDirTwo + calcViewDir());
                    half VLndh1 = DotClamped(worldNormal, VLhalfVector1);
                    half ldh1 = DotClamped(VLDirTwo, VLhalfVector1);
                    //VL3 Data
                    half3 VLhalfVector2 = Unity_SafeNormalize(VLDirThree + calcViewDir());
                    half VLndh2 = DotClamped(worldNormal, VLhalfVector2);
                    half ldh2 = DotClamped(VLDirThree, VLhalfVector2);
                    //VL4 Data
                    half3 VLhalfVector3 = Unity_SafeNormalize(VLDirFour + calcViewDir());
                    half VLndh3 = DotClamped(worldNormal, VLhalfVector3);
                    half ldh3 = DotClamped(VLDirFour, VLhalfVector3);
                    //Subsurface Scattering
                    half3 VLSSS0 = SSS(worldNormal, VLDirOne, unity_LightColor[0] * VLAtten.x);
                    half3 VLSSS1 = SSS(worldNormal, VLDirTwo, unity_LightColor[1] * VLAtten.y);
                    half3 VLSSS2 = SSS(worldNormal, VLDirThree, unity_LightColor[2] * VLAtten.z);
                    half3 VLSSS3 = SSS(worldNormal, VLDirFour, unity_LightColor[3] * VLAtten.w);
                    VLSubsurfaceScattering = VLSSS0 + VLSSS1 + VLSSS2 + VLSSS3;
                    //Calc Spec BRDF
                    half3 VertexLightSpecularBRDF0 = calcSpecularBRDF(smoothness, specColor, VLndl.x, ndv, VLndh0, ldh0, unity_LightColor[0] * VLAtten.x);
                    half3 VertexLightSpecularBRDF1 = calcSpecularBRDF(smoothness, specColor, VLndl.y, ndv, VLndh1, ldh1, unity_LightColor[1] * VLAtten.y);
                    half3 VertexLightSpecularBRDF2 = calcSpecularBRDF(smoothness, specColor, VLndl.z, ndv, VLndh2, ldh2, unity_LightColor[2] * VLAtten.z);
                    half3 VertexLightSpecularBRDF3 = calcSpecularBRDF(smoothness, specColor, VLndl.w, ndv, VLndh3, ldh3, unity_LightColor[3] * VLAtten.w);
                    VertexLightSpecular = VertexLightSpecularBRDF0 + VertexLightSpecularBRDF1 + VertexLightSpecularBRDF2 + VertexLightSpecularBRDF3;
                    #if defined(_SPECULARHIGHLIGHTS_OFF)
                        VertexLightSpecular = 0.0;
                    #endif
                    //Calc Spec Aniso
                    half3 VertexLightSpecular0 = calcDirectSpecular(VLndl.x, VLndh0, ndv, ldh0, VLDirOne, unity_LightColor[0], VLhalfVector0, diffuseColor, tangent, bitangent) * VLAtten.x;
                    half3 VertexLightSpecular1 = calcDirectSpecular(VLndl.y, VLndh1, ndv, ldh1, VLDirTwo, unity_LightColor[1], VLhalfVector1, diffuseColor, tangent, bitangent) * VLAtten.y;
                    half3 VertexLightSpecular2 = calcDirectSpecular(VLndl.z, VLndh2, ndv, ldh2, VLDirThree, unity_LightColor[2], VLhalfVector2, diffuseColor, tangent, bitangent) * VLAtten.z;
                    half3 VertexLightSpecular3 = calcDirectSpecular(VLndl.w, VLndh3, ndv, ldh3, VLDirFour, unity_LightColor[3], VLhalfVector3, diffuseColor, tangent, bitangent) * VLAtten.w;
                    VertexLightSpecular += VertexLightSpecular0 + VertexLightSpecular1 + VertexLightSpecular2 + VertexLightSpecular3;
                    return VertexLightSpecular;
                #endif
            #endif
        #endif
    return 0.0; //Not in VERTEXLIGHT_ON Keyword anymore so we just return 0, should have used a void i guess
}

half3 getReflectionUV(half3 direction, half3 position, half4 cubemapPosition, half3 boxMin, half3 boxMax)
{
    #if UNITY_SPECCUBE_BOX_PROJECTION
    if (cubemapPosition.w > 0) {
        half3 factors = ((direction > 0 ? boxMax : boxMin) - position) / direction;
        half scalar = min(min(factors.x, factors.y), factors.z);
        direction = direction * scalar + (position - cubemapPosition);
    }
    #endif
    return direction;
}

half3 calcIndirectSpecular(half3 reflDir, half3 indirectLight)
{//This function handls Unity style reflections and a baked in fallback cubemap.
    half3 spec = half3(0,0,0);
    
        #if defined(UNITY_PASS_FORWARDBASE) //Indirect PBR specular should only happen in the forward base pass. Otherwise each extra light adds another indirect sample, which could mean you're getting too much light.
        half3 reflectionUV1 = getReflectionUV(reflDir, input.worldPos, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
        half roughness = 1-(_Glossiness * MetallicGlossMapSample().a);
        roughness *= 1.7 - 0.7 * roughness;
        half4 probe0 = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflectionUV1, roughness * UNITY_SPECCUBE_LOD_STEPS);
        half3 probe0sample = DecodeHDR(probe0, unity_SpecCube0_HDR);
        
        half3 indirectSpecular;
        half interpolator = unity_SpecCube0_BoxMin.w;

        UNITY_BRANCH
        if (interpolator < 0.99999)
        {
            half3 reflectionUV2 = getReflectionUV(reflDir, input.worldPos, unity_SpecCube1_ProbePosition, unity_SpecCube1_BoxMin, unity_SpecCube1_BoxMax);
            half4 probe1 = UNITY_SAMPLE_TEXCUBE_SAMPLER_LOD(unity_SpecCube1, unity_SpecCube0, reflectionUV2, roughness * UNITY_SPECCUBE_LOD_STEPS);
            half3 probe1sample = DecodeHDR(probe1, unity_SpecCube1_HDR);
            indirectSpecular = lerp(probe1sample, probe0sample, interpolator);
        }
        else
        {
            indirectSpecular = probe0sample;
        }

        if (!any(indirectSpecular))
        {
            indirectSpecular = texCUBElod(_BakedCubemap, half4(reflDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
            indirectSpecular *= indirectLight;
        }
        #if defined (_GLOSSYREFLECTIONS_OFF)
            spec = unity_IndirectSpecColor;
        #else
            spec = indirectSpecular;
        #endif
        #endif
    
    return spec * ReflectionMaskSample() * OcclusionMapSample();
}

half3 BRDF1(half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness, half3 gidiffuse, half shadows, half atten, half3 gispecular, half alpha, half ndv, half ndl, half ldh)
{
    //gispecular is already multiplied here with the occlusion map
    const float perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);

    // Diffuse term
    half diffuseTerm = DisneyDiffuse(ndv, ndl, ldh, perceptualRoughness) * ndl;
    diffuseTerm = lerp(diffuseTerm, ndl, 1-ReflectionMaskSample()); //lerp to ndl since this needs to always be rendered from the diffuse side of things
    diffuseTerm = lerp(diffuseTerm, 1, _ShadowLift); //Toon stuff
    if (_ShadowLift > 0) //Toon stuff
    {
        diffuseTerm = min(diffuseTerm, shadows) * atten;
    }
    else
    {
        diffuseTerm *= shadows * atten;
    }
    
    // Specular term
    // HACK: theoretically we should divide diffuseTerm by Pi and not multiply specularTerm!
    // BUT 1) that will make shader look significantly darker than Legacy ones
    // and 2) on engine side "Non-important" lights have to be divided by Pi too in cases when they are injected into ambient SH
    float roughness = PerceptualRoughnessToRoughness(perceptualRoughness);

    // GGX with roughtness to 0 would mean no specular at all, using max(roughness, 0.002) here to match HDrenderloop roughtness remapping.
    roughness = max(roughness, 0.002);
    
    // surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(roughness^2+1)
    half surfaceReduction;
#   ifdef UNITY_COLORSPACE_GAMMA
        surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
#   else
        surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
#   endif

    const half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
    half3 diffuse = diffColor * (gidiffuse + diffuseTerm * _LightColor0.rgb);
    if (_Mode == 3)
    {
        diffuse *= alpha;
    }
    half3 color =   diffuse
                    + surfaceReduction * gispecular * FresnelLerp (specColor, grazingTerm, ndv);

    return color;
}

half3 calcMatcap(half3 worldNormal, half3 diffuseVertexLighting, half3 PixelLighting, half3 AmbientLight, out half MatcapLightAbsobtion)
{
    //Lighting (Matcap Base)
    const float3 AmbientLightOccluded = AmbientLight * OcclusionMapSample();
    half LightingMul = saturate(LinearRgbToLuminance(PixelLighting + AmbientLight + diffuseVertexLighting)); //No Shadows and clamp for pure illumination
    LightingMul *= MainTexSample() * OcclusionMapSample();
    const half3 LightingAdd = PixelLighting + AmbientLightOccluded + diffuseVertexLighting; //Additive colored Lighting
    
    //R1 Base + Modes
    const half3 MatcapR1Base = MatcapR1Sample(worldNormal) * _MatcapR1Color.rgb * _MatcapR1Color.a * _MatcapR1Blending * _MatcapR1Intensity;
    const half3 MatcapR1Tint = lerp(1, MainTexSample(), _MatcapR1Tint);
    const half3 MatcapR1ModeMul = MatcapR1Base * LightingMul;
    const half3 MatcapR1ModeAdd = MatcapR1Base * LightingAdd;
    half3 MatcapR1 = 0;
    if (_MatcapR1Mode == 0 && group_toggle_MatcapR1 == 1)
    {
        MatcapR1 = MatcapR1ModeMul * MatcapMaskSample().r;
    }
    else if (_MatcapR1Mode == 1 && group_toggle_MatcapR1 == 1)
    {
        MatcapR1 = MatcapR1ModeAdd * MatcapMaskSample().r * MatcapR1Tint;
    }

    //G2 Base + Modes
    const half3 MatcapG2Base = MatcapG2Sample(worldNormal) * _MatcapG2Color.rgb * _MatcapG2Color.a * _MatcapG2Blending * _MatcapG2Intensity;
    const half3 MatcapG2Tint = lerp(1, MainTexSample(), _MatcapG2Tint);
    const half3 MatcapG2ModeMul = MatcapG2Base * LightingMul;
    const half3 MatcapG2ModeAdd = MatcapG2Base * LightingAdd;
    half3 MatcapG2 = 0;
    if (_MatcapG2Mode == 0 && group_toggle_MatcapG2 == 1)
    {
        MatcapG2 = MatcapG2ModeMul * MatcapMaskSample().g;
    }
    else if (_MatcapG2Mode == 1 && group_toggle_MatcapG2 == 1)
    {
        MatcapG2 = MatcapG2ModeAdd * MatcapMaskSample().g * MatcapG2Tint;
    }

    //B3 Base + Modes
    const half3 MatcapB3Base = MatcapB3Sample(worldNormal) * _MatcapB3Color.rgb * _MatcapB3Color.a * _MatcapB3Blending * _MatcapB3Intensity;
    const half3 MatcapB3Tint = lerp(1, MainTexSample(), _MatcapB3Tint);
    const half3 MatcapB3ModeMul = MatcapB3Base * LightingMul;
    const half3 MatcapB3ModeAdd = MatcapB3Base * LightingAdd;
    half3 MatcapB3 = 0;
    if (_MatcapB3Mode == 0 && group_toggle_MatcapB3 == 1)
    {
        MatcapB3 = MatcapB3ModeMul * MatcapMaskSample().b;
    }
    else if (_MatcapB3Mode == 1 && group_toggle_MatcapB3 == 1)
    {
        MatcapB3 = MatcapB3ModeAdd * MatcapMaskSample().b * MatcapB3Tint;
    }

    //A4 Base + Modes
    const half3 MatcapA4Base = MatcapA4Sample(worldNormal) * _MatcapA4Color.rgb * _MatcapA4Color.a * _MatcapA4Blending * _MatcapA4Intensity;
    const half3 MatcapA4Tint = lerp(1, MainTexSample(), _MatcapA4Tint);
    const half3 MatcapA4ModeMul = MatcapA4Base * LightingMul;
    const half3 MatcapA4ModeAdd = MatcapA4Base * LightingAdd;
    half3 MatcapA4 = 0;
    if (_MatcapA4Mode == 0 && group_toggle_MatcapA4 == 1)
    {
        MatcapA4 = MatcapA4ModeMul * MatcapMaskSample().a;
    }
    else if (_MatcapA4Mode == 1 && group_toggle_MatcapA4 == 1)
    {
        MatcapA4 = MatcapA4ModeAdd * MatcapMaskSample().a * MatcapA4Tint;
    }

    //Lightabsobtion
    MatcapLightAbsobtion = 0;
    if (group_toggle_MatcapR1 == 1 && _MatcapR1Mode == 0)
    {
        MatcapLightAbsobtion = _MatcapR1Blending * MatcapMaskSample().r;
    }
    if (group_toggle_MatcapG2 == 1 && _MatcapG2Mode == 0)
    {
        MatcapLightAbsobtion += _MatcapG2Blending * MatcapMaskSample().g;
    }
    if (group_toggle_MatcapB3 == 1 && _MatcapB3Mode == 0)
    {
        MatcapLightAbsobtion += _MatcapB3Blending * MatcapMaskSample().b;
    }
    if (group_toggle_MatcapA4 == 1 && _MatcapA4Mode == 0)
    {
        MatcapLightAbsobtion += _MatcapA4Blending * MatcapMaskSample().a;
    }
    MatcapLightAbsobtion = saturate(MatcapLightAbsobtion);
    
    return MatcapR1 + MatcapG2 + MatcapB3 + MatcapA4;
}

#endif//end