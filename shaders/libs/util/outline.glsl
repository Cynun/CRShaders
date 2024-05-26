#include "/libs/util/util.glsl"
#include "/libs/fog/fog.glsl"

#ifndef __OUTLINE__
#define __OUTLINE__

vec2 shadowFilterOffset[8]=vec2[](
    vec2( 0.0   , 1.0   ),
    vec2( 0.7071, 0.7071),
    vec2( 1.0   , 0.0   ),
    vec2( 0.7071,-0.7071),
    vec2( 0.0   ,-1.0   ),
    vec2(-0.7071,-0.7071),
    vec2(-1.0   , 0.0   ),
    vec2(-0.7071, 0.7071)
);

float getOutline(vec2 texCoord,float blockId){
    float avg0=-8*linearizeDepth(texture2D(depthtex0,texCoord).x);
    float avg1=-8*linearizeDepth(texture2D(depthtex1,texCoord).x);
    vec2 r=2/vec2(viewWidth,viewHeight);
    for(int i=0;i<8;i++){
        avg0+=linearizeDepth(texture2D(depthtex0,texCoord+shadowFilterOffset[i]*r).x);
        avg1+=linearizeDepth(texture2D(depthtex1,texCoord+shadowFilterOffset[i]*r).x);
    }
    if(isEqual(blockId,BLOCKID_WATER)||isEqual(blockId,BLOCKID_ICE)){
        avg1=0;
    }
    return clamp(max(avg0,avg1)*64,0,1);
}

void drawOutline(inout vec4 color,vec2 texCoord,float blockId){
    float outline = getOutline(texCoord,blockId);
    float luma = GET_LUMA(color);
    color.rgb = mix(color.rgb,(0.5+0.4*luma)*color.rgb,outline * (1 - linearizeDepth(texture2D(depthtex0,texCoord).x)));
}   

#endif