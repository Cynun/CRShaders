#include "/libs/uniforms.glsl"

#ifdef VSH

varying vec2 texCoord;

void main() {

	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

    gl_Position = ftransform();

}

#else

varying vec2 texCoord;

void main() {

    vec4 color=clamp(texture2D(colortex0,texCoord),vec4(0),vec4(1));
    
    /*DRAWBUFFERS:0*/
	gl_FragData[0] = color;
    
}

#endif