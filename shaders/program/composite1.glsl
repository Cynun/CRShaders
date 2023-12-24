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
    
    //vec4 color = texture2D(colortex0, miniCoordToScreenCoord(texCoord,0,0,1));
    //color=mix(color,texture2D(colortex0, miniCoordToScreenCoord(texCoord,2,2,2)),0.5);

    vec4 color=texture2D(colortex0,texCoord);
	
    /*DRAWBUFFERS:0*/
	gl_FragData[0] = color;

}

#endif