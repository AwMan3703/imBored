package utility;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

/**
 * Adds rectangle sprites to the `stage`, matching the provided colliders (`levelColliders`).
 * @param levelColliders An `Array<FlxRect>`, the list containing the colliders to visualize.
 * @param state The `FlxState` the sprites will be `add()`ed to.
 */
function visualizeColliders(levelColliders:Array<FlxRect>, state:FlxState)
{
	for (collider in levelColliders)
	{
		var s = new FlxSprite(collider.x, collider.y).makeGraphic(Std.int(collider.width), Std.int(collider.height), FlxColor.RED);
		s.alpha = .5;
		state.add(s);
	}
}
