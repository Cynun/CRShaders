#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"
#include "/libs/color/color.glsl"
#include "/libs/bloom/bloom.glsl"
#include "/libs/util/FXAA.glsl"

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

    vec4 color=texture2D(colortex0,texCoord);
    vec4 bloom;

    #ifdef FAXX_ENABLE
    FXAA(color,colortex0,texCoord);
    #endif

    // hsv color adjust
    //colorAdjust(color,vec3(0,0,0));

    #ifdef BLOOM_ENABLE
    secondPassBloom(bloom,texCoord);
    color.rgb+=bloom.rgb*BLOOM_STRENGHT;
    #endif
	
    /*DRAWBUFFERS:04*/
	gl_FragData[0] = clamp(color,vec4(0),vec4(1));
    gl_FragData[1] = bloom;

}

#endif