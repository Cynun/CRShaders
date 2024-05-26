#include "/libs/color/color.glsl"

#ifndef __FILTERING__
#define __FILTERING__

void filtering(inout vec4 color,sampler2D src,vec2 texCoord){
    vec2 offset=vec2(0.5)/vec2(viewWidth,viewHeight);
    vec3 N,S,W,E,NE,NW,SE,SW,M;
    M = rgb2hsv(color.rgb);
    N = rgb2hsv(texture2D(src,texCoord+vec2(0,offset.y)).rgb);
    S = rgb2hsv(texture2D(src,texCoord+vec2(0,-offset.y)).rgb);
    W = rgb2hsv(texture2D(src,texCoord+vec2(-offset.x,0)).rgb);
    E = rgb2hsv(texture2D(src,texCoord+vec2(offset.x,0)).rgb);
    float avg = (M.z + N.z + S.z + W.z + E.z) / 5;
    M.z = avg;
    color.rgb = hsv2rgb(M.rgb);
}

#endif