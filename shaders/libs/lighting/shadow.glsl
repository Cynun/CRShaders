#include "/libs/util/util.glsl"

#ifndef __SHADOW__
#define __SHADOW__

const int shadowMapResolution = 2048;

const float shadowDistance = 160;

const float ambientOcclusionLevel = 0.8;

const float sunPathRotation = 15;

vec2 shadowFilterOffset[9]=vec2[](
    vec2( 0.0   , 0.0   ),
    vec2( 0.0   , 1.0   ),
    vec2( 0.7071, 0.7071),
    vec2( 1.0   , 0.0   ),
    vec2( 0.7071,-0.7071),
    vec2( 0.0   ,-1.0   ),
    vec2(-0.7071,-0.7071),
    vec2(-1.0   , 0.0   ),
    vec2(-0.7071, 0.7071)
);

float getShadow(sampler2DShadow src,vec3 sunCoord,float radius){
    float shadow=sunCoord.z-shadow2D(src,sunCoord).x;
    if(shadow>0.0001){
        if(shadow>=0.001){
            shadow=1;
        }
        else{
            shadow*=1000;
        }
    }
    else{
        shadow=0;
    }
    return shadow;
}


float inShadow(vec4 sunCoord,float dis,sampler2DShadow shadowtex,float filterRadius){
    float shadow=0;

    for(int i=0;i<9;i++){
        float offset=filterRadius/shadowMapResolution*getNoise(sunCoord.xy+0.4363465*i)/(1+0.1*dis);
        shadow+=getShadow(shadowtex,sunCoord.xyz+vec3(offset*shadowFilterOffset[i],0),filterRadius);
    }
    
    return shadow/9;
}


float getShadowCoefficient(vec4 sunCoord,float dis,vec3 normalViewCoord,vec3 lightViewCoord,
                            sampler2DShadow shadowtex,float blockId,float time){

    float disAttenuation=dis;
    if(disAttenuation>16*64){
        return 0;
    }
    disAttenuation/=16*10;
    if(disAttenuation>0.90){
        disAttenuation=mix(1,0,clamp((disAttenuation-0.90)*(1/0.10),0,1));
    }
    else{
        disAttenuation=1;
    }

    float lightDotNormal=dot(normalViewCoord,lightViewCoord);
    float angleShadow=clamp(1-lightDotNormal,0,1);
    angleShadow*=angleShadow*angleShadow;

    if(isEqual(blockId,BLOCKID_LEAVES)){
        angleShadow*=0.5;
    }
    else if(isEqual(blockId,BLOCKID_GRASS)){
        angleShadow=0;
    }

    float shadowCoefficient=inShadow(sunCoord,dis,shadowtex,4)*disAttenuation;

    shadowCoefficient=max(shadowCoefficient,angleShadow);
    shadowCoefficient=mix(1,shadowCoefficient,abs(clamp(10*time,-1,1)));
    shadowCoefficient=mix(shadowCoefficient,1,rainStrength*0.8);

    return shadowCoefficient;
}

#endif