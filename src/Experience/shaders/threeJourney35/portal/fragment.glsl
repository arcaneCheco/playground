uniform float uTime;
uniform vec3 uStartColor;
uniform vec3 uEndColor;

varying vec2 vUv;

#pragma glslify: perlin3d = require('../../partials/perlin3d.glsl')

void main() {
    vec2 displacedUv = vUv + perlin3d(vec3(vUv * 5., uTime * 0.00025));
    float strength = perlin3d(vec3(displacedUv * 5., uTime * 0.0005));
    float outerGlow = distance(vUv, vec2(0.5)) * 5. - 1.4;
    strength += outerGlow;
    strength += step(-0.2,strength) * 0.8;
    strength = clamp(strength, 0.,1.);
    vec3 color = mix(uStartColor, uEndColor, strength);
    gl_FragColor = vec4(color, 1.);
}