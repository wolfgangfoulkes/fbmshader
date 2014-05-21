//just remember that the UV coordinates ( gl_TexCoord.uv, gl_TexCoord.st ..) are normalised, which means the value is always between 0 and 1

uniform sampler2D tex0;
uniform sampler2D tex1;

uniform vec2 resolution;
uniform vec2 scale; //for matching sizes if you wanted to do that

uniform float fTime;
uniform float fFloor; //doesn't like using the reserved keyword no more


void main()
{
    vec2 texCoordScaled = gl_TexCoord[0].st * scale;
    
    vec3 dry = texture2D(tex0, gl_TexCoord[0].st).rgb; //gl_TexCoord is 0 - 1
    vec3 dissolveMap = texture2D(tex1, texCoordScaled).rgb;
    
    float dist = distance(dissolveMap, vec3(0.0));
    
    if (dist <= fFloor)
    {
        discard;
    }
    
    gl_FragColor = vec4(dry, 1.0);
}