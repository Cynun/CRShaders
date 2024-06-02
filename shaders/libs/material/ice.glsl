material.x = 0.8;
material.w = 0;

float rand = 0.33 * noiseSample((absoluteWorldCoord.xy) / 128).x +
             0.33 * noiseSample((absoluteWorldCoord.xz) / 128).x +
             0.33 * noiseSample((absoluteWorldCoord.yz) / 128).x;
rand = 2 * (rand - 0.5);
normal.x += 0.05 * rand;
normal.y += 0.05 * rand;
normal.z += 0.05 * rand;
normal.xyz = normalize(normal.xyz);