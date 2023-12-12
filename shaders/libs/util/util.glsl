#include "/libs/uniforms.glsl"

vec2 screenCoordToMiniCoord(vec2 texCoord,int row,int column,int divisions){
    float offset=1/pow(2,divisions);
    return (texCoord-offset*vec2(row,column))/offset;
}

vec2 miniCoordToScreenCoord(vec2 texCoord,int row,int column,int divisions){
    float offset=1/pow(2,divisions);
    return texCoord*offset+offset*vec2(row,column);
}

bool inScreen(vec2 texCoord){
    if(texCoord.x>=0&&texCoord.x<=1&&texCoord.y>=0&&texCoord.y<=1){
        return true;
    }
    return false;
}

#define CONVOLUTION_FUNCTION(SIZE) \
    int n=SIZE/2;\
    vec2 offset=vec2(radius)*vec2(1,aspectRatio)/SIZE;\
    float weightSum=0;\
    vec4 color=vec4(0);\
    for(int i=0;i<SIZE;i++){\
        for(int j=0;j<SIZE;j++){\
            float weight=core[i+j*SIZE];\
            weightSum+=weight;\
            color+=weight*texture2D(src,texCoord+offset*vec2(i,j));\
        }\
    }\
    if(normalized){\
        return color/weightSum;\
    }\
    return color;

vec4 convolution(sampler2D src,vec2 texCoord,float core[9],float radius,bool normalized){
    CONVOLUTION_FUNCTION(3)
}

vec4 convolution(sampler2D src,vec2 texCoord,float core[25],float radius,bool normalized){
    CONVOLUTION_FUNCTION(5)
}

vec4 convolution(sampler2D src,vec2 texCoord,float core[49],float radius,bool normalized){
    CONVOLUTION_FUNCTION(7)
}
