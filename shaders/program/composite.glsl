#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"
#include "/libs/bloom/bloom.glsl"
#include "/libs/color/unwater.glsl"

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
    vec4 bloom=texture2D(colortex4,texCoord);

    float time=getTime(upVec);
    drawUnwaterColor(color,time);

    #ifdef BLOOM_ENABLE
        getNatureBloom(bloom,color);
    #endif

    /*DRAWBUFFERS:04*/
	gl_FragData[0] = color;
    gl_FragData[1] = bloom;

}

#endif