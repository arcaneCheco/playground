uniform float uTime;
uniform sampler2D uMatcap;
uniform vec2 uMouse;
varying vec2 vUv;
varying vec3 vNormal;

mat4 rotationMatrix(vec3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat4(
		        oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
		        0.0,                                0.0,                                0.0,                                1.0
	);
}

vec3 rotate(vec3 v, vec3 axis, float angle) {
	mat4 m = rotationMatrix(axis, angle);
	return (m * vec4(v, 1.0)).xyz;
}

vec2 getMatcap(vec3 eye, vec3 normal) { // takes eye (or ray direction) and normal and returns uv's, from https://github.com/hughsk/matcap/blob/master/matcap.glsl
  vec3 reflected = reflect(eye, normal);
  float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
  return reflected.xy / m + 0.5;
}

float sdSphere(vec3 p, float r) {
    return length(p) -r;
}

float sdBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sdOctahedron( vec3 p, float s)
{
  p = abs(p);
  return (p.x+p.y+p.z-s)*0.57735027;
}

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

float sdBoxFrame( vec3 p, vec3 b, float e )
{
  p = abs(p  )-b;
  vec3 q = abs(p+e)-e;
  return min(min(
      length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
      length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
      length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}

// polynomial smooth min (k = 0.1); from https://www.iquilezles.org/www/articles/smin/smin.htm
float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

// exponential smooth min (k = 32);
float sminExp( float a, float b, float k )
{
    float res = exp2( -k*a ) + exp2( -k*b );
    return -log2( res )/k;
}

float sdf(vec3 p) { // signed-distance-function
    vec3 p1 = rotate(p, vec3(1.), uTime/2.);
    float box = sdBox(p1, vec3(0.3));
    float sphere = sdSphere(p, 0.4);
    float octahedron = sdOctahedron(p1, 0.4);
    float torus = sdTorus(p1, vec2(0.4, 0.1));
    float boxFrame = sdBoxFrame(p1, vec3(0.3), 0.01);
    float interactiveSphere = sdSphere(p - vec3(uMouse, 0.), 0.2);
    // return box;
    // return sphere;
    // return min(box, sphere);
    // return smin(box, sphere, 0.5);
    // return sminExp(box, interactiveSphere, 0.5);
    // return smin(box, interactiveSphere, 0.5);
    // return smin(octahedron, interactiveSphere, 0.8);
    // return smin(torus, interactiveSphere, 0.8);
    // return smin(boxFrame, interactiveSphere, 0.8);

    // create animation
    float progress = fract(uTime / 3.);
    float progSphere = sdSphere(p + vec3(1.) * progress, 0.1);
    float anim = smin(box, progSphere, 0.2);

    return smin(anim, interactiveSphere, 0.5);

}


vec3 calcNormal( in vec3 p )
{
    const float eps = 0.0001; // or some other value
    const vec2 h = vec2(eps,0);
    return normalize( vec3(sdf(p+h.xyy) - sdf(p-h.xyy),
                           sdf(p+h.yxy) - sdf(p-h.yxy),
                           sdf(p+h.yyx) - sdf(p-h.yyx) ) );
}


void main() {

    // background
    float dist = distance(vUv, vec2(0.5));
    vec3 bg = mix(vec3(0.), vec3(0.3), dist);


    vec3 cameraPos = vec3(0.,0.,2.);
    vec3 ray = normalize(vec3(vUv - vec2(0.5), -1)); // z should be negative because camera is in front
    vec3 rayPos = cameraPos;
    float stepSize = 0.;
    float maxDistance = 5.; // no objects will be placed further than 5
    for(int i=0;i<256;++i) {
        vec3 pos = cameraPos + stepSize * ray;
        float distanceToObject = sdf(pos);
        if(distanceToObject<0.0001 || distanceToObject>maxDistance) break;
        stepSize += distanceToObject;
    }

    vec3 color = bg;
    float fresnel = 0.;

    if(stepSize<maxDistance) { // condtion to check if ray hit something
        vec3 pos = cameraPos + stepSize * ray;

        // just black
        color = vec3(1.);

        // normal colors
        vec3 posNormal = calcNormal(pos);
        color = posNormal;

        // white with basic lighting
        float diff = dot(vec3(1.), posNormal); // do the lighting
        color = vec3(diff);

        // matcap
        vec2 matcapUv = getMatcap(ray, posNormal);
        color = texture2D(uMatcap, matcapUv).rbg;

        // mixed
        // color = mix(color, posNormal, 0.5);

        fresnel = pow(1. + dot(ray, posNormal), 3.);

        color = mix(color, bg, fresnel);
    }

    gl_FragColor = vec4(color, 1.);
    // gl_FragColor = vec4(fresnel);
}
