#include "/libs/util/util.glsl"


void getNatureBloom(inout vec4 bloom,vec4 color){
    color*=0.5;
    float luma=GET_LUMA(color);
    luma*=luma*luma;
    bloom.rgb+=luma*bloom.rgb;
}

void getLighterBloom(inout vec4 bloom,vec4 color,float luminous){
    bloom.rgb+=luminous*color.rgb;
}

vec3 getFinalBloom(sampler2D src,vec2 target,vec2 texCoord){
    vec3 bloom;
    target*=vec2(1,aspectRatio);
    for(int i=0;i<5;i++){
        target+=target*getNoise(432.524*i+223.2332*(texCoord+target));
        bloom+=texture2D(src,clamp(texCoord+target,vec2(0),vec2(1))).rgb;
        bloom+=texture2D(src,clamp(texCoord-target,vec2(0),vec2(1))).rgb;
    }
    return bloom/10;
}

void firstPassBloom(inout vec4 bloom,vec2 texCoord){
    bloom.rgb+=getFinalBloom(colortex4,vec2(0.002,0),texCoord)*1.0/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0.003,0),texCoord)*0.5/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0.004,0),texCoord)*0.25/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0.006,0),texCoord)*0.175/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0.010,0),texCoord)*0.0875/2.2;
}

void secondPassBloom(inout vec4 bloom,vec2 texCoord){
    bloom.rgb+=getFinalBloom(colortex4,vec2(0,0.002),texCoord)*1.0/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0,0.003),texCoord)*0.5/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0,0.004),texCoord)*0.25/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0,0.006),texCoord)*0.175/2.2;
    bloom.rgb+=getFinalBloom(colortex4,vec2(0,0.010),texCoord)*0.0875/2.2;
}