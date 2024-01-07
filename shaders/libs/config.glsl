#include "/libs/settings.glsl"
#include "/libs/uniforms.glsl"

#ifndef __CONFIG__
#define __CONFIG__

vec3 getTorchColor(){return vec3(TORCH_COLOR_R,TORCH_COLOR_G,TORCH_COLOR_B);}

vec3 getShadowColor(){return vec3(SHADOW_COLOR_R,SHADOW_COLOR_G,SHADOW_COLOR_B);}

#define COLOR_TIME_MIX(DAY,TWILIGHT,NIGHT) time>0?mix(TWILIGHT,NIGHT,time):mix(DAY,TWILIGHT,time+1);

#define TIME_SCALE_AND_OFFSET(SCALE,OFFSET) time=clamp(SCALE*time+OFFSET,-1,1);

#ifdef WORLD

vec3 getAmbientColor(float time){
    TIME_SCALE_AND_OFFSET(2.5,0.35);
    vec3 color=COLOR_TIME_MIX(vec3(AMBIENT_DAY_COLOR_R,AMBIENT_DAY_COLOR_G,AMBIENT_DAY_COLOR_B)
                ,vec3(AMBIENT_TWILIGHT_COLOR_R,AMBIENT_TWILIGHT_COLOR_G,AMBIENT_TWILIGHT_COLOR_B)
                ,vec3(AMBIENT_NIGHT_COLOR_R,AMBIENT_NIGHT_COLOR_G,AMBIENT_NIGHT_COLOR_B)
                );
    color=mix(color,
        mix(vec3(AMBIENT_DAY_RAIN_COLOR_R,AMBIENT_DAY_RAIN_COLOR_G,AMBIENT_DAY_RAIN_COLOR_B),
            vec3(AMBIENT_NIGHT_RAIN_COLOR_R,AMBIENT_NIGHT_RAIN_COLOR_G,AMBIENT_NIGHT_RAIN_COLOR_B),time*0.5+0.5),
        rainStrength);
    return color;
}

vec3 getSkyLightColor(float time){
    TIME_SCALE_AND_OFFSET(2,0);
    if(time>0)
        return vec3(MOON_LIGHT_COLOR_R,MOON_LIGHT_COLOR_G,MOON_LIGHT_COLOR_B)*(abs(moonPhase-4)/4.0);
    return mix(
        vec3(SUN_LIGHT_DAY_COLOR_R,SUN_LIGHT_DAY_COLOR_G,SUN_LIGHT_DAY_COLOR_B)
        ,vec3(SUN_LIGHT_TWILIGHT_COLOR_R,SUN_LIGHT_TWILIGHT_COLOR_G,SUN_LIGHT_TWILIGHT_COLOR_B),time+1);
}

vec3 getSkyUpColor(float time){
    TIME_SCALE_AND_OFFSET(2.5,0.35);
    vec3 color=COLOR_TIME_MIX(vec3(SKY_UP_DAY_COLOR_R,SKY_UP_DAY_COLOR_G,SKY_UP_DAY_COLOR_B)
                ,vec3(SKY_UP_TWILIGHT_COLOR_R,SKY_UP_TWILIGHT_COLOR_G,SKY_UP_TWILIGHT_COLOR_B)
                ,vec3(SKY_UP_NIGHT_COLOR_R,SKY_UP_NIGHT_COLOR_G,SKY_UP_NIGHT_COLOR_B)
                );
    color=mix(color,
        mix(vec3(SKY_UP_DAY_RAIN_COLOR_R,SKY_UP_DAY_RAIN_COLOR_G,SKY_UP_DAY_RAIN_COLOR_B),
            vec3(SKY_UP_NIGHT_RAIN_COLOR_R,SKY_UP_NIGHT_RAIN_COLOR_G,SKY_UP_NIGHT_RAIN_COLOR_B),time*0.5+0.5),
        rainStrength);
    return color;
}

vec3 getSkyDownColor(float time){
    TIME_SCALE_AND_OFFSET(2.5,0.35);
    vec3 color=COLOR_TIME_MIX(vec3(SKY_DOWN_DAY_COLOR_R,SKY_DOWN_DAY_COLOR_G,SKY_DOWN_DAY_COLOR_B)
                ,vec3(SKY_DOWN_TWILIGHT_COLOR_R,SKY_DOWN_TWILIGHT_COLOR_G,SKY_DOWN_TWILIGHT_COLOR_B)
                ,vec3(SKY_DOWN_NIGHT_COLOR_R,SKY_DOWN_NIGHT_COLOR_G,SKY_DOWN_NIGHT_COLOR_B)
                );
    color=mix(color,
        mix(vec3(SKY_DOWN_DAY_RAIN_COLOR_R,SKY_DOWN_DAY_RAIN_COLOR_G,SKY_DOWN_DAY_RAIN_COLOR_B),
            vec3(SKY_DOWN_NIGHT_RAIN_COLOR_R,SKY_DOWN_NIGHT_RAIN_COLOR_G,SKY_DOWN_NIGHT_RAIN_COLOR_B),time*0.5+0.5),
        rainStrength);
    return color;
}

vec3 getSunColor(float time){
    TIME_SCALE_AND_OFFSET(2.5,0.35);
    return COLOR_TIME_MIX(vec3(SUN_DAY_COLOR_R,SUN_DAY_COLOR_G,SUN_DAY_COLOR_B)
                ,vec3(SUN_TWILIGHT_COLOR_R,SUN_TWILIGHT_COLOR_G,SUN_TWILIGHT_COLOR_B)
                ,vec3(SUN_TWILIGHT_COLOR_R,SUN_TWILIGHT_COLOR_G,SUN_TWILIGHT_COLOR_B)
                );
}

vec3 getMoonColor(float time){
    return vec3(MOON_COLOR_R,MOON_COLOR_G,MOON_COLOR_B);
}

float getDistanceFogStart(){
    return mix(DISTANCE_FOG_START,DISTANCE_FOG_START_RAIN,rainStrength);
}

float getDistanceFogEnd(){
    return mix(DISTANCE_FOG_END,DISTANCE_FOG_END_RAIN,rainStrength);
}

#elif END

vec3 getAmbientColor(float time){
    return vec3(AMBIENT_END_COLOR_R,AMBIENT_END_COLOR_G,AMBIENT_END_COLOR_B);
}

vec3 getSkyLightColor(float time){
    return vec3(MOON_LIGHT_COLOR_R,MOON_LIGHT_COLOR_G,MOON_LIGHT_COLOR_B);
}

vec3 getSkyUpColor(float time){
    return vec3(0);
}

vec3 getSkyDownColor(float time){
    return vec3(0);
}

float getDistanceFogStart(){
    return DISTANCE_FOG_START;
}

float getDistanceFogEnd(){
    return DISTANCE_FOG_END_RAIN;
}

#elif NETHER 

vec3 getAmbientColor(float time){
    return vec3(AMBIENT_NETHER_COLOR_R,AMBIENT_NETHER_COLOR_G,AMBIENT_NETHER_COLOR_B);
}

vec3 getSkyLightColor(float time){
    return vec3(SUN_LIGHT_DAY_COLOR_R,SUN_LIGHT_DAY_COLOR_G,SUN_LIGHT_DAY_COLOR_B);
}

vec3 getSkyUpColor(float time){
    return vec3(0);
}

vec3 getSkyDownColor(float time){
    return vec3(0);
}

float getDistanceFogStart(){
    return DISTANCE_FOG_START;
}

float getDistanceFogEnd(){
    return DISTANCE_FOG_END_RAIN;
}

#endif

#endif