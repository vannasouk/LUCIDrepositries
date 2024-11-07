Shader "Moriohs Shader"
{
    Properties
    {
        [ShaderVersion]Version("", int) = 0
        [ShaderOptimizerLockButton]_ShaderOptimizerEnabled("PLEASE IMPORT KAJSHADEROPTIMIZER SCRIPT WITHIN ITS EDITOR FOLDER", Float) = 0
        [PresetsEnum] _Mode ("Rendering Mode;Opaque,RenderQueue=-1,RenderType=,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=1,_DstBlend=0,_SrcBlendAlpha=1,_DstBlendAlpha=0,_AlphaToMask=0,_ZWrite=1,_ZTest=4;Cutout,RenderQueue=2450,RenderType=TransparentCutout,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=1,_DstBlend=0,_SrcBlendAlpha=1,_DstBlendAlpha=0,_AlphaToMask=0,_ZWrite=1,_ZTest=4;Fade,RenderQueue=3000,RenderType=Transparent,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=5,_DstBlend=10,_SrcBlendAlpha=5,_DstBlendAlpha=10,_AlphaToMask=0,_ZWrite=0,_ZTest=4;Transparent,RenderQueue=3000,RenderType=Transparent,_BlendOp=0,_BlendOpAlpha=0,_SrcBlend=1,_DstBlend=10,_SrcBlendAlpha=1,_DstBlendAlpha=10,_AlphaToMask=0,_ZWrite=0,_ZTest=4", Int) = 0
        
        //Main Settings
        [HideInInspector]group_MainSettings("Main Settings", Int) = 0
            _Cutoff ("Cutout", Range(0, 1)) = 0
            _Color ("Color", Color) = (1,1,1,1)
            _MainTex ("MainTex", 2D) = "white" {}
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_MainTexUVSwitch ("UV Set", Int) = 0
            _OcclusionMap ("Occlusion Map", 2D) = "white" {}
            _OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 0
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_OcclusionMapUVSwitch ("UV Set", Int) = 0
        [HideInInspector][ToggleUI]group_toggle_BRDF("Unity BRDF", Int) = 0
            _Metallic ("Metallic", Range(0, 1)) = 0 //we do not do [Gamma] here cause the optimizer will kill it, so we compute it in Shader
            _Glossiness ("Smoothness", Range(0, 1)) = 0.5
            [ToggleUI]_BRDFReflInheritAniso ("Inherit Anisotropy", Int) = 0
            _MetallicGlossMap ("Metallic", 2D) = "white" {}
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_MetallicGlossMapUVSwitch ("UV Set", Int) = 0
            _ReflectionMask ("Reflection Mask", 2D) = "white" {}
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_ReflectionMaskUVSwitch ("UV Set", Int) = 0
            _BakedCubemap ("Baked Cubemap", Cube) = "white" {}
            [ToggleUI]_EnableGSAA ("Enable GSAA", Int) = 1
            _GSAAVariance ("GSAA Variance", Range(0, 1)) = 0.15
            _GSAAThreshold ("GSAA Threshold", Range(0, 1)) = 0.1
        [HideInInspector]end_BRDF("", Int) = 0
        [HideInInspector]group_Toon("Toon shenaniganz", Int) = 0
            _ShadowLift ("Shadow Lift/Toon scaler", Range(0, 1)) = 0
            _ShadowSqueeze ("Shadow Squeeze", Range(1, 10)) = 1
        [HideInInspector]end_Toon("", Int) = 0
        [HideInInspector]end_MainSettings("", Int) = 1 //1 = extend
        
        //Normal Maps
        [HideInInspector]group_NormalMaps("Normal Maps", Int) = 0
            [Normal]_BumpMap("Normal Map", 2D) = "bump" {}
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_BumpMapUVSwitch ("UV Set", Int) = 0
            _BumpScale ("Normal Map Scale", Range(-2, 2)) = 0
            [Normal]_DetailNormalMap("Detailed Normal Map", 2D) = "bump" {}
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_DetailNormalMapUVSwitch ("UV Set", Int) = 0
            _DetailNormalMapScale ("Detailed Normal Map Scale", Range(-2, 2)) = 0
            _NormalMapMask ("Normal Map Mask", 2D) = "white" {}
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_NormalMapMaskUVSwitch ("UV Set", Int) = 0
        [HideInInspector]end_NormalMaps("", Int) = 0
        
        //Emission
        [HideInInspector]group_Emission("Emission", Int) = 0
            [HDR]_EmissionColor ("Emission Color", Color) = (1,1,1,1)
            _Emission ("Emission", 2D) = "black" {}
            _EmissionTint ("Emission Tint", Range(0, 1)) = 0
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_EmissionUVSwitch ("UV Set", Int) = 0
        [HideInInspector]end_Emission("", Int) = 0
        
        //Matcap
        [HideInInspector]group_Matcap("Matcap", Int) = 0
            //R1
            [HideInInspector][ToggleUI]group_toggle_MatcapR1("Matcap R1", Int) = 0
                _MatcapR1Color ("Matcap Color", Color) = (1,1,1,1)
                _MatcapR1 ("Matcap R1", 2D) = "white" {}
                [Enum(Multiply,0,Additive,1)]_MatcapR1Mode ("Matcap Blending", Range(0, 1)) = 0
                _MatcapR1Blending ("Matcap Blending", Range(0, 1)) = 0
                _MatcapR1Intensity ("Matcap Intensity", Range(0, 1)) = 1
                _MatcapR1smoothness ("Matcap Smoothness", Range(0, 1)) = 1
                _MatcapR1Tint ("Matcap Tint (Add)", Range(0, 1)) = 1
            [HideInInspector]end_MatcapR1("", Int) = 0
            //G2
            [HideInInspector][ToggleUI]group_toggle_MatcapG2("Matcap G2", Int) = 0
                _MatcapG2Color ("Matcap Color", Color) = (1,1,1,1)
                _MatcapG2 ("Matcap G2", 2D) = "white" {}
                [Enum(Multiply,0,Additive,1)]_MatcapG2Mode ("Matcap Blending", Range(0, 1)) = 0
                _MatcapG2Blending ("Matcap Blending", Range(0, 1)) = 0
                _MatcapG2Intensity ("Matcap Intensity", Range(0, 1)) = 1
                _MatcapG2smoothness ("Matcap Smoothness", Range(0, 1)) = 1
                _MatcapG2Tint ("Matcap Tint (Add)", Range(0, 1)) = 1
            [HideInInspector]end_MatcapG2("", Int) = 0
            //B3
            [HideInInspector][ToggleUI]group_toggle_MatcapB3("Matcap B3", Int) = 0
                _MatcapB3Color ("Matcap Color", Color) = (1,1,1,1)
                _MatcapB3 ("Matcap B3", 2D) = "white" {}
                [Enum(Multiply,0,Additive,1)]_MatcapB3Mode ("Matcap Blending", Range(0, 1)) = 0
                _MatcapB3Blending ("Matcap Blending", Range(0, 1)) = 0
                _MatcapB3Intensity ("Matcap Intensity", Range(0, 1)) = 1
                _MatcapB3smoothness ("Matcap Smoothness", Range(0, 1)) = 1
                _MatcapB3Tint ("Matcap Tint (Add)", Range(0, 1)) = 1
            [HideInInspector]end_MatcapB3("", Int) = 0
            //A4
            [HideInInspector][ToggleUI]group_toggle_MatcapA4("Matcap A4", Int) = 0
                _MatcapA4Color ("Matcap Color", Color) = (1,1,1,1)
                _MatcapA4 ("Matcap A4", 2D) = "white" {}
                [Enum(Multiply,0,Additive,1)]_MatcapA4Mode ("Matcap Blending", Range(0, 1)) = 0
                _MatcapA4Blending ("Matcap Blending", Range(0, 1)) = 0
                _MatcapA4Intensity ("Matcap Intensity", Range(0, 1)) = 1
                _MatcapA4smoothness ("Matcap Smoothness", Range(0, 1)) = 1
                _MatcapA4Tint ("Matcap Tint (Add)", Range(0, 1)) = 1
            [HideInInspector]end_MatcapA4("", Int) = 0
        _MatcapMask ("Matcap Mask RGBA", 2D) = "white" {}
        [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_MatcapMaskUVSwitch ("UV Set", Int) = 0
        [HideInInspector]end_Matcap("", Int) = 0
        
        //Specular
        [HideInInspector]group_Specular("Specular Highlights", Int) = 0
            [HideInInspector][ToggleUI]group_toggle_SpecularAniso("GGX Aniso", Int) = 0
                _SpecularMap ("Specular Map", 2D) = "white" {}
                [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_SpecularMapUVSwitch ("UV Set", Int) = 0
                _SpecularIntensity ("Specular Intensity", Range(0, 1)) = 1
                _AnisoF0Reflectance ("f0 Reflectance (metallic)", Range(0, 1)) = 0
                _SpecularArea ("Specular smoothness", Range(0, 0.911)) = 0.5
                _Anisotropy ("Anisotropy", Range(-1, 1)) = 0.75
                _SpecularAlbedoTint ("Albedo Tint", Range(0, 1)) = 0
                [ToggleUI]_SpecularSharpness ("Toon Style", Int) = 0
                [ToggleUI]_AnisoFlickerFix ("Bad Topology/Flicker Fix", Int) = 0
                [ToggleUI]_EnableGSAA ("Enable GSAA", Int) = 1
                _GSAAVariance ("GSAA Variance", Range(0, 1)) = 0.15
                _GSAAThreshold ("GSAA Threshold", Range(0, 1)) = 0.1
            [HideInInspector]end_SpecularAniso("", Int) = 0
        [HideInInspector]end_Specular("", Int) = 0
        
        //SSS
        [HideInInspector][ToggleUI]group_toggle_SSS("Subsurface Scattering", Int) = 0
            _SSSColor ("SSS Color", Color) = (1,1,1,1)
            _SSSIntensity ("SSS Intensity", float) = 1
            _SSSTint ("SSS Tint", Range(0, 1)) = 0.975
            _SubsurfaceDistortionModifier ("Distortion Modifier", float) = 0
            _SSSPower ("SSS Power", float) = 1
            _SSSThickenessMap ("SSS Thickeness Map", 2D) = "white" {}
            [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_SSSThickenessMapUVSwitch ("UV Set", Int) = 0
        [HideInInspector]end_SSS("", Int) = 0
        
        ////Dissolve
        //[HideInInspector][ToggleUI]group_toggle_Dissolve("Dissolve", Int) = 0
        //    _DissolveModifier ("Dissolve Modifier", Range(-1, 1)) = 1
        //    _DissolvePattern ("Pattern", 2D) = "white" {}
        //    [Enum(UV0,0,UV1,1,UV2,2,UV3,3)]_DissolvePatternUVSwitch ("UV Set", Int) = 0
        //[Space(12)]
        //    [Enum(Separate,0,Merge,1,Reverse Merge,2)]_MaterializeLayerModeR ("Layer Mode Red", int) = 0
        //    [IntRange]_MaterializeColorLayerR("Color Layer R", Range( 0 , 100)) = 100
        //    _MaterializeR ("Materialize R", Range(-1, 1)) = -1
        //[Space(12)]
        //    [Enum(Separate,0,Merge,1,Reverse Merge,2)]_MaterializeLayerModeG ("Layer Mode Green", int) = 0
        //    [IntRange]_MaterializeColorLayerG("Color Layer G", Range( 0 , 100)) = 100
        //    _MaterializeG ("Materialize G", Range(-1, 1)) = -1
        //[Space(12)]
        //    [Enum(Separate,0,Merge,1,Reverse Merge,2)]_MaterializeLayerModeB ("Layer Mode Blue", int) = 0
        //    [IntRange]_MaterializeColorLayerB("Color Layer B", Range( 0 , 100)) = 100
        //    _MaterializeB ("Materialize B", Range(-1, 1)) = -1
        //[Space(12)]
        //    [Enum(Separate,0,Merge,1,Reverse Merge,2)]_MaterializeLayerModeA ("Layer Mode Alpha", int) = 0
        //    [IntRange]_MaterializeColorLayerA("Color Layer A", Range( 0 , 100)) = 100
        //    _MaterializeA ("Materialize A", Range(-1, 1)) = -1
        //[HideInInspector]end_Dissolve("", Int) = 0
            
        
        // Rendering Options
        [HideInInspector]group_RenderingOptions("Rendering Options", Int) = 0
            [GIFlags] _GIFlags ("Global Illumination", Int) = 4
            [DisabledLightModes] _LightModes ("Disabled LightModes", Int) = 0
            [DisableBatching] _DisableBatching ("Disable Batching", Int) = 0
            [PreviewType] _PreviewType ("Preview Type", Int) = 0
            [OverrideTagToggle(IgnoreProjector)] _IgnoreProjector ("IgnoreProjector", Int) = 0
            [OverrideTagToggle(ForceNoShadowCasting)] _ForceNoShadowCasting ("ForceNoShadowCasting", Int) = 0
            [OverrideTagToggle(CanUseSpriteAtlas)] _CanUseSpriteAtlas ("CanUseSpriteAtlas", Int) = 1
            [ToggleUI]_AlphaToMask ("Alpha To Coverage", Int) = 0
        
        [HideInInspector]group_Blending("Blending Options", Int) = 0
            [WideEnum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Int) = 2
            [WideEnum(Off,0,On,1)] _ZWrite ("ZWrite", Int) = 1
            [WideEnum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 4
            _OffsetFactor("Offset Factor", Float) = 0
            _OffsetUnits("Offset Units", Float) = 0
            [WideEnum(MoriohsShader.BlendOp)]_BlendOp ("RGB Blend Op", Int) = 0
            [WideEnum(MoriohsShader.BlendOp)]_BlendOpAlpha ("Alpha Blend Op", Int) = 0
            [WideEnum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("RGB Source Blend", Int) = 1
            [WideEnum(UnityEngine.Rendering.BlendMode)] _DstBlend ("RGB Destination Blend", Int) = 0
            [WideEnum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlpha ("Alpha Source Blend", Int) = 1
            [WideEnum(UnityEngine.Rendering.BlendMode)] _DstBlendAlpha ("Alpha Destination Blend", Int) = 0
            [WideEnum(MoriohsShader.ColorMask)] _ColorMask("Color Mask", Int) = 15
        [HideInInspector]end_Blending("", Int) = 0

        [HideInInspector]group_Stencil("Stencil Options", Int) = 0
            [IntRange] _Stencil ("Reference Value", Range(0, 255)) = 0
            [IntRange] _StencilWriteMask ("ReadMask", Range(0, 255)) = 255
            [IntRange] _StencilReadMask ("WriteMask", Range(0, 255)) = 255
            [WideEnum(UnityEngine.Rendering.StencilOp)] _StencilPass ("Pass Op", Int) = 0
            [WideEnum(UnityEngine.Rendering.StencilOp)] _StencilFail ("Fail Op", Int) = 0
            [WideEnum(UnityEngine.Rendering.StencilOp)] _StencilZFail ("ZFail Op", Int) = 0
            [WideEnum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Compare Function", Int) = 8
            [HideInInspector]end_Stencil("", Int) = 0
        [HideInInspector]end_RenderingOptions("", Int) = 0
        [Header(Forward Rendering Options)]
        [Space(8)]
        [ToggleOff(_SPECULARHIGHLIGHTS_OFF)] _SpecularHighlights (";_SPECULARHIGHLIGHTS_OFF;;Specular Highlights (BRDF)", Int) = 0
        [ToggleOff(_GLOSSYREFLECTIONS_OFF)] _GlossyReflections (";_GLOSSYREFLECTIONS_OFF;;Reflections", Int) = 0
        //End of Rendering Options
    }

    CustomEditor "MoriohsShader.ShaderEditor"
    SubShader
    {
        CGINCLUDE
        #pragma target 5.0
        #pragma only_renderers d3d11 glcore gles3 vulkan nomrt
        #pragma vertex vert
        #pragma fragment frag
        ENDCG
        
        Tags {  "RenderType"="Opaque"
                "Queue"="Geometry+0"
                //"IgnoreProjector"="True"      // Override tags/editor toggle doesn't work on these
                //"ForceNoShadowCasting"="True" // Use the optimizer to lock in, which will uncomment if they're used
        }
        
        Cull [_Cull]
        ZTest [_ZTest]
        ColorMask [_ColorMask]
        Offset [_OffsetFactor], [_OffsetUnits]
        AlphaToMask [_AlphaToMask]
        
        Stencil
        {
            Ref [_Stencil]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilComp]
            Pass [_StencilPass]
            Fail [_StencilFail]
            ZFail [_StencilZFail]
        }

        Pass
        {
            Name "FORWARDBASE"
            Tags
            {
                "LightMode"="ForwardBase"
            }
            ZWrite [_ZWrite]
            Cull [_Cull]
            ZTest [_ZTest]
            AlphaToMask [_AlphaToMask]
            BlendOp [_BlendOp], [_BlendOpAlpha]
            Blend [_SrcBlend] [_DstBlend]

            CGPROGRAM
            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            //#pragma instancing_options
            //#pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma multi_compile _ VERTEXLIGHT_ON

            #pragma shader_feature_local _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature_local _GLOSSYREFLECTIONS_OFF
            
            #include "../CGIncludes/Base.cginc"
            ENDCG
        }

        Pass
        {
            Name "FORWARDADD"
            Tags
            {
                "LightMode"="ForwardAdd"
            }
            Fog
            {
                Color (0,0,0,0)
            }
            ZWrite Off
            BlendOp [_BlendOp], [_BlendOpAlpha]
            Blend [_SrcBlend] One
            Cull [_Cull]
            ZTest [_ZTest]
            AlphaToMask [_AlphaToMask]

            CGPROGRAM
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_instancing
            #pragma multi_compile_fog
            //#pragma instancing_options
            //#pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma shader_feature_local _SPECULARHIGHLIGHTS_OFF
            
            #include "../CGIncludes/Base.cginc"
            ENDCG
        }

        Pass
        {
            Name "SHADOWCASTER"
            Tags
            {
                "LightMode"="ShadowCaster"
            }
            AlphaToMask Off
            ZWrite On
            Cull [_Cull]
            ZTest LEqual

            CGPROGRAM
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            //#pragma instancing_options
            //#pragma multi_compile _ LOD_FADE_CROSSFADE
            
            #pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
            
            #include "../CGIncludes/Shadowcaster.cginc"
            ENDCG
        }
    }
    Fallback "Standard"
}
