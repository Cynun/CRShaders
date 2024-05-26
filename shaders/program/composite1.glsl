#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"
#include "/libs/color/color.glsl"
#include "/libs/bloom/bloom.glsl"
#include "/libs/util/FXAA.glsl"
#include "/libs/util/outline.glsl"

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
    
    //vec4 color = texture2D(colortex0, miniCoordToScreenCoord(texCoord,0,0,1));
    //color=mix(color,texture2D(colortex0, miniCoordToScreenCoord(texCoord,2,2,2)),0.5);

    vec4 color=texture2D(colortex0,texCoord);
    vec4 bloom;

    #ifdef OUTLINE_ENABLE
        float blockId=texture2D(colortex3,texCoord).x;
        drawOutline(color,texCoord,blockId);
    #endif

    #ifdef BLOOM_ENABLE
        firstPassBloom(bloom,texCoord);
    #endif
	
    /*DRAWBUFFERS:04*/
	gl_FragData[0] = clamp(color,vec4(0),vec4(1));
    gl_FragData[1] = bloom;

}

#endif