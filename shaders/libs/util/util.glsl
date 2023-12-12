#include "/libs/uniforms.glsl"

vec2 miniMapping(vec2 texCoord,int row,int column,int subdivisions){
    float subdivisionsNumber=1/pow(2,subdivisions);
    return (texCoord+vec2(row,column))*subdivisionsNumber;
}