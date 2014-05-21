#version 110

#ifdef GL_ES
precision mediump float;
#endif

#ifdef GL_ES
precision mediump int;
#endif

//fbm function yanked from http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2012/10/Tatarchuk-Noise(GDC07-D3D_Day).pdf

uniform float time;
uniform vec2 resolution;

uniform int octaves;
uniform float lacunarity;
uniform float gain;

float rand(vec2 n) {
	return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n);
    vec2 f = smoothstep( vec2(0.0), vec2(1.0), fract(n) );
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fBm( vec2 vInputCoords, int nNumOctaves, float fLacunarity, float fGain ) //typically Lac = 2, gain = .5
//was originally vec3 for vInput
{
    float fNoiseSum = 0.0;
    float fAmplitude = 1.0;
    float fAmplitudeSum = 0.0;
    vec2 vSampleCoords = vInputCoords;
    
    for ( int i = 0; i < nNumOctaves; i++ )
    {
        fNoiseSum += fAmplitude * noise( vSampleCoords );
        fAmplitudeSum += fAmplitude;
        fAmplitude *= fGain;
        vSampleCoords *= fLacunarity;
        //Lacunarity is frequency (density) change between each band
        //if fractal is dense, lacunarity is small
        //lacunarity increases with coarseness
    }
    
    fNoiseSum /= fAmplitudeSum;
    return fNoiseSum;
}

void main()
{
    const vec3 c1 = vec3(0.5, 0.5, 0.1); // Rojo oscuro.
	const vec3 c2 = vec3(0.9, 0.0, 0.0);
    
    vec2 position = gl_FragCoord.xy / resolution.xy;
    
    gl_FragColor = vec4(vec3(fBm(position + time, 8, 4.0, 0.25)), 1.0);
}