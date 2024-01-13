#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"

#ifndef __UNWATER__
#define __UNWATER__

void drawUnwaterColor(inout vec4 color,float time){
    if(isEyeInWater==1){
        color.rgb*=getUnwaterFogColor(time);
    }
    else if(isEyeInWater==2){
        color.rgb*=getLavaFogColor();
    }
}

#endif