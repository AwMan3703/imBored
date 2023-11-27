package utility;

import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup.FlxSpriteGroup;

class HUD extends FlxSpriteGroup
{
	private var hudCamera:FlxCamera;

	public function new(camera:FlxCamera)
	{
		super(0, 0);
		hudCamera = camera;
	}

	override function update(elapsed:Float)
	{
		x = hudCamera.scroll.x;
		y = hudCamera.scroll.y;
	}
}
