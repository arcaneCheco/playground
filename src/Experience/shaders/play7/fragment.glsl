uniform float uTime;
uniform vec2 uMouse;

varying vec2 vUv;

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

#define MAX_STEPS 100
#define SURF_DIST 0.01
#define MAX_DIST 100.

mat2 Rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

float sd_sphere(vec3 p) {
  vec3 s = vec3(0., .5, 0.);
  float r = .5;
  
  return length(p-s) - r;
}

float sd_floor(vec3 p) {
  return p.y;
}

float sd_capsule(vec3 p) {
  vec3 a = vec3(0., 3.5, 0.);
  vec3 b = vec3(0., 0.5, 0.);
  float r = 0.5;
  vec3 ab = b - a;
  vec3 ap = p - a;
  float t = dot(ab, ap) / dot(ab, ab);
  t = clamp(t, 0., 1.);
  vec3 c = a + t * ab;
  return length(p - c) - r;
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sdf(vec3 p) {
  float plane = sd_floor(p);
  // float s1 = sd_sphere(p-vec3(-0.5, 1., 0.));
  // float s2 = sd_sphere(p-vec3(0., 1., 0.5));
  // float sb = max(s1, s2);
  // float d = min(plane, sb);

  float s = sd_sphere(p -vec3(0., 1., 0.));
  float d = min(plane, s);
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
  vec3 lightPos = vec3(1., 2., 1.);
  // lightPos.xz += vec2(cos(uTime), sin(uTime))*3.;
  vec3 l = normalize(lightPos - p);
  vec3 n = normal(p);
  float diff = clamp(dot(n, l), 0., 1.);
  // float d = rayMarch(p + n * SURF_DIST*2., l);
  // if(d < length(lightPos - p)) diff *= 0.2;
  return diff;
}

vec3 R(vec2 uv, vec3 p, vec3 l, float z) {
    vec3 f = normalize(l-p),
        r = normalize(cross(vec3(0,1,0), f)),
        u = cross(f,r),
        c = p+f*z,
        i = c + uv.x*r + uv.y*u,
        d = normalize(i-p);
    return d;
}



void main() {
  vec2 nUv = vUv - vec2(0.5);
  vec3 col = vec3(0.);

  vec3 ro = vec3(0., 0., 0.);
  // ro += vec3(uMouse.x, 0., uMouse.y) * 5.;
  ro += vec3(0., 1., 4.);
  ro.yz *= Rot(-uMouse.y*3.14);
  ro.xz *= Rot(-uMouse.x*6.2831);
  // vec3 rd = vec3(nUv.x, nUv.y, -1.);
  vec3 rd = R(nUv, ro, vec3(0,1,0), 1.);

  float d = rayMarch(ro, rd);

  vec3 p = ro + d * rd;

  // float distortion = perlin3d(vec3(normal(p) + uTime * 1.)) * 1.;
  // distortion = clamp(distortion, -1., 1.);
  // p += distortion * normal(p);


  float diff = topLight(p);


  col += diff;

  col += 0.2;

  float fresnel = pow(1. + dot(ro, normal(p)), 3.);
  // fresnel = clamp(fresnel, 0., 1.);

  col = mix(col, vec3(0.2, 0.1, 0.3), fresnel);

  col = pow(col, vec3(.4545));


  gl_FragColor = vec4(col,1.);
}