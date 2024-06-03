#include "/libs/util/util.glsl"
#include "/libs/uniforms.glsl"

#ifndef __AUTO_MATERIAL__
#define __AUTO_MATERIAL__

#define BLOCK_TYPE(ID) else if(isEqual(blockId,ID))

void getPBRMaterial(inout vec4 color,inout vec3 normal,inout vec4 material,vec2 texCoord,float skyLightStrength,vec3 upVec,float blockId,vec4 absoluteWorldCoord,vec3 screenCoord,vec4 baseColor){

    vec4 pbr = texture2D(specular,texCoord);
    pbr.r = pow(1.0 - pbr.r, 2.0);
    pbr.a = pbr.a == 1.0 ? 0.0 : pbr.a;

    vec4 normalTexture = texture2D(normals,texCoord);
    float ao = sqrt(1.0 - dot(normalTexture.xy, normalTexture.xy));
    color.rgb *= 0.75 + 0.25 * ao;

    material.x = pbr.g;
    material.y = pbr.a;
    material.z = 0;
    material.w = pbr.r;

    if(isEqual(blockId,BLOCKID_WATER)){
        #include "/libs/material/water.glsl"
    }

    #ifdef RAIN_REFLECTION
    #ifdef WORLD
    float rainRefectionStrength = 10 * (skyLightStrength - 0.9) * wetness;
    rainRefectionStrength *= noiseSample(absoluteWorldCoord.xz / 128).x;
    rainRefectionStrength *= clamp(dot(upVec,normal),0,1);
    material.x += rainRefectionStrength;
    material.x = clamp(material.x,0,1);
    material.w -= 2 * rainRefectionStrength;
    material.w = clamp(material.w,0,1);
    #endif
    #endif
}
 
void getAutoMaterial(inout vec4 color,inout vec3 normal,inout vec4 material,float skyLightStrength,vec3 upVec,float blockId,vec4 absoluteWorldCoord,vec3 screenCoord,vec4 baseColor){
    
    material.x = 0.0;
    material.w = 1.0;

    if(blockId<10000);
    #ifdef GET_LIGHT_BLOOM
    BLOCK_TYPE(BLOCKID_LIGHTER){
        #include "/libs/material/lighter.glsl"
        }
    BLOCK_TYPE(BLOCKID_NATURE_LIGHTER){
        #include "/libs/material/nature_lighter.glsl"
    }
    BLOCK_TYPE(BLOCKID_BEACON){
        #include "/libs/material/beacon.glsl"
    }
    #endif
    BLOCK_TYPE(BLOCKID_GLASS){
        #include "/libs/material/glass.glsl"
    }
    BLOCK_TYPE(BLOCKID_WATER){
        #include "/libs/material/water.glsl"
    }
    BLOCK_TYPE(BLOCKID_ICE){
        #include "/libs/material/ice.glsl"
    }
    BLOCK_TYPE(BLOCKID_ORE_BLOCK){
        #include "/libs/material/ore_block.glsl"
    }
    #ifdef LIGHT_ORE_ENABLE
    BLOCK_TYPE(BLOCKID_ORE){
        #include "/libs/material/light_ore.glsl"
    }
    #endif

    #ifdef RAIN_REFLECTION
    #ifdef WORLD
    float rainRefectionStrength = 10 * (skyLightStrength - 0.9) * wetness;
    rainRefectionStrength *= noiseSample(absoluteWorldCoord.xz / 128).x;
    rainRefectionStrength *= clamp(dot(upVec,normal),0,1);
    material.x -= rainRefectionStrength;
    material.x = clamp(material.x,0,1);
    material.w -= 2 * rainRefectionStrength;
    material.w = clamp(material.w,0,1);
    #endif
    #endif
}

#endif