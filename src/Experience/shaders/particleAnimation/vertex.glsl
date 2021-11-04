// #pragma glslify: perlin3d = require('../partials/perlin3d.glsl')
uniform float uTime;
uniform float uSpeed;

varying vec3 vPosition;
varying float vDistanceToCenter;

void main() {

    vec4 modelPosition = modelMatrix * vec4(position, 1.);
    
    // Rotate
    // float angle = atan(modelPosition.x, modelPosition.z);
    // float distanceToCenter = length(modelPosition.xz);
    // float angleOffset = (1.0 / distanceToCenter) * uTime * 0.2 * uSpeed;
    // angle += angleOffset;
    // modelPosition.x += cos(angle);
    // modelPosition.z += sin(angle);

    vPosition = modelPosition.xyz;
    // vDistanceToCenter = distanceToCenter;

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;

    gl_PointSize = 20.;
    gl_PointSize *= 1. / -viewPosition.z;

    gl_Position = projectedPosition;


}