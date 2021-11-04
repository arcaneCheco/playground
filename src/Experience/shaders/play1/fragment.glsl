uniform float uTime;

uniform sampler2D uTexture;

varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;

// Referred to https://iquilezles.org/www/articles/palettes/palettes.htm
// Thank you so much.

vec3 pal( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d ) {
  return a + b*cos( 6.28318*(c*t+d) );
}

vec2 getMatcap(vec3 eye, vec3 normal) { // takes eye (or ray direction) and normal and returns uv's, from https://github.com/hughsk/matcap/blob/master/matcap.glsl
  vec3 reflected = reflect(eye, normal);
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
  return reflected.xy / m + 0.5;
}

void main () {

    // vec2 matUv = getMatcap(vec3(0.,0.,-.5), vNormal);


  vec4 color = texture2D(uTexture, vUv);
  
  float len = distance(vUv.xy, vec2(0.5));
  
  vec3 color2 =
    pal(
      len - uTime * 5.0,
      vec3(0.5,0.5,0.5),
      vec3(0.5,0.5,0.5),
      vec3(1.0,1.0,1.0),vec3(0.3,0.20,0.20)
    );
  
  color.r *= color2.r;
  color.g *= color2.g;
  color.b *= color2.b;


  
  gl_FragColor = vec4(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);
  gl_FragColor = vec4(color);
}