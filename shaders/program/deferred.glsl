#include "/libs/uniforms.glsl"
#include "/libs/sky/cloud.glsl"
#include "/libs/lighting/lighting.glsl"

#ifdef VSH

varying vec2 texCoord;
varying vec3 upVec;

void main() {

	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
	
	upVec = normalize(gbufferModelView[1].xyz);

    gl_Position = ftransform();

}

#else

varying vec2 texCoord;
varying vec3 upVec;

void main() {

    vec3 screenCoord = vec3(texCoord, texture2D(depthtex0,texCoord).x);

    vec4 color = texture2D(colortex0,screenCoord.st);

    float time=getTime(upVec);

    #ifdef GET_LIGHT_VIEW
    vec3 lightViewCoord;
    if(time>0){
        lightViewCoord=moonPosition;
    }
    else{
        lightViewCoord=sunPosition;
    }
    lightViewCoord=normalize(lightViewCoord);
    #endif

    #ifdef CLOUD_ENABLE
    #ifdef DRAW_CLOUD
    drawCloud(color,screenCoord,lightViewCoord,time);
    #endif
    #endif

    #ifdef WORLD
    drawVolumetricLight(color,screenCoord,lightViewCoord,time);
    #endif

    gl_FragData[0] = clamp(color,vec4(0),vec4(1));
	
    #ifdef REFLECT_ENABLE
    /*DRAWBUFFERS:07*/
    vec4 reflectColor = color * color;
    gl_FragData[1] = reflectColor;
    #else
    /*DRAWBUFFERS:0*/
    #endif

}

#endif