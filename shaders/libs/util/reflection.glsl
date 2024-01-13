#include "/libs/util/util.glsl"

#ifndef __REFLECTION__
#define __REFLECTION__

void drawReflect(inout vec4 color,vec3 screenCoord,vec4 viewCoord,vec3 normal,float reflectionStrength){
    if(reflectionStrength<0.1){
        return;
    }

    vec3 reflectVec=reflect(normalize(viewCoord.xyz),normal);
    
    const float stepBase = 0.05;
    vec3 testPoint = viewCoord.xyz+0.1*normal;
    vec3 reflectStep = reflectVec;
    reflectStep *= stepBase;
    bool hit = false;
    vec4 hitColor = vec4(0.0);
    for(int i = 0; i < 35; i++)
    {
        testPoint += reflectStep * pow(float(i + 1), 1.46);
        vec2 uv = getScreenCoordFromViewCoord(vec4(testPoint,1)).st;
        float sampleDepth = texture2D(depthtex0, uv, 0.0).x;
        sampleDepth = linearizeDepth(sampleDepth);
        float testDepth = getLinearDepthFormViewCoord(vec4(testPoint,1));
        if(sampleDepth < testDepth && testDepth - sampleDepth < (1.0 / 2048.0) * (1.0 + testDepth * 200.0 + float(i)))
        {
            hitColor = vec4(texture2D(colortex7, uv, 0.0).rgb, 1.0);
            hitColor.a = clamp(1.0 - pow(distance(uv, vec2(0.5))*2.0, 4), 0.0, 1.0);
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
        float sampleDepth = texture2D(depthtex0, uv, 0.0).x;
        sampleDepth = linearizeDepth(sampleDepth);
        if(testDepth - sampleDepth < 0.5)
        {
            hitColor = vec4(texture2D(colortex7, uv, 0.0).rgb, 1.0);
            hitColor.a = clamp(1.0 - pow(distance(uv, vec2(0.5))*2.0, 4), 0.0, 1.0);
        }
    }

    float fresnel = 0.02 + 0.98 * pow(1.0 - dot(reflectVec, normal), 2.0);

    color.rgb=mix(color.rgb,hitColor.rgb,hitColor.a*reflectionStrength*fresnel);
    
}

#endif