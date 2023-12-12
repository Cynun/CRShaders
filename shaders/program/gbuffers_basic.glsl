#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"

#ifdef VSH

varying vec2 texCoord;
varying vec4 lightMapCoord;
varying vec4 color;

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

varying float blockId;
varying vec3 normal;

void main() {

    color = gl_Color;

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    lightMapCoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
    normal = gl_NormalMatrix * gl_Normal;

    blockId = mc_Entity.x;

    gl_Position = ftransform();

}

#else

uniform sampler2D texture;

varying vec2 texCoord;
varying float blockId;
varying vec3 normal;
varying vec4 color;

void main() {

    vec4 baseColor = texture2D(texture, texCoord) * color;

    /* DRAWBUFFERS:023 */
    gl_FragData[0] = baseColor;
    gl_FragData[1] = vec4(normal,1);
    gl_FragData[2] = vec4(blockId);

}

#endif