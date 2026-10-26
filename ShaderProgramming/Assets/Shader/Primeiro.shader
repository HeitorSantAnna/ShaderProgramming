Shader "Custom/Primeiro"
{
    Properties
    {
        [MainColor] _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap("Base Map", 2D) = "white" {}
        _Xs ("Valor de X", Range(-1, 1)) = 0
        _Ys ("Valor de Y", Range(-1, 1)) = 0
        _Zs ("Valor de Z", Range(-1, 1)) = 0
    }

    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            //Imagino que isso sirva para definir qué é BiultIn
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            //Aqui deve ser os IN do outro, 
            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            //Deve existir um para cada script imagino para todos terem as mesmas referencias
            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //Aqui deve estar definindo a forma da textura
            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            //Aqui definimos em valores float, string, half, das váriaveis das propriedades
            CBUFFER_START(UnityPerMaterial)
                half4 _BaseColor;
                float4 _BaseMap_ST;
                float _Xs, _Ys, _Zs;
            CBUFFER_END

            //Aqui deve ser o surf do anterior, devemos fazer os calculos aqui para que o proximo pinte também deve ser onde altera para o HLSL possa alterar
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
                float f = (IN.uv.x * _Xs) + (IN.uv.y * _Ys) + _Zs;
                return f;
            }
            ENDHLSL
        }
    }
}
