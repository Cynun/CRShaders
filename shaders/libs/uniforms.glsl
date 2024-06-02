#ifndef __GENERAL_UNIFORMS__
#define __GENERAL_UNIFORMS__

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
uniform sampler2D shadowcolor0;
uniform sampler2DShadow shadowtex0;
uniform sampler2DShadow shadowtex1;
uniform sampler2D texture;
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
uniform vec3 skyColor;
uniform vec3 fogColor;

// PBR
uniform sampler2D specular;
uniform sampler2D normals;


#define BLOCKID_NATURE_LIGHTER 10001
#define BLOCKID_LIGHTER 10002
#define BLOCKID_BEACON 10201
#define BLOCKID_WATER 10003
#define BLOCKID_ICE 10004
#define BLOCKID_GRASS 10005
#define BLOCKID_ORE 10006
#define BLOCKID_ORE_BLOCK 10007
#define BLOCKID_GLASS 10008
#define BLOCKID_LEAVES 10009

#define BLOCKID_HAND 20000
#define BLOCKID_SKY 20001

const float shadowIntervalSize = 0.0;

const int RG32F = 0;
const int RGB32F = 0;

const int colortex2Format = RGB32F;
const int colortex3Format = RG32F;

const bool colortex7Clear = false;


#endif