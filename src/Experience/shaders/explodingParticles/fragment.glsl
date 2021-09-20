uniform sampler2D uTexture;

varying vec2 vUv;

void main() {
    vec4 tt = texture2D(uTexture, vUv);
    gl_FragColor = tt;
    // gl_FragColor = vec4(1.,0.,0.,1.);
    if(tt.r < 0.1 && tt.g < 0.1 && tt.b < 0.1) discard; 
}
    
    
// vec2 newUv = vPosition.xy / vec2(120. * 1.5, 205. * 1.5) + vec2(0.5);