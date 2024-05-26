#include "/libs/sky/sky.glsl"

#ifndef __FOG__
#define __FOG__

vec3 getDistanceFogColor(vec4 viewCoord,float upDotView,float time){
    vec3 color;
    if(isEyeInWater==0){
        vec3 skyUpColor=getSkyUpColor(time);

        vec3 skyDownColor=getSkyDownColor(time);

        upDotView=1-upDotView;
        upDotView*=upDotView;
        upDotView=1-upDotView;

        color=mix(skyDownColor,skyUpColor,clamp(upDotView,0,1));

        #ifdef WORLD

        vec3 sunColor=getSunColor(time);
        vec3 moonColor=getMoonColor(time);

        float sunLightSth=clamp(-time+0.5,0,1)*(1-rainStrength);
        float moonLightSth=clamp(time+0.15,0,1)*(1-rainStrength);

        float disToSun=length(normalize(sunPosition)-normalize(viewCoord.xyz));
        float disToMoon=length(normalize(moonPosition)-normalize(viewCoord.xyz));

        disToSun=clamp(1-disToSun,0,1);
        disToMoon=clamp(1-disToMoon,0,1);
        disToSun*=disToSun;
        disToMoon*=disToMoon;

        color=mix(color,sunColor,disToSun*sunLightSth);
        color=mix(color,moonColor,disToMoon*moonLightSth);

        #endif
    }
    else if(isEyeInWater==1){
        color=getUnwaterFogColor(time);
    }
    else{
        color=getLavaFogColor();
    }
    return color;

}

void drawDistanceFog(inout vec4 color,vec4 worldCoord,vec4 viewCoord,float upDotView,float time){
    float distanceFogStart=getDistanceFogStart();
    float distanceFogEnd=getDistanceFogEnd();
    vec3 fogColor = getDistanceFogColor(viewCoord,upDotView,time);
    float dis=clamp((length(worldCoord.xz)-far*distanceFogEnd*distanceFogStart)/(far*distanceFogEnd*(1-distanceFogStart)),0,1);
    // float dis = clamp(length(worldCoord.xz)/(128*16),0,1);
    dis*=dis;
    color.rgb=mix(color.rgb,fogColor,dis);
}

#endif