

Shader "Hidden/Moriohs Shaders/Enviroment Shaders/Sea-Water-simple/110a562f0c224c648b92da9a320053e5"
{
	Properties
	{
		[ShaderOptimizerLockButton]_ShaderOptimizerEnabled("PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER", Float) = 0
		[Header(MAIN OPTIONS)]_WaterColor("WaterColor", Color) = (0,0.1607843,0.1568628,0)
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 2
		_WaterDepth("Water Depth", Range( 0 , 1)) = 0.975
		_NormalMapDepthinfluence("Normal Map Depth influence", Range( 0 , 1)) = 0.2
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.94
		_UVTiling("UV Tiling", Float) = 0.01
		_GeneralFoamAmount("General Foam Amount", Range( 0 , 1)) = 0.645
		_GeneralFoamStrength("General Foam Strength", Float) = 1.65
		_GeneralFoamDepthFalloff("General Foam Depth Falloff", Range( 0 , 1)) = 0.25
		[Space(25)][Header(NORMAL MAPS)]_Normal("Normal", 2D) = "bump" {}
		_ScrollSpeed("Scroll Speed", Range( -2 , 2)) = 0.075
		_NormalScale("Normal Scale", Range( -2 , 2)) = 0.2
		_VectorXY("Vector X,Y", Vector) = (0,-1,0,0)
		_SecondaryNormal("Secondary Normal", 2D) = "bump" {}
		_SecondaryScrollSpeed("Secondary Scroll Speed", Range( -2 , 2)) = 0.17
		_NormalScaleSecondary("Normal Scale Secondary", Range( -2 , 2)) = 0.2
		_SecondaryVectorXY("Secondary Vector X,Y", Vector) = (0,-1,0,0)
		[Space(25)][Header(EDGE FOAM)]_SeaFoam("SeaFoam", 2D) = "black" {}
		_EdgeFoamSpeed("Edge Foam Speed", Float) = 0.025
		_EdgePower("Edge Intensity", Range( 0 , 1)) = 0.5
		_EdgeDistance("Edge Distance", Range( 0 , 1)) = 0.7
		[HideInInspector][ToggleUI]_NormalScaleAnimated("Normal Scale Animated", Int) = 1
		[HideInInspector][ToggleUI]_NormalScaleSecondaryAnimated("Normal Scale Secondary Animated", Int) = 1

		
		
		
		
		
		
		
		
		
		
		
		
		
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}
	CGINCLUDE
#define OPTIMIZER_ENABLED
#define PROP_SHADEROPTIMIZERENABLED 1
#define PROP_CULLMODE 2
#define PROP_WATERDEPTH 0.836
#define PROP_NORMALMAPDEPTHINFLUENCE 0.2
#define PROP_SMOOTHNESS 0
#define PROP_UVTILING 4.18
#define PROP_GENERALFOAMAMOUNT 0.471
#define PROP_GENERALFOAMSTRENGTH 4.79
#define PROP_GENERALFOAMDEPTHFALLOFF 0.378
#define PROP_NORMAL
#define PROP_SCROLLSPEED 0.0075
#define PROP_NORMALSCALE 0.2
#define PROP_SECONDARYNORMAL
#define PROP_SECONDARYSCROLLSPEED 0.05
#define PROP_NORMALSCALESECONDARY 0.3
#define PROP_SEAFOAM
#define PROP_EDGEFOAMSPEED 0.025
#define PROP_EDGEPOWER 0.3
#define PROP_EDGEDISTANCE 0.7
#define PROP_NORMALSCALEANIMATED 1
#define PROP_NORMALSCALESECONDARYANIMATED 1
#define PROP_SPECULARHIGHLIGHTS 1
#define PROP_GLOSSYREFLECTIONS 1
ENDCG
	SubShader
	{
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="False" }
	LOD 0

		Cull [_CullMode]
		AlphaToMask Off
		ZWrite Off
		ZTest LEqual
		ColorMask RGBA
		
		Blend SrcAlpha OneMinusSrcAlpha
		

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

		
		Pass
		{
			
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }
			
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

#pragma exclude_renderers gles
			#define _ALPHABLEND_ON 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
//			#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
//			#pragma shader_feature _GLOSSYREFLECTIONS_OFF

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
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			SamplerState sampler_CameraDepthTexture;
			Texture2D _CameraDepthTexture;
			uniform float4 _CameraDepthTexture_TexelSize;

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
			uniform float _CullMode;
			uniform int _NormalScaleSecondaryAnimated;
			uniform int _NormalScaleAnimated;
			uniform float _ShaderOptimizerEnabled;
			uniform float4 _WaterColor;
			uniform sampler2D _Normal;
			uniform float _ScrollSpeed;
			uniform float2 _VectorXY;
			uniform float4 _Normal_ST;
			uniform float _UVTiling;
			uniform float _NormalScale;
			uniform sampler2D _SecondaryNormal;
			uniform float _SecondaryScrollSpeed;
			uniform float2 _SecondaryVectorXY;
			uniform float4 _SecondaryNormal_ST;
			uniform float _NormalScaleSecondary;
			uniform float _WaterDepth;
			uniform float _GeneralFoamStrength;
			uniform float _GeneralFoamAmount;
			uniform float _GeneralFoamDepthFalloff;
			uniform sampler2D _SeaFoam;
			uniform float4 _SeaFoam_ST;
			uniform float _EdgeFoamSpeed;
			uniform float _EdgeDistance;
			uniform float _EdgePower;
			uniform float _Smoothness;
			uniform float _NormalMapDepthinfluence;

	
			float2 hash2D2D( float2 s )
			{
				return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453);
			}
			
			void SourceDeclaration(  )
			{
				
			}
			
			float3 tex2DStochasticNormals( sampler2D tex, float2 UV, float _NormalScale )
			{
				    
				    
				    
				    float4x3 BW_vx;
				    
				    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464);
				    
				    float2 vxID = float2 (floor(skewUV));
				    float3 barry = float3 (frac(skewUV), 0);
				    barry.z = 1.0-barry.x-barry.y;
				    BW_vx = ((barry.z>0) ? 
				        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :
				        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)));
				    
				    float2 dx = ddx(UV);
				    float2 dy = ddy(UV);
				    
				    return mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), _NormalScale), BW_vx[3].x) + 
				            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), _NormalScale), BW_vx[3].y) + 
				            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z);
			}
			
			float4 tex2DStochastic( sampler2D tex, float2 UV )
			{
				    
				    
				    
				    float4x3 BW_vx;
				    
				    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464);
				    
				    float2 vxID = float2 (floor(skewUV));
				    float3 barry = float3 (frac(skewUV), 0);
				    barry.z = 1.0-barry.x-barry.y;
				    BW_vx = ((barry.z>0) ? 
				        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :
				        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)));
				    
				    float2 dx = ddx(UV);
				    float2 dy = ddy(UV);
				    
				    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + 
				            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + 
				            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z);
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 objectToViewPos = UnityObjectToViewPos(v.vertex.xyz);
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord9.x = eyeDepth;
				
				
				
				o.ase_texcoord9.yzw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = v.normal;
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
			
			fixed4 frag (v2f IN 
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

				sampler2D tex96_g112 = _Normal;
				float mulTime7_g112 = _Time.y * float(0.0075);
				float temp_output_68_0_g112 = float(4.18);
				float2 appendResult105_g112 = (float2(worldPos.x , worldPos.z));
				float2 temp_output_104_0_g112 = ( ( float4(0.075,0.025,0,0).xy * temp_output_68_0_g112 * appendResult105_g112 ) + float4(0.075,0.025,0,0).zw );
				float2 panner17_g112 = ( mulTime7_g112 * float4(0,-1,0,0) + temp_output_104_0_g112);
				float2 UV96_g112 = ( panner17_g112 + 0.25 );
				float _NormalScale96_g112 = _NormalScale;
				float3 localtex2DStochasticNormals96_g112 = tex2DStochasticNormals( tex96_g112 , UV96_g112 , _NormalScale96_g112 );
				sampler2D tex79_g112 = _Normal;
				float mulTime4_g112 = _Time.y * float(0.0075);
				float2 panner12_g112 = ( ( mulTime4_g112 * 2.179 ) * float4(0,-1,0,0) + ( 1.0 - temp_output_104_0_g112 ));
				float2 UV79_g112 = ( 1.0 - panner12_g112 );
				float _NormalScale79_g112 = _NormalScale;
				float3 localtex2DStochasticNormals79_g112 = tex2DStochasticNormals( tex79_g112 , UV79_g112 , _NormalScale79_g112 );
				sampler2D tex76_g112 = _SecondaryNormal;
				float mulTime16_g112 = _Time.y * float(0.05);
				float2 panner21_g112 = ( mulTime16_g112 * float4(0,-1,0,0) + ( ( float4(1,1,0,0).xy * temp_output_68_0_g112 * appendResult105_g112 ) + float4(1,1,0,0).zw ));
				float2 UV76_g112 = panner21_g112;
				float _NormalScale76_g112 = _NormalScaleSecondary;
				float3 localtex2DStochasticNormals76_g112 = tex2DStochasticNormals( tex76_g112 , UV76_g112 , _NormalScale76_g112 );
				float3 normalizeResult66_g112 = normalize( BlendNormals( BlendNormals( localtex2DStochasticNormals96_g112 , localtex2DStochasticNormals79_g112 ) , localtex2DStochasticNormals76_g112 ) );
				float3 Normals80 = normalizeResult66_g112;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal891 = Normals80;
				float3 worldNormal891 = normalize( float3(dot(tanToWorld0,tanNormal891), dot(tanToWorld1,tanNormal891), dot(tanToWorld2,tanNormal891)) );
				float fresnelNdotV888 = dot( worldNormal891, worldViewDir );
				float fresnelNode888 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV888, 5.0 ) );
				float localDepthCheck1211 = ( 0.0 );
				float width1211 = 17;
				{
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS
				_CameraDepthTexture.GetDimensions(width1211, width1211);
				#endif
				}
				float localscreenDepth1217 = ( 0.0 );
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 SP1217 = ase_screenPosNorm;
				float ScreenDepth1217 = 0;
				{
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS
				ScreenDepth1217 = LinearEyeDepth(_CameraDepthTexture.Sample(sampler_CameraDepthTexture, SP1217.xy));
				#else
				ScreenDepth1217 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, SP1217.xy ));
				#endif
				}
				float eyeDepth = IN.ase_texcoord9.x;
				float ifLocalVar1210 = 0;
				if( width1211 <= 16.0 )
				ifLocalVar1210 = 1.0;
				else
				ifLocalVar1210 = ( ( ScreenDepth1217 - eyeDepth ) * ( 1.0 - float(0.836) ) );
				float WaterDepth671 = ifLocalVar1210;
				float4 lerpResult894 = lerp( float4(0.005412819,0,0.4912431,0) , ( float4(0.005412819,0,0.4912431,0) * fresnelNode888 ) , saturate( ( WaterDepth671 * 0.5 ) ));
				float3 temp_cast_0 = (1.0).xxx;
				float dotResult1179 = dot( Normals80 , temp_cast_0 );
				float GeneralFoam673 = saturate( ( ( ( dotResult1179 * float(4.79) * float(0.471) ) - ( float(4.79) * ( 1.0 - float(0.471) ) ) ) * saturate( ( WaterDepth671 * float(0.378) ) ) ) );
				float localDepthCheck1202 = ( 0.0 );
				float width1202 = 17;
				{
				_CameraDepthTexture.GetDimensions(width1202, width1202);
				}
				sampler2D tex340 = _SeaFoam;
				float2 appendResult1221 = (float2(worldPos.x , worldPos.z));
				float2 NormalVector625 = float4(0,-1,0,0);
				float mulTime344 = _Time.y * float(0.025);
				float2 UV340 = ( ( ( float4(1,1,0,0).xy * appendResult1221 * float(4.18) ) + float4(1,1,0,0).zw ) + ( NormalVector625 * mulTime344 ) );
				float4 localtex2DStochastic340 = tex2DStochastic( tex340 , UV340 );
				float ifLocalVar1203 = 0;
				if( width1202 > 16.0 )
				ifLocalVar1203 = ( saturate( ( localtex2DStochastic340.y - saturate( ( WaterDepth671 * float(0.7) ) ) ) ) * float(0.3) );
				
				o.Albedo = ( lerpResult894 + ( GeneralFoam673 + ifLocalVar1203 ) ).rgb;
				o.Normal = Normals80;
				o.Emission = half3( 0, 0, 0 );
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = 0;
				#endif
				o.Smoothness = ( saturate( ( 1.0 - ( ifLocalVar1203 + GeneralFoam673 ) ) ) * float(0) );
				o.Occlusion = 1;
				o.Alpha = saturate( ( WaterDepth671 + ( Normals80.y * float(0.2) ) ) );
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

				
				
				
				
				
				
				
				

				c.rgb += o.Emission;

				#ifdef ASE_FOG
					UNITY_APPLY_FOG(IN.fogCoord, c);
				#endif
				return c;
			}
			ENDCG
		}

		
		Pass
		{
			
			Name "ForwardAdd"
			Tags { "LightMode"="ForwardAdd" }
			ZWrite Off
			Blend SrcAlpha One

			CGPROGRAM

#pragma exclude_renderers gles
			#define _ALPHABLEND_ON 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
//			#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
//			#pragma shader_feature _GLOSSYREFLECTIONS_OFF

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
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			SamplerState sampler_CameraDepthTexture;
			Texture2D _CameraDepthTexture;
			uniform float4 _CameraDepthTexture_TexelSize;

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
			uniform float _CullMode;
			uniform int _NormalScaleSecondaryAnimated;
			uniform int _NormalScaleAnimated;
			uniform float _ShaderOptimizerEnabled;
			uniform float4 _WaterColor;
			uniform sampler2D _Normal;
			uniform float _ScrollSpeed;
			uniform float2 _VectorXY;
			uniform float4 _Normal_ST;
			uniform float _UVTiling;
			uniform float _NormalScale;
			uniform sampler2D _SecondaryNormal;
			uniform float _SecondaryScrollSpeed;
			uniform float2 _SecondaryVectorXY;
			uniform float4 _SecondaryNormal_ST;
			uniform float _NormalScaleSecondary;
			uniform float _WaterDepth;
			uniform float _GeneralFoamStrength;
			uniform float _GeneralFoamAmount;
			uniform float _GeneralFoamDepthFalloff;
			uniform sampler2D _SeaFoam;
			uniform float4 _SeaFoam_ST;
			uniform float _EdgeFoamSpeed;
			uniform float _EdgeDistance;
			uniform float _EdgePower;
			uniform float _Smoothness;
			uniform float _NormalMapDepthinfluence;

	
			float2 hash2D2D( float2 s )
			{
				return frac(sin(fmod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159))*43758.5453);
			}
			
			void SourceDeclaration(  )
			{
				
			}
			
			float3 tex2DStochasticNormals( sampler2D tex, float2 UV, float _NormalScale )
			{
				    
				    
				    
				    float4x3 BW_vx;
				    
				    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464);
				    
				    float2 vxID = float2 (floor(skewUV));
				    float3 barry = float3 (frac(skewUV), 0);
				    barry.z = 1.0-barry.x-barry.y;
				    BW_vx = ((barry.z>0) ? 
				        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :
				        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)));
				    
				    float2 dx = ddx(UV);
				    float2 dy = ddy(UV);
				    
				    return mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), _NormalScale), BW_vx[3].x) + 
				            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), _NormalScale), BW_vx[3].y) + 
				            mul (UnpackScaleNormal(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), _NormalScale), BW_vx[3].z);
			}
			
			float4 tex2DStochastic( sampler2D tex, float2 UV )
			{
				    
				    
				    
				    float4x3 BW_vx;
				    
				    float2 skewUV = mul(float2x2 (1.0 , 0.0 , -0.57735027 , 1.15470054), UV * 3.464);
				    
				    float2 vxID = float2 (floor(skewUV));
				    float3 barry = float3 (frac(skewUV), 0);
				    barry.z = 1.0-barry.x-barry.y;
				    BW_vx = ((barry.z>0) ? 
				        float4x3(float3(vxID, 0), float3(vxID + float2(0, 1), 0), float3(vxID + float2(1, 0), 0), barry.zyx) :
				        float4x3(float3(vxID + float2 (1, 1), 0), float3(vxID + float2 (1, 0), 0), float3(vxID + float2 (0, 1), 0), float3(-barry.z, 1.0-barry.y, 1.0-barry.x)));
				    
				    float2 dx = ddx(UV);
				    float2 dy = ddy(UV);
				    
				    return mul(tex2D(tex, UV + hash2D2D(BW_vx[0].xy), dx, dy), BW_vx[3].x) + 
				            mul(tex2D(tex, UV + hash2D2D(BW_vx[1].xy), dx, dy), BW_vx[3].y) + 
				            mul(tex2D(tex, UV + hash2D2D(BW_vx[2].xy), dx, dy), BW_vx[3].z);
			}
			

			v2f VertexFunction (appdata v  ) {
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_TRANSFER_INSTANCE_ID(v,o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 objectToViewPos = UnityObjectToViewPos(v.vertex.xyz);
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord9.x = eyeDepth;
				
				
				
				o.ase_texcoord9.yzw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.vertex.w = 1;
				v.normal = v.normal;
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

			fixed4 frag ( v2f IN 
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


				sampler2D tex96_g112 = _Normal;
				float mulTime7_g112 = _Time.y * float(0.0075);
				float temp_output_68_0_g112 = float(4.18);
				float2 appendResult105_g112 = (float2(worldPos.x , worldPos.z));
				float2 temp_output_104_0_g112 = ( ( float4(0.075,0.025,0,0).xy * temp_output_68_0_g112 * appendResult105_g112 ) + float4(0.075,0.025,0,0).zw );
				float2 panner17_g112 = ( mulTime7_g112 * float4(0,-1,0,0) + temp_output_104_0_g112);
				float2 UV96_g112 = ( panner17_g112 + 0.25 );
				float _NormalScale96_g112 = _NormalScale;
				float3 localtex2DStochasticNormals96_g112 = tex2DStochasticNormals( tex96_g112 , UV96_g112 , _NormalScale96_g112 );
				sampler2D tex79_g112 = _Normal;
				float mulTime4_g112 = _Time.y * float(0.0075);
				float2 panner12_g112 = ( ( mulTime4_g112 * 2.179 ) * float4(0,-1,0,0) + ( 1.0 - temp_output_104_0_g112 ));
				float2 UV79_g112 = ( 1.0 - panner12_g112 );
				float _NormalScale79_g112 = _NormalScale;
				float3 localtex2DStochasticNormals79_g112 = tex2DStochasticNormals( tex79_g112 , UV79_g112 , _NormalScale79_g112 );
				sampler2D tex76_g112 = _SecondaryNormal;
				float mulTime16_g112 = _Time.y * float(0.05);
				float2 panner21_g112 = ( mulTime16_g112 * float4(0,-1,0,0) + ( ( float4(1,1,0,0).xy * temp_output_68_0_g112 * appendResult105_g112 ) + float4(1,1,0,0).zw ));
				float2 UV76_g112 = panner21_g112;
				float _NormalScale76_g112 = _NormalScaleSecondary;
				float3 localtex2DStochasticNormals76_g112 = tex2DStochasticNormals( tex76_g112 , UV76_g112 , _NormalScale76_g112 );
				float3 normalizeResult66_g112 = normalize( BlendNormals( BlendNormals( localtex2DStochasticNormals96_g112 , localtex2DStochasticNormals79_g112 ) , localtex2DStochasticNormals76_g112 ) );
				float3 Normals80 = normalizeResult66_g112;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal891 = Normals80;
				float3 worldNormal891 = normalize( float3(dot(tanToWorld0,tanNormal891), dot(tanToWorld1,tanNormal891), dot(tanToWorld2,tanNormal891)) );
				float fresnelNdotV888 = dot( worldNormal891, worldViewDir );
				float fresnelNode888 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV888, 5.0 ) );
				float localDepthCheck1211 = ( 0.0 );
				float width1211 = 17;
				{
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS
				_CameraDepthTexture.GetDimensions(width1211, width1211);
				#endif
				}
				float localscreenDepth1217 = ( 0.0 );
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 SP1217 = ase_screenPosNorm;
				float ScreenDepth1217 = 0;
				{
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS
				ScreenDepth1217 = LinearEyeDepth(_CameraDepthTexture.Sample(sampler_CameraDepthTexture, SP1217.xy));
				#else
				ScreenDepth1217 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, SP1217.xy ));
				#endif
				}
				float eyeDepth = IN.ase_texcoord9.x;
				float ifLocalVar1210 = 0;
				if( width1211 <= 16.0 )
				ifLocalVar1210 = 1.0;
				else
				ifLocalVar1210 = ( ( ScreenDepth1217 - eyeDepth ) * ( 1.0 - float(0.836) ) );
				float WaterDepth671 = ifLocalVar1210;
				float4 lerpResult894 = lerp( float4(0.005412819,0,0.4912431,0) , ( float4(0.005412819,0,0.4912431,0) * fresnelNode888 ) , saturate( ( WaterDepth671 * 0.5 ) ));
				float3 temp_cast_0 = (1.0).xxx;
				float dotResult1179 = dot( Normals80 , temp_cast_0 );
				float GeneralFoam673 = saturate( ( ( ( dotResult1179 * float(4.79) * float(0.471) ) - ( float(4.79) * ( 1.0 - float(0.471) ) ) ) * saturate( ( WaterDepth671 * float(0.378) ) ) ) );
				float localDepthCheck1202 = ( 0.0 );
				float width1202 = 17;
				{
				_CameraDepthTexture.GetDimensions(width1202, width1202);
				}
				sampler2D tex340 = _SeaFoam;
				float2 appendResult1221 = (float2(worldPos.x , worldPos.z));
				float2 NormalVector625 = float4(0,-1,0,0);
				float mulTime344 = _Time.y * float(0.025);
				float2 UV340 = ( ( ( float4(1,1,0,0).xy * appendResult1221 * float(4.18) ) + float4(1,1,0,0).zw ) + ( NormalVector625 * mulTime344 ) );
				float4 localtex2DStochastic340 = tex2DStochastic( tex340 , UV340 );
				float ifLocalVar1203 = 0;
				if( width1202 > 16.0 )
				ifLocalVar1203 = ( saturate( ( localtex2DStochastic340.y - saturate( ( WaterDepth671 * float(0.7) ) ) ) ) * float(0.3) );
				
				o.Albedo = ( lerpResult894 + ( GeneralFoam673 + ifLocalVar1203 ) ).rgb;
				o.Normal = Normals80;
				o.Emission = half3( 0, 0, 0 );
				#if defined(_SPECULAR_SETUP)
					o.Specular = fixed3( 0, 0, 0 );
				#else
					o.Metallic = 0;
				#endif
				o.Smoothness = ( saturate( ( 1.0 - ( ifLocalVar1203 + GeneralFoam673 ) ) ) * float(0) );
				o.Occlusion = 1;
				o.Alpha = saturate( ( WaterDepth671 + ( Normals80.y * float(0.2) ) ) );
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































































































































































































        

