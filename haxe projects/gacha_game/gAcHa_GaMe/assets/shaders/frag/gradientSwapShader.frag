#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform float intensity;
uniform sampler2D gradient;

void main() {
    vec4 oc = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;

    float lum = dot(oc.rgb, vec3(0.299, 0.587, 0.114));
    vec4 color = texture2D(gradient, vec2(lum));

    gl_FragColor = color;
}
