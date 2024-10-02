// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Moriohs Shaders/Standard/Standard Stochastic Metallic"
{
	Properties
	{
		[ShaderOptimizerLockButton]_ShaderOptimizerEnabled("PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_Culling("Culling", Int) = 2
		[Enum(Off,0,Method by Rotoscope,1,Gaussian by Errormdl,2)][Header(Diffuse)]_StochasticTiling("Stochastic Tiling", Int) = 0
		_MainColor("Main Color", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		[SingleLineTexture][Header(Reflections)]_MetallicTex("Metallic Tex", 2D) = "white" {}
		[Gamma]_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Enum(Metallic Alpha,0,Albedo Alpha,1)]_Source("Source", Int) = 0
		[SingleLineTexture][Header(Normal Map)]_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		[SingleLineTexture][Header(Ambient Occlusion)]_Occlusion("Occlusion", 2D) = "white" {}
		_OcclusionBlend("Occlusion Blend", Range( 0 , 1)) = 0
		[SingleLineTexture][Header(Detail Mask)]_DetailMask("Detail Mask", 2D) = "white" {}
		[Header(Emission)]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[SingleLineTexture]_Emission("Emission", 2D) = "white" {}
		[Enum(Off,0,Method by Rotoscope,1,Gaussian by Errormdl,2)][Space(15)][Header(Secondary Maps)]_DetailedStochasticTiling("Detailed Stochastic Tiling", Int) = 0
		[SingleLineTexture]_DetailAlbedox2("Detail Albedo x2", 2D) = "gray" {}
		_SecondaryNormalMap("Secondary Normal Map", 2D) = "bump" {}
		_SecondaryNormalScale("Secondary Normal Scale", Float) = 0
		[HideInInspector]_CsCenter("CsCenter", Vector) = (0,0,0,0)
		[HideInInspector]_CX("CX", Vector) = (0,0,0,0)
		[HideInInspector]_CY("CY", Vector) = (0,0,0,0)
		[HideInInspector]_CZ("CZ", Vector) = (0,0,0,0)
		[Header(LOOKUP TABLES)]_MainTex_LUT("MainTex Lookup Table", 2DArray) = "white" {}
		_MetallicTex_LUT("MetallicTex Lookup Table", 2DArray) = "white" {}
		_NormalMap_LUT("Normal Map Lookup Table", 2DArray) = "white" {}
		_Occlusion_LUT("Occlusion Lookup Table", 2DArray) = "white" {}
		_Emission_LUT("Emission Lookup Table", 2DArray) = "white" {}
		_DetailAlbedox2_LUT("Detail Albedo x2 Lookup Table", 2DArray) = "white" {}
		_SecondaryNormalMap_LUT("Secondary Normal Map Lookup Table", 2DArray) = "white" {}
		_TilingScale("TilingScale", Float) = 1.732051
		[Header(Forward Rendering Options)][ToggleOff(_SPECULARHIGHLIGHTS_OFF)] _SPECULARHIGHLIGHTS("Specular Highlights", Float) = 1
		[ToggleOff(_GLOSSYREFLECTIONS_OFF)] _GLOSSYREFLECTIONS("Reflections", Float) = 1
		[HideInInspector][ToggleUI]_NormalScaleAnimated("Normal Scale Animated", Int) = 1
		[HideInInspector][ToggleUI]_SecondaryNormalScaleAnimated("Secondary Normal Scale Animated", Int) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Culling]
		CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
		#include "UnityStandardUtils.cginc"
		#pragma target 5.0
		#pragma shader_feature_local _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature_local _GLOSSYREFLECTIONS_OFF
		#define TWO_TAN_30 1.154700538
		#define TAN_30     0.577350269
		struct colorspace
		{
		float4 axis0; ////< First basis vector of the colorspace in the xyz components, inverse length of the axis in w
		float4 axis1; ////< Second basis vector of the colorspace in the xyz components, inverse length of the axis in w
		float4 axis2; ////< Third basis vector of the colorspace in the xyz components, inverse length of the axis in w
		float4 center; ///< Center of the colorspace in the xyz components, w is unused
		};
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D_ARRAY_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#else //ASE discards identical directives1
		#define SAMPLE_TEXTURE2D_ARRAY_LOD(tex,samplertex,coord,lod) tex2DArraylod(tex, float4(coord,lod))
		#endif //ASE discards identical directives1
		#ifndef SHADER_TARGET_SURFACE_ANALYSIS
		Texture2DArray<fixed4> _MainTex_LUT;
		Texture2DArray<fixed4> _MetallicTex_LUT;
		Texture2DArray<fixed4> _NormalMap_LUT;
		Texture2DArray<fixed4> _SecondaryNormalMap_LUT;
		Texture2DArray<fixed4> _DetailAlbedox2_LUT;
		Texture2DArray<fixed4> _Emission_LUT;
		Texture2DArray<fixed4> _Occlusion_LUT;
		#else //ASE discards identical directives2
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_MainTex_LUT);
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_MetallicTex_LUT);
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalMap_LUT);
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_SecondaryNormalMap_LUT);
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_DetailAlbedox2_LUT);
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Emission_LUT);
		UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Occlusion_LUT);
		#endif //ASE discards identical directives2
		float4 _MainTex_LUT_TexelSize;
		float4 _MetallicTex_LUT_TexelSize;
		float4 _NormalMap_LUT_TexelSize;
		float4 _SecondaryNormalMap_LUT_TexelSize;
		float4 _DetailAlbedox2_LUT_TexelSize;
		float4 _Emission_LUT_TexelSize;
		float4 _Occlusion_LUT_TexelSize;
		SamplerState sampler_MainTex_LUT;
		SamplerState sampler_MetallicTex_LUT;
		SamplerState sampler_NormalMap_LUT;
		SamplerState sampler_SecondaryNormalMap_LUT; //we are not using this samplerstate since we ran out of texture slots and needed to reuse the samplerstate of _NormalMap
		SamplerState sampler_DetailAlbedox2_LUT;
		SamplerState sampler_Emission_LUT;
		SamplerState sampler_Occlusion_LUT;
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _ShaderOptimizerEnabled;
		uniform int _SecondaryNormalScaleAnimated;
		uniform float4 _CsCenter;
		uniform float4 _CX;
		uniform float _TilingScale;
		uniform float4 _CY;
		uniform int _Culling;
		uniform int _NormalScaleAnimated;
		uniform float4 _CZ;
		uniform int _StochasticTiling;
		uniform sampler2D _NormalMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _NormalScale;
		uniform sampler2D _DetailMask;
		uniform int _DetailedStochasticTiling;
		uniform sampler2D _SecondaryNormalMap;
		uniform float4 _SecondaryNormalMap_ST;
		uniform float _SecondaryNormalScale;
		uniform float4 _MainColor;
		uniform sampler2D _DetailAlbedox2;
		uniform float4 _EmissionColor;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform sampler2D _MetallicTex;
		uniform float _Metallic;
		uniform int _Source;
		uniform float _Smoothness;
		uniform sampler2D _Occlusion;
		uniform float _OcclusionBlend;


		float4 LookUpTableRGBEmission( float2 lutDim, float3 coords, float mip )
		{
			uint3 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0));
						    uint LUTWidth = (uint)lutDim.x;
						    uint LUTModW = LUTWidth - 1; // x % y is equivalent to x & (y - 1) if y is power of 2
						    uint LUTDivW = firstbithigh(LUTWidth); // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)
							# ifndef SHADER_TARGET_SURFACE_ANALYSIS
						    float3 sample1 = float3(
						        _Emission_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,
						        _Emission_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,
						        _Emission_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b
						        );
							#else // we need to do this so that the surface compiler isnt stripping the texture
							float3 sample1 = float3(
								SAMPLE_TEXTURE2D_ARRAY_LOD(_Emission_LUT, sampler_Emission_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_Emission_LUT, sampler_Emission_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_Emission_LUT, sampler_Emission_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b
							);
							#endif
								return float4(sample1, 1);
		}


		float4 LookUpTableRGBDetailAlbedox2( float2 lutDim, float3 coords, float mip )
		{
			uint3 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0));
						    uint LUTWidth = (uint)lutDim.x;
						    uint LUTModW = LUTWidth - 1; // x % y is equivalent to x & (y - 1) if y is power of 2
						    uint LUTDivW = firstbithigh(LUTWidth); // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)
							# ifndef SHADER_TARGET_SURFACE_ANALYSIS
						    float3 sample1 = float3(
						        _DetailAlbedox2_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,
						        _DetailAlbedox2_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,
						        _DetailAlbedox2_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b
						        );
							#else // we need to do this so that the surface compiler isnt stripping the texture
							float3 sample1 = float3(
								SAMPLE_TEXTURE2D_ARRAY_LOD(_DetailAlbedox2_LUT, sampler_DetailAlbedox2_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_DetailAlbedox2_LUT, sampler_DetailAlbedox2_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_DetailAlbedox2_LUT, sampler_DetailAlbedox2_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b
							);
							#endif
								return float4(sample1, 1);
		}


		float4 LookUpTableRGBAMainTex( float2 lutDim, float4 coords, float mip )
		{
			uint4 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0));
						    uint LUTWidth = (uint)lutDim.x;
						    uint LUTModW = LUTWidth - 1; // x % y is equivalent to x & (y - 1) if y is power of 2
						    uint LUTDivW = firstbithigh(LUTWidth); // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)
							# ifndef SHADER_TARGET_SURFACE_ANALYSIS
						    float4 sample1 = float4(
						        _MainTex_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,
						        _MainTex_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,
						        _MainTex_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b,
						        _MainTex_LUT.Load(int4(coords1.w & LUTModW, coords1.w >> LUTDivW, mip, 0)).a
						        );
							#else // we need to do this so that the surface compiler isnt stripping the texture
							float4 sample1 = float4(
								SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.w & LUTModW, coords1.w >> LUTDivW, 0.0), mip).a
							);
							#endif
								return sample1;
		}


		float3 Blend3GaussianRGB( float3 gaussian1, float3 gaussian2, float3 gaussian3, float3 weights, colorspace cs )
		{
			float3 gaussian = float3(cs.axis0.w, cs.axis1.w, cs.axis2.w) * ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float3(0.5,0.5,0.5))
			            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float3(0.5, 0.5, 0.5);
			        return saturate(gaussian);
		}


		float4 LookUpTableGOcclusion( float2 lutDim, float coords, float mip )
		{
			uint coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0));
			uint LUTWidth = (uint)lutDim.x;
			uint LUTModW = LUTWidth - 1; // x % y is equivalent to x & (y - 1) if y is power of 2
			uint LUTDivW = firstbithigh(LUTWidth); // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)
							# ifndef SHADER_TARGET_SURFACE_ANALYSIS
						    float4 sample1 = float4(
						        0,
						        _Occlusion_LUT.Load(int4(coords1 & LUTModW, coords1 >> LUTDivW, mip, 0)).g,
						        0,
						        1
						        );
							#else // we need to do this so that the surface compiler isnt stripping the texture
							float4 sample1 = float4(
								0,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_Occlusion_LUT, sampler_Occlusion_LUT, float3(coords1 & LUTModW, coords1 >> LUTDivW, 0.0), mip).g,
								0,
								1
							);
							#endif
								return sample1;
		}


		float4 LookUpTableRAMetallicTex( float2 lutDim, float2 coords, float mip )
		{
			uint2 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0));
			uint LUTWidth = (uint)lutDim.x;
			uint LUTModW = LUTWidth - 1; // x % y is equivalent to x & (y - 1) if y is power of 2
			uint LUTDivW = firstbithigh(LUTWidth); // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)
							# ifndef SHADER_TARGET_SURFACE_ANALYSIS
						    float4 sample1 = float4(
						        _MetallicTex_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,
						        0,
						        0,
						        _MetallicTex_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).a
						        );
							#else // we need to do this so that the surface compiler isnt stripping the texture
							float4 sample1 = float4(
								SAMPLE_TEXTURE2D_ARRAY_LOD(_MetallicTex_LUT, sampler_MetallicTex_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,
								0,
								0,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_MetallicTex_LUT, sampler_MetallicTex_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).a
							);
							#endif
								return sample1;
		}


		float4 LookUpTableRGBASecondaryNormalMap( float2 lutDim, float4 coords, float mip )
		{
			uint4 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0));
						    uint LUTWidth = (uint)lutDim.x;
						    uint LUTModW = LUTWidth - 1; // x % y is equivalent to x & (y - 1) if y is power of 2
						    uint LUTDivW = firstbithigh(LUTWidth); // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)
							# ifndef SHADER_TARGET_SURFACE_ANALYSIS
						    float4 sample1 = float4(
						        _SecondaryNormalMap_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,
						        _SecondaryNormalMap_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,
						        _SecondaryNormalMap_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b,
						        _SecondaryNormalMap_LUT.Load(int4(coords1.w & LUTModW, coords1.w >> LUTDivW, mip, 0)).a
						        );
							#else // we need to do this so that the surface compiler isnt stripping the texture
							//btw we are reusing the samplerstate of the _NormalMap here since we ran out of Texture slots and this should not matter too much for the enduser hopefully
							float4 sample1 = float4(
								SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.w & LUTModW, coords1.w >> LUTDivW, 0.0), mip).a
							);
							#endif
								return sample1;
		}


		float2 hash2( float2 input )
		{
				return frac(sin(mul(float2x2(137.231, 512.37, 199.137, 373.351), input)) * 23597.3733);
		}


		float4 LookUpTableRGBANormalMap( float2 lutDim, float4 coords, float mip )
		{
			uint4 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0));
						    uint LUTWidth = (uint)lutDim.x;
						    uint LUTModW = LUTWidth - 1; // x % y is equivalent to x & (y - 1) if y is power of 2
						    uint LUTDivW = firstbithigh(LUTWidth); // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)
							# ifndef SHADER_TARGET_SURFACE_ANALYSIS
						    float4 sample1 = float4(
						        _NormalMap_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,
						        _NormalMap_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,
						        _NormalMap_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b,
						        _NormalMap_LUT.Load(int4(coords1.w & LUTModW, coords1.w >> LUTDivW, mip, 0)).a
						        );
							#else // we need to do this so that the surface compiler isnt stripping the texture
							float4 sample1 = float4(
								SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b,
								SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.w & LUTModW, coords1.w >> LUTDivW, 0.0), mip).a
							);
							#endif
								return sample1;
		}


		void RandomOffsetTiling( float2 uv, inout float3 triWeights, inout float2 uvVertex0, inout float2 uvVertex1, inout float2 uvVertex2 )
		{
				float2x2 ShearedUVSpace = float2x2(-TAN_30, 1, TWO_TAN_30, 0); //WHY MUST TAN 30 BE NEGATIVE? WHY? IT SHOULDN"T BE BUT IT DOESN'T WORK OTHERWISE. I CAN'T FUCKING MATH. that was Errors comment not mine :D
				float2 shearedUVs = mul(ShearedUVSpace, uv);
				float2 intSUVs = floor(shearedUVs);
				float2 fracSUVs = frac(shearedUVs);
				float Ternary3rdComponent = 1.0 - fracSUVs.x - fracSUVs.y;
				float2 vertex0Offset = Ternary3rdComponent > 0 ? float2(0, 0) : float2(1, 1);
				float2 hashVertex0 = intSUVs + vertex0Offset;
				float2 hashVertex1 = intSUVs + float2(0, 1);
				float2 hashVertex2 = intSUVs + float2(1, 0);
				hashVertex0 = hash2(hashVertex0);
				hashVertex1 = hash2(hashVertex1);
				hashVertex2 = hash2(hashVertex2);
				/*
				float sin0, cos0, sin1, cos1, sin2, cos2;
				sincos(0.5 * (hashVertex0.x + hashVertex0.y) - 0.25, sin0, cos0);
				sincos(0.5 * (hashVertex1.x + hashVertex1.y) - 0.25, sin1, cos1);
				sincos(0.5 * (hashVertex2.x + hashVertex2.y) - 0.25, sin2, cos2);
			    */
				uvVertex0 += hashVertex0;
				uvVertex1 += hashVertex1;
				uvVertex2 += hashVertex2;
				
				/*
				uvVertex0 = uv * lerp(0.8, 1.2, hashVertex0.x)  + hashVertex0;
				uvVertex1 = uv * lerp(0.8, 1.2, hashVertex1.x) + hashVertex1;
				uvVertex2 = uv * lerp(0.8, 1.2, hashVertex2.x) + hashVertex2;
				*/
				if (Ternary3rdComponent > 0)
				{
					triWeights = float3(Ternary3rdComponent, fracSUVs.y, fracSUVs.x);
				}
				else
				{
					triWeights = float3(-Ternary3rdComponent, 1.0 - fracSUVs.x, 1.0 - fracSUVs.y);
				}
		}


		float2 hash2D2D( float2 s )
		{
			return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453);
		}


		float2 Blend3GaussianRA( float2 gaussian1, float2 gaussian2, float2 gaussian3, float3 weights )
		{
			float2 gaussian = ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float2(0.5,0.5))
			            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float2(0.5, 0.5);
			        return saturate(gaussian);
		}


		float3 ConvertColorspaceToRGB( float3 lutColor, colorspace cs )
		{
			    return (lutColor.r * cs.axis0.xyz + lutColor.g * cs.axis1.xyz + lutColor.b * cs.axis2.xyz) + cs.center.xyz;
		}


		float4 Blend3GaussianRGBANoCs( float4 gaussian1, float4 gaussian2, float4 gaussian3, float3 weights )
		{
			float4 gaussian = ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float4(0.5,0.5,0.5,0.5))
			            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float4(0.5, 0.5, 0.5, 0.5);
			        return saturate(gaussian);
		}


		float4 Blend3GaussianRGBA( float4 gaussian1, float4 gaussian2, float4 gaussian3, float3 weights, colorspace cs )
		{
					float4 gaussian = float4(cs.axis0.w, cs.axis1.w, cs.axis2.w, 1) * ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float4(0.5,0.5,0.5,0.5))
			            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float4(0.5, 0.5, 0.5, 0.5);
			        return saturate(gaussian);
		}


		float3 tex2DStochasticNormals( sampler2D tex, float2 UV, float NormalScale )
		{
			    //triangle vertices and blend weights
			    //BW_vx[0...2].xyz = triangle verts
			    //BW_vx[3].xy = blend weights (z is unused)
			    float4x3 BW_vx;
			    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)
			    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464);
			    //vertex IDs and barycentric coords
			    float2 vxID = float2 (floor(skewUV));
			    float3 barry = float3 (frac(skewUV), 0);
			    barry.z = 1.0-barry.x-barry.y;
			    BW_vx = ((barry.z>0) ? 
			        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :
			        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)));
			    //calculate derivatives to avoid triangular grid artifacts
			    float2 dx = ddx(UV);
			    float2 dy = ddy(UV);
			    //blend samples with calculated weights
			    return mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), NormalScale), BW_vx[3].x) + 
			            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), NormalScale), BW_vx[3].y) + 
			            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), NormalScale), BW_vx[3].z);
		}


		float4 tex2DGaussNormalMap( float2 UV )
		{
			float mip = 0;
			float3 weights = float3(0,0,0);
			float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0;
			RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2);
			//calculate derivatives to avoid triangular grid artifacts
			float2 constDx = ddx(UV);
			float2 constDy = ddy(UV);
			//blend samples with calculated weights
			float4 mainGauss1 = tex2Dgrad(_NormalMap, UV + uvVertex0, constDx, constDy);
			float4 mainGauss2 = tex2Dgrad(_NormalMap, UV + uvVertex1, constDx, constDy);
			float4 mainGauss3 = tex2Dgrad(_NormalMap, UV + uvVertex2, constDx, constDy);
			float4 mainGaussTotal = Blend3GaussianRGBANoCs(mainGauss1, mainGauss2, mainGauss3, weights);
			float4 mainColor = LookUpTableRGBANormalMap(_NormalMap_LUT_TexelSize.zw, mainGaussTotal, mip);
			return mainColor;
		}


		float3 getUnpackNormal340( float4 tex )
		{
			return UnpackNormal(tex);
		}


		float4 tex2DGaussSecondaryNormalMap( float2 UV )
		{
			float mip = 0;
			float3 weights = float3(0,0,0);
			float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0;
			RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2);
			//calculate derivatives to avoid triangular grid artifacts
			float2 constDx = ddx(UV);
			float2 constDy = ddy(UV);
			//blend samples with calculated weights
			float4 mainGauss1 = tex2Dgrad(_SecondaryNormalMap, UV + uvVertex0, constDx, constDy);
			float4 mainGauss2 = tex2Dgrad(_SecondaryNormalMap, UV + uvVertex1, constDx, constDy);
			float4 mainGauss3 = tex2Dgrad(_SecondaryNormalMap, UV + uvVertex2, constDx, constDy);
			float4 mainGaussTotal = Blend3GaussianRGBANoCs(mainGauss1, mainGauss2, mainGauss3, weights);
			float4 mainColor = LookUpTableRGBASecondaryNormalMap(_SecondaryNormalMap_LUT_TexelSize.zw, mainGaussTotal, mip);
			return mainColor;
		}


		float3 getUnpackNormal348( float4 tex )
		{
			return UnpackNormal(tex);
		}


		float4 tex2DStochastic( sampler2D tex, float2 UV )
		{
			    //triangle vertices and blend weights
			    //BW_vx[0...2].xyz = triangle verts
			    //BW_vx[3].xy = blend weights (z is unused)
			    float4x3 BW_vx;
			    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)
			    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464);
			    //vertex IDs and barycentric coords
			    float2 vxID = float2 (floor(skewUV));
			    float3 barry = float3 (frac(skewUV), 0);
			    barry.z = 1.0-barry.x-barry.y;
			    BW_vx = ((barry.z>0) ? 
			        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :
			        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)));
			    //calculate derivatives to avoid triangular grid artifacts
			    float2 dx = ddx(UV);
			    float2 dy = ddy(UV);
			    //blend samples with calculated weights
			    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + 
			            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + 
			            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z);
		}


		float4 tex2DGaussMainTex( float2 UV )
		{
			float mip = 0;
			float3 weights = float3(0,0,0);
			float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0;
			RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2);
			//calculate derivatives to avoid triangular grid artifacts
			float2 constDx = ddx(UV);
			float2 constDy = ddy(UV);
			colorspace cs;
				cs.axis0 = _CX;
				cs.axis1 = _CY;
				cs.axis2 = _CZ;
				cs.center = _CsCenter;
			//blend samples with calculated weights
			float4 mainGauss1 = tex2Dgrad(_MainTex, UV + uvVertex0, constDx, constDy);
			float4 mainGauss2 = tex2Dgrad(_MainTex, UV + uvVertex1, constDx, constDy);
			float4 mainGauss3 = tex2Dgrad(_MainTex, UV + uvVertex2, constDx, constDy);
			float4 mainGaussTotal = Blend3GaussianRGBA(mainGauss1, mainGauss2, mainGauss3, weights, cs);
			float4 mainColor = LookUpTableRGBAMainTex(_MainTex_LUT_TexelSize.zw, mainGaussTotal, mip);
			mainColor.rgb = ConvertColorspaceToRGB(mainColor.rgb, cs);
			return mainColor;
		}


		float4 tex2DGaussDetailAlbedox2( float2 UV )
		{
			float mip = 0;
			float3 weights = float3(0,0,0);
			float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0;
			RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2);
			//calculate derivatives to avoid triangular grid artifacts
			float2 constDx = ddx(UV);
			float2 constDy = ddy(UV);
			colorspace cs;
				cs.axis0 = _CX;
				cs.axis1 = _CY;
				cs.axis2 = _CZ;
				cs.center = _CsCenter;
			//blend samples with calculated weights
			float3 mainGauss1 = tex2Dgrad(_DetailAlbedox2, UV + uvVertex0, constDx, constDy).rgb;
			float3 mainGauss2 = tex2Dgrad(_DetailAlbedox2, UV + uvVertex1, constDx, constDy).rgb;
			float3 mainGauss3 = tex2Dgrad(_DetailAlbedox2, UV + uvVertex2, constDx, constDy).rgb;
			float3 mainGaussTotal = Blend3GaussianRGB(mainGauss1, mainGauss2, mainGauss3, weights, cs);
			float4 mainColor = LookUpTableRGBDetailAlbedox2(_DetailAlbedox2_LUT_TexelSize.zw, mainGaussTotal, mip);
			mainColor.rgb = ConvertColorspaceToRGB(mainColor.rgb, cs);
			return mainColor;
		}


		float4 tex2DGaussEmission( float2 UV )
		{
			float mip = 0;
			float3 weights = float3(0,0,0);
			float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0;
			RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2);
			//calculate derivatives to avoid triangular grid artifacts
			float2 constDx = ddx(UV);
			float2 constDy = ddy(UV);
			colorspace cs;
				cs.axis0 = _CX;
				cs.axis1 = _CY;
				cs.axis2 = _CZ;
				cs.center = _CsCenter;
			//blend samples with calculated weights
			float3 mainGauss1 = tex2Dgrad(_Emission, UV + uvVertex0, constDx, constDy).rgb;
			float3 mainGauss2 = tex2Dgrad(_Emission, UV + uvVertex1, constDx, constDy).rgb;
			float3 mainGauss3 = tex2Dgrad(_Emission, UV + uvVertex2, constDx, constDy).rgb;
			float3 mainGaussTotal = Blend3GaussianRGB(mainGauss1, mainGauss2, mainGauss3, weights, cs);
			float4 mainColor = LookUpTableRGBEmission(_Emission_LUT_TexelSize.zw, mainGaussTotal, mip);
			mainColor.rgb = ConvertColorspaceToRGB(mainColor.rgb, cs);
			return mainColor;
		}


		float4 tex2DGaussMetallicTex( float2 UV )
		{
			float mip = 0;
			float3 weights = float3(0,0,0);
			float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0;
			RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2);
			//calculate derivatives to avoid triangular grid artifacts
			float2 constDx = ddx(UV);
			float2 constDy = ddy(UV);
			//blend samples with calculated weights
			float2 mainGauss1 = tex2Dgrad(_MetallicTex, UV + uvVertex0, constDx, constDy).ra;
			float2 mainGauss2 = tex2Dgrad(_MetallicTex, UV + uvVertex1, constDx, constDy).ra;
			float2 mainGauss3 = tex2Dgrad(_MetallicTex, UV + uvVertex2, constDx, constDy).ra;
			float2 mainGaussTotal = Blend3GaussianRA(mainGauss1, mainGauss2, mainGauss3, weights);
			float4 mainColor = LookUpTableRAMetallicTex(_MetallicTex_LUT_TexelSize.zw, mainGaussTotal, mip);
			return mainColor;
		}


		float2 tex2DGaussOcclusion( float2 UV )
		{
			float mip = 0;
			float3 weights = float3(0,0,0);
			float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0;
			RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2);
			//calculate derivatives to avoid triangular grid artifacts
			float2 constDx = ddx(UV);
			float2 constDy = ddy(UV);
			//blend samples with calculated weights
			float mainGauss1 = tex2Dgrad(_Occlusion, UV + uvVertex0, constDx, constDy).g;
			float mainGauss2 = tex2Dgrad(_Occlusion, UV + uvVertex1, constDx, constDy).g;
			float mainGauss3 = tex2Dgrad(_Occlusion, UV + uvVertex2, constDx, constDy).g;
			float mainGaussTotal = Blend3GaussianRA(mainGauss1, mainGauss2, mainGauss3, weights);
			float4 mainColor = LookUpTableGOcclusion(_Occlusion_LUT_TexelSize.zw, mainGaussTotal, mip);
			return mainColor;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 _DefaultNormalVector = float3(0,0,1);
			int StochasticTiling52 = _StochasticTiling;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			sampler2D tex49 = _NormalMap;
			float2 UV49 = uv_MainTex;
			float NormalScale49 = _NormalScale;
			float3 localtex2DStochasticNormals49 = tex2DStochasticNormals( tex49 , UV49 , NormalScale49 );
			float2 UV255 = uv_MainTex;
			float4 localtex2DGaussNormalMap255 = tex2DGaussNormalMap( UV255 );
			float4 tex340 = localtex2DGaussNormalMap255;
			float3 localgetUnpackNormal340 = getUnpackNormal340( tex340 );
			float3 temp_output_343_0 = ( saturate( localgetUnpackNormal340 ) + float3(0,0,0.0001) );
			float3 appendResult347 = (float3(( (temp_output_343_0).xy * _NormalScale ) , temp_output_343_0.z));
			float3 ifLocalVar47 = 0;
			if( 1.0 > StochasticTiling52 )
				ifLocalVar47 = UnpackScaleNormal( tex2D( _NormalMap, uv_MainTex ), _NormalScale );
			else if( 1.0 == StochasticTiling52 )
				ifLocalVar47 = localtex2DStochasticNormals49;
			else if( 1.0 < StochasticTiling52 )
				ifLocalVar47 = appendResult347;
			float4 tex2DNode89 = tex2D( _DetailMask, uv_MainTex );
			float4 break105 = tex2DNode89;
			float3 lerpResult82 = lerp( _DefaultNormalVector , ifLocalVar47 , break105.g);
			int DetailedStochasticTiling149 = _DetailedStochasticTiling;
			float2 uv_SecondaryNormalMap = i.uv_texcoord * _SecondaryNormalMap_ST.xy + _SecondaryNormalMap_ST.zw;
			sampler2D tex92 = _SecondaryNormalMap;
			float2 UV92 = uv_SecondaryNormalMap;
			float NormalScale92 = _SecondaryNormalScale;
			float3 localtex2DStochasticNormals92 = tex2DStochasticNormals( tex92 , UV92 , NormalScale92 );
			float2 UV265 = uv_SecondaryNormalMap;
			float4 localtex2DGaussSecondaryNormalMap265 = tex2DGaussSecondaryNormalMap( UV265 );
			float4 tex348 = localtex2DGaussSecondaryNormalMap265;
			float3 localgetUnpackNormal348 = getUnpackNormal348( tex348 );
			float3 temp_output_351_0 = ( saturate( localgetUnpackNormal348 ) + float3(0,0,0.0001) );
			float3 appendResult355 = (float3(( (temp_output_351_0).xy * _SecondaryNormalScale ) , temp_output_351_0.z));
			float3 ifLocalVar95 = 0;
			if( 1.0 > DetailedStochasticTiling149 )
				ifLocalVar95 = UnpackScaleNormal( tex2D( _SecondaryNormalMap, uv_SecondaryNormalMap ), _SecondaryNormalScale );
			else if( 1.0 == DetailedStochasticTiling149 )
				ifLocalVar95 = localtex2DStochasticNormals92;
			else if( 1.0 < DetailedStochasticTiling149 )
				ifLocalVar95 = appendResult355;
			float3 lerpResult86 = lerp( _DefaultNormalVector , ifLocalVar95 , break105.a);
			float3 TangentNormals108 = BlendNormals( lerpResult82 , lerpResult86 );
			o.Normal = TangentNormals108;
			sampler2D tex8 = _MainTex;
			float2 UV8 = uv_MainTex;
			float4 localtex2DStochastic8 = tex2DStochastic( tex8 , UV8 );
			float2 UV230 = uv_MainTex;
			float4 localtex2DGaussMainTex230 = tex2DGaussMainTex( UV230 );
			float4 ifLocalVar33 = 0;
			if( 1.0 > StochasticTiling52 )
				ifLocalVar33 = tex2D( _MainTex, uv_MainTex );
			else if( 1.0 == StochasticTiling52 )
				ifLocalVar33 = localtex2DStochastic8;
			else if( 1.0 < StochasticTiling52 )
				ifLocalVar33 = localtex2DGaussMainTex230;
			sampler2D tex128 = _DetailAlbedox2;
			float2 UV128 = uv_SecondaryNormalMap;
			float4 localtex2DStochastic128 = tex2DStochastic( tex128 , UV128 );
			float2 UV269 = uv_SecondaryNormalMap;
			float4 localtex2DGaussDetailAlbedox2269 = tex2DGaussDetailAlbedox2( UV269 );
			float4 ifLocalVar126 = 0;
			if( 1.0 > DetailedStochasticTiling149 )
				ifLocalVar126 = tex2D( _DetailAlbedox2, uv_SecondaryNormalMap );
			else if( 1.0 == DetailedStochasticTiling149 )
				ifLocalVar126 = localtex2DStochastic128;
			else if( 1.0 < DetailedStochasticTiling149 )
				ifLocalVar126 = localtex2DGaussDetailAlbedox2269;
			float DetailedMaskAlpha133 = break105.a;
			float4 lerpResult135 = lerp( float4( 1,1,1,1 ) , ( ifLocalVar126 * unity_ColorSpaceDouble ) , DetailedMaskAlpha133);
			o.Albedo = ( ( _MainColor * ifLocalVar33 ) * lerpResult135 ).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			sampler2D tex58 = _Emission;
			float2 UV58 = uv_MainTex;
			float4 localtex2DStochastic58 = tex2DStochastic( tex58 , UV58 );
			float2 UV274 = uv_MainTex;
			float4 localtex2DGaussEmission274 = tex2DGaussEmission( UV274 );
			float4 ifLocalVar56 = 0;
			if( 1.0 > StochasticTiling52 )
				ifLocalVar56 = tex2D( _Emission, uv_Emission );
			else if( 1.0 == StochasticTiling52 )
				ifLocalVar56 = localtex2DStochastic58;
			else if( 1.0 < StochasticTiling52 )
				ifLocalVar56 = localtex2DGaussEmission274;
			o.Emission = ( _EmissionColor * ifLocalVar56 ).rgb;
			sampler2D tex67 = _MetallicTex;
			float2 UV67 = uv_MainTex;
			float4 localtex2DStochastic67 = tex2DStochastic( tex67 , UV67 );
			float2 UV251 = uv_MainTex;
			float4 localtex2DGaussMetallicTex251 = tex2DGaussMetallicTex( UV251 );
			float4 ifLocalVar70 = 0;
			if( 1.0 > StochasticTiling52 )
				ifLocalVar70 = tex2D( _MetallicTex, uv_MainTex );
			else if( 1.0 == StochasticTiling52 )
				ifLocalVar70 = localtex2DStochastic67;
			else if( 1.0 < StochasticTiling52 )
				ifLocalVar70 = localtex2DGaussMetallicTex251;
			float4 break68 = ifLocalVar70;
			float Metallic112 = ( break68.r * _Metallic );
			o.Metallic = Metallic112;
			float AlbedoAlpha190 = ifLocalVar33.a;
			float ifLocalVar189 = 0;
			if( _Source == 1.0 )
				ifLocalVar189 = AlbedoAlpha190;
			else if( _Source < 1.0 )
				ifLocalVar189 = break68.a;
			float Smoothness113 = ( ifLocalVar189 * _Smoothness );
			o.Smoothness = Smoothness113;
			sampler2D tex63 = _Occlusion;
			float2 UV63 = uv_MainTex;
			float localtex2DStochastic63 = tex2DStochastic( tex63 , UV63 );
			float2 UV278 = uv_MainTex;
			float2 localtex2DGaussOcclusion278 = tex2DGaussOcclusion( UV278 );
			float ifLocalVar61 = 0;
			if( 1.0 > StochasticTiling52 )
				ifLocalVar61 = tex2D( _Occlusion, uv_MainTex ).g;
			else if( 1.0 == StochasticTiling52 )
				ifLocalVar61 = localtex2DStochastic63;
			else if( 1.0 < StochasticTiling52 )
				ifLocalVar61 = localtex2DGaussOcclusion278.y;
			float lerpResult24 = lerp( 1.0 , ifLocalVar61 , _OcclusionBlend);
			float AmbientOcclusion116 = lerpResult24;
			o.Occlusion = AmbientOcclusion116;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Standard"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
0;0;3840;1019;6779.339;629.738;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;41;-5296,-608;Inherit;False;3303.216;2289.854;Normal Map;8;108;81;82;86;87;110;107;106;;0,0.3731735,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;106;-5248,-512;Inherit;False;1732.296;797.699;Base Normal Map;19;347;346;345;344;343;342;341;340;259;255;254;47;53;49;12;39;15;51;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;107;-5248,304;Inherit;False;1833.846;824.6757;Secondary Normal Map;19;355;354;353;352;351;350;349;348;264;266;95;85;96;92;90;265;94;91;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-5200,784;Inherit;False;0;90;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-5200,-64;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;265;-4592,912;Float;False;float mip = 0@$float3 weights = float3(0,0,0)@$float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0@$RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2)@$//calculate derivatives to avoid triangular grid artifacts$float2 constDx = ddx(UV)@$float2 constDy = ddy(UV)@$$$//blend samples with calculated weights$float4 mainGauss1 = tex2Dgrad(_SecondaryNormalMap, UV + uvVertex0, constDx, constDy)@$float4 mainGauss2 = tex2Dgrad(_SecondaryNormalMap, UV + uvVertex1, constDx, constDy)@$float4 mainGauss3 = tex2Dgrad(_SecondaryNormalMap, UV + uvVertex2, constDx, constDy)@$$float4 mainGaussTotal = Blend3GaussianRGBANoCs(mainGauss1, mainGauss2, mainGauss3, weights)@$$float4 mainColor = LookUpTableRGBASecondaryNormalMap(_SecondaryNormalMap_LUT_TexelSize.zw, mainGaussTotal, mip)@$$return mainColor@;4;Create;1;True;UV;FLOAT2;0,0;In;;Float;False;tex2DGaussSecondaryNormalMap;False;False;3;211;225;235;;False;1;0;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;255;-4736,64;Float;False;float mip = 0@$float3 weights = float3(0,0,0)@$float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0@$RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2)@$//calculate derivatives to avoid triangular grid artifacts$float2 constDx = ddx(UV)@$float2 constDy = ddy(UV)@$$$//blend samples with calculated weights$float4 mainGauss1 = tex2Dgrad(_NormalMap, UV + uvVertex0, constDx, constDy)@$float4 mainGauss2 = tex2Dgrad(_NormalMap, UV + uvVertex1, constDx, constDy)@$float4 mainGauss3 = tex2Dgrad(_NormalMap, UV + uvVertex2, constDx, constDy)@$$float4 mainGaussTotal = Blend3GaussianRGBANoCs(mainGauss1, mainGauss2, mainGauss3, weights)@$$float4 mainColor = LookUpTableRGBANormalMap(_NormalMap_LUT_TexelSize.zw, mainGaussTotal, mip)@$$return mainColor@;4;Create;1;True;UV;FLOAT2;0,0;In;;Float;False;tex2DGaussNormalMap;False;False;3;211;225;235;;False;1;0;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1952,-1728;Inherit;False;1296.574;757.5433;Albedo;13;260;217;230;27;26;190;191;33;54;8;36;9;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;34;-128,-336;Inherit;False;Property;_StochasticTiling;Stochastic Tiling;2;1;[Enum];Create;True;0;3;Off;0;Method by Rotoscope;1;Gaussian by Errormdl;2;0;False;1;Header(Diffuse);False;0;2;False;0;1;INT;0
Node;AmplifyShaderEditor.CustomExpressionNode;340;-4544,64;Inherit;False;return UnpackNormal(tex)@;3;Create;1;True;tex;FLOAT4;0,0,0,0;In;;Inherit;False;getUnpackNormal;True;False;0;;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;348;-4336,912;Inherit;False;return UnpackNormal(tex)@;3;Create;1;True;tex;FLOAT4;0,0,0,0;In;;Inherit;False;getUnpackNormal;True;False;0;;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;349;-4176,912;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;80,-336;Inherit;False;StochasticTiling;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.Vector3Node;342;-4400,128;Inherit;False;Constant;_Vector0;Vector 0;44;0;Create;True;0;0;0;False;0;False;0,0,0.0001;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;9;-1904,-1504;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;341;-4384,64;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1904,-1312;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;350;-4192,976;Inherit;False;Constant;_Vector1;Vector 0;44;0;Create;True;0;0;0;False;0;False;0,0,0.0001;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1568,-1664;Inherit;False;52;StochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;44;-1952,1488;Inherit;False;1908.061;790.55;Reflections;20;249;250;113;112;29;30;21;189;20;192;68;188;70;71;251;28;67;72;69;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;343;-4240,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;8;-1616,-1392;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;230;-1456,-1184;Float;False;float mip = 0@$float3 weights = float3(0,0,0)@$float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0@$RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2)@$//calculate derivatives to avoid triangular grid artifacts$float2 constDx = ddx(UV)@$float2 constDy = ddy(UV)@$$colorspace cs@$	cs.axis0 = _CX@$	cs.axis1 = _CY@$	cs.axis2 = _CZ@$	cs.center = _CsCenter@$$//blend samples with calculated weights$float4 mainGauss1 = tex2Dgrad(_MainTex, UV + uvVertex0, constDx, constDy)@$float4 mainGauss2 = tex2Dgrad(_MainTex, UV + uvVertex1, constDx, constDy)@$float4 mainGauss3 = tex2Dgrad(_MainTex, UV + uvVertex2, constDx, constDy)@$$float4 mainGaussTotal = Blend3GaussianRGBA(mainGauss1, mainGauss2, mainGauss3, weights, cs)@$$float4 mainColor = LookUpTableRGBAMainTex(_MainTex_LUT_TexelSize.zw, mainGaussTotal, mip)@$mainColor.rgb = ConvertColorspaceToRGB(mainColor.rgb, cs)@$$return mainColor@;4;Create;1;True;UV;FLOAT2;0,0;In;;Float;False;tex2DGaussMainTex;False;False;3;211;225;235;;False;1;0;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;36;-1632,-1584;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;351;-4032,912;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;150;-128,-432;Inherit;False;Property;_DetailedStochasticTiling;Detailed Stochastic Tiling;18;1;[Enum];Create;True;0;3;Off;0;Method by Rotoscope;1;Gaussian by Errormdl;2;0;False;2;Space(15);Header(Secondary Maps);False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-5152,-336;Inherit;False;Property;_NormalScale;Normal Scale;12;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-1904,1920;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;344;-4112,64;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;352;-3904,912;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-1904,1600;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;72;-1904,1728;Inherit;True;Property;_MetallicTex;Metallic Tex;5;1;[SingleLineTexture];Create;True;0;0;0;False;1;Header(Reflections);False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;110;-5248,1152;Inherit;False;1294.428;502.2498;Detailed Mask;8;133;97;98;101;105;89;99;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-5232,512;Inherit;False;Property;_SecondaryNormalScale;Secondary Normal Scale;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;33;-1248,-1456;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;43;-1952,592;Inherit;False;1606.575;863.0546;Ambient Occlusion;14;116;24;61;25;22;62;63;38;64;65;276;277;278;280;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;144,-432;Inherit;False;DetailedStochasticTiling;-1;True;1;0;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-1904,1024;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-1632,1632;Inherit;True;Property;_MetallicTex1;Metallic Tex1;5;2;[Gamma];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;345;-4064,144;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;191;-1008,-1376;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;354;-3712,912;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;90;-5216,592;Inherit;True;Property;_SecondaryNormalMap;Secondary Normal Map;20;0;Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;-3920,64;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;353;-3856,992;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CustomExpressionNode;67;-1616,1824;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;132;-1952,-928;Inherit;False;1366.072;684.9454;Detail Albedo x2;13;135;120;134;126;119;127;128;121;129;131;268;269;270;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;100;-5200,1280;Inherit;True;Property;_DetailMask;Detail Mask;15;1;[SingleLineTexture];Create;True;0;0;0;False;1;Header(Detail Mask);False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;51;-5200,-256;Inherit;True;Property;_NormalMap;Normal Map;10;1;[SingleLineTexture];Create;True;0;0;0;False;1;Header(Normal Map);False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1568,1552;Inherit;False;52;StochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;99;-5200,1472;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;251;-1456,2048;Float;False;float mip = 0@$float3 weights = float3(0,0,0)@$float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0@$RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2)@$//calculate derivatives to avoid triangular grid artifacts$float2 constDx = ddx(UV)@$float2 constDy = ddy(UV)@$$$//blend samples with calculated weights$float2 mainGauss1 = tex2Dgrad(_MetallicTex, UV + uvVertex0, constDx, constDy).ra@$float2 mainGauss2 = tex2Dgrad(_MetallicTex, UV + uvVertex1, constDx, constDy).ra@$float2 mainGauss3 = tex2Dgrad(_MetallicTex, UV + uvVertex2, constDx, constDy).ra@$$float2 mainGaussTotal = Blend3GaussianRA(mainGauss1, mainGauss2, mainGauss3, weights)@$$float4 mainColor = LookUpTableRAMetallicTex(_MetallicTex_LUT_TexelSize.zw, mainGaussTotal, mip)@$$return mainColor@;4;Create;1;True;UV;FLOAT2;0,0;In;;Float;False;tex2DGaussMetallicTex;False;False;3;211;225;235;;False;1;0;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;-5200,384;Inherit;False;0;90;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-5200,-464;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-880,-1312;Inherit;False;AlbedoAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;347;-3792,64;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;355;-3584,912;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;92;-4912,688;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), NormalScale), BW_vx[3].x) + $            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), NormalScale), BW_vx[3].y) + $            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), NormalScale), BW_vx[3].z)@;3;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;NormalScale;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-1904,-608;Inherit;False;0;90;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;70;-1072,1776;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-4912,-384;Inherit;True;Property;_NormalMap1;Normal Map1;6;2;[Normal];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;LockedToTexture2D;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;65;-1904,832;Inherit;True;Property;_Occlusion;Occlusion;13;1;[SingleLineTexture];Create;True;0;0;0;False;1;Header(Ambient Occlusion);False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-1904,704;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;53;-4848,-464;Inherit;False;52;StochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.CustomExpressionNode;49;-4912,-192;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), NormalScale), BW_vx[3].x) + $            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), NormalScale), BW_vx[3].y) + $            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), NormalScale), BW_vx[3].z)@;3;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;NormalScale;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-4896,416;Inherit;False;149;DetailedStochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;85;-4928,496;Inherit;True;Property;_SecondaryNormal1;Secondary Normal1;2;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;278;-1472,1152;Float;False;float mip = 0@$float3 weights = float3(0,0,0)@$float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0@$RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2)@$//calculate derivatives to avoid triangular grid artifacts$float2 constDx = ddx(UV)@$float2 constDy = ddy(UV)@$$$//blend samples with calculated weights$float mainGauss1 = tex2Dgrad(_Occlusion, UV + uvVertex0, constDx, constDy).g@$float mainGauss2 = tex2Dgrad(_Occlusion, UV + uvVertex1, constDx, constDy).g@$float mainGauss3 = tex2Dgrad(_Occlusion, UV + uvVertex2, constDx, constDy).g@$$float mainGaussTotal = Blend3GaussianRA(mainGauss1, mainGauss2, mainGauss3, weights)@$$float4 mainColor = LookUpTableGOcclusion(_Occlusion_LUT_TexelSize.zw, mainGaussTotal, mip)@$$return mainColor@;2;Create;1;True;UV;FLOAT2;0,0;In;;Float;False;tex2DGaussOcclusion;False;False;3;211;225;235;;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;89;-4912,1280;Inherit;True;Property;_DetailMask1;Detail Mask1;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;131;-1904,-800;Inherit;True;Property;_DetailAlbedox2;Detail Albedo x2;19;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;gray;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;127;-1600,-880;Inherit;False;149;DetailedStochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-800,1936;Inherit;False;190;AlbedoAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;47;-4560,-256;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;22;-1616,736;Inherit;True;Property;_Occlusion1;Occlusion1;8;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1552,656;Inherit;False;52;StochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;280;-1296,1152;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;68;-880,1776;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.IntNode;188;-752,1856;Inherit;False;Property;_Source;Source;9;1;[Enum];Create;True;0;2;Metallic Alpha;0;Albedo Alpha;1;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-1952,-208;Inherit;False;1462.757;760.379;Emission;11;274;273;272;32;56;31;57;16;58;59;60;;1,1,0,1;0;0
Node;AmplifyShaderEditor.SamplerNode;121;-1616,-800;Inherit;True;Property;_DetailAlbedox21;Detail Albedo x21;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;87;-3232,64;Inherit;False;Constant;_DefaultNormalVector;Default Normal Vector;1;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;105;-4352,1280;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ConditionalIfNode;95;-4560,496;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;63;-1616,944;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy).g, BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy).g, BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy).g, BW_vx[3].z)@;1;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;269;-1376,-464;Float;False;float mip = 0@$float3 weights = float3(0,0,0)@$float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0@$RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2)@$//calculate derivatives to avoid triangular grid artifacts$float2 constDx = ddx(UV)@$float2 constDy = ddy(UV)@$$colorspace cs@$	cs.axis0 = _CX@$	cs.axis1 = _CY@$	cs.axis2 = _CZ@$	cs.center = _CsCenter@$$//blend samples with calculated weights$float3 mainGauss1 = tex2Dgrad(_DetailAlbedox2, UV + uvVertex0, constDx, constDy).rgb@$float3 mainGauss2 = tex2Dgrad(_DetailAlbedox2, UV + uvVertex1, constDx, constDy).rgb@$float3 mainGauss3 = tex2Dgrad(_DetailAlbedox2, UV + uvVertex2, constDx, constDy).rgb@$$float3 mainGaussTotal = Blend3GaussianRGB(mainGauss1, mainGauss2, mainGauss3, weights, cs)@$$float4 mainColor = LookUpTableRGBDetailAlbedox2(_DetailAlbedox2_LUT_TexelSize.zw, mainGaussTotal, mip)@$mainColor.rgb = ConvertColorspaceToRGB(mainColor.rgb, cs)@$$return mainColor@;4;Create;1;True;UV;FLOAT2;0,0;In;;Float;False;tex2DGaussDetailAlbedox2;False;False;3;211;225;235;;False;1;0;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;128;-1616,-608;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ConditionalIfNode;189;-624,1856;Inherit;False;False;5;0;INT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-1904,192;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;82;-2912,-32;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;86;-2912,160;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorSpaceDouble;119;-1232,-640;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;60;-1904,-16;Inherit;True;Property;_Emission;Emission;17;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;25;-1200,1056;Inherit;False;Property;_OcclusionBlend;Occlusion Blend;14;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;126;-1232,-800;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-736,1760;Inherit;False;Property;_Metallic;Metallic;6;1;[Gamma];Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;61;-1104,880;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-4208,1344;Inherit;False;DetailedMaskAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-736,2032;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1616,-64;Inherit;True;Property;_Emission1;Emission1;10;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;81;-2672,48;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-448,1760;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-448,1856;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;24;-912,880;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-1024,-672;Inherit;False;133;DetailedMaskAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;58;-1616,128;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;26;-1248,-1632;Inherit;False;Property;_MainColor;Main Color;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-976,-800;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;274;-1456,320;Float;False;float mip = 0@$float3 weights = float3(0,0,0)@$float2 uvVertex0 = 0, uvVertex1 = 0, uvVertex2 = 0@$RandomOffsetTiling(UV * _TilingScale, weights, uvVertex0, uvVertex1, uvVertex2)@$//calculate derivatives to avoid triangular grid artifacts$float2 constDx = ddx(UV)@$float2 constDy = ddy(UV)@$$colorspace cs@$	cs.axis0 = _CX@$	cs.axis1 = _CY@$	cs.axis2 = _CZ@$	cs.center = _CsCenter@$$//blend samples with calculated weights$float3 mainGauss1 = tex2Dgrad(_Emission, UV + uvVertex0, constDx, constDy).rgb@$float3 mainGauss2 = tex2Dgrad(_Emission, UV + uvVertex1, constDx, constDy).rgb@$float3 mainGauss3 = tex2Dgrad(_Emission, UV + uvVertex2, constDx, constDy).rgb@$$float3 mainGaussTotal = Blend3GaussianRGB(mainGauss1, mainGauss2, mainGauss3, weights, cs)@$$float4 mainColor = LookUpTableRGBEmission(_Emission_LUT_TexelSize.zw, mainGaussTotal, mip)@$mainColor.rgb = ConvertColorspaceToRGB(mainColor.rgb, cs)@$$return mainColor@;4;Create;1;True;UV;FLOAT2;0,0;In;;Float;False;tex2DGaussEmission;False;False;3;211;225;235;;False;1;0;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1552,-144;Inherit;False;52;StochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-304,1856;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-304,1760;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-2464,48;Inherit;False;TangentNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;45;-128,-224;Inherit;False;458.6365;147.8446;Stochastic Hash, source: https://redd.it/dhr5g2;1;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ConditionalIfNode;56;-1264,64;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1008,-1472;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;247;256,16;Inherit;False;1558.204;467.5031;Source: https://github.com/Error-mdl/UnityGaussianTex;12;211;235;204;228;236;225;203;202;248;201;258;283;Gaussian constants;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;31;-1264,-112;Inherit;False;Property;_EmissionColor;Emission Color;16;0;Create;True;0;0;0;False;1;Header(Emission);False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-752,880;Inherit;False;AmbientOcclusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;135;-816,-816;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;193;-16,544;Inherit;False;Property;_SPECULARHIGHLIGHTS;Specular Highlights;34;0;Create;False;0;0;0;True;1;Header(Forward Rendering Options);False;0;1;1;True;_SPECULARHIGHLIGHTS_OFF;ToggleOff;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;335;-3344,-1696;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy).r, BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy).r, BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy).r, BW_vx[3].z)@;1;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;7;-16,-176;Float;False;return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453)@;2;Create;1;True;s;FLOAT2;0,0;In;;Float;False;hash2D2D;False;True;0;;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;291;-3664,-1504;Float;False;Property;_Parallax;Parallax;8;0;Create;True;0;0;0;False;0;False;0;0.01;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;273;-1680,320;Inherit;False;uint3 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0))@$			    uint LUTWidth = (uint)lutDim.x@$			    uint LUTModW = LUTWidth - 1@ // x % y is equivalent to x & (y - 1) if y is power of 2$			    uint LUTDivW = firstbithigh(LUTWidth)@ // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)$				# ifndef SHADER_TARGET_SURFACE_ANALYSIS$			    float3 sample1 = float3($			        _Emission_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,$			        _Emission_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,$			        _Emission_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b$			        )@$				#else // we need to do this so that the surface compiler isnt stripping the texture$				float3 sample1 = float3($					SAMPLE_TEXTURE2D_ARRAY_LOD(_Emission_LUT, sampler_Emission_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_Emission_LUT, sampler_Emission_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_Emission_LUT, sampler_Emission_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b$				)@$				#endif$					return float4(sample1, 1)@;4;Create;3;True;lutDim;FLOAT2;0,0;In;;Inherit;False;True;coords;FLOAT3;0,0,0;In;const float4;Inherit;False;True;mip;FLOAT;0;In;const  float;Inherit;False;LookUpTableRGBEmission;False;True;1;214;;False;3;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;283;1136,64;Inherit;False;float3 gaussian = float3(cs.axis0.w, cs.axis1.w, cs.axis2.w) * ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float3(0.5,0.5,0.5))$            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float3(0.5, 0.5, 0.5)@$        return saturate(gaussian)@;3;Create;5;True;gaussian1;FLOAT3;0,0,0;In;;Inherit;False;True;gaussian2;FLOAT3;0,0,0;In;;Inherit;False;True;gaussian3;FLOAT3;0,0,0;In;;Inherit;False;True;weights;FLOAT3;0,0,0;In;;Inherit;False;True;cs;OBJECT;;In;colorspace;Inherit;False;Blend3GaussianRGB;False;True;1;214;;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;260;-1680,-1184;Inherit;False;uint4 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0))@$			    uint LUTWidth = (uint)lutDim.x@$			    uint LUTModW = LUTWidth - 1@ // x % y is equivalent to x & (y - 1) if y is power of 2$			    uint LUTDivW = firstbithigh(LUTWidth)@ // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)$				# ifndef SHADER_TARGET_SURFACE_ANALYSIS$			    float4 sample1 = float4($			        _MainTex_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,$			        _MainTex_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,$			        _MainTex_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b,$			        _MainTex_LUT.Load(int4(coords1.w & LUTModW, coords1.w >> LUTDivW, mip, 0)).a$			        )@$				#else // we need to do this so that the surface compiler isnt stripping the texture$				float4 sample1 = float4($					SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_MainTex_LUT, sampler_MainTex_LUT, float3(coords1.w & LUTModW, coords1.w >> LUTDivW, 0.0), mip).a$				)@$				#endif$					return sample1@;4;Create;3;True;lutDim;FLOAT2;0,0;In;;Inherit;False;True;coords;FLOAT4;0,0,0,0;In;const float4;Inherit;False;True;mip;FLOAT;0;In;const  float;Inherit;False;LookUpTableRGBAMainTex;False;True;1;214;;False;3;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;281;16,-720;Inherit;False;Property;_ShaderOptimizerEnabled;PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER;0;0;Create;False;0;0;0;True;1;ShaderOptimizerLockButton;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;328;-3200,-1232;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode;299;-3168,-1728;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-272,112;Inherit;False;112;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;268;-1632,-464;Inherit;False;uint3 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0))@$			    uint LUTWidth = (uint)lutDim.x@$			    uint LUTModW = LUTWidth - 1@ // x % y is equivalent to x & (y - 1) if y is power of 2$			    uint LUTDivW = firstbithigh(LUTWidth)@ // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)$				# ifndef SHADER_TARGET_SURFACE_ANALYSIS$			    float3 sample1 = float3($			        _DetailAlbedox2_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,$			        _DetailAlbedox2_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,$			        _DetailAlbedox2_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b$			        )@$				#else // we need to do this so that the surface compiler isnt stripping the texture$				float3 sample1 = float3($					SAMPLE_TEXTURE2D_ARRAY_LOD(_DetailAlbedox2_LUT, sampler_DetailAlbedox2_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_DetailAlbedox2_LUT, sampler_DetailAlbedox2_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_DetailAlbedox2_LUT, sampler_DetailAlbedox2_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b$				)@$				#endif$					return float4(sample1, 1)@;4;Create;3;True;lutDim;FLOAT2;0,0;In;;Inherit;False;True;coords;FLOAT3;0,0,0;In;const float4;Inherit;False;True;mip;FLOAT;0;In;const  float;Inherit;False;LookUpTableRGBDetailAlbedox2;False;True;1;214;;False;3;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-272,0;Inherit;False;108;TangentNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;202;496,272;Inherit;False;Property;_CX;CX;23;1;[HideInInspector];Create;True;0;0;0;True;0;False;0,0,0,0;0.0178384,-0.1237444,0.357076,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;249;-1904,2048;Inherit;True;Property;_MetallicTex_LUT;MetallicTex Lookup Table;27;0;Fetch;False;0;0;0;True;0;False;None;None;False;white;LockedToTexture2DArray;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;236;784,64;Inherit;False;Property;_TilingScale;TilingScale;33;0;Create;True;0;0;0;True;0;False;1.732051;1.732051;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;332;-3344,-1520;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy).r, BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy).r, BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy).r, BW_vx[3].z)@;1;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;187;144,-176;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector4Node;201;288,272;Inherit;False;Property;_CsCenter;CsCenter;22;1;[HideInInspector];Create;True;0;0;0;True;0;False;0,0,0,0;0.1661971,-0.1369825,-0.1860984,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;101;-4912,1472;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-272,272;Inherit;False;116;AmbientOcclusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;276;-1904,1152;Inherit;True;Property;_Occlusion_LUT;Occlusion Lookup Table;29;0;Fetch;False;0;0;0;True;0;False;None;None;False;white;LockedToTexture2DArray;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CustomExpressionNode;334;-3360,-1344;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy).r, BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy).r, BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy).r, BW_vx[3].z)@;1;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;228;336,64;Inherit;False;$	return frac(sin(mul(float2x2(137.231, 512.37, 199.137, 373.351), input)) * 23597.3733)@$;2;Create;1;True;input;FLOAT2;0,0;In;;Inherit;False;hash2;False;True;0;;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;270;-1904,-464;Inherit;True;Property;_DetailAlbedox2_LUT;Detail Albedo x2 Lookup Table;31;0;Fetch;False;0;0;0;True;0;False;None;None;False;white;LockedToTexture2DArray;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;98;-4848,1200;Inherit;False;52;StochasticTiling;1;0;OBJECT;;False;1;INT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;330;-3168,-1200;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;259;-4960,64;Inherit;False;uint4 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0))@$			    uint LUTWidth = (uint)lutDim.x@$			    uint LUTModW = LUTWidth - 1@ // x % y is equivalent to x & (y - 1) if y is power of 2$			    uint LUTDivW = firstbithigh(LUTWidth)@ // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)$				# ifndef SHADER_TARGET_SURFACE_ANALYSIS$			    float4 sample1 = float4($			        _NormalMap_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,$			        _NormalMap_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,$			        _NormalMap_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b,$			        _NormalMap_LUT.Load(int4(coords1.w & LUTModW, coords1.w >> LUTDivW, mip, 0)).a$			        )@$				#else // we need to do this so that the surface compiler isnt stripping the texture$				float4 sample1 = float4($					SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_NormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.w & LUTModW, coords1.w >> LUTDivW, 0.0), mip).a$				)@$				#endif$					return sample1@;4;Create;3;True;lutDim;FLOAT2;0,0;In;;Inherit;False;True;coords;FLOAT4;0,0,0,0;In;const float4;Inherit;False;True;mip;FLOAT;0;In;const  float;Inherit;False;LookUpTableRGBANormalMap;False;True;1;214;;False;3;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StickyNoteNode;282;256,544;Inherit;False;1294;154;Adding a new Texture;Gaussian Edits;1,1,1,1;1. duplicate the correct LookUpTable* and tex2DGauss* custom nodes and the LUT Texture Array that you need for your new Texture, keep in mind that choosing the right Gaussian setup for the texture you are going to use is crucial !!! Normal Maps are handled in a specific way, same goes for Ambient Occlusion, Metallic, Emission and Albedo. To edit the GaussianTex setups requires knowledge of the internals of the feature.$2. exchange all Texture names with the new ones$3. Define new: "Texture2DArray<fixed4> *, UNITY_DECLARE_TEX2DARRAY_NOSAMPLER *, *_LUT_TexelSize, SamplerState sampler_*" in the Additional Directives$4. In the Custom Nodes you copied you have to change all Names from the past Textures to the new texture including Texelsize names etc.;0;0
Node;AmplifyShaderEditor.IntNode;285;-16,-528;Inherit;False;Property;_SecondaryNormalScaleAnimated;Secondary Normal Scale Animated;37;1;[HideInInspector];Create;True;0;0;0;True;1;ToggleUI;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.CustomExpressionNode;211;944,64;Inherit;False;		float4 gaussian = float4(cs.axis0.w, cs.axis1.w, cs.axis2.w, 1) * ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float4(0.5,0.5,0.5,0.5))$            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float4(0.5, 0.5, 0.5, 0.5)@$        return saturate(gaussian)@;4;Create;5;True;gaussian1;FLOAT4;0,0,0,0;In;;Inherit;False;True;gaussian2;FLOAT4;0,0,0,0;In;;Inherit;False;True;gaussian3;FLOAT4;0,0,0,0;In;;Inherit;False;True;weights;FLOAT3;0,0,0;In;;Inherit;False;True;cs;OBJECT;;In;colorspace;Inherit;False;Blend3GaussianRGBA;False;True;1;214;;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;4;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1040,48;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-272,192;Inherit;False;113;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;254;-5200,64;Inherit;True;Property;_NormalMap_LUT;Normal Map Lookup Table;28;0;Fetch;False;0;0;0;True;0;False;None;None;False;white;LockedToTexture2DArray;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector4Node;203;720,272;Inherit;False;Property;_CY;CY;24;1;[HideInInspector];Create;True;0;0;0;True;0;False;0,0,0,0;0.7077192,0.578709,0.1651957,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;194;-16,640;Inherit;False;Property;_GLOSSYREFLECTIONS;Reflections;35;0;Create;False;0;0;0;True;0;False;0;1;1;True;_GLOSSYREFLECTIONS_OFF;ToggleOff;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;97;-4528,1280;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;266;-5200,912;Inherit;True;Property;_SecondaryNormalMap_LUT;Secondary Normal Map Lookup Table;32;0;Fetch;False;0;0;0;True;0;False;None;None;False;white;LockedToTexture2DArray;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;303;-2896,-1616;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;326;-2896,-1248;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;248;1328,64;Inherit;False;float2 gaussian = ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float2(0.5,0.5))$            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float2(0.5, 0.5)@$        return saturate(gaussian)@;2;Create;4;True;gaussian1;FLOAT2;0,0;In;;Inherit;False;True;gaussian2;FLOAT2;0,0;In;;Inherit;False;True;gaussian3;FLOAT2;0,0;In;;Inherit;False;True;weights;FLOAT3;0,0,0;In;;Inherit;False;Blend3GaussianRA;False;True;1;214;;False;4;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;76;32,448;Inherit;False;Property;_Culling;Culling;1;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;False;0;1;INT;0
Node;AmplifyShaderEditor.StickyNoteNode;339;-2800,-1664;Inherit;False;488;391;Height Mapping Info;;1,1,1,1;use this in all other textures for height mapping.$height mapping still needs to be setup for GaussianTex and for no stochastic sampling.$$Why are we not using Height mapping in this shader yet you might ask.$$1. Performance. Well, to break it down, i would need to implement a Height map and sample it 4 times just for the general Height mapping part, now when we want to stochastic sample the height map we need to sample 4x3 which is too much for just one single feature in my book. You caaaan do that and i experimented with that, its totally possible but im not going to implement it solely on that fact already but then there is also:$2. Also we ran out of texture slots and would need to reuse two samplerstates from another texture which i dont quite like.;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;235;304,144;Inherit;False;$    return (lutColor.r * cs.axis0.xyz + lutColor.g * cs.axis1.xyz + lutColor.b * cs.axis2.xyz) + cs.center.xyz@$;3;Create;2;True;lutColor;FLOAT3;0,0,0;In;;Inherit;False;True;cs;OBJECT;;In;colorspace;Inherit;False;ConvertColorspaceToRGB;False;True;0;;False;2;0;FLOAT3;0,0,0;False;1;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ParallaxMappingNode;308;-3168,-1552;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;204;928,272;Inherit;False;Property;_CZ;CZ;25;1;[HideInInspector];Create;True;0;0;0;True;0;False;0,0,0,0;-0.3246861,0.3571105,0.1399766,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;250;-1664,2048;Inherit;False;uint2 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0))@$uint LUTWidth = (uint)lutDim.x@$uint LUTModW = LUTWidth - 1@ // x % y is equivalent to x & (y - 1) if y is power of 2$uint LUTDivW = firstbithigh(LUTWidth)@ // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)$				# ifndef SHADER_TARGET_SURFACE_ANALYSIS$			    float4 sample1 = float4($			        _MetallicTex_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,$			        0,$			        0,$			        _MetallicTex_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).a$			        )@$				#else // we need to do this so that the surface compiler isnt stripping the texture$				float4 sample1 = float4($					SAMPLE_TEXTURE2D_ARRAY_LOD(_MetallicTex_LUT, sampler_MetallicTex_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,$					0,$					0,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_MetallicTex_LUT, sampler_MetallicTex_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).a$				)@$				#endif$					return sample1@;4;Create;3;True;lutDim;FLOAT2;0,0;In;;Inherit;False;True;coords;FLOAT2;0,0;In;const float4;Inherit;False;True;mip;FLOAT;0;In;const  float;Inherit;False;LookUpTableRAMetallicTex;False;True;1;214;;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-560,-832;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;316;-3200,-1408;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;331;-2752,-1200;Float;False;Offset;1;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;225;528,64;Inherit;False;$	float2x2 ShearedUVSpace = float2x2(-TAN_30, 1, TWO_TAN_30, 0)@ //WHY MUST TAN 30 BE NEGATIVE? WHY? IT SHOULDN"T BE BUT IT DOESN'T WORK OTHERWISE. I CAN'T FUCKING MATH. that was Errors comment not mine :D$$	float2 shearedUVs = mul(ShearedUVSpace, uv)@$	float2 intSUVs = floor(shearedUVs)@$	float2 fracSUVs = frac(shearedUVs)@$	float Ternary3rdComponent = 1.0 - fracSUVs.x - fracSUVs.y@$	float2 vertex0Offset = Ternary3rdComponent > 0 ? float2(0, 0) : float2(1, 1)@$	float2 hashVertex0 = intSUVs + vertex0Offset@$	float2 hashVertex1 = intSUVs + float2(0, 1)@$	float2 hashVertex2 = intSUVs + float2(1, 0)@$	hashVertex0 = hash2(hashVertex0)@$	hashVertex1 = hash2(hashVertex1)@$	hashVertex2 = hash2(hashVertex2)@$	/*$	float sin0, cos0, sin1, cos1, sin2, cos2@$	sincos(0.5 * (hashVertex0.x + hashVertex0.y) - 0.25, sin0, cos0)@$	sincos(0.5 * (hashVertex1.x + hashVertex1.y) - 0.25, sin1, cos1)@$	sincos(0.5 * (hashVertex2.x + hashVertex2.y) - 0.25, sin2, cos2)@$    */$	uvVertex0 += hashVertex0@$	uvVertex1 += hashVertex1@$	uvVertex2 += hashVertex2@$	$	/*$	uvVertex0 = uv * lerp(0.8, 1.2, hashVertex0.x)  + hashVertex0@$	uvVertex1 = uv * lerp(0.8, 1.2, hashVertex1.x) + hashVertex1@$	uvVertex2 = uv * lerp(0.8, 1.2, hashVertex2.x) + hashVertex2@$	*/$	if (Ternary3rdComponent > 0)$	{$		triWeights = float3(Ternary3rdComponent, fracSUVs.y, fracSUVs.x)@$	}$	else$	{$		triWeights = float3(-Ternary3rdComponent, 1.0 - fracSUVs.x, 1.0 - fracSUVs.y)@$	}$;7;Create;5;True;uv;FLOAT2;0,0;In;;Inherit;False;True;triWeights;FLOAT3;0,0,0;InOut;;Inherit;False;True;uvVertex0;FLOAT2;0,0;InOut;;Inherit;False;True;uvVertex1;FLOAT2;0,0;InOut;;Inherit;False;True;uvVertex2;FLOAT2;0,0;InOut;;Inherit;False;RandomOffsetTiling;False;True;1;228;;False;6;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;5;FLOAT;0;FLOAT3;3;FLOAT2;4;FLOAT2;5;FLOAT2;6
Node;AmplifyShaderEditor.ParallaxMappingNode;319;-3168,-1376;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;333;-3360,-1168;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy).r, BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy).r, BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy).r, BW_vx[3].z)@;1;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;284;16,-624;Inherit;False;Property;_NormalScaleAnimated;Normal Scale Animated;36;1;[HideInInspector];Create;True;0;0;0;True;1;ToggleUI;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.TexturePropertyNode;217;-1904,-1184;Inherit;True;Property;_MainTex_LUT;MainTex Lookup Table;26;1;[Header];Fetch;False;1;LOOKUP TABLES;0;0;True;0;False;None;None;False;white;LockedToTexture2DArray;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CustomExpressionNode;277;-1664,1152;Inherit;False;uint coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0))@$uint LUTWidth = (uint)lutDim.x@$uint LUTModW = LUTWidth - 1@ // x % y is equivalent to x & (y - 1) if y is power of 2$uint LUTDivW = firstbithigh(LUTWidth)@ // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)$				# ifndef SHADER_TARGET_SURFACE_ANALYSIS$			    float4 sample1 = float4($			        0,$			        _Occlusion_LUT.Load(int4(coords1 & LUTModW, coords1 >> LUTDivW, mip, 0)).g,$			        0,$			        1$			        )@$				#else // we need to do this so that the surface compiler isnt stripping the texture$				float4 sample1 = float4($					0,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_Occlusion_LUT, sampler_Occlusion_LUT, float3(coords1 & LUTModW, coords1 >> LUTDivW, 0.0), mip).g,$					0,$					1$				)@$				#endif$					return sample1@;4;Create;3;True;lutDim;FLOAT2;0,0;In;;Inherit;False;True;coords;FLOAT;0;In;const float4;Inherit;False;True;mip;FLOAT;0;In;const  float;Inherit;False;LookUpTableGOcclusion;False;True;1;214;;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;290;-3600,-1424;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;272;-1904,320;Inherit;True;Property;_Emission_LUT;Emission Lookup Table;30;0;Fetch;False;0;0;0;True;0;False;None;None;False;white;LockedToTexture2DArray;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;289;-3600,-1728;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;258;1520,64;Inherit;False;float4 gaussian = ((weights.x * gaussian1 + weights.y * gaussian2 + weights.z * gaussian3 - float4(0.5,0.5,0.5,0.5))$            / sqrt(weights.x * weights.x + weights.y * weights.y + weights.z * weights.z)) + float4(0.5, 0.5, 0.5, 0.5)@$        return saturate(gaussian)@;4;Create;4;True;gaussian1;FLOAT4;0,0,0,0;In;;Inherit;False;True;gaussian2;FLOAT4;0,0,0,0;In;;Inherit;False;True;gaussian3;FLOAT4;0,0,0,0;In;;Inherit;False;True;weights;FLOAT3;0,0,0;In;;Inherit;False;Blend3GaussianRGBANoCs;False;True;1;214;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;313;-2896,-1424;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;306;-3200,-1584;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;292;-3616,-1936;Inherit;True;Property;_HeightMap;HeightMap;11;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CustomExpressionNode;264;-4880,912;Inherit;False;uint4 coords1 = floor(coords * (lutDim.x * lutDim.y - 1.0))@$			    uint LUTWidth = (uint)lutDim.x@$			    uint LUTModW = LUTWidth - 1@ // x % y is equivalent to x & (y - 1) if y is power of 2$			    uint LUTDivW = firstbithigh(LUTWidth)@ // LUTWidth is a power of 2, so firstbithigh gives log2(LUTWidth)$				# ifndef SHADER_TARGET_SURFACE_ANALYSIS$			    float4 sample1 = float4($			        _SecondaryNormalMap_LUT.Load(int4(coords1.x & LUTModW, coords1.x >> LUTDivW, mip, 0)).r,$			        _SecondaryNormalMap_LUT.Load(int4(coords1.y & LUTModW, coords1.y >> LUTDivW, mip, 0)).g,$			        _SecondaryNormalMap_LUT.Load(int4(coords1.z & LUTModW, coords1.z >> LUTDivW, mip, 0)).b,$			        _SecondaryNormalMap_LUT.Load(int4(coords1.w & LUTModW, coords1.w >> LUTDivW, mip, 0)).a$			        )@$				#else // we need to do this so that the surface compiler isnt stripping the texture$				//btw we are reusing the samplerstate of the _NormalMap here since we ran out of Texture slots and this should not matter too much for the enduser hopefully$				float4 sample1 = float4($					SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.x & LUTModW, coords1.x >> LUTDivW, 0.0), mip).r,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.y & LUTModW, coords1.y >> LUTDivW, 0.0), mip).g,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.z & LUTModW, coords1.z >> LUTDivW, 0.0), mip).b,$					SAMPLE_TEXTURE2D_ARRAY_LOD(_SecondaryNormalMap_LUT, sampler_NormalMap_LUT, float3(coords1.w & LUTModW, coords1.w >> LUTDivW, 0.0), mip).a$				)@$				#endif$					return sample1@;4;Create;3;True;lutDim;FLOAT2;0,0;In;;Inherit;False;True;coords;FLOAT4;0,0,0,0;In;const float4;Inherit;False;True;mip;FLOAT;0;In;const  float;Inherit;False;LookUpTableRGBASecondaryNormalMap;False;True;1;214;;False;3;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;Moriohs Shaders/Standard/Standard Stochastic Metallic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;Standard;-1;-1;-1;-1;0;False;0;0;True;76;-1;0;False;-1;45;Custom;#define TWO_TAN_30 1.154700538;False;;Custom;Custom;#define TAN_30     0.577350269;False;;Custom;Custom;struct colorspace;False;;Custom;Custom;{;False;;Custom;Custom;float4 axis0@ ////< First basis vector of the colorspace in the xyz components, inverse length of the axis in w;False;;Custom;Custom;float4 axis1@ ////< Second basis vector of the colorspace in the xyz components, inverse length of the axis in w;False;;Custom;Custom;float4 axis2@ ////< Third basis vector of the colorspace in the xyz components, inverse length of the axis in w;False;;Custom;Custom;float4 center@ ///< Center of the colorspace in the xyz components, w is unused;False;;Custom;Custom;}@;False;;Custom;Custom;#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros;False;;Custom;Custom;#define SAMPLE_TEXTURE2D_ARRAY_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod);False;;Custom;Custom;#else //ASE discards identical directives1;False;;Custom;Custom;#define SAMPLE_TEXTURE2D_ARRAY_LOD(tex,samplertex,coord,lod) tex2DArraylod(tex, float4(coord,lod));False;;Custom;Custom;#endif //ASE discards identical directives1;False;;Custom;Custom;#ifndef SHADER_TARGET_SURFACE_ANALYSIS;False;;Custom;Custom;Texture2DArray<fixed4> _MainTex_LUT@;False;;Custom;Custom;Texture2DArray<fixed4> _MetallicTex_LUT@;False;;Custom;Custom;Texture2DArray<fixed4> _NormalMap_LUT@;False;;Custom;Custom;Texture2DArray<fixed4> _SecondaryNormalMap_LUT@;False;;Custom;Custom;Texture2DArray<fixed4> _DetailAlbedox2_LUT@;False;;Custom;Custom;Texture2DArray<fixed4> _Emission_LUT@;False;;Custom;Custom;Texture2DArray<fixed4> _Occlusion_LUT@;False;;Custom;Custom;#else //ASE discards identical directives2;False;;Custom;Custom;UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_MainTex_LUT)@;False;;Custom;Custom;UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_MetallicTex_LUT)@;False;;Custom;Custom;UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_NormalMap_LUT)@;False;;Custom;Custom;UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_SecondaryNormalMap_LUT)@;False;;Custom;Custom;UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_DetailAlbedox2_LUT)@;False;;Custom;Custom;UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Emission_LUT)@;False;;Custom;Custom;UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Occlusion_LUT)@;False;;Custom;Custom;#endif //ASE discards identical directives2;False;;Custom;Custom;float4 _MainTex_LUT_TexelSize@;False;;Custom;Custom;float4 _MetallicTex_LUT_TexelSize@;False;;Custom;Custom;float4 _NormalMap_LUT_TexelSize@;False;;Custom;Custom;float4 _SecondaryNormalMap_LUT_TexelSize@;False;;Custom;Custom;float4 _DetailAlbedox2_LUT_TexelSize@;False;;Custom;Custom;float4 _Emission_LUT_TexelSize@;False;;Custom;Custom;float4 _Occlusion_LUT_TexelSize@;False;;Custom;Custom;SamplerState sampler_MainTex_LUT@;False;;Custom;Custom;SamplerState sampler_MetallicTex_LUT@;False;;Custom;Custom;SamplerState sampler_NormalMap_LUT@;False;;Custom;Custom;SamplerState sampler_SecondaryNormalMap_LUT@ //we are not using this samplerstate since we ran out of texture slots and needed to reuse the samplerstate of _NormalMap;False;;Custom;Custom;SamplerState sampler_DetailAlbedox2_LUT@;False;;Custom;Custom;SamplerState sampler_Emission_LUT@;False;;Custom;Custom;SamplerState sampler_Occlusion_LUT@;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;265;0;93;0
WireConnection;255;0;50;0
WireConnection;340;0;255;0
WireConnection;348;0;265;0
WireConnection;349;0;348;0
WireConnection;52;0;34;0
WireConnection;341;0;340;0
WireConnection;343;0;341;0
WireConnection;343;1;342;0
WireConnection;8;0;9;0
WireConnection;8;1;11;0
WireConnection;230;0;11;0
WireConnection;36;0;9;0
WireConnection;351;0;349;0
WireConnection;351;1;350;0
WireConnection;344;0;343;0
WireConnection;352;0;351;0
WireConnection;33;1;54;0
WireConnection;33;2;36;0
WireConnection;33;3;8;0
WireConnection;33;4;230;0
WireConnection;149;0;150;0
WireConnection;28;0;72;0
WireConnection;28;1;37;0
WireConnection;345;0;343;0
WireConnection;191;0;33;0
WireConnection;354;0;352;0
WireConnection;354;1;91;0
WireConnection;346;0;344;0
WireConnection;346;1;15;0
WireConnection;353;0;351;0
WireConnection;67;0;72;0
WireConnection;67;1;69;0
WireConnection;251;0;69;0
WireConnection;190;0;191;3
WireConnection;347;0;346;0
WireConnection;347;2;345;2
WireConnection;355;0;354;0
WireConnection;355;2;353;2
WireConnection;92;0;90;0
WireConnection;92;1;93;0
WireConnection;92;2;91;0
WireConnection;70;1;71;0
WireConnection;70;2;28;0
WireConnection;70;3;67;0
WireConnection;70;4;251;0
WireConnection;12;0;51;0
WireConnection;12;1;39;0
WireConnection;12;5;15;0
WireConnection;49;0;51;0
WireConnection;49;1;50;0
WireConnection;49;2;15;0
WireConnection;85;0;90;0
WireConnection;85;1;94;0
WireConnection;85;5;91;0
WireConnection;278;0;64;0
WireConnection;89;0;100;0
WireConnection;89;1;99;0
WireConnection;47;1;53;0
WireConnection;47;2;12;0
WireConnection;47;3;49;0
WireConnection;47;4;347;0
WireConnection;22;0;65;0
WireConnection;22;1;38;0
WireConnection;280;0;278;0
WireConnection;68;0;70;0
WireConnection;121;0;131;0
WireConnection;121;1;129;0
WireConnection;105;0;89;0
WireConnection;95;1;96;0
WireConnection;95;2;85;0
WireConnection;95;3;92;0
WireConnection;95;4;355;0
WireConnection;63;0;65;0
WireConnection;63;1;64;0
WireConnection;269;0;129;0
WireConnection;128;0;131;0
WireConnection;128;1;129;0
WireConnection;189;0;188;0
WireConnection;189;3;192;0
WireConnection;189;4;68;3
WireConnection;82;0;87;0
WireConnection;82;1;47;0
WireConnection;82;2;105;1
WireConnection;86;0;87;0
WireConnection;86;1;95;0
WireConnection;86;2;105;3
WireConnection;126;1;127;0
WireConnection;126;2;121;0
WireConnection;126;3;128;0
WireConnection;126;4;269;0
WireConnection;61;1;62;0
WireConnection;61;2;22;2
WireConnection;61;3;63;0
WireConnection;61;4;280;1
WireConnection;133;0;105;3
WireConnection;16;0;60;0
WireConnection;81;0;82;0
WireConnection;81;1;86;0
WireConnection;29;0;68;0
WireConnection;29;1;20;0
WireConnection;30;0;189;0
WireConnection;30;1;21;0
WireConnection;24;1;61;0
WireConnection;24;2;25;0
WireConnection;58;0;60;0
WireConnection;58;1;59;0
WireConnection;120;0;126;0
WireConnection;120;1;119;0
WireConnection;274;0;59;0
WireConnection;113;0;30;0
WireConnection;112;0;29;0
WireConnection;108;0;81;0
WireConnection;56;1;57;0
WireConnection;56;2;16;0
WireConnection;56;3;58;0
WireConnection;56;4;274;0
WireConnection;27;0;26;0
WireConnection;27;1;33;0
WireConnection;116;0;24;0
WireConnection;135;1;120;0
WireConnection;135;2;134;0
WireConnection;335;0;292;0
WireConnection;335;1;289;0
WireConnection;328;0;326;0
WireConnection;299;0;289;0
WireConnection;299;1;335;0
WireConnection;299;2;291;0
WireConnection;299;3;290;0
WireConnection;332;0;292;0
WireConnection;332;1;299;0
WireConnection;101;0;100;0
WireConnection;101;1;99;0
WireConnection;334;0;292;0
WireConnection;334;1;308;0
WireConnection;330;0;328;0
WireConnection;330;1;333;0
WireConnection;330;2;291;0
WireConnection;330;3;290;0
WireConnection;32;0;31;0
WireConnection;32;1;56;0
WireConnection;97;1;98;0
WireConnection;97;2;89;0
WireConnection;97;3;101;0
WireConnection;303;0;299;0
WireConnection;326;0;319;0
WireConnection;308;0;306;0
WireConnection;308;1;332;0
WireConnection;308;2;291;0
WireConnection;308;3;290;0
WireConnection;146;0;27;0
WireConnection;146;1;135;0
WireConnection;316;0;313;0
WireConnection;331;0;330;0
WireConnection;319;0;316;0
WireConnection;319;1;334;0
WireConnection;319;2;291;0
WireConnection;319;3;290;0
WireConnection;333;0;292;0
WireConnection;333;1;319;0
WireConnection;313;0;308;0
WireConnection;306;0;303;0
WireConnection;0;0;146;0
WireConnection;0;1;111;0
WireConnection;0;2;32;0
WireConnection;0;3;114;0
WireConnection;0;4;115;0
WireConnection;0;5;117;0
ASEEND*/
//CHKSM=6EB1A6B3A33B38618746A440D05BC509C882C2BC