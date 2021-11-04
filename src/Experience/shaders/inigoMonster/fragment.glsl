uniform float uTime;
uniform vec2 uMouse;
varying vec2 vUv;
varying vec3 vNormal;

float sdSphere(vec3 pos, float r) {
  return length(pos) - r;
}
float sdElipsoid(vec3 pos, vec3 r) {
  float k0 = length(pos/r) ;
  float k1 = length(pos/r/r);
  return k0*(k0-1.)/k1;
}
float sdFloor(vec3 pos, float offset) {
  offset += 0.1*(sin(2.*pos.x) + sin(2.*pos.z));
  return pos.y - offset; 
}

float smin(float a, float b, float k) {
  float h = max(k - abs(a - b), 0.);
  return min(a,b) - h*h/(k*4.);
}


vec2 sdGuy(vec3 pos, float r) { // return a vec2: the sd and the object/identiier which is needed to identify objects and apply right materials
  float t = 0.5; //fract(uTime);

  float y = 4. * t * (1. - t); // this is just an upside-down parabola between 0 and 1 on both x and y
  float dy = 4. - 8. * t; // tangent of the parabola

  vec2 u = normalize(vec2(1., -dy));
  vec2 v = vec2( dy, 1.);

  vec3 center = vec3(0., y, 0.);

  float sY = 0.5 + 0.5*y;
  float sZ = 1./sY;
  vec3 rad3 = vec3(r, r * sY, r * sZ);

  vec3 q = pos - center;

  // q.yz = vec2(dot(u,q.yz), dot(v,q.yz));
  
  float d =  sdElipsoid(q, rad3);

  vec3 h = q;

  // head
  float head = sdElipsoid(h - vec3(0., 0.28, 0.), vec3(0.2));
  float backHead = sdElipsoid(h - vec3(0., 0.28, -0.1), vec3(0.2));
  head = smin(head, backHead, 0.03);
  head = smin(d, head, 0.1);

  vec2 res = vec2(head, 2.);

  // eyes
  vec3 sh = vec3(abs(h.x), h.y, h.z); // since eyes are symmetric about x we only need one eye to model both eyes
  float eye = sdSphere(sh - vec3(0.08, 0.28, 0.16 ), 0.05);

  if(eye < head){ // if eyes are closest object
    res = vec2(eye, 3.);
  }

  d = min(head, eye);

  return res;
}

vec2 sdf(vec3 pos) { // tells us if a point is inside or outside a shape and how far from it, by convention, a distance of zero means exaclty the surface, if dist is negative we are inside the shape
  // float sphere = sdSphere(pos, 0.25);
  vec2 guy = sdGuy(pos, 0.25);
  float floor = sdFloor(pos, -0.25);

  return (floor<guy.x) ? vec2(floor, 1.) : guy;

  return min(guy, floor); // min is basically a way to combine sd objects
}

vec3 calcNormal( vec3 p )
{ // needed for lighting and stuff
    const float eps = 0.0001; // or some other value
    const vec2 h = vec2(eps,0);
    return normalize( vec3(sdf(p+h.xyy).x - sdf(p-h.xyy).x,
                           sdf(p+h.yxy).x - sdf(p-h.yxy).x,
                           sdf(p+h.yyx).x - sdf(p-h.yyx).x ) );
}

float castShadow(vec3 rayOrigin, vec3 rayDir) {
  float res = 1.;

  float t = 0.001;
  for( int i=0; i<100; i++) {
    vec3 pos = rayOrigin + t * rayDir;
    float h = sdf(pos).x;
    res = min(res, 16.*h/t);
    if(res<0.0001) break;
    t += h;
    if(t> 20.) break;
  }

  return clamp(res, 0.,1.);
}

vec2 castRay(vec3 rayOrigin, vec3 rayDir) {
  float mat = -1.;
  float t = 0.;
  for(int i=0; i<100; i++) {

      vec3 pos = rayOrigin + t * rayDir;

      vec2 h = sdf(pos);
      mat = h.y;

      if(h.x < 0.0001) break; // on the surface

      t += h.x ;

      if(t > 20.) break; // further than any object

    }
    if (t > 20.) mat = -1.;
    return vec2(t, mat);
}

void main() {
  vec2 newUv = vUv - vec2(0.5);

    // vec3 rayOrigin = vec3(0.,0.,2.); // or camera position
    // vec3 rayDir = vec3(vUv - vec2(0.5), -1);
    // rayDir = normalize(rayDir);

    // camera stuff
    // float angle = 0.4 * uTime;
    float angle = uMouse.x * 10.;
    // float angle = 0.;

    // vec3 targ = vec3(1. * sin(angle), 0., 1. * cos(angle)); // add time to this to move the target instead
    vec3 targ = vec3(0., 0.5, 0.);
    vec3 rayOrigin = targ + vec3(3. * sin(angle), 0., 3. * cos(angle));


    vec3 ww = normalize(targ - rayOrigin);
    vec3 uu = normalize(cross(ww, vec3(0., 1., 0.)));
    vec3 vv = normalize(cross(uu, ww));

    vec3 rayDir = normalize(newUv.x*uu + newUv.y*vv + 1.5 * ww); // the ww part is the camera length or fov

    // background
    vec3 color = vec3(0.4, 0.75, 1.) - 0.65 * rayDir.y;
    // add saturation to create horizon
    color = mix(color, vec3(0.4,0.75, 0.8), exp(-25. * rayDir.y));

    vec2 tmat = castRay(rayOrigin, rayDir);
    if(tmat.y > 0.) {
      float t = tmat.x;
      vec3 pos = rayOrigin + t * rayDir; // point in space where the intersection happened
      vec3 norm = calcNormal(pos);

      vec3 material = vec3(0.18); // like a base colour

      if(tmat.y<1.5) { // floor
        material = vec3(0.05, 0.1, 0.02);
        float f = smoothstep(-0.1,0.1,sin(18.*pos.x)*sin(18.*pos.z));
        material += f * 0.05;
      }
      // else if(tmat.y<2.5) { // guy
      //   material = vec3(0.2, 0.1, 0.02);
      // }
      // else if(tmat.y<3.5) { // eyes
      //   material = vec3(0.4, 0.4, 0.4);
      // }

      // lighting:, this is regular stuff for key lighitng, aas in aa strong directional light eg. the sun
      vec3 sunDir = normalize(vec3(1., 0.8, 0.6));
      float sunDiffusion = clamp(dot(norm, sunDir), 0., 1.);
      float sunShadow = castShadow(pos+norm*0.001, sunDir);
      vec3 sunLight = material * vec3(7., 4.5, 3.) * sunDiffusion * sunShadow;

      // sky lighting: the more it's facing up, the more sunlight its going to catch, the 0.5's in the dif just add some light to the bottom
      float skyDiffusion = clamp(0.5 + 0.5*dot(norm, vec3(0., 1., 0.)), 0., 1.);
      vec3 skyLight = material * vec3(0.5, 0.8, 0.9) * skyDiffusion;

      // adding sun and sky because the colours are complementary
      color = sunLight + skyLight;

      // bounce light to avoid completely black parts on shape
      float bounceDiffusion = clamp(0.5 + 0.5*dot(norm, vec3(0., -1., 0.)), 0., 1.);
      vec3 bounceLight = material * vec3(0.7, 0.3, 0.2) * bounceDiffusion;

      color += bounceLight;
    }

    color = pow(color, vec3(0.4545)); // conversion from physically correct lght to how your eyes would actually read colours in nature

    gl_FragColor = vec4(color, 1.);
}
