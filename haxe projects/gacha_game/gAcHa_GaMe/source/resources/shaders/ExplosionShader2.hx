package resources.shaders;

import openfl.display.ShaderParameter;
import flixel.system.FlxAssets.FlxShader;

class ExplosionShader2 extends FlxShader{
    @:glFragmentSource('
        #pragma header
        
        uniform float u_time;
        uniform vec2 u_resolution;
        uniform float speed;
        
        float glow(float s1, float s2, vec2 p1, vec2 p2) {
            return (smoothstep(s1, s2, 1.-distance(p1, p2)));
        }
        
        float explosion(vec2 pos) {
            float a;
            //*radial flash
            a += glow(.1, .9, vec2(.5), pos);
            a += glow(.2, .9, vec2(.5), pos)/1.5;
        
            //*horizontal flash
            a += (smoothstep(.0, .9, 1.-distance(vec2(pos.x, .5), pos)*5.));
            a += (smoothstep(.0, .9, 1.-distance(vec2(pos.x, .5), pos)*9.))*2.;
        
            //*diagonal flash
            a += 1.-distance(vec2(.5), pos);
            a += (smoothstep(.2, .9, 1.-distance(vec2(pos.x), pos)*9.))*.5;
            a += (smoothstep(.2, .9, 1.-distance(vec2(pos.x), vec2(1.-pos.y))*6.))*.5;
            return a;
        }
        
        void main() {
            vec2 pos = gl_FragCoord.xy/u_resolution.xy;
            float alpha;
        
            alpha += 1.-sin(u_time*speed)*explosion(pos);
            alpha += 1.-sin(u_time-1.0*speed)*explosion(pos);
        
            //refinement
            //alpha += smoothstep(.1, 1.5, alpha)*.5;
            //alpha *= (alpha);
        
            vec3 color = vec3(1.0, 0.549, 0.0);
        
            gl_FragColor = vec4(color+(alpha/5.), (alpha));
        }
    ')

    public function new() {
        super();
        // transfer parameters to the @:glFragmentSource()
        this.u_time.value = [0.0];
        this.u_resolution.value = [860.0, 640.0];
        this.speed.value = [2.0];
    }
}