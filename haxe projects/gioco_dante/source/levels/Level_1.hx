package levels;

import flixel.FlxSprite;
import flixel.math.FlxRect;
import utility.Avatar;
import utility.Debug.visualizeColliders;
import utility.Globals;

class Level_1 extends Level
{
	// collider
	var levelColliders:Array<FlxRect> = [new FlxRect(25, 0, 52, 25)];

	// level sprites
	var player:Avatar;
	var background:FlxSprite;
	var ground:FlxSprite;
	var foreground:FlxSprite;
	var water:FlxSprite;

	override public function create()
	{
		super.create();

		// ground sprite
		ground = new FlxSprite(0, 0);
		ground.loadGraphic("assets/images/lv1/platform.png");
		ground.immovable = true;

		// background sprite
		background = new FlxSprite(30, -11.72);
		background.loadGraphic("assets/images/lv1/background.png");
		background.immovable = true;

		// foreground sprite
		foreground = new FlxSprite(0, 28.45);
		foreground.loadGraphic("assets/images/lv1/foreground.png");
		foreground.immovable = true;

		// water sprite
		water = new FlxSprite(-45, 7.95);
		water.loadGraphic("assets/images/lv1/water.png", true, 153, 70);
		water.immovable = true;
		water.animation.add("waves", [0, 1], Globals.frameRate);

		// player sprite
		player = new Avatar(ground.x + 35, ground.y + 10);
		player.updateHitbox();

		// add the sprites
		add(ground);
		add(background);
		add(water);
		add(player);
		add(foreground);

		super.init(player, Level_2);
	}

	override public function update(elapsed:Float)
	{
		water.animation.play("waves");

		player.updateMovement(elapsed, levelColliders);

		if (player.x > 74)
			switchToNextLevel();

		super.update(elapsed);
	}
}
