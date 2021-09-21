varying vec3 vNormal;

uniform float uTime;
uniform float uSpeed;
uniform float uNoiseDensity;
uniform float uNoiseStrength;

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

void main() {
//   float t = uTime * uSpeed;
//   // You can also use classic perlin noise or simplex noise,
//   // I'm using its periodic variant out of curiosity
//   float distortion = perlin3d((normal + t), vec3(10.0) * uNoiseDensity) * uNoiseStrength;

//   // Disturb each vertex along the direction of its normal
//   vec3 pos = position + (normal * distortion);

//   vNormal = normal;

//   gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);


vec3 pos = position + sin(normal + uTime * 0.001) * 2. - cos(normal + uTime * 0.002) * 2.;

gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
vNormal = normal;
}