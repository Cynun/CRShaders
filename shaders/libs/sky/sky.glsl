#include "/libs/util/util.glsl"
#include "/libs/config.glsl"

#ifndef __SKY__
#define __SKY__

void drawSky(inout vec4 color,inout vec3 bloom,vec4 viewCoord,float upDotView,float time){

    // Get setting
    vec3 skyUpColor=getSkyUpColor(time);

    vec3 skyDownColor=getSkyDownColor(time);

    upDotView=1-upDotView;
    upDotView*=upDotView;
    upDotView=1-upDotView;

    // Mix sky color
    color.rgb=mix(skyDownColor,skyUpColor,clamp(upDotView,0,1));

    #ifdef WORLD

    // Get setting
    vec3 sunColor = getSunColor(time);
    vec3 moonColor = getMoonColor(time);

    float sunLightSth = 0.5 * clamp(-time+0.5,0,1)*(1-rainStrength);
    float moonLightSth = 0.5 * clamp(time+0.15,0,1)*(1-rainStrength);

    float disToSun=length(normalize(sunPosition)-normalize(viewCoord.xyz));
    float disToMoon=length(normalize(moonPosition)-normalize(viewCoord.xyz));

    disToSun=clamp(1-disToSun,0,1);
    disToMoon=clamp(1-disToMoon,0,1);
    disToSun*=disToSun;
    disToMoon*=disToMoon;

    // Draw light from sun/moon
    color.rgb=mix(color.rgb,sunColor,disToSun*sunLightSth);
    color.rgb=mix(color.rgb,moonColor,disToMoon*moonLightSth);

    #endif

    bloom=0.1*color.rgb;

}

#endif