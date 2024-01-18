#include "/libs/util/util.glsl"
#include "/libs/config.glsl"

#ifndef __CLOUD__
#define __CLOUD__

#ifdef WORLD

#define CLOUD_BUTTOM 256
#define CLOUD_TOP 316

float cloudNoise(vec3 absoluteWorldCoord){
    float noise = 
        8.0/16.5*noiseSample((absoluteWorldCoord.xz+frameTimeCounter)/32768).x
        +4.0/16.5*noiseSample((-absoluteWorldCoord.zx+frameTimeCounter)/16384).x
        +1.0/16.5*noiseSample((absoluteWorldCoord.yx+frameTimeCounter)/4096).x
        +1.0/16.5*noiseSample((-absoluteWorldCoord.xz+frameTimeCounter)/4096).x
        +1.0/16.5*noiseSample((absoluteWorldCoord.yz+frameTimeCounter)/4096).x
        +0.5/16.5*noiseSample((-absoluteWorldCoord.xy+frameTimeCounter)/2048).x
        +0.5/16.5*noiseSample((absoluteWorldCoord.zx+frameTimeCounter)/2048).x
        +0.5/16.5*noiseSample((-absoluteWorldCoord.yz+frameTimeCounter)/2048).x;
    return noise*sqrt(
        cos((absoluteWorldCoord.y-0.5*(CLOUD_TOP+CLOUD_BUTTOM))*1.57/(0.5*(CLOUD_TOP-CLOUD_BUTTOM)))
        );
}

void drawCloud(inout vec4 color,vec3 screenCoord,vec3 lightViewCoord,float time){

    vec4 viewCoord=getViewCoord(screenCoord.xy,screenCoord.z);
    vec4 worldCoord=getWorldCoordFormViewCoord(viewCoord);
    float dis=length(worldCoord);
    vec4 absoluteWorldCoord=worldCoord+vec4(cameraPosition,0);

    vec3 dirction = normalize(worldCoord.xyz);

    vec3 startPoint;

    if(CLOUD_BUTTOM > cameraPosition.y){
        if(dirction.y<=0.01){
            return;
        }
        startPoint = cameraPosition.xyz+dirction*(CLOUD_BUTTOM-cameraPosition.y)/dirction.y;
    }
    else if(CLOUD_TOP < cameraPosition.y){
        if(dirction.y>=-0.01){
            return;
        }
        startPoint = cameraPosition.xyz+dirction*(CLOUD_TOP-cameraPosition.y)/dirction.y;
    }
    else{
        startPoint = cameraPosition.xyz;
    }

    vec4 cloudColor;

    const float stepBase = 0.05;
    vec3 testPoint = startPoint;
    dirction *= stepBase;

    float depth = linearizeDepth(texture2D(depthtex0,screenCoord.st).x);

    vec3 lightWorldCoord=3*normalize(getWorldCoordFormViewCoord(vec4(lightViewCoord,1)).xyz);
    for(int i = 0; i < 35; i++)
    {
        testPoint += dirction * (0.5+0.5*getNoise(1244.214*testPoint.xy+4352.134*testPoint.yz)) * pow(float(i + 1), 1.46);
        if(testPoint.y < CLOUD_BUTTOM || CLOUD_TOP < testPoint.y){
            break;
        }
        vec4 testPointViewCoord = getViewCoordFromWorldCoord(vec4(testPoint-cameraPosition,1));
        float testPointDepth = getLinearDepthFormViewCoord(testPointViewCoord);

        if(depth < testPointDepth){
            break;
        }

        float noise=(cloudNoise(testPoint)+cloudNoise(testPoint-dirction))/2;
        
        float cloudDensity=1-(mix(0.9+0.1*sin(frameTimeCounter/100),1,rainStrength)*getCloudDensity());

        if(noise>cloudDensity){
            cloudColor.rgb=getSkyDownColor(time);
            cloudColor.a=1;
            float lightStrength=1;
            for(int i = 0;i<5;i++){
                testPoint+=lightWorldCoord;
                if(cloudNoise(testPoint)>cloudDensity+0.02){
                    lightStrength-=0.2;
                }
            }
            cloudColor.rgb+=getCloudLightColor(time)*lightStrength;
            cloudColor.rgb=clamp(cloudColor.rgb,vec3(0),vec3(1));
            break;
        }
    }

    color.rgb=mix(color.rgb,cloudColor.rgb,clamp(cloudColor.a,0,1));


}

#endif

#endif