uniform float uTime;

varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;

float PI = 3.14159265359;

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

void main(){
  vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
  
  gl_Position = projectionMatrix * mvPosition;
  vUv = uv;
}