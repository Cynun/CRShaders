#include "/libs/util/util.glsl"

#ifndef __REFLECTION__
#define __REFLECTION__

void drawReflect(inout vec4 color,vec3 screenCoord,vec4 viewCoord,vec3 normal,float metallic,float roughness){

    if(metallic == 0){
        return;
    }

    vec3 reflectVec=reflect(normalize(viewCoord.xyz),normal);
    
    const float stepBase = 0.05;
    vec3 testPoint = viewCoord.xyz+0.25*normal;
    vec3 reflectStep = reflectVec;
    reflectStep *= stepBase;
    bool hit = false;
    vec4 hitColor = vec4(0.0);

    for(int i = 0; i < 35; i++)
    {
        testPoint += reflectStep * pow(float(i + 1), 1.46);
        vec2 uv = getScreenCoordFromViewCoord(vec4(testPoint,1)).st;
        float sampleDepth = texture2D(depthtex1, uv, 0.0).x;
        sampleDepth = linearizeDepth(sampleDepth);
        float testDepth = getLinearDepthFormViewCoord(vec4(testPoint,1));
        if(sampleDepth < testDepth && testDepth - sampleDepth < (1.0 / 2048.0) * (1.0 + testDepth * 200.0 + float(i)))
        {
            hitColor.a = clamp(1.0 - pow(distance(uv, vec2(0.5))*2.0, 4), 0.0, 1.0);

            vec2 offset = vec2(0);
            if(roughness>0){
                offset.x = mod(uv.x,0.05*roughness) / (0.05*roughness);
                offset.y = mod(uv.y,aspectRatio*0.05*roughness) / (aspectRatio*0.05*roughness);
                uv.x = uv.x - mod(uv.x,0.05*roughness);
                uv.y = uv.y - mod(uv.y,aspectRatio*0.05*roughness);
            }
            vec3 lb = texture2D(colortex7, uv, 0.0).rgb;
            vec3 lt = texture2D(colortex7, uv + vec2(0,aspectRatio*0.05*roughness), 0.0).rgb;
            vec3 rb = texture2D(colortex7, uv + vec2(0.05*roughness,0), 0.0).rgb;
            vec3 rt = texture2D(colortex7, uv + vec2(0.05*roughness,aspectRatio*0.05*roughness), 0.0).rgb;

            hitColor.rgb = mix(mix(lb,rb,offset.x),mix(lt,rt,offset.x),offset.y);

            hit = true;
            break;
        }
        if(uv.x<0||uv.x>1||uv.y<0||uv.y>1){
            hit=true;
            break;
        }
    }
    if(!hit){
        vec2 uv = getScreenCoordFromViewCoord(vec4(testPoint,1)).st;
        float testDepth = getLinearDepthFormViewCoord(vec4(testPoint,1));
        float sampleDepth = texture2D(depthtex1, uv, 0.0).x;
        sampleDepth = linearizeDepth(sampleDepth);
        if(testDepth - sampleDepth < 0.5)
        {
            hitColor.a = clamp(1.0 - pow(distance(uv, vec2(0.5))*2.0, 4), 0.0, 1.0);

            vec2 offset = vec2(0);
            if(roughness>0){
                offset.x = mod(uv.x,0.05*roughness) / (0.05*roughness);
                offset.y = mod(uv.y,aspectRatio*0.05*roughness) / (aspectRatio*0.05*roughness);
                uv.x = uv.x - mod(uv.x,0.05*roughness);
                uv.y = uv.y - mod(uv.y,aspectRatio*0.05*roughness);
            }
            vec3 lb = texture2D(colortex7, uv, 0.0).rgb;
            vec3 lt = texture2D(colortex7, uv + vec2(0,aspectRatio*0.05*roughness), 0.0).rgb;
            vec3 rb = texture2D(colortex7, uv + vec2(0.05*roughness,0), 0.0).rgb;
            vec3 rt = texture2D(colortex7, uv + vec2(0.05*roughness,aspectRatio*0.05*roughness), 0.0).rgb;

            hitColor.rgb = mix(mix(lb,rb,offset.x),mix(lt,rt,offset.x),offset.y);

        }
    }

    float fresnel = 0.02 + 0.98 * pow(1.0 - dot(reflectVec, normal), 2.0);

    float hitColorLuma = GET_LUMA(hitColor);
    hitColorLuma*=hitColor.a;
    color.rgb = mix(color.rgb,hitColor.rgb,hitColor.a*metallic*fresnel); 
}

#endif