#include "/libs/config.glsl"
#include "/libs/color/color.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"
#include "/libs/util/reflection.glsl"
#include "/libs/lighting/shadow.glsl"
#include "/libs/lighting/lighting.glsl"
#include "/libs/sky/cloud.glsl"
#include "/libs/fog/fog.glsl"
#include "/libs/color/color.glsl"
#include "/libs/bloom/bloom.glsl"
#include "/libs/material/auto_material.glsl"


#ifdef VSH

varying vec2 texCoord;
varying vec4 lightMapCoord;
varying vec4 baseColor;

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

varying float blockId;
varying vec3 orgNormal;
varying vec3 upVec;

void main() {

    baseColor = gl_Color;

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    lightMapCoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
    orgNormal = gl_NormalMatrix * gl_Normal;

    upVec = normalize(gbufferModelView[1].xyz);

    blockId = mc_Entity.x;

    gl_Position = ftransform();

}

#else

varying vec2 texCoord;
varying float blockId;
varying vec3 orgNormal;
varying vec4 baseColor;
varying vec3 upVec;
varying vec4 lightMapCoord;

void main() {

    vec4 color;
    vec4 material;
    vec3 normal=orgNormal;

    float shadowCoefficient0;
    float shadowCoefficient1;

    float time=getTime(upVec);

    vec4 colorSunCoord=vec4(1);

    vec4 bloom;

    #ifdef DRAW_TEXTURE
        color = texture2D(texture,texCoord)*baseColor;
    #endif //DRAW_TEXTURE END

    vec3 lightViewCoord;
    
    #ifdef WORLD
        if(time>0){
            lightViewCoord=moonPosition;
        }
        else{
            lightViewCoord=sunPosition;
        }
        lightViewCoord=normalize(lightViewCoord);
    #endif

    #ifdef END
        lightViewCoord=normalize(getViewCoordFromWorldCoord(vec4(1,1,1,1)).xyz); 
    #endif

    //Before draw light

    #ifdef SCREEN_TO_VIEW

        vec3 screenCoord = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
        vec4 viewCoord=getViewCoord(screenCoord.xy,screenCoord.z);

        #ifdef VIEW_TO_WORLD

            vec4 worldCoord=getWorldCoordFormViewCoord(viewCoord);
            float dis=length(worldCoord);

            #ifdef WORLD_TO_ABS
                #ifdef AUTO_MATERIAL
                    vec4 absoluteWorldCoord=worldCoord+vec4(cameraPosition,0);
                    
                    #ifndef PBR_MATERIAL
                    getAutoMaterial(color,normal,material,lightMapCoord.y,upVec,blockId,absoluteWorldCoord,screenCoord,baseColor);
                    #else
                    getPBRMaterial(color,normal,material,texCoord,lightMapCoord.y,upVec,blockId,absoluteWorldCoord,screenCoord,baseColor);
                    #endif

                    #ifdef BLOOM_ENABLE
                        getLighterBloom(bloom,color,material.y);
                    #endif
                #endif
            #endif

            #ifdef WORLD_TO_SUN

                vec4 sunCoord=getSunScreenCoord(worldCoord);

                #ifdef DRAW_SHADOW

                    #ifdef SHADOW_ENABLE
                        shadowCoefficient0=getShadowCoefficient(sunCoord,dis,normal,lightViewCoord,shadowtex0,blockId,time);
                        #ifdef COLORFUL_SHADOW_ENABLE
                            shadowCoefficient1=getShadowCoefficient(sunCoord,dis,normal,lightViewCoord,shadowtex1,blockId,time);
                            colorSunCoord=texture2D(shadowcolor0,sunCoord.xy);
                        #else //COLORFUL_SHADOW CLOSE
                            shadowCoefficient1=shadowCoefficient0;
                        #endif //COLORFUL_SHADOW END
                    #else //DRAW_SHADOW CLOSE
                        shadowCoefficient0=getAngleShadow(normal,lightViewCoord,blockId,time);
                        shadowCoefficient1=shadowCoefficient0;
                    #endif //SHADOW_ENABLE

                #endif //DRAW_SHADOW END
            #endif //WORLD_TO_SUN END
        #endif //VIEW_TO_WORLD END
    #endif //SCREEN_TO_VIEW END

    //Draw light
    drawLight(color,colorSunCoord,time,material.y,lightMapCoord.xyz,shadowCoefficient0,shadowCoefficient1);

    //After draw light
    #ifdef SCREEN_TO_VIEW
        #ifdef DRAW_REFLECT
            #ifdef REFLECT_ENABLE
                drawReflect(color,screenCoord,viewCoord,normal,material.x,material.w);
            #endif
        #endif

        #ifdef VIEW_TO_WORLD

            #ifdef DRAW_DISTANCE_FOG
                drawDistanceFog(color,worldCoord,viewCoord,dot(upVec,normalize(viewCoord.xyz)),time);
            #endif //DRAW_DISTANCE_FOG END

        #endif //VIEW_TO_WORLD END
    #endif //SCREEN_TO_VIEW END

    #ifdef GBUFFER_WATER
        #ifdef CLOUD_ENABLE
            #ifdef DRAW_CLOUD
                drawCloud(color,screenCoord,lightViewCoord,time);
            #endif
        #endif
        #ifdef WORLD
            drawVolumetricLight(color,screenCoord,lightViewCoord,time);
        #endif
    #endif

    bloom.a=1;

    /* DRAWBUFFERS:02345 */
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(normal,1);
    gl_FragData[2] = vec4(blockId,1,1,1);
    gl_FragData[3] = bloom;
    gl_FragData[4] = material;

}

#endif