#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"
#include "/libs/lighting/shadow.glsl"
#include "/libs/lighting/lighting.glsl"
#include "/libs/fog/fog.glsl"
#include "/libs/color/color.glsl"

#ifdef VSH

varying vec2 texCoord;
varying vec4 lightMapCoord;
varying vec4 baseColor;

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

varying float blockId;
varying vec3 normal;
varying vec3 upVec;

void main() {

    baseColor = gl_Color;

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    lightMapCoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
    normal = gl_NormalMatrix * gl_Normal;

    upVec = normalize(gbufferModelView[1].xyz);

    blockId = mc_Entity.x;

    gl_Position = ftransform();

}

#else

uniform sampler2D texture;

varying vec2 texCoord;
varying float blockId;
varying vec3 normal;
varying vec4 baseColor;
varying vec3 upVec;
varying vec4 lightMapCoord;

void main() {

    vec4 color;

    float shadowCoefficient0;
    float shadowCoefficient1;

    float time=getTime(upVec);

    vec4 colorSunCoord=vec4(1);

    #ifdef DRAW_TEXTURE

    color = texture2D(texture,texCoord)*baseColor;

    #endif //DRAW_TEXTURE END

    //Before draw light
    #ifdef SCREEN_TO_VIEW

    vec3 screenCoord = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
    vec4 viewCoord=getViewCoord(screenCoord.xy,screenCoord.z);

    #ifdef VIEW_TO_WORLD

    vec4 worldCoord=getWorldCoordFormViewCoord(viewCoord);
    float dis=length(worldCoord);

    #ifdef WORLD_TO_SUN

    vec4 sunCoord=getSunScreenCoord(worldCoord);

    #ifdef DRAW_SHADOW

    vec3 lightViewCoord;
    if(time>0){
        lightViewCoord=moonPosition;
    }
    else{
        lightViewCoord=sunPosition;
    }
    lightViewCoord=normalize(lightViewCoord);

    shadowCoefficient0=getShadowCoefficient(sunCoord,dis,normal,lightViewCoord,shadowtex0,blockId,time);

    #ifdef COLORFUL_SHADOW
    shadowCoefficient1=getShadowCoefficient(sunCoord,dis,normal,lightViewCoord,shadowtex1,blockId,time);
    colorSunCoord=texture2D(shadowcolor0,sunCoord.xy);
    #else //COLORFUL_SHADOW CLOSE
    shadowCoefficient1=shadowCoefficient0;
    #endif //COLORFUL_SHADOW END

    #endif //DRAW_SHADOW END
    #endif //WORLD_TO_SUN END
    #endif //VIEW_TO_WORLD END
    #endif //SCREEN_TO_VIEW END

    drawLight(color,colorSunCoord,time,lightMapCoord.xyz,shadowCoefficient0,shadowCoefficient1);

    //After draw light
    #ifdef SCREEN_TO_VIEW
    #ifdef VIEW_TO_WORLD
    #ifdef DRAW_DISTANCE_FOG
    drawDistanceFog(color,worldCoord,viewCoord,dot(upVec,normalize(viewCoord.xyz)),time);
    #endif //DRAW_DISTANCE_FOG END
    #endif //WORLD_TO_SUN END
    #endif //SCREEN_TO_VIEW END

    /* DRAWBUFFERS:023 */
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(normal,1);
    gl_FragData[2] = vec4(blockId,blockId,1,1);

}

#endif