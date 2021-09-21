uniform float uPixelRatio;
uniform float uTime;
uniform float uSize;

attribute float aScale;

void main() {
    vec4 modelPosition = modelMatrix * vec4(position, 1.);
    modelPosition.y += sin(uTime * 0.001 + modelPosition.x * 100.) * aScale * 0.2;
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;
    gl_PointSize = uSize * aScale * uPixelRatio * (1. / -viewPosition.z);
}