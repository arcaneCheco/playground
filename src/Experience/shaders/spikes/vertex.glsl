varying vec3 vNormal;
varying float vDistort;

uniform float uTime;
uniform float uSpeed;
uniform float uNoiseDensity;
uniform float uNoiseStrength;
uniform float uFrequency;
uniform float uAmplitude;

#pragma glslify: perlin3d = require('../partials/perlin3d.glsl')


mat3 rotation3dY(float angle) {
	float s = sin(angle);
	float c = cos(angle);

	return mat3(
		c, 0.0, -s,
		0.0, 1.0, 0.0,
		s, 0.0, c
	);
}

vec3 rotateY(vec3 v, float angle) {
	return rotation3dY(angle) * v;
}

void main() {


    // vec3 pos = position + sin(normal + uTime * 0.001) * 2. - cos(normal + uTime * 0.002) * 2.;

    float t = uTime * uSpeed * 0.001;

    float distortion = perlin3d(vec3(normal + t * 3.)) * uNoiseStrength;
    vec3 pos = position + (normal * distortion);

    float angle = sin(uv.y * uFrequency + t) * uAmplitude;
    pos = rotateY(pos, angle); 

    vNormal = normal;
    vDistort = distortion;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}


/**
BLOB STAGE
void main() {


    // vec3 pos = position + sin(normal + uTime * 0.001) * 2. - cos(normal + uTime * 0.002) * 2.;

    float t = uTime * uSpeed * 0.005;

    float distortion = perlin3d(vec3(normal + t * 3.)) * uNoiseStrength;
    distortion = step(abs(sin(t * 0.001))* 0.4, distortion) * (sin(t) + 2.) * uNoiseStrength;
    vec3 pos = position + (normal * distortion) ;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    vNormal = vec3(distortion);
}
*/