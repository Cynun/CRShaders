material.x=color.a;

if(isEyeInWater==1){
    normal=-normal;
}

float rand=noiseSample((absoluteWorldCoord.xz+0.1*frameTimeCounter)/32).x;
rand*=rand;

color=mix(color,vec4(1),
(0.2+0.8*rand)*clamp(1-(linearizeDepth(texture2D(depthtex1,screenCoord.st).x)-linearizeDepth(texture2D(depthtex0,screenCoord.st).x))*far,0,1)
);

