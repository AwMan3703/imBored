package;

import flixel.FlxGame;
import flixel.system.FlxAssets;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		// Game setup
		// FlxAssets.FONT_DEFAULT = "Montserrat";

		// Start
		addChild(new FlxGame(0, 0, MenuState));
	}
}
