#ifndef UTILITIES_INCLUDED
#define UTILITIES_INCLUDED

//General stuff
float2 UVSwitch(float UVSwitchProp)
{
	if (UVSwitchProp == 0)
		return input.uv0;
	else if (UVSwitchProp == 1)
		return input.uv1;
	else if (UVSwitchProp == 2)
		return input.uv2;
	else
		return input.uv3;
}

half3 calcViewDir()
{
	const half3 viewDir = _WorldSpaceCameraPos - input.worldPos;
	return normalize(viewDir);
}

half3 calcStereoViewDir()
{
	#if UNITY_SINGLE_PASS_STEREO
	half3 cameraPos = half3((unity_StereoWorldSpaceCameraPos[0]+ unity_StereoWorldSpaceCameraPos[1])*.5);
	#else
	const half3 cameraPos = _WorldSpaceCameraPos;
	#endif
	const half3 viewDir = cameraPos - input.worldPos;
	return normalize(viewDir);
}

half3 calcReflView(half3 worldnormal)
{
	return reflect(-calcViewDir(), worldnormal);
}

half3 calcReflLight(half3 lightDir, half3 worldnormal)
{
	return reflect(lightDir, worldnormal);
}
//General stuff end

//Lighting stuff
half3 calcLightDir()
{
	return normalize(UnityWorldSpaceLightDir(input.worldPos));
}

half3 calcLightDirAmbient()
{
	return normalize(unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz);
}

float V_SmithGGXCorrelated_Anisotropic(float at, float ab, float ToV, float BoV, float ToL, float BoL, float NoV, float NoL)
{
	float lambdaV = NoL * length(float3(at * ToV, ab * BoV, NoV));
	float lambdaL = NoV * length(float3(at * ToL, ab * BoL, NoL));
	float v = 0.5 / (lambdaV + lambdaL);
	return saturate(v);
}

float D_GGX_Anisotropic(float NoH, const float3 h, const float3 t, const float3 b, float at, float ab)
{
	const float ToH = dot(t, h);
	const float BoH = dot(b, h);
	float a2 = at * ab;
	const float3 v = float3(ab * ToH, at * BoH, a2 * NoH);
	const float v2 = dot(v, v);
	const float w2 = a2 / v2;
	return a2 * w2 * w2 * (1.0 / UNITY_PI);
}

float F_Schlick(float u, float f0)
{
	return f0 + (1.0 - f0) * pow(1.0 - u, 5.0);
}

float shEvaluateDiffuseL1Geomerics_local(float L0, float3 L1, float3 n)
{
	/* http://www.geomerics.com/wp-content/uploads/2015/08/CEDEC_Geomerics_ReconstructingDiffuseLighting1.pdf */
	// average energy
	// Add max0 to fix an issue caused by probes having a negative ambient component (???)
	// I'm not sure how normal that is but this can't handle it
	const float R0 = max(L0, 0);

	// avg direction of incoming light
	const float3 R1 = 0.5f * L1;

	// directional brightness
	const float lenR1 = length(R1);

	// linear angle between normal and direction 0-1
	float q = dot(normalize(R1), n) * 0.5 + 0.5;
	q = saturate(q); // Thanks to ScruffyRuffles for the bug identity.

	// power for q
	// lerps from 1 (linear) to 3 (cubic) based on directionality
	const float p = 1.0f + 2.0f * lenR1 / R0;

	// dynamic range constant
	// should vary between 4 (highly directional) and 0 (ambient)
	const float a = (1.0f - lenR1 / R0) / (1.0f + lenR1 / R0);

	return R0 * (a + (1.0f - a) * (p + 1.0f) * pow(q, p));
}

half3 BetterSH9(half4 normal) {
	float3 indirect;
	float3 L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w)
	 + float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
	indirect.r = shEvaluateDiffuseL1Geomerics_local(L0.r, unity_SHAr.xyz, normal);
	indirect.g = shEvaluateDiffuseL1Geomerics_local(L0.g, unity_SHAg.xyz, normal);
	indirect.b = shEvaluateDiffuseL1Geomerics_local(L0.b, unity_SHAb.xyz, normal);
	indirect = max(0, indirect);
	indirect += SHEvalLinearL2(normal);
	return indirect;
}

float rcpSqrtIEEEIntApproximation(float inX, const int inRcpSqrtConst)
{
	int x = asint(inX);
	x = inRcpSqrtConst - (x >> 1);
	return asfloat(x);
}

float fastRcpSqrtNR0(float inX)
{
	const float  xRcpSqrt = rcpSqrtIEEEIntApproximation(inX, 0x5f3759df);
	return xRcpSqrt;
}

float3 Shade4PointLights(float3 normal,
	out half4 ndl, out half4 attenuation,
	out half3 VLDirOne, out half3 VLDirTwo, out half3 VLDirThree, out half3 VLDirFour)
{
	// to light vectors
	float4 toLightX = unity_4LightPosX0 - input.worldPos.x;
	float4 toLightY = unity_4LightPosY0 - input.worldPos.y;
	float4 toLightZ = unity_4LightPosZ0 - input.worldPos.z;
	// squared lengths
	float4 lengthSq = 0;
	lengthSq += toLightX * toLightX;
	lengthSq += toLightY * toLightY;
	lengthSq += toLightZ * toLightZ;
	// don't produce NaNs if some vertex position overlaps with the light
	lengthSq = max(lengthSq, 0.000001);

	// NdotL
	float4 ndotl = 0;
	ndotl += toLightX * normal.x;
	ndotl += toLightY * normal.y;
	ndotl += toLightZ * normal.z;
	// correct NdotL
	float4 corr = 0;//rsqrt(lengthSq);
	corr.x = fastRcpSqrtNR0(lengthSq.x);
	corr.y = fastRcpSqrtNR0(lengthSq.y);
	corr.z = fastRcpSqrtNR0(lengthSq.z);
	corr.w = fastRcpSqrtNR0(lengthSq.x);

	ndotl = corr * ndotl;
	ndotl = max (float4(0,0,0,0), ndotl);
	// attenuation
	// Fixes popin. Thanks, d4rkplayer!
	float4 atten = 1.0 / (1.0 + lengthSq * unity_4LightAtten0);
	const float4 atten2 = saturate(1 - (lengthSq * unity_4LightAtten0 / 25));
	atten = min(atten, atten2 * atten2);

	//out params
	ndl = ndotl;
	attenuation = atten;
	VLDirOne = normalize(float3(toLightX.x, toLightY.x, toLightZ.x));
	VLDirTwo = normalize(float3(toLightX.y, toLightY.y, toLightZ.y));
	VLDirThree = normalize(float3(toLightX.z, toLightY.z, toLightZ.z));
	VLDirFour = normalize(float3(toLightX.w, toLightY.w, toLightZ.w));

	ndotl = saturate(ndotl * _ShadowSqueeze);
	ndotl = lerp(ndotl, 1, _ShadowLift);
	float4 diff = ndotl * atten;
	const float3 VLFinalOne = diff.x * unity_LightColor[0];
	const float3 VLFinalTwo = diff.y * unity_LightColor[1];
	const float3 VLFinalThree = diff.z * unity_LightColor[2];
	const float3 VLFinalFour = diff.w * unity_LightColor[3];
	return VLFinalOne + VLFinalTwo + VLFinalThree + VLFinalFour;
}

float GSAA_Filament(float3 normal, float perceptualRoughness, float gsaaVariance, float gsaaThreshold)
{
	// Kaplanyan 2016, "Stable specular highlights"
	// Tokuyoshi 2017, "Error Reduction and Simplification for Shading Anti-Aliasing"
	// Tokuyoshi and Kaplanyan 2019, "Improved Geometric Specular Antialiasing"
				
	// This implementation is meant for deferred rendering in the original paper but
	// we use it in forward rendering as well (as discussed in Tokuyoshi and Kaplanyan
	// 2019). The main reason is that the forward version requires an expensive transform
	// of the float vector by the tangent frame for every light. This is therefore an
	// approximation but it works well enough for our needs and provides an improvement
	// over our original implementation based on Vlachos 2015, "Advanced VR Rendering".
				
	float3 du = ddx(normal);
	float3 dv = ddy(normal);
				
	float variance = gsaaVariance * (dot(du, du) + dot(dv, dv));
				
	float roughness = perceptualRoughness * perceptualRoughness;
	float kernelRoughness = min(2.0 * variance, gsaaThreshold);
	float squareRoughness = saturate(roughness * roughness + kernelRoughness);
				
	return sqrt(sqrt(squareRoughness));
}
//Lighting stuff end

//Matcap
half2 matcapSample(half3 worldnormal)
{
	const half3 worldUp = float3(0,1,0);
	const half3 worldViewUp = normalize(worldUp - calcViewDir() * dot(calcViewDir(), worldUp));
	const half3 worldViewRight = normalize(cross(calcViewDir(), worldViewUp));
	half2 matcapUV = half2(dot(worldViewRight, worldnormal), dot(worldViewUp, worldnormal)) * 0.5 + 0.5;
	return matcapUV;
}

float3 MatcapR1Sample(half3 worldnormal)
{
	const float2 UV = matcapSample(worldnormal);
	float3 Tex = _MatcapR1.SampleLevel(sampler_MainTex,UV * _MatcapR1_ST.xy + _MatcapR1_ST.zw, (1-_MatcapR1smoothness) * 10);
	return Tex;
}

float3 MatcapG2Sample(half3 worldnormal)
{
	const float2 UV = matcapSample(worldnormal);
	float3 Tex = _MatcapG2.SampleLevel(sampler_MainTex,UV * _MatcapG2_ST.xy + _MatcapG2_ST.zw, (1-_MatcapG2smoothness) * 10);
	return Tex;
}

float3 MatcapB3Sample(half3 worldnormal)
{
	const float2 UV = matcapSample(worldnormal);
	float3 Tex = _MatcapB3.SampleLevel(sampler_MainTex,UV * _MatcapB3_ST.xy + _MatcapB3_ST.zw, (1-_MatcapB3smoothness) * 10);
	return Tex;
}

float3 MatcapA4Sample(half3 worldnormal)
{
	const float2 UV = matcapSample(worldnormal);
	float3 Tex = _MatcapA4.SampleLevel(sampler_MainTex,UV * _MatcapA4_ST.xy + _MatcapA4_ST.zw, (1-_MatcapA4smoothness) * 10);
	return Tex;
}

float4 MatcapMaskSample()
{
	const float2 UV = UVSwitch(_MatcapMaskUVSwitch);
	float4 Tex = _MatcapMask.Sample(sampler_MainTex, UV * _MatcapMask_ST.xy + _MatcapMask_ST.zw);
	return Tex;
}
//Matcap end

//Texture Samples
float3 SpecularMapSample()
{
	const float2 UV = UVSwitch(_SpecularMapUVSwitch);
	float3 Tex = _SpecularMap.Sample(sampler_MainTex, UV * _SpecularMap_ST.xy + _SpecularMap_ST.zw);
	return Tex;
}

float4 MainTexSample()
{
	const float2 UV = UVSwitch(_MainTexUVSwitch);
	const float4 Tex = _MainTex.Sample(sampler_MainTex, UV * _MainTex_ST.xy + _MainTex_ST.zw);
	float4 FinalMaintex = Tex * _Color;
	return FinalMaintex;
}

float3 EmissionSample()
{
	const float2 UV = UVSwitch(_EmissionUVSwitch);
	const float3 Tex = _Emission.Sample(sampler_MainTex, UV * _Emission_ST.xy + _Emission_ST.zw);
	float3 FinalEmission = Tex * _EmissionColor;
	FinalEmission = lerp(FinalEmission, FinalEmission * MainTexSample().rgb, _EmissionTint);
	return FinalEmission;
}

float3 TangentNormalSample()
{
	const float2 UV = UVSwitch(_BumpMapUVSwitch);
	float3 Tex = UnpackScaleNormal(_BumpMap.Sample(sampler_MainTex, UV * _BumpMap_ST.xy + _BumpMap_ST.zw), _BumpScale);
	return Tex;
}

float3 DetailedTangentNormalSample()
{
	const float2 UV = UVSwitch(_DetailNormalMapUVSwitch);
	float3 Tex = UnpackScaleNormal(_DetailNormalMap.Sample(sampler_MainTex, UV * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw), _DetailNormalMapScale);
	return Tex;
}

float4 NormalMapMaskSample()
{
	const float2 UV = UVSwitch(_NormalMapMaskUVSwitch);
	float4 Tex = _NormalMapMask.Sample(sampler_MainTex, UV * _NormalMapMask_ST.xy + _NormalMapMask_ST.zw);
	return Tex;
}

float OcclusionMapSample()
{
	const float2 UV = UVSwitch(_OcclusionMapUVSwitch);
	float2 Tex = _OcclusionMap.Sample(sampler_MainTex, UV * _OcclusionMap_ST.xy + _OcclusionMap_ST.zw);
	Tex = lerp(1, Tex.g, _OcclusionStrength);
	return Tex;
}

float4 MetallicGlossMapSample()
{
	const float2 UV = UVSwitch(_MetallicGlossMapUVSwitch);
	float4 Tex = _MetallicGlossMap.Sample(sampler_MainTex, UV * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw);
	return Tex;
}

float ReflectionMaskSample()
{
	const float2 UV = UVSwitch(_ReflectionMaskUVSwitch);
	const float Tex = _ReflectionMask.Sample(sampler_MainTex, UV * _ReflectionMask_ST.xy + _ReflectionMask_ST.zw);
	return Tex;
}

float3 SSSThickenessMapSample()
{
	const float2 UV = UVSwitch(_SSSThickenessMapUVSwitch);
	float3 Tex = _SSSThickenessMap.Sample(sampler_MainTex, UV * _SSSThickenessMap_ST.xy + _SSSThickenessMap_ST.zw);
	return Tex;
}
//Texture Samples end

#endif //END