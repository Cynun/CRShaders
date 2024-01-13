#include "/libs/util/util.glsl"
#include "/libs/uniforms.glsl"

#ifndef __AUTO_MATERIAL__
#define __AUTO_MATERIAL__

#define BLOCK_TYPE(ID) else if(isEqual(blockId,ID))
 
void getAutoMaterial(inout vec4 color,inout vec3 normal,inout vec4 material,float blockId,vec4 absoluteWorldCoord,vec3 screenCoord,vec4 baseColor){
    if(blockId<10000);
    #ifdef GET_LIGHT_BLOOM
    BLOCK_TYPE(BLOCKID_LIGHTER){
        #include "/libs/material/lighter.glsl"
        }
    BLOCK_TYPE(BLOCKID_NATURE_LIGHTER){
        #include "/libs/material/lighter.glsl"
    }
    #endif
    BLOCK_TYPE(BLOCKID_WATER){
        #include "/libs/material/water.glsl"
    }
    BLOCK_TYPE(BLOCKID_ICE){
        
    }
    BLOCK_TYPE(BLOCKID_ORE_BLOCK){
        
    }
    #ifdef LIGHT_ORE_ENABLE
    BLOCK_TYPE(BLOCKID_ORE){
        #include "/libs/material/light_ore.glsl"
    }
    #endif
}

#endif