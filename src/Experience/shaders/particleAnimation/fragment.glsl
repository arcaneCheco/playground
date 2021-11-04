varying vec3 vPosition;
varying float vDistanceToCenter;
uniform float uTime;

void main() {
    float distanceToCenter = distance(gl_PointCoord, vec2(0.5));
    float strength = 0.1 / distanceToCenter - 0.2;
    vec3 col = (1. / abs(vDistanceToCenter)) * vPosition.yyy;
    float b = clamp(cos(uTime * 0.7), 0.3, 0.6);
    gl_FragColor = vec4(vec3(vPosition.yz * vec2(0.8) + vec2(sin(uTime* 0.2))* cos(uTime*0.3), b),strength);

    // float dist = length(gl_PointCoord - vec2(0.5));
    // float alpha = 1. - smoothstep(0.45, 0.5, dist);
    // gl_FragColor = vec4(vec3(1.), alpha);
}