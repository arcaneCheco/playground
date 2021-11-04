uniform float uTime;
uniform vec2 uMouse;
uniform sampler2D uTexture;
uniform int uIterations;
uniform float uAmplitude;
uniform float uSpeed;
uniform float uSpeed2;
uniform float uGrid;
uniform float uRadSmall;
uniform float uRadBig;
uniform float uRotation;
uniform float uMod;

varying vec2 vUv;
varying vec3 vPosition;
varying vec3 vNormal;


float circle(in vec2 _uv, in float _radius){
    vec2 l = _uv-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*4.0);
}

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

float box(vec2 _st, vec2 _size, float _smoothEdges){
    _size = vec2(0.5)-_size*0.5;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_size,_size+aa,_st);
    uv *= smoothstep(_size,_size+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
}

float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

vec2 N(float angle) {
  return vec2(sin(angle), cos(angle));
}

float xOr(float a, float b) {
  return a*(1.-b) + b*(1.-a);
}


#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

#define PI 3.14159265358979323846

void main () {

  vec2 newUv = vUv-vec2(0.5);

  // float angle = uMouse.x*PI;
  // newUv += vec2(cos(angle), sin(angle))*distance(newUv, vec2(0.));

  newUv = rotate2D(newUv, uRotation*2.*PI);

  newUv *= uGrid;

  // newUv.x += fract(uTime);
  newUv.x += uTime * uSpeed2;


  vec2 uvF = fract(newUv) - 0.5;
  vec2 uvI = floor(newUv);
  vec3 col = vec3(0.);




  float m = 0.;

  float t = uTime*uSpeed;

  for (float x=-1.;x<=1.;x++) {
    for (float y=-1.;y<=1.;y++) {
      vec2 offset = vec2(x,y);
      float d = length(uvF-offset);
      // float dist = uAmplitude * length(uvI+offset);
      float dist = uAmplitude * length(uvF+offset);
      float func1 = sin(t+dist)*0.5+0.5; 
      float func2 = 0.5;
      float r = mix(uRadSmall,uRadBig,func1);
      m += smoothstep(r,r*0.87, d);
      // m = xOr(m, smoothstep(r,r*0.9, d));
    }
  }


  // col.rg += newUv;
  // col += m;
  col += mod(m, uMod);
  col *= normalize(vec3(1.,2.5,3.5))*1.;
  

  gl_FragColor = vec4(col, 1.);
}