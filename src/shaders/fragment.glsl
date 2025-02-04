export default /* glsl */`

uniform vec3 uColor;
varying float vDisplacement;


void main() {
  gl_FragColor = vec4(vec3(uColor * vDisplacement), 1.0);
}
`;