uniform float uTime;
uniform float uSize;
uniform float uProgressSpeed;
uniform float uPerlinFrequency;
uniform float uPerlinMultiplier;

attribute float aProgress;
attribute float aSize;
attribute float aAlpha;

varying float vAlpha;

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

void main() {
    float progress = mod(aProgress + uTime * uProgressSpeed, 1.);

    vec4 modelPosition = modelMatrix * vec4(position, 1.);
    modelPosition.y += progress * 10.;
    modelPosition.x += perlin3d((modelPosition.xyz + vec3(0.,uTime * 0.001,0.)) * uPerlinFrequency) * uPerlinMultiplier;

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    gl_PointSize = uSize * aSize;
    gl_PointSize *= 1. / -viewPosition.z;

    vAlpha = aAlpha;
}