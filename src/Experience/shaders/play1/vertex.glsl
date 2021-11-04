uniform float uTime;

varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;

float PI = 3.14159265359;
// float scale = 0.1;

float scaling(float t, float delta, float a, float f) {
  return ((2.0 * a) / PI) * atan(sin(2.0 * PI * t * f) / delta);
}

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

void main(){
  vec3 pos = position;
  
//   pos.y += sin(pos.y * 0.01 - uTime * 10.0) * 2.0;
//   pos.z += sin(pos.y * 0.01 - uTime * 10.0) * 2.0;
  
  float dist = length(pos);
  float scale = scaling(uTime * 5.0 - dist * 0.01, 0.1, 1.0, 1.0 / 4.0) * 0.3; // + 1.0;
  
  pos *= scale;
  
//   vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0); 
  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
  
  vUv = uv;
  vPosition = position;
//   vPosition = pos;
vNormal = normal;
  
  gl_Position = projectionMatrix * mvPosition;
}