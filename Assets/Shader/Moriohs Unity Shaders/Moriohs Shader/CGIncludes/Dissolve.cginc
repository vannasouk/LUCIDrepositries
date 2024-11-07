#ifndef DISSOLVE_INCLUDED
#define DISSOLVE_INCLUDED

//couldn't figure out why the Pattern didn't scale properly for the Shadow Caster Pass. That's the only Problem with this
float _MaterializeColorLayerR;
float _MaterializeLayerModeR;
float _MaterializeR;
float _MaterializeColorLayerG;
float _MaterializeLayerModeG;
float _MaterializeG;
float _MaterializeColorLayerB;
float _MaterializeLayerModeB;
float _MaterializeB;
float _MaterializeColorLayerA;
float _MaterializeLayerModeA;
float _MaterializeA;
float _DissolveModifier;
sampler2D _DissolvePattern;
float4 _DissolvePattern_ST;
float group_toggle_Dissolve;
float _DissolvePatternUVSwitch;

float3 DissolvePatternSample()
{
    //float3 Tex = _DissolvePattern.Sample(sampler_DissolvePattern, input.uv0 * _DissolvePattern_ST.xy + _DissolvePattern_ST.zw);
    float3 Tex = tex2D(_DissolvePattern, input.uv0 * _DissolvePattern_ST.xy + _DissolvePattern_ST.zw);
    return Tex;
}

void Dissolve (out half finalout)
{
    half Ra = _MaterializeColorLayerR/100;
    half Rb = Ra - 0.005;
    half Rc = Ra + 0.005;
    half2 RforComp = 0;
    if (_MaterializeLayerModeR == 0)
    {
        RforComp = half2(Rb, Rc);
    }
    else if (_MaterializeLayerModeR == 1)
    {
        RforComp = half2(-0.005, Rc);
    }
    else if (_MaterializeLayerModeR == 2)
    {
        RforComp = half2(Rb, 1.005);
    }

    half Ga = _MaterializeColorLayerG/100;
    half Gb = Ga - 0.005;
    half Gc = Ga + 0.005;
    half2 GforComp = 0;
    if (_MaterializeLayerModeG == 0)
    {
        GforComp = half2(Gb, Gc);
    }
    else if (_MaterializeLayerModeG == 1)
    {
        GforComp = half2(-0.005, Gc);
    }
    else if (_MaterializeLayerModeG == 2)
    {
        GforComp = half2(Gb, 1.005);
    }

    half Ba = _MaterializeColorLayerB/100;
    half Bb = Ba - 0.005;
    half Bc = Ba + 0.005;
    half2 BforComp = 0;
    if (_MaterializeLayerModeB == 0)
    {
        BforComp = half2(Bb, Bc);
    }
    else if (_MaterializeLayerModeB == 1)
    {
        BforComp = half2(-0.005, Bc);
    }
    else if (_MaterializeLayerModeB == 2)
    {
        BforComp = half2(Bb, 1.005);
    }

    half Aa = _MaterializeColorLayerA/100;
    half Ab = Aa - 0.005;
    half Ac = Aa + 0.005;
    half2 AforComp = 0;
    if (_MaterializeLayerModeA == 0)
    {
        AforComp = half2(Ab, Ac);
    }
    else if (_MaterializeLayerModeA == 1)
    {
        AforComp = half2(-0.005, Ac);
    }
    else if (_MaterializeLayerModeA == 2)
    {
        AforComp = half2(Ab, 1.005);
    }
    //Final Materialize Layers
    half4 combA = half4(RforComp.x, GforComp.x, BforComp.x, AforComp.x);
    half4 combB = half4(RforComp.y, GforComp.y, BforComp.y, AforComp.y);
    half4 MaterializeLayers = input.color >= combA && input.color <= combB ? input.color : half4(0,0,0,0);
    MaterializeLayers = ceil(MaterializeLayers);

    //Pattern
    half3 PatternTex = DissolvePatternSample();
    half Pattern = max(max(PatternTex.r, PatternTex.g), PatternTex.b);

    //Main Layer
    half whiteExclude = input.color.r && input.color.g && input.color.b;
    half Dissolve = lerp(_DissolveModifier + Pattern * 1.995 - 0.995, 1, whiteExclude);

    //Materialize
    half MaterializeR = (_MaterializeR + Pattern * 1.995 - 0.995) * MaterializeLayers.r;
    half MaterializeG = (_MaterializeG + Pattern * 1.995 - 0.995) * MaterializeLayers.g;
    half MaterializeB = (_MaterializeB + Pattern * 1.995 - 0.995) * MaterializeLayers.b;
    half MaterializeA = (_MaterializeA + Pattern * 1.995 - 0.995) * MaterializeLayers.a;
    
    finalout = 1-max(max(max(max(MaterializeR, MaterializeG), MaterializeB), MaterializeA), Dissolve) +0.005;
}

#endif //END