material.x=color.a;

if(isEyeInWater==1){
    normal=-normal;
}


float rand = 0.85 * noiseSample((absoluteWorldCoord.xz + vec2(-0.1*frameTimeCounter,0.1*frameTimeCounter)) / 128).x;
            + 0.15 * noiseSample((absoluteWorldCoord.xz + vec2(0.2*frameTimeCounter,-0.2*frameTimeCounter)) / 64).x;
rand = 2 * (rand - 0.5);
normal.x += 0.1 * rand;
normal.z += 0.1 * rand; 
normal.xyz = normalize(normal.xyz);

/*
color=mix(color,vec4(1),
(0.2+0.8*rand)*clamp(1-(linearizeDepth(texture2D(depthtex1,screenCoord.st).x)-linearizeDepth(texture2D(depthtex0,screenCoord.st).x))*far,0,1)
);
*/
