package utility;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxVelocity;
import haxe.Timer;
import utility.Globals;

class Avatar extends FlxSprite
{
	/**
	 * The speed at which the player moves. Normal range is around 40-80
	 */
	public var SPEED:Float = Globals.playerSpeed;

	/**
	 * Wether `this` avatar is locked.
	 * A locked `Avatar` cannot move or play movement animations.
	 */
	public var LOCKED:Bool = false;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/avatar.png", true, 6, 12);
		animation.add("u_idle", [7]);
		animation.add("d_idle", [4]);
		animation.add("l_idle", [9]);
		animation.add("r_idle", [0]);
		animation.add("u_walk", [5, 6], Globals.frameRate);
		animation.add("d_walk", [2, 3], Globals.frameRate);
		animation.add("l_walk", [8, 9], Globals.frameRate);
		animation.add("r_walk", [0, 1], Globals.frameRate);
		animation.play("r_idle");
		height = 2;
		offset.y = 5;
	}

	override public function kill()
	{
		/*alive = false;
			exists = true; // keep true to mantain the corpse in the game */
		loadGraphic("assets/images/avatar_dead.png");
		Timer.delay(function() exists = false, 5000);
	}

	public function updateMovement(elapsed:Float, ?colliders:Array<FlxRect>, ?key_up:Bool, ?key_down:Bool, ?key_left:Bool, ?key_right:Bool)
	{
		if (LOCKED)
		{
			velocity.set(0, 0);
			updateMovementAnimation(0);
			return false;
		}

		if (key_up == null)
			key_up = FlxG.keys.anyPressed(Globals.controls_moveUp);
		if (key_down == null)
			key_down = FlxG.keys.anyPressed(Globals.controls_moveDown);
		if (key_left == null)
			key_left = FlxG.keys.anyPressed(Globals.controls_moveLeft);
		if (key_right == null)
			key_right = FlxG.keys.anyPressed(Globals.controls_moveRight);

		var frame_speed:Float = this.SPEED;
		var newAngle:Float = 0;

		// if any input is received, process it
		if (key_up || key_down || key_left || key_right)
		{
			newAngle = calculateInputs(key_up, key_down, key_left, key_right);
		}
		else
		{
			frame_speed = 0;
		}

		// determine our new position based on angle and speed
		final newPosition:FlxPoint = calculateNewCoords(elapsed, velocity);

		// check if the new position is legal (AKA is inside the collider, if provided)
		// if not, block the movement
		if (!solveCollider(newPosition, colliders))
		{
			frame_speed = 0;
			x = last.x;
			y = last.y;
		}

		// set velocity based on angle and speed
		velocity.setPolarDegrees(frame_speed, newAngle);

		updateMovementAnimation(frame_speed);
		return true;
	}

	private function calculateInputs(key_up:Bool, key_down:Bool, key_left:Bool, key_right:Bool)
	{
		var newAngle:Float = 0;
		if (key_up)
		{
			newAngle = -90;
			facing = UP;
			if (key_left)
			{
				newAngle -= 45;
				facing = LEFT;
			}
			else if (key_right)
			{
				newAngle += 45;
				facing = RIGHT;
			}
		}
		else if (key_down)
		{
			newAngle = 90;
			facing = DOWN;
			if (key_left)
			{
				newAngle += 45;
				facing = LEFT;
			}
			else if (key_right)
			{
				newAngle -= 45;
				facing = RIGHT;
			}
		}
		else if (key_left)
		{
			newAngle = 180;
			facing = LEFT;
		}
		else if (key_right)
		{
			newAngle = 0;
			facing = RIGHT;
		}

		return newAngle;
	}

	private function solveCollider(position:FlxPoint, colliders:Null<Array<FlxRect>>):Bool
	{
		// if the collider is null, automatically return true
		if (colliders == null)
			return true;

		// iterate through all the colliders, return wether the position is inside any of them
		for (collider in colliders)
		{
			if (collider.containsPoint(position)) // isInsideRect(position, collider))
			{
				return true;
			}
		}
		// if the position isn't in any collider, return false
		return false;
	}

	private function calculateNewCoords(elapsed:Float, currentVelocity:FlxPoint):FlxPoint
	{
		var velocityDelta:Float;
		var delta:Float;

		velocityDelta = 0.5 * (FlxVelocity.computeVelocity(velocity.x, acceleration.x, drag.x, maxVelocity.x, elapsed) - velocity.x);
		currentVelocity.x += velocityDelta;
		delta = currentVelocity.x * elapsed;
		currentVelocity.x += velocityDelta;
		var newX = x + delta;

		velocityDelta = 0.5 * (FlxVelocity.computeVelocity(velocity.y, acceleration.y, drag.y, maxVelocity.y, elapsed) - velocity.y);
		currentVelocity.y += velocityDelta;
		delta = currentVelocity.y * elapsed;
		currentVelocity.y += velocityDelta;
		var newY = y + delta;

		return new FlxPoint(newX, newY);
	}

	private function updateMovementAnimation(frame_speed:Float):Void
	{
		var action = "idle";

		// check if the player is moving, and not walking into walls
		if (frame_speed != 0) // velocity.x != 0 || velocity.y != 0)
		{
			action = "walk";
		}
		switch (facing)
		{
			case LEFT:
				animation.play("l_" + action);
			case RIGHT:
				animation.play("r_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}
	}
}
