#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"
#include "/libs/lighting/shadow.glsl"

#ifdef VSH

varying vec2 texCoord;
varying vec4 lightMapCoord;
varying vec4 color;

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

varying float blockId;
varying vec3 normal;
varying vec3 upVec;

void main() {

    color = gl_Color;

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
varying vec4 color;
varying vec3 upVec;

void main() {

    vec4 color;

    #ifdef DRAW_TEXTURE

    color = texture2D(texture, texCoord) * color;

    #endif

    #ifdef SCREEN_TO_VIEW

    vec3 screenCoord = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
    vec4 viewCoord0=getViewCoord(screenCoord.xy,screenCoord.z);
    vec4 viewCoord1=getViewCoord(screenCoord.xy,screenCoord.z);

    #ifdef VIEW_TO_WORLD

    vec4 worldCoord0=getWorldCoordFormViewCoord(viewCoord0);
    vec4 worldCoord1=getWorldCoordFormViewCoord(viewCoord1);

    #ifdef DRAW_SHADOW

    float time=getTime(upVec);

    vec3 lightViewCoord;
    if(time>0.5){
        lightViewCoord=moonPosition;
    }
    else{
        lightViewCoord=sunPosition;
    }
    lightViewCoord=normalize(lightViewCoord);

    color.rgb=vec3(
            getShadowCoefficient(worldCoord0,viewCoord0,normal,lightViewCoord,shadowtex0,blockId,time),
            getShadowCoefficient(worldCoord1,viewCoord1,normal,lightViewCoord,shadowtex1,blockId,time),
            0
        );

    #endif //DRAW_SHADOW END
    #endif //VIEW_TO_WORLD END
    #endif //SCREEN_TO_VIEW END

    /* DRAWBUFFERS:023 */
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(normal,1);
    gl_FragData[2] = vec4(blockId,blockId,1,1);

}

#endif