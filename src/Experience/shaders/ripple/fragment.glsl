uniform float uTime;
uniform vec2 uResolution;
uniform sampler2D uTexture;
uniform float uFrequency;
uniform float uSpeed;
uniform float uAmplitude;
varying vec2 vUv;

void main() {
    vec2 cPos = -1.0 + 2.0 * vUv;
    float cLength = length(cPos);

    vec2 uv = (cPos/cLength)*cos(cLength * uFrequency - uTime*  uSpeed)*uAmplitude;
    vec3 col = texture2D(uTexture,uv).xyz;
    gl_FragColor = vec4(col,.1);
}
