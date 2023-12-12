#ifndef GENERAL_UNIFORMS
#define GENERAL_UNIFORMS

uniform float rainStrength;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D noisetex;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2DShadow shadowtex0;
uniform sampler2DShadow shadowtex1;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform int isEyeInWater;
uniform float far;
uniform float near;
uniform float viewWidth;
uniform float viewHeight;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;
uniform float frameTimeCounter;
uniform int worldTime;
uniform vec3 cameraPosition;
uniform int moonPhase;
uniform float wetness;
uniform ivec2 eyeBrightnessSmooth;
uniform ivec2 eyeBrightness;
uniform float centerDepthSmooth;
uniform float aspectRatio;

#endif