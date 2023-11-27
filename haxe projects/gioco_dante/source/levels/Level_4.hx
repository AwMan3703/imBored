package levels;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import haxe.Timer;
import utility.Avatar;
import utility.Debug.visualizeColliders;
import utility.Globals;

enum Lv4RunPhase
{
	BEFORE;
	RUNNING;
	AFTER;
}

class Lv4Runner extends FlxSprite
{
	private final random:FlxRandom = new FlxRandom();
	var speed:Float = -50;

	public function new(lane:Int)
	{
		super(Level_4.player.x + Level_4.enemies_spawnOffset, Level_4.lanes_Y[lane]);

		loadGraphic("assets/images/lv4/runner.png", true, 8, 11);
		if (random.bool()) // if runner comes from the back, correct graphics and movement
		{
			scale.x = -1;
			speed = 50 + Level_4.playerSpeed;
			x = Level_4.player.x - Level_4.enemies_spawnOffset;
		}
		animation.add("running", [1, 0, 2, 0], Globals.frameRate * 1.75);
		animation.play("running");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		velocity.x = speed;
		if (x <= Level_4.player_startX)
			this.kill();
	}
}

class Level_4 extends Level
{
	private static final random:FlxRandom = new FlxRandom();

	// collider
	var levelColliders:Array<FlxRect> = [new FlxRect(30, 5, 382, 28)];

	// level sprites
	var background:FlxSprite;
	var ground:FlxSprite;
	var foreground:FlxSprite;
	var runners:FlxTypedGroup<Lv4Runner> = new FlxTypedGroup<Lv4Runner>();

	public static var player:Avatar;
	public static final playerSpeed:Float = 45;

	// level data
	private static final spawnTimer:Timer = new Timer(580); // the timer to spawn enemies (delay in ms)
	public static final player_startX:Float = 50; // the X threshold at which the run begins and enemies despawn
	private static final player_endX:Float = 380; // the X threshold at which the run ends
	private static final lanes_length:Float = 120; // the length of each lane
	public static final enemies_spawnOffset:Float = 80; // the X distance from the player at which runners spawn
	public static final lanes_Y:Array<Float> = [-5, 12.5, 30]; // Y coordinates for the three lanes

	private var currentPhase:Lv4RunPhase = BEFORE;
	private var currentLane:Int = 0;

	override public function create()
	{
		super.create();

		spawnTimer.run = spawnRunner; // so that every X seconds a runner is spawned

		// ground sprite
		ground = new FlxSprite(0, 0);
		ground.loadGraphic("assets/images/lv4/platform.png");
		ground.immovable = true;

		// background sprite
		background = new FlxSprite(45, -57);
		background.loadGraphic("assets/images/lv4/background.png");
		background.immovable = true;

		// foreground sprite
		foreground = new FlxSprite(45, -3);
		foreground.loadGraphic("assets/images/lv4/foreground.png");
		foreground.immovable = true;

		// player sprite
		player = new Avatar(ground.x + 40, ground.y + 15);
		player.SPEED = playerSpeed;
		player.updateHitbox(); // reset the hitbox offset to center the player on the lane

		// add the sprites
		add(background);
		add(ground);
		add(foreground);
		add(runners);
		add(player);

		super.init(player, Level_5);
	}

	override public function update(elapsed:Float)
	{
		if (currentPhase == RUNNING)
		{
			// check if player is touching an enemy
			if (FlxG.collide(player, runners))
			{
				// game over
				player.kill();
				FlxG.switchState(new GameOverState(Level_4));
			}

			// move constantly to the right
			player.velocity.set(45);

			// lane switch logic
			if (FlxG.keys.justPressed.UP && currentLane > 0)
				currentLane -= 1;
			else if (FlxG.keys.justPressed.DOWN && currentLane < 2)
				currentLane += 1;

			// align player
			player.y = lanes_Y[currentLane];

			// check if run should end
			if (player.x >= player_endX)
				stopRun();
		}
		else
		{
			// movement logic
			player.updateMovement(elapsed, levelColliders);

			if (player.x > 410)
				switchToNextLevel();

			// check if run should start
			if (currentPhase == BEFORE && player.x >= player_startX)
				startRun();
		}
		super.update(elapsed);
	}

	private function startRun()
	{
		var newCoords:FlxPoint = new FlxPoint(player_startX, 0);
		if (player.y < lanes_Y[0])
		{
			currentLane = 0;
		}
		else if (player.y < lanes_Y[1])
		{
			currentLane = 1;
		}
		else
		{
			currentLane = 2;
		}
		newCoords.y = lanes_Y[currentLane];

		FlxTween.linearMotion(player, player.x, player.y, newCoords.x, newCoords.y, .5);

		player.animation.play("r_walk");

		currentPhase = RUNNING;
	}

	private function stopRun()
	{
		currentPhase = AFTER;
	}

	private function spawnRunner()
	{
		if (currentPhase == AFTER)
			return;
		var runner:Lv4Runner = new Lv4Runner(random.int(0, 2));
		runners.add(runner);
	}
}
