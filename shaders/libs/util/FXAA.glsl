#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"

#ifndef __FXAA__
#define __FXAA__

void FXAA(inout vec4 color,sampler2D src,vec2 texCoord){
    vec2 offset=vec2(0.75)/vec2(viewWidth,viewHeight);
    float N,S,W,E,NE,NW,SE,SW,M;
    M = GET_LUMA(color);
    N = GET_LUMA(texture2D(src,texCoord+vec2(0,offset.y)));
    S = GET_LUMA(texture2D(src,texCoord+vec2(0,-offset.y)));
    W = GET_LUMA(texture2D(src,texCoord+vec2(-offset.x,0)));
    E = GET_LUMA(texture2D(src,texCoord+vec2(offset.x,0)));
    NW = GET_LUMA(texture2D(src,texCoord+vec2(offset.x,offset.y)));
    NE = GET_LUMA(texture2D(src,texCoord+vec2(-offset.x,offset.y)));
    SW = GET_LUMA(texture2D(src,texCoord+vec2(offset.x,-offset.y)));
    SE = GET_LUMA(texture2D(src,texCoord+vec2(-offset.x,-offset.y)));
    float maxLuma = max(N, max(max(E,W), max(S, M)));
    float minLuma = min(N, min(min(E,W), min(S, M)));
    float contrast =  maxLuma - minLuma;

    if(contrast >= 0.05){
        vec2 target = vec2(
            abs(N + S - 2 * M) * 2+ abs(NE + SE - 2 * E) + abs(NW + SW - 2 * W),
            abs(E + W - 2 * M) * 2 + abs(NE + NW - 2 * N) + abs(SE + SW - 2 * S)
        );
        target*=0.75/vec2(viewWidth,viewHeight);
        color = (color+texture2D(src, texCoord + target)+texture2D(src, texCoord - target))/3;
    }

}

#endif