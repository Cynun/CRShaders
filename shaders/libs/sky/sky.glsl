#include "/libs/util/util.glsl"
#include "/libs/config.glsl"

#ifndef __SKY__
#define __SKY__

void drawSky(inout vec4 color,inout vec3 bloom,vec4 viewCoord,float upDotView,float time){

    vec3 skyUpColor=getSkyUpColor(time);

    vec3 skyDownColor=getSkyDownColor(time);

    upDotView=1-upDotView;
    upDotView*=upDotView;
    upDotView=1-upDotView;

    color.rgb=mix(skyDownColor,skyUpColor,clamp(upDotView,0,1));

    #ifdef WORLD

    vec3 sunColor=getSunColor(time);
    vec3 moonColor=getMoonColor(time);

    float sunLightSth=clamp(-time+0.5,0,1)*0.75*(1-0.8*rainStrength);
    float moonLightSth=clamp(time+0.15,0,1)*0.75*(1-0.8*rainStrength);

    float disToSun=length(normalize(sunPosition)-normalize(viewCoord.xyz));
    float disToMoon=length(normalize(moonPosition)-normalize(viewCoord.xyz));

    disToSun=clamp(1-disToSun,0,1);
    disToMoon=clamp(1-disToMoon,0,1);
    disToSun*=disToSun;
    disToMoon*=disToMoon;

    color.rgb=mix(color.rgb,sunColor,disToSun*sunLightSth);
    color.rgb=mix(color.rgb,moonColor,disToMoon*moonLightSth);

    #endif

    bloom=0.1*color.rgb;

}

vec3 getDistanceFogColor(vec4 viewCoord,float upDotView,float time){

    vec3 skyUpColor=getSkyUpColor(time);

    vec3 skyDownColor=getSkyDownColor(time);

    upDotView=1-upDotView;
    upDotView*=upDotView;
    upDotView=1-upDotView;

    vec3 color=mix(skyDownColor,skyUpColor,clamp(upDotView,0,1));

    #ifdef WORLD

    vec3 sunColor=getSunColor(time);
    vec3 moonColor=getMoonColor(time);

    float sunLightSth=clamp(-time+0.5,0,1)*0.75;
    float moonLightSth=clamp(time+0.15,0,1)*0.75;

    float disToSun=length(normalize(sunPosition)-normalize(viewCoord.xyz));
    float disToMoon=length(normalize(moonPosition)-normalize(viewCoord.xyz));

    disToSun=clamp(1-disToSun,0,1);
    disToMoon=clamp(1-disToMoon,0,1);
    disToSun*=disToSun;
    disToMoon*=disToMoon;

    color=mix(color,sunColor,disToSun*sunLightSth);
    color=mix(color,moonColor,disToMoon*moonLightSth);

    #endif

    return color;

}

#endif