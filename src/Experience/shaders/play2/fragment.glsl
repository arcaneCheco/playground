uniform float uTime;
uniform vec2 uMouse;
uniform sampler2D uTexture;

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

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')

#define PI 3.14159265358979323846

void main () {

  vec2 newUv = vUv * vec2(30., 30.);

  // newUv = rotate2D(newUv, uTime);

  vec2 iUv = floor(newUv);
  vec2 fUv = fract(newUv);

  // if(newUv.y<1.5) {
  //   fUv.x += uTime*0.1;
  // }

  float m_dist = 1.0;

  vec3 color = vec3(0.);
  // color += distance(vUv, vec2(0.5));

  vec2 m_point;

  for(int y=-1;y<=1;y++) {
    for(int x=-1;x<=1;x++) {
        vec2 neighbour = vec2(float(x), float(y));
        vec2 point = random2(iUv + neighbour);
        point = 0.5 + 0.5*sin(uTime*5. + 2.*PI*point);
        // point *= 0.5 + 0.5*cos(uTime);
        // point += clamp(-1.,1.,perlin3d(vec3(fUv, uTime)))*0.1;
        vec2 diff = point+neighbour-fUv;
        float dist = length(diff);
        // m_dist = min(m_dist, dist);

        if(dist<m_dist) {
          // m_dist = dist;
          m_point = point;
        }
        m_dist = smin(m_dist, dist, 0.7);


        // vec2 mouseP = uMouse*(iUv+neighbour);
        // dist = length(mouseP-fUv);
        // m_dist = min(m_dist, dist);
    }
  }

  
  // float dist = length(mouseP-fUv);
  // m_dist = min(m_dist, dist);

  color += m_dist;

  // color *= vec3(0.35,0.2,0.5) *m_dist*2.;

  color += 1. - step(0.005, m_dist);

  // color.r += step(0.99, fUv.x);
  // color.r += step(0.99, fUv.y);

  // color.rg += m_point;
  color = mix(vec3(m_point, pow(vUv.y, 4.)*2.), color, 0.9);
  // color.b += perlin3d(vec3(m_point, uTime*0.1));
  // color *= 0.5*vUv.y + (1.- fract(uTime));
  // color == mix(color, )


   color -= step(.3,abs(sin(13.0*m_dist)))*.05;

   vec3 tex = texture2D(uTexture, vUv).xyz;
  //  color = mix(color, tex, 0.5);



  gl_FragColor = vec4(color, 1.);
}