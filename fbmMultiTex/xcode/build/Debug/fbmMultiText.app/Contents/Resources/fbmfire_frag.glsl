#version 110

#ifdef GL_ES
precision mediump float;
#endif

#ifdef GL_ES
precision mediump int;
#endif


uniform float time;
uniform vec2 resolution;

uniform sampler2D iChannel0;

// by @301z


 float rand(vec2 n) {
	return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

// Function generates noise in pixel coordinates
float noise(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

// Fractional Brownian Amplitude. Collect several "layers" (octaves) of noise.
float fbm(vec2 n) { //if I implement this outside shader, it is called once per-frame vs. per-pixel
	float total = 0.0, amplitude = 1.0, gain = 0.5;
	for (int i = 0; i < 4; i++)
    {
		total += noise(n) * amplitude;
		n += n;
		amplitude *= gain;
	}
	return total;
}

void main() {
	// Colores
	const vec3 c1 = vec3(0.5, 0.5, 0.1); // Rojo oscuro.
	const vec3 c2 = vec3(0.9, 0.0, 0.0); // Rojo claro.
	const vec3 c3 = vec3(0.2, 0.0, 0.0); // Rojo oscuro.
	const vec3 c4 = vec3(1.0, 0.9, 0.0); // Amarillo.
	const vec3 c5 = vec3(0.1); // Gris oscuro.
	const vec3 c6 = vec3(0.9); // Gris claro.
	
	vec2 p = gl_FragCoord.xy * 8.0 / resolution.xx; // Offsets the coordinates so that there is more change of an outcome to neighboring
	
	float q = fbm(p - time); // noise offset for movement.
	
	//several layers of noise
	vec2 r = vec2( fbm(p + q + time * 0.7 - p.x - p.y), fbm(p + q - time * 0.4) ); //all movement stuff
	vec3 c = mix(c1, c2, fbm(p + r)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);
	gl_FragColor = vec4(c * cos(1.57 * gl_FragCoord.y / resolution.y), 1.0); //Gradient Most paneling above.
}