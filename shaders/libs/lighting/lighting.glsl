#include "/libs/config.glsl"

#ifndef __LIGHTING__
#define __LIGHTING__

void drawLight(inout vec4 color,vec4 colorSunCoord,float time,vec3 lightMapValue,float shadowCoefficient0,float shadowCoefficient1){
    lightMapValue.x*=lightMapValue.x*lightMapValue.x;
    color.rgb*=mix(getAmbientColor(time),vec3(1),lightMapValue.x);

    vec3 skyLightColor=getSkyLightColor(time);
    vec3 torchColor=getTorchColor();
    vec3 shadowColor=getShadowColor();

    float colorfulShadowCoefficient=shadowCoefficient0-shadowCoefficient1;

    float shadowLight=shadowCoefficient0;
    shadowLight=(shadowLight-0.5)*2;

    vec3 lightOrShadow=vec3(1);

    if(shadowLight>0){
        lightOrShadow=mix(vec3(1),shadowColor,shadowLight);
        lightOrShadow=mix(lightOrShadow,(1+skyLightColor*colorSunCoord.rgb),colorfulShadowCoefficient*(1-colorSunCoord.a));
    }
    else{
        lightOrShadow=mix(vec3(1),1+skyLightColor,(-shadowLight));
    }
    
    lightOrShadow=max(
        lightOrShadow*mix(1,clamp(0.05+lightMapValue.y,0,1),max(shadowCoefficient0,0.25*colorfulShadowCoefficient))
        ,(1+torchColor)*lightMapValue.x
        );

    color.rgb*=lightOrShadow;

}

#endif