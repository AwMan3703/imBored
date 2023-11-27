package resources.shaders;

import flixel.system.FlxAssets.FlxShader;

class MonochromaticShader extends FlxShader{
    @:glFragmentSource('
        #pragma header

        vec4 desaturate(vec3 color)
        {
            float bw = (min(color.r, min(color.g, color.b)) + max(color.r, max(color.g, color.b))) * 0.5;
            return vec4(bw, bw, bw, 1.0);
        }

        void main() {
            vec4 ic = flixel_texture2D(bitmap, openfl_TextureCoordv);

            gl_FragmentColor = desaturate(ic.rgb);
        }

    ')
    public function new() {
        super();
    }
}