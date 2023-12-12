#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"

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
    
    vec4 color = texture2D(colortex0, texCoord);

    //color.rgb=clamp(color.rgb*color.rgb*color.rgb*4,vec3(0),vec3(1));
	
    /*DRAWBUFFERS:0*/
	gl_FragData[0] = color;

}

#endif