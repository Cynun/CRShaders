#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"

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

varying vec2 texCoord;
varying float blockId;
varying vec3 normal;
varying vec4 baseColor;
varying vec3 upVec;
varying vec4 lightMapCoord;

void main() {

    vec4 color = texture2D(texture,texCoord)*baseColor;
    float time=getTime(upVec);
    color.rgb*=2;
    color.rgb=clamp(color.rgb,vec3(0),vec3(1));
    color.rgb*=getAmbientColor(time);
    color.a*=0.5;

    /* DRAWBUFFERS:0234 */
    gl_FragData[0] = color;
    gl_FragData[1] = vec4(normal,0);
    gl_FragData[2] = vec4(blockId,blockId,1,1);
    gl_FragData[3] = vec4(0);

}

#endif