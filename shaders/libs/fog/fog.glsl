#include "/libs/sky/sky.glsl"

#ifndef __FOG__

#define DEISTANCE_FOG_START 0.2
#define DEISTANCE_FOG_END   1.0

void drawDistanceFog(inout vec4 color,vec4 worldCoord,vec4 viewCoord,float upDotView,float time){
    float distanceFogStart=getDistanceFogStart();
    float distanceFogEnd=getDistanceFogEnd();
    vec3 fogColor = getDistanceFogColor(viewCoord,upDotView,time);
    float dis=clamp((length(worldCoord.xz)-far*distanceFogEnd*distanceFogStart)/(far*distanceFogEnd*(1-distanceFogStart)),0,1);
    dis*=dis;
    color.rgb=mix(color.rgb,fogColor,dis);
}

#endif