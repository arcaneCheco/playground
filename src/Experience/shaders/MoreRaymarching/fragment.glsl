varying vec2 vUv;
varying vec3 vNormal;

float sdf(vec3 pos) { // tells us if a point is inside or outside a shape and how far from it, by convention, a distance of zero means exaclty the surface, if dist is negative we are inside the shape
  float dist = length(pos) - 0.3;

  return dist;
}

vec3 calcNormal( vec3 p )
{ // needed for lighting and stuff
    const float eps = 0.0001; // or some other value
    const vec2 h = vec2(eps,0);
    return normalize( vec3(sdf(p+h.xyy) - sdf(p-h.xyy),
                           sdf(p+h.yxy) - sdf(p-h.yxy),
                           sdf(p+h.yyx) - sdf(p-h.yyx) ) );
}

void main() {

    vec3 rayOrigin = vec3(0.,0.,2.); // or camera position
    vec3 rayDir = vec3(vUv - vec2(0.5), -1);
    rayDir = normalize(rayDir);

    vec3 color = vec3(0.);

    float t = 0.;

    for(int i=0; i<100; i++) {
      vec3 pos = rayOrigin + t * rayDir;

      float h = sdf(pos);

      if(h< 0.0001) break;

      t += h;

      if(t >20.) break;
    }

    if(t<20.) {
      vec3 pos = rayOrigin + t * rayDir; // point in space where the intersection happened
      vec3 norm = calcNormal(pos);

      // lighting:, this is regular stuff for key lighitng, aas in aa strong directional light eg. the sun
      vec3 sunDir = normalize(vec3(0.8, 0.4, 0.2));
      float sunDiffusion = clamp(dot(norm, sunDir), 0., 1.);
      vec3 sunLight = vec3(1., 0.7, 0.5) * sunDiffusion;

      // sky lighting: the more it's facing up, the more sunlight its going to catch, the 0.5's in the dif just add some light to the bottom
      float skyDiffusion = clamp(0.5 + 0.5*dot(norm, vec3(0., 1., 0.)), 0., 1.);
      vec3 skyLight = vec3(0., 0.1, 0.3) * skyDiffusion;

      // adding sun and sky because the colours are complementary
      color = sunLight + skyLight;
    }

    gl_FragColor = vec4(color, 1.);
}
