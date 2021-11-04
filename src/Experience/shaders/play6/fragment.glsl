// uniform float uTime;
// uniform vec2 uMouse;

// varying vec2 vUv;

// #pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

// #define PI 3.14159265358979323846
// #define MAX_STEPS 100
// #define MAX_DIST 100.
// #define SURF_DIST 0.01

// float getDist(vec3 p) {
//   vec4 s = vec4(0., 1., 6., 1.);
//   float sphereDist = length(s.xyz - p) - s.w;
//   float planeDist = p.y;
//   float d = min(sphereDist, planeDist);
//   return d;
// }

// float RayMarch(vec3 ro, vec3 rd) {
//   float dO = 0.;
//   for(int i=0; i<MAX_STEPS; i++) {
//     vec3 p = ro + dO * rd;
//     float dS = getDist(p);
//     dO += dS;
//     if(dO > MAX_DIST || dO < SURF_DIST) break;
//   }
//   return dO;
// }

// vec3 getNormal(vec3 p) {
//   float d = getDist(p);
//   vec2 e = vec2(0.01, 0.);
//   vec3 n = d - vec3(
//                 getDist(p - e.xyy),
//                 getDist(p - e.yxy),
//                 getDist(p - e.yyx)
//                 );
//   return normalize(n);
// }

// float getLight(vec3 p) {
//   vec3 lightPos = vec3(0., 5., 6.);
//   lightPos.xz += vec2(cos(uTime), sin(uTime)) * 2.;
//   vec3 l = normalize(lightPos-p);
//   vec3 n = getNormal(p);
//   float diff = clamp(dot(n, l), 0., 1.);

//   // shadow
//   float d = RayMarch(p + n*SURF_DIST*2., l);
//   if(d<length(lightPos-p)) diff *= 0.1;
//   return diff;
// }

// void main () {

//   vec3 col = vec3(0.);

//   vec2 nUv = vUv-vec2(0.5);

//   //camera
//   vec3 ro = vec3(0.,1.,0.);
//   vec3 rd = normalize(vec3(nUv.x, nUv.y, 1.));

//   float d = RayMarch(ro,rd);

//   vec3 p = ro + d * rd;

//   float diff = getLight(p); 

//   // col += d/8.;
//   col += diff;

//   gl_FragColor = vec4(col, 1.);
// }






uniform float uTime;
uniform vec2 uMouse;

varying vec2 vUv;

#define MAX_STEPS 100
#define SURF_DIST 0.01
#define MAX_DIST 100.

float sd_sphere(vec3 p) {
  vec3 s = vec3(0., .5, 0.);
  float r = .5;
  return length(p-s) - r;
}

float sd_floor(vec3 p) {
  return p.y;
}

float sdf(vec3 p) {
  float d_sphere = sd_sphere(p);
  float d_floor = sd_floor(p);
  float d = min(d_sphere, d_floor);
  return d;
}

float rayMarch(vec3 ro, vec3 rd) {
  float dO = 0.;
  for(int i=0; i<MAX_STEPS; i++) {
    vec3 p = ro + dO * rd;
    float dS = sdf(p);
    dO += dS;
    if(dO > MAX_DIST || dO < SURF_DIST) break;
  }
  return dO;
}

vec3 normal(vec3 p) {
  vec2 e = vec2(0.01, 0.);
  float d = sdf(p);
  vec3 n = d - vec3(
                sdf(p - e.xyy),
                sdf(p - e.yxy),
                sdf(p - e.yyx)
              );
  return normalize(n);
}

float topLight(vec3 p) {
  vec3 lightPos = vec3(0., 3., 0.);
  lightPos.xz += vec2(cos(uTime), sin(uTime));
  vec3 l = normalize(lightPos - p);
  vec3 n = normal(p);
  float diff = clamp(dot(n, l), 0., 1.);
  float d = rayMarch(p + n * SURF_DIST*2., l);
  if(d < length(lightPos - p)) diff *= 0.1;
  return diff;
}

void main() {
  vec2 nUv = vUv - vec2(0.5);
  vec3 col = vec3(0.);

  vec3 ro = vec3(0., 1., 4.);
  vec3 rd = vec3(nUv.x, nUv.y, -1.);

  float d = rayMarch(ro, rd);

  vec3 p = ro + d * rd;

  float diff = topLight(p);

  col += diff;

  gl_FragColor = vec4(col,1.);
}