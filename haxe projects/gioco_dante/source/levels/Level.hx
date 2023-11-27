package levels;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import utility.Globals;

class Level extends FlxState
{
	var nextLevel:Class<Level>;

	public function init(avatar:FlxSprite, nextLevel:Class<Level>)
	{
		this.nextLevel = nextLevel;
		FlxG.camera.follow(avatar, LOCKON, 0.5);
		FlxG.camera.zoom = Globals.cameraZoom;
		FlxG.camera.fade(FlxColor.BLACK, .5, true);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function switchToNextLevel()
	{
		FlxG.camera.fade(FlxColor.BLACK, .5, false, () ->
		{
			FlxG.switchState(Type.createInstance(nextLevel, []));
		});
	}
}
