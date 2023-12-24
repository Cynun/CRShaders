#include "/libs/util/util.glsl"

#ifndef __SHADOW__
#define __SHADOW__

const int shadowMapResolution = 2048;

const float shadowDistance = 160;

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

float shadowFilter(sampler2DShadow src,vec3 sunCoord,float radius){
    float depth=0;
    float fishEyeCoordCoefficient=getFishEyeCoordCoefficient(sunCoord.xy);

    for(int i=0;i<9;i++){
        float offset=radius/shadowMapResolution*getNoise(sunCoord.xy+0.4363465*i);
        float currentDepth=sunCoord.z-shadow2D(src,sunCoord+offset*vec3(shadowFilterOffset[i],0)).x;
        if(currentDepth<0.001*fishEyeCoordCoefficient){
            currentDepth=0;
        }
        else{
            currentDepth=1.0;
        }
        depth+=currentDepth;
    }
    return clamp(depth/9,0,1);
}


float inShadow(vec4 worldCoord,vec4 viewCoord,float lightDotNormal,sampler2DShadow shadowtex,float filterRadius){

    lightDotNormal=sqrt(1-lightDotNormal*lightDotNormal);

    float shadowBias=lightDotNormal/(2*shadowMapResolution);

    vec4 sunCoord=getSunScreenCoord(worldCoord);
    sunCoord.z-=shadowBias;
    return shadowFilter(shadowtex,sunCoord.xyz,filterRadius);
}


float getShadowCoefficient(vec4 worldCoord,vec4 viewCoord,vec3 normalViewCoord,vec3 lightViewCoord,
                            sampler2DShadow shadowtex,float blockId,float time){

    float dis=length(worldCoord.xyz);
    if(dis>16*64){
        return 0;
    }
    dis/=16*8;
    if(dis>0.90){
        dis=mix(1,0,clamp((dis-0.90)*(1/0.10),0,1));
    }
    else{
        dis=1;
    }

    float lightDotNormal=dot(normalViewCoord,lightViewCoord);
    float angleShadow=clamp(1-lightDotNormal,0,1);
    angleShadow*=angleShadow;

    if(isEqual(blockId,BLOCKID_GRASS)||isEqual(blockId,BLOCKID_LEAVES)){
        angleShadow*=0.5;
    }

    float shadowCoefficient=inShadow(worldCoord,viewCoord,lightDotNormal,shadowtex,2);

    shadowCoefficient=max(shadowCoefficient*dis,angleShadow);
    shadowCoefficient=mix(1,shadowCoefficient,2*abs(time-0.5));

    return shadowCoefficient;
}

#endif