float saturation = (max(color.r,max(color.b,color.g)) - min(color.r,max(color.b,color.g))) / max(color.r,max(color.b,color.g));
saturation*=saturation;
float luma=GET_LUMA(color);
luma*=luma*luma;
material.y=clamp(luma*0.5+saturation,0,1)*color.a*0.5;