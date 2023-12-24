#include "/libs/uniforms.glsl"

#ifndef __UTIL__
#define __UTIL__

vec2 screenCoordToMiniCoord(vec2 texCoord,int row,int column,int divisions){
    float offset=1/pow(2,divisions);
    return (texCoord-offset*vec2(row,column))/offset;
}

vec2 miniCoordToScreenCoord(vec2 texCoord,int row,int column,int divisions){
    float offset=1/pow(2,divisions);
    return texCoord*offset+offset*vec2(row,column);
}

bool inScreen(vec2 texCoord){
    if(texCoord.x>=0&&texCoord.x<=1&&texCoord.y>=0&&texCoord.y<=1){
        return true;
    }
    return false;
}

#define CONVOLUTION_FUNCTION(SIZE) \
    int n=SIZE/2;\
    vec2 offset=vec2(radius)*vec2(1,aspectRatio)/SIZE;\
    float weightSum=0;\
    vec4 color=vec4(0);\
    for(int i=0;i<SIZE;i++){\
        for(int j=0;j<SIZE;j++){\
            float weight=core[i+j*SIZE];\
            weightSum+=weight;\
            color+=weight*texture2D(src,texCoord+offset*vec2(i,j));\
        }\
    }\
    if(normalized){\
        return color/weightSum;\
    }\
    return color;

vec4 convolution(sampler2D src,vec2 texCoord,float core[9],float radius,bool normalized){
    CONVOLUTION_FUNCTION(3)
}

vec4 convolution(sampler2D src,vec2 texCoord,float core[25],float radius,bool normalized){
    CONVOLUTION_FUNCTION(5)
}

vec4 convolution(sampler2D src,vec2 texCoord,float core[49],float radius,bool normalized){
    CONVOLUTION_FUNCTION(7)
}

vec4 getWorldCoord(vec2 texCoord,float depth){
	vec4 screenCoord = vec4(texCoord.x, texCoord.y, depth, 1.0);
    screenCoord.xyz= (screenCoord * 2.0 - 1.0).xyz;
	vec4 viewCoord = gbufferProjectionInverse * screenCoord;
	viewCoord /= viewCoord.w;
    return gbufferModelViewInverse * viewCoord;
}

#define SHADOW_MAP_BIAS 0.95

vec2 getFishEyeCoord(vec2 ndcCoord) {
    return ndcCoord / ((1-SHADOW_MAP_BIAS)+SHADOW_MAP_BIAS*length(ndcCoord.xy));
}

float getFishEyeCoordCoefficient(vec2 ndcCoord) {
    return (1-SHADOW_MAP_BIAS)+SHADOW_MAP_BIAS*length(ndcCoord.xy);
}

vec4 getViewCoord(vec2 texCoord,float depth){
	vec4 screenCoord = vec4(texCoord.x, texCoord.y, depth, 1.0);
	vec4 viewCoord = gbufferProjectionInverse * (screenCoord * 2.0 - 1.0);
	return viewCoord/viewCoord.w;
}

vec4 getWorldCoordFormViewCoord(vec4 viewCoord){
    return gbufferModelViewInverse * viewCoord;
}

vec4 getSunScreenCoord(vec4 worldCoord){

    vec4 sunViewCoord = shadowModelView * worldCoord; 
    vec4 sunClipCoord = shadowProjection * sunViewCoord;
    vec4 sunScreenCoord = sunClipCoord/sunClipCoord.w;
    sunScreenCoord.xy = getFishEyeCoord(sunScreenCoord.xy);
    return sunScreenCoord * 0.5 + 0.5;
}

bool isEqual(float a,float b){
    return abs(a-b)<0.01;
}

float getTime(vec3 upVec){
    float sunDotUp = clamp(10*dot(normalize(sunPosition),upVec),0,1);
    return 1-(sunDotUp*0.5+0.5);
}

float getNoise(vec2 coord) {
    return mod(52.9829189 * fract(0.06711056 * coord.x + 0.00583715 * coord.y),1);
}

#endif