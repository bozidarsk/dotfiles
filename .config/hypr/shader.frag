precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

float luminance(vec3 color) { return dot(color, vec3(0.299, 0.587, 0.114)); }

void main() 
{
    vec3 color = texture2D(tex, v_texcoord).rgb;

    // color.b *= 0.8;

    gl_FragColor = vec4(color, 1.0);
}
