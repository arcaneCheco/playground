const shader = `
uniform vec3 uColor;
uniform sampler2D uMap;
varying vec2 vUv;

float median(float r, float g, float b) {
  return max(min(r, g), min(max(r, g), b));
}

void main() {

  // fill
  vec3 mySample = texture2D(uMap, vUv).rgb;
  float sigDist = median(mySample.r, mySample.g, mySample.b) - 0.5;
  float fill = clamp(sigDist/fwidth(sigDist) + 0.5, 0.0, 1.0);

  gl_FragColor = vec4(uColor.xyz, fill);
  if (gl_FragColor.a < 0.001) discard;
}`;

export default shader;
