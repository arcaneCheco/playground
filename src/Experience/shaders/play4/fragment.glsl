uniform float uTime;
uniform vec2 uMouse;
uniform sampler2D uTexture;
uniform int uIterations;
uniform float uZoom;

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


#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

#define PI 3.14159265358979323846

void main () {

  vec2 newUv = vUv-vec2(0.5);
  newUv *= uZoom;

  vec3 col = vec3(0.);

  float angle = uMouse.x*PI;
  // float angle = 2./3.*PI;
  // angle += sin(uTime*0.1)*10.;
  newUv.x = abs(newUv.x);
  newUv.y += 0.5*tan(5./6.*PI); // upshift
  vec2 n = N(5./6.*PI);
  newUv -= n * max(0.,dot(newUv-vec2(0.5,0), n)) * 2.; 

  // newUv = rotate2D(newUv, uTime*PI*.1);

  // float t = smoothstep(0.1,0., fract(uTime));
  // n = N(t*2./3.*PI);

  n = N(abs(uMouse.y)*2./3.*PI);

  /*
  float d = dot(newUv, n);
  newUv -= n * min(0.,d) * 2.;
  col.rg += sin(newUv*10.);
  col += smoothstep(0.03, 0., abs(d));;
*/

  int it = 5;
  float scale = 1.;

  newUv.x += .5;

  for(int i=0; i<uIterations; i++) {
    newUv *= 3.;
    scale += 3.;
    newUv.x -= 1.5;

    newUv.x = abs(newUv.x);
    newUv.x -= 0.5;
    newUv -= n * min(0.,dot(newUv, n)) * 2.; // reflection code
  }

  float d = length(newUv - vec2(clamp(newUv.x, -1., 1.), 0.));

  // d += sin(uTime);

  col += smoothstep(0.1, 0., d/scale);
  // col += smoothstep(3./gl_FragCoord.y, 0., d/scale);

  newUv /= scale;
  vec3 tex = texture2D(uTexture, newUv).rgb;
  // vec3 tex = texture2D(uTexture, newUv - uTime* 0.03).rgb;
  // col.rg += newUv/scale;
  col += tex;
  

  gl_FragColor = vec4(col, 1.);
}