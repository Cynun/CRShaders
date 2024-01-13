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

vec4 getWorldCoord(vec2 texCoord,float depth){
	vec4 screenCoord = vec4(texCoord.x, texCoord.y, depth, 1.0);
    screenCoord.xyz= (screenCoord * 2.0 - 1.0).xyz;
	vec4 viewCoord = gbufferProjectionInverse * screenCoord;
	viewCoord /= viewCoord.w;
    return gbufferModelViewInverse * viewCoord;
}

#define GET_LUMA(COLOR) (0.213 * COLOR.r + 0.715 * COLOR.g + 0.072 * COLOR.b)

#define SHADOW_MAP_BIAS 0.85

vec2 getFishEyeCoord(vec2 ndcCoord) {
    return ndcCoord / ((1-SHADOW_MAP_BIAS)+SHADOW_MAP_BIAS*length(ndcCoord.xy));
}

float getFishEyeCoordCoefficient(vec2 ndcCoord) {
    return (1-SHADOW_MAP_BIAS)+SHADOW_MAP_BIAS*length(ndcCoord.xy);
}

vec4 getViewCoord(vec2 screenCoordXY,float depth){
	vec4 screenCoord = vec4(screenCoordXY.x, screenCoordXY.y, depth, 1.0);
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

vec4 getSunScreenCoordNoFishEye(vec4 worldCoord){
    vec4 sunViewCoord = shadowModelView * worldCoord; 
    vec4 sunClipCoord = shadowProjection * sunViewCoord;
    vec4 sunScreenCoord = sunClipCoord/sunClipCoord.w;
    return sunScreenCoord * 0.5 + 0.5;
}

vec4 getScreenCoordFromViewCoord(vec4 viewCoord){
    vec4 screenCoord = gbufferProjection * viewCoord;
    screenCoord /= screenCoord.w;
    if(screenCoord.z < -1 || screenCoord.z > 1)
        return vec4(-1.0);
    screenCoord = screenCoord * 0.5f + 0.5f;
    return screenCoord;
}

vec4 getViewCoordFromWorldCoord(vec4 worldCoord){
    return gbufferModelView * worldCoord;
}

float linearizeDepth(float depth) {
    return (2.0 * near) / (far + near - depth * (far - near));
}
 
float getLinearDepthFormViewCoord(vec4 viewCoord) {
    vec4 p = viewCoord;
    p = gbufferProjection * p;
    p /= p.w;
    return linearizeDepth(p.z * 0.5 + 0.5);
}

bool isEqual(float a,float b){
    return abs(a-b)<0.01;
}

float getTime(vec3 upVec){
    float sunDotUp = dot(normalize(sunPosition),upVec);
    return -sunDotUp;
}

float getNoise(vec2 coord) {
    return mod(52.9829189 * fract(0.06711056 * coord.x + 0.00583715 * coord.y),1);
}

vec4 noiseSample(vec2 pos){
    pos.x=mod(pos.x,2);
    if(pos.x>=1){
        pos.x=1-(pos.x-1);
    }
    pos.y=mod(pos.y,2);
    if(pos.y>=1){
        pos.y=1-(pos.y-1);
    }
    return texture2D(noisetex,pos);
}

#endif