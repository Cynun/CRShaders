#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"

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
    
    vec2 miniCoord1=screenCoordToMiniCoord(texCoord,0,0,1);
    vec2 miniCoord2=screenCoordToMiniCoord(texCoord,2,2,2);
    vec4 color;
    if(inScreen(miniCoord1)){
        color = texture2D(colortex0,miniCoord1);
    }
    if(inScreen(miniCoord2)){
        color = texture2D(colortex0,miniCoord2);
    }
	
    /*DRAWBUFFERS:0*/
	gl_FragData[0] = color;

}

#endif