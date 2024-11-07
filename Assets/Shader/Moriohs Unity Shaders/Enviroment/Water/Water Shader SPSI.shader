// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Moriohs Shaders/Enviroment Shaders/Water SPSI"
{
	Properties
	{
		[ShaderOptimizerLockButton]_ShaderOptimizerEnabled("PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER", Float) = 0
		[HideInInspector]_NdLfade("NdL fade", Range( 0 , 1)) = 0.75
		[Header(MAIN OPTIONS)]_Color("Color", Color) = (0,0.4078431,0.6901961,1)
		_ColorSecondary("Color Secondary", Color) = (0,1,0.8705882,0.5019608)
		[Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Int) = 0
		[Enum(Off,0,On,1)]_ZWrite("ZWrite", Int) = 0
		_Depth("Opacity Depth", Range( 0 , 0.999)) = 0.999
		_UVTiling("UV Tiling", Float) = 0.5
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
		_EdgeFoamDistance("Edge Foam Distance", Range( 0 , 1)) = 0.5
		_EdgeFoamSpeed("Edge Foam Speed", Float) = 0.025
		_EdgePower("Edge Intensity", Range( 0 , 1)) = 0.75
		_NormalMapdeformation("Normal Map deformation", Range( 0 , 1)) = 0.05
		[Space(25)][Header(EDGE WAVE)][ToggleUI]_ToggleEdgeWave("Toggle Edge Wave", Float) = 0
		_EdgeWaveSharpness("Edge Wave Sharpness", Range( 0 , 1)) = 1
		_EdgeWaveFrequency("Edge Wave Frequency", Float) = 1
		_EdgeWaveSpeed("Edge Wave Speed", Range( 0 , 1)) = 0.25
		[HideInInspector]_UVTiling("UV Tiling", Float) = 0.5
		_EdgeWaveOffset("Edge Wave Offset", Float) = 0.25
		_EdgeWaveVertexOffset("Edge Wave Vertex Offset", Range( 0 , 1)) = 0.2
		[Space(25)][Header(Gerstner Waves _ Vertex Offset _ Tessellation)][ToggleUI]_GerstnerWavesToggle("Gerstner Waves Toggle", Int) = 0
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
		[HideInInspector][NonModifiableTextureData]_NoiseTexSSR("Noise Tex SSR", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
		//[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		//[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}
	
	SubShader
	{
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="False" "IgnoreProjector"="True" "PreviewType"="Plane" }
	LOD 0

		Cull [_Cull]
		AlphaToMask Off
		ZWrite [_ZWrite]
		ZTest Always
		ColorMask RGB
		
		Blend Off
		

		CGINCLUDE
		#pragma target 5.0

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDCG

		GrabPass{ "_GrabTexture" }

		Pass
		{
			
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }
			
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_DISTANCE_TESSELLATION
			#define _ALPHABLEND_ON 1
			#if defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_D3D9)
			#define FRONT_FACE_SEMANTIC VFACE
			#define FRONT_FACE_TYPE float
			#else
			#define FRONT_FACE_SEMANTIC SV_IsFrontFace
			#define FRONT_FACE_TYPE bool
			#endif
			#pragma multi_compile_fwdbase
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#ifndef UNITY_PASS_FORWARDBASE
				#define UNITY_PASS_FORWARDBASE
			#endif
			#include "HLSLSupport.cginc"
			#ifndef UNITY_INSTANCED_LOD_FADE
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#ifndef UNITY_INSTANCED_SH
				#define UNITY_INSTANCED_SH
			#endif
			#ifndef UNITY_INSTANCED_LIGHTMAPSTS
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"

			#include "UnityStandardUtils.cginc"
			#include "UnityStandardBRDF.cginc"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES2
			#pragma shader_feature_local _SSR_ON
			//Vertex Lights
			#pragma multi_compile _ VERTEXLIGHT_ON
			//MSAA artifact fix
			#if defined(SHADER_STAGE_VERTEX) || defined(SHADER_STAGE_FRAGMENT) || defined(SHADER_STAGE_DOMAIN) || defined(SHADER_STAGE_HULL) || defined(SHADER_STAGE_GEOMETRY)
			#if !defined(UNITY_PASS_DEFERRED) //ASEnodel1
			#define TEXCOORD9 TEXCOORD9_Centroid
			#endif //ASEnodel2
			#endif //ASEnodel3
			//SSR defines
			float4 _GrabTexture_TexelSize;
			float4 _NoiseTexSSR_TexelSize;
			#define SSR_ENABLED	defined(_SSR_ON) && !defined(UNITY_PASS_FORWARDADD)

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#if defined(LIGHTMAP_ON) || (!defined(LIGHTMAP_ON) && SHADER_TARGET >= 30)
					float4 lmap : TEXCOORD0;
				#endif
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
					half3 sh : TEXCOORD1;
				#endif
				#if defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS) && UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHTING_COORDS(2,3)
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_SHADOW_COORDS(2)
					#else
						SHADOW_COORDS(2)
					#endif
				#endif
				#ifdef ASE_FOG
					UNITY_FOG_COORDS(4)
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD8;
				#endif
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_texcoord10 : TEXCOORD10;
				float4 ase_lmap : TEXCOORD11;
				float4 ase_sh : TEXCOORD12;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			uniform float _GSAAVariance;
			uniform float _EnableGSAA;
			uniform float _GSAAThreshold;
			uniform float _EdgeFadeSSR;
			uniform int _NormalScaleSecondaryAnimated;
			uniform float _UVTiling;
			uniform sampler2D _NoiseTexSSR;
			uniform int _ZWrite;
			uniform int _NormalScaleAnimated;
			uniform float _ShaderOptimizerEnabled;
			uniform int _Cull;
			uniform int _GerstnerWavesToggle;
			uniform float4 _WaveA;
			uniform sampler2D _VertexOffsetMask;
			uniform float4 _VertexOffsetMask_ST;
			uniform float _GerstnerSpeed;
			uniform float _GerstnerHeight;
			uniform float4 _WaveB;
			uniform float4 _WaveC;
			uniform float _VertOffsetDistMaskTessMaxxthis;
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

	
			//This is a late directive
			
			void SourceDeclaration(  )
			{
				//This Shader was made possible by Moriohs Toon Shader (https://gitlab.com/xMorioh/moriohs-toon-shader)
			}
			
			float2 hash2D2D( float2 s )
			{
				return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453);
			}
			
			float UnityCalcDistanceTessFactor( float4 vertex, float minDist, float maxDist, float tess )
			{
				    float3 wpos = mul(unity_ObjectToWorld,vertex).xyz;
				    float dist = distance (wpos, _WorldSpaceCameraPos);
				    float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
				    return f;
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
			
			float3 InvertDepthDir72_g461( float3 In )
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
			
					float2 voronoihash2546( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2546( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash2546( n + g );
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
			
			float3 InvertDepthDir72_g464( float3 In )
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
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 uv_VertexOffsetMask = v.ase_texcoord.xy * _VertexOffsetMask_ST.xy + _VertexOffsetMask_ST.zw;
				float4 tex2DNode1275 = tex2Dlod( _VertexOffsetMask, float4( uv_VertexOffsetMask, 0, 0.0) );
				float VertexOffsetMask1284 = tex2DNode1275.g;
				float4 appendResult1278 = (float4(_WaveA.x , _WaveA.y , ( _WaveA.z * VertexOffsetMask1284 ) , _WaveA.w));
				float4 wave1199 = appendResult1278;
				float3 p1199 = v.vertex.xyz;
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
				float3 p1200 = v.vertex.xyz;
				float3 tangent1200 = _tangent;
				float3 binormal1200 = _binormal;
				float Speed1200 = _GerstnerSpeed;
				float Height1200 = temp_output_1243_0;
				float3 localGerstnerWave1200 = GerstnerWave( wave1200 , p1200 , tangent1200 , binormal1200 , Speed1200 , Height1200 );
				float4 appendResult1283 = (float4(_WaveC.x , _WaveC.y , ( _WaveC.z * VertexOffsetMask1284 ) , _WaveC.w));
				float4 wave1201 = appendResult1283;
				float3 p1201 = v.vertex.xyz;
				float3 tangent1201 = _tangent;
				float3 binormal1201 = _binormal;
				float Speed1201 = _GerstnerSpeed;
				float Height1201 = temp_output_1243_0;
				float3 localGerstnerWave1201 = GerstnerWave( wave1201 , p1201 , tangent1201 , binormal1201 , Speed1201 , Height1201 );
				float3 GerstnerOffset1259 = ( localGerstnerWave1199 + localGerstnerWave1200 + localGerstnerWave1201 );
				float3 ifLocalVar2389 = 0;
				if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2389 = GerstnerOffset1259;
				float3 GerstnerOffsetWithMask2519 = ( ifLocalVar2389 * tex2DNode1275.g );
				float4 vertex2417 = v.vertex;
				float minDist2417 = _TessMin;
				float maxDist2417 = ( _TessMax * _VertOffsetDistMaskTessMaxxthis );
				float tess2417 = _TessValue;
				float localTessDistance2417 = TessDistance( vertex2417 , minDist2417 , maxDist2417 , tess2417 );
				float TessellationDistance2421 = saturate( (0.0 + (localTessDistance2417 - ( _TessValue / 100.0 )) * (1.0 - 0.0) / (1.0 - ( _TessValue / 100.0 ))) );
				float3 objectToViewPos = UnityObjectToViewPos(v.vertex.xyz);
				float eyeDepth = -objectToViewPos.z;
				float cameraDepthFade2508 = (( eyeDepth -_ProjectionParams.y - 2.0 ) / 1.0);
				float ifLocalVar2512 = 0;
				if( _VertexOffsetCameradistMask == 1.0 )
				ifLocalVar2512 = saturate( cameraDepthFade2508 );
				else if( _VertexOffsetCameradistMask < 1.0 )
				ifLocalVar2512 = 1.0;
				float3 FinalVertexOffset1260 = ( ( GerstnerOffsetWithMask2519 * TessellationDistance2421 ) * ifLocalVar2512 );
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_output_73_0_g461 = ase_screenPosNorm.xy;
				float2 UV22_g462 = float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy;
				float2 localUnStereo22_g462 = UnStereo( UV22_g462 );
				float2 break64_g461 = localUnStereo22_g462;
				float clampDepth76_g461 = SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy, 0, 0 ) );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g461 = ( 1.0 - clampDepth76_g461 );
				#else
				float staticSwitch38_g461 = clampDepth76_g461;
				#endif
				float3 appendResult39_g461 = (float3(break64_g461.x , break64_g461.y , staticSwitch38_g461));
				float4 appendResult42_g461 = (float4((appendResult39_g461*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g461 = mul( unity_CameraInvProjection, appendResult42_g461 );
				float3 In72_g461 = ( (temp_output_43_0_g461).xyz / (temp_output_43_0_g461).w );
				float3 localInvertDepthDir72_g461 = InvertDepthDir72_g461( In72_g461 );
				float4 appendResult49_g461 = (float4(localInvertDepthDir72_g461 , 1.0));
				float mulTime2552 = _Time.y * _EdgeWaveSpeed;
				float temp_output_2553_0 = sin( mulTime2552 );
				float lerpResult2565 = lerp( saturate( -temp_output_2553_0 ) , saturate( temp_output_2553_0 ) , ( ( temp_output_2553_0 * 0.5 ) + 0.5 ));
				float temp_output_2568_0 = ( ( ( ( ase_worldPos.y - mul( unity_CameraToWorld, appendResult49_g461 ).y ) * _EdgeWaveFrequency ) + lerpResult2565 ) + _EdgeWaveOffset );
				float smoothstepResult2579 = smoothstep( ( _EdgeWaveSharpness - 0.25 ) , 1.0 , ( temp_output_2568_0 - 0.25 ));
				float eyeDepth2409 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
				float _depthMaskOpacity1652 = ( 1.0 - saturate( ( ( eyeDepth2409 - eyeDepth ) * ( 1.0 - _Depth ) ) ) );
				float Opacity2548 = ( ( 1.0 - _depthMaskOpacity1652 ) * 16.0 );
				float temp_output_2572_0 = saturate( ( 1.0 - Opacity2548 ) );
				float temp_output_2176_0 = ( distance( ase_worldPos , _WorldSpaceCameraPos ) * 0.005 );
				float LODDistance2533 = saturate( ( 1.0 - temp_output_2176_0 ) );
				float ifLocalVar2587 = 0;
				if( _ToggleEdgeWave == 1.0 )
				ifLocalVar2587 = ( ( ( saturate( smoothstepResult2579 ) * temp_output_2572_0 ) * _EdgeWaveVertexOffset ) * LODDistance2533 );
				float3 appendResult2588 = (float3(0.0 , ifLocalVar2587 , 0.0));
				float3 EdgeWaveVertexOffset2589 = appendResult2588;
				
				float3 normalizeResult1209 = normalize( cross( ( binormal1199 + binormal1200 + binormal1201 ) , ( tangent1199 + tangent1200 + tangent1201 ) ) );
				float3 ifLocalVar2391 = 0;
				if( 1.0 > _GerstnerWavesToggle )
				ifLocalVar2391 = v.normal;
				else if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2391 = normalizeResult1209;
				float3 FinalVertexNormals1262 = ifLocalVar2391;
				
				o.ase_texcoord9.x = eyeDepth;
				#ifdef DYNAMICLIGHTMAP_ON //dynlm
				o.ase_lmap.zw = v.texcoord2.xyzw.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif //dynlm
				#ifdef LIGHTMAP_ON //stalm
				o.ase_lmap.xy = v.texcoord1.xyzw.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif //stalm
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.normal);
				#ifndef LIGHTMAP_ON //nstalm
				#if UNITY_SHOULD_SAMPLE_SH //sh
				o.ase_sh.xyz = 0;
				#ifdef VERTEXLIGHT_ON //vl
				o.ase_sh.xyz += Shade4PointLights (
				unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, ase_worldPos, ase_worldNormal);
				#endif //vl
				o.ase_sh.xyz = ShadeSHPerVertex (ase_worldNormal, o.ase_sh.xyz);
				#endif //sh
				#endif //nstalm
				
				o.ase_texcoord9.yz = v.ase_texcoord.xy;
				o.ase_texcoord10 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.w = 0;
				o.ase_sh.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( FinalVertexOffset1260 + EdgeWaveVertexOffset2589 );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = FinalVertexNormals1262;
				v.tangent = v.tangent;

				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				#ifdef DYNAMICLIGHTMAP_ON
				o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				#ifdef LIGHTMAP_ON
				o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				#ifndef LIGHTMAP_ON
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						o.sh = 0;
						#ifdef VERTEXLIGHT_ON
						o.sh += Shade4PointLights (
							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							unity_4LightAtten0, worldPos, worldNormal);
						#endif
						o.sh = ShadeSHPerVertex (worldNormal, o.sh);
					#endif
				#endif

				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
					#else
						TRANSFER_SHADOW(o);
					#endif
				#endif

				#ifdef ASE_FOG
					UNITY_TRANSFER_FOG(o,o.pos);
				#endif
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(o.pos);
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( appdata v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.tangent = v.tangent;
				o.normal = v.normal;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				appdata o = (appdata) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
				o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			#endif
			
			fixed4 frag (v2f IN , FRONT_FACE_TYPE ase_vface : FRONT_FACE_SEMANTIC
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				) : SV_Target 
			{
				UNITY_SETUP_INSTANCE_ID(IN);

				#ifdef LOD_FADE_CROSSFADE
					UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				#endif

				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif
				float3 WorldTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldNormal = float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z);
				float3 worldPos = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				#else
					half atten = 1;
				#endif
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				float3 temp_cast_0 = (0.0).xxx;
				
				sampler2D tex96_g451 = _Normal;
				float mulTime7_g451 = _Time.y * _ScrollSpeed;
				float temp_output_68_0_g451 = _UVTiling;
				float2 appendResult101_g451 = (float2(worldPos.x , worldPos.z));
				float2 temp_output_103_0_g451 = ( ( _Normal_ST.xy * temp_output_68_0_g451 * appendResult101_g451 ) + _Normal_ST.zw );
				float2 panner17_g451 = ( mulTime7_g451 * _VectorXY + temp_output_103_0_g451);
				float2 UV96_g451 = ( panner17_g451 + 0.25 );
				float _NormalScale96_g451 = _NormalScale;
				float3 localtex2DStochasticNormals96_g451 = tex2DStochasticNormals( tex96_g451 , UV96_g451 , _NormalScale96_g451 );
				sampler2D tex79_g451 = _Normal;
				float mulTime4_g451 = _Time.y * _ScrollSpeed;
				float temp_output_9_0_g451 = ( mulTime4_g451 * 2.179 );
				float2 panner12_g451 = ( temp_output_9_0_g451 * _VectorXY + ( 1.0 - temp_output_103_0_g451 ));
				float2 UV79_g451 = ( 1.0 - panner12_g451 );
				float _NormalScale79_g451 = _NormalScale;
				float3 localtex2DStochasticNormals79_g451 = tex2DStochasticNormals( tex79_g451 , UV79_g451 , _NormalScale79_g451 );
				sampler2D tex76_g451 = _SecondaryNormal;
				float mulTime16_g451 = _Time.y * _SecondaryScrollSpeed;
				float2 panner21_g451 = ( mulTime16_g451 * _SecondaryVectorXY + ( ( _SecondaryNormal_ST.xy * temp_output_68_0_g451 * appendResult101_g451 ) + _SecondaryNormal_ST.zw ));
				float2 UV76_g451 = panner21_g451;
				float _NormalScale76_g451 = _NormalScaleSecondary;
				float3 localtex2DStochasticNormals76_g451 = tex2DStochasticNormals( tex76_g451 , UV76_g451 , _NormalScale76_g451 );
				sampler3D tex2057 = _Normals_3D;
				float temp_output_2023_0 = ( _UVTiling * 0.25 );
				float2 break2605 = _Normals_3D_ST.xy;
				float _Time1684 = temp_output_9_0_g451;
				float3 appendResult1682 = (float3(( worldPos.x * temp_output_2023_0 * break2605.x ) , ( worldPos.z * temp_output_2023_0 * break2605.y ) , ( _Time1684 * 4.0 )));
				float3 _3duvs1683 = appendResult1682;
				float3 UV2057 = _3duvs1683;
				float lerpResult1687 = lerp( 0.0 , _3DNormalScale , WorldNormal.y);
				float Normalscale2057 = lerpResult1687;
				float3 localtex3DStochasticNormals2057 = tex3DStochasticNormals( tex2057 , UV2057 , Normalscale2057 );
				float temp_output_2176_0 = ( distance( worldPos , _WorldSpaceCameraPos ) * 0.005 );
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 ase_tanViewDir =  tanToWorld0 * worldViewDir.x + tanToWorld1 * worldViewDir.y  + tanToWorld2 * worldViewDir.z;
				ase_tanViewDir = Unity_SafeNormalize( ase_tanViewDir );
				float switchResult2209 = (((ase_vface>0)?(ase_tanViewDir.z):(-ase_tanViewDir.z)));
				float lerpResult2168 = lerp( temp_output_2176_0 , 1.0 , ( ( 1.0 - switchResult2209 ) * ( 1.0 - _3DNormalLod ) ));
				float3 lerpResult2132 = lerp( localtex3DStochasticNormals2057 , float3( 0,0,1 ) , saturate( lerpResult2168 ));
				float3 ifLocalVar2401 = 0;
				if( 1.0 > _3DNormals )
				ifLocalVar2401 = BlendNormals( BlendNormals( localtex2DStochasticNormals96_g451 , localtex2DStochasticNormals79_g451 ) , localtex2DStochasticNormals76_g451 );
				else if( 1.0 == _3DNormals )
				ifLocalVar2401 = lerpResult2132;
				float3 normalizeResult1901 = normalize( ifLocalVar2401 );
				float3 switchResult2258 = (((ase_vface>0)?(normalizeResult1901):(-normalizeResult1901)));
				float3 Normals80 = switchResult2258;
				float3 tanNormal1897 = Normals80;
				float3 worldNormal1897 = float3(dot(tanToWorld0,tanNormal1897), dot(tanToWorld1,tanNormal1897), dot(tanToWorld2,tanNormal1897));
				float3 WorldNormal1915 = worldNormal1897;
				float3 WorldNormals305_g466 = WorldNormal1915;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(worldPos);
				float dotResult2930_g466 = dot( WorldNormals305_g466 , worldSpaceLightDir );
				float NdLGGX2357_g466 = saturate( dotResult2930_g466 );
				float temp_output_2418_0_g466 = max( 0.0 , NdLGGX2357_g466 );
				float NdotL2412_g466 = temp_output_2418_0_g466;
				float3 viewDir443_g453 = worldViewDir;
				float3 WorldNormals20_g453 = WorldNormal1915;
				float3 normal443_g453 = WorldNormals20_g453;
				float localCorrectNegativeNdotV443_g453 = CorrectNegativeNdotV( viewDir443_g453 , normal443_g453 );
				float CorrectedNdotV2507_g466 = localCorrectNegativeNdotV443_g453;
				float NdotV2412_g466 = CorrectedNdotV2507_g466;
				float3 worldNormal2910_g466 = WorldNormals305_g466;
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth2409 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float eyeDepth = IN.ase_texcoord9.x;
				float _depthMaskOpacity1652 = ( 1.0 - saturate( ( ( eyeDepth2409 - eyeDepth ) * ( 1.0 - _Depth ) ) ) );
				float Opacity2548 = ( ( 1.0 - _depthMaskOpacity1652 ) * 16.0 );
				float2 temp_output_73_0_g461 = ase_screenPosNorm.xy;
				float2 UV22_g462 = float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy;
				float2 localUnStereo22_g462 = UnStereo( UV22_g462 );
				float2 break64_g461 = localUnStereo22_g462;
				float clampDepth76_g461 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g461 = ( 1.0 - clampDepth76_g461 );
				#else
				float staticSwitch38_g461 = clampDepth76_g461;
				#endif
				float3 appendResult39_g461 = (float3(break64_g461.x , break64_g461.y , staticSwitch38_g461));
				float4 appendResult42_g461 = (float4((appendResult39_g461*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g461 = mul( unity_CameraInvProjection, appendResult42_g461 );
				float3 In72_g461 = ( (temp_output_43_0_g461).xyz / (temp_output_43_0_g461).w );
				float3 localInvertDepthDir72_g461 = InvertDepthDir72_g461( In72_g461 );
				float4 appendResult49_g461 = (float4(localInvertDepthDir72_g461 , 1.0));
				float mulTime2552 = _Time.y * _EdgeWaveSpeed;
				float temp_output_2553_0 = sin( mulTime2552 );
				float lerpResult2565 = lerp( saturate( -temp_output_2553_0 ) , saturate( temp_output_2553_0 ) , ( ( temp_output_2553_0 * 0.5 ) + 0.5 ));
				float temp_output_2568_0 = ( ( ( ( worldPos.y - mul( unity_CameraToWorld, appendResult49_g461 ).y ) * _EdgeWaveFrequency ) + lerpResult2565 ) + _EdgeWaveOffset );
				float smoothstepResult2570 = smoothstep( _EdgeWaveSharpness , 1.0 , temp_output_2568_0);
				float temp_output_2572_0 = saturate( ( 1.0 - Opacity2548 ) );
				float LODDistance2533 = saturate( ( 1.0 - temp_output_2176_0 ) );
				float ifLocalVar2580 = 0;
				if( _ToggleEdgeWave == 1.0 )
				ifLocalVar2580 = ( ( saturate( smoothstepResult2570 ) * temp_output_2572_0 ) * LODDistance2533 );
				float EdgeWave2581 = ifLocalVar2580;
				sampler2D tex340 = _SeaFoam;
				float2 appendResult1851 = (float2(worldPos.x , worldPos.z));
				float2 NormalVector625 = _VectorXY;
				float mulTime344 = _Time.y * _EdgeFoamSpeed;
				float mulTime415 = _Time.y * ( 1.5 * 10.0 );
				float4 _NoiseScaleOffset = float4(7.5,1.5,0,0);
				float2 appendResult1000 = (float2(_NoiseScaleOffset.x , _NoiseScaleOffset.y));
				float2 appendResult1885 = (float2(worldPos.x , worldPos.z));
				float2 appendResult1001 = (float2(_NoiseScaleOffset.z , _NoiseScaleOffset.w));
				float2 temp_output_1003_0 = ( ( appendResult1000 * appendResult1885 ) + appendResult1001 );
				float2 panner412 = ( mulTime415 * -NormalVector625 + temp_output_1003_0);
				float simpleNoise411 = SimpleNoise( panner412*0.01 );
				float2 panner746 = ( mulTime415 * NormalVector625 + temp_output_1003_0);
				float simpleNoise747 = SimpleNoise( panner746*0.01 );
				float Noise2496 = ( simpleNoise411 + simpleNoise747 );
				float3 appendResult1858 = (float3(0.0 , 0.0 , _NormalMapdeformation));
				float dotResult1852 = dot( appendResult1858 , Normals80 );
				float2 UV340 = ( ( ( _SeaFoam_ST.xy * appendResult1851 * _UVTiling ) + _SeaFoam_ST.zw ) + ( NormalVector625 * mulTime344 ) + ( ( saturate( Noise2496 ) * 0.25 ) + dotResult1852 ) );
				float4 localtex2DStochastic340 = tex2DStochastic( tex340 , UV340 );
				float temp_output_2486_0 = ( 1.0 - _EdgeFoamDistance );
				float lerpResult2490 = lerp( 0.0 , exp( temp_output_2486_0 ) , saturate( ( _depthMaskOpacity1652 - temp_output_2486_0 ) ));
				float2 uv_VertexOffsetMask = IN.ase_texcoord9.yz * _VertexOffsetMask_ST.xy + _VertexOffsetMask_ST.zw;
				float4 tex2DNode1275 = tex2D( _VertexOffsetMask, uv_VertexOffsetMask );
				float VertexOffsetMask1284 = tex2DNode1275.g;
				float4 appendResult1278 = (float4(_WaveA.x , _WaveA.y , ( _WaveA.z * VertexOffsetMask1284 ) , _WaveA.w));
				float4 wave1199 = appendResult1278;
				float3 p1199 = IN.ase_texcoord10.xyz;
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
				float3 p1200 = IN.ase_texcoord10.xyz;
				float3 tangent1200 = _tangent;
				float3 binormal1200 = _binormal;
				float Speed1200 = _GerstnerSpeed;
				float Height1200 = temp_output_1243_0;
				float3 localGerstnerWave1200 = GerstnerWave( wave1200 , p1200 , tangent1200 , binormal1200 , Speed1200 , Height1200 );
				float4 appendResult1283 = (float4(_WaveC.x , _WaveC.y , ( _WaveC.z * VertexOffsetMask1284 ) , _WaveC.w));
				float4 wave1201 = appendResult1283;
				float3 p1201 = IN.ase_texcoord10.xyz;
				float3 tangent1201 = _tangent;
				float3 binormal1201 = _binormal;
				float Speed1201 = _GerstnerSpeed;
				float Height1201 = temp_output_1243_0;
				float3 localGerstnerWave1201 = GerstnerWave( wave1201 , p1201 , tangent1201 , binormal1201 , Speed1201 , Height1201 );
				float3 GerstnerOffset1259 = ( localGerstnerWave1199 + localGerstnerWave1200 + localGerstnerWave1201 );
				float3 ifLocalVar2389 = 0;
				if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2389 = GerstnerOffset1259;
				float3 GerstnerOffsetWithMask2519 = ( ifLocalVar2389 * tex2DNode1275.g );
				float clampResult2524 = clamp( ( GerstnerOffsetWithMask2519.y * LODDistance2533 ) , -2.0 , 2.0 );
				float VertexOffsetForEffects2525 = clampResult2524;
				float EdgeFoam1909 = ( saturate( ( localtex2DStochastic340.y - ( ( 1.0 - lerpResult2490 ) - saturate( VertexOffsetForEffects2525 ) ) ) ) * _EdgePower * saturate( Noise2496 ) );
				float Smoothness300_g466 = ( min( saturate( ( Opacity2548 + EdgeWave2581 ) ) , ( 1.0 - EdgeFoam1909 ) ) * _Smoothness );
				float smoothness2910_g466 = Smoothness300_g466;
				float localGSAA_Filament2910_g466 = GSAA_Filament( worldNormal2910_g466 , smoothness2910_g466 );
				float SmoothnessTex290_g466 = localGSAA_Filament2910_g466;
				float perceptualRoughness2761_g466 = ( 1.0 - SmoothnessTex290_g466 );
				float roughness2729_g466 = max( ( perceptualRoughness2761_g466 * perceptualRoughness2761_g466 ) , 0.002 );
				float roughness2412_g466 = roughness2729_g466;
				float localgetSmithJointGGXVisibilityTerm2412_g466 = getSmithJointGGXVisibilityTerm( NdotL2412_g466 , NdotV2412_g466 , roughness2412_g466 );
				float GGXVisibilityTerm2305_g466 = localgetSmithJointGGXVisibilityTerm2412_g466;
				float3 normalizeResult464_g453 = ASESafeNormalize( ( worldViewDir + worldSpaceLightDir ) );
				float3 HalfVectorUnityNormalized457_g453 = normalizeResult464_g453;
				float dotResult42_g453 = dot( WorldNormals20_g453 , HalfVectorUnityNormalized457_g453 );
				float NdotH2416_g466 = max( 0.0 , dotResult42_g453 );
				float roughness2416_g466 = roughness2729_g466;
				float localgetGGXTerm2416_g466 = getGGXTerm( NdotH2416_g466 , roughness2416_g466 );
				float GGXTerm2305_g466 = localgetGGXTerm2416_g466;
				float NdotL2305_g466 = temp_output_2418_0_g466;
				float dotResult50_g453 = dot( worldSpaceLightDir , HalfVectorUnityNormalized457_g453 );
				float LdotH2305_g466 = max( 0.0 , dotResult50_g453 );
				float roughness2305_g466 = roughness2729_g466;
				float4 temp_output_1942_0 = ( _Color * _Color.a );
				float4 temp_output_1950_0 = ( _ColorSecondary * _ColorSecondary.a );
				float4 lerpResult1939 = lerp( temp_output_1942_0 , temp_output_1950_0 , ( ( VertexOffsetForEffects2525 * 0.1 ) + _depthMaskOpacity1652 ));
				float4 Color1917 = lerpResult1939;
				float3 MainTex312_g466 = Color1917.rgb;
				float MetallicTex289_g466 = 0.0;
				half3 specColor2324_g466 = (0).xxx;
				half oneMinusReflectivity2324_g466 = 0;
				half3 diffuseAndSpecularFromMetallic2324_g466 = DiffuseAndSpecularFromMetallic(MainTex312_g466,MetallicTex289_g466,specColor2324_g466,oneMinusReflectivity2324_g466);
				float3 SpecColor2715_g466 = specColor2324_g466;
				float3 specColor2305_g466 = SpecColor2715_g466;
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float AttenGGX2831_g466 = float4(atten,0,0,0);
				float3 lightcolor2305_g466 = ( ase_lightColor.rgb * AttenGGX2831_g466 );
				float SpecularHighlightToggle2498_g466 = _CubemapSpecularToggle;
				float specularTermToggle2305_g466 = SpecularHighlightToggle2498_g466;
				float3 localcalcSpecularTerm2305_g466 = calcSpecularTerm( GGXVisibilityTerm2305_g466 , GGXTerm2305_g466 , NdotL2305_g466 , LdotH2305_g466 , roughness2305_g466 , specColor2305_g466 , lightcolor2305_g466 , specularTermToggle2305_g466 );
				float3 specularTerm2404_g466 = localcalcSpecularTerm2305_g466;
				float NdotV2404_g466 = CorrectedNdotV2507_g466;
				float3 specColor2404_g466 = SpecColor2715_g466;
				float roughness2404_g466 = roughness2729_g466;
				float OneMinusReflectivity2718_g466 = oneMinusReflectivity2324_g466;
				float oneMinusReflectivity2404_g466 = OneMinusReflectivity2718_g466;
				float AO2783_g466 = _BRDFAmbientOcclusion;
				UnityGIInput data;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data );
				data.worldPos = worldPos;
				data.worldViewDir = worldViewDir;
				data.probeHDR[0] = unity_SpecCube0_HDR;
				data.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION //specdataif0
				data.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif //specdataif0
				#if UNITY_SPECCUBE_BOX_PROJECTION //specdataif1
				data.boxMax[0] = unity_SpecCube0_BoxMax;
				data.probePosition[0] = unity_SpecCube0_ProbePosition;
				data.boxMax[1] = unity_SpecCube1_BoxMax;
				data.boxMin[1] = unity_SpecCube1_BoxMin;
				data.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif //specdataif1
				Unity_GlossyEnvironmentData g2316_g466 = UnityGlossyEnvironmentSetup( SmoothnessTex290_g466, worldViewDir, WorldNormals305_g466, float3(0,0,0));
				float3 indirectSpecular2316_g466 = UnityGI_IndirectSpecular( data, AO2783_g466, WorldNormals305_g466, g2316_g466 );
				float3 indirectspecular2404_g466 = indirectSpecular2316_g466;
				float smoothness2404_g466 = SmoothnessTex290_g466;
				float perceptualRoughness2404_g466 = perceptualRoughness2761_g466;
				float3 localcalcSpecularBase2404_g466 = calcSpecularBase( specularTerm2404_g466 , NdotV2404_g466 , specColor2404_g466 , roughness2404_g466 , oneMinusReflectivity2404_g466 , indirectspecular2404_g466 , smoothness2404_g466 , perceptualRoughness2404_g466 );
				float3 SpecularReflections316_g466 = localcalcSpecularBase2404_g466;
				float Intensity285_g466 = _BRDFIntensity;
				float3 BRDF1911 = ( SpecularReflections316_g466 * Intensity285_g466 );
				float dotResult3_g453 = dot( WorldNormals20_g453 , worldSpaceLightDir );
				float NdL2030 = dotResult3_g453;
				float lerpResult2007 = lerp( NdL2030 , 1.0 , _NdLfade);
				float3 tanNormal1984 = Normals80;
				UnityGIInput data1984;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data1984 );
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm1984
				data1984.lightmapUV = IN.ase_lmap;
				#endif //dylm1984
				#if UNITY_SHOULD_SAMPLE_SH //fsh1984
				data1984.ambient = IN.ase_sh;
				#endif //fsh1984
				UnityGI gi1984 = UnityGI_Base(data1984, 1, float3(dot(tanToWorld0,tanNormal1984), dot(tanToWorld1,tanNormal1984), dot(tanToWorld2,tanNormal1984)));
				float3 localLightColorZero304_g453 = LightColorZero();
				float4 localFourLightAtten305_g453 = FourLightAtten();
				float4 localFourLightPosX340_g453 = FourLightPosX();
				float4 temp_cast_7 = (worldPos.x).xxxx;
				float4 FourLightPosX0WorldPos286_g453 = ( localFourLightPosX340_g453 - temp_cast_7 );
				float4 localFourLightPosY342_g453 = FourLightPosY();
				float4 temp_cast_8 = (worldPos.y).xxxx;
				float4 FourLightPosY0WorldPos291_g453 = ( localFourLightPosY342_g453 - temp_cast_8 );
				float4 localFourLightPosZ296_g453 = FourLightPosZ();
				float4 temp_cast_9 = (worldPos.z).xxxx;
				float4 FourLightPosZ0WorldPos325_g453 = ( localFourLightPosZ296_g453 - temp_cast_9 );
				float4 temp_cast_10 = (1E-06).xxxx;
				float4 temp_output_328_0_g453 = max( ( ( FourLightPosX0WorldPos286_g453 * FourLightPosX0WorldPos286_g453 ) + ( FourLightPosY0WorldPos291_g453 * FourLightPosY0WorldPos291_g453 ) + ( FourLightPosZ0WorldPos325_g453 * FourLightPosZ0WorldPos325_g453 ) ) , temp_cast_10 );
				float4 temp_output_272_0_g453 = ( localFourLightAtten305_g453 * temp_output_328_0_g453 );
				float4 temp_cast_11 = (1E-06).xxxx;
				float4 temp_output_343_0_g453 = saturate( ( 1.0 - ( temp_output_272_0_g453 / 25.0 ) ) );
				float4 temp_output_320_0_g453 = min( ( 1.0 / ( 1.0 + temp_output_272_0_g453 ) ) , ( temp_output_343_0_g453 * temp_output_343_0_g453 ) );
				float4 temp_cast_12 = (1E-06).xxxx;
				float3 break295_g453 = WorldNormals20_g453;
				float4 temp_output_366_0_g453 = ( rsqrt( temp_output_328_0_g453 ) * ( ( FourLightPosX0WorldPos286_g453 * break295_g453.x ) + ( FourLightPosY0WorldPos291_g453 * break295_g453.y ) + ( FourLightPosZ0WorldPos325_g453 * break295_g453.z ) ) );
				float4 temp_cast_13 = (1.0).xxxx;
				float4 lerpResult481_g453 = lerp( max( float4( 0,0,0,0 ) , temp_output_366_0_g453 ) , temp_cast_13 , _NdLfade);
				float4 temp_output_368_0_g453 = ( temp_output_320_0_g453 * lerpResult481_g453 );
				float4 break337_g453 = temp_output_368_0_g453;
				float3 localLightColorZOne303_g453 = LightColorZOne();
				float3 localLightColorZTwo302_g453 = LightColorZTwo();
				float3 localLightColorZThree301_g453 = LightColorZThree();
				#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch2293 = ( ( localLightColorZero304_g453 * break337_g453.x ) + ( localLightColorZOne303_g453 * break337_g453.y ) + ( localLightColorZTwo302_g453 * break337_g453.z ) + ( localLightColorZThree301_g453 * break337_g453.w ) );
				#else
				float3 staticSwitch2293 = float3( 0,0,0 );
				#endif
				#ifdef VERTEXLIGHT_ON
				float3 staticSwitch2294 = staticSwitch2293;
				#else
				float3 staticSwitch2294 = float3( 0,0,0 );
				#endif
				float3 DiffuseVertexLighting2295 = staticSwitch2294;
				float3 FinalLight1989 = ( ( ase_lightColor.rgb * saturate( lerpResult2007 ) ) + gi1984.indirect.diffuse + DiffuseVertexLighting2295 );
				float4 switchResult2264 = (((ase_vface>0)?(( ( Color1917 + EdgeFoam1909 + EdgeWave2581 ) * float4( FinalLight1989 , 0.0 ) )):(float4( 0,0,0,0 ))));
				float time2546 = ( _Time1684 * 10.0 );
				float2 voronoiSmoothId2546 = 0;
				float switchResult2253 = (((ase_vface>0)?(_GrabPassDistortion):(( _GrabPassDistortion * 10.0 ))));
				float eyeDepth28_g463 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float2 temp_output_20_0_g463 = ( (Normals80).xy * ( switchResult2253 / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g463 - eyeDepth ) ) );
				float4 temp_output_7_0_g463 = ( float4( temp_output_20_0_g463, 0.0 , 0.0 ) + ase_screenPosNorm );
				float eyeDepth2_g463 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, temp_output_7_0_g463.xy ));
				float2 temp_output_32_0_g463 = (( float4( ( temp_output_20_0_g463 * saturate( ( eyeDepth2_g463 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float2 temp_output_1_0_g463 = ( ( floor( ( temp_output_32_0_g463 * (_CameraDepthTexture_TexelSize).zw ) ) + 0.5 ) * (_CameraDepthTexture_TexelSize).xy );
				float2 temp_output_2408_38 = temp_output_1_0_g463;
				float2 _refractUV1673 = temp_output_2408_38;
				float2 temp_output_73_0_g464 = _refractUV1673;
				float2 UV22_g465 = float4( temp_output_73_0_g464, 0.0 , 0.0 ).xy;
				float2 localUnStereo22_g465 = UnStereo( UV22_g465 );
				float2 break64_g464 = localUnStereo22_g465;
				float clampDepth76_g464 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_73_0_g464, 0.0 , 0.0 ).xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g464 = ( 1.0 - clampDepth76_g464 );
				#else
				float staticSwitch38_g464 = clampDepth76_g464;
				#endif
				float3 appendResult39_g464 = (float3(break64_g464.x , break64_g464.y , staticSwitch38_g464));
				float4 appendResult42_g464 = (float4((appendResult39_g464*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g464 = mul( unity_CameraInvProjection, appendResult42_g464 );
				float3 In72_g464 = ( (temp_output_43_0_g464).xyz / (temp_output_43_0_g464).w );
				float3 localInvertDepthDir72_g464 = InvertDepthDir72_g464( In72_g464 );
				float4 appendResult49_g464 = (float4(localInvertDepthDir72_g464 , 1.0));
				float2 coords2546 = (mul( unity_CameraToWorld, appendResult49_g464 )).xz * _CausticsScale;
				float2 id2546 = 0;
				float2 uv2546 = 0;
				float voroi2546 = voronoi2546( coords2546, time2546, id2546, uv2546, 0, voronoiSmoothId2546 );
				float smoothstepResult2606 = smoothstep( 0.133 , 1.0 , voroi2546);
				float4 screenColor1646 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_2408_38);
				float4 _distortion1672 = ( screenColor1646 * float4( FinalLight1989 , 0.0 ) );
				float4 temp_output_2609_0 = ( smoothstepResult2606 * _distortion1672 );
				float4 lerpResult2540 = lerp( temp_output_2609_0 , ( temp_output_2609_0 * 3.0 ) , saturate( pow( smoothstepResult2606 , 3.0 ) ));
				float4 emission1669 = ( ( ( max( ( lerpResult2540 * 2.0 ) , float4( 0,0,0,0 ) ) * _CausticIntensity * float4( FinalLight1989 , 0.0 ) ) * _depthMaskOpacity1652 ) + saturate( ( _distortion1672 * _depthMaskOpacity1652 ) ) );
				float4 lerpResult2278 = lerp( temp_output_1942_0 , temp_output_1950_0 , _BacksideWaterColor);
				float4 ColorBackside2279 = lerpResult2278;
				float fresnelNdotV2247 = dot( WorldNormal1915, worldViewDir );
				float fresnelNode2247 = ( _fresnelbias + _fresnelscale * pow( 1.0 - fresnelNdotV2247, _fresnelpower ) );
				float4 lerpResult2249 = lerp( ( ColorBackside2279 * float4( FinalLight1989 , 0.0 ) ) , _distortion1672 , ( 1.0 - saturate( fresnelNode2247 ) ));
				float4 switchResult2230 = (((ase_vface>0)?(emission1669):(lerpResult2249)));
				float3 worldPos2472 = worldPos;
				float3 viewDir2472 = worldViewDir;
				float3 normalDir2472 = WorldNormal1915;
				float3 albedo2472 = Color1917.rgb;
				float4 unityObjectToClipPos2465 = UnityObjectToClipPos( IN.ase_texcoord10.xyz );
				float4 computeGrabScreenPos2466 = ComputeGrabScreenPos( unityObjectToClipPos2465 );
				float4 screenPos2472 = computeGrabScreenPos2466;
				float3 localSSR2472 = SSR( worldPos2472 , viewDir2472 , normalDir2472 , albedo2472 , screenPos2472 );
				float3 switchResult2473 = (((ase_vface>0)?(localSSR2472):(float3( 0,0,0 ))));
				#ifdef _SSR_ON
				float3 staticSwitch2474 = switchResult2473;
				#else
				float3 staticSwitch2474 = float3( 0,0,0 );
				#endif
				float3 SSR2475 = staticSwitch2474;
				
				o.Albedo = temp_cast_0;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = ( float4( BRDF1911 , 0.0 ) + switchResult2264 + switchResult2230 + float4( SSR2475 , 0.0 ) ).rgb;
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = 0;
				#endif
				o.Smoothness = -1.0;
				o.Occlusion = 0.0;
				o.Alpha = saturate( ( Opacity2548 + EdgeWave2581 ) );
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;				

				#ifdef _ALPHATEST_ON
					clip( o.Alpha - AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				fixed4 c = 0;
				float3 worldN;
				worldN.x = dot(IN.tSpace0.xyz, o.Normal);
				worldN.y = dot(IN.tSpace1.xyz, o.Normal);
				worldN.z = dot(IN.tSpace2.xyz, o.Normal);
				worldN = normalize(worldN);
				o.Normal = worldN;

				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;

				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = worldPos;
				giInput.worldViewDir = worldViewDir;
				giInput.atten = atten;
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
					giInput.lightmapUV = IN.lmap;
				#else
					giInput.lightmapUV = 0.0;
				#endif
				#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
					giInput.ambient = IN.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
				giInput.probeHDR[0] = unity_SpecCube0_HDR;
				giInput.probeHDR[1] = unity_SpecCube1_HDR;
				#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
					giInput.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMax[0] = unity_SpecCube0_BoxMax;
					giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
					giInput.boxMax[1] = unity_SpecCube1_BoxMax;
					giInput.boxMin[1] = unity_SpecCube1_BoxMin;
					giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif
				
				#if defined(_SPECULAR_SETUP)
					LightingStandardSpecular_GI(o, giInput, gi);
				#else
					LightingStandard_GI( o, giInput, gi );
				#endif

				#ifdef ASE_BAKEDGI
					gi.indirect.diffuse = BakedGI;
				#endif

				#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && defined(ASE_NO_AMBIENT)
					gi.indirect.diffuse = 0;
				#endif

				#if defined(_SPECULAR_SETUP)
					c += LightingStandardSpecular (o, worldViewDir, gi);
				#else
					c += LightingStandard( o, worldViewDir, gi );
				#endif
				
				#ifdef _TRANSMISSION_ASE
				{
					float shadow = _TransmissionShadow;
					#ifdef DIRECTIONAL
						float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
					#else
						float3 lightAtten = gi.light.color;
					#endif
					half3 transmission = max(0 , -dot(o.Normal, gi.light.dir)) * lightAtten * Transmission;
					c.rgb += o.Albedo * transmission;
				}
				#endif

				#ifdef _TRANSLUCENCY_ASE
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#ifdef DIRECTIONAL
						float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
					#else
						float3 lightAtten = gi.light.color;
					#endif
					half3 lightDir = gi.light.dir + o.Normal * normal;
					half transVdotL = pow( saturate( dot( worldViewDir, -lightDir ) ), scattering );
					half3 translucency = lightAtten * (transVdotL * direct + gi.indirect.diffuse * ambient) * Translucency;
					c.rgb += o.Albedo * translucency * strength;
				}
				#endif

				//#ifdef _REFRACTION_ASE
				//	float4 projScreenPos = ScreenPos / ScreenPos.w;
				//	float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, WorldNormal ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
				//	projScreenPos.xy += refractionOffset.xy;
				//	float3 refraction = UNITY_SAMPLE_SCREENSPACE_TEXTURE( _GrabTexture, projScreenPos ) * RefractionColor;
				//	color.rgb = lerp( refraction, color.rgb, color.a );
				//	color.a = 1;
				//#endif

				c.rgb += o.Emission;

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
		}

		GrabPass{ "_GrabTexture" }

		Pass
		{
			
			Name "ForwardAdd"
			Tags { "LightMode"="ForwardAdd" }
			ZWrite Off
			Blend SrcAlpha One

			CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_DISTANCE_TESSELLATION
			#define _ALPHABLEND_ON 1
			#if defined(SHADER_API_GLCORE) || defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_D3D9)
			#define FRONT_FACE_SEMANTIC VFACE
			#define FRONT_FACE_TYPE float
			#else
			#define FRONT_FACE_SEMANTIC SV_IsFrontFace
			#define FRONT_FACE_TYPE bool
			#endif
			#pragma multi_compile_fwdbase
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif

			#pragma vertex vert
			#pragma fragment frag
			#pragma skip_variants INSTANCING_ON
			#pragma multi_compile_fwdadd_fullshadows
			#ifndef UNITY_PASS_FORWARDADD
				#define UNITY_PASS_FORWARDADD
			#endif
			#include "HLSLSupport.cginc"
			#if !defined( UNITY_INSTANCED_LOD_FADE )
				#define UNITY_INSTANCED_LOD_FADE
			#endif
			#if !defined( UNITY_INSTANCED_SH )
				#define UNITY_INSTANCED_SH
			#endif
			#if !defined( UNITY_INSTANCED_LIGHTMAPSTS )
				#define UNITY_INSTANCED_LIGHTMAPSTS
			#endif
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			#include "AutoLight.cginc"

			#include "UnityStandardUtils.cginc"
			#include "UnityStandardBRDF.cginc"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES2
			#pragma shader_feature_local _SSR_ON
			//Vertex Lights
			#pragma multi_compile _ VERTEXLIGHT_ON
			//MSAA artifact fix
			#if defined(SHADER_STAGE_VERTEX) || defined(SHADER_STAGE_FRAGMENT) || defined(SHADER_STAGE_DOMAIN) || defined(SHADER_STAGE_HULL) || defined(SHADER_STAGE_GEOMETRY)
			#if !defined(UNITY_PASS_DEFERRED) //ASEnodel1
			#define TEXCOORD9 TEXCOORD9_Centroid
			#endif //ASEnodel2
			#endif //ASEnodel3
			//SSR defines
			float4 _GrabTexture_TexelSize;
			float4 _NoiseTexSSR_TexelSize;
			#define SSR_ENABLED	defined(_SSR_ON) && !defined(UNITY_PASS_FORWARDADD)

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct v2f {
				#if UNITY_VERSION >= 201810
					UNITY_POSITION(pos);
				#else
					float4 pos : SV_POSITION;
				#endif
				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHTING_COORDS(1,2)
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_SHADOW_COORDS(1)
					#else
						SHADOW_COORDS(1)
					#endif
				#endif
				#ifdef ASE_FOG
					UNITY_FOG_COORDS(3)
				#endif
				float4 tSpace0 : TEXCOORD5;
				float4 tSpace1 : TEXCOORD6;
				float4 tSpace2 : TEXCOORD7;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD8;
				#endif
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_texcoord10 : TEXCOORD10;
				float4 ase_lmap : TEXCOORD11;
				float4 ase_sh : TEXCOORD12;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			uniform float _GSAAVariance;
			uniform float _EnableGSAA;
			uniform float _GSAAThreshold;
			uniform float _EdgeFadeSSR;
			uniform int _NormalScaleSecondaryAnimated;
			uniform float _UVTiling;
			uniform sampler2D _NoiseTexSSR;
			uniform int _ZWrite;
			uniform int _NormalScaleAnimated;
			uniform float _ShaderOptimizerEnabled;
			uniform int _Cull;
			uniform int _GerstnerWavesToggle;
			uniform float4 _WaveA;
			uniform sampler2D _VertexOffsetMask;
			uniform float4 _VertexOffsetMask_ST;
			uniform float _GerstnerSpeed;
			uniform float _GerstnerHeight;
			uniform float4 _WaveB;
			uniform float4 _WaveC;
			uniform float _VertOffsetDistMaskTessMaxxthis;
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

	
			//This is a late directive
			
			void SourceDeclaration(  )
			{
				//This Shader was made possible by Moriohs Toon Shader (https://gitlab.com/xMorioh/moriohs-toon-shader)
			}
			
			float2 hash2D2D( float2 s )
			{
				return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453);
			}
			
			float UnityCalcDistanceTessFactor( float4 vertex, float minDist, float maxDist, float tess )
			{
				    float3 wpos = mul(unity_ObjectToWorld,vertex).xyz;
				    float dist = distance (wpos, _WorldSpaceCameraPos);
				    float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
				    return f;
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
			
			float3 InvertDepthDir72_g461( float3 In )
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
			
					float2 voronoihash2546( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2546( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash2546( n + g );
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
			
			float3 InvertDepthDir72_g464( float3 In )
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
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 uv_VertexOffsetMask = v.ase_texcoord.xy * _VertexOffsetMask_ST.xy + _VertexOffsetMask_ST.zw;
				float4 tex2DNode1275 = tex2Dlod( _VertexOffsetMask, float4( uv_VertexOffsetMask, 0, 0.0) );
				float VertexOffsetMask1284 = tex2DNode1275.g;
				float4 appendResult1278 = (float4(_WaveA.x , _WaveA.y , ( _WaveA.z * VertexOffsetMask1284 ) , _WaveA.w));
				float4 wave1199 = appendResult1278;
				float3 p1199 = v.vertex.xyz;
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
				float3 p1200 = v.vertex.xyz;
				float3 tangent1200 = _tangent;
				float3 binormal1200 = _binormal;
				float Speed1200 = _GerstnerSpeed;
				float Height1200 = temp_output_1243_0;
				float3 localGerstnerWave1200 = GerstnerWave( wave1200 , p1200 , tangent1200 , binormal1200 , Speed1200 , Height1200 );
				float4 appendResult1283 = (float4(_WaveC.x , _WaveC.y , ( _WaveC.z * VertexOffsetMask1284 ) , _WaveC.w));
				float4 wave1201 = appendResult1283;
				float3 p1201 = v.vertex.xyz;
				float3 tangent1201 = _tangent;
				float3 binormal1201 = _binormal;
				float Speed1201 = _GerstnerSpeed;
				float Height1201 = temp_output_1243_0;
				float3 localGerstnerWave1201 = GerstnerWave( wave1201 , p1201 , tangent1201 , binormal1201 , Speed1201 , Height1201 );
				float3 GerstnerOffset1259 = ( localGerstnerWave1199 + localGerstnerWave1200 + localGerstnerWave1201 );
				float3 ifLocalVar2389 = 0;
				if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2389 = GerstnerOffset1259;
				float3 GerstnerOffsetWithMask2519 = ( ifLocalVar2389 * tex2DNode1275.g );
				float4 vertex2417 = v.vertex;
				float minDist2417 = _TessMin;
				float maxDist2417 = ( _TessMax * _VertOffsetDistMaskTessMaxxthis );
				float tess2417 = _TessValue;
				float localTessDistance2417 = TessDistance( vertex2417 , minDist2417 , maxDist2417 , tess2417 );
				float TessellationDistance2421 = saturate( (0.0 + (localTessDistance2417 - ( _TessValue / 100.0 )) * (1.0 - 0.0) / (1.0 - ( _TessValue / 100.0 ))) );
				float3 objectToViewPos = UnityObjectToViewPos(v.vertex.xyz);
				float eyeDepth = -objectToViewPos.z;
				float cameraDepthFade2508 = (( eyeDepth -_ProjectionParams.y - 2.0 ) / 1.0);
				float ifLocalVar2512 = 0;
				if( _VertexOffsetCameradistMask == 1.0 )
				ifLocalVar2512 = saturate( cameraDepthFade2508 );
				else if( _VertexOffsetCameradistMask < 1.0 )
				ifLocalVar2512 = 1.0;
				float3 FinalVertexOffset1260 = ( ( GerstnerOffsetWithMask2519 * TessellationDistance2421 ) * ifLocalVar2512 );
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_output_73_0_g461 = ase_screenPosNorm.xy;
				float2 UV22_g462 = float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy;
				float2 localUnStereo22_g462 = UnStereo( UV22_g462 );
				float2 break64_g461 = localUnStereo22_g462;
				float clampDepth76_g461 = SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy, 0, 0 ) );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g461 = ( 1.0 - clampDepth76_g461 );
				#else
				float staticSwitch38_g461 = clampDepth76_g461;
				#endif
				float3 appendResult39_g461 = (float3(break64_g461.x , break64_g461.y , staticSwitch38_g461));
				float4 appendResult42_g461 = (float4((appendResult39_g461*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g461 = mul( unity_CameraInvProjection, appendResult42_g461 );
				float3 In72_g461 = ( (temp_output_43_0_g461).xyz / (temp_output_43_0_g461).w );
				float3 localInvertDepthDir72_g461 = InvertDepthDir72_g461( In72_g461 );
				float4 appendResult49_g461 = (float4(localInvertDepthDir72_g461 , 1.0));
				float mulTime2552 = _Time.y * _EdgeWaveSpeed;
				float temp_output_2553_0 = sin( mulTime2552 );
				float lerpResult2565 = lerp( saturate( -temp_output_2553_0 ) , saturate( temp_output_2553_0 ) , ( ( temp_output_2553_0 * 0.5 ) + 0.5 ));
				float temp_output_2568_0 = ( ( ( ( ase_worldPos.y - mul( unity_CameraToWorld, appendResult49_g461 ).y ) * _EdgeWaveFrequency ) + lerpResult2565 ) + _EdgeWaveOffset );
				float smoothstepResult2579 = smoothstep( ( _EdgeWaveSharpness - 0.25 ) , 1.0 , ( temp_output_2568_0 - 0.25 ));
				float eyeDepth2409 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
				float _depthMaskOpacity1652 = ( 1.0 - saturate( ( ( eyeDepth2409 - eyeDepth ) * ( 1.0 - _Depth ) ) ) );
				float Opacity2548 = ( ( 1.0 - _depthMaskOpacity1652 ) * 16.0 );
				float temp_output_2572_0 = saturate( ( 1.0 - Opacity2548 ) );
				float temp_output_2176_0 = ( distance( ase_worldPos , _WorldSpaceCameraPos ) * 0.005 );
				float LODDistance2533 = saturate( ( 1.0 - temp_output_2176_0 ) );
				float ifLocalVar2587 = 0;
				if( _ToggleEdgeWave == 1.0 )
				ifLocalVar2587 = ( ( ( saturate( smoothstepResult2579 ) * temp_output_2572_0 ) * _EdgeWaveVertexOffset ) * LODDistance2533 );
				float3 appendResult2588 = (float3(0.0 , ifLocalVar2587 , 0.0));
				float3 EdgeWaveVertexOffset2589 = appendResult2588;
				
				float3 normalizeResult1209 = normalize( cross( ( binormal1199 + binormal1200 + binormal1201 ) , ( tangent1199 + tangent1200 + tangent1201 ) ) );
				float3 ifLocalVar2391 = 0;
				if( 1.0 > _GerstnerWavesToggle )
				ifLocalVar2391 = v.normal;
				else if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2391 = normalizeResult1209;
				float3 FinalVertexNormals1262 = ifLocalVar2391;
				
				o.ase_texcoord9.x = eyeDepth;
				#ifdef DYNAMICLIGHTMAP_ON //dynlm
				o.ase_lmap.zw = v.texcoord2.xyzw.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif //dynlm
				#ifdef LIGHTMAP_ON //stalm
				o.ase_lmap.xy = v.texcoord1.xyzw.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif //stalm
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.normal);
				#ifndef LIGHTMAP_ON //nstalm
				#if UNITY_SHOULD_SAMPLE_SH //sh
				o.ase_sh.xyz = 0;
				#ifdef VERTEXLIGHT_ON //vl
				o.ase_sh.xyz += Shade4PointLights (
				unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
				unity_4LightAtten0, ase_worldPos, ase_worldNormal);
				#endif //vl
				o.ase_sh.xyz = ShadeSHPerVertex (ase_worldNormal, o.ase_sh.xyz);
				#endif //sh
				#endif //nstalm
				
				o.ase_texcoord9.yz = v.ase_texcoord.xy;
				o.ase_texcoord10 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.w = 0;
				o.ase_sh.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( FinalVertexOffset1260 + EdgeWaveVertexOffset2589 );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = FinalVertexNormals1262;
				v.tangent = v.tangent;

				o.pos = UnityObjectToClipPos(v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
				o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				#if UNITY_VERSION >= 201810 && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
				#elif defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if UNITY_VERSION >= 201710
						UNITY_TRANSFER_SHADOW(o, v.texcoord1.xy);
					#else
						TRANSFER_SHADOW(o);
					#endif
				#endif

				#ifdef ASE_FOG
					UNITY_TRANSFER_FOG(o,o.pos);
				#endif
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(o.pos);
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( appdata v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.tangent = v.tangent;
				o.normal = v.normal;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				appdata o = (appdata) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
				o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			v2f vert ( appdata v )
			{
				return VertexFunction( v );
			}
			#endif

			fixed4 frag ( v2f IN , FRONT_FACE_TYPE ase_vface : FRONT_FACE_SEMANTIC
				#ifdef _DEPTHOFFSET_ON
				, out float outputDepth : SV_Depth
				#endif
				) : SV_Target 
			{
				UNITY_SETUP_INSTANCE_ID(IN);

				#ifdef LOD_FADE_CROSSFADE
					UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
				#endif

				#if defined(_SPECULAR_SETUP)
					SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
				#else
					SurfaceOutputStandard o = (SurfaceOutputStandard)0;
				#endif
				float3 WorldTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldNormal = float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z);
				float3 worldPos = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
				#else
					half atten = 1;
				#endif
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif


				float3 temp_cast_0 = (0.0).xxx;
				
				sampler2D tex96_g451 = _Normal;
				float mulTime7_g451 = _Time.y * _ScrollSpeed;
				float temp_output_68_0_g451 = _UVTiling;
				float2 appendResult101_g451 = (float2(worldPos.x , worldPos.z));
				float2 temp_output_103_0_g451 = ( ( _Normal_ST.xy * temp_output_68_0_g451 * appendResult101_g451 ) + _Normal_ST.zw );
				float2 panner17_g451 = ( mulTime7_g451 * _VectorXY + temp_output_103_0_g451);
				float2 UV96_g451 = ( panner17_g451 + 0.25 );
				float _NormalScale96_g451 = _NormalScale;
				float3 localtex2DStochasticNormals96_g451 = tex2DStochasticNormals( tex96_g451 , UV96_g451 , _NormalScale96_g451 );
				sampler2D tex79_g451 = _Normal;
				float mulTime4_g451 = _Time.y * _ScrollSpeed;
				float temp_output_9_0_g451 = ( mulTime4_g451 * 2.179 );
				float2 panner12_g451 = ( temp_output_9_0_g451 * _VectorXY + ( 1.0 - temp_output_103_0_g451 ));
				float2 UV79_g451 = ( 1.0 - panner12_g451 );
				float _NormalScale79_g451 = _NormalScale;
				float3 localtex2DStochasticNormals79_g451 = tex2DStochasticNormals( tex79_g451 , UV79_g451 , _NormalScale79_g451 );
				sampler2D tex76_g451 = _SecondaryNormal;
				float mulTime16_g451 = _Time.y * _SecondaryScrollSpeed;
				float2 panner21_g451 = ( mulTime16_g451 * _SecondaryVectorXY + ( ( _SecondaryNormal_ST.xy * temp_output_68_0_g451 * appendResult101_g451 ) + _SecondaryNormal_ST.zw ));
				float2 UV76_g451 = panner21_g451;
				float _NormalScale76_g451 = _NormalScaleSecondary;
				float3 localtex2DStochasticNormals76_g451 = tex2DStochasticNormals( tex76_g451 , UV76_g451 , _NormalScale76_g451 );
				sampler3D tex2057 = _Normals_3D;
				float temp_output_2023_0 = ( _UVTiling * 0.25 );
				float2 break2605 = _Normals_3D_ST.xy;
				float _Time1684 = temp_output_9_0_g451;
				float3 appendResult1682 = (float3(( worldPos.x * temp_output_2023_0 * break2605.x ) , ( worldPos.z * temp_output_2023_0 * break2605.y ) , ( _Time1684 * 4.0 )));
				float3 _3duvs1683 = appendResult1682;
				float3 UV2057 = _3duvs1683;
				float lerpResult1687 = lerp( 0.0 , _3DNormalScale , WorldNormal.y);
				float Normalscale2057 = lerpResult1687;
				float3 localtex3DStochasticNormals2057 = tex3DStochasticNormals( tex2057 , UV2057 , Normalscale2057 );
				float temp_output_2176_0 = ( distance( worldPos , _WorldSpaceCameraPos ) * 0.005 );
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 ase_tanViewDir =  tanToWorld0 * worldViewDir.x + tanToWorld1 * worldViewDir.y  + tanToWorld2 * worldViewDir.z;
				ase_tanViewDir = Unity_SafeNormalize( ase_tanViewDir );
				float switchResult2209 = (((ase_vface>0)?(ase_tanViewDir.z):(-ase_tanViewDir.z)));
				float lerpResult2168 = lerp( temp_output_2176_0 , 1.0 , ( ( 1.0 - switchResult2209 ) * ( 1.0 - _3DNormalLod ) ));
				float3 lerpResult2132 = lerp( localtex3DStochasticNormals2057 , float3( 0,0,1 ) , saturate( lerpResult2168 ));
				float3 ifLocalVar2401 = 0;
				if( 1.0 > _3DNormals )
				ifLocalVar2401 = BlendNormals( BlendNormals( localtex2DStochasticNormals96_g451 , localtex2DStochasticNormals79_g451 ) , localtex2DStochasticNormals76_g451 );
				else if( 1.0 == _3DNormals )
				ifLocalVar2401 = lerpResult2132;
				float3 normalizeResult1901 = normalize( ifLocalVar2401 );
				float3 switchResult2258 = (((ase_vface>0)?(normalizeResult1901):(-normalizeResult1901)));
				float3 Normals80 = switchResult2258;
				float3 tanNormal1897 = Normals80;
				float3 worldNormal1897 = float3(dot(tanToWorld0,tanNormal1897), dot(tanToWorld1,tanNormal1897), dot(tanToWorld2,tanNormal1897));
				float3 WorldNormal1915 = worldNormal1897;
				float3 WorldNormals305_g466 = WorldNormal1915;
				float3 worldSpaceLightDir = UnityWorldSpaceLightDir(worldPos);
				float dotResult2930_g466 = dot( WorldNormals305_g466 , worldSpaceLightDir );
				float NdLGGX2357_g466 = saturate( dotResult2930_g466 );
				float temp_output_2418_0_g466 = max( 0.0 , NdLGGX2357_g466 );
				float NdotL2412_g466 = temp_output_2418_0_g466;
				float3 viewDir443_g453 = worldViewDir;
				float3 WorldNormals20_g453 = WorldNormal1915;
				float3 normal443_g453 = WorldNormals20_g453;
				float localCorrectNegativeNdotV443_g453 = CorrectNegativeNdotV( viewDir443_g453 , normal443_g453 );
				float CorrectedNdotV2507_g466 = localCorrectNegativeNdotV443_g453;
				float NdotV2412_g466 = CorrectedNdotV2507_g466;
				float3 worldNormal2910_g466 = WorldNormals305_g466;
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth2409 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float eyeDepth = IN.ase_texcoord9.x;
				float _depthMaskOpacity1652 = ( 1.0 - saturate( ( ( eyeDepth2409 - eyeDepth ) * ( 1.0 - _Depth ) ) ) );
				float Opacity2548 = ( ( 1.0 - _depthMaskOpacity1652 ) * 16.0 );
				float2 temp_output_73_0_g461 = ase_screenPosNorm.xy;
				float2 UV22_g462 = float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy;
				float2 localUnStereo22_g462 = UnStereo( UV22_g462 );
				float2 break64_g461 = localUnStereo22_g462;
				float clampDepth76_g461 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_73_0_g461, 0.0 , 0.0 ).xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g461 = ( 1.0 - clampDepth76_g461 );
				#else
				float staticSwitch38_g461 = clampDepth76_g461;
				#endif
				float3 appendResult39_g461 = (float3(break64_g461.x , break64_g461.y , staticSwitch38_g461));
				float4 appendResult42_g461 = (float4((appendResult39_g461*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g461 = mul( unity_CameraInvProjection, appendResult42_g461 );
				float3 In72_g461 = ( (temp_output_43_0_g461).xyz / (temp_output_43_0_g461).w );
				float3 localInvertDepthDir72_g461 = InvertDepthDir72_g461( In72_g461 );
				float4 appendResult49_g461 = (float4(localInvertDepthDir72_g461 , 1.0));
				float mulTime2552 = _Time.y * _EdgeWaveSpeed;
				float temp_output_2553_0 = sin( mulTime2552 );
				float lerpResult2565 = lerp( saturate( -temp_output_2553_0 ) , saturate( temp_output_2553_0 ) , ( ( temp_output_2553_0 * 0.5 ) + 0.5 ));
				float temp_output_2568_0 = ( ( ( ( worldPos.y - mul( unity_CameraToWorld, appendResult49_g461 ).y ) * _EdgeWaveFrequency ) + lerpResult2565 ) + _EdgeWaveOffset );
				float smoothstepResult2570 = smoothstep( _EdgeWaveSharpness , 1.0 , temp_output_2568_0);
				float temp_output_2572_0 = saturate( ( 1.0 - Opacity2548 ) );
				float LODDistance2533 = saturate( ( 1.0 - temp_output_2176_0 ) );
				float ifLocalVar2580 = 0;
				if( _ToggleEdgeWave == 1.0 )
				ifLocalVar2580 = ( ( saturate( smoothstepResult2570 ) * temp_output_2572_0 ) * LODDistance2533 );
				float EdgeWave2581 = ifLocalVar2580;
				sampler2D tex340 = _SeaFoam;
				float2 appendResult1851 = (float2(worldPos.x , worldPos.z));
				float2 NormalVector625 = _VectorXY;
				float mulTime344 = _Time.y * _EdgeFoamSpeed;
				float mulTime415 = _Time.y * ( 1.5 * 10.0 );
				float4 _NoiseScaleOffset = float4(7.5,1.5,0,0);
				float2 appendResult1000 = (float2(_NoiseScaleOffset.x , _NoiseScaleOffset.y));
				float2 appendResult1885 = (float2(worldPos.x , worldPos.z));
				float2 appendResult1001 = (float2(_NoiseScaleOffset.z , _NoiseScaleOffset.w));
				float2 temp_output_1003_0 = ( ( appendResult1000 * appendResult1885 ) + appendResult1001 );
				float2 panner412 = ( mulTime415 * -NormalVector625 + temp_output_1003_0);
				float simpleNoise411 = SimpleNoise( panner412*0.01 );
				float2 panner746 = ( mulTime415 * NormalVector625 + temp_output_1003_0);
				float simpleNoise747 = SimpleNoise( panner746*0.01 );
				float Noise2496 = ( simpleNoise411 + simpleNoise747 );
				float3 appendResult1858 = (float3(0.0 , 0.0 , _NormalMapdeformation));
				float dotResult1852 = dot( appendResult1858 , Normals80 );
				float2 UV340 = ( ( ( _SeaFoam_ST.xy * appendResult1851 * _UVTiling ) + _SeaFoam_ST.zw ) + ( NormalVector625 * mulTime344 ) + ( ( saturate( Noise2496 ) * 0.25 ) + dotResult1852 ) );
				float4 localtex2DStochastic340 = tex2DStochastic( tex340 , UV340 );
				float temp_output_2486_0 = ( 1.0 - _EdgeFoamDistance );
				float lerpResult2490 = lerp( 0.0 , exp( temp_output_2486_0 ) , saturate( ( _depthMaskOpacity1652 - temp_output_2486_0 ) ));
				float2 uv_VertexOffsetMask = IN.ase_texcoord9.yz * _VertexOffsetMask_ST.xy + _VertexOffsetMask_ST.zw;
				float4 tex2DNode1275 = tex2D( _VertexOffsetMask, uv_VertexOffsetMask );
				float VertexOffsetMask1284 = tex2DNode1275.g;
				float4 appendResult1278 = (float4(_WaveA.x , _WaveA.y , ( _WaveA.z * VertexOffsetMask1284 ) , _WaveA.w));
				float4 wave1199 = appendResult1278;
				float3 p1199 = IN.ase_texcoord10.xyz;
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
				float3 p1200 = IN.ase_texcoord10.xyz;
				float3 tangent1200 = _tangent;
				float3 binormal1200 = _binormal;
				float Speed1200 = _GerstnerSpeed;
				float Height1200 = temp_output_1243_0;
				float3 localGerstnerWave1200 = GerstnerWave( wave1200 , p1200 , tangent1200 , binormal1200 , Speed1200 , Height1200 );
				float4 appendResult1283 = (float4(_WaveC.x , _WaveC.y , ( _WaveC.z * VertexOffsetMask1284 ) , _WaveC.w));
				float4 wave1201 = appendResult1283;
				float3 p1201 = IN.ase_texcoord10.xyz;
				float3 tangent1201 = _tangent;
				float3 binormal1201 = _binormal;
				float Speed1201 = _GerstnerSpeed;
				float Height1201 = temp_output_1243_0;
				float3 localGerstnerWave1201 = GerstnerWave( wave1201 , p1201 , tangent1201 , binormal1201 , Speed1201 , Height1201 );
				float3 GerstnerOffset1259 = ( localGerstnerWave1199 + localGerstnerWave1200 + localGerstnerWave1201 );
				float3 ifLocalVar2389 = 0;
				if( 1.0 == _GerstnerWavesToggle )
				ifLocalVar2389 = GerstnerOffset1259;
				float3 GerstnerOffsetWithMask2519 = ( ifLocalVar2389 * tex2DNode1275.g );
				float clampResult2524 = clamp( ( GerstnerOffsetWithMask2519.y * LODDistance2533 ) , -2.0 , 2.0 );
				float VertexOffsetForEffects2525 = clampResult2524;
				float EdgeFoam1909 = ( saturate( ( localtex2DStochastic340.y - ( ( 1.0 - lerpResult2490 ) - saturate( VertexOffsetForEffects2525 ) ) ) ) * _EdgePower * saturate( Noise2496 ) );
				float Smoothness300_g466 = ( min( saturate( ( Opacity2548 + EdgeWave2581 ) ) , ( 1.0 - EdgeFoam1909 ) ) * _Smoothness );
				float smoothness2910_g466 = Smoothness300_g466;
				float localGSAA_Filament2910_g466 = GSAA_Filament( worldNormal2910_g466 , smoothness2910_g466 );
				float SmoothnessTex290_g466 = localGSAA_Filament2910_g466;
				float perceptualRoughness2761_g466 = ( 1.0 - SmoothnessTex290_g466 );
				float roughness2729_g466 = max( ( perceptualRoughness2761_g466 * perceptualRoughness2761_g466 ) , 0.002 );
				float roughness2412_g466 = roughness2729_g466;
				float localgetSmithJointGGXVisibilityTerm2412_g466 = getSmithJointGGXVisibilityTerm( NdotL2412_g466 , NdotV2412_g466 , roughness2412_g466 );
				float GGXVisibilityTerm2305_g466 = localgetSmithJointGGXVisibilityTerm2412_g466;
				float3 normalizeResult464_g453 = ASESafeNormalize( ( worldViewDir + worldSpaceLightDir ) );
				float3 HalfVectorUnityNormalized457_g453 = normalizeResult464_g453;
				float dotResult42_g453 = dot( WorldNormals20_g453 , HalfVectorUnityNormalized457_g453 );
				float NdotH2416_g466 = max( 0.0 , dotResult42_g453 );
				float roughness2416_g466 = roughness2729_g466;
				float localgetGGXTerm2416_g466 = getGGXTerm( NdotH2416_g466 , roughness2416_g466 );
				float GGXTerm2305_g466 = localgetGGXTerm2416_g466;
				float NdotL2305_g466 = temp_output_2418_0_g466;
				float dotResult50_g453 = dot( worldSpaceLightDir , HalfVectorUnityNormalized457_g453 );
				float LdotH2305_g466 = max( 0.0 , dotResult50_g453 );
				float roughness2305_g466 = roughness2729_g466;
				float4 temp_output_1942_0 = ( _Color * _Color.a );
				float4 temp_output_1950_0 = ( _ColorSecondary * _ColorSecondary.a );
				float4 lerpResult1939 = lerp( temp_output_1942_0 , temp_output_1950_0 , ( ( VertexOffsetForEffects2525 * 0.1 ) + _depthMaskOpacity1652 ));
				float4 Color1917 = lerpResult1939;
				float3 MainTex312_g466 = Color1917.rgb;
				float MetallicTex289_g466 = 0.0;
				half3 specColor2324_g466 = (0).xxx;
				half oneMinusReflectivity2324_g466 = 0;
				half3 diffuseAndSpecularFromMetallic2324_g466 = DiffuseAndSpecularFromMetallic(MainTex312_g466,MetallicTex289_g466,specColor2324_g466,oneMinusReflectivity2324_g466);
				float3 SpecColor2715_g466 = specColor2324_g466;
				float3 specColor2305_g466 = SpecColor2715_g466;
				#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
				float4 ase_lightColor = 0;
				#else //aselc
				float4 ase_lightColor = _LightColor0;
				#endif //aselc
				float AttenGGX2831_g466 = float4(atten,0,0,0);
				float3 lightcolor2305_g466 = ( ase_lightColor.rgb * AttenGGX2831_g466 );
				float SpecularHighlightToggle2498_g466 = _CubemapSpecularToggle;
				float specularTermToggle2305_g466 = SpecularHighlightToggle2498_g466;
				float3 localcalcSpecularTerm2305_g466 = calcSpecularTerm( GGXVisibilityTerm2305_g466 , GGXTerm2305_g466 , NdotL2305_g466 , LdotH2305_g466 , roughness2305_g466 , specColor2305_g466 , lightcolor2305_g466 , specularTermToggle2305_g466 );
				float3 specularTerm2404_g466 = localcalcSpecularTerm2305_g466;
				float NdotV2404_g466 = CorrectedNdotV2507_g466;
				float3 specColor2404_g466 = SpecColor2715_g466;
				float roughness2404_g466 = roughness2729_g466;
				float OneMinusReflectivity2718_g466 = oneMinusReflectivity2324_g466;
				float oneMinusReflectivity2404_g466 = OneMinusReflectivity2718_g466;
				float AO2783_g466 = _BRDFAmbientOcclusion;
				UnityGIInput data;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data );
				data.worldPos = worldPos;
				data.worldViewDir = worldViewDir;
				data.probeHDR[0] = unity_SpecCube0_HDR;
				data.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION //specdataif0
				data.boxMin[0] = unity_SpecCube0_BoxMin;
				#endif //specdataif0
				#if UNITY_SPECCUBE_BOX_PROJECTION //specdataif1
				data.boxMax[0] = unity_SpecCube0_BoxMax;
				data.probePosition[0] = unity_SpecCube0_ProbePosition;
				data.boxMax[1] = unity_SpecCube1_BoxMax;
				data.boxMin[1] = unity_SpecCube1_BoxMin;
				data.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif //specdataif1
				Unity_GlossyEnvironmentData g2316_g466 = UnityGlossyEnvironmentSetup( SmoothnessTex290_g466, worldViewDir, WorldNormals305_g466, float3(0,0,0));
				float3 indirectSpecular2316_g466 = UnityGI_IndirectSpecular( data, AO2783_g466, WorldNormals305_g466, g2316_g466 );
				float3 indirectspecular2404_g466 = indirectSpecular2316_g466;
				float smoothness2404_g466 = SmoothnessTex290_g466;
				float perceptualRoughness2404_g466 = perceptualRoughness2761_g466;
				float3 localcalcSpecularBase2404_g466 = calcSpecularBase( specularTerm2404_g466 , NdotV2404_g466 , specColor2404_g466 , roughness2404_g466 , oneMinusReflectivity2404_g466 , indirectspecular2404_g466 , smoothness2404_g466 , perceptualRoughness2404_g466 );
				float3 SpecularReflections316_g466 = localcalcSpecularBase2404_g466;
				float Intensity285_g466 = _BRDFIntensity;
				float3 BRDF1911 = ( SpecularReflections316_g466 * Intensity285_g466 );
				float dotResult3_g453 = dot( WorldNormals20_g453 , worldSpaceLightDir );
				float NdL2030 = dotResult3_g453;
				float lerpResult2007 = lerp( NdL2030 , 1.0 , _NdLfade);
				float3 tanNormal1984 = Normals80;
				UnityGIInput data1984;
				UNITY_INITIALIZE_OUTPUT( UnityGIInput, data1984 );
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm1984
				data1984.lightmapUV = IN.ase_lmap;
				#endif //dylm1984
				#if UNITY_SHOULD_SAMPLE_SH //fsh1984
				data1984.ambient = IN.ase_sh;
				#endif //fsh1984
				UnityGI gi1984 = UnityGI_Base(data1984, 1, float3(dot(tanToWorld0,tanNormal1984), dot(tanToWorld1,tanNormal1984), dot(tanToWorld2,tanNormal1984)));
				float3 localLightColorZero304_g453 = LightColorZero();
				float4 localFourLightAtten305_g453 = FourLightAtten();
				float4 localFourLightPosX340_g453 = FourLightPosX();
				float4 temp_cast_7 = (worldPos.x).xxxx;
				float4 FourLightPosX0WorldPos286_g453 = ( localFourLightPosX340_g453 - temp_cast_7 );
				float4 localFourLightPosY342_g453 = FourLightPosY();
				float4 temp_cast_8 = (worldPos.y).xxxx;
				float4 FourLightPosY0WorldPos291_g453 = ( localFourLightPosY342_g453 - temp_cast_8 );
				float4 localFourLightPosZ296_g453 = FourLightPosZ();
				float4 temp_cast_9 = (worldPos.z).xxxx;
				float4 FourLightPosZ0WorldPos325_g453 = ( localFourLightPosZ296_g453 - temp_cast_9 );
				float4 temp_cast_10 = (1E-06).xxxx;
				float4 temp_output_328_0_g453 = max( ( ( FourLightPosX0WorldPos286_g453 * FourLightPosX0WorldPos286_g453 ) + ( FourLightPosY0WorldPos291_g453 * FourLightPosY0WorldPos291_g453 ) + ( FourLightPosZ0WorldPos325_g453 * FourLightPosZ0WorldPos325_g453 ) ) , temp_cast_10 );
				float4 temp_output_272_0_g453 = ( localFourLightAtten305_g453 * temp_output_328_0_g453 );
				float4 temp_cast_11 = (1E-06).xxxx;
				float4 temp_output_343_0_g453 = saturate( ( 1.0 - ( temp_output_272_0_g453 / 25.0 ) ) );
				float4 temp_output_320_0_g453 = min( ( 1.0 / ( 1.0 + temp_output_272_0_g453 ) ) , ( temp_output_343_0_g453 * temp_output_343_0_g453 ) );
				float4 temp_cast_12 = (1E-06).xxxx;
				float3 break295_g453 = WorldNormals20_g453;
				float4 temp_output_366_0_g453 = ( rsqrt( temp_output_328_0_g453 ) * ( ( FourLightPosX0WorldPos286_g453 * break295_g453.x ) + ( FourLightPosY0WorldPos291_g453 * break295_g453.y ) + ( FourLightPosZ0WorldPos325_g453 * break295_g453.z ) ) );
				float4 temp_cast_13 = (1.0).xxxx;
				float4 lerpResult481_g453 = lerp( max( float4( 0,0,0,0 ) , temp_output_366_0_g453 ) , temp_cast_13 , _NdLfade);
				float4 temp_output_368_0_g453 = ( temp_output_320_0_g453 * lerpResult481_g453 );
				float4 break337_g453 = temp_output_368_0_g453;
				float3 localLightColorZOne303_g453 = LightColorZOne();
				float3 localLightColorZTwo302_g453 = LightColorZTwo();
				float3 localLightColorZThree301_g453 = LightColorZThree();
				#ifdef UNITY_PASS_FORWARDBASE
				float3 staticSwitch2293 = ( ( localLightColorZero304_g453 * break337_g453.x ) + ( localLightColorZOne303_g453 * break337_g453.y ) + ( localLightColorZTwo302_g453 * break337_g453.z ) + ( localLightColorZThree301_g453 * break337_g453.w ) );
				#else
				float3 staticSwitch2293 = float3( 0,0,0 );
				#endif
				#ifdef VERTEXLIGHT_ON
				float3 staticSwitch2294 = staticSwitch2293;
				#else
				float3 staticSwitch2294 = float3( 0,0,0 );
				#endif
				float3 DiffuseVertexLighting2295 = staticSwitch2294;
				float3 FinalLight1989 = ( ( ase_lightColor.rgb * saturate( lerpResult2007 ) ) + gi1984.indirect.diffuse + DiffuseVertexLighting2295 );
				float4 switchResult2264 = (((ase_vface>0)?(( ( Color1917 + EdgeFoam1909 + EdgeWave2581 ) * float4( FinalLight1989 , 0.0 ) )):(float4( 0,0,0,0 ))));
				float time2546 = ( _Time1684 * 10.0 );
				float2 voronoiSmoothId2546 = 0;
				float switchResult2253 = (((ase_vface>0)?(_GrabPassDistortion):(( _GrabPassDistortion * 10.0 ))));
				float eyeDepth28_g463 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float2 temp_output_20_0_g463 = ( (Normals80).xy * ( switchResult2253 / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g463 - eyeDepth ) ) );
				float4 temp_output_7_0_g463 = ( float4( temp_output_20_0_g463, 0.0 , 0.0 ) + ase_screenPosNorm );
				float eyeDepth2_g463 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, temp_output_7_0_g463.xy ));
				float2 temp_output_32_0_g463 = (( float4( ( temp_output_20_0_g463 * saturate( ( eyeDepth2_g463 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float2 temp_output_1_0_g463 = ( ( floor( ( temp_output_32_0_g463 * (_CameraDepthTexture_TexelSize).zw ) ) + 0.5 ) * (_CameraDepthTexture_TexelSize).xy );
				float2 temp_output_2408_38 = temp_output_1_0_g463;
				float2 _refractUV1673 = temp_output_2408_38;
				float2 temp_output_73_0_g464 = _refractUV1673;
				float2 UV22_g465 = float4( temp_output_73_0_g464, 0.0 , 0.0 ).xy;
				float2 localUnStereo22_g465 = UnStereo( UV22_g465 );
				float2 break64_g464 = localUnStereo22_g465;
				float clampDepth76_g464 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( temp_output_73_0_g464, 0.0 , 0.0 ).xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g464 = ( 1.0 - clampDepth76_g464 );
				#else
				float staticSwitch38_g464 = clampDepth76_g464;
				#endif
				float3 appendResult39_g464 = (float3(break64_g464.x , break64_g464.y , staticSwitch38_g464));
				float4 appendResult42_g464 = (float4((appendResult39_g464*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g464 = mul( unity_CameraInvProjection, appendResult42_g464 );
				float3 In72_g464 = ( (temp_output_43_0_g464).xyz / (temp_output_43_0_g464).w );
				float3 localInvertDepthDir72_g464 = InvertDepthDir72_g464( In72_g464 );
				float4 appendResult49_g464 = (float4(localInvertDepthDir72_g464 , 1.0));
				float2 coords2546 = (mul( unity_CameraToWorld, appendResult49_g464 )).xz * _CausticsScale;
				float2 id2546 = 0;
				float2 uv2546 = 0;
				float voroi2546 = voronoi2546( coords2546, time2546, id2546, uv2546, 0, voronoiSmoothId2546 );
				float smoothstepResult2606 = smoothstep( 0.133 , 1.0 , voroi2546);
				float4 screenColor1646 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,temp_output_2408_38);
				float4 _distortion1672 = ( screenColor1646 * float4( FinalLight1989 , 0.0 ) );
				float4 temp_output_2609_0 = ( smoothstepResult2606 * _distortion1672 );
				float4 lerpResult2540 = lerp( temp_output_2609_0 , ( temp_output_2609_0 * 3.0 ) , saturate( pow( smoothstepResult2606 , 3.0 ) ));
				float4 emission1669 = ( ( ( max( ( lerpResult2540 * 2.0 ) , float4( 0,0,0,0 ) ) * _CausticIntensity * float4( FinalLight1989 , 0.0 ) ) * _depthMaskOpacity1652 ) + saturate( ( _distortion1672 * _depthMaskOpacity1652 ) ) );
				float4 lerpResult2278 = lerp( temp_output_1942_0 , temp_output_1950_0 , _BacksideWaterColor);
				float4 ColorBackside2279 = lerpResult2278;
				float fresnelNdotV2247 = dot( WorldNormal1915, worldViewDir );
				float fresnelNode2247 = ( _fresnelbias + _fresnelscale * pow( 1.0 - fresnelNdotV2247, _fresnelpower ) );
				float4 lerpResult2249 = lerp( ( ColorBackside2279 * float4( FinalLight1989 , 0.0 ) ) , _distortion1672 , ( 1.0 - saturate( fresnelNode2247 ) ));
				float4 switchResult2230 = (((ase_vface>0)?(emission1669):(lerpResult2249)));
				float3 worldPos2472 = worldPos;
				float3 viewDir2472 = worldViewDir;
				float3 normalDir2472 = WorldNormal1915;
				float3 albedo2472 = Color1917.rgb;
				float4 unityObjectToClipPos2465 = UnityObjectToClipPos( IN.ase_texcoord10.xyz );
				float4 computeGrabScreenPos2466 = ComputeGrabScreenPos( unityObjectToClipPos2465 );
				float4 screenPos2472 = computeGrabScreenPos2466;
				float3 localSSR2472 = SSR( worldPos2472 , viewDir2472 , normalDir2472 , albedo2472 , screenPos2472 );
				float3 switchResult2473 = (((ase_vface>0)?(localSSR2472):(float3( 0,0,0 ))));
				#ifdef _SSR_ON
				float3 staticSwitch2474 = switchResult2473;
				#else
				float3 staticSwitch2474 = float3( 0,0,0 );
				#endif
				float3 SSR2475 = staticSwitch2474;
				
				o.Albedo = temp_cast_0;
				o.Normal = fixed3( 0, 0, 1 );
				o.Emission = ( float4( BRDF1911 , 0.0 ) + switchResult2264 + switchResult2230 + float4( SSR2475 , 0.0 ) ).rgb;
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = 0;
				#endif
				o.Smoothness = -1.0;
				o.Occlusion = 0.0;
				o.Alpha = saturate( ( Opacity2548 + EdgeWave2581 ) );
				float AlphaClipThreshold = 0.5;
				float3 Transmission = 1;
				float3 Translucency = 1;		

				#ifdef _ALPHATEST_ON
					clip( o.Alpha - AlphaClipThreshold );
				#endif

				#ifdef _DEPTHOFFSET_ON
					outputDepth = IN.pos.z;
				#endif

				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif

				fixed4 c = 0;
				float3 worldN;
				worldN.x = dot(IN.tSpace0.xyz, o.Normal);
				worldN.y = dot(IN.tSpace1.xyz, o.Normal);
				worldN.z = dot(IN.tSpace2.xyz, o.Normal);
				worldN = normalize(worldN);
				o.Normal = worldN;

				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				gi.light.color = _LightColor0.rgb;
				gi.light.dir = lightDir;
				gi.light.color *= atten;

				#if defined(_SPECULAR_SETUP)
					c += LightingStandardSpecular( o, worldViewDir, gi );
				#else
					c += LightingStandard( o, worldViewDir, gi );
				#endif
				
				#ifdef _TRANSMISSION_ASE
				{
					float shadow = _TransmissionShadow;
					#ifdef DIRECTIONAL
						float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
					#else
						float3 lightAtten = gi.light.color;
					#endif
					half3 transmission = max(0 , -dot(o.Normal, gi.light.dir)) * lightAtten * Transmission;
					c.rgb += o.Albedo * transmission;
				}
				#endif

				#ifdef _TRANSLUCENCY_ASE
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#ifdef DIRECTIONAL
						float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
					#else
						float3 lightAtten = gi.light.color;
					#endif
					half3 lightDir = gi.light.dir + o.Normal * normal;
					half transVdotL = pow( saturate( dot( worldViewDir, -lightDir ) ), scattering );
					half3 translucency = lightAtten * (transVdotL * direct + gi.indirect.diffuse * ambient) * Translucency;
					c.rgb += o.Albedo * translucency * strength;
				}
				#endif

				//#ifdef _REFRACTION_ASE
				//	float4 projScreenPos = ScreenPos / ScreenPos.w;
				//	float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, WorldNormal ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
				//	projScreenPos.xy += refractionOffset.xy;
				//	float3 refraction = UNITY_SAMPLE_SCREENSPACE_TEXTURE( _GrabTexture, projScreenPos ) * RefractionColor;
				//	color.rgb = lerp( refraction, color.rgb, color.a );
				//	color.a = 1;
				//#endif

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
		}

	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
952;74;2382;901;-5259.525;-2131.481;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;2026;-2701,2480;Inherit;False;11273.96;967.5389;Originally made by PolyToots (https://www.patreon.com/posts/water-water-and-41716139) (https://www.youtube.com/c/PolyToots) changed it in some ways to make it work with the rest of the shader;8;1651;1634;1625;1629;1623;2151;1622;1624;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1624;-80,2528;Inherit;False;1593.12;428.3525;;10;1901;2259;2258;625;1684;1879;80;2402;2401;2514;Final Normal Maps;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1879;-48,2592;Inherit;False;Property;_UVTiling;UV Tiling;10;0;Fetch;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1622;-2658,2944;Inherit;False;1172.012;473.0353;;11;2604;2605;1683;1682;2025;1681;1679;2021;2023;1678;1699;tex3D Normal Map UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;2514;112,2592;Inherit;False;Normal scroll;29;;451;165ce0b77cdf01d4db68ed4aeb90cad2;0;1;68;FLOAT;0;False;5;FLOAT3;0;FLOAT2;83;FLOAT;87;FLOAT2;98;FLOAT;97
Node;AmplifyShaderEditor.CommentaryNode;2151;-1456,2528;Inherit;False;1329.842;717.3252;tex3D Normal Map with custom lod setup;20;2193;2207;2204;2198;2203;2209;2210;2118;2124;2117;2176;2121;2168;2132;2057;2058;1688;2531;2532;2533;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1699;-2496,3184;Inherit;False;Property;_UVTiling;UV Tiling;51;1;[HideInInspector];Fetch;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1684;416,2688;Inherit;False;_Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2193;-1408,2928;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureTransformNode;2604;-2624,3280;Inherit;False;2058;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;2021;-2304,3296;Inherit;False;1684;_Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2605;-2432,3280;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldPosInputsNode;1678;-2336,3008;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;2210;-1232,3072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2023;-2336,3184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;2118;-1216,2864;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1679;-2112,3184;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1681;-2112,3008;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2025;-2112,3296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2209;-1104,3008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2124;-1216,2720;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;2203;-1232,3152;Inherit;False;Property;_3DNormalLod;3D Normal Lod;42;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1623;-2112,2528;Inherit;False;634.9541;391.5852;side fix;3;1687;1686;1685;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;2207;-928,3008;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2198;-944,3152;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1682;-1888,3072;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;2117;-944,2832;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2204;-784,3008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1683;-1728,3056;Inherit;False;_3duvs;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1685;-2048,2576;Inherit;False;Property;_3DNormalScale;3D Normal Scale;41;0;Create;True;0;0;0;False;0;False;1;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1686;-1984,2736;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2176;-768,2832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.005;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2168;-608,2832;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1687;-1760,2656;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2058;-944,2592;Inherit;True;Property;_Normals_3D;Normals_3D;40;0;Create;True;0;0;0;False;0;False;04486b2b3df04f24482407db6cc193d1;04486b2b3df04f24482407db6cc193d1;False;bump;LockedToTexture3D;Texture3D;-1;0;2;SAMPLER3D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;1688;-720,2672;Inherit;False;1683;_3duvs;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;2057;-560,2608;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    //float3 dx = ddx(UV)@ //tex3D does not have mipmaps$    //float3 dy = ddy(UV)@ //tex3D does not have mipmaps$$    //blend samples with calculated weights$    return mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[0].xy), 0), 0, 0), Normalscale), BW_vx[3].x) + $            mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[1].xy), 0), 0, 0), Normalscale), BW_vx[3].y) + $            mul (UnpackScaleNormal(tex3D(_Normals_3D, UV + float3(hash2D2D(BW_vx[2].xy), 0), 0, 0), Normalscale), BW_vx[3].z)@;3;Create;3;True;tex;SAMPLER3D;0,0;In;;Float;False;True;UV;FLOAT3;0,0,0;In;;Float;False;True;Normalscale;FLOAT;0;In;;Inherit;False;tex3DStochasticNormals;False;False;1;7;;False;3;0;SAMPLER3D;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;2121;-448,2832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;2402;400,2768;Inherit;False;Property;_3DNormals;3D Normals Toggle;39;0;Create;False;0;0;0;False;1;ToggleUI;False;0;1;False;0;1;INT;0
Node;AmplifyShaderEditor.LerpOp;2132;-288,2784;Inherit;False;3;0;FLOAT3;0,0,1;False;1;FLOAT3;0,0,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1277;6064,1168;Inherit;False;1812.344;407.0662;;13;1260;2513;2512;2511;2510;2509;2508;2424;2422;1276;1284;1275;2519;Final Vertex Offset with Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1275;6112,1216;Inherit;True;Property;_VertexOffsetMask;Vertex Offset Mask;62;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;2401;640,2752;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1284;6432,1312;Inherit;False;VertexOffsetMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1265;3536,1088;Inherit;False;2449.882;791.8042;;31;1262;1251;1209;1210;1213;1212;1259;1211;1199;1201;1200;1203;1228;1202;1205;1243;1282;1278;1283;1244;1242;1279;1281;1280;1207;1208;1206;1285;2388;2389;2391;GerstnerWave;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;1901;816,2752;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;1206;3904,1216;Inherit;False;Property;_WaveA;WaveA dir, dir, steepness, wavelength;55;0;Create;False;0;0;0;False;0;False;1,0,0.5,0.00125;1,0,0.1,0.00125;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1285;3984,1792;Inherit;False;1284;VertexOffsetMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;1208;3904,1600;Inherit;False;Property;_WaveC;WaveC dir, dir, steepness, wavelength;57;0;Create;False;0;0;0;False;0;False;1,0,0.5,0.00125;1,0,0,0.00125;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;1207;3904,1408;Inherit;False;Property;_WaveB;WaveB dir, dir, steepness, wavelength;56;0;Create;False;0;0;0;False;0;False;1,0,0.5,0.00125;1,0,0,0.00125;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;2259;992,2816;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2258;1136,2752;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1280;4240,1472;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1244;3616,1600;Inherit;False;Constant;_Float2;Float 2;36;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1281;4240,1664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1242;3584,1504;Inherit;False;Property;_GerstnerHeight;Gerstner Height;58;0;Create;True;0;0;0;False;0;False;0;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1279;4240,1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;1312,2752;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;2029;-1933.783,1088;Inherit;False;2251.378;1274.59;;20;2603;2602;2601;2600;2599;2598;2597;1911;2412;2032;1918;2295;2294;2293;2030;2296;2372;1915;1897;1898;BRDF;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1228;4400,1152;Inherit;False;Property;_GerstnerSpeed;Gerstner Speed;60;0;Create;True;0;0;0;False;0;False;0.05;0.00333;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1282;4368,1408;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;1203;4496,1600;Inherit;False;Constant;_binormal;binormal;32;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;1202;4496,1408;Inherit;False;Constant;_tangent;tangent;32;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1243;3776,1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1283;4368,1600;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;1205;4496,1216;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;1278;4368,1216;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;543;558.4,1088;Inherit;False;1618.11;637.4212;;20;2496;928;438;747;746;743;411;412;626;415;1887;416;1003;1001;999;1000;1885;998;1886;2537;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;1199;4720,1216;Inherit;False;// Source: https://catlikecoding.com/unity/tutorials/flow/waves$float steepness = wave.z@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, p.xz) - c * _Time.y * Speed)@$float a = steepness / k@$tangent += float3($	-d.x * d.x * (steepness * sin(f)),$	d.x * (steepness * cos(f)),$	-d.x * d.y * (steepness * sin(f))$)@$binormal += float3($	-d.x * d.y * (steepness * sin(f)),$	d.y * (steepness * cos(f)),$	-d.y * d.y * (steepness * sin(f))$)@$return float3($	d.x * (a * cos(f)),$	a * sin(f) * Height,$	d.y * (a * cos(f))$)@;3;Create;6;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;True;p;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;0,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,0;InOut;;Inherit;False;True;Speed;FLOAT;0;In;;Inherit;False;True;Height;FLOAT;0;In;;Inherit;False;GerstnerWave;False;False;0;;False;6;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT3;0;FLOAT3;3;FLOAT3;4
Node;AmplifyShaderEditor.CustomExpressionNode;1200;4720,1408;Inherit;False;// Source: https://catlikecoding.com/unity/tutorials/flow/waves$float steepness = wave.z@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, p.xz) - c * _Time.y * Speed)@$float a = steepness / k@$tangent += float3($	-d.x * d.x * (steepness * sin(f)),$	d.x * (steepness * cos(f)),$	-d.x * d.y * (steepness * sin(f))$)@$binormal += float3($	-d.x * d.y * (steepness * sin(f)),$	d.y * (steepness * cos(f)),$	-d.y * d.y * (steepness * sin(f))$)@$return float3($	d.x * (a * cos(f)),$	a * sin(f) * Height,$	d.y * (a * cos(f))$)@;3;Create;6;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;True;p;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;0,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,0;InOut;;Inherit;False;True;Speed;FLOAT;0;In;;Inherit;False;True;Height;FLOAT;0;In;;Inherit;False;GerstnerWave;False;False;0;;False;6;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT3;0;FLOAT3;3;FLOAT3;4
Node;AmplifyShaderEditor.CustomExpressionNode;1201;4720,1600;Inherit;False;// Source: https://catlikecoding.com/unity/tutorials/flow/waves$float steepness = wave.z@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, p.xz) - c * _Time.y * Speed)@$float a = steepness / k@$tangent += float3($	-d.x * d.x * (steepness * sin(f)),$	d.x * (steepness * cos(f)),$	-d.x * d.y * (steepness * sin(f))$)@$binormal += float3($	-d.x * d.y * (steepness * sin(f)),$	d.y * (steepness * cos(f)),$	-d.y * d.y * (steepness * sin(f))$)@$return float3($	d.x * (a * cos(f)),$	a * sin(f) * Height,$	d.y * (a * cos(f))$)@;3;Create;6;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;True;p;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;0,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,0;InOut;;Inherit;False;True;Speed;FLOAT;0;In;;Inherit;False;True;Height;FLOAT;0;In;;Inherit;False;GerstnerWave;False;False;0;;False;6;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT3;0;FLOAT3;3;FLOAT3;4
Node;AmplifyShaderEditor.CommentaryNode;1629;3344,2528;Inherit;False;1621.543;565.14;;21;2497;2507;2506;2505;2504;2503;2502;2501;2500;2499;2498;1652;1649;1644;1640;1635;2409;1633;1636;1631;2596;DepthMasks;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1898;-1856,1312;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;998;736,1376;Inherit;False;Constant;_NoiseScaleOffset;Noise Scale Offset;48;0;Create;True;0;0;0;False;0;False;7.5,1.5,0,0;7.5,1.5,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;2596;3392,2800;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1211;4992,1280;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1886;592,1552;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;1897;-1696,1312;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;625;416,2592;Inherit;False;NormalVector;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1915;-1504,1312;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;2388;5232,1360;Inherit;False;Property;_GerstnerWavesToggle;Gerstner Waves Toggle;54;0;Create;True;0;0;0;True;3;Space(25);Header(Gerstner Waves _ Vertex Offset _ Tessellation);ToggleUI;False;0;1;False;0;1;INT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1000;928,1376;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1885;752,1584;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SurfaceDepthNode;1633;3568,2880;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1631;3504,2976;Inherit;False;Property;_Depth;Opacity Depth;7;0;Create;False;0;0;0;False;0;False;0.999;0.836;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1259;5120,1280;Inherit;False;GerstnerOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenDepthNode;2409;3632,2800;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;416;736,1264;Inherit;False;Constant;_NoiseSpeed;Noise Speed;47;0;Create;True;0;0;0;False;0;False;1.5;3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2372;-1296,1312;Inherit;False;Utilities;1;;453;039d2583fcc3ab544b6fd55efa3a137e;0;1;19;FLOAT3;0,0,0;False;40;FLOAT;0;FLOAT;14;FLOAT;17;FLOAT;15;FLOAT;16;FLOAT;60;FLOAT;62;FLOAT;63;FLOAT;64;FLOAT;65;FLOAT;13;FLOAT;446;FLOAT;18;FLOAT;114;FLOAT4;372;FLOAT4;373;FLOAT4;374;FLOAT4;375;FLOAT4;397;FLOAT4;376;FLOAT3;377;FLOAT3;378;FLOAT3;379;FLOAT3;380;FLOAT3;382;FLOAT3;384;FLOAT3;386;FLOAT3;388;FLOAT;381;FLOAT;383;FLOAT;385;FLOAT;387;FLOAT;389;FLOAT;390;FLOAT;391;FLOAT;392;FLOAT3;393;FLOAT3;394;FLOAT3;395;FLOAT3;396
Node;AmplifyShaderEditor.ConditionalIfNode;2389;5536,1216;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1635;3872,2816;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;626;992,1184;Inherit;False;625;NormalVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1887;1024,1264;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1001;928,1472;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;1636;3776,2976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;999;1056,1376;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1986;1280,-464;Inherit;False;1150.144;485.1869;;11;1989;1988;2297;1984;1985;2056;2007;2031;2282;1978;1987;Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2296;-816,1792;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2030;-816,1328;Inherit;False;NdL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;743;1152,1488;Inherit;False;625;NormalVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1625;1552,2528;Inherit;False;1753.765;363.6911;;10;1646;1673;1626;2253;2254;1627;1672;2290;2284;2408;Refraction + UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1640;4032,2816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2531;-608,2960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1003;1184,1376;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;2550;-2256,-592;Inherit;False;3469.612;669.329;Edited version of Takanu#8278 Concept;41;2591;2590;2589;2588;2587;2586;2585;2584;2583;2582;2581;2580;2579;2578;2577;2576;2575;2574;2573;2572;2571;2570;2569;2568;2567;2566;2565;2564;2563;2562;2561;2560;2559;2558;2557;2556;2555;2554;2553;2552;2551;Edge Wave;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;2537;1184,1184;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;415;1152,1264;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1276;6432,1216;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;746;1344,1472;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;412;1344,1168;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2031;1408,-288;Inherit;False;2030;NdL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1627;1568,2656;Inherit;False;Property;_GrabPassDistortion;GrabPass Distortion;8;0;Create;True;0;0;0;False;0;False;0.15;0.05;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;2293;-672,1792;Inherit;False;Property;_Keyword1;Keyword 1;42;0;Create;True;0;0;0;False;0;False;0;0;0;False;UNITY_PASS_FORWARDBASE;Toggle;2;Key0;Key1;Fetch;False;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2282;1312,-208;Inherit;False;Property;_NdLfade;NdL fade;9;0;Create;True;0;0;0;True;0;False;0.75;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2551;-2224,-128;Inherit;False;Property;_EdgeWaveSpeed;Edge Wave Speed;51;0;Create;True;0;0;0;False;0;False;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2532;-464,2960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2519;6576,1216;Inherit;False;GerstnerOffsetWithMask;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;438;1344,1328;Inherit;False;Constant;_WaveTiling;Wave Tiling;26;0;Create;True;0;0;0;False;0;False;0.01;1000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1644;4192,2816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2520;-64,-1040;Inherit;False;1322;294;Wave Height for fragment effects;9;2529;2528;2527;2526;2525;2524;2523;2522;2521;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;2529;-16,-992;Inherit;False;2519;GerstnerOffsetWithMask;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;2007;1600,-288;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2254;1872,2720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;2294;-384,1792;Inherit;False;Property;_Keyword1;Keyword 1;42;0;Create;True;0;0;0;False;0;False;0;0;0;False;VERTEXLIGHT_ON;Toggle;2;Key0;Key1;Fetch;False;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;2552;-1952,-128;Inherit;False;1;0;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2533;-336,2960;Inherit;False;LODDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1649;4352,2816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;95;-880,192;Inherit;False;2642.451;783.4632;;42;1909;54;1846;55;1823;372;1891;340;924;1857;1877;2041;1852;1894;389;631;344;346;1883;1858;1697;1851;2040;1854;1859;1890;87;1850;2483;2484;2485;2486;2487;2488;2489;2490;2491;2494;2495;2534;2535;2536;EdgeFoam;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;747;1536,1472;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;411;1536,1168;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1626;1984,2576;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1985;1632,-160;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2253;2016,2656;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2056;1744,-288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2295;-160,1792;Inherit;False;DiffuseVertexLighting;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1652;4544,2816;Inherit;False;_depthMaskOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;928;1824,1312;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2484;417,704;Inherit;False;Property;_EdgeFoamDistance;Edge Foam Distance;44;0;Create;True;0;0;0;False;0;False;0.5;0.836;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2554;-1904,-352;Inherit;False;Reconstruct World Position From Depth Morioh edit;-1;;461;faa6426e02b291840a1f94a0373d2fa1;0;1;73;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;2553;-1776,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2522;176,-864;Inherit;False;2533;LODDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2521;240,-992;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LightColorNode;1978;1728,-416;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;2297;1776,-80;Inherit;False;2295;DiffuseVertexLighting;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;1984;1792,-160;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2496;1968,1312;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2555;-1536,-496;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;2485;640,784;Inherit;False;1652;_depthMaskOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2486;705,704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1863;3648,448;Inherit;False;1652;_depthMaskOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2556;-1632,-48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1987;1904,-384;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2557;-1488,-352;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NegateNode;2558;-1632,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2523;384,-992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2408;2208,2592;Inherit;False;DepthMaskedRefraction;-1;;463;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.SimpleAddOpNode;1988;2080,-256;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;1634;5024,2528;Inherit;False;2277.158;422.7563;;21;2611;2610;2609;2608;2607;2606;1707;2538;2038;2289;2539;2541;2540;2547;2546;1641;1645;1643;2406;1638;1637;Caustics;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1673;2592,2768;Inherit;False;_refractUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1859;-400,800;Inherit;False;Property;_NormalMapdeformation;Normal Map deformation;47;0;Create;True;0;0;0;False;0;False;0.05;0.07;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1850;-608,400;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1890;-128,656;Inherit;False;2496;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1864;3872,448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;87;-832,240;Inherit;True;Property;_SeaFoam;SeaFoam;43;0;Create;True;0;0;0;False;2;Space(25);Header(EDGE FOAM);False;04ba2d0dd3fadef41a6e28103cb0e150;04ba2d0dd3fadef41a6e28103cb0e150;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2487;881,784;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2561;-1504,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2559;-1488,-208;Inherit;False;Property;_EdgeWaveFrequency;Edge Wave Frequency;50;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2562;-1632,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2560;-1488,-48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;2524;544,-992;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-2;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2563;-1344,-448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2564;-1200,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1989;2224,-256;Inherit;False;FinalLight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1637;5120,2624;Inherit;False;1673;_refractUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1865;4016,448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;16;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2525;688,-992;Inherit;False;VertexOffsetForEffects;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;346;-160,576;Inherit;False;Property;_EdgeFoamSpeed;Edge Foam Speed;45;0;Create;True;1;EDGE FOAM;0;0;False;0;False;0.025;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;2040;-608,304;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SaturateNode;1883;32,656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1697;-432,528;Inherit;False;Property;_UVTiling;UV Tiling;9;1;[HideInInspector];Fetch;True;0;0;0;False;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1854;-144,864;Inherit;False;80;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;1858;-112,736;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;2565;-1360,-128;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2489;1041,784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1851;-432,432;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ExpOpNode;2488;1057,704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2290;2768,2672;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;2406;5296,2624;Inherit;False;Reconstruct World Position From Depth Morioh edit;-1;;464;faa6426e02b291840a1f94a0373d2fa1;0;1;73;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;1646;2592,2592;Inherit;False;Global;_GrabTexture;GrabTexture;2;0;Create;True;0;0;0;False;0;False;Object;-1;True;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1638;5552,2704;Inherit;False;1684;_Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1894;160,672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2490;1201,688;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;10;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;344;32,576;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1852;48,800;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;631;16,496;Inherit;False;625;NormalVector;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2534;1201,816;Inherit;False;2525;VertexOffsetForEffects;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2548;4144,448;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2567;-1136,-352;Inherit;False;Property;_EdgeWaveOffset;Edge Wave Offset;52;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;-272,432;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2566;-1056,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1643;5696,2816;Inherit;False;Property;_CausticsScale;Caustics Scale;16;0;Create;True;0;0;0;False;0;False;3;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1641;5744,2704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;1645;5712,2624;Inherit;False;True;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2590;-432,-368;Inherit;False;2548;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2284;2944,2608;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1877;208,496;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2568;-928,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2041;-128,432;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;2491;1361,688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2535;1441,816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2569;-1136,-272;Inherit;False;Property;_EdgeWaveSharpness;Edge Wave Sharpness;49;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1857;288,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;2546;5920,2624;Inherit;True;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.OneMinusNode;2571;-272,-368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;924;368,432;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2536;1600,688;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1672;3104,2608;Inherit;False;_distortion;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2570;-592,-448;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.995;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2606;6112,2624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.133;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2573;-432,-448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2608;6112,2752;Inherit;False;Constant;_HFLH;HFLH;54;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2495;1693,642;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;340;528,256;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV)@$    float2 dy = ddy(UV)@$$    //blend samples with calculated weights$    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;2;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;tex2DStochastic;False;False;1;1778;;False;2;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;2547;6096,2832;Inherit;False;1672;_distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;2462;5216,352;Inherit;False;1491;665;;12;2420;2421;2414;2415;2416;2417;2418;2419;2436;2377;2378;2379;Tessellation;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;2572;-128,-368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2609;6288,2736;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;2607;6288,2624;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2574;32,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2414;5264,848;Inherit;False;Property;_VertOffsetDistMaskTessMaxxthis;Vert Offset Dist Mask TessMax x this;66;0;Create;True;0;0;0;False;0;False;0.85;0.85;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;827;1280,-1104;Inherit;False;968.0345;460.7963;;10;2274;1917;1939;2279;2278;1950;2281;1942;43;1948;Main Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;2494;1026,580;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;372;672,256;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;2591;192,-160;Inherit;False;2533;LODDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2377;5360,560;Inherit;False;Property;_TessMax;Tess Max Distance;65;0;Create;False;0;0;0;True;0;False;100;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2611;6432,2624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2610;6416,2736;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;2416;5376,688;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2415;5600,736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2578;-768,-272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2577;-768,-176;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2379;5360,480;Inherit;False;Property;_TessMin;Tess Min Distance;64;0;Create;False;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;1344,-1040;Inherit;False;Property;_Color;Color;3;1;[Header];Create;True;1;MAIN OPTIONS;0;0;False;0;False;0,0.4078431,0.6901961,1;0,0.405958,0.6886792,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1948;1344,-864;Inherit;False;Property;_ColorSecondary;Color Secondary;4;0;Create;True;1;MAIN OPTIONS;0;0;False;0;False;0,1,0.8705882,0.5019608;0,1,0.8716099,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1891;1088,512;Inherit;False;2496;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2527;896,-864;Inherit;False;1652;_depthMaskOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2526;944,-992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2576;368,-544;Inherit;False;Property;_ToggleEdgeWave;Toggle Edge Wave;48;0;Create;True;0;0;0;False;3;Space(25);Header(EDGE WAVE);ToggleUI;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2575;416,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1823;1120,304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2378;5312,400;Inherit;False;Property;_TessValue;TessValue;63;1;[IntRange];Create;True;0;0;0;True;0;False;1;60;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2540;6592,2576;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2541;6608,2688;Inherit;False;Constant;_Float5;Float 5;55;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2463;2624,-1520;Inherit;False;1588.387;1030.79;Code by error.mdl with changes from Mochie, Toocanzs and Xiexe;18;2481;2480;2479;2478;2477;2476;2475;2474;2473;2472;2471;2470;2469;2468;2467;2466;2465;2464;Screen Space Reflections;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1950;1584,-864;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;1120,400;Inherit;False;Property;_EdgePower;Edge Intensity;46;0;Create;False;0;0;0;False;0;False;0.75;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2483;1264,320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;2580;624,-512;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;2418;5984,720;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1846;1248,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2417;5760,688;Inherit;False;return UnityCalcDistanceTessFactor(vertex, minDist, maxDist, tess)@;1;Create;4;True;vertex;FLOAT4;0,0,0,0;In;;Inherit;False;True;minDist;FLOAT;0;In;;Inherit;False;True;maxDist;FLOAT;0;In;;Inherit;False;True;tess;FLOAT;1;In;;Inherit;False;Tess Distance;False;False;1;2436;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2528;1104,-992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2579;-592,-272;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.75;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1942;1584,-1040;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2581;1008,-512;Inherit;False;EdgeWave;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2582;-432,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2276;1840,192;Inherit;False;1002.941;540.8196;Backside refraction, transparency and Color over Fresnel;12;2261;2263;2269;2280;2249;2260;2251;2247;2248;2268;2267;2265;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2281;1568,-768;Inherit;False;Property;_BacksideWaterColor;Backside Water Color;11;1;[Header];Create;True;1;Backside;0;0;False;0;False;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1939;1856,-1040;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1651;7328,2528;Inherit;False;1211.385;460.9903;;8;1669;1667;1662;1663;1658;1659;1670;1655;Depth_Merged;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;2464;2672,-688;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2539;6752,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;2419;6128,688;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;1408,336;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2289;6864,2752;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1670;7552,2672;Inherit;False;1672;_distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1655;7552,2800;Inherit;False;1652;_depthMaskOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;2538;6912,2576;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2038;6832,2672;Inherit;False;Property;_CausticIntensity;Caustic Intensity;15;0;Create;True;0;0;0;False;2;Space(25);Header(CAUSTICS);False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;2465;2848,-688;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1917;2016,-1040;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2584;32,-272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1909;1552,336;Inherit;False;EdgeFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2598;-1136,1232;Inherit;False;2581;EdgeWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2597;-1136,1152;Inherit;False;2548;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2267;1888,544;Inherit;False;Property;_fresnelscale;fresnel scale;13;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2420;6304,688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2265;1888,464;Inherit;False;Property;_fresnelbias;fresnel bias;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2583;-96,-176;Inherit;False;Property;_EdgeWaveVertexOffset;Edge Wave Vertex Offset;53;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2268;1888,624;Inherit;False;Property;_fresnelpower;fresnel power;14;0;Create;True;0;0;0;False;0;False;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2278;1856,-896;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2248;1888,384;Inherit;False;1915;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2599;-960,1184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;2508;6896,1392;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2279;2016,-896;Inherit;False;ColorBackside;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2471;3040,-1136;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;2470;3040,-768;Inherit;False;1917;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1658;7776,2704;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1659;7344,2656;Inherit;False;1652;_depthMaskOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;2247;2112,464;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2421;6448,688;Inherit;False;TessellationDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeGrabScreenPosHlpNode;2466;3040,-688;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2469;3040,-992;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;2468;3040,-848;Inherit;False;1915;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1707;7088,2576;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2585;192,-272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2600;-848,1248;Inherit;False;1909;EdgeFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2472;3312,-960;Inherit;False;float NdotV = abs(dot(normalDir, viewDir))@$float omr = unity_ColorSpaceDielectricSpec.a * unity_ColorSpaceDielectricSpec.a@$float3 specularTint = lerp(unity_ColorSpaceDielectricSpec.rgb, 1, 0)@$float roughSq = 1-_Smoothness * 1-_Smoothness@$float roughBRDF = max(roughSq, 0.003)@	$float3 reflDir = reflect(-viewDir, normalDir)@$float surfaceReduction = 1.0 / (roughBRDF*roughBRDF + 1.0)@$float grazingTerm = saturate((_Smoothness) + (1-omr))@$float fresnel = FresnelLerp(specularTint, grazingTerm, NdotV)@$float3 reflCol = 0@$	half4 ssrCol = GetSSR(worldPos, reflDir, normalDir, albedo, screenPos)@$	ssrCol.rgb *= lerp(10, 7, linearstep(0,1,0))@$	//#if FOAM_ENABLED$	//	foamLerp = 1-foamLerp@$	//	foamLerp = smoothstep(0.7, 1, foamLerp)@$	//	ssrCol.a *= foamLerp@$	//#endif$	reflCol = lerp(reflCol, ssrCol.rgb, ssrCol.a)@$reflCol = reflCol * fresnel * surfaceReduction@$return reflCol@;3;Create;5;True;worldPos;FLOAT3;0,0,0;In;;Inherit;False;True;viewDir;FLOAT3;0,0,0;In;;Inherit;False;True;normalDir;FLOAT3;0,0,0;In;;Inherit;False;True;albedo;FLOAT3;0,0,0;In;;Inherit;False;True;screenPos;FLOAT4;0,0,0,0;In;;Inherit;False;SSR;False;False;1;2478;;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1212;4992,1408;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2280;2255,256;Inherit;False;2279;ColorBackside;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;2251;2352,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2586;416,-272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2422;6640,1312;Inherit;False;2421;TessellationDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1213;4992,1536;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;1662;7952,2704;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1663;7552,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;2509;7136,1392;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2602;-848,1184;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2510;7136,1472;Inherit;False;Constant;_Float0;Float 0;27;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2511;6896,1312;Inherit;False;Property;_VertexOffsetCameradistMask;Vertex Offset Camera dist Mask;61;0;Create;True;0;0;0;False;1;ToggleUI;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2601;-688,1248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2269;2272,336;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1667;8112,2576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2424;6896,1216;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2592;2848,112;Inherit;False;2581;EdgeWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;2587;624,-336;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1947;2848,32;Inherit;False;1909;EdgeFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2261;2464,384;Inherit;False;1672;_distortion;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;2260;2496,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2263;2480,288;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;2512;7280,1312;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1933;2848,-48;Inherit;False;1917;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CrossProductOpNode;1210;5168,1472;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2032;-624,1328;Inherit;False;1915;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1918;-592,1408;Inherit;False;1917;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMinOpNode;2603;-544,1184;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2473;3552,-960;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;2249;2656,352;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;1251;5328,1552;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2513;7472,1216;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;2474;3744,-960;Inherit;False;Property;_SSR;SSR (performance heavy);27;0;Create;False;0;0;0;True;1;Header(Screen Space Reflections by error.mdl);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;2588;816,-336;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1669;8320,2576;Inherit;False;emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1990;3024,-96;Inherit;False;1989;FinalLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;1209;5328,1472;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;2412;-400,1328;Inherit;False;BRDF;17;;466;c8238fd52fdf6e048bf6236ff19fd3bd;0;7;2935;FLOAT;1;False;86;FLOAT3;0,0,0;False;89;FLOAT3;1,1,1;False;1847;FLOAT;0;False;2409;FLOAT;0;False;2671;FLOAT;0;False;2411;FLOAT;0;False;2;FLOAT3;0;FLOAT;2705
Node;AmplifyShaderEditor.SimpleAddOpNode;288;3072,-16;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2589;960,-336;Inherit;False;EdgeWaveVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2475;4000,-960;Inherit;False;SSR;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;2391;5536,1440;Inherit;False;False;5;0;FLOAT;1;False;1;INT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2593;4160,528;Inherit;False;2581;EdgeWave;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1911;64,1328;Inherit;False;BRDF;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1260;7632,1216;Inherit;False;FinalVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1691;3184,80;Inherit;False;1669;emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2387;2878.327,251.322;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2003;3216,-16;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1775;4672,-736;Inherit;False;395.8096;144.2545;Stochastic Hash, source: https://redd.it/dhr5g2;1;1778;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2264;3360,-16;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1912;3376,-112;Inherit;False;1911;BRDF;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1262;5744,1440;Inherit;False;FinalVertexNormals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2482;3376,176;Inherit;False;2475;SSR;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;2230;3360,80;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2594;4240,688;Inherit;False;2589;EdgeWaveVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2549;4352,448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1261;4272,608;Inherit;False;1260;FinalVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;2506;4592,2640;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2459;4576,-192;Inherit;False;Constant;_Float7;Float 7;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2480;3248,-1264;Inherit;False;#if SSR_ENABLED$	#if UNITY_SINGLE_PASS_STEREO$		half x_min = 0.5*unity_StereoEyeIndex@$		half x_max = 0.5 + 0.5*unity_StereoEyeIndex@$	#else$		half x_min = 0.0@$		half x_max = 1.0@$	#endif$	$	reflectedRay = mul(UNITY_MATRIX_V, float4(reflectedRay, 1))@$	rayDir = mul(UNITY_MATRIX_V, float4(rayDir, 0))@$	int totalIterations = 0@$	int direction = 1@$	float3 finalPos = 0@$	float step = 0.09@$	float lRad = 0.2@$	float sRad = 0.02@$$	[loop] for (int i = 0@ i < 50@ i++){$		totalIterations = i@$		float4 spos = ComputeGrabScreenPos(mul(UNITY_MATRIX_P, float4(reflectedRay, 1)))@$		float2 uvDepth = spos.xy / spos.w@$		UNITY_BRANCH$		if (uvDepth.x > x_max || uvDepth.x < x_min || uvDepth.y > 1 || uvDepth.y < 0){$			break@$		}$$		float rawDepth = DecodeFloatRG(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_CameraDepthTexture, uvDepth))@$		float linearDepth = Linear01Depth(rawDepth)@$		float sampleDepth = -reflectedRay.z@$		float realDepth = linearDepth * _ProjectionParams.z@$		float depthDifference = abs(sampleDepth - realDepth)@$$		if (depthDifference < lRad){ $			if (direction == 1){$				if(sampleDepth > (realDepth - sRad)){$					if(sampleDepth < (realDepth + sRad)){$						finalPos = reflectedRay@$						break@$					}$					direction = -1@$					step = step*0.1@$				}$			}$			else {$				if(sampleDepth < (realDepth + sRad)){$					direction = 1@$					step = step*0.1@$				}$			}$		}$		reflectedRay = reflectedRay + direction*step*rayDir@$		step += step*(0.025 + 0.005*noise)@$		lRad += lRad*(0.025 + 0.005*noise)@$		sRad += sRad*(0.025 + 0.005*noise)@$	}$	return float4(finalPos, totalIterations)@$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;4;Create;3;True;reflectedRay;FLOAT3;0,0,0;In;;Inherit;False;True;rayDir;FLOAT3;0,0,0;In;;Inherit;False;True;noise;FLOAT;0;In;;Inherit;False;ReflectRay;False;True;0;;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;1866;4480,448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;4736,-192;Inherit;False;Property;_ShaderOptimizerEnabled;PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER;0;0;Create;False;0;0;0;True;1;ShaderOptimizerLockButton;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2503;4288,2640;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;353;4752,-368;Inherit;False;Property;_NormalScaleAnimated;Normal Scale Animated;67;1;[HideInInspector];Create;True;0;0;0;True;1;ToggleUI;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;2530;4800,-560;Inherit;False;Property;_ZWrite;ZWrite;6;1;[Enum];Create;True;0;2;Off;0;On;1;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1263;4480,768;Inherit;False;1262;FinalVertexNormals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2479;3104,-1472;Inherit;True;Property;_NoiseTexSSR;Noise Tex SSR;69;1;[HideInInspector];Create;True;0;0;0;True;1;NonModifiableTextureData;False;-1;38e7d156069d4b345842d760866b8411;38e7d156069d4b345842d760866b8411;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;383;4800,-848;Inherit;False;Property;_UVTiling;UV Tiling;8;0;Create;True;0;0;0;True;0;False;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2436;5744,832;Inherit;False;    float3 wpos = mul(unity_ObjectToWorld,vertex).xyz@$    float dist = distance (wpos, _WorldSpaceCameraPos)@$    float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess@$    return f@$;1;Create;4;True;vertex;FLOAT4;0,0,0,0;In;;Inherit;False;True;minDist;FLOAT;0;In;;Inherit;False;True;maxDist;FLOAT;0;In;;Inherit;False;True;tess;FLOAT;0;In;;Inherit;False;UnityCalcDistanceTessFactor;False;True;0;;False;4;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2497;3392,2624;Inherit;False;2467;UVGrab;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;2501;4016,2640;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2467;3280,-688;Inherit;False;UVGrab;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;2481;3456,-1376;Inherit;False;Property;_EdgeFadeSSR;Edge Fade SSR;28;0;Create;True;0;0;0;True;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1977;3584,0;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;2500;3872,2640;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode;2461;3728,-96;Inherit;False;1311.017;374.2745;IMPORTANT;;1,1,1,1;Grabpass Texture causes issues with the Lit Template, for frequent changes unplug the grabpass, after final compile do this:$CHANGE THIS:$#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)$			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)@$			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)$$$$$TO THIS IN BASE AND ADD PASS:$#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)$			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)@$			#else$			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)$			#endif;0;0
Node;AmplifyShaderEditor.CustomExpressionNode;2477;3040,-1264;Inherit;False;#if SSR_ENABLED$	float2 pixSize = 2/texelSize@$	float center = floor(dim*0.5)@$	float3 refTotal = float3(0,0,0)@$	for (int i = 0@ i < floor(dim)@ i++){$		[loop] for (int j = 0@ j < floor(dim)@ j++){$			float4 refl = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture, float2(uvs.x + pixSize.x*(i-center), uvs.y + pixSize.y*(j-center)))@$			refTotal += refl.rgb@$		}$	}$	return refTotal/(floor(dim)*floor(dim))@$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;3;Create;3;True;texelSize;FLOAT2;0,0;In;;Inherit;False;True;uvs;FLOAT2;0,0;In;;Inherit;False;True;dim;FLOAT;0;In;;Inherit;False;GetBlurredGP;False;True;0;;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;2478;2880,-1264;Inherit;False;#if SSR_ENABLED$	x = clamp((x - j) / (k - j), 0.0, 1.0)@ $	return x@$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;3;Create;3;True;j;FLOAT3;0,0,0;In;;Inherit;False;True;k;FLOAT3;0,0,0;In;;Inherit;False;True;x;FLOAT3;0,0,0;In;;Inherit;False;linearstep;False;True;0;;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2595;4496,640;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2507;4736,2640;Inherit;False;_depthMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2449;4464,288;Inherit;False;Constant;_Float1;Float 1;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2476;3488,-1264;Inherit;False;#if SSR_ENABLED$	float FdotR = dot(faceNormal, rayDir.xyz)@$	UNITY_BRANCH$	if (unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f  || FdotR < 0){$		return 0@$	}$	else {$		float4 noiseUvs = screenPos@$		noiseUvs.xy = (noiseUvs.xy * _GrabTexture_TexelSize.zw) / (_NoiseTexSSR_TexelSize.zw * noiseUvs.w)@	$		float4 noiseRGBA = tex2Dlod(_NoiseTexSSR, float4(noiseUvs.xy,0,0))@$		float noise = noiseRGBA.r@$		$		float3 reflectedRay = wPos + (0.2*0.09/FdotR + noise*0.09)*rayDir@$		float4 finalPos = ReflectRay(reflectedRay, rayDir, noise)@$		float totalSteps = finalPos.w@$		finalPos.w = 1@$		$		if (!any(finalPos.xyz)){$			return 0@$		}$		$		float4 uvs = UNITY_PROJ_COORD(ComputeGrabScreenPos(mul(UNITY_MATRIX_P, finalPos)))@$		uvs.xy = uvs.xy / uvs.w@$		$		#if UNITY_SINGLE_PASS_STEREO$			float xfade = 1@$		#else$			float xfade = smoothstep(0, _EdgeFadeSSR, uvs.x) * smoothstep(1, 1-_EdgeFadeSSR, uvs.x)@ //Fade x uvs out towards the edges$		#endif$		float yfade = smoothstep(0, _EdgeFadeSSR, uvs.y)*smoothstep(1, 1-_EdgeFadeSSR, uvs.y)@ //Same for y$		float lengthFade = smoothstep(1, 0, 2*(totalSteps / 50)-1)@$		$		float blurFac = max(1,min(12, 12 * (-2)*(_Smoothness-1)))@$		float4 reflection = float4(GetBlurredGP(_GrabTexture_TexelSize.zw, uvs.xy, blurFac*1.5),1)@$		reflection.rgb = lerp(reflection.rgb, reflection.rgb*albedo.rgb,smoothstep(0, 1.75, 0))@$		reflection.a = FdotR * xfade * yfade * lengthFade@$		return max(0,reflection)@$		}$#else //SSR_ENABLED$return 0@$#endif //SSR_ENABLED;4;Create;5;True;wPos;FLOAT3;0,0,0;In;;Inherit;False;True;rayDir;FLOAT3;0,0,0;In;;Inherit;False;True;faceNormal;FLOAT3;0,0,0;In;;Inherit;False;True;albedo;FLOAT3;0,0,0;In;;Inherit;False;True;screenPos;FLOAT4;0,0,0,0;In;;Inherit;False;GetSSR;False;True;2;2477;2480;;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;1778;4816,-688;Float;False;return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453)@;2;Create;1;True;s;FLOAT2;0,0;In;;Float;False;hash2D2D;False;True;0;;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;2502;4144,2640;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2498;3552,2624;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CustomExpressionNode;2499;3680,2672;Inherit;False;return UNITY_Z_0_FAR_FROM_CLIPSPACE(In0)@;1;Create;1;True;In0;FLOAT;0;In;;Inherit;False;SurfaceDepth;False;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2504;4240,2720;Inherit;False;Property;_GeneralDepth;General Depth;59;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;2413;4800,-464;Inherit;False;Property;_Cull;Cull;5;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;False;0;1;INT;0
Node;AmplifyShaderEditor.PowerNode;2505;4432,2640;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2460;4464,368;Inherit;False;Constant;_Float6;Float 6;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2274;1584,-944;Inherit;False;2507;_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;352;4736,-272;Inherit;False;Property;_NormalScaleSecondaryAnimated;Normal Scale Secondary Animated;68;1;[HideInInspector];Create;True;0;0;0;True;1;ToggleUI;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2431;3744,48;Float;False;False;-1;2;ASEMaterialInspector;0;10;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2427;3760,-176;Float;False;False;-1;2;ASEMaterialInspector;0;10;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2432;3744,48;Float;False;False;-1;2;ASEMaterialInspector;0;10;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2429;3744,48;Float;False;False;-1;2;ASEMaterialInspector;0;10;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;True;4;5;False;-1;1;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2430;3744,48;Float;False;False;-1;2;ASEMaterialInspector;0;10;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;True;2;True;17;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;xboxseries;ps4;playstation;psp2;n3ds;wiiu;switch;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2428;4768,-48;Float;False;True;-1;2;ASEMaterialInspector;0;10;Moriohs Shaders/Enviroment Shaders/Water SPSI;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;18;True;True;0;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;0;True;2413;True;True;True;True;True;False;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;True;2530;True;7;False;-1;False;True;5;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;DisableBatching=False=DisableBatching;IgnoreProjector=True;PreviewType=Plane;True;7;False;0;False;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;13;Include;;False;;Native;Custom;//Vertex Lights;False;;Custom;Custom;#pragma multi_compile _ VERTEXLIGHT_ON;False;;Custom;Custom;//MSAA artifact fix;False;;Custom;Custom;#if defined(SHADER_STAGE_VERTEX) || defined(SHADER_STAGE_FRAGMENT) || defined(SHADER_STAGE_DOMAIN) || defined(SHADER_STAGE_HULL) || defined(SHADER_STAGE_GEOMETRY);False;;Custom;Custom;#if !defined(UNITY_PASS_DEFERRED) //ASEnodel1;False;;Custom;Custom;#define TEXCOORD9 TEXCOORD9_Centroid;False;;Custom;Custom;#endif //ASEnodel2;False;;Custom;Custom;#endif //ASEnodel3;False;;Custom;Custom;//SSR defines;False;;Custom;Custom;float4 _GrabTexture_TexelSize@;False;;Custom;Custom;float4 _NoiseTexSSR_TexelSize@;False;;Custom;Custom;#define SSR_ENABLED	defined(_SSR_ON) && !defined(UNITY_PASS_FORWARDADD);False;;Custom;;0;0;Standard;40;Workflow,InvertActionOnDeselection;1;0;Surface;1;637933256336624082;  Blend;0;637939457914138783;  Refraction Model;0;0;  Dither Shadows;0;637939457558927244;Two Sided;1;0;Deferred Pass;0;637933256267964107;Transmission;0;0;  Transmission Shadow;0.5,False,-1;0;Translucency;0;0;  Translucency Strength;1,False,-1;0;  Normal Distortion;0.5,False,-1;0;  Scattering;2,False,-1;0;  Direct;0.9,False,-1;0;  Ambient;0.1,False,-1;0;  Shadow;0.5,False,-1;0;Cast Shadows;0;637933256150712866;  Use Shadow Threshold;0;0;Receive Shadows;0;637933256171248026;GPU Instancing;1;0;LOD CrossFade;0;637933256195598023;Built-in Fog;1;0;Ambient Light;1;0;Meta Pass;0;637933261089868312;Add Pass;1;0;Override Baked GI;0;637933270539200725;Extra Pre Pass;0;637933261176438317;Tessellation;1;637933261859660446;  Phong;0;0;  Strength;0.5,False,-1;0;  Type;1;637933261879270465;  Tess;16,True,2378;637933262260121560;  Min;10,True,2379;637933262512267519;  Max;25,True,2377;637933262559863697;  Edge Length;16,False,-1;0;  Max Displacement;25,False,-1;0;Fwd Specular Highlights Toggle;0;637933891135743510;Fwd Reflections Toggle;0;637933891133193518;Disable Batching;0;637939451110279504;Vertex Position,InvertActionOnDeselection;1;0;0;6;False;True;True;False;False;False;False;;False;0
WireConnection;2514;68;1879;0
WireConnection;1684;0;2514;87
WireConnection;2605;0;2604;0
WireConnection;2210;0;2193;3
WireConnection;2023;0;1699;0
WireConnection;1679;0;1678;3
WireConnection;1679;1;2023;0
WireConnection;1679;2;2605;1
WireConnection;1681;0;1678;1
WireConnection;1681;1;2023;0
WireConnection;1681;2;2605;0
WireConnection;2025;0;2021;0
WireConnection;2209;0;2193;3
WireConnection;2209;1;2210;0
WireConnection;2207;0;2209;0
WireConnection;2198;0;2203;0
WireConnection;1682;0;1681;0
WireConnection;1682;1;1679;0
WireConnection;1682;2;2025;0
WireConnection;2117;0;2124;0
WireConnection;2117;1;2118;0
WireConnection;2204;0;2207;0
WireConnection;2204;1;2198;0
WireConnection;1683;0;1682;0
WireConnection;2176;0;2117;0
WireConnection;2168;0;2176;0
WireConnection;2168;2;2204;0
WireConnection;1687;1;1685;0
WireConnection;1687;2;1686;2
WireConnection;2057;0;2058;0
WireConnection;2057;1;1688;0
WireConnection;2057;2;1687;0
WireConnection;2121;0;2168;0
WireConnection;2132;0;2057;0
WireConnection;2132;2;2121;0
WireConnection;2401;1;2402;0
WireConnection;2401;2;2514;0
WireConnection;2401;3;2132;0
WireConnection;1284;0;1275;2
WireConnection;1901;0;2401;0
WireConnection;2259;0;1901;0
WireConnection;2258;0;1901;0
WireConnection;2258;1;2259;0
WireConnection;1280;0;1207;3
WireConnection;1280;1;1285;0
WireConnection;1281;0;1208;3
WireConnection;1281;1;1285;0
WireConnection;1279;0;1206;3
WireConnection;1279;1;1285;0
WireConnection;80;0;2258;0
WireConnection;1282;0;1207;1
WireConnection;1282;1;1207;2
WireConnection;1282;2;1280;0
WireConnection;1282;3;1207;4
WireConnection;1243;0;1242;0
WireConnection;1243;1;1244;0
WireConnection;1283;0;1208;1
WireConnection;1283;1;1208;2
WireConnection;1283;2;1281;0
WireConnection;1283;3;1208;4
WireConnection;1278;0;1206;1
WireConnection;1278;1;1206;2
WireConnection;1278;2;1279;0
WireConnection;1278;3;1206;4
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
WireConnection;1211;0;1199;0
WireConnection;1211;1;1200;0
WireConnection;1211;2;1201;0
WireConnection;1897;0;1898;0
WireConnection;625;0;2514;83
WireConnection;1915;0;1897;0
WireConnection;1000;0;998;1
WireConnection;1000;1;998;2
WireConnection;1885;0;1886;1
WireConnection;1885;1;1886;3
WireConnection;1259;0;1211;0
WireConnection;2409;0;2596;0
WireConnection;2372;19;1915;0
WireConnection;2389;1;2388;0
WireConnection;2389;3;1259;0
WireConnection;1635;0;2409;0
WireConnection;1635;1;1633;0
WireConnection;1887;0;416;0
WireConnection;1001;0;998;3
WireConnection;1001;1;998;4
WireConnection;1636;0;1631;0
WireConnection;999;0;1000;0
WireConnection;999;1;1885;0
WireConnection;2296;0;2372;377
WireConnection;2296;1;2372;378
WireConnection;2296;2;2372;379
WireConnection;2296;3;2372;380
WireConnection;2030;0;2372;0
WireConnection;1640;0;1635;0
WireConnection;1640;1;1636;0
WireConnection;2531;0;2176;0
WireConnection;1003;0;999;0
WireConnection;1003;1;1001;0
WireConnection;2537;0;626;0
WireConnection;415;0;1887;0
WireConnection;1276;0;2389;0
WireConnection;1276;1;1275;2
WireConnection;746;0;1003;0
WireConnection;746;2;743;0
WireConnection;746;1;415;0
WireConnection;412;0;1003;0
WireConnection;412;2;2537;0
WireConnection;412;1;415;0
WireConnection;2293;0;2296;0
WireConnection;2532;0;2531;0
WireConnection;2519;0;1276;0
WireConnection;1644;0;1640;0
WireConnection;2007;0;2031;0
WireConnection;2007;2;2282;0
WireConnection;2254;0;1627;0
WireConnection;2294;0;2293;0
WireConnection;2552;0;2551;0
WireConnection;2533;0;2532;0
WireConnection;1649;0;1644;0
WireConnection;747;0;746;0
WireConnection;747;1;438;0
WireConnection;411;0;412;0
WireConnection;411;1;438;0
WireConnection;2253;0;1627;0
WireConnection;2253;1;2254;0
WireConnection;2056;0;2007;0
WireConnection;2295;0;2294;0
WireConnection;1652;0;1649;0
WireConnection;928;0;411;0
WireConnection;928;1;747;0
WireConnection;2553;0;2552;0
WireConnection;2521;0;2529;0
WireConnection;1984;0;1985;0
WireConnection;2496;0;928;0
WireConnection;2486;0;2484;0
WireConnection;2556;0;2553;0
WireConnection;1987;0;1978;1
WireConnection;1987;1;2056;0
WireConnection;2557;0;2554;0
WireConnection;2558;0;2553;0
WireConnection;2523;0;2521;1
WireConnection;2523;1;2522;0
WireConnection;2408;35;1626;0
WireConnection;2408;37;2253;0
WireConnection;1988;0;1987;0
WireConnection;1988;1;1984;0
WireConnection;1988;2;2297;0
WireConnection;1673;0;2408;38
WireConnection;1864;0;1863;0
WireConnection;2487;0;2485;0
WireConnection;2487;1;2486;0
WireConnection;2561;0;2558;0
WireConnection;2562;0;2553;0
WireConnection;2560;0;2556;0
WireConnection;2524;0;2523;0
WireConnection;2563;0;2555;2
WireConnection;2563;1;2557;1
WireConnection;2564;0;2563;0
WireConnection;2564;1;2559;0
WireConnection;1989;0;1988;0
WireConnection;1865;0;1864;0
WireConnection;2525;0;2524;0
WireConnection;2040;0;87;0
WireConnection;1883;0;1890;0
WireConnection;1858;2;1859;0
WireConnection;2565;0;2561;0
WireConnection;2565;1;2562;0
WireConnection;2565;2;2560;0
WireConnection;2489;0;2487;0
WireConnection;1851;0;1850;1
WireConnection;1851;1;1850;3
WireConnection;2488;0;2486;0
WireConnection;2406;73;1637;0
WireConnection;1646;0;2408;38
WireConnection;1894;0;1883;0
WireConnection;2490;1;2488;0
WireConnection;2490;2;2489;0
WireConnection;344;0;346;0
WireConnection;1852;0;1858;0
WireConnection;1852;1;1854;0
WireConnection;2548;0;1865;0
WireConnection;389;0;2040;0
WireConnection;389;1;1851;0
WireConnection;389;2;1697;0
WireConnection;2566;0;2564;0
WireConnection;2566;1;2565;0
WireConnection;1641;0;1638;0
WireConnection;1645;0;2406;0
WireConnection;2284;0;1646;0
WireConnection;2284;1;2290;0
WireConnection;1877;0;631;0
WireConnection;1877;1;344;0
WireConnection;2568;0;2566;0
WireConnection;2568;1;2567;0
WireConnection;2041;0;389;0
WireConnection;2041;1;2040;1
WireConnection;2491;0;2490;0
WireConnection;2535;0;2534;0
WireConnection;1857;0;1894;0
WireConnection;1857;1;1852;0
WireConnection;2546;0;1645;0
WireConnection;2546;1;1641;0
WireConnection;2546;2;1643;0
WireConnection;2571;0;2590;0
WireConnection;924;0;2041;0
WireConnection;924;1;1877;0
WireConnection;924;2;1857;0
WireConnection;2536;0;2491;0
WireConnection;2536;1;2535;0
WireConnection;1672;0;2284;0
WireConnection;2570;0;2568;0
WireConnection;2570;1;2569;0
WireConnection;2606;0;2546;0
WireConnection;2573;0;2570;0
WireConnection;2495;0;2536;0
WireConnection;340;0;87;0
WireConnection;340;1;924;0
WireConnection;2572;0;2571;0
WireConnection;2609;0;2606;0
WireConnection;2609;1;2547;0
WireConnection;2607;0;2606;0
WireConnection;2607;1;2608;0
WireConnection;2574;0;2573;0
WireConnection;2574;1;2572;0
WireConnection;2494;0;2495;0
WireConnection;372;0;340;0
WireConnection;2611;0;2607;0
WireConnection;2610;0;2609;0
WireConnection;2610;1;2608;0
WireConnection;2415;0;2377;0
WireConnection;2415;1;2414;0
WireConnection;2578;0;2568;0
WireConnection;2577;0;2569;0
WireConnection;2526;0;2525;0
WireConnection;2575;0;2574;0
WireConnection;2575;1;2591;0
WireConnection;1823;0;372;1
WireConnection;1823;1;2494;0
WireConnection;2540;0;2609;0
WireConnection;2540;1;2610;0
WireConnection;2540;2;2611;0
WireConnection;1950;0;1948;0
WireConnection;1950;1;1948;4
WireConnection;2483;0;1823;0
WireConnection;2580;0;2576;0
WireConnection;2580;3;2575;0
WireConnection;2418;0;2378;0
WireConnection;1846;0;1891;0
WireConnection;2417;0;2416;0
WireConnection;2417;1;2379;0
WireConnection;2417;2;2415;0
WireConnection;2417;3;2378;0
WireConnection;2528;0;2526;0
WireConnection;2528;1;2527;0
WireConnection;2579;0;2578;0
WireConnection;2579;1;2577;0
WireConnection;1942;0;43;0
WireConnection;1942;1;43;4
WireConnection;2581;0;2580;0
WireConnection;2582;0;2579;0
WireConnection;1939;0;1942;0
WireConnection;1939;1;1950;0
WireConnection;1939;2;2528;0
WireConnection;2539;0;2540;0
WireConnection;2539;1;2541;0
WireConnection;2419;0;2417;0
WireConnection;2419;1;2418;0
WireConnection;54;0;2483;0
WireConnection;54;1;55;0
WireConnection;54;2;1846;0
WireConnection;2538;0;2539;0
WireConnection;2465;0;2464;0
WireConnection;1917;0;1939;0
WireConnection;2584;0;2582;0
WireConnection;2584;1;2572;0
WireConnection;1909;0;54;0
WireConnection;2420;0;2419;0
WireConnection;2278;0;1942;0
WireConnection;2278;1;1950;0
WireConnection;2278;2;2281;0
WireConnection;2599;0;2597;0
WireConnection;2599;1;2598;0
WireConnection;2279;0;2278;0
WireConnection;1658;0;1670;0
WireConnection;1658;1;1655;0
WireConnection;2247;0;2248;0
WireConnection;2247;1;2265;0
WireConnection;2247;2;2267;0
WireConnection;2247;3;2268;0
WireConnection;2421;0;2420;0
WireConnection;2466;0;2465;0
WireConnection;1707;0;2538;0
WireConnection;1707;1;2038;0
WireConnection;1707;2;2289;0
WireConnection;2585;0;2584;0
WireConnection;2585;1;2583;0
WireConnection;2472;0;2471;0
WireConnection;2472;1;2469;0
WireConnection;2472;2;2468;0
WireConnection;2472;3;2470;0
WireConnection;2472;4;2466;0
WireConnection;1212;0;1199;3
WireConnection;1212;1;1200;3
WireConnection;1212;2;1201;3
WireConnection;2251;0;2247;0
WireConnection;2586;0;2585;0
WireConnection;2586;1;2591;0
WireConnection;1213;0;1199;4
WireConnection;1213;1;1200;4
WireConnection;1213;2;1201;4
WireConnection;1662;0;1658;0
WireConnection;1663;0;1707;0
WireConnection;1663;1;1659;0
WireConnection;2509;0;2508;0
WireConnection;2602;0;2599;0
WireConnection;2601;0;2600;0
WireConnection;1667;0;1663;0
WireConnection;1667;1;1662;0
WireConnection;2424;0;2519;0
WireConnection;2424;1;2422;0
WireConnection;2587;0;2576;0
WireConnection;2587;3;2586;0
WireConnection;2260;0;2251;0
WireConnection;2263;0;2280;0
WireConnection;2263;1;2269;0
WireConnection;2512;0;2511;0
WireConnection;2512;3;2509;0
WireConnection;2512;4;2510;0
WireConnection;1210;0;1213;0
WireConnection;1210;1;1212;0
WireConnection;2603;0;2602;0
WireConnection;2603;1;2601;0
WireConnection;2473;0;2472;0
WireConnection;2249;0;2263;0
WireConnection;2249;1;2261;0
WireConnection;2249;2;2260;0
WireConnection;2513;0;2424;0
WireConnection;2513;1;2512;0
WireConnection;2474;0;2473;0
WireConnection;2588;1;2587;0
WireConnection;1669;0;1667;0
WireConnection;1209;0;1210;0
WireConnection;2412;2935;2603;0
WireConnection;2412;86;2032;0
WireConnection;2412;89;1918;0
WireConnection;2412;2409;2372;14
WireConnection;2412;2671;2372;446
WireConnection;2412;2411;2372;15
WireConnection;288;0;1933;0
WireConnection;288;1;1947;0
WireConnection;288;2;2592;0
WireConnection;2589;0;2588;0
WireConnection;2475;0;2474;0
WireConnection;2391;1;2388;0
WireConnection;2391;2;1251;0
WireConnection;2391;3;1209;0
WireConnection;1911;0;2412;0
WireConnection;1260;0;2513;0
WireConnection;2387;0;2249;0
WireConnection;2003;0;288;0
WireConnection;2003;1;1990;0
WireConnection;2264;0;2003;0
WireConnection;1262;0;2391;0
WireConnection;2230;0;1691;0
WireConnection;2230;1;2387;0
WireConnection;2549;0;2548;0
WireConnection;2549;1;2593;0
WireConnection;2506;0;2505;0
WireConnection;1866;0;2549;0
WireConnection;2503;0;2502;0
WireConnection;2501;0;2500;0
WireConnection;2467;0;2466;0
WireConnection;1977;0;1912;0
WireConnection;1977;1;2264;0
WireConnection;1977;2;2230;0
WireConnection;1977;3;2482;0
WireConnection;2500;0;2409;0
WireConnection;2500;1;2499;0
WireConnection;2595;0;1261;0
WireConnection;2595;1;2594;0
WireConnection;2507;0;2506;0
WireConnection;2502;0;2501;0
WireConnection;2498;0;2497;0
WireConnection;2499;0;2498;2
WireConnection;2505;0;2503;0
WireConnection;2505;1;2504;0
WireConnection;2428;0;2459;0
WireConnection;2428;2;1977;0
WireConnection;2428;5;2449;0
WireConnection;2428;6;2460;0
WireConnection;2428;7;1866;0
WireConnection;2428;15;2595;0
WireConnection;2428;16;1263;0
ASEEND*/
//CHKSM=60C76E3AE72FDDB8E16DEB8D2FECDCFCB9BF97FF