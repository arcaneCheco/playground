uniform float uTime;
uniform float uDistortionMultiplier;
uniform float uDistortionWidth;
uniform float uDistortionHeight;
uniform float uDistortionDepth;
uniform float uNoiseX;
uniform float uNoiseY;
uniform float uFrequency;

varying vec2 vUv;

#pragma glslify: curlNoise = require('../partials/curl3d.glsl')

void main() {
    vec4 modelPosition = modelMatrix * vec4(position, 1.);

    vec3 distortion = 
        vec3(position.x * uDistortionWidth, position.y * uDistortionHeight, uDistortionDepth) * 
        curlNoise(
        vec3(
            position.x * uNoiseX + uTime * uFrequency, 
            position.y * uNoiseY + uTime * uFrequency, 
            (position.x + position.y) * 0.01 // this could just be a random func to experiment with
        )) * 
        uDistortionMultiplier;

    vec3 finalPosition = position + distortion;

    vec4 viewPosition = viewMatrix * vec4(finalPosition, 1.);
    vec4 projectedPosition = projectionMatrix * viewPosition;
    // gl_PointSize = 20. * (1. / -viewPosition.z);
    gl_PointSize = 2.;
    gl_Position = projectedPosition;
    vUv = uv;
}