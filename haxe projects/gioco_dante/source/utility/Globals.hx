package utility;

import flixel.input.keyboard.FlxKey;

class Globals
{
	// stats
	public static final cameraZoom:Float = 4;
	public static final frameRate:Float = 4;
	public static final playerSpeed:Float = 60;

	// controls
	public static final controls_moveUp:Array<FlxKey> = [UP, W];
	public static final controls_moveDown:Array<FlxKey> = [DOWN, S];
	public static final controls_moveLeft:Array<FlxKey> = [LEFT, A];
	public static final controls_moveRight:Array<FlxKey> = [RIGHT, D];
	public static final controls_interact:Array<FlxKey> = [X];
}
