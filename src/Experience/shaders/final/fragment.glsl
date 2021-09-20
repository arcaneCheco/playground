uniform sampler2D tDiffuse;

varying vec2 vUv;

#pragma glslify: blur = require('glsl-fast-gaussian-blur/13') 

void main() {
    vec4 color = blur(tDiffuse, vUv, vec2(1920., 1080.), vec2(1.,0.));
    gl_FragColor = color;
}