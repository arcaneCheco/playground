varying vec3 vNormal;
varying float vDistort;
uniform float uTime;

void main() {
    vec3 start = vec3(0.,0.,0.);
    vec3 end = vec3(1.,0.1, 0.3 + sin(uTime * 0.001) *0.4);
    vec3 finalColor = mix(start, end, vDistort);
    gl_FragColor = vec4(finalColor, 1.);
}


/*
*
BLOB STAGE
void main() {
    vec3 start = vec3(0.,0.,0.);
    vec3 end = vec3(1.,1.,sin(uTime * 0.0001));
    vec3 finalColor = mix(start, end, vNormal);
    gl_FragColor = vec4(vNormal*2., 1.);
}
*/