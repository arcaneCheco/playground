varying vec2 vUv;
varying vec3 vNormal;

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

    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    vUv = uv;
    vNormal = normal;
}