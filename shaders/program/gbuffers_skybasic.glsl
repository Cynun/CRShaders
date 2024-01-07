#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"
#include "/libs/sky/sky.glsl"
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

    blockId = BLOCKID_SKY;

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

    vec4 color=vec4(0,0,0,1);
    vec3 bloom;

    vec3 screenCoord = vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), gl_FragCoord.z);
    vec4 viewCoord=getViewCoord(screenCoord.xy,screenCoord.z);
    vec4 worldCoord=getWorldCoordFormViewCoord(viewCoord);

    float time=getTime(upVec);

    drawSky(color,bloom,viewCoord,dot(upVec,normalize(viewCoord.xyz)),time);

    /* DRAWBUFFERS:0234 */
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(normal,1);
    gl_FragData[2] = vec4(blockId,blockId,1,1);
    gl_FragData[3] = vec4(bloom,0);

}

#endif