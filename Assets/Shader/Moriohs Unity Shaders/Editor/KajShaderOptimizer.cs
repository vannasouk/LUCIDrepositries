#region
#if VRC_SDK_VRCSDK3
#endif
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.Build;
using UnityEngine;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;
#if VRC_SDK_VRCSDK3
using VRC.SDKBase.Editor.BuildPipeline;
#endif
#endregion


namespace MoriohsUnityShaders //This script is based off of Kaj's Shader Optimizer [https://github.com/DarthShader/Kaj-Unity-Shaders] and edited from [https://gitlab.com/Float3] and [https://github.com/z3y]
{

#if VRC_SDK_VRCSDK3

    public class LockMaterialsOnAvatarUpload : IVRCSDKPreprocessAvatarCallback
    {
        public int callbackOrder => 3;

        public bool OnPreprocessAvatar(GameObject avatarGameObject)
        {
            ShaderOptimizer.LockAllChildren(avatarGameObject);
            return true;
        }
    }


    public class LockMaterialsOnVrcWorldUpload : IVRCSDKBuildRequestedCallback
    {
        public int callbackOrder => 3;

        bool IVRCSDKBuildRequestedCallback.OnBuildRequested(VRCSDKRequestedBuildType requestedBuildType)
        {
#if !UNITY_ANDROID
            if (requestedBuildType == VRCSDKRequestedBuildType.Scene) ShaderOptimizer.LockAllMaterials();
#endif
            return true;
        }
    }
#endif


    public class UnlockOnPlatformChange : IActiveBuildTargetChanged
    {
        public int callbackOrder => 3;
        public void OnActiveBuildTargetChanged(BuildTarget previousTarget, BuildTarget newTarget)
        {
            ShaderOptimizer.UnlockAllMaterials();
        }
    }


    // Static methods to generate new shader files with in-place constants based on a material's properties
    // and link that new shader to the material automatically
    public class ShaderOptimizer
    {

        public enum PropertyType
        {
            Vector,
            Float
        }

        // For some reason, 'if' statements with replaced constant (literal) conditions cause some compilation error
        // So until that is figured out, branches will be removed by default
        // Set to false if you want to keep UNITY_BRANCH and [branch]
        public static bool RemoveUnityBranches = true;


        // LOD Crossfade Dithing doesn't have multi_compile keyword correctly toggled at build time (its always included) so
        // this hard-coded material property will uncomment //#pragma multi_compile _ LOD_FADE_CROSSFADE in optimized .shader files
        public static readonly string LODCrossFadePropertyName = "_LodCrossFade";




        // Material property suffix that controls whether the property of the same name gets baked into the optimized shader
        // e.g. if _Color exists and _ColorAnimated = 1, _Color will not be baked in
        public static readonly string AnimatedPropertySuffix = "Animated";

        public static readonly string OriginalShaderTag = "OriginalShader";
        public static readonly string ShaderOptimizerEnabled = "_ShaderOptimizerEnabled";


        // Material properties are put into each CGPROGRAM as preprocessor defines when the optimizer is run.
        // This is mainly targeted at culling interpolators and lines that rely on those interpolators.
        // (The compiler is not smart enough to cull VS output that isn't used anywhere in the PS)
        // Additionally, simply enabling the optimizer can define a keyword, whose name is stored here.
        // This keyword is added to the beginning of all passes, right after CGPROGRAM
        public static readonly string OptimizerEnabledKeyword = "OPTIMIZER_ENABLED";

        public static readonly string ReplaceAnimatedParametersPropertyName = "_ReplaceAnimatedParameters";
        private static bool _replaceAnimatedParameters;

        public static readonly string[] PropertiesToSkip =
        {
            ShaderOptimizerEnabled,
            "_BlendOp",
            "_BlendOpAlpha",
            "_SrcBlend",
            "_DstBlend",
            "_ZWrite",
            "_ZTest",
            "_Cull",
            "_MainTex"
        };

        public static readonly string[] TexelSizeCheck =
        {
            "_RNM0",
            "_RNM1",
            "_RNM2"
        };

        // Would be better to dynamically parse the "C:\Program Files\UnityXXXX\Editor\Data\CGIncludes\" folder
        // to get version specific includes but eh
        public static readonly string[] DefaultUnityShaderIncludes =
        {
            "UnityUI.cginc",
            "AutoLight.cginc",
            "GLSLSupport.glslinc",
            "HLSLSupport.cginc",
            "Lighting.cginc",
            "SpeedTreeBillboardCommon.cginc",
            "SpeedTreeCommon.cginc",
            "SpeedTreeVertex.cginc",
            "SpeedTreeWind.cginc",
            "TerrainEngine.cginc",
            "TerrainSplatmapCommon.cginc",
            "Tessellation.cginc",
            "UnityBuiltin2xTreeLibrary.cginc",
            "UnityBuiltin3xTreeLibrary.cginc",
            "UnityCG.cginc",
            "UnityCG.glslinc",
            "UnityCustomRenderTexture.cginc",
            "UnityDeferredLibrary.cginc",
            "UnityDeprecated.cginc",
            "UnityGBuffer.cginc",
            "UnityGlobalIllumination.cginc",
            "UnityImageBasedLighting.cginc",
            "UnityInstancing.cginc",
            "UnityLightingCommon.cginc",
            "UnityMetaPass.cginc",
            "UnityPBSLighting.cginc",
            "UnityShaderUtilities.cginc",
            "UnityShaderVariables.cginc",
            "UnityShadowLibrary.cginc",
            "UnitySprites.cginc",
            "UnityStandardBRDF.cginc",
            "UnityStandardConfig.cginc",
            "UnityStandardCore.cginc",
            "UnityStandardCoreForward.cginc",
            "UnityStandardCoreForwardSimple.cginc",
            "UnityStandardInput.cginc",
            "UnityStandardMeta.cginc",
            "UnityStandardParticleInstancing.cginc",
            "UnityStandardParticles.cginc",
            "UnityStandardParticleShadow.cginc",
            "UnityStandardShadow.cginc",
            "UnityStandardUtils.cginc"
        };

        public static readonly string[] DefaultUnityShaderNames =
        {
            "GUI/Text Shader",
            "Hidden/InternalClear",
            "Hidden/Internal-Colored",
            "Hidden/InternalErrorShader",
            "Hidden/FrameDebuggerRenderTargetDisplay",
            "Legacy Shaders/Transparent/Bumped Diffuse",
            "Legacy Shaders/Transparent/Bumped Specular",
            "Legacy Shaders/Transparent/Diffuse",
            "Legacy Shaders/Transparent/Specular",
            "Legacy Shaders/Transparent/Parallax Diffuse",
            "Legacy Shaders/Transparent/Parallax Specular",
            "Legacy Shaders/Transparent/VertexLit",
            "Legacy Shaders/Transparent/Cutout/Bumped Diffuse",
            "Legacy Shaders/Transparent/Cutout/Bumped Specular",
            "Legacy Shaders/Transparent/Cutout/Diffuse",
            "Legacy Shaders/Transparent/Cutout/Specular",
            "Legacy Shaders/Transparent/Cutout/Soft Edge Unlit",
            "Legacy Shaders/Transparent/Cutout/VertexLit",
            "AR/TangoARRender",
            "Autodesk Interactive",
            "Hidden/Compositing",
            "Hidden/CubeBlend",
            "Hidden/CubeBlur",
            "Hidden/CubeBlurOdd",
            "Hidden/CubeCopy",
            "Legacy Shaders/Decal",
            "FX/Flare",
            "Hidden/GIDebug/ShowLightMask",
            "Hidden/GIDebug/TextureUV",
            "Hidden/GIDebug/UV1sAsPositions",
            "Hidden/GIDebug/VertexColors",
            "Legacy Shaders/Self-Illumin/Bumped Diffuse",
            "Legacy Shaders/Self-Illumin/Bumped Specular",
            "Legacy Shaders/Self-Illumin/Diffuse",
            "Legacy Shaders/Self-Illumin/Specular",
            "Legacy Shaders/Self-Illumin/Parallax Diffuse",
            "Legacy Shaders/Self-Illumin/Parallax Specular",
            "Legacy Shaders/Self-Illumin/VertexLit",
            "Hidden/BlitCopy",
            "Hidden/BlitCopyDepth",
            "Hidden/BlitCopyWithDepth",
            "Hidden/BlitToDepth",
            "Hidden/BlitToDepth_MSAA",
            "Hidden/Internal-CombineDepthNormals",
            "Hidden/ConvertTexture",
            "Hidden/Internal-CubemapToEquirect",
            "Hidden/Internal-DeferredReflections",
            "Hidden/Internal-DeferredShading",
            "Hidden/Internal-DepthNormalsTexture",
            "Hidden/Internal-Flare",
            "Hidden/Internal-GUIRoundedRect",
            "Hidden/Internal-GUIRoundedRectWithColorPerBorder",
            "Hidden/Internal-GUITexture",
            "Hidden/Internal-GUITextureBlit",
            "Hidden/Internal-GUITextureClip",
            "Hidden/Internal-GUITextureClipText",
            "Hidden/Internal-Halo",
            "Hidden/Internal-MotionVectors",
            "Hidden/Internal-ODSWorldTexture",
            "Hidden/Internal-PrePassLighting",
            "Hidden/Internal-ScreenSpaceShadows",
            "Hidden/Internal-StencilWrite",
            "Hidden/Internal-UIRAtlasBlitCopy",
            "Hidden/Internal-UIRDefault",
            "Legacy Shaders/Lightmapped/Bumped Diffuse",
            "Legacy Shaders/Lightmapped/Bumped Specular",
            "Legacy Shaders/Lightmapped/Diffuse",
            "Legacy Shaders/Lightmapped/Specular",
            "Legacy Shaders/Lightmapped/VertexLit",
            "Mobile/Bumped Diffuse",
            "Mobile/Bumped Specular (1 Directional Realtime Light)",
            "Mobile/Bumped Specular",
            "Mobile/Diffuse",
            "Mobile/Unlit (Supports Lightmap)",
            "Mobile/Particles/Additive",
            "Mobile/Particles/VertexLit Blended",
            "Mobile/Particles/Alpha Blended",
            "Mobile/Particles/Multiply",
            "Mobile/Skybox",
            "Mobile/VertexLit (Only Directional Lights)",
            "Mobile/VertexLit",
            "Nature/Tree Soft Occlusion Bark",
            "Hidden/Nature/Tree Soft Occlusion Bark Rendertex",
            "Nature/Tree Soft Occlusion Leaves",
            "Hidden/Nature/Tree Soft Occlusion Leaves Rendertex",
            "Nature/SpeedTree",
            "Nature/SpeedTree8",
            "Nature/SpeedTree Billboard",
            "Hidden/Nature/Tree Creator Albedo Rendertex",
            "Nature/Tree Creator Bark",
            "Hidden/Nature/Tree Creator Bark Optimized",
            "Hidden/Nature/Tree Creator Bark Rendertex",
            "Nature/Tree Creator Leaves",
            "Nature/Tree Creator Leaves Fast",
            "Hidden/Nature/Tree Creator Leaves Fast Optimized",
            "Hidden/Nature/Tree Creator Leaves Optimized",
            "Hidden/Nature/Tree Creator Leaves Rendertex",
            "Hidden/Nature/Tree Creator Normal Rendertex",
            "Legacy Shaders/Bumped Diffuse",
            "Legacy Shaders/Bumped Specular",
            "Legacy Shaders/Diffuse",
            "Legacy Shaders/Diffuse Detail",
            "Legacy Shaders/Diffuse Fast",
            "Legacy Shaders/Specular",
            "Legacy Shaders/Parallax Diffuse",
            "Legacy Shaders/Parallax Specular",
            "Legacy Shaders/VertexLit",
            "Legacy Shaders/Particles/Additive",
            "Legacy Shaders/Particles/~Additive-Multiply",
            "Legacy Shaders/Particles/Additive (Soft)",
            "Legacy Shaders/Particles/Alpha Blended",
            "Legacy Shaders/Particles/Anim Alpha Blended",
            "Legacy Shaders/Particles/Blend",
            "Legacy Shaders/Particles/Multiply",
            "Legacy Shaders/Particles/Multiply (Double)",
            "Legacy Shaders/Particles/Alpha Blended Premultiply",
            "Particles/Standard Surface",
            "Particles/Standard Unlit",
            "Legacy Shaders/Particles/VertexLit Blended",
            "Legacy Shaders/Reflective/Bumped Diffuse",
            "Legacy Shaders/Reflective/Bumped Unlit",
            "Legacy Shaders/Reflective/Bumped Specular",
            "Legacy Shaders/Reflective/Bumped VertexLit",
            "Legacy Shaders/Reflective/Diffuse",
            "Legacy Shaders/Reflective/Specular",
            "Legacy Shaders/Reflective/Parallax Diffuse",
            "Legacy Shaders/Reflective/Parallax Specular",
            "Legacy Shaders/Reflective/VertexLit",
            "Skybox/Cubemap",
            "Skybox/Panoramic",
            "Skybox/Procedural",
            "Skybox/6 Sided",
            "Sprites/Default",
            "Sprites/Diffuse",
            "Sprites/Mask",
            "Standard",
            "Standard (Specular setup)",
            "Hidden/TerrainEngine/Details/Vertexlit",
            "Hidden/TerrainEngine/Details/WavingDoublePass",
            "Hidden/TerrainEngine/Details/BillboardWavingDoublePass",
            "Hidden/TerrainEngine/Splatmap/Diffuse-AddPass",
            "Hidden/TerrainEngine/Splatmap/Diffuse-Base",
            "Hidden/TerrainEngine/Splatmap/Diffuse-BaseGen",
            "Nature/Terrain/Diffuse",
            "Hidden/TerrainEngine/Splatmap/Specular-AddPass",
            "Hidden/TerrainEngine/Splatmap/Specular-Base",
            "Nature/Terrain/Specular",
            "Hidden/TerrainEngine/Splatmap/Standard-AddPass",
            "Hidden/TerrainEngine/Splatmap/Standard-Base",
            "Hidden/TerrainEngine/Splatmap/Standard-BaseGen",
            "Nature/Terrain/Standard",
            "Hidden/Nature/Terrain/Utilities",
            "Hidden/TerrainEngine/BillboardTree",
            "Hidden/TerrainEngine/CameraFacingBillboardTree",
            "Hidden/TerrainEngine/BrushPreview",
            "Hidden/TerrainEngine/CrossBlendNeighbors",
            "Hidden/TerrainEngine/GenerateNormalmap",
            "Hidden/TerrainEngine/PaintHeight",
            "Hidden/TerrainEngine/HeightBlitCopy",
            "Hidden/TerrainEngine/TerrainLayerUtils",
            "Hidden/TextCore/Distance Field SSD",
            "Hidden/TextCore/Distance Field",
            "Hidden/UI/CompositeOverdraw",
            "UI/Default",
            "UI/DefaultETC1",
            "UI/Default Font",
            "UI/Lit/Bumped",
            "UI/Lit/Detail",
            "UI/Lit/Refraction",
            "UI/Lit/Refraction Detail",
            "UI/Lit/Transparent",
            "Hidden/UI/Overdraw",
            "UI/Unlit/Detail",
            "UI/Unlit/Text",
            "UI/Unlit/Text Detail",
            "UI/Unlit/Transparent",
            "Unlit/Transparent",
            "Unlit/Transparent Cutout",
            "Unlit/Color",
            "Unlit/Texture",
            "Hidden/VideoComposite",
            "Hidden/VideoDecode",
            "Hidden/VideoDecodeAndroid",
            "Hidden/VideoDecodeML",
            "Hidden/VideoDecodeOSX",
            "Hidden/VR/BlitFromTex2DToTexArraySlice",
            "Hidden/VR/BlitTexArraySlice",
            "Hidden/VR/BlitTexArraySliceToDepth",
            "Hidden/VR/BlitTexArraySliceToDepth_MSAA",
            "Hidden/VR/Internal-VRDistortion",
            "VR/SpatialMapping/Occlusion",
            "VR/SpatialMapping/Wireframe"
        };


        public static readonly char[] ValidSeparators = { ' ', '\t', '\r', '\n', ';', ',', '.', '(', ')', '[', ']', '{', '}', '>', '<', '=', '!', '&', '|', '^', '+', '-', '*', '/', '#', '?' };

        public static readonly string[] ValidPropertyDataTypes =
        {
            "float",
            "float2",
            "float3",
            "float4",
            "half",
            "half2",
            "half3",
            "half4",
            "fixed",
            "fixed2",
            "fixed3",
            "fixed4",
            "int",
            "uint",
            "double"
        };

        private static readonly Dictionary<Material, ApplyLater> ApplyStructsLater = new Dictionary<Material, ApplyLater>();

        public static void LockMaterial(Material mat, bool applyLater, Material sharedMaterial)
        {

            mat.SetFloat(ShaderOptimizerEnabled, 1);
            MaterialProperty[] props = MaterialEditor.GetMaterialProperties(new Object[] { mat });
            if (!Lock(mat, props, applyLater, sharedMaterial)) // Error locking shader, revert property
                mat.SetFloat(ShaderOptimizerEnabled, 0);
        }


        //----Scene Lock


        [MenuItem("Tools/Shader Optimizer/Unlock Materials In Scene")]
        public static void UnlockAllMaterials()
        {

            Material[] mats = GetMaterialsUsingOptimizer(true);

            foreach (Material m in mats)
            {
                Unlock(m);
                m.SetFloat(ShaderOptimizerEnabled, 0);
            }
        }


        //----Scene Unlock


        [MenuItem("Tools/Shader Optimizer/Lock Materials In Scene")]
        public static void LockAllMaterials()
        {

            Material[] mats = GetMaterialsUsingOptimizer(false);
            LockMaterials(mats);
        }


        //----GameObject Lock


        [MenuItem("GameObject/Shader Optimizer/Lock All", false, 0)]
        public static void LockAllChildren()
        {
            Material[] mats = GetMaterialsUsingOptimizer(Selection.activeGameObject, false);
            LockMaterials(mats);
        }


        //----GameObject Unlock


        [MenuItem("GameObject/Shader Optimizer/Unlock All", false, 0)]
        public static void UnlockAllChildren()
        {

            Material[] mats = GetMaterialsUsingOptimizer(Selection.activeGameObject, true);

            foreach (Material m in mats)
            {
                Unlock(m);
                m.SetFloat(ShaderOptimizerEnabled, 0);
            }
        }



        //----Asset Lock


        [MenuItem("Assets/Shader Optimizer/Lock Selection")]
        private static void LockMaterialsInSelection()
        {
            IEnumerable<Material> mats = Selection.assetGUIDs.Select(g => AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(g))).Where(m => IsUsingOptimizer(m, false));
            LockMaterials(mats);
        }

        [MenuItem("Assets/Shader Optimizer/Lock Selection", true)]
        private static bool LockMaterialsInSelectionValidator()
        {
            return SelectedObjectsAreLockableMaterials(false);
        }


        //----Asset Unlock


        [MenuItem("Assets/Shader Optimizer/Unlock Selection")]
        private static void UnlockMaterialsInSelection()
        {
            IEnumerable<Material> mats = Selection.assetGUIDs.Select(g => AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(g))).Where(m => IsUsingOptimizer(m, true));
            foreach (Material m in mats)
            {
                Unlock(m);
                m.SetFloat(ShaderOptimizerEnabled, 0);
            }
        }

        [MenuItem("Assets/Shader Optimizer/Unlock Selection", true)]
        private static bool UnlockMaterialsInSelectionValidator()
        {
            return SelectedObjectsAreLockableMaterials(true);
        }


        //----Folder Lock


        [MenuItem("Assets/Shader Optimizer/Lock Folder", false)]
        private static void LockFolder()
        {
            if (AssetDatabase.GetAssetPath(Selection.activeObject) == "Assets")
            {
                Debug.Log("[Kaj Shader Optimizer] cannot lock root folder");
                return;
            }
            IEnumerable<string> folderPaths = Selection.objects.Select(AssetDatabase.GetAssetPath).Where(Directory.Exists);
            List<Material> mats = new List<Material>();
            foreach (string f in folderPaths) FindMaterialsRecursive(f, mats, false);
            LockMaterials(mats);
        }

        [MenuItem("Assets/Shader Optimizer/Lock Folder", true)]
        private static bool LockFolderValidator()
        {
            return Selection.objects.Select(o => AssetDatabase.GetAssetPath(o)).Where(p => Directory.Exists(p)).Count() == Selection.objects.Length;
        }


        //-----Folder Unlock


        [MenuItem("Assets/Shader Optimizer/Unlock Folder", false)]
        private static void UnLockFolder()
        {
            if (AssetDatabase.GetAssetPath(Selection.activeObject) == "Assets")
            {
                Debug.Log("[Kaj Shader Optimizer] cannot unlock root folder");
                return;
            }
            IEnumerable<string> folderPaths = Selection.objects.Select(AssetDatabase.GetAssetPath).Where(Directory.Exists);
            List<Material> mats = new List<Material>();
            foreach (string f in folderPaths) FindMaterialsRecursive(f, mats, true);
            foreach (Material m in mats)
            {
                Unlock(m);
                m.SetFloat(ShaderOptimizerEnabled, 0);
            }
        }

        [MenuItem("Assets/Shader Optimizer/Unlock Folder", true)]
        private static bool UnLockFolderValidator()
        {
            return Selection.objects.Select(AssetDatabase.GetAssetPath).Count(Directory.Exists) == Selection.objects.Length;
        }



        private static bool SelectedObjectsAreLockableMaterials(bool isLocked)
        {
            if (Selection.assetGUIDs != null && Selection.assetGUIDs.Length > 0)
                foreach (string assetGUID in Selection.assetGUIDs)
                    if (AssetDatabase.GetMainAssetTypeAtPath(AssetDatabase.GUIDToAssetPath(assetGUID)) == typeof(Material))
                    {
                        Material mat = AssetDatabase.LoadAssetAtPath<Material>(AssetDatabase.GUIDToAssetPath(assetGUID));
                        if (IsUsingOptimizer(mat, isLocked)) return true;
                    }
            return false;
        }

        public static void LockAllChildren(GameObject parent)
        {

            Material[] mats = GetMaterialsUsingOptimizer(parent, false);
            LockMaterials(mats);
        }

        private static void FindMaterialsRecursive(string folderPath, List<Material> materials, bool islocked)
        {
            foreach (string f in Directory.GetFiles(folderPath))
                if (AssetDatabase.GetMainAssetTypeAtPath(f) == typeof(Material))
                    if (IsUsingOptimizer(AssetDatabase.LoadAssetAtPath<Material>(f), islocked))
                        materials.Add(AssetDatabase.LoadAssetAtPath<Material>(f));
            foreach (string f in Directory.GetDirectories(folderPath)) FindMaterialsRecursive(f, materials, islocked);
        }

        private static Material[] GetMaterialsUsingOptimizer(GameObject parent, bool isLocked)
        {
            List<Material> materials = new List<Material>();
            List<Material> foundMaterials = new List<Material>();

            Renderer[] renderers = parent.GetComponentsInChildren<Renderer>(true);


            if (renderers != null)
                foreach (Renderer rend in renderers)
                    if (rend != null)
                        foreach (var mat in rend.sharedMaterials)
                            if (mat != null)
                                foundMaterials.Add(mat);

            foreach (Material mat in foundMaterials)
                if (mat.shader.name != "Hidden/InternalErrorShader")
                {
                    bool usingOptimizer = false;
                    try
                    {
                        if (ShaderUtil.GetPropertyName(mat.shader, 0) == ShaderOptimizerEnabled) usingOptimizer = true;
                        if (!usingOptimizer)
                        {
                            int propertyCount = ShaderUtil.GetPropertyCount(mat.shader);

                            for (int i = 0; i <= propertyCount; i++)
                                if (ShaderUtil.GetPropertyName(mat.shader, i) == ShaderOptimizerEnabled)
                                    usingOptimizer = true;
                        }
                    }
                    catch
                    {
                        // ignored
                    }

                    if (!materials.Contains(mat) && usingOptimizer)
                        if (mat.GetFloat(ShaderOptimizerEnabled) == (isLocked ? 1 : 0))
                            materials.Add(mat);
                }
                else
                {
                    if (!materials.Contains(mat) && mat.GetTag(OriginalShaderTag, false) != string.Empty)
                        if (isLocked)
                            materials.Add(mat);
                }
            return materials.Distinct().ToArray();
        }

        private static Material[] GetMaterialsUsingOptimizer(bool isLocked)
        {
            List<Material> materials = new List<Material>();
            List<Material> foundMaterials = new List<Material>();
            Scene scene = SceneManager.GetActiveScene();

            string[] materialPaths = AssetDatabase.GetDependencies(scene.path).Where(x => x.EndsWith(".mat")).ToArray();
            var renderers = Object.FindObjectsOfType<Renderer>();

            for (int i = 0; i < materialPaths.Length; i++)
            {
                Material mat = AssetDatabase.LoadAssetAtPath<Material>(materialPaths[i]);
                foundMaterials.Add(mat);
            }

            if (renderers != null)
                foreach (var rend in renderers)
                    if (rend != null)
                        foreach (var mat in rend.sharedMaterials)
                            if (mat != null)
                                foundMaterials.Add(mat);

            foreach (Material mat in foundMaterials)
                if (mat.shader.name != "Hidden/InternalErrorShader")
                {
                    bool usingOptimizer = false;
                    try
                    {
                        if (ShaderUtil.GetPropertyName(mat.shader, 0) == ShaderOptimizerEnabled) usingOptimizer = true;
                        if (!usingOptimizer)
                        {
                            int propertyCount = ShaderUtil.GetPropertyCount(mat.shader);

                            for (int i = 0; i <= propertyCount; i++)
                                if (ShaderUtil.GetPropertyName(mat.shader, i) == ShaderOptimizerEnabled)
                                    usingOptimizer = true;
                        }
                    }
                    catch
                    {
                        // ignored
                    }

                    if (!materials.Contains(mat) && usingOptimizer)
                        if (mat.GetFloat(ShaderOptimizerEnabled) == (isLocked ? 1 : 0))
                            materials.Add(mat);
                }
                else
                {
                    if (!materials.Contains(mat) && mat.GetTag(OriginalShaderTag, false) != string.Empty)
                        if (isLocked)
                            materials.Add(mat);
                }
            return materials.Distinct().ToArray();
        }


        private static bool IsUsingOptimizer(Material mat, bool isLocked)
        {
            if (DefaultUnityShaderNames.Contains(mat.shader.name)) return false;
            bool usingOptimizer = false;
            if (mat.shader.name != "Hidden/InternalErrorShader")
            {
                try
                {
                    usingOptimizer = ShaderUtil.GetPropertyName(mat.shader, 0) == ShaderOptimizerEnabled;

                    if (!usingOptimizer)
                    {
                        int propertyCount = ShaderUtil.GetPropertyCount(mat.shader);

                        for (int i = 0; i <= propertyCount; i++)
                            if (ShaderUtil.GetPropertyName(mat.shader, i) == ShaderOptimizerEnabled)
                                usingOptimizer = true;
                    }

                }
                catch
                {
                    // ignored
                }

                if (usingOptimizer)
                    if (mat.GetFloat(ShaderOptimizerEnabled) == (isLocked ? 1 : 0))
                        return true;
            }
            else
            {
                if (mat.GetTag(OriginalShaderTag, false) != string.Empty)
                    if (isLocked)
                        return true;
            }
            return usingOptimizer;
        }

        // https://forum.unity.com/threads/hash-function-for-game.452779/
        private static string ComputeMD5(string str)
        {
            ASCIIEncoding encoding = new ASCIIEncoding();
            byte[] bytes = encoding.GetBytes(str);
            var sha = new MD5CryptoServiceProvider();
            return BitConverter.ToString(sha.ComputeHash(bytes)).Replace("-", "").ToLower();
        }

        private static void LockMaterials(Material[] mats)
        {
            float progress = mats.Length;

            if (progress == 0) return;

            AssetDatabase.StartAssetEditing();
            Dictionary<string, Material> materialsPropertyHash = new Dictionary<string, Material>();



            for (int i = 0; i < progress; i++)
            {
                EditorUtility.DisplayCancelableProgressBar("Generating Shaders", mats[i].name, i / progress);

                int propCount = ShaderUtil.GetPropertyCount(mats[i].shader);

                StringBuilder materialPropertyValues = new StringBuilder(mats[i].shader.name);

                for (int l = 0; l < propCount; l++)
                {
                    string propName = ShaderUtil.GetPropertyName(mats[i].shader, l);

                    if (PropertiesToSkip.Contains(propName))
                    {
                        materialPropertyValues.Append(propName);
                        continue;
                    }

                    bool isAnimated = mats[i].GetTag(propName, false) != "";

                    if (isAnimated)
                    {
                        materialPropertyValues.Append(propName + "_Animated");
                        continue;
                    }

                    switch (ShaderUtil.GetPropertyType(mats[i].shader, l))
                    {
                        case ShaderUtil.ShaderPropertyType.Float:
                            materialPropertyValues.Append(mats[i].GetFloat(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.TexEnv:
                            Texture t = mats[i].GetTexture(propName);
                            Vector4 texelSize = new Vector4(1.0f, 1.0f, 1.0f, 1.0f);

                            materialPropertyValues.Append(t != null ? "true" : "false");
                            materialPropertyValues.Append(mats[i].GetTextureOffset(propName).ToString());
                            materialPropertyValues.Append(mats[i].GetTextureScale(propName).ToString());

                            if (t != null && TexelSizeCheck.Contains(propName)) texelSize = new Vector4(1.0f / t.width, 1.0f / t.height, t.width, t.height);
                            materialPropertyValues.Append(texelSize.ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Color:
                            materialPropertyValues.Append(mats[i].GetColor(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Range:
                            materialPropertyValues.Append(mats[i].GetFloat(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Vector:
                            materialPropertyValues.Append(mats[i].GetVector(propName).ToString());
                            break;
                    }
                }

                Material sharedMaterial = null;
                string matPropHash = ComputeMD5(materialPropertyValues.ToString());
                if (materialsPropertyHash.ContainsKey(matPropHash))
                    materialsPropertyHash.TryGetValue(matPropHash, out sharedMaterial);
                else
                    materialsPropertyHash.Add(matPropHash, mats[i]);

                LockMaterial(mats[i], true, sharedMaterial);
            }

            EditorUtility.ClearProgressBar();
            AssetDatabase.StopAssetEditing();
            AssetDatabase.Refresh();

            for (int i = 0; i < progress; i++)
            {
                EditorUtility.DisplayCancelableProgressBar("Replacing Shaders", mats[i].name, i / progress);
                LockApplyShader(mats[i]);
            }
            EditorUtility.ClearProgressBar();
        }

        private static void LockMaterials(List<Material> mats)
        {
            float progress = mats.Count;

            if (progress == 0) return;

            AssetDatabase.StartAssetEditing();
            Dictionary<string, Material> materialsPropertyHash = new Dictionary<string, Material>();



            for (int i = 0; i < progress; i++)
            {
                EditorUtility.DisplayCancelableProgressBar("Generating Shaders", mats[i].name, i / progress);

                int propCount = ShaderUtil.GetPropertyCount(mats[i].shader);

                StringBuilder materialPropertyValues = new StringBuilder(mats[i].shader.name);

                for (int l = 0; l < propCount; l++)
                {
                    string propName = ShaderUtil.GetPropertyName(mats[i].shader, l);

                    if (PropertiesToSkip.Contains(propName))
                    {
                        materialPropertyValues.Append(propName);
                        continue;
                    }

                    bool isAnimated = mats[i].GetTag(propName, false) != "";

                    if (isAnimated)
                    {
                        materialPropertyValues.Append(propName + "_Animated");
                        continue;
                    }

                    switch (ShaderUtil.GetPropertyType(mats[i].shader, l))
                    {
                        case ShaderUtil.ShaderPropertyType.Float:
                            materialPropertyValues.Append(mats[i].GetFloat(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.TexEnv:
                            Texture t = mats[i].GetTexture(propName);
                            Vector4 texelSize = new Vector4(1.0f, 1.0f, 1.0f, 1.0f);

                            materialPropertyValues.Append(t != null ? "true" : "false");
                            materialPropertyValues.Append(mats[i].GetTextureOffset(propName).ToString());
                            materialPropertyValues.Append(mats[i].GetTextureScale(propName).ToString());

                            if (t != null && TexelSizeCheck.Contains(propName)) texelSize = new Vector4(1.0f / t.width, 1.0f / t.height, t.width, t.height);
                            materialPropertyValues.Append(texelSize.ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Color:
                            materialPropertyValues.Append(mats[i].GetColor(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Range:
                            materialPropertyValues.Append(mats[i].GetFloat(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Vector:
                            materialPropertyValues.Append(mats[i].GetVector(propName).ToString());
                            break;
                    }
                }

                Material sharedMaterial = null;
                string matPropHash = ComputeMD5(materialPropertyValues.ToString());
                if (materialsPropertyHash.ContainsKey(matPropHash))
                    materialsPropertyHash.TryGetValue(matPropHash, out sharedMaterial);
                else
                    materialsPropertyHash.Add(matPropHash, mats[i]);

                LockMaterial(mats[i], true, sharedMaterial);
            }

            EditorUtility.ClearProgressBar();
            AssetDatabase.StopAssetEditing();
            AssetDatabase.Refresh();

            for (int i = 0; i < progress; i++)
            {
                EditorUtility.DisplayCancelableProgressBar("Replacing Shaders", mats[i].name, i / progress);
                LockApplyShader(mats[i]);
            }
            EditorUtility.ClearProgressBar();
        }
        private static void LockMaterials(IEnumerable<Material> enumerable)
        {
            var mats = enumerable as Material[] ?? enumerable.ToArray();

            float progress = mats.Length;

            if (progress == 0) return;

            AssetDatabase.StartAssetEditing();
            Dictionary<string, Material> materialsPropertyHash = new Dictionary<string, Material>();



            for (int i = 0; i < progress; i++)
            {
                EditorUtility.DisplayCancelableProgressBar("Generating Shaders", mats[i].name, i / progress);

                int propCount = ShaderUtil.GetPropertyCount(mats[i].shader);

                StringBuilder materialPropertyValues = new StringBuilder(mats[i].shader.name);

                for (int l = 0; l < propCount; l++)
                {
                    string propName = ShaderUtil.GetPropertyName(mats[i].shader, l);

                    if (PropertiesToSkip.Contains(propName))
                    {
                        materialPropertyValues.Append(propName);
                        continue;
                    }

                    bool isAnimated = mats[i].GetTag(propName, false) != "";

                    if (isAnimated)
                    {
                        materialPropertyValues.Append(propName + "_Animated");
                        continue;
                    }

                    switch (ShaderUtil.GetPropertyType(mats[i].shader, l))
                    {
                        case ShaderUtil.ShaderPropertyType.Float:
                            materialPropertyValues.Append(mats[i].GetFloat(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.TexEnv:
                            Texture t = mats[i].GetTexture(propName);
                            Vector4 texelSize = new Vector4(1.0f, 1.0f, 1.0f, 1.0f);

                            materialPropertyValues.Append(t != null ? "true" : "false");
                            materialPropertyValues.Append(mats[i].GetTextureOffset(propName).ToString());
                            materialPropertyValues.Append(mats[i].GetTextureScale(propName).ToString());

                            if (t != null && TexelSizeCheck.Contains(propName)) texelSize = new Vector4(1.0f / t.width, 1.0f / t.height, t.width, t.height);
                            materialPropertyValues.Append(texelSize.ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Color:
                            materialPropertyValues.Append(mats[i].GetColor(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Range:
                            materialPropertyValues.Append(mats[i].GetFloat(propName).ToString());
                            break;

                        case ShaderUtil.ShaderPropertyType.Vector:
                            materialPropertyValues.Append(mats[i].GetVector(propName).ToString());
                            break;
                    }
                }

                Material sharedMaterial = null;
                string matPropHash = ComputeMD5(materialPropertyValues.ToString());
                if (materialsPropertyHash.ContainsKey(matPropHash))
                    materialsPropertyHash.TryGetValue(matPropHash, out sharedMaterial);
                else
                    materialsPropertyHash.Add(matPropHash, mats[i]);

                LockMaterial(mats[i], true, sharedMaterial);
            }

            EditorUtility.ClearProgressBar();
            AssetDatabase.StopAssetEditing();
            AssetDatabase.Refresh();

            for (int i = 0; i < progress; i++)
            {
                EditorUtility.DisplayCancelableProgressBar("Replacing Shaders", mats[i].name, i / progress);
                LockApplyShader(mats[i]);
            }
            EditorUtility.ClearProgressBar();
        }

        public static bool Lock(Material material, MaterialProperty[] props)
        {
            Lock(material, props, false, null);
            return true;
        }

        public static bool Lock(Material material, MaterialProperty[] props, bool applyShaderLater, Material sharedMaterial)
        {

            Shader shader = material.shader;
            string shaderFilePath = AssetDatabase.GetAssetPath(shader);
            string smallguid = AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(material));
            string newShaderName = "Hidden/" + shader.name + "/" + smallguid;
            string newShaderDirectory = "Assets/OptimizedShaders/" + smallguid + "/";
            ApplyLater applyLater = new ApplyLater();


            if (sharedMaterial != null)
            {
                applyLater.Material = material;
                applyLater.Shader = sharedMaterial.shader;
                applyLater.Smallguid = AssetDatabase.AssetPathToGUID(AssetDatabase.GetAssetPath(sharedMaterial));
                applyLater.NewShaderName = "Hidden/" + shader.name + "/" + applyLater.Smallguid;
                ApplyStructsLater.Add(material, applyLater);
                return true;

            }


            // Get collection of all properties to replace
            // Simultaneously build a string of #defines for each CGPROGRAM
            StringBuilder definesSb = new StringBuilder();
            // Append convention OPTIMIZER_ENABLED keyword
            definesSb.Append(Environment.NewLine);
            definesSb.Append("#define ");
            definesSb.Append(OptimizerEnabledKeyword);
            definesSb.Append(Environment.NewLine);
            // Append all keywords active on the material
            foreach (string keyword in material.shaderKeywords)
            {
                if (keyword == "") continue; // idk why but null keywords exist if _ keyword is used and not removed by the editor at some point
                definesSb.Append("#define ");
                definesSb.Append(keyword);
                definesSb.Append(Environment.NewLine);
            }

            List<PropertyData> constantProps = new List<PropertyData>();
            List<string> animatedProps = new List<string>();


            foreach (MaterialProperty prop in props)
            {
                if (prop == null) continue;

                // Every property gets turned into a preprocessor variable
                switch (prop.type)
                {
                    case MaterialProperty.PropType.Float:
                    case MaterialProperty.PropType.Range:
                        definesSb.Append("#define PROP");
                        definesSb.Append(prop.name.ToUpper());
                        definesSb.Append(' ');
                        definesSb.Append(prop.floatValue.ToString(CultureInfo.InvariantCulture));
                        definesSb.Append(Environment.NewLine);
                        break;
                    case MaterialProperty.PropType.Texture:
                        if (prop.textureValue != null)
                        {
                            definesSb.Append("#define PROP");
                            definesSb.Append(prop.name.ToUpper());
                            definesSb.Append(Environment.NewLine);
                        }
                        break;
                }

                if (prop.name.EndsWith(AnimatedPropertySuffix) || (material.GetTag(prop.name + AnimatedPropertySuffix, false) == string.Empty ? false : true)) continue;
                if (prop.name == ReplaceAnimatedParametersPropertyName)
                {
                    _replaceAnimatedParameters = prop.floatValue == 1;
                    if (_replaceAnimatedParameters)
                    {
                        // Add a tag to the material so animation clip referenced parameters 
                        // will stay consistent across material locking/unlocking
                        string animatedParameterSuffix = material.GetTag("AnimatedParametersSuffix", false, "");
                        if (animatedParameterSuffix == "")
                            material.SetOverrideTag("AnimatedParametersSuffix", Guid.NewGuid().ToString().Split('-')[0]);
                    }
                }


                // Check for the convention 'Animated' Property to be true otherwise assume all properties are constant
                // nlogn trash
                MaterialProperty animatedProp = Array.Find(props, x => x.name == prop.name + AnimatedPropertySuffix);
                if (animatedProp != null && animatedProp.floatValue == 1)
                {
                    animatedProps.Add(prop.name);
                    continue;
                }

                PropertyData propData;
                switch (prop.type)
                {
                    case MaterialProperty.PropType.Color:
                        propData = new PropertyData();
                        propData.Type = PropertyType.Vector;
                        propData.Name = prop.name;
                        if ((prop.flags & MaterialProperty.PropFlags.HDR) != 0)
                        {
                            if ((prop.flags & MaterialProperty.PropFlags.Gamma) != 0)
                                propData.Value = prop.colorValue.linear;
                            else propData.Value = prop.colorValue;
                        }
                        else if ((prop.flags & MaterialProperty.PropFlags.Gamma) != 0)
                        {
                            propData.Value = prop.colorValue;
                        }
                        else
                        {
                            propData.Value = prop.colorValue.linear;
                        }
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Vector:
                        propData = new PropertyData();
                        propData.Type = PropertyType.Vector;
                        propData.Name = prop.name;
                        propData.Value = prop.vectorValue;
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Float:
                    case MaterialProperty.PropType.Range:
                        propData = new PropertyData();
                        propData.Type = PropertyType.Float;
                        propData.Name = prop.name;
                        propData.Value = new Vector4(prop.floatValue, 0, 0, 0);
                        constantProps.Add(propData);
                        break;
                    case MaterialProperty.PropType.Texture:
                        animatedProp = Array.Find(props, x => x.name == prop.name + "_ST" + AnimatedPropertySuffix);
                        if (!(animatedProp != null && animatedProp.floatValue == 1))
                        {
                            PropertyData st = new PropertyData();
                            st.Type = PropertyType.Vector;
                            st.Name = prop.name + "_ST";
                            Vector2 offset = material.GetTextureOffset(prop.name);
                            Vector2 scale = material.GetTextureScale(prop.name);
                            st.Value = new Vector4(scale.x, scale.y, offset.x, offset.y);
                            constantProps.Add(st);
                        }
                        animatedProp = Array.Find(props, x => x.name == prop.name + "_TexelSize" + AnimatedPropertySuffix);
                        if (!(animatedProp != null && animatedProp.floatValue == 1))
                        {
                            PropertyData texelSize = new PropertyData();
                            texelSize.Type = PropertyType.Vector;
                            texelSize.Name = prop.name + "_TexelSize";
                            Texture t = prop.textureValue;
                            if (t != null)
                                texelSize.Value = new Vector4(1.0f / t.width, 1.0f / t.height, t.width, t.height);
                            else texelSize.Value = new Vector4(1.0f, 1.0f, 1.0f, 1.0f);
                            constantProps.Add(texelSize);
                        }
                        break;
                }
            }
            string optimizerDefines = definesSb.ToString();

            // Parse shader and cginc files, also gets preprocessor macros
            List<ParsedShaderFile> shaderFiles = new List<ParsedShaderFile>();
            List<Macro> macros = new List<Macro>();
            if (!ParseShaderFilesRecursive(shaderFiles, newShaderDirectory, shaderFilePath, macros, material))
                return false;


            // Loop back through and do macros, props, and all other things line by line as to save string ops
            // Will still be a massive n2 operation from each line * each property
            foreach (ParsedShaderFile psf in shaderFiles)
            {
                // Shader file specific stuff
                if (psf.FilePath.EndsWith(".shader"))
                    for (int i = 0; i < psf.Lines.Length; i++)
                    {
                        string trimmedLine = psf.Lines[i].TrimStart();
                        if (trimmedLine.StartsWith("Shader"))
                        {
                            string originalSgaderName = psf.Lines[i].Split('\"')[1];
                            psf.Lines[i] = psf.Lines[i].Replace(originalSgaderName, newShaderName);
                        }
                        else if (trimmedLine.StartsWith("#pragma multi_compile _ LOD_FADE_CROSSFADE"))
                        {
                            MaterialProperty crossfadeProp = Array.Find(props, x => x.name == LODCrossFadePropertyName);
                            if (crossfadeProp != null && crossfadeProp.floatValue == 0)
                                psf.Lines[i] = psf.Lines[i].Replace("#pragma", "//#pragma");
                        }

                        else if (trimmedLine.StartsWith("CGINCLUDE"))
                        {
                            for (int j = i + 1; j < psf.Lines.Length; j++)
                                if (psf.Lines[j].TrimStart().StartsWith("ENDCG"))
                                {
                                    ReplaceShaderValues(material, psf.Lines, i + 1, j, constantProps, animatedProps, macros);
                                    break;
                                }
                        }
                        else if (trimmedLine.StartsWith("SubShader"))
                        {
                            psf.Lines[i - 1] += "CGINCLUDE";
                            psf.Lines[i - 1] += optimizerDefines;
                            psf.Lines[i - 1] += "ENDCG";
                        }
                        else if (trimmedLine.StartsWith("CGPROGRAM"))
                        {
                            for (int j = i + 1; j < psf.Lines.Length; j++)
                                if (psf.Lines[j].TrimStart().StartsWith("ENDCG"))
                                {
                                    ReplaceShaderValues(material, psf.Lines, i + 1, j, constantProps, animatedProps, macros);
                                    break;
                                }
                        }

                        else if (_replaceAnimatedParameters)
                        {
                            // Check to see if line contains an animated property name with valid left/right characters
                            // then replace the parameter name with prefixtag + parameter name
                            string animatedPropName = animatedProps.Find(x => trimmedLine.Contains(x));
                            if (animatedPropName != null)
                            {
                                int parameterIndex = trimmedLine.IndexOf(animatedPropName, StringComparison.Ordinal);
                                char charLeft = trimmedLine[parameterIndex - 1];
                                char charRight = trimmedLine[parameterIndex + animatedPropName.Length];
                                if (Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight))
                                    psf.Lines[i] = psf.Lines[i].Replace(animatedPropName, animatedPropName + material.GetTag("AnimatedParametersSuffix", false, string.Empty));
                            }
                        }
                    }
                else // CGINC file
                    ReplaceShaderValues(material, psf.Lines, 0, psf.Lines.Length, constantProps, animatedProps, macros);

                // Recombine file lines into a single string
                int totalLen = psf.Lines.Length * 2; // extra space for newline chars
                foreach (string line in psf.Lines)
                    totalLen += line.Length;
                StringBuilder sb = new StringBuilder(totalLen);
                // This appendLine function is incompatible with the '\n's that are being added elsewhere
                foreach (string line in psf.Lines)
                    sb.AppendLine(line);
                string output = sb.ToString();

                // Write output to file
                string newDirectory = psf.FilePath.Split('/').Last();

                new FileInfo(newShaderDirectory + newDirectory).Directory.Create();
                try
                {
                    StreamWriter sw = new StreamWriter(newShaderDirectory + newDirectory);
                    sw.Write(output);
                    sw.Close();
                }
                catch (IOException e)
                {
                    Debug.LogError("[Kaj Shader Optimizer] Processed shader file " + newShaderDirectory + newDirectory + " could not be written.  " + e);
                    return false;
                }
            }


            applyLater.Material = material;
            applyLater.Shader = shader;
            applyLater.Smallguid = smallguid;
            applyLater.NewShaderName = newShaderName;

            if (applyShaderLater)
            {
                ApplyStructsLater.Add(material, applyLater);
                return true;
            }

            AssetDatabase.Refresh();

            return ReplaceShader(applyLater);
        }

        private static void LockApplyShader(Material material)
        {
            if (ApplyStructsLater.ContainsKey(material) == false) return;
            ApplyLater applyStruct = ApplyStructsLater[material];
            ApplyStructsLater.Remove(material);
            ReplaceShader(applyStruct);
        }


        private static bool ReplaceShader(ApplyLater applyLater)
        {

            // Write original shader to override tag
            applyLater.Material.SetOverrideTag(OriginalShaderTag, applyLater.Shader.name);
            // Write the new shader folder name in an override tag so it will be deleted 
            applyLater.Material.SetOverrideTag("OptimizedShaderFolder", applyLater.Smallguid);

            // For some reason when shaders are swapped on a material the RenderType override tag gets completely deleted and render queue set back to -1
            // So these are saved as temp values and reassigned after switching shaders
            string renderType = applyLater.Material.GetTag("RenderType", false, string.Empty);
            int renderQueue = applyLater.Material.renderQueue;

            // Actually switch the shader
            Shader newShader = Shader.Find(applyLater.NewShaderName);

            if (newShader == null)
            {
                // LockMaterial(applyLater.material, false, null);
                Debug.LogError("[Kaj Shader Optimizer] Generated shader " + applyLater.NewShaderName + " for " + applyLater.Material + " could not be found ");
                return false;
            }
            applyLater.Material.shader = newShader;
            applyLater.Material.SetOverrideTag("RenderType", renderType);
            applyLater.Material.renderQueue = renderQueue;

            // Remove ALL keywords
            foreach (string keyword in applyLater.Material.shaderKeywords)
                applyLater.Material.DisableKeyword(keyword);

            return true;
        }


        // Preprocess each file for macros and includes
        // Save each file as string[], parse each macro with //KSOEvaluateMacro
        // Only editing done is replacing #include "X" filepaths where necessary
        // most of these args could be private static members of the class
        private static bool ParseShaderFilesRecursive(List<ParsedShaderFile> filesParsed, string newTopLevelDirectory, string filePath, List<Macro> macros, Material mat)
        {
            // Infinite recursion check
            if (filesParsed.Exists(x => x.FilePath == filePath)) return true;

            ParsedShaderFile psf = new ParsedShaderFile();
            psf.FilePath = filePath;
            filesParsed.Add(psf);

            // Read file
            string fileContents;
            try
            {
                StreamReader sr = new StreamReader(filePath);
                fileContents = sr.ReadToEnd();
                sr.Close();
            }
            catch (FileNotFoundException e)
            {
                Debug.LogError("[Kaj Shader Optimizer] Shader file " + filePath + " not found.  " + e);
                return false;
            }
            catch (IOException e)
            {
                Debug.LogError("[Kaj Shader Optimizer] Error reading shader file.  " + e);
                return false;
            }

            // Parse file line by line
            List<string> macrosList = new List<string>();
            if (macrosList == null) throw new ArgumentNullException(nameof(macrosList));
            string[] fileLines = new CommentFreeIterator(Regex.Split(fileContents, "\r\n|\r|\n")).ToArray();
            for (int i = 0; i < fileLines.Length; i++)
            {
                string lineParsed = fileLines[i].TrimStart();

                // Skip the cginc
                if (lineParsed.StartsWith("//#if") && mat != null)
                {
                    string[] materialProperties = Regex.Split(lineParsed.Replace("//#if", ""), ",");
                    try
                    {
                        bool all = true;
                        foreach (var x in materialProperties)
                            if (mat.GetFloat(x) != 0)
                            {
                                all = false;
                                break;
                            }
                        if (all)
                        {
                            i++;
                            fileLines[i] = fileLines[i].Insert(0, "//");
                        }
                    }
                    catch
                    {
                        Debug.LogError($"Property at line {i} not found on {mat}");
                    }
                }

                // Specifically requires no whitespace between # and include, as it should be
                else if (lineParsed.StartsWith("#include"))
                {
                    int firstQuotation = lineParsed.IndexOf('\"', 0);
                    int lastQuotation = lineParsed.IndexOf('\"', firstQuotation + 1);
                    string includeFilename = lineParsed.Substring(firstQuotation + 1, lastQuotation - firstQuotation - 1);

                    // Skip default includes
                    if (Array.Exists(DefaultUnityShaderIncludes, x => x.Equals(includeFilename, StringComparison.InvariantCultureIgnoreCase)))
                        continue;

                    // cginclude filepath is either absolute or relative
                    if (includeFilename.StartsWith("Assets/"))
                    {
                        if (!ParseShaderFilesRecursive(filesParsed, newTopLevelDirectory, includeFilename, macros, mat))
                            return false;
                        // Only absolute filepaths need to be renampped in-file
                        fileLines[i] = fileLines[i].Replace(includeFilename, newTopLevelDirectory + includeFilename);
                    }
                    else
                    {
                        string includeFullpath = GetFullPath(includeFilename, Path.GetDirectoryName(filePath));
                        if (!ParseShaderFilesRecursive(filesParsed, newTopLevelDirectory, includeFullpath, macros, mat))
                            return false;
                        fileLines[i] = "#include " + "\"" + Path.GetFileName(includeFullpath) + "\"";
                    }
                }
            }

            // Prepare the macros list into pattern matchable structs
            // Revise this later to not do so many string ops
            foreach (string macroString in macrosList)
            {
                string m = macroString;
                Macro macro = new Macro();
                m = m.TrimStart();
                if (m[0] != '#') continue;
                m = m.Remove(0, "#".Length).TrimStart();
                if (!m.StartsWith("define")) continue;
                m = m.Remove(0, "define".Length).TrimStart();
                int firstParenthesis = m.IndexOf('(');
                macro.Name = m.Substring(0, firstParenthesis);
                m = m.Remove(0, firstParenthesis + "(".Length);
                int lastParenthesis = m.IndexOf(')');
                string allArgs = m.Substring(0, lastParenthesis).Replace(" ", "").Replace("\t", "");
                macro.Args = allArgs.Split(',');
                m = m.Remove(0, lastParenthesis + ")".Length);
                macro.Contents = m;
                macros.Add(macro);
            }

            // Save psf lines to list
            psf.Lines = fileLines;
            return true;
        }

        // error CS1501: No overload for method 'Path.GetFullPath' takes 2 arguments
        // Thanks Unity
        // Could be made more efficent with stringbuilder
        public static string GetFullPath(string relativePath, string basePath)
        {
            while (relativePath.StartsWith("./"))
                relativePath = relativePath.Remove(0, "./".Length);
            while (relativePath.StartsWith("../"))
            {
                basePath = basePath.Remove(basePath.LastIndexOf(Path.DirectorySeparatorChar), basePath.Length - basePath.LastIndexOf(Path.DirectorySeparatorChar));
                relativePath = relativePath.Remove(0, "../".Length);
            }
            return basePath + '/' + relativePath;
        }

        // Replace properties! The meat of the shader optimization process
        // For each constantProp, pattern match and find each instance of the property that isn't a declaration
        // most of these args could be private static members of the class
        private static void ReplaceShaderValues(Material material, string[] lines, int startLine, int endLine, List<PropertyData> constants, List<string> animProps, List<Macro> macros)
        {

            for (int i = startLine; i < endLine; i++)
            {
                string lineTrimmed = lines[i].TrimStart();
                // Remove all shader_feature directives
                if (lineTrimmed.StartsWith("#pragma shader_feature") || lineTrimmed.StartsWith("#pragma shader_feature_local"))
                    lines[i] = "//" + lines[i];


                // then replace macros
                foreach (Macro macro in macros)
                {
                    // Expects only one instance of a macro per line!
                    int macroIndex;
                    if (lines != null && (macroIndex = lines[i].IndexOf(macro.Name + "(", StringComparison.Ordinal)) != -1)
                    {
                        // Macro exists on this line, make sure its not the definition
                        string lineParsed = lineTrimmed.Replace(" ", "").Replace("\t", "");
                        if (lineParsed.StartsWith("#define")) continue;

                        // parse args between first '(' and first ')'
                        int firstParenthesis = macroIndex + macro.Name.Length;
                        int lastParenthesis = lines[i].IndexOf(')', macroIndex + macro.Name.Length + 1);
                        string allArgs = lines[i].Substring(firstParenthesis + 1, lastParenthesis - firstParenthesis - 1);
                        string[] args = allArgs.Split(',');

                        // Replace macro parts
                        string newContents = macro.Contents;
                        for (int j = 0; j < args.Length; j++)
                        {
                            args[j] = args[j].Trim();
                            int argIndex;
                            int lastIndex = 0;
                            // ERROR: This method of one-by-one argument replacement will infinitely loop
                            // if one of the arguments to paste into the macro definition has the same name
                            // as one of the macro arguments!
                            while ((argIndex = newContents.IndexOf(macro.Args[j], lastIndex, StringComparison.Ordinal)) != -1)
                            {
                                lastIndex = argIndex + 1;
                                char charLeft = ' ';
                                if (argIndex - 1 >= 0)
                                    charLeft = newContents[argIndex - 1];
                                char charRight = ' ';
                                if (argIndex + macro.Args[j].Length < newContents.Length)
                                    charRight = newContents[argIndex + macro.Args[j].Length];
                                if (Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight))
                                {
                                    // Replcae the arg!
                                    StringBuilder sbm = new StringBuilder(newContents.Length - macro.Args[j].Length + args[j].Length);
                                    sbm.Append(newContents, 0, argIndex);
                                    sbm.Append(args[j]);
                                    sbm.Append(newContents, argIndex + macro.Args[j].Length, newContents.Length - argIndex - macro.Args[j].Length);
                                    newContents = sbm.ToString();
                                }
                            }
                        }

                        newContents = newContents.Replace("##", ""); // Remove token pasting separators
                        // Replace the line with the evaluated macro
                        StringBuilder sb = new StringBuilder(lines[i].Length + newContents.Length);
                        sb.Append(lines[i], 0, macroIndex);
                        sb.Append(newContents);
                        sb.Append(lines[i], lastParenthesis + 1, lines[i].Length - lastParenthesis - 1);
                        //lines[i] = sb.ToString();
                    }
                }

                // then replace properties
                foreach (PropertyData constant in constants)
                {
                    int constantIndex;
                    int lastIndex = 0;
                    bool declarationFound = false;
                    while ((constantIndex = lines[i].IndexOf(constant.Name, lastIndex, StringComparison.Ordinal)) != -1)
                    {
                        lastIndex = constantIndex + 1;
                        char charLeft = ' ';
                        if (constantIndex - 1 >= 0)
                            charLeft = lines[i][constantIndex - 1];
                        char charRight = ' ';
                        if (constantIndex + constant.Name.Length < lines[i].Length)
                            charRight = lines[i][constantIndex + constant.Name.Length];
                        // Skip invalid matches (probably a subname of another symbol)
                        if (!(Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight)))
                            continue;

                        // Skip basic declarations of unity shader properties i.e. "uniform float4 _Color;"
                        if (!declarationFound)
                        {
                            string precedingText = lines[i].Substring(0, constantIndex - 1).TrimEnd(); // whitespace removed string immediately to the left should be float or float4
                            string restOftheFile = lines[i].Substring(constantIndex + constant.Name.Length).TrimStart(); // whitespace removed character immediately to the right should be ;
                            if (Array.Exists(ValidPropertyDataTypes, x => precedingText.EndsWith(x)) && restOftheFile.StartsWith(";"))
                            {
                                declarationFound = true;
                                continue;
                            }
                        }

                        // Replace with constant!
                        // This could technically be more efficient by being outside the IndexOf loop
                        // int parameters could be pasted here properly, but Unity's scripting API doesn't carry 
                        // over that information from shader parameters
                        StringBuilder sb = new StringBuilder(lines[i].Length * 2);
                        sb.Append(lines[i], 0, constantIndex);
                        switch (constant.Type)
                        {
                            case PropertyType.Float:
                                sb.Append("float(" + constant.Value.x.ToString(CultureInfo.InvariantCulture) + ")");
                                break;
                            case PropertyType.Vector:
                                sb.Append("float4(" + constant.Value.x.ToString(CultureInfo.InvariantCulture) + ","
                                    + constant.Value.y.ToString(CultureInfo.InvariantCulture) + ","
                                    + constant.Value.z.ToString(CultureInfo.InvariantCulture) + ","
                                    + constant.Value.w.ToString(CultureInfo.InvariantCulture) + ")");
                                break;
                        }
                        sb.Append(lines[i], constantIndex + constant.Name.Length, lines[i].Length - constantIndex - constant.Name.Length);
                        lines[i] = sb.ToString();

                        // Check for Unity branches on previous line here?
                    }
                }

                // Then remove Unity branches
                if (RemoveUnityBranches)
                    lines[i] = lines[i].Replace("UNITY_BRANCH", "").Replace("[branch]", "");

                // Replace animated properties with their generated unique names
                if (_replaceAnimatedParameters)
                    foreach (string animPropName in animProps)
                    {
                        int nameIndex;
                        int lastIndex = 0;
                        while ((nameIndex = lines[i].IndexOf(animPropName, lastIndex, StringComparison.Ordinal)) != -1)
                        {
                            lastIndex = nameIndex + 1;
                            char charLeft = ' ';
                            if (nameIndex - 1 >= 0)
                                charLeft = lines[i][nameIndex - 1];
                            char charRight = ' ';
                            if (nameIndex + animPropName.Length < lines[i].Length)
                                charRight = lines[i][nameIndex + animPropName.Length];
                            // Skip invalid matches (probably a subname of another symbol)
                            if (!(Array.Exists(ValidSeparators, x => x == charLeft) && Array.Exists(ValidSeparators, x => x == charRight)))
                                continue;

                            StringBuilder sb = new StringBuilder(lines[i].Length * 2);
                            sb.Append(lines[i], 0, nameIndex);
                            sb.Append(animPropName + "_" + material.GetTag("AnimatedParametersSuffix", false, string.Empty));
                            sb.Append(lines[i], nameIndex + animPropName.Length, lines[i].Length - nameIndex - animPropName.Length);
                            lines[i] = sb.ToString();
                        }
                    }
            }
        }

        public static bool Unlock(Material material)
        {
            if (DefaultUnityShaderNames.Contains(material.shader.name)) return false;
            if (!IsUsingOptimizer(material, true)) return false;
            string originalShaderName = material.GetTag(OriginalShaderTag, false, string.Empty);
            Shader orignalShader = Shader.Find(originalShaderName);
            if (orignalShader == null)
            {
                Debug.LogError("[Kaj Shader Optimizer] Original shader " + originalShaderName + " could not be found");
                return false;
            }
            // For some reason when shaders are swapped on a material the RenderType override tag gets completely deleted and render queue set back to -1
            // So these are saved as temp values and reassigned after switching shaders
            string renderType = material.GetTag("RenderType", false, string.Empty);
            int renderQueue = material.renderQueue;
            material.shader = orignalShader;
            material.SetOverrideTag("RenderType", renderType);
            material.renderQueue = renderQueue;
            return true;
        }



        public class PropertyData
        {
            public string Name;
            public PropertyType Type;
            public Vector4 Value;
        }

        public class Macro
        {
            public string[] Args;
            public string Contents;
            public string Name;
        }

        public class ParsedShaderFile
        {
            public string FilePath;
            public string[] Lines;
        }

        private struct ApplyLater
        {
            public Material Material;
            public Shader Shader;
            public string Smallguid;
            public string NewShaderName;
        }
    }


    public class ShaderOptimizerLockButtonDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty shaderOptimizer, string label, MaterialEditor materialEditor)
        {
            // Theoretically this shouldn't ever happen since locked in materials have different shaders.
            // But in a case where the material property says its locked in but the material really isn't, this
            // will display and allow users to fix the property/lock in
            if (shaderOptimizer.hasMixedValue)
            {
                EditorGUI.BeginChangeCheck();
                GUILayout.Button("Lock in Optimized Shaders (" + materialEditor.targets.Length + " materials)");
                if (EditorGUI.EndChangeCheck())
                    foreach (Material m in materialEditor.targets)
                    {
                        m.SetFloat(shaderOptimizer.name, 1);
                        MaterialProperty[] props = MaterialEditor.GetMaterialProperties(new UnityEngine.Object[] { m });
                        if (!ShaderOptimizer.Lock(m, props)) // Error locking shader, revert property
                            m.SetFloat(shaderOptimizer.name, 0);
                    }
            }
            else
            {
                EditorGUI.BeginChangeCheck();
                if (shaderOptimizer.floatValue == 0)
                {
                    if (materialEditor.targets.Length == 1)
                        GUILayout.Button("Lock In Optimized Shader");
                    else GUILayout.Button("Lock in Optimized Shaders (" + materialEditor.targets.Length + " materials)");
                }
                else GUILayout.Button("Unlock Shader");
                if (EditorGUI.EndChangeCheck())
                {
                    shaderOptimizer.floatValue = shaderOptimizer.floatValue == 1 ? 0 : 1;
                    if (shaderOptimizer.floatValue == 1)
                    {
                        foreach (Material m in materialEditor.targets)
                        {
                            MaterialProperty[] props = MaterialEditor.GetMaterialProperties(new UnityEngine.Object[] { m });
                            if (!ShaderOptimizer.Lock(m, props))
                                m.SetFloat(shaderOptimizer.name, 0);
                        }
                    }
                    else
                    {
                        foreach (Material m in materialEditor.targets)
                            if (!ShaderOptimizer.Unlock(m))
                                m.SetFloat(shaderOptimizer.name, 1);
                    }
                }
            }
        }
        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor) // i have no idea what i need to do this here but this is not my Editor
        {
            return 0;
        }
    }

    /*
    Copyright 2018-2021 Lyuma

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
    to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
    and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    */
    public class CommentFreeIterator : IEnumerable<string>
    {
        private readonly IEnumerable<string> _sourceLines;

        public CommentFreeIterator(IEnumerable<string> sourceLines)
        {
            _sourceLines = sourceLines;
        }
        
        public IEnumerator<string> GetEnumerator()
        {
            int comment = 0;
            foreach (string xline in _sourceLines)
            {
                string line = ParserRemoveComments(xline, ref comment);
                yield return line;
            }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public static string ParserRemoveComments(string line, ref int comment)
        {
            int lineSkip = 0;
            bool cisOpenQuote = false;


            while (true)
            {
                //Debug.Log ("Looking for comment " + lineNum);
                int openQuote = line.IndexOf("\"", lineSkip, StringComparison.CurrentCulture);
                if (cisOpenQuote)
                {
                    if (openQuote == -1)
                    {
                        //Debug.Log("C-Open quote ignore " + lineSkip);
                        break;
                    }

                    lineSkip = openQuote + 1;
                    bool esc = false;
                    int i = lineSkip - 1;
                    while (i > 0 && line[i] == '\\')
                    {
                        esc = !esc;
                        i--;
                    }

                    if (!esc)
                    {
                        cisOpenQuote = false;
                    }

                    //Debug.Log("C-Open quote end " + lineSkip);
                    continue;
                }

                //Debug.Log ("Looking for comment " + lineSkip);
                int commentIdx;
                if (comment == 1)
                {
                    commentIdx = line.IndexOf("*/", lineSkip, StringComparison.CurrentCulture);
                    if (commentIdx != -1)
                    {
                        line = new string(' ', commentIdx + 2) + line.Substring(commentIdx + 2);
                        lineSkip = commentIdx + 2;
                        comment = 0;
                    }
                    else
                    {
                        line = "";
                        break;
                    }
                }

                commentIdx = line.IndexOf("//", lineSkip, StringComparison.CurrentCulture);
                int commentIdx2 = line.IndexOf("/*", lineSkip, StringComparison.CurrentCulture);
                if (commentIdx2 != -1 && (commentIdx == -1 || commentIdx > commentIdx2))
                {
                    commentIdx = -1;
                }

                if (openQuote != -1 && (openQuote < commentIdx || commentIdx == -1) &&
                    (openQuote < commentIdx2 || commentIdx2 == -1))
                {
                    cisOpenQuote = true;
                    lineSkip = openQuote + 1;
                    //Debug.Log("C-Open quote start " + lineSkip);
                    continue;
                }

                if (commentIdx != -1)
                {
                    line = line.Substring(0, commentIdx);
                    break;
                }

                commentIdx = commentIdx2;
                if (commentIdx != -1)
                {
                    int endCommentIdx = line.IndexOf("*/", lineSkip, StringComparison.CurrentCulture);
                    if (endCommentIdx != -1)
                    {
                        line = line.Substring(0, commentIdx) + new string(' ', endCommentIdx + 2 - commentIdx) +
                               line.Substring(endCommentIdx + 2);
                        lineSkip = endCommentIdx + 2;
                    }
                    else
                    {
                        line = line.Substring(0, commentIdx);
                        comment = 1;
                        break;
                    }
                }
                else
                {
                    break;
                }
            }

            return line;
        }
    }

    public class PragmaIterator : IEnumerable<KeyValuePair<string, int>>
    {
        private readonly IEnumerable<string> _sourceLines;
        private readonly int _startLine;

        public PragmaIterator(IEnumerable<string> sourceLines, int startLine)
        {
            _sourceLines = sourceLines;
            _startLine = startLine;
        }

        public IEnumerator<KeyValuePair<string, int>> GetEnumerator()
        {
            Regex re = new Regex("^\\s*#\\s*pragma\\s+(.*)$");
            //Regex re = new Regex ("^\\s*#\\s*pragma\\s+geometry\\s+\(\\S*\)\\s*$");
            int ln = _startLine - 1;
            foreach (string xline in _sourceLines)
            {
                string line = xline;
                ln++;
                /*if (ln < startLine + 10) { Debug.Log ("Check line " + ln +"/" + line); }
            line = line.Trim ();
            if (line.StartsWith("#", StringComparison.CurrentCulture)) {
                Debug.Log ("Check pragma " + ln + "/" + line);
            }*/
                if (re.IsMatch(line))
                {
                    //Debug.Log ("Matched pragma " + line);
                    yield return new KeyValuePair<string, int>(re.Replace(line, match => match.Groups[1].Value),
                        ln);
                }
            }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}