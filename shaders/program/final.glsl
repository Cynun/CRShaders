#include "/libs/uniforms.glsl"
#include "/libs/color/color.glsl"

#ifdef VSH

varying vec2 texCoord;

void main() {

	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

    gl_Position = ftransform();

}

#else

varying vec2 texCoord;

void main() {

    vec4 color = texture2D(colortex0,texCoord);

    /*
    vec3 hsv=rgb2hsv(color.rgb);
    hsv.y = 1 - pow((hsv.y-1),2);
    hsv.y = clamp(hsv.y,0,1);
    hsv.z = pow(hsv.z,1.2);
    hsv.z = clamp(hsv.z,0,1);
    color.rgb = hsv2rgb(hsv);
    color = clamp(color,vec4(0),vec4(1));
    */
    
    /*DRAWBUFFERS:0*/
	gl_FragData[0] = color;
    
}

#endif