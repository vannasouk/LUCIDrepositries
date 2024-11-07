// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Moriohs Shaders/Enviroment Shaders/Triplanar"
{
	Properties
	{
		[ShaderOptimizerLockButton]_ShaderOptimizerEnabled("PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER", Float) = 0
		[Header(Albedo)]_TopAlbedo("Top Albedo", 2D) = "white" {}
		_TriplanarAlbedo("Triplanar Albedo", 2D) = "white" {}
		_MidAlbedo("Mid Albedo", 2D) = "white" {}
		_LowerAlbedo("Lower Albedo", 2D) = "white" {}
		[Header(Coverage Top)]_CoverageTopPosition("Coverage Top Position", Float) = -500
		_CoverageTopTexFalloff("Coverage Top Tex Falloff", Float) = 500
		_CoverageTopNoiseScale("Coverage Top Noise Scale", Float) = 50
		_CoverageTopNoiseFlatten("Coverage Top Noise Flatten", Range( 0 , 2)) = 2
		[Header(Coverage Triplanar)]_CoverageTriplanarTex("Coverage Triplanar Tex", Range( -1 , 1)) = 0.1
		_CoverageTriplanarTexFalloff("Coverage Triplanar Tex Falloff", Range( 0.01 , 20)) = 1
		_CoverageTriplanarNoiseScale("Coverage Triplanar Noise Scale", Float) = 50
		_CoverageTriplanarNoiseFlatten("Coverage Triplanar Noise Flatten", Range( 0 , 2)) = 2
		[Header(Coverage Mid)]_CoverageMidNoiseScale("Coverage Mid Noise Scale", Float) = 50
		_CoverageMidNoiseFlatten("Coverage Mid Noise Flatten", Range( 0 , 1)) = 0.5
		[Header(Coverage Lower)]_CoverageLowerPosition("Coverage Lower Position", Float) = 250
		_CoverageLowerTexFalloff("Coverage Lower Tex Falloff", Float) = 500
		[Header(Normal Maps)][ToggleUI]_UseSharedTexcoord("Use Shared Texcoord", Float) = 1
		[Normal]_TopNormal("Top Normal", 2D) = "bump" {}
		[Normal]_TriplanarNormal("Triplanar Normal", 2D) = "bump" {}
		[Normal]_MidNormal("Mid Normal", 2D) = "bump" {}
		[Normal]_LowerNormal("Lower Normal", 2D) = "bump" {}
		_TopNormalScale("Top Normal Scale", Range( -2 , 2)) = 1
		_TriplanarNormalScale("Triplanar Normal Scale", Range( -2 , 2)) = 1
		_MidNormalScale("Mid Normal Scale", Range( -2 , 2)) = 1
		_LowerNormalScale("Lower Normal Scale", Range( -2 , 2)) = 1
		[Header(Smoothness)]_TopSmoothness("Top Smoothness", Range( 0 , 1)) = 0.22
		_TriplanarSmoothness("Triplanar Smoothness", Range( 0 , 1)) = 0.22
		_MidSmoothness("Mid Smoothness", Range( 0 , 1)) = 0.22
		_LowerSmoothness("Lower Smoothness", Range( 0 , 1)) = 0.22
		[Space(25)][Header(MISCELLANEOUS)]_Specular("Specular", Range( 0 , 1)) = 0.02
		[HideInInspector][ToggleUI]_WorldtoObjectSwitch("World to Object Switch", Float) = 1
		[ToggleUI]_WorldtoObjectSwitch("World to Object Switch", Float) = 1
		[HideInInspector][ToggleUI]_NormalScaleAnimated("Normal Scale Animated", Int) = 1
		_Lod("Lod", Range( 0.5 , 1)) = 0.65
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZWrite On
		ZTest LEqual
		ColorMask RGB
		CGINCLUDE
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma multi_compile_instancing
		#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
		SamplerState sampler_trilinear_repeat;
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex.SampleBias(samplerTex,coord,bias)
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex.SampleGrad(samplerTex,coord,ddx,ddy)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
		#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex2Dbias(tex,float4(coord,0,bias))
		#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex2Dgrad(tex,coord,ddx,ddy)
		#endif//ASE Sampling Macros

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform int _NormalScaleAnimated;
		uniform float _ShaderOptimizerEnabled;
		#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
			sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
			sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
		#endif//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
			UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
		UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
		CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
				float4 _TerrainHeightmapScale;//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
		CBUFFER_END//ASE Terrain Instancing
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TriplanarNormal);
		uniform float _UseSharedTexcoord;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TriplanarAlbedo);
		uniform float4 _TriplanarAlbedo_ST;
		uniform float4 _TriplanarNormal_ST;
		uniform float _TriplanarNormalScale;
		uniform float _Lod;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_LowerNormal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_LowerAlbedo);
		uniform float4 _LowerAlbedo_ST;
		uniform float4 _LowerNormal_ST;
		uniform float _LowerNormalScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MidNormal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_MidAlbedo);
		uniform float4 _MidAlbedo_ST;
		uniform float4 _MidNormal_ST;
		uniform float _MidNormalScale;
		uniform float _CoverageLowerPosition;
		uniform float _CoverageLowerTexFalloff;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TopNormal);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_TopAlbedo);
		uniform float4 _TopAlbedo_ST;
		uniform float4 _TopNormal_ST;
		uniform float _TopNormalScale;
		uniform float _CoverageTopPosition;
		uniform float _CoverageTopTexFalloff;
		uniform float _CoverageTopNoiseScale;
		uniform float _CoverageTopNoiseFlatten;
		uniform float _CoverageTriplanarTex;
		uniform float _CoverageTriplanarTexFalloff;
		uniform float _CoverageTriplanarNoiseScale;
		uniform float _CoverageTriplanarNoiseFlatten;
		uniform float _TriplanarSmoothness;
		uniform float _LowerSmoothness;
		uniform float _MidSmoothness;
		uniform float _CoverageMidNoiseScale;
		uniform float _CoverageMidNoiseFlatten;
		uniform float _TopSmoothness;
		uniform float _WorldtoObjectSwitch;
		uniform float _Specular;


		float2 hash2D2D( float2 s )
		{
			return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453);
		}


		void ApplyMeshModification( inout appdata_full v )
		{
			#if defined(UNITY_INSTANCING_ENABLED) && !defined(SHADER_API_D3D11_9X)
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP(Terrain, _TerrainPatchInstanceData);
				
				float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
				float4 uvoffset = instanceData.xyxy * uvscale;
				uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
				float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
				
				float hm = UnpackHeightmap(tex2Dlod(_TerrainHeightmapTexture, float4(sampleCoords, 0, 0)));
				v.vertex.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
				v.vertex.y = hm * _TerrainHeightmapScale.y;
				v.vertex.w = 1.0f;
				
				v.texcoord.xy = (patchVertex.xy * uvscale.zw + uvoffset.zw);
				v.texcoord3 = v.texcoord2 = v.texcoord1 = v.texcoord;
				
				#ifdef TERRAIN_INSTANCED_PERPIXEL_NORMAL
					v.normal = float3(0, 1, 0);
					//data.tc.zw = sampleCoords;
				#else
					float3 nor = tex2Dlod(_TerrainNormalmapTexture, float4(sampleCoords, 0, 0)).xyz;
					v.normal = 2.0f * nor - 1.0f;
				#endif
			#endif
		}


		float3 tex2DStochasticNormals( UNITY_DECLARE_TEX2D_NOSAMPLER(tex), float2 UV, float _NormalScale, float lod )
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
			    float2 dx = ddx(UV * lod);
			    float2 dy = ddy(UV * lod);
			    //blend samples with calculated weights
			return mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy),_NormalScale), BW_vx[3].x) + 
			        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy),_NormalScale), BW_vx[3].y) + 
			        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z);
		}


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


		float4 tex2DStochastic344( UNITY_DECLARE_TEX2D_NOSAMPLER(tex), float2 UV, float lod )
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
			    float2 dx = ddx(UV * lod);
			    float2 dy = ddy(UV * lod);
			    //blend samples with calculated weights
			    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + 
			            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + 
			            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z);
		}


		float4 tex2DStochastic( UNITY_DECLARE_TEX2D_NOSAMPLER(tex), float2 UV, float lod )
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
			    float2 dx = ddx(UV * lod);
			    float2 dy = ddy(UV * lod);
			    //blend samples with calculated weights
			    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + 
			            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + 
			            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			ApplyMeshModification(v);;
			float localCalculateTangents951 = ( 0.0 );
			{
			v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
			v.tangent.w = -1;
			}
			float3 temp_cast_0 = (localCalculateTangents951).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex353) = _TriplanarNormal;
			float UseSharedTexcoord675 = _UseSharedTexcoord;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ifLocalVar711 = 0;
			if( _WorldtoObjectSwitch == 1.0 )
				ifLocalVar711 = ase_vertex3Pos;
			else if( _WorldtoObjectSwitch < 1.0 )
				ifLocalVar711 = ase_worldPos;
			float3 WorldtoObject715 = ifLocalVar711;
			float3 break759 = ( WorldtoObject715 / 100.0 );
			float2 appendResult758 = (float2(break759.y , break759.z));
			float2 TriplanarUVOne486 = ( ( appendResult758 * _TriplanarAlbedo_ST.xy ) + _TriplanarAlbedo_ST.zw );
			float3 break829 = ( WorldtoObject715 / 100.0 );
			float2 appendResult831 = (float2(break829.y , break829.z));
			float2 ifLocalVar685 = 0;
			if( UseSharedTexcoord675 == 1.0 )
				ifLocalVar685 = TriplanarUVOne486;
			else if( UseSharedTexcoord675 < 1.0 )
				ifLocalVar685 = ( ( appendResult831 * _TriplanarNormal_ST.xy ) + _TriplanarNormal_ST.zw );
			float2 UV353 = ifLocalVar685;
			float _NormalScale353 = _TriplanarNormalScale;
			float lod977 = _Lod;
			float lod353 = lod977;
			float3 localtex2DStochasticNormals353 = tex2DStochasticNormals( tex353 , UV353 , _NormalScale353 , lod353 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_72_0 = abs( mul( unity_WorldToObject, float4( ase_worldNormal , 0.0 ) ).xyz );
			float dotResult73 = dot( temp_output_72_0 , float3(1,1,1) );
			float3 BlendComponents147 = ( temp_output_72_0 / dotResult73 );
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex358) = _TriplanarNormal;
			float2 appendResult756 = (float2(break759.x , break759.z));
			float2 TriplanarUVTwo487 = ( ( appendResult756 * _TriplanarAlbedo_ST.xy ) + _TriplanarAlbedo_ST.zw );
			float2 appendResult832 = (float2(break829.x , break829.z));
			float2 ifLocalVar688 = 0;
			if( UseSharedTexcoord675 == 1.0 )
				ifLocalVar688 = TriplanarUVTwo487;
			else if( UseSharedTexcoord675 < 1.0 )
				ifLocalVar688 = ( ( appendResult832 * _TriplanarNormal_ST.xy ) + _TriplanarNormal_ST.zw );
			float2 UV358 = ifLocalVar688;
			float _NormalScale358 = _TriplanarNormalScale;
			float lod358 = lod977;
			float3 localtex2DStochasticNormals358 = tex2DStochasticNormals( tex358 , UV358 , _NormalScale358 , lod358 );
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex360) = _TriplanarNormal;
			float2 appendResult757 = (float2(break759.x , break759.y));
			float2 TriplanarUVThree488 = ( ( appendResult757 * _TriplanarAlbedo_ST.xy ) + _TriplanarAlbedo_ST.zw );
			float2 appendResult830 = (float2(break829.x , break829.y));
			float2 ifLocalVar691 = 0;
			if( UseSharedTexcoord675 == 1.0 )
				ifLocalVar691 = TriplanarUVThree488;
			else if( UseSharedTexcoord675 < 1.0 )
				ifLocalVar691 = ( ( appendResult830 * _TriplanarNormal_ST.xy ) + _TriplanarNormal_ST.zw );
			float2 UV360 = ifLocalVar691;
			float _NormalScale360 = _TriplanarNormalScale;
			float lod360 = lod977;
			float3 localtex2DStochasticNormals360 = tex2DStochasticNormals( tex360 , UV360 , _NormalScale360 , lod360 );
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex400) = _LowerNormal;
			float3 break790 = ( WorldtoObject715 / 100.0 );
			float2 appendResult791 = (float2(break790.x , break790.z));
			float2 LowerAlbedoUV492 = ( ( appendResult791 * _LowerAlbedo_ST.xy ) + _LowerAlbedo_ST.zw );
			float3 break851 = ( WorldtoObject715 / 100.0 );
			float2 appendResult850 = (float2(break851.x , break851.z));
			float2 ifLocalVar672 = 0;
			if( UseSharedTexcoord675 == 1.0 )
				ifLocalVar672 = LowerAlbedoUV492;
			else if( UseSharedTexcoord675 < 1.0 )
				ifLocalVar672 = ( ( appendResult850 * _LowerNormal_ST.xy ) + _LowerNormal_ST.zw );
			float2 UV400 = ifLocalVar672;
			float _NormalScale400 = _LowerNormalScale;
			float lod400 = lod977;
			float3 localtex2DStochasticNormals400 = tex2DStochasticNormals( tex400 , UV400 , _NormalScale400 , lod400 );
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex361) = _MidNormal;
			float2 MidAlbedoUV493 = ( ( appendResult791 * _MidAlbedo_ST.xy ) + _MidAlbedo_ST.zw );
			float2 ifLocalVar678 = 0;
			if( UseSharedTexcoord675 == 1.0 )
				ifLocalVar678 = MidAlbedoUV493;
			else if( UseSharedTexcoord675 < 1.0 )
				ifLocalVar678 = ( ( appendResult850 * _MidNormal_ST.xy ) + _MidNormal_ST.zw );
			float2 UV361 = ifLocalVar678;
			float _NormalScale361 = _MidNormalScale;
			float lod361 = lod977;
			float3 localtex2DStochasticNormals361 = tex2DStochasticNormals( tex361 , UV361 , _NormalScale361 , lod361 );
			float temp_output_878_0 = saturate( ( ( WorldtoObject715.y + _CoverageLowerPosition ) / _CoverageLowerTexFalloff ) );
			float3 lerpResult397 = lerp( localtex2DStochasticNormals400 , localtex2DStochasticNormals361 , temp_output_878_0);
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex598) = _TopNormal;
			float2 TopAlbedoUV586 = ( ( appendResult791 * _TopAlbedo_ST.xy ) + _TopAlbedo_ST.zw );
			float2 ifLocalVar681 = 0;
			if( UseSharedTexcoord675 == 1.0 )
				ifLocalVar681 = TopAlbedoUV586;
			else if( UseSharedTexcoord675 < 1.0 )
				ifLocalVar681 = ( ( appendResult850 * _TopNormal_ST.xy ) + _TopNormal_ST.zw );
			float2 UV598 = ifLocalVar681;
			float _NormalScale598 = _TopNormalScale;
			float lod598 = lod977;
			float3 localtex2DStochasticNormals598 = tex2DStochasticNormals( tex598 , UV598 , _NormalScale598 , lod598 );
			float temp_output_865_0 = ( ( WorldtoObject715.y + _CoverageTopPosition ) / _CoverageTopTexFalloff );
			float temp_output_906_0 = saturate( temp_output_865_0 );
			float3 break942 = ( WorldtoObject715 / 100.0 );
			float2 appendResult943 = (float2(break942.x , break942.z));
			float simplePerlin2D643 = snoise( ( appendResult943 / 100.0 )*_CoverageTopNoiseScale );
			float lerpResult905 = lerp( temp_output_906_0 , ( temp_output_906_0 * saturate( ( simplePerlin2D643 + _CoverageTopNoiseFlatten ) ) ) , saturate( ( 1.0 - ( temp_output_865_0 - 1.0 ) ) ));
			float3 lerpResult599 = lerp( lerpResult397 , localtex2DStochasticNormals598 , lerpResult905);
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 break936 = ( WorldtoObject715 / 100.0 );
			float2 appendResult937 = (float2(break936.x , break936.z));
			float simplePerlin2D732 = snoise( ( appendResult937 / 100.0 )*_CoverageTriplanarNoiseScale );
			float temp_output_735_0 = saturate( ( simplePerlin2D732 + _CoverageTriplanarNoiseFlatten ) );
			float3 lerpResult284 = lerp( ( ( ( localtex2DStochasticNormals353 * BlendComponents147.x ) + ( localtex2DStochasticNormals358 * BlendComponents147.y ) ) + ( localtex2DStochasticNormals360 * BlendComponents147.z ) ) , lerpResult599 , ( pow( saturate( ( ase_normWorldNormal.y + _CoverageTriplanarTex ) ) , _CoverageTriplanarTexFalloff ) * temp_output_735_0 ));
			float3 CalculatedNormal292 = lerpResult284;
			o.Normal = CalculatedNormal292;
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex344) = _TriplanarAlbedo;
			float2 UV344 = TriplanarUVOne486;
			float lod344 = lod977;
			float4 localtex2DStochastic344 = tex2DStochastic344( tex344 , UV344 , lod344 );
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex349) = _TriplanarAlbedo;
			float2 UV349 = TriplanarUVTwo487;
			float lod349 = lod977;
			float4 localtex2DStochastic349 = tex2DStochastic( tex349 , UV349 , lod349 );
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex351) = _TriplanarAlbedo;
			float2 UV351 = TriplanarUVThree488;
			float lod351 = lod977;
			float4 localtex2DStochastic351 = tex2DStochastic( tex351 , UV351 , lod351 );
			float4 break615 = ( ( ( localtex2DStochastic344 * BlendComponents147.x ) + ( localtex2DStochastic349 * BlendComponents147.y ) ) + ( localtex2DStochastic351 * BlendComponents147.z ) );
			float4 appendResult616 = (float4(break615.x , break615.y , break615.z , ( break615.w * _TriplanarSmoothness )));
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex373) = _LowerAlbedo;
			float2 UV373 = LowerAlbedoUV492;
			float lod373 = lod977;
			float4 localtex2DStochastic373 = tex2DStochastic( tex373 , UV373 , lod373 );
			float4 break604 = localtex2DStochastic373;
			float4 appendResult606 = (float4(break604.x , break604.y , break604.z , ( break604.w * _LowerSmoothness )));
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex365) = _MidAlbedo;
			float2 UV365 = MidAlbedoUV493;
			float lod365 = lod977;
			float4 localtex2DStochastic365 = tex2DStochastic( tex365 , UV365 , lod365 );
			float4 break607 = localtex2DStochastic365;
			float4 appendResult608 = (float4(break607.x , break607.y , break607.z , ( break607.w * _MidSmoothness )));
			float3 break945 = ( WorldtoObject715 / 100.0 );
			float2 appendResult946 = (float2(break945.x , break945.z));
			float simplePerlin2D918 = snoise( ( appendResult946 / 100.0 )*_CoverageMidNoiseScale );
			simplePerlin2D918 = simplePerlin2D918*0.5 + 0.5;
			float4 lerpResult372 = lerp( appendResult606 , ( appendResult608 * saturate( ( simplePerlin2D918 + _CoverageMidNoiseFlatten ) ) ) , temp_output_878_0);
			UNITY_DECLARE_TEX2D_NOSAMPLER(tex587) = _TopAlbedo;
			float2 UV587 = TopAlbedoUV586;
			float lod587 = lod977;
			float4 localtex2DStochastic587 = tex2DStochastic( tex587 , UV587 , lod587 );
			float4 break611 = localtex2DStochastic587;
			float4 appendResult612 = (float4(break611.x , break611.y , break611.z , ( break611.w * _TopSmoothness )));
			float4 lerpResult591 = lerp( lerpResult372 , appendResult612 , lerpResult905);
			float3 PixelNormal315 = (WorldNormalVector( i , CalculatedNormal292 ));
			float3 lerpResult186 = lerp( PixelNormal315 , mul( unity_WorldToObject, float4( PixelNormal315 , 0.0 ) ).xyz , _WorldtoObjectSwitch);
			float3 temp_cast_4 = (_CoverageTriplanarTexFalloff).xxx;
			float4 lerpResult105 = lerp( appendResult616 , lerpResult591 , ( temp_output_735_0 * pow( saturate( ( lerpResult186 + _CoverageTriplanarTex ) ) , temp_cast_4 ).y ));
			o.Albedo = lerpResult105.xyz;
			float3 temp_cast_6 = (_Specular).xxx;
			o.Specular = temp_cast_6;
			o.Smoothness = lerpResult105.w;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma only_renderers d3d9 d3d11_9x d3d11 glcore metal vulkan nomrt 
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
		UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
21;29;2106;954;-847.199;565.2975;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;712;1808,-560;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;710;1760,-784;Float;False;Property;_WorldtoObjectSwitch;World to Object Switch;31;1;[HideInInspector];Fetch;True;0;0;0;False;1;ToggleUI;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;713;1808,-704;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;711;2000,-720;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;715;2160,-720;Inherit;False;WorldtoObject;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;144;-2560,128;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldToObjectMatrix;329;-2560,32;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.GetLocalVarNode;760;-1168,0;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;821;-1104,272;Inherit;False;Constant;_Float1;Float 1;33;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;787;-864,736;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;811;-832,816;Inherit;False;Constant;_Float4;Float 4;34;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;820;-928,80;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-2288,96;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;834;-1280,2448;Inherit;False;Constant;_Float0;Float 0;33;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;345;-1184,80;Inherit;True;Property;_TriplanarAlbedo;Triplanar Albedo;2;0;Create;True;1;Albedo;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.BreakToComponentsNode;759;-800,80;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;933;-2368,976;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;264;-2160,208;Float;False;Constant;_Vector0;Vector 0;-1;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;72;-2128,96;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;789;-672,736;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;939;816,1456;Inherit;False;Constant;_Float3;Float 3;34;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;835;-1344,2176;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;940;784,1376;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;934;-2336,1056;Inherit;False;Constant;_Float5;Float 5;34;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;73;-1952,160;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;366;-656,864;Inherit;True;Property;_MidAlbedo;Mid Albedo;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;935;-2176,976;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;376;-656,544;Inherit;True;Property;_LowerAlbedo;Lower Albedo;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureTransformNode;813;-928,-32;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;941;976,1376;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;854;-928,3184;Inherit;False;Constant;_Float2;Float 2;34;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;828;-1104,2336;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;756;-640,96;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;790;-544,736;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;757;-640,336;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;853;-960,3104;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;758;-640,-176;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;816;-512,96;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;814;-512,-176;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;75;-1792,96;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;936;-2048,976;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;829;-976,2336;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureTransformNode;810;-432,608;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;818;-512,336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;583;-656,1120;Inherit;True;Property;_TopAlbedo;Top Albedo;1;1;[Header];Create;True;1;Albedo;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;791;-416,736;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;724;1136,1696;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;852;-768,3104;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;942;1104,1376;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureTransformNode;840;-432,928;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TexturePropertyNode;356;-1360,2256;Inherit;True;Property;_TriplanarNormal;Triplanar Normal;19;1;[Normal];Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.BreakToComponentsNode;723;1328,1696;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;815;-384,-176;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;937;-1920,976;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;817;-384,96;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;943;1232,1376;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;838;-224,864;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;831;-816,2080;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;575;1088,1840;Inherit;False;Property;_CoverageTopPosition;Coverage Top Position;5;1;[Header];Create;True;1;Coverage Top;0;0;False;0;False;-500;-570;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;851;-640,3104;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;147;-1632,96;Float;True;BlendComponents;1;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;819;-384,336;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;363;-608,3248;Inherit;True;Property;_MidNormal;Mid Normal;20;1;[Normal];Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;673;1808,-272;Inherit;False;Property;_UseSharedTexcoord;Use Shared Texcoord;17;1;[Header];Create;True;1;Normal Maps;0;0;False;1;ToggleUI;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;832;-816,2352;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;830;-816,2656;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;833;-1104,2224;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;788;-224,544;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;843;-432,1184;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TexturePropertyNode;402;-608,2912;Inherit;True;Property;_LowerNormal;Lower Normal;21;1;[Normal];Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;874;-80,1472;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;486;-272,-176;Inherit;False;TriplanarUVOne;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;812;-96,544;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;580;1328,1840;Inherit;False;Property;_CoverageTopTexFalloff;Coverage Top Tex Falloff;6;0;Create;True;0;0;0;False;0;False;500;150;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;824;-688,2352;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;847;-352,3408;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;738;-1872,1152;Inherit;False;Property;_CoverageTriplanarNoiseScale;Coverage Triplanar Noise Scale;11;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;938;-1776,976;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;862;1456,1712;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;857;-352,3088;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;944;1376,1376;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;487;-272,96;Inherit;False;TriplanarUVTwo;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;839;-96,864;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;245;-1824,2256;Inherit;False;147;BlendComponents;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;-272,336;Inherit;False;TriplanarUVThree;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;850;-512,3104;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;826;-688,2656;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;976;1808,-368;Inherit;False;Property;_Lod;Lod;33;0;Create;True;0;0;0;False;0;False;0.65;0;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;822;-688,2080;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;675;2032,-272;Inherit;False;UseSharedTexcoord;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;646;1232,1504;Inherit;False;Property;_CoverageTopNoiseScale;Coverage Top Noise Scale;7;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;841;-224,1120;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;597;-608,3504;Inherit;True;Property;_TopNormal;Top Normal;18;1;[Normal];Create;True;1;Normal Maps;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;648;1456,1600;Inherit;False;Property;_CoverageTopNoiseFlatten;Coverage Top Noise Flatten;8;0;Create;True;0;0;0;False;0;False;2;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-1840,1600;Float;False;Property;_CoverageTriplanarTexFalloff;Coverage Triplanar Tex Falloff;10;0;Create;True;0;0;0;False;0;False;1;4;0.01;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;733;-1632,1248;Inherit;False;Property;_CoverageTriplanarNoiseFlatten;Coverage Triplanar Noise Flatten;12;0;Create;True;0;0;0;False;0;False;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;825;-560,2352;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;391;-192,1600;Inherit;False;Property;_CoverageLowerPosition;Coverage Lower Position;15;1;[Header];Create;True;1;Coverage Lower;0;0;False;0;False;250;21.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-1840,1504;Float;False;Property;_CoverageTriplanarTex;Coverage Triplanar Tex;9;1;[Header];Create;True;1;Coverage Triplanar;0;0;False;0;False;0.1;0.5;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;270;-1488,2112;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;489;-880,1984;Inherit;False;486;TriplanarUVOne;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;836;-880,2256;Inherit;False;487;TriplanarUVTwo;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;827;-560,2656;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-672,2560;Inherit;False;675;UseSharedTexcoord;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;875;112,1472;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;848;-144,3344;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;684;-672,1984;Inherit;False;675;UseSharedTexcoord;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;282;-1488,2400;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NoiseGeneratorNode;732;-1584,1024;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;492;16,544;Inherit;False;LowerAlbedoUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;687;-672,2256;Inherit;False;675;UseSharedTexcoord;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;493;16,864;Inherit;False;MidAlbedoUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;860;-352,3664;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;865;1584,1712;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;856;-144,3024;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;823;-560,2080;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;837;-880,2560;Inherit;False;488;TriplanarUVThree;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;977;2080,-368;Inherit;False;lod;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;842;-96,1120;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;643;1504,1376;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;849;-16,3344;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;304;144,1760;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;312;196.0534,1899.365;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;983;-432,2720;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;734;-1344,1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;495;-336,3248;Inherit;False;493;MidAlbedoUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;309;174.1647,1946.967;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;691;-432,2560;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;494;-336,2928;Inherit;False;492;LowerAlbedoUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;688;-432,2256;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;859;-144,3600;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;902;1712,1792;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;982;-432,2416;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;876;240,1488;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;325;-1280,2064;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;352;-560,2800;Inherit;False;Property;_TriplanarNormalScale;Triplanar Normal Scale;23;0;Create;True;0;0;0;False;0;False;1;1.5;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;322;-1280,2576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;981;-432,2144;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;677;-128,3248;Inherit;False;675;UseSharedTexcoord;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;676;-128,2928;Inherit;False;675;UseSharedTexcoord;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;855;-16,3024;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;476;80,1600;Inherit;False;Property;_CoverageLowerTexFalloff;Coverage Lower Tex Falloff;16;0;Create;True;0;0;0;False;0;False;500;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;647;1744,1376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;586;16,1120;Inherit;False;TopAlbedoUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;685;-432,1984;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;323;-1248,2608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;877;368,1488;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;482;-896,2960;Inherit;False;Property;_LowerNormalScale;Lower Normal Scale;25;0;Create;True;0;0;0;False;0;False;1;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;308;432,2096;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;735;-1232,1024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;595;-336,3504;Inherit;False;586;TopAlbedoUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;680;-128,3504;Inherit;False;675;UseSharedTexcoord;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;678;112,3248;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CustomExpressionNode;360;-240,2560;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$return mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy),_NormalScale), BW_vx[3].x) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy),_NormalScale), BW_vx[3].y) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z)@;3;Create;4;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;_NormalScale;FLOAT;0;In;;Inherit;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;4;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;273;-1488,2256;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;906;2016,1712;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;649;1856,1376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;672;112,2928;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;324;-1248,2032;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;984;112,3088;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;483;-896,3280;Inherit;False;Property;_MidNormalScale;Mid Normal Scale;24;0;Create;True;0;0;0;False;0;False;1;0.8;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;858;-16,3600;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;303;384,1936;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;903;1856,1792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;353;-240,1984;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$return mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy),_NormalScale), BW_vx[3].x) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy),_NormalScale), BW_vx[3].y) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z)@;3;Create;4;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;_NormalScale;FLOAT;0;In;;Inherit;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;4;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;358;-240,2256;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$return mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy),_NormalScale), BW_vx[3].x) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy),_NormalScale), BW_vx[3].y) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z)@;3;Create;4;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;_NormalScale;FLOAT;0;In;;Inherit;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;4;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;985;112,3408;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;0,1984;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;0,2256;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;305;544,2128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;993;184.8472,1922.541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;914;2192,1744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;986;112,3664;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;467;544,2208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;878;496,1488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;681;112,3504;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;249;0,2560;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;596;-896,3536;Inherit;False;Property;_TopNormalScale;Top Normal Scale;22;0;Create;True;0;0;0;False;0;False;1;1.5;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;361;320,3248;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$return mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy),_NormalScale), BW_vx[3].x) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy),_NormalScale), BW_vx[3].y) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z)@;3;Create;4;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;_NormalScale;FLOAT;0;In;;Inherit;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;4;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;904;2016,1792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;400;320,2928;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$return mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy),_NormalScale), BW_vx[3].x) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy),_NormalScale), BW_vx[3].y) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z)@;3;Create;4;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;_NormalScale;FLOAT;0;In;;Inherit;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;4;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;306;688,2176;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;992;636.8472,2194.541;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;598;320,3504;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$return mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy),_NormalScale), BW_vx[3].x) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy),_NormalScale), BW_vx[3].y) + $        mul(UnpackScaleNormal(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z)@;3;Create;4;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;_NormalScale;FLOAT;0;In;;Inherit;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochasticNormals;False;False;1;7;;False;4;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;397;592,3072;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;250;224,2400;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;252;240,2096;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;905;2336,1712;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;599;768,3072;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;990;832,2176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;248;480,2288;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;284;1008,2288;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;1184,2288;Float;True;CalculatedNormal;2;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;314;1440,2288;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;170;-2272,1376;Inherit;False;377.2743;222.3279;Coverage in Object mode;3;149;313;328;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;1664,2288;Float;True;PixelNormal;3;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;949;1600,960;Inherit;False;715;WorldtoObject;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;172;-2112,1200;Inherit;False;221.2136;154.4081;Coverage in World mode;1;293;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;328;-2240,1424;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;-2240,1504;Inherit;False;315;PixelNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;948;1632,1040;Inherit;False;Constant;_Float6;Float 6;34;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;950;1792,960;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-2112,1104;Float;False;Property;_WorldtoObjectSwitch;World to Object Switch;31;0;Create;True;0;0;0;False;1;ToggleUI;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-2080,1248;Inherit;False;315;PixelNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-2032,1440;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;238;-1328,-64;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;945;1920,960;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;186;-1792,1344;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;240;-1328,224;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;988;32,944;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-1648,1344;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;298;-1184,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;980;-240,416;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;198;-1184,-112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;978;-256,-96;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;946;2048,960;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;979;-256,176;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;296;-1152,368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;90;-1152,-144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;239;-1328,80;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CustomExpressionNode;365;208,864;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochastic;False;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;987;32,624;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;947;2192,960;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;916;2048,1088;Inherit;False;Property;_CoverageMidNoiseScale;Coverage Mid Noise Scale;13;0;Create;True;0;0;0;False;1;Header(Coverage Mid);False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;344;-64,-192;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochastic;True;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;351;-64,320;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochastic;False;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;152;-1536,1344;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;349;-64,80;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochastic;False;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;112,320;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;918;2320,960;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;989;32,1200;Inherit;False;977;lod;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;155;-1408,1344;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;917;2272,1184;Inherit;False;Property;_CoverageMidNoiseFlatten;Coverage Mid Noise Flatten;14;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;112,80;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;112,-192;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;610;208,1008;Float;False;Property;_MidSmoothness;Mid Smoothness;28;0;Create;True;0;0;0;False;0;False;0.22;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;607;352,864;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CustomExpressionNode;373;208,544;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochastic;False;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CustomExpressionNode;587;208,1120;Float;False;    //triangle vertices and blend weights$    //BW_vx[0...2].xyz = triangle verts$    //BW_vx[3].xy = blend weights (z is unused)$    float4x3 BW_vx@$$    //uv transformed into triangular grid space with UV scaled by approximation of 2*sqrt(3)$    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464)@$$    //vertex IDs and barycentric coords$    float2 vxID = float2 (floor(skewUV))@$    float3 barry = float3 (frac(skewUV), 0)@$    barry.z = 1.0-barry.x-barry.y@$$    BW_vx = ((barry.z>0) ? $        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :$        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)))@$$    //calculate derivatives to avoid triangular grid artifacts$    float2 dx = ddx(UV * lod)@$    float2 dy = ddy(UV * lod)@$$    //blend samples with calculated weights$    return mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + $            mul(SAMPLE_TEXTURE2D_GRAD(tex, sampler_trilinear_repeat, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z)@;4;Create;3;True;tex;SAMPLER2D;0,0;In;;Float;False;True;UV;FLOAT2;0,0;In;;Float;False;True;lod;FLOAT;0;In;;Inherit;False;tex2DStochastic;False;False;1;7;;False;3;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;609;480,960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;352,-80;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;268;-1264,1344;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;919;2560,960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;603;208,688;Float;False;Property;_LowerSmoothness;Lower Smoothness;29;0;Create;True;0;0;0;False;0;False;0.22;0.22;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;120;368,272;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;604;352,544;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;614;208,1264;Float;False;Property;_TopSmoothness;Top Smoothness;26;1;[Header];Create;True;1;Smoothness;0;0;False;0;False;0.22;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;605;480,640;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;608;624,864;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;920;2688,960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;611;352,1120;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;736;-1104,1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;704,176;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;618;704,320;Float;False;Property;_TriplanarSmoothness;Triplanar Smoothness;27;0;Create;True;0;0;0;False;0;False;0.22;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;606;624,544;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;921;1424,864;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;613;480,1216;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;740;-896,576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;615;848,176;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;594;-848,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;372;800,656;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;612;624,1120;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;617;976,272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;591;960,656;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;616;1120,176;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;593;1088,464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;337;1943,0;Inherit;False;400.6365;142.8446;Stochastic Hash, source: https://redd.it/dhr5g2;1;343;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;105;1296,176;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;212;1584,352;Float;False;Property;_Specular;Specular;30;0;Create;True;0;0;0;False;2;Space(25);Header(MISCELLANEOUS);False;0.02;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;370;1920,-176;Inherit;False;Property;_NormalScaleAnimated;Normal Scale Animated;32;1;[HideInInspector];Create;False;0;2;Off;0;Method by Rotoscope;1;0;True;1;ToggleUI;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.GetLocalVarNode;600;1728,224;Inherit;False;292;CalculatedNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;951;1808,464;Float;False;v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) )@$v.tangent.w = -1@;1;Call;0;CalculateTangents;True;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;343;2016,48;Float;False;return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453)@;2;Create;1;True;s;FLOAT2;0,0;In;;Float;False;hash2D2D;False;True;0;;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;601;1584,208;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;369;1920,-80;Inherit;False;Property;_ShaderOptimizerEnabled;PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER;0;0;Create;False;0;0;0;True;1;ShaderOptimizerLockButton;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;670;1968,176;Float;False;True;-1;7;ASEMaterialInspector;0;0;StandardSpecular;Moriohs Shaders/Enviroment Shaders/Triplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;7;d3d9;d3d11_9x;d3d11;glcore;metal;vulkan;nomrt;True;True;True;False;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Custom;SamplerState sampler_trilinear_repeat@;False;;Custom;0;0;True;0.1;False;-1;0;False;-1;True;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;711;0;710;0
WireConnection;711;3;713;0
WireConnection;711;4;712;0
WireConnection;715;0;711;0
WireConnection;820;0;760;0
WireConnection;820;1;821;0
WireConnection;145;0;329;0
WireConnection;145;1;144;0
WireConnection;759;0;820;0
WireConnection;72;0;145;0
WireConnection;789;0;787;0
WireConnection;789;1;811;0
WireConnection;73;0;72;0
WireConnection;73;1;264;0
WireConnection;935;0;933;0
WireConnection;935;1;934;0
WireConnection;813;0;345;0
WireConnection;941;0;940;0
WireConnection;941;1;939;0
WireConnection;828;0;835;0
WireConnection;828;1;834;0
WireConnection;756;0;759;0
WireConnection;756;1;759;2
WireConnection;790;0;789;0
WireConnection;757;0;759;0
WireConnection;757;1;759;1
WireConnection;758;0;759;1
WireConnection;758;1;759;2
WireConnection;816;0;756;0
WireConnection;816;1;813;0
WireConnection;814;0;758;0
WireConnection;814;1;813;0
WireConnection;75;0;72;0
WireConnection;75;1;73;0
WireConnection;936;0;935;0
WireConnection;829;0;828;0
WireConnection;810;0;376;0
WireConnection;818;0;757;0
WireConnection;818;1;813;0
WireConnection;791;0;790;0
WireConnection;791;1;790;2
WireConnection;852;0;853;0
WireConnection;852;1;854;0
WireConnection;942;0;941;0
WireConnection;840;0;366;0
WireConnection;723;0;724;0
WireConnection;815;0;814;0
WireConnection;815;1;813;1
WireConnection;937;0;936;0
WireConnection;937;1;936;2
WireConnection;817;0;816;0
WireConnection;817;1;813;1
WireConnection;943;0;942;0
WireConnection;943;1;942;2
WireConnection;838;0;791;0
WireConnection;838;1;840;0
WireConnection;831;0;829;1
WireConnection;831;1;829;2
WireConnection;851;0;852;0
WireConnection;147;0;75;0
WireConnection;819;0;818;0
WireConnection;819;1;813;1
WireConnection;832;0;829;0
WireConnection;832;1;829;2
WireConnection;830;0;829;0
WireConnection;830;1;829;1
WireConnection;833;0;356;0
WireConnection;788;0;791;0
WireConnection;788;1;810;0
WireConnection;843;0;583;0
WireConnection;486;0;815;0
WireConnection;812;0;788;0
WireConnection;812;1;810;1
WireConnection;824;0;832;0
WireConnection;824;1;833;0
WireConnection;847;0;363;0
WireConnection;938;0;937;0
WireConnection;938;1;934;0
WireConnection;862;0;723;1
WireConnection;862;1;575;0
WireConnection;857;0;402;0
WireConnection;944;0;943;0
WireConnection;944;1;939;0
WireConnection;487;0;817;0
WireConnection;839;0;838;0
WireConnection;839;1;840;1
WireConnection;488;0;819;0
WireConnection;850;0;851;0
WireConnection;850;1;851;2
WireConnection;826;0;830;0
WireConnection;826;1;833;0
WireConnection;822;0;831;0
WireConnection;822;1;833;0
WireConnection;675;0;673;0
WireConnection;841;0;791;0
WireConnection;841;1;843;0
WireConnection;825;0;824;0
WireConnection;825;1;833;1
WireConnection;270;0;245;0
WireConnection;827;0;826;0
WireConnection;827;1;833;1
WireConnection;875;0;874;0
WireConnection;848;0;850;0
WireConnection;848;1;847;0
WireConnection;282;0;245;0
WireConnection;732;0;938;0
WireConnection;732;1;738;0
WireConnection;492;0;812;0
WireConnection;493;0;839;0
WireConnection;860;0;597;0
WireConnection;865;0;862;0
WireConnection;865;1;580;0
WireConnection;856;0;850;0
WireConnection;856;1;857;0
WireConnection;823;0;822;0
WireConnection;823;1;833;1
WireConnection;977;0;976;0
WireConnection;842;0;841;0
WireConnection;842;1;843;1
WireConnection;643;0;944;0
WireConnection;643;1;646;0
WireConnection;849;0;848;0
WireConnection;849;1;847;1
WireConnection;312;0;110;0
WireConnection;734;0;732;0
WireConnection;734;1;733;0
WireConnection;309;0;115;0
WireConnection;691;0;690;0
WireConnection;691;3;837;0
WireConnection;691;4;827;0
WireConnection;688;0;687;0
WireConnection;688;3;836;0
WireConnection;688;4;825;0
WireConnection;859;0;850;0
WireConnection;859;1;860;0
WireConnection;902;0;865;0
WireConnection;876;0;875;1
WireConnection;876;1;391;0
WireConnection;325;0;270;0
WireConnection;322;0;282;2
WireConnection;855;0;856;0
WireConnection;855;1;857;1
WireConnection;647;0;643;0
WireConnection;647;1;648;0
WireConnection;586;0;842;0
WireConnection;685;0;684;0
WireConnection;685;3;489;0
WireConnection;685;4;823;0
WireConnection;323;0;322;0
WireConnection;877;0;876;0
WireConnection;877;1;476;0
WireConnection;308;0;309;0
WireConnection;735;0;734;0
WireConnection;678;0;677;0
WireConnection;678;3;495;0
WireConnection;678;4;849;0
WireConnection;360;0;356;0
WireConnection;360;1;691;0
WireConnection;360;2;352;0
WireConnection;360;3;983;0
WireConnection;273;0;245;0
WireConnection;906;0;865;0
WireConnection;649;0;647;0
WireConnection;672;0;676;0
WireConnection;672;3;494;0
WireConnection;672;4;855;0
WireConnection;324;0;325;0
WireConnection;858;0;859;0
WireConnection;858;1;860;1
WireConnection;303;0;304;2
WireConnection;303;1;312;0
WireConnection;903;0;902;0
WireConnection;353;0;356;0
WireConnection;353;1;685;0
WireConnection;353;2;352;0
WireConnection;353;3;981;0
WireConnection;358;0;356;0
WireConnection;358;1;688;0
WireConnection;358;2;352;0
WireConnection;358;3;982;0
WireConnection;253;0;353;0
WireConnection;253;1;324;0
WireConnection;251;0;358;0
WireConnection;251;1;273;1
WireConnection;305;0;303;0
WireConnection;993;0;735;0
WireConnection;914;0;906;0
WireConnection;914;1;649;0
WireConnection;467;0;308;0
WireConnection;878;0;877;0
WireConnection;681;0;680;0
WireConnection;681;3;595;0
WireConnection;681;4;858;0
WireConnection;249;0;360;0
WireConnection;249;1;323;0
WireConnection;361;0;363;0
WireConnection;361;1;678;0
WireConnection;361;2;483;0
WireConnection;361;3;985;0
WireConnection;904;0;903;0
WireConnection;400;0;402;0
WireConnection;400;1;672;0
WireConnection;400;2;482;0
WireConnection;400;3;984;0
WireConnection;306;0;305;0
WireConnection;306;1;467;0
WireConnection;992;0;993;0
WireConnection;598;0;597;0
WireConnection;598;1;681;0
WireConnection;598;2;596;0
WireConnection;598;3;986;0
WireConnection;397;0;400;0
WireConnection;397;1;361;0
WireConnection;397;2;878;0
WireConnection;250;0;249;0
WireConnection;252;0;253;0
WireConnection;252;1;251;0
WireConnection;905;0;906;0
WireConnection;905;1;914;0
WireConnection;905;2;904;0
WireConnection;599;0;397;0
WireConnection;599;1;598;0
WireConnection;599;2;905;0
WireConnection;990;0;306;0
WireConnection;990;1;992;0
WireConnection;248;0;252;0
WireConnection;248;1;250;0
WireConnection;284;0;248;0
WireConnection;284;1;599;0
WireConnection;284;2;990;0
WireConnection;292;0;284;0
WireConnection;314;0;292;0
WireConnection;315;0;314;0
WireConnection;950;0;949;0
WireConnection;950;1;948;0
WireConnection;149;0;328;0
WireConnection;149;1;313;0
WireConnection;238;0;147;0
WireConnection;945;0;950;0
WireConnection;186;0;293;0
WireConnection;186;1;149;0
WireConnection;186;2;185;0
WireConnection;240;0;147;0
WireConnection;153;0;186;0
WireConnection;153;1;110;0
WireConnection;298;0;240;2
WireConnection;198;0;238;0
WireConnection;946;0;945;0
WireConnection;946;1;945;2
WireConnection;296;0;298;0
WireConnection;90;0;198;0
WireConnection;239;0;147;0
WireConnection;365;0;366;0
WireConnection;365;1;493;0
WireConnection;365;2;988;0
WireConnection;947;0;946;0
WireConnection;947;1;948;0
WireConnection;344;0;345;0
WireConnection;344;1;486;0
WireConnection;344;2;978;0
WireConnection;351;0;345;0
WireConnection;351;1;488;0
WireConnection;351;2;980;0
WireConnection;152;0;153;0
WireConnection;349;0;345;0
WireConnection;349;1;487;0
WireConnection;349;2;979;0
WireConnection;34;0;351;0
WireConnection;34;1;296;0
WireConnection;918;0;947;0
WireConnection;918;1;916;0
WireConnection;155;0;152;0
WireConnection;155;1;115;0
WireConnection;31;0;349;0
WireConnection;31;1;239;1
WireConnection;28;0;344;0
WireConnection;28;1;90;0
WireConnection;607;0;365;0
WireConnection;373;0;376;0
WireConnection;373;1;492;0
WireConnection;373;2;987;0
WireConnection;587;0;583;0
WireConnection;587;1;586;0
WireConnection;587;2;989;0
WireConnection;609;0;607;3
WireConnection;609;1;610;0
WireConnection;32;0;28;0
WireConnection;32;1;31;0
WireConnection;268;0;155;0
WireConnection;919;0;918;0
WireConnection;919;1;917;0
WireConnection;120;0;34;0
WireConnection;604;0;373;0
WireConnection;605;0;604;3
WireConnection;605;1;603;0
WireConnection;608;0;607;0
WireConnection;608;1;607;1
WireConnection;608;2;607;2
WireConnection;608;3;609;0
WireConnection;920;0;919;0
WireConnection;611;0;587;0
WireConnection;736;0;735;0
WireConnection;736;1;268;1
WireConnection;35;0;32;0
WireConnection;35;1;120;0
WireConnection;606;0;604;0
WireConnection;606;1;604;1
WireConnection;606;2;604;2
WireConnection;606;3;605;0
WireConnection;921;0;608;0
WireConnection;921;1;920;0
WireConnection;613;0;611;3
WireConnection;613;1;614;0
WireConnection;740;0;736;0
WireConnection;615;0;35;0
WireConnection;594;0;740;0
WireConnection;372;0;606;0
WireConnection;372;1;921;0
WireConnection;372;2;878;0
WireConnection;612;0;611;0
WireConnection;612;1;611;1
WireConnection;612;2;611;2
WireConnection;612;3;613;0
WireConnection;617;0;615;3
WireConnection;617;1;618;0
WireConnection;591;0;372;0
WireConnection;591;1;612;0
WireConnection;591;2;905;0
WireConnection;616;0;615;0
WireConnection;616;1;615;1
WireConnection;616;2;615;2
WireConnection;616;3;617;0
WireConnection;593;0;594;0
WireConnection;105;0;616;0
WireConnection;105;1;591;0
WireConnection;105;2;593;0
WireConnection;601;0;105;0
WireConnection;670;0;105;0
WireConnection;670;1;600;0
WireConnection;670;3;212;0
WireConnection;670;4;601;3
WireConnection;670;11;951;0
ASEEND*/
//CHKSM=504B3F20B8B82D9A5A6214786BD5FF9479B23B26