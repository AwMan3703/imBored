package levels;

import Math.max;
import Math.min;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.helpers.FlxRange;
import utility.Avatar;
import utility.Debug.visualizeColliders;

class Lv2Rock extends FlxSprite
{
	// utility
	final random:FlxRandom = new FlxRandom();

	// movement
	public var speed:Float;
	public var endY:Float;

	private var fallen:Bool;

	public function new()
	{
		super();
		y = Level_2.rocks_startY;
		immovable = true;
		this.speed = random.float(.2, .4);
		if (random.bool(Level_2.rocks_spawnNearPlayerChance)
			&& (Level_2.rocks_spawnZone.start < Level_2.player.x)
			&& (Level_2.player.x < Level_2.rocks_spawnZone.end))
		{
			x = random.float(max(Level_2.player.x - Level_2.rocks_spawnRange.x, Level_2.rocks_spawnZone.start),
				min(Level_2.player.x + Level_2.rocks_spawnRange.x, Level_2.rocks_spawnZone.end));
			this.endY = random.float(max(Level_2.player.y - Level_2.rocks_spawnRange.y, Level_2.rocks_endY.start),
				min(Level_2.player.y + Level_2.rocks_spawnRange.y, Level_2.rocks_endY.end));
		}
		else
		{
			x = random.float(Level_2.rocks_spawnZone.start, Level_2.rocks_spawnZone.end);
			this.endY = random.float(Level_2.rocks_endY.start, Level_2.rocks_endY.end);
		}
	}

	public function startFall(callback:Null<() -> Void>)
	{
		loadGraphic("assets/images/lv2/rock_" + new FlxRandom().int(1, 4) + ".png");
		if (random.bool())
			scale.x = -1;
		angle = random.float(-5, 5);

		FlxTween.linearMotion(this, x, y, x, endY, speed, true, {
			onComplete: function(_:FlxTween)
			{
				this.fallen = true;
				FlxG.camera.shake(.0005, .2, callback);
			},
			ease: FlxEase.cubeIn
		});
	}

	override public function update(elapsed:Float)
	{
		if (overlaps(Level_2.player))
		{
			if (fallen)
			{
				// Move the rock behind the player if its y is lower (is further away from foreground)
				// this can be done by changing its position in the Level_2.fallen_rocks.members array
				// (0 = background, [highest] = foreground)
				// TO BE CONTINUED LOL
				// Level_2.fallen_rocks.members.remove(this);
				// Level_2.fallen_rocks.members.insert(Level_2.fallen_rocks.members.length - 1, this);
			}
			else if (endY - y < Level_2.rock_killDistance && FlxG.collide(this, Level_2.player))
			{
				Level_2.player.kill();
				FlxG.switchState(new GameOverState(Level_2));
			}
		}
		super.update(elapsed);
	}
} // ciao <- Handri

class Lv2RockShadow extends FlxSprite
{
	private var speed:Float;

	public function new(rock:Lv2Rock)
	{
		super(rock.x, rock.endY);
		loadGraphic("assets/images/lv2/rock_shadow.png");
		scale.set(2, 2);
		alpha = 0;
		this.speed = rock.speed;
	}

	public function startAnimation(callback:(FlxTween) -> Void)
	{
		FlxTween.tween(this, {alpha: .3}, speed);
		FlxTween.tween(this.scale, {x: 1, y: 1}, speed, {
			onComplete: callback
		});
	}
}

class Level_2 extends Level
{
	// collider
	var levelColliders:Array<FlxRect> = [new FlxRect(50, 0, 312, 44)];

	// level sprites
	public static var player:Avatar;

	var background:FlxSprite;
	var ground:FlxSprite;
	var foreground:FlxSprite;

	var falling_rocks:FlxSpriteGroup;
	var rocks_shadows:FlxSpriteGroup;

	public static var fallen_rocks:FlxSpriteGroup;

	// level data
	public static final rocks_startY:Int = -55; // the y level at which the rocks start falling (off-screen)
	public static final rocks_endY:FlxRange<Int> = new FlxRange(-11, 31); // the highest/lowest y level at which the rocks end the fall (on platform)
	public static final rocks_spawnRange:FlxPoint = new FlxPoint(30, 7); // the x and y distance from the player at which rocks spawn more often
	// (e.g. FlxPoint(10, 5) : rocks spawn range is -10 to +10 horizontally and -5 to +5 vertically from the player)
	public static final rocks_spawnOnUpdateChance:Float = 2.5; // the chance that a rock will spawn upon an update() call
	public static final rocks_spawnNearPlayerChance:Float = 90; // the chance that a rock will spawn near the player
	public static final rocks_spawnZone:FlxRange<Int> = new FlxRange(80, 310); // the x range where rocks can spawn
	public static final rock_killDistance:Float = 20; // distance at which a falling rock kills the player on collision

	override public function create()
	{
		super.create();

		// rocks sprite group
		falling_rocks = new FlxSpriteGroup(0, 0);
		fallen_rocks = new FlxSpriteGroup(0, 0);
		rocks_shadows = new FlxSpriteGroup(0, 0);

		// ground sprite
		ground = new FlxSprite(0, 0);
		ground.loadGraphic("assets/images/lv2/platform.png");
		ground.immovable = true;

		// background sprite
		background = new FlxSprite(49, -48);
		background.loadGraphic("assets/images/lv2/background.png");
		background.immovable = true;

		// foreground sprite
		foreground = new FlxSprite(0, 32);
		foreground.loadGraphic("assets/images/lv2/foreground.png");
		foreground.immovable = true;

		// player sprite
		player = new Avatar(ground.x + 60, ground.y + 15);
		player.SPEED = 45;

		// add the sprites
		add(background);
		add(ground);
		add(rocks_shadows);
		add(player);
		add(falling_rocks);
		add(fallen_rocks);
		add(foreground);

		super.init(player, Level_3);
	}

	override public function update(elapsed:Float)
	{
		FlxG.collide(player, fallen_rocks);

		if (new FlxRandom().bool(Level_2.rocks_spawnOnUpdateChance))
			generateRock();

		player.updateMovement(elapsed, levelColliders);

		if (player.x > 360)
			switchToNextLevel();

		super.update(elapsed);
	}

	private function generateRock()
	{
		// initialize sprites
		var rock:Lv2Rock = new Lv2Rock();
		var rock_shadow:Lv2RockShadow = new Lv2RockShadow(rock);

		// add to respective groups
		falling_rocks.add(rock);
		rocks_shadows.add(rock_shadow);

		// start animations
		rock.startFall(function()
		{
			// add rock to fallen, so it will be used as an obstacle
			fallen_rocks.add(rock);
			// when fall is complete, remove from falling rocks as it can't kill the player anymore
			falling_rocks.remove(rock);
		});
		rock_shadow.startAnimation(null);
	}
}
