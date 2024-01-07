#include "/libs/uniforms.glsl"

#ifndef __COLOR__
#define __COLOR__

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    vec3 hsv = vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    return hsv;
}

vec3 hsv2rgb(vec3 h){
    vec3 rgb = clamp(3.0*abs(1.0-2.0*fract(h.x+vec3(0.0,-1.0/3.0,1.0/3.0)))-1
            ,vec3(0),vec3(1)
        );
    return mix(vec3(1,1,1),rgb,h.y)*h.z;
}

void colorAdjust(inout vec4 color,vec3 hsvOffset){
    vec3 hsv=rgb2hsv(color.rgb);
    hsv+=hsvOffset;
    hsv.x=mod(hsv.x,1);
    hsv.y=clamp(hsv.y,0,1);
    hsv.z=clamp(hsv.z,0,1);
    color.rgb=hsv2rgb(hsv);
}

vec3 tonemap(vec3 x)
{
    float a = 2.51f;
    float b = 0.03f;
    float c = 2.43f;
    float d = 0.59f;
    float e = 0.14f;
    return clamp((x*(a*x+b))/(x*(c*x+d)+e),0,1);
}

#endif