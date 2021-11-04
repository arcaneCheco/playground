uniform vec2 uMouse;
uniform float uTime;

varying vec2 vUv;

#define MAX_STEPS 40
#define E_SURF 0.001
#define MAX_DIST 45.
#define PI 3.14159265358979323846

float sdFloor(vec3 p, float offset) {
  offset += 0.4*(sin(.6*p.x) + sin(.8*p.z));
  return p.y - offset; 
}

float sdSphere(vec3 pos, float r) {
  return length(pos) - r;
}

float sdElipsoid(vec3 p, vec3 r) {
  float k0 = length(p/r) ;
  float k1 = length(p/r/r);
  return k0*(k0-1.)/k1;
}

float smin(float a, float b, float k) {
  float h = max(k - abs(a - b), 0.);
  return min(a,b) - h*h/(k*4.);
}

vec2 sdf(vec3 p) {
  // float sphere = sdSphere(p, 0.25);
  float guy = sdElipsoid(p-vec3(0., .6, 0.), vec3(0.25));
  vec2 res = vec2(guy, 2.);

  float floor = sdFloor(p, -0.25);
  if(floor<guy) res = vec2(floor, 1.);

  float n = 7.;
  for(float i=0.; i<n; i++) {
  float speed = 0.5 + 0.1*i;
  float r = 0.5*sin(uTime*speed+i*2.)+0.5;
  vec3 p_s = vec3(cos(uTime*speed + i * 2.*PI/n) * r, 0.6, sin(uTime*speed + i * 2.*PI/n) * r);
  float sphere = sdSphere(p - p_s, 0.001);
  if(sphere<res.x) res = vec2(sphere, 3.);
  res.x = smin(res.x, sphere, 0.22);
  } 
  return res;

  // return min(guy, floor); // min is basically a way to combine sd objects
}

vec3 calcNormal(vec3 p) {
  float eps = 0.0001;
  vec2 e = vec2(eps, 0.);
  float d = sdf(p).x;
  vec3 n = d - vec3(
                sdf(p - e.xyy).x,
                sdf(p - e.yxy).x,
                sdf(p - e.yyx).x
              );
  return normalize(n);
}

vec2 castRay(vec3 ro, vec3 rd) {
  float mat = -1.;
  float dO = 0.;
  for(int i=0; i<MAX_STEPS; i++) {

      vec3 p = ro + dO * rd;

      vec2 dS = sdf(p);
      mat = dS.y;

      if(dS.x < E_SURF) break;

      dO += dS.x;

      if(dO > MAX_DIST) break;

    }
    if (dO > MAX_DIST) mat = -1.;
    return vec2(dO, mat);
}

float castShadow(vec3 rayOrigin, vec3 rayDir) {
  float res = 1.;

  float t = 0.001;
  for( int i=0; i<100; i++) {
    vec3 pos = rayOrigin + t * rayDir;
    float h = sdf(pos).x;
    res = min(res, 16.*h/t);
    if(res<0.0001) break;
    t += h;
    if(t> 20.) break;
  }

  return clamp(res, 0.,1.);
}

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

void main() {

  vec2 nUv = vUv - vec2(0.5);

  // float angle = uMouse.x * 10.;
  float angle = 0.1 * uTime;
  vec3 target = vec3(0.0, .5, 0.0);
  vec3 ro = target + vec3(3. * sin(angle), 1., 3. * cos(angle));

  vec3 ww = normalize(target - ro);
  vec3 uu = normalize(cross(ww, vec3(0., 1., 0.)));
  vec3 vv = normalize(cross(uu, ww));
  vec3 rd = normalize(nUv.x*uu + nUv.y*vv + 1. * ww);

  vec3 col = vec3(0.4, 0.75, 1.) * 0.3 - 1.05 * rd.y;

  vec2 dO_m = castRay(ro, rd);

  float mat = dO_m.y;

  if(mat > 0.) {
    float dO = dO_m.x;
    vec3 p = ro + dO * rd;
    vec3 n = calcNormal(p);

    vec3 material = vec3(0.18);

    if(mat<1.5) { // floor
        material = normalize(vec3(0.25, 0.1, 0.02)) * .18 * 0.4;
    }
    else if(mat<2.5) {
        material = normalize(vec3(0.13, 0.16, 0.36)) * 0.18;

        float distortion = perlin3d(vec3(n + uTime * .2)) * 10.;
        p += distortion * n * rd;
        n = calcNormal(p);

        // float fresnel = pow(1. + dot(rd, n), 2.) / 4.;
        // col += fresnel;
      }
    else if(mat<3.5) {
        material = normalize(vec3(0.2, 0.1, 0.02)) * 0.18;
        float fresnel = pow(1. + dot(rd, n), 2.);
        col += fresnel;
    }

    vec3 sunDir = normalize(vec3(.6, 0.9, 0.4));
    float sunDiffusion = clamp(dot(n, sunDir), 0., 1.);
    float sunShadow = castShadow(p+n*0.001, sunDir);
    vec3 sunLight = material * vec3(7., 4.5, 3.) * sunDiffusion * sunShadow;

    col += sunLight;
    
  }

  gl_FragColor = vec4(col, 1.);

}