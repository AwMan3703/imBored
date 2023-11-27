package levels;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.math.FlxRect;
import flixel.math.FlxVelocity;
import flixel.util.helpers.FlxRange;
import utility.Avatar;
import utility.Debug.visualizeColliders;
import utility.FSM;
import utility.Globals;

class Lv3Enemy extends FlxSprite
{
	private final random:FlxRandom = new FlxRandom();

	private final brain:FSM;
	private final texture_path:String;
	private final running_speed:Float = Globals.playerSpeed / 2;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		// get a new finite state machine for the brain
		brain = new FSM(sleep);

		// set texture path to a random texture (enemy_1 to enemy_3) and load the animation frames
		texture_path = "assets/images/lv3/enemy_" + random.int(1, 3) + ".png";
		loadGraphic(texture_path, true, 15, 15);

		// add the animations and play idle
		animation.add("idle", [0, 1], Globals.frameRate);
		animation.add("triggered", [2, 3], Globals.frameRate);
		animation.play("idle");

		// normalize the scale
		scale.set(.7, .7);
	}

	public function awake()
	{
		animation.play("triggered");
		brain.setState(chase);
		Level_3.awoken_enemies.add(this);
	}

	private function chase(elapsed:Float)
	{
		FlxVelocity.moveTowardsPoint(this, Level_3.player.getPosition(), running_speed);
	}

	private function sleep(elapsed:Float)
	{
		if (FlxG.collide(this, Level_3.player))
			awake();
	}

	override public function update(elapsed:Float)
	{
		brain.update(elapsed);
		super.update(elapsed);
	}
}

class Lv3Root extends FlxSprite
{
	private final random:FlxRandom = new FlxRandom();
	private final texture_path:String;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		texture_path = "assets/images/lv3/roots_" + random.int(1, 3) + ".png";
		if (random.bool())
			scale.x = -1;
		if (random.bool())
			scale.y = -1;
		loadGraphic(texture_path);
	}

	override public function update(elapsed:Float)
	{
		if (overlaps(Level_3.player))
			Level_3.wakeRandomEnemies();
		super.update(elapsed);
	}
}

class Level_3 extends Level
{
	// collider
	var levelColliders:Array<FlxRect> = [new FlxRect(55, 10, 145, 53)];

	// level sprites
	public static var awoken_enemies:FlxTypedGroup<Lv3Enemy> = new FlxTypedGroup<Lv3Enemy>();
	static var enemies:FlxTypedGroup<Lv3Enemy> = new FlxTypedGroup<Lv3Enemy>();
	static var roots:FlxTypedGroup<Lv3Root> = new FlxTypedGroup<Lv3Root>();

	var background:FlxSprite;
	var ground:FlxSprite;
	var foreground:FlxSprite;

	public static var player:Avatar;

	// level data
	public static final rootsArea:FlxRect = new FlxRect(65, 10, 135, 40);
	public static final enemiesArea:FlxRect = new FlxRect(150, 10, 20, 40);
	private static final rootsAmount:FlxRange<Int> = new FlxRange(9, 14);
	private static final enemiesAmount:FlxRange<Int> = new FlxRange(3, 5);

	// level utility
	private static final random:FlxRandom = new FlxRandom();

	override public function create()
	{
		super.create();

		// ground sprite
		ground = new FlxSprite(0, 0);
		ground.loadGraphic("assets/images/lv3/platform.png");
		ground.immovable = true;

		// background sprite
		background = new FlxSprite(70, -57);
		background.loadGraphic("assets/images/lv3/background.png");
		background.immovable = true;

		// foreground sprite
		foreground = new FlxSprite(63, -5);
		foreground.loadGraphic("assets/images/lv3/foreground.png");
		foreground.immovable = true;

		// player sprite
		player = new Avatar(ground.x + 56, ground.y + 40);
		player.offset.y = 10;

		// roots group
		spawnRoots();

		// enemies group
		spawnEnemies();

		// add the sprites
		add(background);
		add(ground);
		add(foreground);
		add(roots);
		add(enemies);
		add(player);

		super.init(player, Level_4);
	}

	private function spawnRoots():Void
	{
		final amount:Int = random.int(rootsAmount.start, rootsAmount.end);
		for (i in 0...amount)
		{
			final newRoot:Lv3Root = new Lv3Root(random.int(Std.int(rootsArea.left), Std.int(rootsArea.right)),
				random.int(Std.int(rootsArea.top), Std.int(rootsArea.bottom)));

			newRoot.immovable = true;

			roots.add(newRoot);
		}
	}

	private function spawnEnemies():Void
	{
		final amount:Int = random.int(enemiesAmount.start, enemiesAmount.end);
		for (i in 0...amount)
		{
			final newEnemy:Lv3Enemy = new Lv3Enemy(random.int(Std.int(enemiesArea.left), Std.int(enemiesArea.right)),
				Std.int(i * (enemiesArea.height / amount) + enemiesArea.top));

			newEnemy.immovable = true;

			enemies.add(newEnemy);
		}
	}

	public static function wakeRandomEnemies()
	{
		for (itEnemy in enemies)
		{
			if (random.bool())
				itEnemy.awake();
		};
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.collide(player, awoken_enemies))
		{
			player.kill();
			FlxG.switchState(new GameOverState(Level_3));
		}

		player.updateMovement(elapsed, levelColliders);

		if (player.x > 198)
			switchToNextLevel();

		super.update(elapsed);
	}
}
