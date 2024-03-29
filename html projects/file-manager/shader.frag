precision mediump float;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float rawsalt;

//from "The Book of Shaders by Patricio Gonzalez Vivo & Jen Lowe"
//at https://thebookofshaders.com/edit.php#11/lava-lamp.frag
// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com
//
//--customised--

vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(((x*34.0)+1.0)*x); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0 / 41.0
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289(i); // Avoid truncation effects in permutation
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
        + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

void main() {
    float true_speed = 15.;
    float iTime = u_time/true_speed;

    float salt = rawsalt*1000.;

    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
    float zoom = .4;
    vec2 pos = vec2(st*zoom);

    float DF = 0.0;

    // Add a random position
    float a = 0.0;
    vec2 vel = vec2(iTime*.4);
    DF += snoise(pos-vel)*.25-.25;

    // Add a random position
    a = snoise(pos*vec2(cos(iTime*0.15),sin(iTime*0.1))*0.1)*3.1415;
    vel = vec2(cos(a),sin(a));
    DF += snoise(pos-pos/2.+vel)*.25-.25;

    float alpha = 0.0;
    //lava lamp
    //alpha += smoothstep(.7,.75,fract(DF));
    //water subsurface
    //alpha += smoothstep(.17,.975,.5*(fract(DF)));
    //weird
    alpha += smoothstep(.17,.975, mod(.8,fract(DF)));
    //weirder
    //alpha += smoothstep(.17,.975, mod(.8,fract(DF*2.)));

    //add mouse influence
    alpha-=(distance(gl_FragCoord.xy, u_mouse)*alpha)*.0005;

    vec3 reflex = vec3(0.7412, 0.3333, 0.0);
    vec3 color = vec3(1.0, 1.0, 1.0);

    gl_FragColor = vec4((reflex*alpha)+(color*alpha), alpha);
}