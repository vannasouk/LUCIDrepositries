// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Moriohs Shaders/Enviroment Shaders/Underwater Depth"
{
	Properties
	{
		[ShaderOptimizerLockButton]_ShaderOptimizerEnabled("PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER", Float) = 0
		[ToggleUI][Header(DEPTH SETTINGS)][Space(5)]_ToggleDepth("ToggleDepth", Float) = 1
		_Color("Color", Color) = (0,0.4078431,0.6901961,1)
		_ColorSecondary("Color Secondary", Color) = (0,1,0.8705882,0.5019608)
		_GeneralDepth("General Depth", Float) = 10
		_Depthsmoothing("Depth smoothing", Float) = 8
		[ToggleUI][Space(25)][Header(CAUSTICS)][Space(5)]_ToggleCaustics("ToggleCaustics", Float) = 1
		_CausticsIntensity("Caustics Intensity", Float) = 1
		_CausticsScale("Caustics Scale", Float) = 3
		_CausticsScrollSpeed("Caustics Scroll Speed", Range( -2 , 2)) = 0.075
		_CausticsDepthFade("Caustics Depth Fade", Float) = 1
		_CausticsEdgeFalloff("Caustics Edge Falloff", Range( 0 , 100)) = 25

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent+1" }
	LOD 0

		CGINCLUDE
		#pragma target 5.0
		ENDCG
		Blend One OneMinusSrcAlpha
		AlphaToMask Off
		Cull Front
		ColorMask RGB
		ZWrite Off
		ZTest Always
		
		
		GrabPass{ "_GrabTexture" }

		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _ShaderOptimizerEnabled;
			uniform float4 _Color;
			uniform float4 _ColorSecondary;
			uniform float _GeneralDepth;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Depthsmoothing;
			uniform float _ToggleDepth;
			uniform float _CausticsScale;
			uniform float _CausticsScrollSpeed;
			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _CausticsIntensity;
			uniform float _CausticsEdgeFalloff;
			uniform float _CausticsDepthFade;
			uniform float _ToggleCaustics;
			float2 UnStereo( float2 UV )
			{
				#if UNITY_SINGLE_PASS_STEREO
				float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
				UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
				#endif
				return UV;
			}
			
			float3 InvertDepthDir72_g2( float3 In )
			{
				float3 result = In;
				#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
				result *= float3(1,1,-1);
				#endif
				return result;
			}
			
			float SurfaceDepth( float In0 )
			{
				return UNITY_Z_0_FAR_FROM_CLIPSPACE(In0);
			}
			
					float2 voronoihash187( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi187( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash187( n + g );
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
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 localBoundingBox504 = ( float3( 0,0,0 ) );
				float3 vertexOffset504 = float3( 0,0,0 );
				{
				//Thanks to s-ilent's WaterVolume Shader https://gitlab.com/s-ilent/clear-water/-/blob/master/Shader/Clear%20Water/CW3/WaterVolume.shader?ref_type=heads#L90
				float3 localCameraPos = mul(unity_WorldToObject, _WorldSpaceCameraPos.xyz - unity_ObjectToWorld._m03_m13_m23);
				float3 minCorner = 0.0 - 1.0 * 0.5;
				float3 maxCorner = 0.0 + 1.0 * 0.5;
				bool isVisible = all(localCameraPos >= minCorner) && all(localCameraPos <= maxCorner);
				// if we're outside the box, set vertex pos to discard
				if (!isVisible) vertexOffset504 = (0,0,1e+9);
				}
				
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				
				o.ase_texcoord2 = v.vertex;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexOffset504;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 screenPos = i.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth395 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float2 UV22_g3 = ase_screenPosNorm.xy;
				float2 localUnStereo22_g3 = UnStereo( UV22_g3 );
				float2 break64_g2 = localUnStereo22_g3;
				float clampDepth69_g2 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g2 = ( 1.0 - clampDepth69_g2 );
				#else
				float staticSwitch38_g2 = clampDepth69_g2;
				#endif
				float3 appendResult39_g2 = (float3(break64_g2.x , break64_g2.y , staticSwitch38_g2));
				float4 appendResult42_g2 = (float4((appendResult39_g2*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g2 = mul( unity_CameraInvProjection, appendResult42_g2 );
				float3 temp_output_46_0_g2 = ( (temp_output_43_0_g2).xyz / (temp_output_43_0_g2).w );
				float3 In72_g2 = temp_output_46_0_g2;
				float3 localInvertDepthDir72_g2 = InvertDepthDir72_g2( In72_g2 );
				float4 appendResult49_g2 = (float4(localInvertDepthDir72_g2 , 1.0));
				float4 temp_output_179_0 = mul( unity_CameraToWorld, appendResult49_g2 );
				float3 worldToObj181 = mul( unity_WorldToObject, float4( temp_output_179_0.xyz, 1 ) ).xyz;
				float3 temp_output_184_0 = ( worldToObj181 * 2 );
				float temp_output_499_0 = ( pow( saturate( ( ( _GeneralDepth - eyeDepth395 ) / _GeneralDepth ) ) , _Depthsmoothing ) * max( temp_output_184_0.y , 0.0 ) );
				float4 lerpResult63 = lerp( ( _Color * _Color.a ) , ( _ColorSecondary * _ColorSecondary.a ) , temp_output_499_0);
				float4 unityObjectToClipPos390 = UnityObjectToClipPos( i.ase_texcoord2.xyz );
				float4 computeGrabScreenPos391 = ComputeGrabScreenPos( unityObjectToClipPos390 );
				float In0393 = computeGrabScreenPos391.z;
				float localSurfaceDepth393 = SurfaceDepth( In0393 );
				float temp_output_131_0 = ( ( 1.0 - pow( saturate( ( ( _GeneralDepth - localSurfaceDepth393 ) / _GeneralDepth ) ) , _Depthsmoothing ) ) * ( 1.0 - temp_output_499_0 ) );
				float4 appendResult72 = (float4(( (lerpResult63).rgb * temp_output_131_0 ) , temp_output_131_0));
				float mulTime178 = _Time.y * _CausticsScrollSpeed;
				float time187 = ( ( mulTime178 * 2.179 ) * 10.0 );
				float2 voronoiSmoothId187 = 0;
				float2 coords187 = (temp_output_179_0).xz * _CausticsScale;
				float2 id187 = 0;
				float2 uv187 = 0;
				float voroi187 = voronoi187( coords187, time187, id187, uv187, 0, voronoiSmoothId187 );
				float smoothstepResult189 = smoothstep( 0.133 , 1.0 , voroi187);
				float4 screenColor190 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_screenPosNorm.xy);
				float4 temp_output_194_0 = ( smoothstepResult189 * screenColor190 );
				float4 lerpResult196 = lerp( temp_output_194_0 , ( temp_output_194_0 * 3.0 ) , saturate( pow( smoothstepResult189 , 3.0 ) ));
				float3 break192 = abs( temp_output_184_0 );
				float temp_output_204_0 = saturate( ( ( 1.0 - max( max( break192.x , break192.y ) , break192.z ) ) * _CausticsEdgeFalloff ) );
				float3 lerpResult270 = lerp( ( (( max( ( lerpResult196 * 2.0 ) , float4( 0,0,0,0 ) ) * _CausticsIntensity )).rgb * temp_output_204_0 ) , float3( 0,0,0 ) , temp_output_131_0);
				
				
				finalColor = ( ( appendResult72 * _ToggleDepth ) + float4( ( ( lerpResult270 * saturate( ( temp_output_184_0.y - _CausticsDepthFade ) ) ) * _ToggleCaustics ) , 0.0 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18935
717;13;1925;976;-795.6521;305.3664;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;252;-1290.148,846;Inherit;False;2965.955;1040.498;;21;339;314;276;207;255;270;250;204;216;202;256;200;254;184;181;183;179;175;367;362;405;Omni Decal Caustics;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;175;-1248,1296;Inherit;False;2119.958;563.2843;Caustic calc;21;189;205;201;203;199;196;197;194;195;190;187;186;185;182;180;177;178;176;296;304;388;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-1200,1456;Inherit;False;Property;_CausticsScrollSpeed;Caustics Scroll Speed;10;0;Create;True;0;0;0;False;0;False;0.075;-0.07;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-928,1536;Inherit;False;Constant;_Float1;Float 1;9;0;Create;True;0;0;0;False;0;False;2.179;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;178;-928,1456;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-752,1456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;179;-1104,1040;Inherit;False;Reconstruct World Position From Depth;-1;;2;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;485;-1952,-64;Inherit;False;1838.5;581.6;All in one system, upper surface depth(top part) + surface depth(bottom part);21;422;414;425;499;413;424;409;496;408;426;421;419;393;392;418;395;401;391;390;396;389;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;183;-720,1104;Inherit;False;True;False;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;389;-1904,-16;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;182;-640,1552;Inherit;False;Property;_CausticsScale;Caustics Scale;9;0;Create;True;0;0;0;False;0;False;3;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-608,1456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;181;-720,960;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;390;-1728,-16;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;187;-416,1392;Inherit;True;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;186;-416,1664;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;189;-224,1392;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.133;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;254;-496,1088;Inherit;False;599;190;Boxprojection;4;198;193;192;188;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenColorNode;190;-224,1664;Inherit;False;Global;_GrabTexture;GrabTexture;2;0;Create;True;0;0;0;False;0;False;Object;-1;True;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;396;-1408,320;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComputeGrabScreenPosHlpNode;391;-1536,-16;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-208,1520;Inherit;False;Constant;_HFLH;HFLH;10;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleNode;184;-496,960;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-32,1488;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;188;-448,1136;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;296;-48,1392;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;395;-1216,320;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;392;-1328,-16;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;401;-1264,128;Inherit;False;Property;_GeneralDepth;General Depth;4;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;96,1488;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;192;-320,1136;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;195;96,1392;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;418;-1024,304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;393;-1184,32;Inherit;False;return UNITY_Z_0_FAR_FROM_CLIPSPACE(In0)@;1;Create;1;True;In0;FLOAT;0;In;;Inherit;False;SurfaceDepth;False;False;0;;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;419;-880,304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;272,1472;Inherit;False;Constant;_Float5;Float 5;55;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;408;-1024,0;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;193;-176,1136;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;196;256,1344;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;421;-752,304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;198;-48,1136;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;416,1344;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;426;-784,128;Inherit;False;Property;_Depthsmoothing;Depth smoothing;5;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;127;270,126;Inherit;False;929;454;Depth Color;6;63;74;109;60;108;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;409;-880,0;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;339;-112,896;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PowerNode;424;-592,304;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;103;320,368;Inherit;False;Property;_ColorSecondary;Color Secondary;3;0;Create;True;0;0;0;False;0;False;0,1,0.8705882,0.5019608;0,1,0.8705882,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;200;112,960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;201;576,1344;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;203;416,1440;Inherit;False;Property;_CausticsIntensity;Caustics Intensity;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;112,1040;Inherit;False;Property;_CausticsEdgeFalloff;Caustics Edge Falloff;12;0;Create;True;0;0;0;False;0;False;25;15;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;496;-576,400;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;320,176;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;0,0.4078431,0.6901961,1;0,0.4078422,0.6901961,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;413;-752,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;720,1344;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;560,368;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;425;-592,0;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;499;-432,304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;384,960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;560,176;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;63;816,256;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;216;896,1344;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;204;512,960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;367;928,1488;Inherit;False;Property;_CausticsDepthFade;Caustics Depth Fade;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;422;-288,272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;414;-432,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;1120,1344;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-48,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;405;1152,1472;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;74;976,256;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;1280,-32;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;270;1280,1344;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;314;1296,1472;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;274;1376.164,60.71608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;362;1456,1344;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;503;1424,144;Inherit;False;Property;_ToggleCaustics;ToggleCaustics;7;0;Create;True;0;0;0;False;4;ToggleUI;Space(25);Header(CAUSTICS);Space(5);False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;501;1440,64;Inherit;False;Property;_ToggleDepth;ToggleDepth;1;0;Create;True;0;0;0;False;3;ToggleUI;Header(DEPTH SETTINGS);Space(5);False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;1440,-32;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;255;-336,912;Inherit;False;206;161;Sperical Projection;1;209;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;502;1632,80;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;500;1632,-32;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;519;1808,80;Inherit;False;251.6724;165;Handle visibility Bounding Box;1;504;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;484;-1664,-496;Inherit;False;1525;393;upper surface depth round;9;17;7;8;3;2;1;5;469;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;276;1504,944;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;5;-704,-416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;207;672,960;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-1040,-432;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;1;-1296,-416;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;3;-1616,-288;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;469;-480,-416;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-320,-416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;209;-288,960;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-848,-416;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-1584,-452.7917;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;253;2112,-128;Inherit;False;Property;_ShaderOptimizerEnabled;PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER;0;0;Create;False;0;0;0;True;1;ShaderOptimizerLockButton;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;266;1808,-32;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1296,-320;Inherit;False;Property;_start;Upper Surface Depth;6;0;Create;False;0;0;0;False;0;False;20;7.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;504;1840,128;Float;False;//Thanks to s-ilent's WaterVolume Shader https://gitlab.com/s-ilent/clear-water/-/blob/master/Shader/Clear%20Water/CW3/WaterVolume.shader?ref_type=heads#L90$float3 localCameraPos = mul(unity_WorldToObject, _WorldSpaceCameraPos.xyz - unity_ObjectToWorld._m03_m13_m23)@$float3 minCorner = 0.0 - 1.0 * 0.5@$float3 maxCorner = 0.0 + 1.0 * 0.5@$bool isVisible = all(localCameraPos >= minCorner) && all(localCameraPos <= maxCorner)@$$// if we're outside the box, set vertex pos to discard$if (!isVisible) vertexOffset = (0,0,1e+9)@;7;Create;1;True;vertexOffset;FLOAT3;0,0,0;Out;;Inherit;False;Bounding Box;False;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0;FLOAT3;2
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2176,-32;Float;False;True;-1;2;ASEMaterialInspector;0;1;Moriohs Shaders/Enviroment Shaders/Underwater Depth;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;3;1;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;1;False;-1;True;True;True;True;True;False;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;True;2;False;-1;True;7;False;-1;True;False;0;False;28;0;False;28;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=1;True;7;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;178;0;176;0
WireConnection;180;0;178;0
WireConnection;180;1;177;0
WireConnection;183;0;179;0
WireConnection;185;0;180;0
WireConnection;181;0;179;0
WireConnection;390;0;389;0
WireConnection;187;0;183;0
WireConnection;187;1;185;0
WireConnection;187;2;182;0
WireConnection;189;0;187;0
WireConnection;190;0;186;0
WireConnection;391;0;390;0
WireConnection;184;0;181;0
WireConnection;194;0;189;0
WireConnection;194;1;190;0
WireConnection;188;0;184;0
WireConnection;296;0;189;0
WireConnection;296;1;388;0
WireConnection;395;0;396;0
WireConnection;392;0;391;0
WireConnection;304;0;194;0
WireConnection;304;1;388;0
WireConnection;192;0;188;0
WireConnection;195;0;296;0
WireConnection;418;0;401;0
WireConnection;418;1;395;0
WireConnection;393;0;392;2
WireConnection;419;0;418;0
WireConnection;419;1;401;0
WireConnection;408;0;401;0
WireConnection;408;1;393;0
WireConnection;193;0;192;0
WireConnection;193;1;192;1
WireConnection;196;0;194;0
WireConnection;196;1;304;0
WireConnection;196;2;195;0
WireConnection;421;0;419;0
WireConnection;198;0;193;0
WireConnection;198;1;192;2
WireConnection;199;0;196;0
WireConnection;199;1;197;0
WireConnection;409;0;408;0
WireConnection;409;1;401;0
WireConnection;339;0;184;0
WireConnection;424;0;421;0
WireConnection;424;1;426;0
WireConnection;200;0;198;0
WireConnection;201;0;199;0
WireConnection;496;0;339;1
WireConnection;413;0;409;0
WireConnection;205;0;201;0
WireConnection;205;1;203;0
WireConnection;108;0;103;0
WireConnection;108;1;103;4
WireConnection;425;0;413;0
WireConnection;425;1;426;0
WireConnection;499;0;424;0
WireConnection;499;1;496;0
WireConnection;202;0;200;0
WireConnection;202;1;256;0
WireConnection;109;0;60;0
WireConnection;109;1;60;4
WireConnection;63;0;109;0
WireConnection;63;1;108;0
WireConnection;63;2;499;0
WireConnection;216;0;205;0
WireConnection;204;0;202;0
WireConnection;422;0;499;0
WireConnection;414;0;425;0
WireConnection;250;0;216;0
WireConnection;250;1;204;0
WireConnection;131;0;414;0
WireConnection;131;1;422;0
WireConnection;405;0;339;1
WireConnection;405;1;367;0
WireConnection;74;0;63;0
WireConnection;273;0;74;0
WireConnection;273;1;131;0
WireConnection;270;0;250;0
WireConnection;270;2;131;0
WireConnection;314;0;405;0
WireConnection;274;0;131;0
WireConnection;362;0;270;0
WireConnection;362;1;314;0
WireConnection;72;0;273;0
WireConnection;72;3;274;0
WireConnection;502;0;362;0
WireConnection;502;1;503;0
WireConnection;500;0;72;0
WireConnection;500;1;501;0
WireConnection;276;0;270;0
WireConnection;276;3;207;0
WireConnection;5;0;9;0
WireConnection;207;0;204;0
WireConnection;8;0;7;0
WireConnection;8;1;1;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;469;0;5;0
WireConnection;469;1;426;0
WireConnection;17;0;469;0
WireConnection;209;0;184;0
WireConnection;9;0;8;0
WireConnection;9;1;7;0
WireConnection;266;0;500;0
WireConnection;266;1;502;0
WireConnection;0;0;266;0
WireConnection;0;1;504;2
ASEEND*/
//CHKSM=43B9F88200F1FA9A7E30B18A29A6D6B1C8C57038