package resources.shaders;

import openfl.display.ShaderParameter;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;

class GradientSwapShader extends FlxShader{
    @:glFragmentSource('
        #pragma header

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
    ')

    public function new(new_gradient:String) {
        super();
        // transfer parameters to the @:glFragmentSource()
        this.u_time.value = [0.0];
        this.u_resolution.value = [860.0, 640.0];
        this.intensity.value = [1.0];
        this.gradient.input = BitmapData.fromFile(new_gradient);
    }
}