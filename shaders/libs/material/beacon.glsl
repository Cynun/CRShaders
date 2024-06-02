float saturation = (max(color.r,max(color.b,color.g)) - min(color.r,max(color.b,color.g))) / max(color.r,max(color.b,color.g));
saturation*=saturation;
material.y=clamp(saturation,0,1)*color.a;