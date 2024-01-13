#version 120

#include "/libs/util/util.glsl"

varying vec4 texcoord;

void main() {
    vec4 pos = ftransform();
    pos.xy=getFishEyeCoord(pos.xy);
    gl_Position = pos;
    texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
}
