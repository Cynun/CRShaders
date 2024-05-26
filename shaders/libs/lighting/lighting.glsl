#include "/libs/config.glsl"
#include "/libs/util/util.glsl"
#include "/libs/color/color.glsl"

#ifndef __LIGHTING__
#define __LIGHTING__

void drawLight(inout vec4 color,vec4 colorSunCoord,float time,float luminous,vec3 lightMapValue,float shadowCoefficient0,float shadowCoefficient1){

    // Self-luminous
    lightMapValue.y=mix(lightMapValue.y,1,luminous);
    #ifndef WORLD
    if(lightMapValue.y<0.5){
        lightMapValue.y=0.4;
    }
    #endif
   
    // Draw ambient light
    // lightMapValue.x = clamp(pow((1.6*lightMapValue.x-0.65),3)+0.25,0,1);
    // lightMapValue.x = clamp(pow((1.5*lightMapValue.x-0.5),3)+0.1,0,1);
    // lightMapValue.x*=0.75;
    lightMapValue.x*=lightMapValue.x;
    color.rgb*=mix(getAmbientColor(time),vec3(1),lightMapValue.x);

    // Get setting
    vec3 skyLightColor=getSkyLightColor(time);
    vec3 torchColor=getTorchColor();
    vec3 shadowColor=getShadowColor();

    // Get light/shadow color
    float colorfulShadowCoefficient=shadowCoefficient0-shadowCoefficient1;

    float shadowLight=shadowCoefficient0;
    shadowLight=(shadowLight-0.5)*2;

    vec3 lightOrShadow=vec3(1);

    if(shadowLight>0){
        lightOrShadow=mix(vec3(1),shadowColor,shadowLight);
        lightOrShadow=mix(lightOrShadow,(1+skyLightColor*colorSunCoord.rgb),colorfulShadowCoefficient*(1-colorSunCoord.a));
    }
    else{
        lightOrShadow=mix(vec3(1),1+skyLightColor,(-shadowLight));
    }
    
    // Mix sky light/shadow and torch light
    #ifdef DRAW_LIGHT_IN_DARK_PLACE
    lightOrShadow=max(
        lightOrShadow*mix(1,clamp(0.3+lightMapValue.y,0,1),max(shadowCoefficient0,0.25*colorfulShadowCoefficient))
        ,(1+torchColor)*lightMapValue.x
        );
    #else
    lightOrShadow=max(lightOrShadow*clamp(0.3+lightMapValue.y,0,1),(1+torchColor)*lightMapValue.x);
    #endif

    // Draw light/shadow
    color.rgb*=lightOrShadow;

}

void drawVolumetricLight(inout vec4 color,vec3 screenCoord,vec3 lightViewCoord,float time){

    vec3 viewCoord=getViewCoord(screenCoord.xy,screenCoord.z).xyz;
    vec3 dirction=normalize(viewCoord);

    const float stepBase = 0.05;
    vec3 testPoint;
    dirction *= stepBase;

    float depth = linearizeDepth(texture2D(depthtex0,screenCoord.st).x);

    vec3 skyLightColor = getSkyLightColor(time);

    float lightColorLuma=GET_LUMA(skyLightColor)*clamp(abs(time*4),0,1);

    vec3 lightWorldCoord=3 * normalize(getWorldCoordFormViewCoord(vec4(lightViewCoord,1)).xyz);

    float lightStrength = 0;
    vec3 waterLightColor = vec3(0,0,0);
    vec3 lightColor = vec3(0,0,0);

    float lastTestPointDepth = 0;
    for(int i = 0; i < 34; i++)
    {
        float offset = (0.5+0.5*getNoise(1244.214*testPoint.xy+4352.134*testPoint.yz)) * pow(float(i + 1), 1.46);
        testPoint += dirction * offset;
        float testPointDepth = getLinearDepthFormViewCoord(vec4(testPoint,1));

        if(depth < testPointDepth){
            break;
        }

        vec4 testPointWorldCoord = getWorldCoordFormViewCoord(vec4(testPoint,1));

        vec4 testPointAbsoluteWorldCoord = testPointWorldCoord + vec4(cameraPosition,0);
        vec4 testPointSunScreenCoordNoFishEye = getSunScreenCoordNoFishEye(testPointAbsoluteWorldCoord);

        float rand=
            4.0/7*noiseSample(testPointSunScreenCoordNoFishEye.xy/4).x
            +2.0/7*noiseSample(testPointSunScreenCoordNoFishEye.xy/2).x
            +1.0/7*noiseSample(testPointSunScreenCoordNoFishEye.xy).x;

        vec4 testPointSunScreenCoord = getSunScreenCoord(testPointWorldCoord);

        float closetInSun0 = shadow2D(shadowtex0,testPointSunScreenCoord.xyz).x;
        float closetInSun1 = shadow2D(shadowtex1,testPointSunScreenCoord.xyz).x;

        if(testPointSunScreenCoord.z > closetInSun1){
            lightColor -= 0.05 * (testPointDepth - lastTestPointDepth);
        }
        else if(testPointSunScreenCoord.z > closetInSun0 && testPointSunScreenCoord.z < closetInSun1){
            vec4 blockColor=texture2D(shadowcolor0,testPointSunScreenCoord.xy);
            if(isEyeInWater == 1 && rand > 0.5){
                waterLightColor += rand * rand * blockColor.rgb * lightColorLuma*offset*(1-clamp(0.1*(testPointSunScreenCoord.z-closetInSun0),0,1));
            }
            else if(isEyeInWater != 1){
                lightColor += 3 * (1 - blockColor.a) * (testPointDepth - lastTestPointDepth) * blockColor.rgb * lightColorLuma;
            }
        }
        else{
            lightColor += (testPointDepth - lastTestPointDepth) * skyLightColor * lightColorLuma;
        }
        lastTestPointDepth = testPointDepth;
    }
    if(isEyeInWater==1){
        color.rgb += 0.01 * waterLightColor * (1 - 0.8 * rainStrength);
    }
    color.rgb += clamp(1 - 0.5 * vec3(length(normalize(viewCoord) - lightViewCoord)),1.25,1.50) *
                (1 + 2 * (1 - max(eyeBrightnessSmooth.x,eyeBrightnessSmooth.y) / 240.0)) * 
                lightColor * (1 - 0.8 * rainStrength);
}

#endif