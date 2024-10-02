// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Moriohs Shaders/Enviroment Shaders/Water"
{
	Properties
	{
		[ShaderOptimizerLockButton]_ShaderOptimizerEnabled("PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER", Float) = 0
		[HideInInspector]_NdLfade("NdL fade", Range( 0 , 1)) = 0.75
		[Header(MAIN OPTIONS)]_Color("Color", Color) = (0,0.4078431,0.6901961,1)
		_ColorSecondary("Color Secondary", Color) = (0,1,0.8705882,0.5019608)
		[Enum(Off,0,On,1)]_ZWrite("ZWrite", Int) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Int) = 0
		_Depth("Opacity Depth", Range( 0 , 0.999)) = 0.85
		_UVTiling("UV Tiling", Float) = 0.5
		_GeneralDepth("General Depth", Float) = 10
		_GrabPassDistortion("GrabPass Distortion", Range( 0 , 0.2)) = 0.15
		_NdLfade("NdL fade", Range( 0 , 1)) = 0.75
		[Header(Backside)]_BacksideWaterColor("Backside Water Color", Range( 0 , 1)) = 0.25
		_fresnelbias("fresnel bias", Float) = 0
		_fresnelscale("fresnel scale", Float) = 1
		_fresnelpower("fresnel power", Float) = 5
		[Space(25)][Header(CAUSTICS)]_CausticIntensity("Caustic Intensity", Float) = 1
		_CausticsScale("Caustics Scale", Float) = 3
		[Space(25)][Header(BRDF)]_BRDFIntensity("BRDF Intensity", Range( 0 , 1)) = 1
		_BRDFAmbientOcclusion("BRDF Ambient Occlusion", Range( 0 , 1)) = 1
		[ToggleUI]_CubemapSpecularToggle("Specular Highlight Toggle", Float) = 1
		[ToggleUI]_EnableGSAA("Enable GSAA", Float) = 1
		_GSAAThreshold("GSAAThreshold", Range( 0 , 1)) = 0.1
		_GSAAVariance("GSAAVariance", Range( 0 , 1)) = 0.15
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.94
		[Header(Screen Space Reflections by error.mdl)][Toggle(_SSR_ON)] _SSR("SSR (performance heavy)", Float) = 0
		_EdgeFadeSSR("Edge Fade SSR", Range( 0 , 1)) = 0.1
		[Space(25)][Header(NORMAL MAPS)]_Normal("Normal", 2D) = "bump" {}
		_ScrollSpeed("Scroll Speed", Range( -2 , 2)) = 0.075
		_NormalScale("Normal Scale", Range( -2 , 2)) = 0.2
		_VectorXY("Vector X,Y", Vector) = (0,-1,0,0)
		_SecondaryNormal("Secondary Normal", 2D) = "bump" {}
		_SecondaryScrollSpeed("Secondary Scroll Speed", Range( -2 , 2)) = 0.17
		_NormalScaleSecondary("Normal Scale Secondary", Range( -2 , 2)) = 0.2
		_SecondaryVectorXY("Secondary Vector X,Y", Vector) = (0,-1,0,0)
		[ToggleUI]_3DNormals("3D Normals Toggle", Int) = 0
		_Normals_3D("Normals_3D", 3D) = "bump" {}
		_3DNormalScale("3D Normal Scale", Range( 0 , 2)) = 1
		_3DNormalLod("3D Normal Lod", Range( 0 , 1)) = 0.25
		[Space(25)][Header(EDGE FOAM)]_SeaFoam("SeaFoam", 2D) = "black" {}
		_EdgeFoamSpeed("Edge Foam Speed", Float) = 0.025
		_EdgeFoamDistance("Edge Foam Distance", Range( 0 , 1)) = 0.5
		_EdgePower("Edge Intensity", Range( 0 , 1)) = 0.75
		_NormalMapdeformation("Normal Map deformation", Range( 0 , 1)) = 0.05
		[Space(25)][Header(EDGE WAVE)][ToggleUI]_ToggleEdgeWave("Toggle Edge Wave", Float) = 0
		[HideInInspector]_UVTiling("UV Tiling", Float) = 0.5
		_EdgeWaveSharpness("Edge Wave Sharpness", Range( 0 , 1)) = 1
		_EdgeWaveFrequency("Edge Wave Frequency", Float) = 1
		_EdgeWaveSpeed("Edge Wave Speed", Range( 0 , 1)) = 0.25
		_EdgeWaveOffset("Edge Wave Offset", Float) = 0.25
		_EdgeWaveVertexOffset("Edge Wave Vertex Offset", Range( 0 , 1)) = 0.2
		[Space(25)][Header(Gerstner Waves _ Vertex Offset _ Tessellation)][ToggleUI]_GerstnerWavesToggle("Gerstner Waves Toggle", Int) = 0
		[HideInInspector][NonModifiableTextureData]_NoiseTexSSR("Noise Tex SSR", 2D) = "black" {}
		_WaveA("WaveA dir, dir, steepness, wavelength", Vector) = (1,0,0.5,0.00125)
		_WaveB("WaveB dir, dir, steepness, wavelength", Vector) = (1,0,0.5,0.00125)
		_WaveC("WaveC dir, dir, steepness, wavelength", Vector) = (1,0,0.5,0.00125)
		_GerstnerHeight("Gerstner Height", Float) = 0
		_GerstnerSpeed("Gerstner Speed", Range( 0 , 1)) = 0.05
		[ToggleUI]_VertexOffsetCameradistMask("Vertex Offset Camera dist Mask", Float) = 1
		_VertexOffsetMask("Vertex Offset Mask", 2D) = "white" {}
		[IntRange]_TessValue("TessValue", Range( 1 , 100)) = 1
		_TessMin("Tess Min Distance", Float) = 0
		_TessMax("Tess Max Distance", Float) = 100
		_VertOffsetDistMaskTessMaxxthis("Vert Offset Dist Mask TessMax x this", Range( 0 , 2)) = 0.85
		[HideInInspector][ToggleUI]_NormalScaleAnimated("Normal Scale Animated", Int) = 1
		[HideInInspector][ToggleUI]_NormalScaleSecondaryAnimated("Normal Scale Secondary Animated", Int) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "PreviewType"="Plane" }
		Cull [_Cull]
		ZWrite [_ZWrite]
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ "_GrabTexture" }
		CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 5.0
		#pragma shader_feature_local _SSR_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		//Vertex Lights
		#pragma multi_compile _ VERTEXLIGHT_ON
		float4 _GrabTexture_TexelSize;
		float4 _NoiseTexSSR_TexelSize;
		#define SSR_ENABLED	defined(_SSR_ON) && !defined(UNITY_PASS_FORWARDADD)
		#pragma surface surf StandardCustomLighting keepalpha noshadow exclude_path:deferred novertexlights nolightmap  nodynlightmap nodirlightmap nometa vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _GSAAVariance;
		uniform float _EnableGSAA;
		uniform float _GSAAThreshold;
		uniform int _NormalScaleSecondaryAnimated;
		uniform int _ZWrite;
		uniform float _UVTiling;
		uniform int _Cull;
		uniform sampler2D _NoiseTexSSR;
		uniform float _EdgeFadeSSR;
		uniform float _ShaderOptimizerEnabled;
		uniform int _NormalScaleAnimated;
		uniform int _GerstnerWavesToggle;
		uniform float4 _WaveA;
		uniform sampler2D _VertexOffsetMask;
		uniform float4 _VertexOffsetMask_ST;
		uniform float _GerstnerSpeed;
		uniform float _GerstnerHeight;
		uniform float4 _WaveB;
		uniform float4 _WaveC;
		uniform float _TessMin;
		uniform float _TessMax;
		uniform float _VertOffsetDistMaskTessMaxxthis;
		uniform float _TessValue;
		uniform float _VertexOffsetCameradistMask;
		uniform float _ToggleEdgeWave;
		uniform float _EdgeWaveSharpness;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeWaveFrequency;
		uniform float _EdgeWaveSpeed;
		uniform float _EdgeWaveOffset;
		uniform float _Depth;
		uniform float _EdgeWaveVertexOffset;
		uniform int _3DNormals;
		uniform sampler2D _Normal;
		uniform float _ScrollSpeed;
		uniform float2 _VectorXY;
		uniform float4 _Normal_ST;
		uniform float _NormalScale;
		uniform sampler2D _SecondaryNormal;
		uniform float _SecondaryScrollSpeed;
		uniform float2 _SecondaryVectorXY;
		uniform float4 _SecondaryNormal_ST;
		uniform float _NormalScaleSecondary;
		uniform sampler3D _Normals_3D;
		uniform float4 _Normals_3D_ST;
		uniform float _3DNormalScale;
		uniform float _3DNormalLod;
		uniform sampler2D _SeaFoam;
		uniform float4 _SeaFoam_ST;
		uniform float _EdgeFoamSpeed;
		uniform float _NormalMapdeformation;
		uniform float _EdgeFoamDistance;
		uniform float _GeneralDepth;
		uniform float _EdgePower;
		uniform float _Smoothness;
		uniform float4 _Color;
		uniform float4 _ColorSecondary;
		uniform float _CubemapSpecularToggle;
		uniform float _BRDFAmbientOcclusion;
		uniform float _BRDFIntensity;
		uniform float _NdLfade;
		uniform float _CausticsScale;
		uniform float _GrabPassDistortion;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _CausticIntensity;
		uniform float _BacksideWaterColor;
		uniform float _fresnelbias;
		uniform float _fresnelscale;
		uniform float _fresnelpower;


		void SourceDeclaration(  )
		{
			//This Shader was made possible by Moriohs Toon Shader (https://gitlab.com/xMorioh/moriohs-toon-shader)
		}


		float2 hash2D2D( float2 s )
		{
			return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453);
		}


		float3 linearstep( float3 j, float3 k, float3 x )
		{
			#if SSR_ENABLED
				x = clamp((x - j) / (k - j), 0.0, 1.0); 
				return x;
			#else //SSR_ENABLED
			return 0;
			#endif //SSR_ENABLED
		}


		float4 ReflectRay( float3 reflectedRay, float3 rayDir, float noise )
		{
			#if SSR_ENABLED
				#if UNITY_SINGLE_PASS_STEREO
					half x_min = 0.5*unity_StereoEyeIndex;
					half x_max = 0.5 + 0.5*unity_StereoEyeIndex;
				#else
					half x_min = 0.0;
					half x_max = 1.0;
				#endif
				
				reflectedRay = mul(UNITY_MATRIX_V, float4(reflectedRay, 1));
				rayDir = mul(UNITY_MATRIX_V, float4(rayDir, 0));
				int totalIterations = 0;
				int direction = 1;
				float3 finalPos = 0;
				float step = 0.09;
				float lRad = 0.2;
				float sRad = 0.02;
				[loop] for (int i = 0; i < 50; i++){
					totalIterations = i;
					float4 spos = ComputeGrabScreenPos(mul(UNITY_MATRIX_P, float4(reflectedRay, 1)));
					float2 uvDepth = spos.xy / spos.w;
					UNITY_BRANCH
					if (uvDepth.x > x_max || uvDepth.x < x_min || uvDepth.y > 1 || uvDepth.y < 0){
						break;
					}
					float rawDepth = DecodeFloatRG(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthTexture, uvDepth));
					float linearDepth = Linear01Depth(rawDepth);
					float sampleDepth = -reflectedRay.z;
					float realDepth = linearDepth * _ProjectionParams.z;
					float depthDifference = abs(sampleDepth - realDepth);
					if (depthDifference < lRad){ 
						if (direction == 1){
							if(sampleDepth > (realDepth - sRad)){
								if(sampleDepth < (realDepth + sRad)){
									finalPos = reflectedRay;
									break;
								}
								direction = -1;
								step = step*0.1;
							}
						}
						else {
							if(sampleDepth < (realDepth + sRad)){
								direction = 1;
								step = step*0.1;
							}
						}
					}
					reflectedRay = reflectedRay + direction*step*rayDir;
					step += step*(0.025 + 0.005*noise);
					lRad += lRad*(0.025 + 0.005*noise);
					sRad += sRad*(0.025 + 0.005*noise);
				}
				return float4(finalPos, totalIterations);
			#else //SSR_ENABLED
			return 0;
			#endif //SSR_ENABLED
		}


		float3 GetBlurredGP( float2 texelSize, float2 uvs, float dim )
		{
			#if SSR_ENABLED
				float2 pixSize = 2/texelSize;
				float center = floor(dim*0.5);
				float3 refTotal = float3(0,0,0);
				for (int i = 0; i < floor(dim); i++){
					[loop] for (int j = 0; j < floor(dim); j++){
						float4 refl = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture, float2(uvs.x + pixSize.x*(i-center), uvs.y + pixSize.y*(j-center)));
						refTotal += refl.rgb;
					}
				}
				return refTotal/(floor(dim)*floor(dim));
			#else //SSR_ENABLED
			return 0;
			#endif //SSR_ENABLED
		}


		float4 GetSSR( float3 wPos, float3 rayDir, float3 faceNormal, float3 albedo, float4 screenPos )
		{
			#if SSR_ENABLED
				float FdotR = dot(faceNormal, rayDir.xyz);
				UNITY_BRANCH
				if (unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f  || FdotR < 0){
					return 0;
				}
				else {
					float4 noiseUvs = screenPos;
					noiseUvs.xy = (noiseUvs.xy * _GrabTexture_TexelSize.zw) / (_NoiseTexSSR_TexelSize.zw * noiseUvs.w);	
					float4 noiseRGBA = tex2Dlod(_NoiseTexSSR, float4(noiseUvs.xy,0,0));
					float noise = noiseRGBA.r;
					
					float3 reflectedRay = wPos + (0.2*0.09/FdotR + noise*0.09)*rayDir;
					float4 finalPos = ReflectRay(reflectedRay, rayDir, noise);
					float totalSteps = finalPos.w;
					finalPos.w = 1;
					
					if (!any(finalPos.xyz)){
						return 0;
					}
					
					float4 uvs = UNITY_PROJ_COORD(ComputeGrabScreenPos(mul(UNITY_MATRIX_P, finalPos)));
					uvs.xy = uvs.xy / uvs.w;
					
					#if UNITY_SINGLE_PASS_STEREO
						float xfade = 1;
					#else
						float xfade = smoothstep(0, _EdgeFadeSSR, uvs.x) * smoothstep(1, 1-_EdgeFadeSSR, uvs.x); //Fade x uvs out towards the edges
					#endif
					float yfade = smoothstep(0, _EdgeFadeSSR, uvs.y)*smoothstep(1, 1-_EdgeFadeSSR, uvs.y); //Same for y
					float lengthFade = smoothstep(1, 0, 2*(totalSteps / 50)-1);
					
					float blurFac = max(1,min(12, 12 * (-2)*(_Smoothness-1)));
					float4 reflection = float4(GetBlurredGP(_GrabTexture_TexelSize.zw, uvs.xy, blurFac*1.5),1);
					reflection.rgb = lerp(reflection.rgb, reflection.rgb*albedo.rgb,smoothstep(0, 1.75, 0));
					reflection.a = FdotR * xfade * yfade * lengthFade;
					return max(0,reflection);
					}
			#else //SSR_ENABLED
			return 0;
			#endif //SSR_ENABLED
		}


		float3 GerstnerWave( float4 wave, float3 p, inout float3 tangent, inout float3 binormal, float Speed, float Height )
		{
			// Source: https://catlikecoding.com/unity/tutorials/flow/waves
			float steepness = wave.z;
			float wavelength = wave.w;
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, p.xz) - c * _Time.y * Speed);
			float a = steepness / k;
			tangent += float3(
				-d.x * d.x * (steepness * sin(f)),
				d.x * (steepness * cos(f)),
				-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
				-d.x * d.y * (steepness * sin(f)),
				d.y * (steepness * cos(f)),
				-d.y * d.y * (steepness * sin(f))
			);
			return float3(
				d.x * (a * cos(f)),
				a * sin(f) * Height,
				d.y * (a * cos(f))
			);
		}


		float TessDistance( float4 vertex, float minDist, float maxDist, float tess )
		{
			return UnityCalcDistanceTessFactor(vertex, minDist, maxDist, tess);
		}


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		float3 InvertDepthDir72_g457( float3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		float3 tex2DStochasticNormals( sampler2D tex, float2 UV, float _NormalScale )
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
			    return mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), _NormalScale), BW_vx[3].x) + 
			            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), _NormalScale), BW_vx[3].y) + 
			            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z);
		}


		float3 tex3DStochasticNormals( sampler3D tex, float3 UV, float Normalscale )
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
			    //float3 dx = ddx(UV); //tex3D does not have mipmaps
			    //float3 dy = ddy(UV); //tex3D does not have mipmaps
			    //blend samples with calculated weights
			    return mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[0].xy), 0), 0, 0), Normalscale), BW_vx[3].x) + 
			            mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[1].xy), 0), 0, 0), Normalscale), BW_vx[3].y) + 
			            mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[2].xy), 0), 0, 0), Normalscale), BW_vx[3].z);
		}


		float CorrectNegativeNdotV( float3 viewDir, float3 normal )
		{
			#define UNITY_HANDLE_CORRECTLY_NEGATIVE_NDOTV 0
			#if UNITY_HANDLE_CORRECTLY_NEGATIVE_NDOTV
			    // The amount we shift the normal toward the view vector is defined by the dot product.
			    half shiftAmount = dot(normal, viewDir);
			    normal = shiftAmount < 0.0f ? normal + viewDir * (-shiftAmount + 1e-5f) : normal;
			    // A re-normalization should be applied here but as the shift is small we don't do it to save ALU.
			    //normal = normalize(normal);
			    float nv = saturate(dot(normal, viewDir)); // TODO: this saturate should no be necessary here
			#else
			    half nv = abs(dot(normal, viewDir));    // This abs allow to limit artifact
			#endif
			return nv;
		}


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
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


		float SurfaceDepth( float In0 )
		{
			return UNITY_Z_0_FAR_FROM_CLIPSPACE(In0);
		}


		float GSAA_Filament( float3 worldNormal, float smoothness )
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
			if (_EnableGSAA == 1)
			{
			    float3 du = ddx(worldNormal);
			    float3 dv = ddy(worldNormal);
			    float variance = _GSAAVariance * (dot(du, du) + dot(dv, dv));
			    float perceptualRoughness = 1-smoothness;
			    float roughness = perceptualRoughness * perceptualRoughness;
			    float kernelRoughness = min(2.0 * variance, _GSAAThreshold);
			    float squareRoughness = saturate(roughness * roughness + kernelRoughness);
			    return 1-sqrt(sqrt(squareRoughness));
			}
			else
			{
			    return smoothness;
			}
		}


		float getSmithJointGGXVisibilityTerm( float NdotL, float NdotV, float roughness )
		{
			return SmithJointGGXVisibilityTerm (NdotL, NdotV, roughness);
		}


		inline float3 ASESafeNormalize(float3 inVec)
		{
			float dp3 = max( 0.001f , dot( inVec , inVec ) );
			return inVec* rsqrt( dp3);
		}


		float getGGXTerm( float NdotH, float roughness )
		{
			return GGXTerm (NdotH, roughness);
		}


		float3 calcSpecularTerm( float GGXVisibilityTerm, float GGXTerm, float NdotL, float LdotH, float roughness, float3 specColor, float3 lightcolor, float specularTermToggle )
		{
			// "GGX with roughness to 0 would mean no specular at all, using max(roughness, 0.002) here to match HDrenderloop roughness remapping."
			float specularTerm = GGXVisibilityTerm * GGXTerm * UNITY_PI; // Torrance-Sparrow model, Fresnel is applied later
			// Gamma Space support
			#   ifdef UNITY_COLORSPACE_GAMMA
			        specularTerm = sqrt(max(1e-4h, specularTerm));
			#   endif
			// specularTerm * nl can be NaN on Metal in some cases, use max() to make sure it's a sane value
			specularTerm = max(0, specularTerm * NdotL);
			//Toggle specularTerm
			if (specularTermToggle == 1) {
			// To provide true Lambert lighting, we need to be able to kill specular completely.
				specularTerm *= any(specColor) ? 1.0 : 0.0;
			}
			else {
				specularTerm = 0;
			}
			return
			specularTerm * lightcolor * FresnelTerm(specColor, LdotH);
		}


		float3 calcSpecularBase( float3 specularTerm, float NdotV, float3 specColor, float roughness, float oneMinusReflectivity, float3 indirectspecular, float smoothness, float perceptualRoughness )
		{
			half surfaceReduction;
			// Gamma Space support
			#   ifdef UNITY_COLORSPACE_GAMMA
			        surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
			#   else
			        surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
			#   endif
			half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
			return specularTerm  + surfaceReduction * indirectspecular.rgb * FresnelLerp(specColor, grazingTerm, NdotV);
		}


		float3 LightColorZero(  )
		{
			return unity_LightColor[0];
		}


		float4 FourLightAtten(  )
		{
			return unity_4LightAtten0;
		}


		float4 FourLightPosX(  )
		{
			return unity_4LightPosX0;
		}


		float4 FourLightPosY(  )
		{
			return unity_4LightPosY0;
		}


		float4 FourLightPosZ(  )
		{
			return unity_4LightPosZ0;
		}


		float3 LightColorZOne(  )
		{
			return unity_LightColor[1];
		}


		float3 LightColorZTwo(  )
		{
			return unity_LightColor[2];
		}


		float3 LightColorZThree(  )
		{
			return unity_LightColor[3];
		}


		float2 voronoihash2957( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2957( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash2957( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float3 InvertDepthDir72_g460( float3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		float3 SSR( float3 worldPos, float3 viewDir, float3 normalDir, float3 albedo, float4 screenPos )
		{
			float NdotV = abs(dot(normalDir, viewDir));
			float omr = unity_ColorSpaceDielectricSpec.a * unity_ColorSpaceDielectricSpec.a;
			float3 specularTint = lerp(unity_ColorSpaceDielectricSpec.rgb, 1, 0);
			float roughSq = 1-_Smoothness * 1-_Smoothness;
			float roughBRDF = max(roughSq, 0.003);	
			float3 reflDir = reflect(-viewDir, normalDir);
			float surfaceReduction = 1.0 / (roughBRDF*roughBRDF + 1.0);
			float grazingTerm = saturate((_Smoothness) + (1-omr));
			float fresnel = FresnelLerp(specularTint, grazingTerm, NdotV);
			float3 reflCol = 0;
				half4 ssrCol = GetSSR(worldPos, reflDir, normalDir, albedo, screenPos);
				ssrCol.rgb *= lerp(10, 7, linearstep(0,1,0));
				//#if FOAM_ENABLED
				//	foamLerp = 1-foamLerp;
				//	foamLerp = smoothstep(0.7, 1, foamLerp);
				//	ssrCol.a *= foamLerp;
				//#endif
				reflCol = lerp(reflCol, ssrCol.rgb, ssrCol.a);
			reflCol = reflCol * fresnel * surfaceReduction;
			return reflCol;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin,_TessMax,_TessValue);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
			float2 uv_VertexOffsetMask = v.texcoord * _VertexOffsetMask_ST.xy + _VertexOffsetMask_ST.zw;
			float4 tex2DNode1275 = tex2Dlod( _VertexOffsetMask, float4( uv_VertexOffsetMask, 0, 0.0) );
			float VertexOffsetMask1284 = tex2DNode1275.g;
			float4 appendResult1278 = (float4(_WaveA.x , _WaveA.y , ( _WaveA.z * VertexOffsetMask1284 ) , _WaveA.w));
			float4 wave1199 = appendResult1278;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 p1199 = ase_vertex3Pos;
			float3 _tangent = float3(1,0,0);
			float3 tangent1199 = _tangent;
			float3 _binormal = float3(0,0,1);
			float3 binormal1199 = _binormal;
			float Speed1199 = _GerstnerSpeed;
			float temp_output_1243_0 = ( _GerstnerHeight * 100.0 );
			float Height1199 = temp_output_1243_0;
			float3 localGerstnerWave1199 = GerstnerWave( wave1199 , p1199 , tangent1199 , binormal1199 , Speed1199 , Height1199 );
			float4 appendResult1282 = (float4(_WaveB.x , _WaveB.y , ( _WaveB.z * VertexOffsetMask1284 ) , _WaveB.w));
			float4 wave1200 = appendResult1282;
			float3 p1200 = ase_vertex3Pos;
			float3 tangent1200 = _tangent;
			float3 binormal1200 = _binormal;
			float Speed1200 = _GerstnerSpeed;
			float Height1200 = temp_output_1243_0;
			float3 localGerstnerWave1200 = GerstnerWave( wave1200 , p1200 , tangent1200 , binormal1200 , Speed1200 , Height1200 );
			float4 appendResult1283 = (float4(_WaveC.x , _WaveC.y , ( _WaveC.z * VertexOffsetMask1284 ) , _WaveC.w));
			float4 wave1201 = appendResult1283;
			float3 p1201 = ase_vertex3Pos;
			float3 tangent1201 = _tangent;
			float3 binormal1201 = _binormal;
			float Speed1201 = _GerstnerSpeed;
			float Height1201 = temp_output_1243_0;
			float3 localGerstnerWave1201 = GerstnerWave( wave1201 , p1201 , tangent1201 , binormal1201 , Speed1201 , Height1201 );
			float3 GerstnerOffset1259 = ( localGerstnerWave1199 + localGerstnerWave1200 + localGerstnerWave1201 );
			float3 ifLocalVar2389 = 0;
			if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2389 = GerstnerOffset1259;
			float3 GerstnerOffsetWithMask2569 = ( ifLocalVar2389 * tex2DNode1275.g );
			float4 ase_vertex4Pos = v.vertex;
			float4 vertex2417 = ase_vertex4Pos;
			float minDist2417 = _TessMin;
			float maxDist2417 = ( _TessMax * _VertOffsetDistMaskTessMaxxthis );
			float tess2417 = _TessValue;
			float localTessDistance2417 = TessDistance( vertex2417 , minDist2417 , maxDist2417 , tess2417 );
			float TessellationDistance2421 = saturate( (0.0 + (localTessDistance2417 - ( _TessValue / 100.0 )) * (1.0 - 0.0) / (1.0 - ( _TessValue / 100.0 ))) );
			float cameraDepthFade2443 = (( -UnityObjectToViewPos( v.vertex.xyz ).z -_ProjectionParams.y - 2.0 ) / 1.0);
			float ifLocalVar2449 = 0;
			if( _VertexOffsetCameradistMask == 1.0 )
				ifLocalVar2449 = saturate( cameraDepthFade2443 );
			else if( _VertexOffsetCameradistMask < 1.0 )
				ifLocalVar2449 = 1.0;
			float3 FinalVertexOffset1260 = ( ( GerstnerOffsetWithMask2569 * TessellationDistance2421 ) * ifLocalVar2449 );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 temp_output_73_0_g457 = ase_screenPosNorm.xy;
			float2 UV22_g458 = float4( temp_output_73_0_g457, 0.0 , 0.0 ).xy;
			float2 localUnStereo22_g458 = UnStereo( UV22_g458 );
			float2 break64_g457 = localUnStereo22_g458;
			float clampDepth76_g457 = SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( float4( temp_output_73_0_g457, 0.0 , 0.0 ).xy, 0, 0 ) );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g457 = ( 1.0 - clampDepth76_g457 );
			#else
				float staticSwitch38_g457 = clampDepth76_g457;
			#endif
			float3 appendResult39_g457 = (float3(break64_g457.x , break64_g457.y , staticSwitch38_g457));
			float4 appendResult42_g457 = (float4((appendResult39_g457*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g457 = mul( unity_CameraInvProjection, appendResult42_g457 );
			float3 In72_g457 = ( (temp_output_43_0_g457).xyz / (temp_output_43_0_g457).w );
			float3 localInvertDepthDir72_g457 = InvertDepthDir72_g457( In72_g457 );
			float4 appendResult49_g457 = (float4(localInvertDepthDir72_g457 , 1.0));
			float mulTime2892 = _Time.y * _EdgeWaveSpeed;
			float temp_output_2895_0 = sin( mulTime2892 );
			float lerpResult2927 = lerp( saturate( -temp_output_2895_0 ) , saturate( temp_output_2895_0 ) , ( ( temp_output_2895_0 * 0.5 ) + 0.5 ));
			float temp_output_2864_0 = ( ( ( ( ase_worldPos.y - mul( unity_CameraToWorld, appendResult49_g457 ).y ) * _EdgeWaveFrequency ) + lerpResult2927 ) + _EdgeWaveOffset );
			float smoothstepResult2836 = smoothstep( ( _EdgeWaveSharpness - 0.25 ) , 1.0 , ( temp_output_2864_0 - 0.25 ));
			float eyeDepth2409 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
			float _depthMaskOpacity2487 = ( 1.0 - saturate( ( ( eyeDepth2409 - eyeDepth ) * ( 1.0 - _Depth ) ) ) );
			float Opacity2874 = ( ( 1.0 - _depthMaskOpacity2487 ) * 16.0 );
			float temp_output_2797_0 = saturate( ( 1.0 - Opacity2874 ) );
			float temp_output_2176_0 = ( distance( ase_worldPos , _WorldSpaceCameraPos ) * 0.005 );
			float LODDistance2560 = saturate( ( 1.0 - temp_output_2176_0 ) );
			float ifLocalVar2891 = 0;
			if( _ToggleEdgeWave == 1.0 )
				ifLocalVar2891 = ( ( ( saturate( smoothstepResult2836 ) * temp_output_2797_0 ) * _EdgeWaveVertexOffset ) * LODDistance2560 );
			float3 appendResult2840 = (float3(0.0 , ifLocalVar2891 , 0.0));
			float3 EdgeWaveVertexOffset2878 = appendResult2840;
			v.vertex.xyz += ( FinalVertexOffset1260 + EdgeWaveVertexOffset2878 );
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 normalizeResult1209 = normalize( cross( ( binormal1199 + binormal1200 + binormal1201 ) , ( tangent1199 + tangent1200 + tangent1201 ) ) );
			float3 ifLocalVar2391 = 0;
			if( 1.0 > _GerstnerWavesToggle )
				ifLocalVar2391 = ase_vertexNormal;
			else if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2391 = normalizeResult1209;
			float3 FinalVertexNormals1262 = ifLocalVar2391;
			v.normal = FinalVertexNormals1262;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float eyeDepth2409 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_viewPos = UnityObjectToViewPos( ase_vertex4Pos );
			float ase_screenDepth = -ase_viewPos.z;
			float _depthMaskOpacity2487 = ( 1.0 - saturate( ( ( eyeDepth2409 - ase_screenDepth ) * ( 1.0 - _Depth ) ) ) );
			float Opacity2874 = ( ( 1.0 - _depthMaskOpacity2487 ) * 16.0 );
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_73_0_g457 = ase_screenPosNorm.xy;
			float2 UV22_g458 = float4( temp_output_73_0_g457, 0.0 , 0.0 ).xy;
			float2 localUnStereo22_g458 = UnStereo( UV22_g458 );
			float2 break64_g457 = localUnStereo22_g458;
			float clampDepth76_g457 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_73_0_g457, 0.0 , 0.0 ).xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g457 = ( 1.0 - clampDepth76_g457 );
			#else
				float staticSwitch38_g457 = clampDepth76_g457;
			#endif
			float3 appendResult39_g457 = (float3(break64_g457.x , break64_g457.y , staticSwitch38_g457));
			float4 appendResult42_g457 = (float4((appendResult39_g457*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g457 = mul( unity_CameraInvProjection, appendResult42_g457 );
			float3 In72_g457 = ( (temp_output_43_0_g457).xyz / (temp_output_43_0_g457).w );
			float3 localInvertDepthDir72_g457 = InvertDepthDir72_g457( In72_g457 );
			float4 appendResult49_g457 = (float4(localInvertDepthDir72_g457 , 1.0));
			float mulTime2892 = _Time.y * _EdgeWaveSpeed;
			float temp_output_2895_0 = sin( mulTime2892 );
			float lerpResult2927 = lerp( saturate( -temp_output_2895_0 ) , saturate( temp_output_2895_0 ) , ( ( temp_output_2895_0 * 0.5 ) + 0.5 ));
			float temp_output_2864_0 = ( ( ( ( ase_worldPos.y - mul( unity_CameraToWorld, appendResult49_g457 ).y ) * _EdgeWaveFrequency ) + lerpResult2927 ) + _EdgeWaveOffset );
			float smoothstepResult2808 = smoothstep( _EdgeWaveSharpness , 1.0 , temp_output_2864_0);
			float temp_output_2797_0 = saturate( ( 1.0 - Opacity2874 ) );
			float temp_output_2176_0 = ( distance( ase_worldPos , _WorldSpaceCameraPos ) * 0.005 );
			float LODDistance2560 = saturate( ( 1.0 - temp_output_2176_0 ) );
			float ifLocalVar2884 = 0;
			if( _ToggleEdgeWave == 1.0 )
				ifLocalVar2884 = ( ( saturate( smoothstepResult2808 ) * temp_output_2797_0 ) * LODDistance2560 );
			float EdgeWave2877 = ifLocalVar2884;
			sampler2D tex96_g427 = _Normal;
			float mulTime7_g427 = _Time.y * _ScrollSpeed;
			float temp_output_68_0_g427 = _UVTiling;
			float2 appendResult101_g427 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_103_0_g427 = ( ( _Normal_ST.xy * temp_output_68_0_g427 * appendResult101_g427 ) + _Normal_ST.zw );
			float2 panner17_g427 = ( mulTime7_g427 * _VectorXY + temp_output_103_0_g427);
			float2 UV96_g427 = ( panner17_g427 + 0.25 );
			float _NormalScale96_g427 = _NormalScale;
			float3 localtex2DStochasticNormals96_g427 = tex2DStochasticNormals( tex96_g427 , UV96_g427 , _NormalScale96_g427 );
			sampler2D tex79_g427 = _Normal;
			float mulTime4_g427 = _Time.y * _ScrollSpeed;
			float temp_output_9_0_g427 = ( mulTime4_g427 * 2.179 );
			float2 panner12_g427 = ( temp_output_9_0_g427 * _VectorXY + ( 1.0 - temp_output_103_0_g427 ));
			float2 UV79_g427 = ( 1.0 - panner12_g427 );
			float _NormalScale79_g427 = _NormalScale;
			float3 localtex2DStochasticNormals79_g427 = tex2DStochasticNormals( tex79_g427 , UV79_g427 , _NormalScale79_g427 );
			sampler2D tex76_g427 = _SecondaryNormal;
			float mulTime16_g427 = _Time.y * _SecondaryScrollSpeed;
			float2 panner21_g427 = ( mulTime16_g427 * _SecondaryVectorXY + ( ( _SecondaryNormal_ST.xy * temp_output_68_0_g427 * appendResult101_g427 ) + _SecondaryNormal_ST.zw ));
			float2 UV76_g427 = panner21_g427;
			float _NormalScale76_g427 = _NormalScaleSecondary;
			float3 localtex2DStochasticNormals76_g427 = tex2DStochasticNormals( tex76_g427 , UV76_g427 , _NormalScale76_g427 );
			sampler3D tex2057 = _Normals_3D;
			float temp_output_2023_0 = ( _UVTiling * 0.25 );
			float2 break3003 = _Normals_3D_ST.xy;
			float _Time1684 = temp_output_9_0_g427;
			float3 appendResult2709 = (float3(( ase_worldPos.x * temp_output_2023_0 * break3003.x ) , ( ase_worldPos.z * temp_output_2023_0 * break3003.y ) , ( _Time1684 * 4.0 )));
			float3 _3duvs1683 = appendResult2709;
			float3 UV2057 = _3duvs1683;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float lerpResult1687 = lerp( 0.0 , _3DNormalScale , ase_worldNormal.y);
			float switchResult3007 = (((i.ASEVFace>0)?(lerpResult1687):(( lerpResult1687 * 0.5 ))));
			float Normalscale2057 = switchResult3007;
			float3 localtex3DStochasticNormals2057 = tex3DStochasticNormals( tex2057 , UV2057 , Normalscale2057 );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_tanViewDir = mul( ase_worldToTangent, ase_worldViewDir );
			float switchResult2209 = (((i.ASEVFace>0)?(ase_tanViewDir.z):(-ase_tanViewDir.z)));
			float lerpResult2168 = lerp( temp_output_2176_0 , 1.0 , ( ( 1.0 - switchResult2209 ) * ( 1.0 - _3DNormalLod ) ));
			float3 lerpResult2132 = lerp( localtex3DStochasticNormals2057 , float3( 0,0,1 ) , saturate( lerpResult2168 ));
			float3 ifLocalVar2401 = 0;
			if( 1.0 > _3DNormals )
				ifLocalVar2401 = BlendNormals( BlendNormals( localtex2DStochasticNormals96_g427 , localtex2DStochasticNormals79_g427 ) , localtex2DStochasticNormals76_g427 );
			else if( 1.0 == _3DNormals )
				ifLocalVar2401 = lerpResult2132;
			float3 normalizeResult1901 = normalize( ifLocalVar2401 );
			float3 switchResult2258 = (((i.ASEVFace>0)?(normalizeResult1901):(-normalizeResult1901)));
			float3 Normals80 = switchResult2258;
			float3 WorldNormal1915 = (WorldNormalVector( i , Normals80 ));
			float3 WorldNormals305_g462 = WorldNormal1915;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult2930_g462 = dot( WorldNormals305_g462 , ase_worldlightDir );
			float NdLGGX2357_g462 = saturate( dotResult2930_g462 );
			float temp_output_2418_0_g462 = max( 0.0 , NdLGGX2357_g462 );
			float NdotL2412_g462 = temp_output_2418_0_g462;
			float3 viewDir443_g455 = ase_worldViewDir;
			float3 WorldNormals20_g455 = WorldNormal1915;
			float3 normal443_g455 = WorldNormals20_g455;
			float localCorrectNegativeNdotV443_g455 = CorrectNegativeNdotV( viewDir443_g455 , normal443_g455 );
			float CorrectedNdotV2507_g462 = localCorrectNegativeNdotV443_g455;
			float NdotV2412_g462 = CorrectedNdotV2507_g462;
			float3 worldNormal2910_g462 = WorldNormals305_g462;
			sampler2D tex340 = _SeaFoam;
			float2 appendResult1851 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 NormalVector625 = _VectorXY;
			float mulTime344 = _Time.y * _EdgeFoamSpeed;
			float mulTime415 = _Time.y * ( 2.0 * 10.0 );
			float4 _NoiseScaleOffset = float4(7.5,1.5,0,0);
			float2 appendResult1000 = (float2(_NoiseScaleOffset.x , _NoiseScaleOffset.y));
			float2 appendResult1885 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult1001 = (float2(_NoiseScaleOffset.z , _NoiseScaleOffset.w));
			float2 temp_output_1003_0 = ( ( appendResult1000 * appendResult1885 ) + appendResult1001 );
			float2 panner412 = ( mulTime415 * -NormalVector625 + temp_output_1003_0);
			float simpleNoise411 = SimpleNoise( panner412*0.01 );
			float2 panner746 = ( mulTime415 * NormalVector625 + temp_output_1003_0);
			float simpleNoise747 = SimpleNoise( panner746*0.01 );
			float Noise1889 = ( simpleNoise411 + simpleNoise747 );
			float3 appendResult1858 = (float3(0.0 , 0.0 , _NormalMapdeformation));
			float dotResult1852 = dot( appendResult1858 , Normals80 );
			float2 UV340 = ( ( ( _SeaFoam_ST.xy * appendResult1851 * _UVTiling ) + _SeaFoam_ST.zw ) + ( NormalVector625 * mulTime344 ) + ( ( saturate( Noise1889 ) * 0.25 ) + dotResult1852 ) );
			float4 localtex2DStochastic340 = tex2DStochastic( tex340 , UV340 );
			float temp_output_2526_0 = ( 1.0 - _EdgeFoamDistance );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos2452 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeGrabScreenPos2454 = ComputeGrabScreenPos( unityObjectToClipPos2452 );
			float4 UVGrab2488 = computeGrabScreenPos2454;
			float In02471 = UVGrab2488.z;
			float localSurfaceDepth2471 = SurfaceDepth( In02471 );
			float _depthMask1652 = saturate( pow( saturate( ( 1.0 - ( ( eyeDepth2409 - localSurfaceDepth2471 ) / 20.0 ) ) ) , _GeneralDepth ) );
			float lerpResult2512 = lerp( 0.0 , exp( temp_output_2526_0 ) , saturate( ( _depthMask1652 - temp_output_2526_0 ) ));
			float2 uv_VertexOffsetMask = i.uv_texcoord * _VertexOffsetMask_ST.xy + _VertexOffsetMask_ST.zw;
			float4 tex2DNode1275 = tex2D( _VertexOffsetMask, uv_VertexOffsetMask );
			float VertexOffsetMask1284 = tex2DNode1275.g;
			float4 appendResult1278 = (float4(_WaveA.x , _WaveA.y , ( _WaveA.z * VertexOffsetMask1284 ) , _WaveA.w));
			float4 wave1199 = appendResult1278;
			float3 p1199 = ase_vertex3Pos;
			float3 _tangent = float3(1,0,0);
			float3 tangent1199 = _tangent;
			float3 _binormal = float3(0,0,1);
			float3 binormal1199 = _binormal;
			float Speed1199 = _GerstnerSpeed;
			float temp_output_1243_0 = ( _GerstnerHeight * 100.0 );
			float Height1199 = temp_output_1243_0;
			float3 localGerstnerWave1199 = GerstnerWave( wave1199 , p1199 , tangent1199 , binormal1199 , Speed1199 , Height1199 );
			float4 appendResult1282 = (float4(_WaveB.x , _WaveB.y , ( _WaveB.z * VertexOffsetMask1284 ) , _WaveB.w));
			float4 wave1200 = appendResult1282;
			float3 p1200 = ase_vertex3Pos;
			float3 tangent1200 = _tangent;
			float3 binormal1200 = _binormal;
			float Speed1200 = _GerstnerSpeed;
			float Height1200 = temp_output_1243_0;
			float3 localGerstnerWave1200 = GerstnerWave( wave1200 , p1200 , tangent1200 , binormal1200 , Speed1200 , Height1200 );
			float4 appendResult1283 = (float4(_WaveC.x , _WaveC.y , ( _WaveC.z * VertexOffsetMask1284 ) , _WaveC.w));
			float4 wave1201 = appendResult1283;
			float3 p1201 = ase_vertex3Pos;
			float3 tangent1201 = _tangent;
			float3 binormal1201 = _binormal;
			float Speed1201 = _GerstnerSpeed;
			float Height1201 = temp_output_1243_0;
			float3 localGerstnerWave1201 = GerstnerWave( wave1201 , p1201 , tangent1201 , binormal1201 , Speed1201 , Height1201 );
			float3 GerstnerOffset1259 = ( localGerstnerWave1199 + localGerstnerWave1200 + localGerstnerWave1201 );
			float3 ifLocalVar2389 = 0;
			if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2389 = GerstnerOffset1259;
			float3 GerstnerOffsetWithMask2569 = ( ifLocalVar2389 * tex2DNode1275.g );
			float clampResult2542 = clamp( ( GerstnerOffsetWithMask2569.y * LODDistance2560 ) , -2.0 , 2.0 );
			float VertexOffsetForEffects2587 = clampResult2542;
			float EdgeFoam1909 = ( saturate( ( localtex2DStochastic340.y - ( ( 1.0 - lerpResult2512 ) - saturate( VertexOffsetForEffects2587 ) ) ) ) * _EdgePower * saturate( Noise1889 ) );
			float Smoothness300_g462 = ( min( saturate( ( Opacity2874 + EdgeWave2877 ) ) , ( 1.0 - EdgeFoam1909 ) ) * _Smoothness );
			float smoothness2910_g462 = Smoothness300_g462;
			float localGSAA_Filament2910_g462 = GSAA_Filament( worldNormal2910_g462 , smoothness2910_g462 );
			float SmoothnessTex290_g462 = localGSAA_Filament2910_g462;
			float perceptualRoughness2761_g462 = ( 1.0 - SmoothnessTex290_g462 );
			float roughness2729_g462 = max( ( perceptualRoughness2761_g462 * perceptualRoughness2761_g462 ) , 0.002 );
			float roughness2412_g462 = roughness2729_g462;
			float localgetSmithJointGGXVisibilityTerm2412_g462 = getSmithJointGGXVisibilityTerm( NdotL2412_g462 , NdotV2412_g462 , roughness2412_g462 );
			float GGXVisibilityTerm2305_g462 = localgetSmithJointGGXVisibilityTerm2412_g462;
			float3 normalizeResult464_g455 = ASESafeNormalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float3 HalfVectorUnityNormalized457_g455 = normalizeResult464_g455;
			float dotResult42_g455 = dot( WorldNormals20_g455 , HalfVectorUnityNormalized457_g455 );
			float NdotH2416_g462 = max( 0.0 , dotResult42_g455 );
			float roughness2416_g462 = roughness2729_g462;
			float localgetGGXTerm2416_g462 = getGGXTerm( NdotH2416_g462 , roughness2416_g462 );
			float GGXTerm2305_g462 = localgetGGXTerm2416_g462;
			float NdotL2305_g462 = temp_output_2418_0_g462;
			float dotResult50_g455 = dot( ase_worldlightDir , HalfVectorUnityNormalized457_g455 );
			float LdotH2305_g462 = max( 0.0 , dotResult50_g455 );
			float roughness2305_g462 = roughness2729_g462;
			float4 temp_output_1942_0 = ( _Color * _Color.a );
			float4 temp_output_1950_0 = ( _ColorSecondary * _ColorSecondary.a );
			float4 lerpResult2491 = lerp( temp_output_1942_0 , temp_output_1950_0 , ( ( VertexOffsetForEffects2587 * 0.1 ) + _depthMask1652 ));
			float4 Color1917 = lerpResult2491;
			float3 MainTex312_g462 = Color1917.rgb;
			float MetallicTex289_g462 = 0.0;
			half3 specColor2324_g462 = (0).xxx;
			half oneMinusReflectivity2324_g462 = 0;
			half3 diffuseAndSpecularFromMetallic2324_g462 = DiffuseAndSpecularFromMetallic(MainTex312_g462,MetallicTex289_g462,specColor2324_g462,oneMinusReflectivity2324_g462);
			float3 SpecColor2715_g462 = specColor2324_g462;
			float3 specColor2305_g462 = SpecColor2715_g462;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float AttenGGX2831_g462 = ase_lightAtten;
			float3 lightcolor2305_g462 = ( ase_lightColor.rgb * AttenGGX2831_g462 );
			float SpecularHighlightToggle2498_g462 = _CubemapSpecularToggle;
			float specularTermToggle2305_g462 = SpecularHighlightToggle2498_g462;
			float3 localcalcSpecularTerm2305_g462 = calcSpecularTerm( GGXVisibilityTerm2305_g462 , GGXTerm2305_g462 , NdotL2305_g462 , LdotH2305_g462 , roughness2305_g462 , specColor2305_g462 , lightcolor2305_g462 , specularTermToggle2305_g462 );
			float3 specularTerm2404_g462 = localcalcSpecularTerm2305_g462;
			float NdotV2404_g462 = CorrectedNdotV2507_g462;
			float3 specColor2404_g462 = SpecColor2715_g462;
			float roughness2404_g462 = roughness2729_g462;
			float OneMinusReflectivity2718_g462 = oneMinusReflectivity2324_g462;
			float oneMinusReflectivity2404_g462 = OneMinusReflectivity2718_g462;
			float3 indirectNormal2316_g462 = WorldNormals305_g462;
			float AO2783_g462 = _BRDFAmbientOcclusion;
			Unity_GlossyEnvironmentData g2316_g462 = UnityGlossyEnvironmentSetup( SmoothnessTex290_g462, data.worldViewDir, indirectNormal2316_g462, float3(0,0,0));
			float3 indirectSpecular2316_g462 = UnityGI_IndirectSpecular( data, AO2783_g462, indirectNormal2316_g462, g2316_g462 );
			float3 indirectspecular2404_g462 = indirectSpecular2316_g462;
			float smoothness2404_g462 = SmoothnessTex290_g462;
			float perceptualRoughness2404_g462 = perceptualRoughness2761_g462;
			float3 localcalcSpecularBase2404_g462 = calcSpecularBase( specularTerm2404_g462 , NdotV2404_g462 , specColor2404_g462 , roughness2404_g462 , oneMinusReflectivity2404_g462 , indirectspecular2404_g462 , smoothness2404_g462 , perceptualRoughness2404_g462 );
			float3 SpecularReflections316_g462 = localcalcSpecularBase2404_g462;
			float Intensity285_g462 = _BRDFIntensity;
			float3 BRDF1911 = ( SpecularReflections316_g462 * Intensity285_g462 );
			float dotResult3_g455 = dot( WorldNormals20_g455 , ase_worldlightDir );
			float NdL2030 = dotResult3_g455;
			float lerpResult2007 = lerp( NdL2030 , 1.0 , _NdLfade);
			UnityGI gi1984 = gi;
			float3 diffNorm1984 = WorldNormalVector( i , Normals80 );
			gi1984 = UnityGI_Base( data, 1, diffNorm1984 );
			float3 indirectDiffuse1984 = gi1984.indirect.diffuse + diffNorm1984 * 0.0001;
			float3 localLightColorZero304_g455 = LightColorZero();
			float4 localFourLightAtten305_g455 = FourLightAtten();
			float4 localFourLightPosX340_g455 = FourLightPosX();
			float4 temp_cast_6 = (ase_worldPos.x).xxxx;
			float4 FourLightPosX0WorldPos286_g455 = ( localFourLightPosX340_g455 - temp_cast_6 );
			float4 localFourLightPosY342_g455 = FourLightPosY();
			float4 temp_cast_7 = (ase_worldPos.y).xxxx;
			float4 FourLightPosY0WorldPos291_g455 = ( localFourLightPosY342_g455 - temp_cast_7 );
			float4 localFourLightPosZ296_g455 = FourLightPosZ();
			float4 temp_cast_8 = (ase_worldPos.z).xxxx;
			float4 FourLightPosZ0WorldPos325_g455 = ( localFourLightPosZ296_g455 - temp_cast_8 );
			float4 temp_cast_9 = (1E-06).xxxx;
			float4 temp_output_328_0_g455 = max( ( ( FourLightPosX0WorldPos286_g455 * FourLightPosX0WorldPos286_g455 ) + ( FourLightPosY0WorldPos291_g455 * FourLightPosY0WorldPos291_g455 ) + ( FourLightPosZ0WorldPos325_g455 * FourLightPosZ0WorldPos325_g455 ) ) , temp_cast_9 );
			float4 temp_output_272_0_g455 = ( localFourLightAtten305_g455 * temp_output_328_0_g455 );
			float4 temp_cast_10 = (1E-06).xxxx;
			float4 temp_output_343_0_g455 = saturate( ( 1.0 - ( temp_output_272_0_g455 / 25.0 ) ) );
			float4 temp_output_320_0_g455 = min( ( 1.0 / ( 1.0 + temp_output_272_0_g455 ) ) , ( temp_output_343_0_g455 * temp_output_343_0_g455 ) );
			float4 temp_cast_11 = (1E-06).xxxx;
			float3 break295_g455 = WorldNormals20_g455;
			float4 temp_output_366_0_g455 = ( rsqrt( temp_output_328_0_g455 ) * ( ( FourLightPosX0WorldPos286_g455 * break295_g455.x ) + ( FourLightPosY0WorldPos291_g455 * break295_g455.y ) + ( FourLightPosZ0WorldPos325_g455 * break295_g455.z ) ) );
			float4 temp_cast_12 = (1.0).xxxx;
			float4 lerpResult481_g455 = lerp( max( float4( 0,0,0,0 ) , temp_output_366_0_g455 ) , temp_cast_12 , _NdLfade);
			float4 temp_output_368_0_g455 = ( temp_output_320_0_g455 * lerpResult481_g455 );
			float4 break337_g455 = temp_output_368_0_g455;
			float3 localLightColorZOne303_g455 = LightColorZOne();
			float3 localLightColorZTwo302_g455 = LightColorZTwo();
			float3 localLightColorZThree301_g455 = LightColorZThree();
			#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch2293 = ( ( localLightColorZero304_g455 * break337_g455.x ) + ( localLightColorZOne303_g455 * break337_g455.y ) + ( localLightColorZTwo302_g455 * break337_g455.z ) + ( localLightColorZThree301_g455 * break337_g455.w ) );
			#else
				float3 staticSwitch2293 = float3( 0,0,0 );
			#endif
			#ifdef VERTEXLIGHT_ON
				float3 staticSwitch2294 = staticSwitch2293;
			#else
				float3 staticSwitch2294 = float3( 0,0,0 );
			#endif
			float3 DiffuseVertexLighting2295 = staticSwitch2294;
			float3 FinalLight1989 = ( ( ase_lightColor.rgb * ase_lightAtten * saturate( lerpResult2007 ) ) + indirectDiffuse1984 + DiffuseVertexLighting2295 );
			float4 switchResult2264 = (((i.ASEVFace>0)?(( ( Color1917 + EdgeFoam1909 + EdgeWave2877 ) * float4( FinalLight1989 , 0.0 ) )):(float4( 0,0,0,0 ))));
			float time2957 = ( _Time1684 * 10.0 );
			float2 voronoiSmoothId2957 = 0;
			float switchResult2253 = (((i.ASEVFace>0)?(_GrabPassDistortion):(( _GrabPassDistortion * 10.0 ))));
			float eyeDepth28_g459 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float2 temp_output_20_0_g459 = ( (Normals80).xy * ( switchResult2253 / max( ase_screenDepth , 0.1 ) ) * saturate( ( eyeDepth28_g459 - ase_screenDepth ) ) );
			float4 temp_output_7_0_g459 = ( float4( temp_output_20_0_g459, 0.0 , 0.0 ) + ase_screenPosNorm );
			float eyeDepth2_g459 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, temp_output_7_0_g459.xy ));
			float2 temp_output_32_0_g459 = (( float4( ( temp_output_20_0_g459 * saturate( ( eyeDepth2_g459 - ase_screenDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
			float2 temp_output_1_0_g459 = ( ( floor( ( temp_output_32_0_g459 * (_CameraDepthTexture_TexelSize).zw ) ) + 0.5 ) * (_CameraDepthTexture_TexelSize).xy );
			float2 temp_output_2408_38 = temp_output_1_0_g459;
			float2 _refractUV1673 = temp_output_2408_38;
			float2 temp_output_73_0_g460 = _refractUV1673;
			float2 UV22_g461 = float4( temp_output_73_0_g460, 0.0 , 0.0 ).xy;
			float2 localUnStereo22_g461 = UnStereo( UV22_g461 );
			float2 break64_g460 = localUnStereo22_g461;
			float clampDepth76_g460 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_73_0_g460, 0.0 , 0.0 ).xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g460 = ( 1.0 - clampDepth76_g460 );
			#else
				float staticSwitch38_g460 = clampDepth76_g460;
			#endif
			float3 appendResult39_g460 = (float3(break64_g460.x , break64_g460.y , staticSwitch38_g460));
			float4 appendResult42_g460 = (float4((appendResult39_g460*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g460 = mul( unity_CameraInvProjection, appendResult42_g460 );
			float3 In72_g460 = ( (temp_output_43_0_g460).xyz / (temp_output_43_0_g460).w );
			float3 localInvertDepthDir72_g460 = InvertDepthDir72_g460( In72_g460 );
			float4 appendResult49_g460 = (float4(localInvertDepthDir72_g460 , 1.0));
			float2 coords2957 = (mul( unity_CameraToWorld, appendResult49_g460 )).xz * _CausticsScale;
			float2 id2957 = 0;
			float2 uv2957 = 0;
			float voroi2957 = voronoi2957( coords2957, time2957, id2957, uv2957, 0, voronoiSmoothId2957 );
			float smoothstepResult2993 = smoothstep( 0.133 , 1.0 , voroi2957);
			float4 screenColor1646 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_2408_38);
			float4 _distortion1672 = ( screenColor1646 * float4( FinalLight1989 , 0.0 ) );
			float4 temp_output_2996_0 = ( smoothstepResult2993 * _distortion1672 );
			float4 lerpResult2961 = lerp( temp_output_2996_0 , ( temp_output_2996_0 * 3.0 ) , saturate( pow( smoothstepResult2993 , 3.0 ) ));
			float4 emission1669 = ( ( ( max( ( lerpResult2961 * 2.0 ) , float4( 0,0,0,0 ) ) * _CausticIntensity * float4( FinalLight1989 , 0.0 ) ) * _depthMask1652 ) + saturate( ( _distortion1672 * _depthMask1652 ) ) );
			float4 lerpResult2278 = lerp( temp_output_1942_0 , temp_output_1950_0 , _BacksideWaterColor);
			float4 ColorBackside2279 = lerpResult2278;
			float fresnelNdotV2247 = dot( WorldNormal1915, ase_worldViewDir );
			float fresnelNode2247 = ( _fresnelbias + _fresnelscale * pow( 1.0 - fresnelNdotV2247, _fresnelpower ) );
			float4 lerpResult2249 = lerp( ( ColorBackside2279 * float4( FinalLight1989 , 0.0 ) ) , _distortion1672 , ( 1.0 - saturate( fresnelNode2247 ) ));
			float4 switchResult2230 = (((i.ASEVFace>0)?(emission1669):(lerpResult2249)));
			float3 worldPos2458 = ase_worldPos;
			float3 viewDir2458 = ase_worldViewDir;
			float3 normalDir2458 = WorldNormal1915;
			float3 albedo2458 = Color1917.rgb;
			float4 screenPos2458 = computeGrabScreenPos2454;
			float3 localSSR2458 = SSR( worldPos2458 , viewDir2458 , normalDir2458 , albedo2458 , screenPos2458 );
			float3 switchResult2459 = (((i.ASEVFace>0)?(localSSR2458):(float3( 0,0,0 ))));
			#ifdef _SSR_ON
				float3 staticSwitch2460 = switchResult2459;
			#else
				float3 staticSwitch2460 = float3( 0,0,0 );
			#endif
			float3 SSR2467 = staticSwitch2460;
			c.rgb = ( float4( BRDF1911 , 0.0 ) + switchResult2264 + switchResult2230 + float4( SSR2467 , 0.0 ) ).rgb;
			c.a = saturate( ( Opacity2874 + EdgeWave2877 ) );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
273;48;2382;901;2696.385;-2193.765;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;2026;-2543.653,2480;Inherit;False;11072.84;941.4859;Originally made by PolyToots (https://www.patreon.com/posts/water-water-and-41716139) (https://www.youtube.com/c/PolyToots) changed it in some ways to make it work with the rest of the shader;8;1651;1634;1625;1629;1623;2151;1622;1624;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1624;-80,2528;Inherit;False;1593.12;428.3525;;10;1901;2259;2258;625;1684;1879;80;2402;2401;2375;Final Normal Maps;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1879;-48,2592;Inherit;False;Property;_UVTiling;UV Tiling;12;0;Fetch;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1622;-2511.621,2944;Inherit;False;1024.633;447.1135;;11;2999;3003;1683;2709;1681;2704;1679;2023;1678;2021;1699;tex3D Normal Map UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2151;-1456,2528;Inherit;False;1329.842;717.3252;tex3D Normal Map with custom lod setup;22;2193;2207;2204;2198;2203;2209;2210;2118;2124;2117;2176;2121;2168;2132;2057;2058;1688;2560;2562;2567;3007;3008;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;2375;112,2592;Inherit;False;Normal scroll;31;;427;165ce0b77cdf01d4db68ed4aeb90cad2;0;1;68;FLOAT;0;False;5;FLOAT3;0;FLOAT2;83;FLOAT;87;FLOAT2;98;FLOAT;97
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2193;-1408,2928;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1699;-2336,3152;Inherit;False;Property;_UVTiling;UV Tiling;51;1;[HideInInspector];Fetch;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1684;416,2688;Inherit;False;_Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;2999;-2496,3232;Inherit;False;2058;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.BreakToComponentsNode;3003;-2304,3232;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;1678;-2208,3008;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2023;-2176,3152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2021;-2192,3280;Inherit;False;1684;_Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1623;-2153,2528;Inherit;False;675.9541;390.5852;side fix;3;1685;1687;1686;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;2210;-1232,3072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1685;-2064,2608;Inherit;False;Property;_3DNormalScale;3D Normal Scale;43;0;Create;True;0;0;0;False;0;False;1;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1679;-2000,3152;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;2118;-1216,2864;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;2124;-1216,2720;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1681;-2000,3024;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2203;-1232,3152;Inherit;False;Property;_3DNormalLod;3D Normal Lod;44;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2209;-1104,3008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1686;-1984,2704;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2704;-2000,3280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;2117;-944,2832;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;2709;-1840,3088;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;2198;-944,3152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2207;-928,3008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1687;-1760,2624;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3008;-1360,2656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2204;-784,3008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1683;-1696,3088;Inherit;False;_3duvs;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2176;-768,2832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.005;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2058;-944,2592;Inherit;True;Property;_Normals_3D;Normals_3D;42;0;Create;True;0;0;0;False;0;False;None;None;False;bump;LockedToTexture3D;Texture3D;-1;0;2;SAMPLER3D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SwitchByFaceNode;3007;-1120,2624;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1688;-720,2672;Inherit;False;1683;_3duvs;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;2168;-608,2832;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2450;2560,-1488;Inherit;False;1588.387;1030.79;Code by error.mdl with changes from Mochie, Toocanzs and Xiexe;18;2467;2460;2461;2463;2462;2465;2466;2464;2459;2458;2455;2457;2454;2453;2456;2452;2451;2488;Screen Space Reflections;1,1,1,1;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;2057;-560,2608;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    //float3 dx = ddx(UV)@ //tex3D does not have mipmaps$    //float3 dy = ddy(UV)@ //tex3D does not have mipmaps$$    //blend samples with calculated weights$    return mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[0].xy), 0), 0, 0), Normalscale), BW_vx[3].x) + $            mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[1].xy), 0), 0, 0), Normalscale), BW_vx[3].y) + $            mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[2].xy), 0), 0, 0), Normalscale), BW_vx[3].z)@;3;Create;3;True;tex;SAMPLER3D;0,0;In;;Float;False;True;UV;FLOAT3;0,0,0;In;;Float;False;True;Normalscale;FLOAT;0;In;;Inherit;False;tex3DStochasticNormals;False;False;1;7;;False;3;0;SAMPLER3D;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;2121;-448,2832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;2402;400,2768;Inherit;False;Property;_3DNormals;3D Normals Toggle;41;0;Create;False;0;0;0;False;1;ToggleUI;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.PosVertexDataNode;2451;2608,-656;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;2132;-288,2784;Inherit;False;3;0;FLOAT3;0,0,1;False;1;FLOAT3;0,0,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1277;6064,1168;Inherit;False;1762;428;;13;2447;1260;2434;2424;2449;2422;1276;2448;2441;2443;1284;1275;2569;Final Vertex Offset with Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1275;6112,1216;Inherit;True;Property;_VertexOffsetMask;Vertex Offset Mask;64;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;2452;2784,-656;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;2401;640,2752;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComputeGrabScreenPosHlpNode;2454;2976,-656;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;1901;800,2752;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1265;3521.919,1088;Inherit;False;2461.53;816.3672;;31;1262;2391;1209;1251;1210;1213;1212;2389;2388;1259;1211;1201;1200;1199;1203;1228;1283;1243;1278;1282;1205;1202;1244;1280;1242;1279;1281;1208;1285;1207;1206;GerstnerWave;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1284;6432,1312;Inherit;False;VertexOffsetMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1285;3984,1792;Inherit;False;1284;VertexOffsetMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;1208;3904,1600;Inherit;False;Property;_WaveC;WaveC dir, dir, steepness, wavelength;60;0;Create;False;0;0;0;False;0;False;1,0,0.5,0.00125;-0.44,-0.04,0.3,0.005;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;1206;3904,1216;Inherit;False;Property;_WaveA;WaveA dir, dir, steepness, wavelength;58;0;Create;False;0;0;0;False;0;False;1,0,0.5,0.00125;0.74,0.45,0.333,0.00333;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;2259;976,2816;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;1207;3904,1408;Inherit;False;Property;_WaveB;WaveB dir, dir, steepness, wavelength;59;0;Create;False;0;0;0;False;0;False;1,0,0.5,0.00125;-0.38,0.64,0.6,0.002;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2488;3216,-656;Inherit;False;UVGrab;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;1629;3344,2528;Inherit;False;1614.647;526.6688;;21;2487;1649;1644;1640;1635;1636;1633;1631;1652;2477;2476;2489;2475;2474;2473;2472;2471;2409;2470;2469;2990;DepthMasks;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2258;1136,2752;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1244;3616,1600;Inherit;False;Constant;_Float2;Float 2;36;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2469;3392,2592;Inherit;False;2488;UVGrab;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1280;4240,1472;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1242;3584,1504;Inherit;False;Property;_GerstnerHeight;Gerstner Height;61;0;Create;True;0;0;0;False;0;False;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1279;4240,1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1281;4240,1664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;1203;4496,1600;Inherit;False;Constant;_binormal;binormal;32;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;1283;4368,1600;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;1205;4496,1216;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;2470;3552,2592;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;2029;-2038.805,1088;Inherit;False;2374.342;1257.702;;20;1911;2412;2032;1918;1910;2295;2294;2293;2296;2030;2372;1915;1897;1898;2954;2955;2956;373;2953;2970;BRDF;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2990;3392,2768;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1243;3776,1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;1202;4496,1408;Inherit;False;Constant;_tangent;tangent;32;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;1312,2752;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1228;4400,1152;Inherit;False;Property;_GerstnerSpeed;Gerstner Speed;62;0;Create;True;0;0;0;False;0;False;0.05;0.005;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1282;4368,1408;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;1278;4368,1216;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;2471;3680,2640;Inherit;False;return UNITY_Z_0_FAR_FROM_CLIPSPACE(In0)@;1;Create;1;True;In0;FLOAT;0;In;;Inherit;False;SurfaceDepth;False;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;2409;3632,2768;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;1199;4720,1216;Inherit;False;// Source: https://catlikecoding.com/unity/tutorials/flow/waves$float steepness = wave.z@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, p.xz) - c * _Time.y * Speed)@$float a = steepness / k@$tangent += float3($	-d.x * d.x * (steepness * sin(f)),$	d.x * (steepness * cos(f)),$	-d.x * d.y * (steepness * sin(f))$)@$binormal += float3($	-d.x * d.y * (steepness * sin(f)),$	d.y * (steepness * cos(f)),$	-d.y * d.y * (steepness * sin(f))$)@$return float3($	d.x * (a * cos(f)),$	a * sin(f) * Height,$	d.y * (a * cos(f))$)@;3;Create;6;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;True;p;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;0,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,0;InOut;;Inherit;False;True;Speed;FLOAT;0;In;;Inherit;False;True;Height;FLOAT;0;In;;Inherit;False;GerstnerWave;False;False;0;;False;6;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT3;0;FLOAT3;3;FLOAT3;4
Node;AmplifyShaderEditor.CustomExpressionNode;1200;4720,1408;Inherit;False;// Source: https://catlikecoding.com/unity/tutorials/flow/waves$float steepness = wave.z@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, p.xz) - c * _Time.y * Speed)@$float a = steepness / k@$tangent += float3($	-d.x * d.x * (steepness * sin(f)),$	d.x * (steepness * cos(f)),$	-d.x * d.y * (steepness * sin(f))$)@$binormal += float3($	-d.x * d.y * (steepness * sin(f)),$	d.y * (steepness * cos(f)),$	-d.y * d.y * (steepness * sin(f))$)@$return float3($	d.x * (a * cos(f)),$	a * sin(f) * Height,$	d.y * (a * cos(f))$)@;3;Create;6;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;True;p;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;0,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,0;InOut;;Inherit;False;True;Speed;FLOAT;0;In;;Inherit;False;True;Height;FLOAT;0;In;;Inherit;False;GerstnerWave;False;False;0;;False;6;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT3;0;FLOAT3;3;FLOAT3;4
Node;AmplifyShaderEditor.CustomExpressionNode;1201;4720,1600;Inherit;False;// Source: https://catlikecoding.com/unity/tutorials/flow/waves$float steepness = wave.z@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, p.xz) - c * _Time.y * Speed)@$float a = steepness / k@$tangent += float3($	-d.x * d.x * (steepness * sin(f)),$	d.x * (steepness * cos(f)),$	-d.x * d.y * (steepness * sin(f))$)@$binormal += float3($	-d.x * d.y * (steepness * sin(f)),$	d.y * (steepness * cos(f)),$	-d.y * d.y * (steepness * sin(f))$)@$return float3($	d.x * (a * cos(f)),$	a * sin(f) * Height,$	d.y * (a * cos(f))$)@;3;Create;6;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;True;p;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;0,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,0;InOut;;Inherit;False;True;Speed;FLOAT;0;In;;Inherit;False;True;Height;FLOAT;0;In;;Inherit;False;GerstnerWave;False;False;0;;False;6;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT3;0;FLOAT3;3;FLOAT3;4
Node;AmplifyShaderEditor.CommentaryNode;543;558.4,1088;Inherit;False;1612.088;655.8855;;20;998;1889;928;411;747;746;412;438;1003;743;415;2644;999;626;1001;1887;1000;1885;416;1886;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1898;-1856,1312;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;998;736,1376;Inherit;False;Constant;_NoiseScaleOffset;Noise Scale Offset;50;0;Create;True;0;0;0;False;0;False;7.5,1.5,0,0;1,5,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2472;3872,2608;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1211;4992,1280;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1886;592,1552;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;1897;-1696,1312;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;1000;928,1376;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1259;5120,1280;Inherit;False;GerstnerOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;625;416,2592;Inherit;False;NormalVector;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1631;3504,2944;Inherit;False;Property;_Depth;Opacity Depth;8;0;Create;False;0;0;0;False;0;False;0.85;0.836;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.SurfaceDepthNode;1633;3568,2848;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1915;-1504,1312;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;2473;4016,2608;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1885;752,1584;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;2388;5232,1360;Inherit;False;Property;_GerstnerWavesToggle;Gerstner Waves Toggle;56;0;Create;True;0;0;0;True;3;Space(25);Header(Gerstner Waves _ Vertex Offset _ Tessellation);ToggleUI;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;416;720,1248;Inherit;False;Constant;_NoiseSpeed;Noise Speed;47;0;Create;True;0;0;0;False;0;False;2;3.44;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1887;1008,1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2372;-1296,1312;Inherit;False;Utilities;2;;455;039d2583fcc3ab544b6fd55efa3a137e;0;1;19;FLOAT3;0,0,0;False;40;FLOAT;0;FLOAT;14;FLOAT;17;FLOAT;15;FLOAT;16;FLOAT;60;FLOAT;62;FLOAT;63;FLOAT;64;FLOAT;65;FLOAT;13;FLOAT;446;FLOAT;18;FLOAT;114;FLOAT4;372;FLOAT4;373;FLOAT4;374;FLOAT4;375;FLOAT4;397;FLOAT4;376;FLOAT3;377;FLOAT3;378;FLOAT3;379;FLOAT3;380;FLOAT3;382;FLOAT3;384;FLOAT3;386;FLOAT3;388;FLOAT;381;FLOAT;383;FLOAT;385;FLOAT;387;FLOAT;389;FLOAT;390;FLOAT;391;FLOAT;392;FLOAT3;393;FLOAT3;394;FLOAT3;395;FLOAT3;396
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1635;3872,2784;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1636;3776,2944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;2389;5536,1216;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;999;1056,1376;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1001;928,1472;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;2474;4144,2608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;626;976,1168;Inherit;False;625;NormalVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;1152,1504;Inherit;False;625;NormalVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1276;6432,1216;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2030;-816,1328;Inherit;False;NdL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;415;1136,1248;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2567;-608,2960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1625;1552,2528;Inherit;False;1753.765;363.6911;;10;1646;1673;1626;2253;2254;1627;1672;2290;2284;2408;Refraction + UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;2644;1168,1168;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1003;1184,1376;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2296;-816,1792;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1640;4032,2784;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2489;4240,2688;Inherit;False;Property;_GeneralDepth;General Depth;9;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2475;4288,2608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1986;1280,-512;Inherit;False;1208.644;622.9869;;12;2297;1984;1985;1989;1988;1987;1983;2056;2007;2282;2031;1978;Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2876;-2320,-544;Inherit;False;3469.612;669.329;Edited version of Takanu#8278 Concept;41;2945;2927;2929;2932;2931;2928;2930;2895;2892;2894;2736;2943;2739;2735;2944;2878;2840;2891;2877;2898;2884;2843;2904;2858;2839;2890;2902;2837;2796;2797;2794;2836;2798;2863;2808;2862;2875;2864;2854;2793;2857;Edge Wave;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;1644;4192,2784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1627;1568,2656;Inherit;False;Property;_GrabPassDistortion;GrabPass Distortion;10;0;Create;True;0;0;0;False;0;False;0.15;0.05;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2562;-464,2960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;438;1344,1344;Inherit;False;Constant;_WaveTiling;Wave Tiling;26;0;Create;True;0;0;0;False;0;False;0.01;1000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;2293;-672,1792;Inherit;False;Property;_Keyword1;Keyword 1;42;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;False;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;412;1344,1152;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;2476;4432,2608;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2031;1408,-240;Inherit;False;2030;NdL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2894;-2288,-80;Inherit;False;Property;_EdgeWaveSpeed;Edge Wave Speed;53;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2569;6576,1216;Inherit;False;GerstnerOffsetWithMask;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;2694;-144,-1072;Inherit;False;1322;294;Wave Height for fragment effects;9;2570;2568;2541;2554;2542;2587;2571;2543;2544;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2282;1312,-160;Inherit;False;Property;_NdLfade;NdL fade;11;0;Create;True;0;0;0;True;0;False;0.75;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;746;1344,1488;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2254;1872,2720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2007;1600,-240;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2570;-96,-1024;Inherit;False;2569;GerstnerOffsetWithMask;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;2477;4592,2608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;747;1536,1504;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1649;4352,2784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2560;-336,2959;Inherit;False;LODDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2892;-2016,-80;Inherit;False;1;0;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;2294;-384,1792;Inherit;False;Property;_Keyword1;Keyword 1;42;0;Create;True;0;0;0;False;0;False;0;0;0;False;VERTEXLIGHT_ON;Toggle;2;Key0;Key1;Fetch;False;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;411;1536,1152;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-880,192;Inherit;False;2642.451;783.4632;;42;1909;54;1846;55;1823;372;1891;1825;1827;340;924;1857;1877;2041;1852;1894;389;631;344;346;1883;1858;1697;1851;2040;1854;1859;1890;87;1850;2506;2510;2511;2512;2514;2522;2526;2588;2621;2691;2692;2693;EdgeFoam;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1985;1632,-80;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2506;416,704;Inherit;False;Property;_EdgeFoamDistance;Edge Foam Distance;47;0;Create;True;0;0;0;False;0;False;0.5;0.836;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2056;1744,-240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;1983;1696,-336;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;928;1824,1344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;1978;1728,-464;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;2295;-160,1792;Inherit;False;DiffuseVertexLighting;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2541;160,-1024;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;2739;-1968,-304;Inherit;False;Reconstruct World Position From Depth Morioh edit;-1;;457;faa6426e02b291840a1f94a0373d2fa1;0;1;73;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1626;2032,2576;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1652;4736,2608;Inherit;False;_depthMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;2895;-1840,-80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2253;2016,2656;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2487;4528,2784;Inherit;False;_depthMaskOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2568;96,-896;Inherit;False;2560;LODDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2943;-1552,-304;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;2297;1776,0;Inherit;False;2295;DiffuseVertexLighting;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1889;1952,1344;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;2930;-1696,-80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2554;304,-1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2928;-1696,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1863;3024,224;Inherit;False;2487;_depthMaskOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;1984;1792,-80;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;2408;2208,2592;Inherit;False;DepthMaskedRefraction;-1;;459;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.WorldPosInputsNode;2736;-1600,-448;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;2526;704,704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1987;1904,-368;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1827;672,784;Inherit;False;1652;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2510;880,784;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1988;2128,-240;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1859;-400,800;Inherit;False;Property;_NormalMapdeformation;Normal Map deformation;49;0;Create;True;0;0;0;False;0;False;0.05;0.07;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1864;3248,224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1890;-128,656;Inherit;False;1889;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2932;-1568,-80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2931;-1696,-160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2735;-1408,-400;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;87;-832,240;Inherit;True;Property;_SeaFoam;SeaFoam;45;0;Create;True;0;0;0;False;2;Space(25);Header(EDGE FOAM);False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;1673;2592,2768;Inherit;False;_refractUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1850;-608,400;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;2542;464,-1024;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-2;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1634;4992,2528;Inherit;False;2224.618;402.1705;;21;2989;2998;2997;2996;2995;2994;2993;2961;1707;2289;2038;2965;2963;2964;2957;1643;1641;1645;1638;2539;1637;Caustics;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2929;-1552,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2945;-1552,-160;Inherit;False;Property;_EdgeWaveFrequency;Edge Wave Frequency;52;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2927;-1424,-80;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2944;-1264,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1851;-432,432;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;2040;-608,304;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.DynamicAppendNode;1858;-112,736;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1854;-144,864;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;1883;32,656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1989;2272,-240;Inherit;False;FinalLight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;2511;1040,784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;2514;1056,704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1697;-432,528;Inherit;False;Property;_UVTiling;UV Tiling;9;1;[HideInInspector];Fetch;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;346;-160,576;Inherit;False;Property;_EdgeFoamSpeed;Edge Foam Speed;46;0;Create;True;1;EDGE FOAM;0;0;False;0;False;0.025;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2587;608,-1024;Inherit;False;VertexOffsetForEffects;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1637;5056,2624;Inherit;False;1673;_refractUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1865;3392,224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;16;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1852;48,800;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2793;-1120,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;-272,432;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;2512;1200,688;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;10;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1894;160,672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;631;16,496;Inherit;False;625;NormalVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2874;3520,224;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2857;-1200,-304;Inherit;False;Property;_EdgeWaveOffset;Edge Wave Offset;54;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1638;5472,2704;Inherit;False;1684;_Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;1646;2592,2592;Inherit;False;Global;_GrabTexture;GrabTexture;2;0;Create;True;0;0;0;False;0;False;Object;-1;True;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2588;1200,816;Inherit;False;2587;VertexOffsetForEffects;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2539;5232,2624;Inherit;False;Reconstruct World Position From Depth Morioh edit;-1;;460;faa6426e02b291840a1f94a0373d2fa1;0;1;73;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;2290;2768,2672;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;344;32,576;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2864;-992,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2691;1440,816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1643;5664,2816;Inherit;False;Property;_CausticsScale;Caustics Scale;18;0;Create;True;0;0;0;False;0;False;3;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2875;-496,-320;Inherit;False;2874;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1877;208,496;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;2854;-1200,-224;Inherit;False;Property;_EdgeWaveSharpness;Edge Wave Sharpness;51;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2041;-128,432;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1641;5664,2704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1825;1360,688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1857;288,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2284;2944,2608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;1645;5648,2624;Inherit;False;True;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;2798;-336,-320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2957;5872,2624;Inherit;True;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;1672;3104,2608;Inherit;False;_distortion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2621;1600,688;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2808;-656,-400;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.995;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;924;368,432;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2989;6064,2832;Inherit;False;1672;_distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;2794;-496,-400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2797;-192,-320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2994;6080,2752;Inherit;False;Constant;_HFLH;HFLH;10;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;340;512,256;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;7;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;2693;1707.821,639.6778;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2993;6064,2624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.133;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;827;1280,-1152;Inherit;False;987.0345;545.7963;;10;2281;2279;1917;2278;1950;1942;43;1948;2491;2490;Main Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;372;672,256;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2796;-32,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2996;6256,2720;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2414;3408,960;Inherit;False;Property;_VertOffsetDistMaskTessMaxxthis;Vert Offset Dist Mask TessMax x this;68;0;Create;True;0;0;0;False;0;False;0.85;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2902;128,-112;Inherit;False;2560;LODDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2377;3504,704;Inherit;False;Property;_TessMax;Tess Max Distance;67;0;Create;False;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;2995;6240,2624;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2692;1043.821,599.6778;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2571;816,-896;Inherit;False;1652;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2997;6384,2624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1891;1088,512;Inherit;False;1889;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1823;1120,304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2890;304,-496;Inherit;False;Property;_ToggleEdgeWave;Toggle Edge Wave;50;0;Create;True;0;0;0;False;3;Space(25);Header(EDGE WAVE);ToggleUI;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;2416;3520,800;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2863;-832,-224;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2378;3456,544;Inherit;False;Property;_TessValue;TessValue;65;1;[IntRange];Create;True;0;0;0;False;0;False;1;0;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1948;1360,-896;Inherit;False;Property;_ColorSecondary;Color Secondary;5;0;Create;True;1;MAIN OPTIONS;0;0;False;0;False;0,1,0.8705882,0.5019608;0,1,0.8716099,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;1360,-1072;Inherit;False;Property;_Color;Color;4;1;[Header];Create;True;1;MAIN OPTIONS;0;0;False;0;False;0,0.4078431,0.6901961,1;0,0.4059581,0.6886792,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2904;352,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2379;3504,624;Inherit;False;Property;_TessMin;Tess Min Distance;66;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2998;6384,2720;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2543;864,-1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2862;-832,-128;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2415;3744,848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;2418;4128,832;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2961;6544,2576;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2836;-656,-224;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.75;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2417;3904,800;Inherit;False;return UnityCalcDistanceTessFactor(vertex, minDist, maxDist, tess)@;1;Create;4;True;vertex;FLOAT4;0,0,0,0;In;;Inherit;False;True;minDist;FLOAT;0;In;;Inherit;False;True;maxDist;FLOAT;0;In;;Inherit;False;True;tess;FLOAT;1;In;;Inherit;False;Tess Distance;False;False;0;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;2884;560,-464;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2964;6560,2704;Inherit;False;Constant;_Float5;Float 5;55;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2544;1024,-1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1942;1600,-1072;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;2522;1280,320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1846;1248,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1950;1600,-896;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;1120,400;Inherit;False;Property;_EdgePower;Edge Intensity;48;0;Create;False;0;0;0;False;0;False;0.75;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1651;7296,2528;Inherit;False;1213.09;370.5899;;8;1669;1667;1662;1663;1659;1658;1670;1655;Depth_Merged;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2963;6704,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;2837;-496,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;2419;4272,800;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2877;944,-464;Inherit;False;EdgeWave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2491;1872,-1072;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;1408,336;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2954;-1184,1136;Inherit;False;2874;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2289;6816,2752;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2281;1584,-800;Inherit;False;Property;_BacksideWaterColor;Backside Water Color;13;1;[Header];Create;True;1;Backside;0;0;False;0;False;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2420;4448,800;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2839;-32,-224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2955;-1184,1216;Inherit;False;2877;EdgeWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1909;1552,336;Inherit;False;EdgeFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1655;7520,2800;Inherit;False;1652;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1917;2032,-1072;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2276;1840,192;Inherit;False;1002.941;540.8196;Backside refraction, transparency and Color over Fresnel;12;2261;2263;2269;2280;2249;2260;2251;2247;2248;2268;2267;2265;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2038;6784,2672;Inherit;False;Property;_CausticIntensity;Caustic Intensity;17;0;Create;True;0;0;0;False;2;Space(25);Header(CAUSTICS);False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;2965;6864,2576;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1670;7520,2672;Inherit;False;1672;_distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2858;-160,-128;Inherit;False;Property;_EdgeWaveVertexOffset;Edge Wave Vertex Offset;55;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2453;2976,-960;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;2268;1888,624;Inherit;False;Property;_fresnelpower;fresnel power;16;0;Create;True;0;0;0;False;0;False;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2843;128,-224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1707;7024,2576;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2455;2976,-736;Inherit;False;1917;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1659;7312,2656;Inherit;False;1652;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2956;-1008,1168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2267;1888,544;Inherit;False;Property;_fresnelscale;fresnel scale;15;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2456;2976,-1104;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;2278;1872,-928;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2248;1888,384;Inherit;False;1915;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1910;-896,1232;Inherit;False;1909;EdgeFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2421;4592,800;Inherit;False;TessellationDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2265;1888,464;Inherit;False;Property;_fresnelbias;fresnel bias;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;2443;6896,1392;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1658;7744,2704;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2457;2976,-816;Inherit;False;1915;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;2247;2112,464;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2898;352,-224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2447;6896,1312;Inherit;False;Property;_VertexOffsetCameradistMask;Vertex Offset Camera dist Mask;63;0;Create;True;0;0;0;False;1;ToggleUI;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2441;7136,1392;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1212;4992,1408;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;1662;7920,2704;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2279;2032,-928;Inherit;False;ColorBackside;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;2458;3248,-928;Inherit;False;float NdotV = abs(dot(normalDir, viewDir))@$float omr = unity_ColorSpaceDielectricSpec.a * unity_ColorSpaceDielectricSpec.a@$float3 specularTint = lerp(unity_ColorSpaceDielectricSpec.rgb, 1, 0)@$float roughSq = 1-_Smoothness * 1-_Smoothness@$float roughBRDF = max(roughSq, 0.003)@	$float3 reflDir = reflect(-viewDir, normalDir)@$float surfaceReduction = 1.0 / (roughBRDF*roughBRDF + 1.0)@$float grazingTerm = saturate((_Smoothness) + (1-omr))@$float fresnel = FresnelLerp(specularTint, grazingTerm, NdotV)@$float3 reflCol = 0@$	half4 ssrCol = GetSSR(worldPos, reflDir, normalDir, albedo, screenPos)@$	ssrCol.rgb *= lerp(10, 7, linearstep(0,1,0))@$	//#if FOAM_ENABLED$	//	foamLerp = 1-foamLerp@$	//	foamLerp = smoothstep(0.7, 1, foamLerp)@$	//	ssrCol.a *= foamLerp@$	//#endif$	reflCol = lerp(reflCol, ssrCol.rgb, ssrCol.a)@$reflCol = reflCol * fresnel * surfaceReduction@$return reflCol@;3;Create;5;True;worldPos;FLOAT3;0,0,0;In;;Inherit;False;True;viewDir;FLOAT3;0,0,0;In;;Inherit;False;True;normalDir;FLOAT3;0,0,0;In;;Inherit;False;True;albedo;FLOAT3;0,0,0;In;;Inherit;False;True;screenPos;FLOAT4;0,0,0,0;In;;Inherit;False;SSR;False;False;1;2461;;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2422;6640,1312;Inherit;False;2421;TessellationDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2953;-896,1168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1663;7520,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2448;7136,1472;Inherit;False;Constant;_Float6;Float 6;27;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1213;4992,1536;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;373;-736,1232;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2269;2272,336;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2459;3488,-928;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;2449;7280,1312;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2424;6896,1216;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1933;2896,-208;Inherit;False;1917;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;2251;2352,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1667;8080,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2879;2896,-48;Inherit;False;2877;EdgeWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;2970;-592,1168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2280;2256,256;Inherit;False;2279;ColorBackside;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2032;-624,1328;Inherit;False;1915;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;2891;560,-288;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;1210;5168,1472;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1947;2896,-128;Inherit;False;1909;EdgeFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1918;-592,1408;Inherit;False;1917;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2261;2464,384;Inherit;False;1672;_distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;2840;752,-288;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;2260;2496,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;1251;5328,1552;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;1209;5328,1472;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;288;3120,-176;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2434;7472,1216;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;2460;3680,-928;Inherit;False;Property;_SSR;SSR (performance heavy);29;0;Create;False;0;0;0;True;1;Header(Screen Space Reflections by error.mdl);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2263;2480,288;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1669;8288,2576;Inherit;False;emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1990;3072,-256;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;2412;-400,1328;Inherit;False;BRDF;19;;462;c8238fd52fdf6e048bf6236ff19fd3bd;0;7;2935;FLOAT;1;False;86;FLOAT3;0,0,0;False;89;FLOAT3;1,1,1;False;1847;FLOAT;0;False;2409;FLOAT;0;False;2671;FLOAT;0;False;2411;FLOAT;0;False;2;FLOAT3;0;FLOAT;2705
Node;AmplifyShaderEditor.GetLocalVarNode;2880;3520,304;Inherit;False;2877;EdgeWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1260;7616,1216;Inherit;False;FinalVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2467;3936,-928;Inherit;False;SSR;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;2391;5536,1440;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2878;896,-288;Inherit;False;EdgeWaveVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1911;64,1328;Inherit;False;BRDF;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1691;3232,-80;Inherit;False;1669;emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2003;3264,-176;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2249;2656,352;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1262;5744,1440;Inherit;False;FinalVertexNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1261;3488,384;Inherit;False;1260;FinalVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2711;3712,224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2264;3408,-176;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1912;3424,-256;Inherit;False;1911;BRDF;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2468;3424,16;Inherit;False;2467;SSR;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2881;3456,464;Inherit;False;2878;EdgeWaveVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1775;4336,160;Inherit;False;395.8096;144.2545;Stochastic Hash, source: https://redd.it/dhr5g2;1;1778;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2230;3408,-80;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2462;3040,-1440;Inherit;True;Property;_NoiseTexSSR;Noise Tex SSR;57;1;[HideInInspector];Create;True;0;0;0;True;1;NonModifiableTextureData;False;-1;38e7d156069d4b345842d760866b8411;38e7d156069d4b345842d760866b8411;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;1778;4480,208;Float;False;return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453)@;2;Create;1;True;s;FLOAT2;0,0;In;;Float;False;hash2D2D;False;False;0;;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;2413;4080,-320;Inherit;False;Property;_Cull;Cull;7;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;4016,-48;Inherit;False;Property;_ShaderOptimizerEnabled;PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER;1;0;Create;False;0;0;0;True;1;ShaderOptimizerLockButton;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1866;3840,224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2465;3392,-1344;Inherit;False;Property;_EdgeFadeSSR;Edge Fade SSR;30;0;Create;True;0;0;0;True;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2464;2976,-1232;Inherit;False;#if SSR_ENABLED$	float2 pixSize = 2/texelSize@$	float center = floor(dim*0.5)@$	float3 refTotal = float3(0,0,0)@$	for (int i = 0@ i < floor(dim)@ i++){$		[loop] for (int j = 0@ j < floor(dim)@ j++){$			float4 refl = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture, float2(uvs.x + pixSize.x*(i-center), uvs.y + pixSize.y*(j-center)))@$			refTotal += refl.rgb@$		}$	}$	return refTotal/(floor(dim)*floor(dim))@$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;3;Create;3;True;texelSize;FLOAT2;0,0;In;;Inherit;False;True;uvs;FLOAT2;0,0;In;;Inherit;False;True;dim;FLOAT;0;In;;Inherit;False;GetBlurredGP;False;True;0;;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;2572;4080,-416;Inherit;False;Property;_ZWrite;ZWrite;6;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1263;3728,496;Inherit;False;1262;FinalVertexNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;2463;3424,-1232;Inherit;False;#if SSR_ENABLED$	float FdotR = dot(faceNormal, rayDir.xyz)@$	UNITY_BRANCH$	if (unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f  || FdotR < 0){$		return 0@$	}$	else {$		float4 noiseUvs = screenPos@$		noiseUvs.xy = (noiseUvs.xy * _GrabTexture_TexelSize.zw) / (_NoiseTexSSR_TexelSize.zw * noiseUvs.w)@	$		float4 noiseRGBA = tex2Dlod(_NoiseTexSSR, float4(noiseUvs.xy,0,0))@$		float noise = noiseRGBA.r@$		$		float3 reflectedRay = wPos + (0.2*0.09/FdotR + noise*0.09)*rayDir@$		float4 finalPos = ReflectRay(reflectedRay, rayDir, noise)@$		float totalSteps = finalPos.w@$		finalPos.w = 1@$		$		if (!any(finalPos.xyz)){$			return 0@$		}$		$		float4 uvs = UNITY_PROJ_COORD(ComputeGrabScreenPos(mul(UNITY_MATRIX_P, finalPos)))@$		uvs.xy = uvs.xy / uvs.w@$		$		#if UNITY_SINGLE_PASS_STEREO$			float xfade = 1@$		#else$			float xfade = smoothstep(0, _EdgeFadeSSR, uvs.x) * smoothstep(1, 1-_EdgeFadeSSR, uvs.x)@ //Fade x uvs out towards the edges$		#endif$		float yfade = smoothstep(0, _EdgeFadeSSR, uvs.y)*smoothstep(1, 1-_EdgeFadeSSR, uvs.y)@ //Same for y$		float lengthFade = smoothstep(1, 0, 2*(totalSteps / 50)-1)@$		$		float blurFac = max(1,min(12, 12 * (-2)*(_Smoothness-1)))@$		float4 reflection = float4(GetBlurredGP(_GrabTexture_TexelSize.zw, uvs.xy, blurFac*1.5),1)@$		reflection.rgb = lerp(reflection.rgb, reflection.rgb*albedo.rgb,smoothstep(0, 1.75, 0))@$		reflection.a = FdotR * xfade * yfade * lengthFade@$		return max(0,reflection)@$		}$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;4;Create;5;True;wPos;FLOAT3;0,0,0;In;;Inherit;False;True;rayDir;FLOAT3;0,0,0;In;;Inherit;False;True;faceNormal;FLOAT3;0,0,0;In;;Inherit;False;True;albedo;FLOAT3;0,0,0;In;;Inherit;False;True;screenPos;FLOAT4;0,0,0,0;In;;Inherit;False;GetSSR;False;True;2;2464;2466;;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;2466;3184,-1232;Inherit;False;#if SSR_ENABLED$	#if UNITY_SINGLE_PASS_STEREO$		half x_min = 0.5*unity_StereoEyeIndex@$		half x_max = 0.5 + 0.5*unity_StereoEyeIndex@$	#else$		half x_min = 0.0@$		half x_max = 1.0@$	#endif$	$	reflectedRay = mul(UNITY_MATRIX_V, float4(reflectedRay, 1))@$	rayDir = mul(UNITY_MATRIX_V, float4(rayDir, 0))@$	int totalIterations = 0@$	int direction = 1@$	float3 finalPos = 0@$	float step = 0.09@$	float lRad = 0.2@$	float sRad = 0.02@$$	[loop] for (int i = 0@ i < 50@ i++){$		totalIterations = i@$		float4 spos = ComputeGrabScreenPos(mul(UNITY_MATRIX_P, float4(reflectedRay, 1)))@$		float2 uvDepth = spos.xy / spos.w@$		UNITY_BRANCH$		if (uvDepth.x > x_max || uvDepth.x < x_min || uvDepth.y > 1 || uvDepth.y < 0){$			break@$		}$$		float rawDepth = DecodeFloatRG(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthTexture, uvDepth))@$		float linearDepth = Linear01Depth(rawDepth)@$		float sampleDepth = -reflectedRay.z@$		float realDepth = linearDepth * _ProjectionParams.z@$		float depthDifference = abs(sampleDepth - realDepth)@$$		if (depthDifference < lRad){ $			if (direction == 1){$				if(sampleDepth > (realDepth - sRad)){$					if(sampleDepth < (realDepth + sRad)){$						finalPos = reflectedRay@$						break@$					}$					direction = -1@$					step = step*0.1@$				}$			}$			else {$				if(sampleDepth < (realDepth + sRad)){$					direction = 1@$					step = step*0.1@$				}$			}$		}$		reflectedRay = reflectedRay + direction*step*rayDir@$		step += step*(0.025 + 0.005*noise)@$		lRad += lRad*(0.025 + 0.005*noise)@$		sRad += sRad*(0.025 + 0.005*noise)@$	}$	return float4(finalPos, totalIterations)@$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;4;Create;3;True;reflectedRay;FLOAT3;0,0,0;In;;Inherit;False;True;rayDir;FLOAT3;0,0,0;In;;Inherit;False;True;noise;FLOAT;0;In;;Inherit;False;ReflectRay;False;True;0;;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;383;4464,48;Inherit;False;Property;_UVTiling;UV Tiling;8;0;Create;True;0;0;0;True;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2842;3712,400;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;2461;2816,-1232;Inherit;False;#if SSR_ENABLED$	x = clamp((x - j) / (k - j), 0.0, 1.0)@ $	return x@$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;3;Create;3;True;j;FLOAT3;0,0,0;In;;Inherit;False;True;k;FLOAT3;0,0,0;In;;Inherit;False;True;x;FLOAT3;0,0,0;In;;Inherit;False;linearstep;False;True;0;;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;2376;3744,608;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.IntNode;352;4016,-128;Inherit;False;Property;_NormalScaleSecondaryAnimated;Normal Scale Secondary Animated;70;1;[HideInInspector];Create;True;0;0;0;True;1;ToggleUI;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;353;4032,-224;Inherit;False;Property;_NormalScaleAnimated;Normal Scale Animated;69;1;[HideInInspector];Create;True;0;0;0;True;1;ToggleUI;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2490;1600,-976;Inherit;False;1652;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1977;3664,-128;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1197;4048,32;Float;False;True;-1;7;ASEMaterialInspector;0;0;CustomLighting;Moriohs Shaders/Enviroment Shaders/Water;False;False;False;False;False;True;True;True;True;False;True;False;False;False;True;False;False;False;False;False;False;Off;1;True;2572;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;7;5000;7500;False;1;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;1;PreviewType=Plane;False;0;0;True;2413;-1;0;False;-1;5;Custom;//Vertex Lights;False;;Custom;Pragma;multi_compile _ VERTEXLIGHT_ON;False;;Custom;Custom;float4 _GrabTexture_TexelSize@;False;;Custom;Custom;float4 _NoiseTexSSR_TexelSize@;False;;Custom;Custom;#define SSR_ENABLED	defined(_SSR_ON) && !defined(UNITY_PASS_FORWARDADD);False;;Custom;0;0;False;0;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2375;68;1879;0
WireConnection;1684;0;2375;87
WireConnection;3003;0;2999;0
WireConnection;2023;0;1699;0
WireConnection;2210;0;2193;3
WireConnection;1679;0;1678;3
WireConnection;1679;1;2023;0
WireConnection;1679;2;3003;1
WireConnection;1681;0;1678;1
WireConnection;1681;1;2023;0
WireConnection;1681;2;3003;0
WireConnection;2209;0;2193;3
WireConnection;2209;1;2210;0
WireConnection;2704;0;2021;0
WireConnection;2117;0;2124;0
WireConnection;2117;1;2118;0
WireConnection;2709;0;1681;0
WireConnection;2709;1;1679;0
WireConnection;2709;2;2704;0
WireConnection;2198;0;2203;0
WireConnection;2207;0;2209;0
WireConnection;1687;1;1685;0
WireConnection;1687;2;1686;2
WireConnection;3008;0;1687;0
WireConnection;2204;0;2207;0
WireConnection;2204;1;2198;0
WireConnection;1683;0;2709;0
WireConnection;2176;0;2117;0
WireConnection;3007;0;1687;0
WireConnection;3007;1;3008;0
WireConnection;2168;0;2176;0
WireConnection;2168;2;2204;0
WireConnection;2057;0;2058;0
WireConnection;2057;1;1688;0
WireConnection;2057;2;3007;0
WireConnection;2121;0;2168;0
WireConnection;2132;0;2057;0
WireConnection;2132;2;2121;0
WireConnection;2452;0;2451;0
WireConnection;2401;1;2402;0
WireConnection;2401;2;2375;0
WireConnection;2401;3;2132;0
WireConnection;2454;0;2452;0
WireConnection;1901;0;2401;0
WireConnection;1284;0;1275;2
WireConnection;2259;0;1901;0
WireConnection;2488;0;2454;0
WireConnection;2258;0;1901;0
WireConnection;2258;1;2259;0
WireConnection;1280;0;1207;3
WireConnection;1280;1;1285;0
WireConnection;1279;0;1206;3
WireConnection;1279;1;1285;0
WireConnection;1281;0;1208;3
WireConnection;1281;1;1285;0
WireConnection;1283;0;1208;1
WireConnection;1283;1;1208;2
WireConnection;1283;2;1281;0
WireConnection;1283;3;1208;4
WireConnection;2470;0;2469;0
WireConnection;1243;0;1242;0
WireConnection;1243;1;1244;0
WireConnection;80;0;2258;0
WireConnection;1282;0;1207;1
WireConnection;1282;1;1207;2
WireConnection;1282;2;1280;0
WireConnection;1282;3;1207;4
WireConnection;1278;0;1206;1
WireConnection;1278;1;1206;2
WireConnection;1278;2;1279;0
WireConnection;1278;3;1206;4
WireConnection;2471;0;2470;2
WireConnection;2409;0;2990;0
WireConnection;1199;0;1278;0
WireConnection;1199;1;1205;0
WireConnection;1199;2;1202;0
WireConnection;1199;3;1203;0
WireConnection;1199;4;1228;0
WireConnection;1199;5;1243;0
WireConnection;1200;0;1282;0
WireConnection;1200;1;1205;0
WireConnection;1200;2;1202;0
WireConnection;1200;3;1203;0
WireConnection;1200;4;1228;0
WireConnection;1200;5;1243;0
WireConnection;1201;0;1283;0
WireConnection;1201;1;1205;0
WireConnection;1201;2;1202;0
WireConnection;1201;3;1203;0
WireConnection;1201;4;1228;0
WireConnection;1201;5;1243;0
WireConnection;2472;0;2409;0
WireConnection;2472;1;2471;0
WireConnection;1211;0;1199;0
WireConnection;1211;1;1200;0
WireConnection;1211;2;1201;0
WireConnection;1897;0;1898;0
WireConnection;1000;0;998;1
WireConnection;1000;1;998;2
WireConnection;1259;0;1211;0
WireConnection;625;0;2375;83
WireConnection;1915;0;1897;0
WireConnection;2473;0;2472;0
WireConnection;1885;0;1886;1
WireConnection;1885;1;1886;3
WireConnection;1887;0;416;0
WireConnection;2372;19;1915;0
WireConnection;1635;0;2409;0
WireConnection;1635;1;1633;0
WireConnection;1636;0;1631;0
WireConnection;2389;1;2388;0
WireConnection;2389;3;1259;0
WireConnection;999;0;1000;0
WireConnection;999;1;1885;0
WireConnection;1001;0;998;3
WireConnection;1001;1;998;4
WireConnection;2474;0;2473;0
WireConnection;1276;0;2389;0
WireConnection;1276;1;1275;2
WireConnection;2030;0;2372;0
WireConnection;415;0;1887;0
WireConnection;2567;0;2176;0
WireConnection;2644;0;626;0
WireConnection;1003;0;999;0
WireConnection;1003;1;1001;0
WireConnection;2296;0;2372;377
WireConnection;2296;1;2372;378
WireConnection;2296;2;2372;379
WireConnection;2296;3;2372;380
WireConnection;1640;0;1635;0
WireConnection;1640;1;1636;0
WireConnection;2475;0;2474;0
WireConnection;1644;0;1640;0
WireConnection;2562;0;2567;0
WireConnection;2293;0;2296;0
WireConnection;412;0;1003;0
WireConnection;412;2;2644;0
WireConnection;412;1;415;0
WireConnection;2476;0;2475;0
WireConnection;2476;1;2489;0
WireConnection;2569;0;1276;0
WireConnection;746;0;1003;0
WireConnection;746;2;743;0
WireConnection;746;1;415;0
WireConnection;2254;0;1627;0
WireConnection;2007;0;2031;0
WireConnection;2007;2;2282;0
WireConnection;2477;0;2476;0
WireConnection;747;0;746;0
WireConnection;747;1;438;0
WireConnection;1649;0;1644;0
WireConnection;2560;0;2562;0
WireConnection;2892;0;2894;0
WireConnection;2294;0;2293;0
WireConnection;411;0;412;0
WireConnection;411;1;438;0
WireConnection;2056;0;2007;0
WireConnection;928;0;411;0
WireConnection;928;1;747;0
WireConnection;2295;0;2294;0
WireConnection;2541;0;2570;0
WireConnection;1652;0;2477;0
WireConnection;2895;0;2892;0
WireConnection;2253;0;1627;0
WireConnection;2253;1;2254;0
WireConnection;2487;0;1649;0
WireConnection;2943;0;2739;0
WireConnection;1889;0;928;0
WireConnection;2930;0;2895;0
WireConnection;2554;0;2541;1
WireConnection;2554;1;2568;0
WireConnection;2928;0;2895;0
WireConnection;1984;0;1985;0
WireConnection;2408;35;1626;0
WireConnection;2408;37;2253;0
WireConnection;2526;0;2506;0
WireConnection;1987;0;1978;1
WireConnection;1987;1;1983;0
WireConnection;1987;2;2056;0
WireConnection;2510;0;1827;0
WireConnection;2510;1;2526;0
WireConnection;1988;0;1987;0
WireConnection;1988;1;1984;0
WireConnection;1988;2;2297;0
WireConnection;1864;0;1863;0
WireConnection;2932;0;2930;0
WireConnection;2931;0;2895;0
WireConnection;2735;0;2736;2
WireConnection;2735;1;2943;1
WireConnection;1673;0;2408;38
WireConnection;2542;0;2554;0
WireConnection;2929;0;2928;0
WireConnection;2927;0;2932;0
WireConnection;2927;1;2931;0
WireConnection;2927;2;2929;0
WireConnection;2944;0;2735;0
WireConnection;2944;1;2945;0
WireConnection;1851;0;1850;1
WireConnection;1851;1;1850;3
WireConnection;2040;0;87;0
WireConnection;1858;2;1859;0
WireConnection;1883;0;1890;0
WireConnection;1989;0;1988;0
WireConnection;2511;0;2510;0
WireConnection;2514;0;2526;0
WireConnection;2587;0;2542;0
WireConnection;1865;0;1864;0
WireConnection;1852;0;1858;0
WireConnection;1852;1;1854;0
WireConnection;2793;0;2944;0
WireConnection;2793;1;2927;0
WireConnection;389;0;2040;0
WireConnection;389;1;1851;0
WireConnection;389;2;1697;0
WireConnection;2512;1;2514;0
WireConnection;2512;2;2511;0
WireConnection;1894;0;1883;0
WireConnection;2874;0;1865;0
WireConnection;1646;0;2408;38
WireConnection;2539;73;1637;0
WireConnection;344;0;346;0
WireConnection;2864;0;2793;0
WireConnection;2864;1;2857;0
WireConnection;2691;0;2588;0
WireConnection;1877;0;631;0
WireConnection;1877;1;344;0
WireConnection;2041;0;389;0
WireConnection;2041;1;2040;1
WireConnection;1641;0;1638;0
WireConnection;1825;0;2512;0
WireConnection;1857;0;1894;0
WireConnection;1857;1;1852;0
WireConnection;2284;0;1646;0
WireConnection;2284;1;2290;0
WireConnection;1645;0;2539;0
WireConnection;2798;0;2875;0
WireConnection;2957;0;1645;0
WireConnection;2957;1;1641;0
WireConnection;2957;2;1643;0
WireConnection;1672;0;2284;0
WireConnection;2621;0;1825;0
WireConnection;2621;1;2691;0
WireConnection;2808;0;2864;0
WireConnection;2808;1;2854;0
WireConnection;924;0;2041;0
WireConnection;924;1;1877;0
WireConnection;924;2;1857;0
WireConnection;2794;0;2808;0
WireConnection;2797;0;2798;0
WireConnection;340;0;87;0
WireConnection;340;1;924;0
WireConnection;2693;0;2621;0
WireConnection;2993;0;2957;0
WireConnection;372;0;340;0
WireConnection;2796;0;2794;0
WireConnection;2796;1;2797;0
WireConnection;2996;0;2993;0
WireConnection;2996;1;2989;0
WireConnection;2995;0;2993;0
WireConnection;2995;1;2994;0
WireConnection;2692;0;2693;0
WireConnection;2997;0;2995;0
WireConnection;1823;0;372;1
WireConnection;1823;1;2692;0
WireConnection;2863;0;2864;0
WireConnection;2904;0;2796;0
WireConnection;2904;1;2902;0
WireConnection;2998;0;2996;0
WireConnection;2998;1;2994;0
WireConnection;2543;0;2587;0
WireConnection;2862;0;2854;0
WireConnection;2415;0;2377;0
WireConnection;2415;1;2414;0
WireConnection;2418;0;2378;0
WireConnection;2961;0;2996;0
WireConnection;2961;1;2998;0
WireConnection;2961;2;2997;0
WireConnection;2836;0;2863;0
WireConnection;2836;1;2862;0
WireConnection;2417;0;2416;0
WireConnection;2417;1;2379;0
WireConnection;2417;2;2415;0
WireConnection;2417;3;2378;0
WireConnection;2884;0;2890;0
WireConnection;2884;3;2904;0
WireConnection;2544;0;2543;0
WireConnection;2544;1;2571;0
WireConnection;1942;0;43;0
WireConnection;1942;1;43;4
WireConnection;2522;0;1823;0
WireConnection;1846;0;1891;0
WireConnection;1950;0;1948;0
WireConnection;1950;1;1948;4
WireConnection;2963;0;2961;0
WireConnection;2963;1;2964;0
WireConnection;2837;0;2836;0
WireConnection;2419;0;2417;0
WireConnection;2419;1;2418;0
WireConnection;2877;0;2884;0
WireConnection;2491;0;1942;0
WireConnection;2491;1;1950;0
WireConnection;2491;2;2544;0
WireConnection;54;0;2522;0
WireConnection;54;1;55;0
WireConnection;54;2;1846;0
WireConnection;2420;0;2419;0
WireConnection;2839;0;2837;0
WireConnection;2839;1;2797;0
WireConnection;1909;0;54;0
WireConnection;1917;0;2491;0
WireConnection;2965;0;2963;0
WireConnection;2843;0;2839;0
WireConnection;2843;1;2858;0
WireConnection;1707;0;2965;0
WireConnection;1707;1;2038;0
WireConnection;1707;2;2289;0
WireConnection;2956;0;2954;0
WireConnection;2956;1;2955;0
WireConnection;2278;0;1942;0
WireConnection;2278;1;1950;0
WireConnection;2278;2;2281;0
WireConnection;2421;0;2420;0
WireConnection;1658;0;1670;0
WireConnection;1658;1;1655;0
WireConnection;2247;0;2248;0
WireConnection;2247;1;2265;0
WireConnection;2247;2;2267;0
WireConnection;2247;3;2268;0
WireConnection;2898;0;2843;0
WireConnection;2898;1;2902;0
WireConnection;2441;0;2443;0
WireConnection;1212;0;1199;3
WireConnection;1212;1;1200;3
WireConnection;1212;2;1201;3
WireConnection;1662;0;1658;0
WireConnection;2279;0;2278;0
WireConnection;2458;0;2456;0
WireConnection;2458;1;2453;0
WireConnection;2458;2;2457;0
WireConnection;2458;3;2455;0
WireConnection;2458;4;2454;0
WireConnection;2953;0;2956;0
WireConnection;1663;0;1707;0
WireConnection;1663;1;1659;0
WireConnection;1213;0;1199;4
WireConnection;1213;1;1200;4
WireConnection;1213;2;1201;4
WireConnection;373;0;1910;0
WireConnection;2459;0;2458;0
WireConnection;2449;0;2447;0
WireConnection;2449;3;2441;0
WireConnection;2449;4;2448;0
WireConnection;2424;0;2569;0
WireConnection;2424;1;2422;0
WireConnection;2251;0;2247;0
WireConnection;1667;0;1663;0
WireConnection;1667;1;1662;0
WireConnection;2970;0;2953;0
WireConnection;2970;1;373;0
WireConnection;2891;0;2890;0
WireConnection;2891;3;2898;0
WireConnection;1210;0;1213;0
WireConnection;1210;1;1212;0
WireConnection;2840;1;2891;0
WireConnection;2260;0;2251;0
WireConnection;1209;0;1210;0
WireConnection;288;0;1933;0
WireConnection;288;1;1947;0
WireConnection;288;2;2879;0
WireConnection;2434;0;2424;0
WireConnection;2434;1;2449;0
WireConnection;2460;0;2459;0
WireConnection;2263;0;2280;0
WireConnection;2263;1;2269;0
WireConnection;1669;0;1667;0
WireConnection;2412;2935;2970;0
WireConnection;2412;86;2032;0
WireConnection;2412;89;1918;0
WireConnection;2412;2409;2372;14
WireConnection;2412;2671;2372;446
WireConnection;2412;2411;2372;15
WireConnection;1260;0;2434;0
WireConnection;2467;0;2460;0
WireConnection;2391;1;2388;0
WireConnection;2391;2;1251;0
WireConnection;2391;3;1209;0
WireConnection;2878;0;2840;0
WireConnection;1911;0;2412;0
WireConnection;2003;0;288;0
WireConnection;2003;1;1990;0
WireConnection;2249;0;2263;0
WireConnection;2249;1;2261;0
WireConnection;2249;2;2260;0
WireConnection;1262;0;2391;0
WireConnection;2711;0;2874;0
WireConnection;2711;1;2880;0
WireConnection;2264;0;2003;0
WireConnection;2230;0;1691;0
WireConnection;2230;1;2249;0
WireConnection;1866;0;2711;0
WireConnection;2842;0;1261;0
WireConnection;2842;1;2881;0
WireConnection;2376;0;2378;0
WireConnection;2376;1;2379;0
WireConnection;2376;2;2377;0
WireConnection;1977;0;1912;0
WireConnection;1977;1;2264;0
WireConnection;1977;2;2230;0
WireConnection;1977;3;2468;0
WireConnection;1197;9;1866;0
WireConnection;1197;13;1977;0
WireConnection;1197;11;2842;0
WireConnection;1197;12;1263;0
WireConnection;1197;14;2376;0
ASEEND*/
//CHKSM=310C3296E818259AC5FCD38AAFBCC59C2F0EA272