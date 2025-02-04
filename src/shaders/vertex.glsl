import cnoise from './noises/classicPerlinNoise.glsl';
import snoise from './noises/valueNoise.glsl';

export default /* glsl */`
${cnoise}
${snoise}


#define PI 3.14159265359

uniform float uTime;
uniform int uEffect;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vuV;
varying float vDisplacement;


float smoothMod(float axis, float amp, float rad) {
  float top = cos(PI * (axis / amp)) * sin(PI * (axis / amp));
  float bottom = pow(sin(PI * (axis / amp)), 2.0) + pow(rad, 2.0);
  float at = atan(top / bottom);
  return amp * (1.0 / 2.0) - (1.0 / PI) * at;
}

float fit(float unscaled, float originalMin, float originalMax, float newMin, float newMax) {
  return newMin + (newMax - newMin) * (unscaled - originalMin) / (originalMax - originalMin);
}

float wave(vec3 position) {
  return fit(smoothMod(position.y * 6.0, 1.0, 1.5), 0.35, 0.8, 0.0, 1.0);
}

void main() {
  vec3 coords = normal;
  coords.y += uTime;
  vec3 noisePatern;
  if (uEffect == 0)
    noisePatern = vec3(cnoise(coords));
  else if (uEffect == 1)
    noisePatern = vec3(snoise(coords));
  else
    noisePatern = vec3(cnoise(coords) + snoise(coords));
  float patern = wave(noisePatern);
	
	vPosition = position;
	vNormal = normal;
	vuV = uv;
	vDisplacement = patern;


	float displacement = vDisplacement * 0.3;
	
	vec3 newPostion = normal * displacement + position;
	vec4 modelViewPosition = viewMatrix * modelMatrix * vec4( newPostion, 1.0 );
	vec4 projectionPosition = projectionMatrix * modelViewPosition;
	gl_Position = projectionPosition;
}
`;
