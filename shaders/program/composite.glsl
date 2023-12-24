#include "/libs/config.glsl"
#include "/libs/uniforms.glsl"
#include "/libs/util/util.glsl"

#ifdef VSH

varying vec2 texCoord;

void main() {

	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

    gl_Position = ftransform();

}

#else


const int RG32I = 0;
const int RGB32F = 0;

const int colortex2Format = RGB32F;
const int colortex3Format = RG32I;


varying vec2 texCoord;


void main() {
    
    vec4 color=texture2D(colortex0,texCoord);

    vec3 normalViewCoord=texture2D(colortex2,texCoord).xyz;

    /*DRAWBUFFERS:0*/
	gl_FragData[0] = color;

}

#endif