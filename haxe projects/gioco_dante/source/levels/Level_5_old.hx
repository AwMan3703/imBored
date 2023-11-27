package levels;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import haxe.Timer;
import utility.Avatar;
import utility.Globals;
import utility.HUD;

class Lv5Food extends FlxSprite
{
	var associatedDoor:Lv5Door;
	var foodName:String;

	public function new(name:Null<String>)
	{
		super();
		if (name == null)
			return;
		loadGraphic("assets/images/lv5/food_" + name + ".png");
		centerOrigin();
	}
}

class Lv5Door extends FlxSprite
{
	public var contained:Lv5Food = new Lv5Food(null); // the food behind this door (if present)

	private static final texture_path:String = "assets/images/lv5/door_";

	public var status:String = "closed";
	public var highlight:Bool = false;

	public function new(x_index:Int)
	{
		super(Level_5.doors_positions[x_index], Level_5.doors_y);
		updateGraphic();
		centerOrigin();
	}

	private function updateGraphic()
	{
		loadGraphic(texture_path + status + ".png");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxCollision.pixelPerfectCheck(this, Level_5.player))
		{
			if (!highlight)
			{
				highlight = true;
				loadGraphic(texture_path + status + "_hover.png");
			}
			if (FlxG.keys.justPressed.X)
			{
				if (status == "closed")
					open();
				else
					close();
			}
		}
		else if (highlight)
		{
			highlight = false;
			loadGraphic(texture_path + status + ".png");
		}
	}

	public function open()
	{
		highlight = false;
		status = "open";
		contained.visible = true;
		updateGraphic();
	}

	public function close()
	{
		highlight = false;
		status = "closed";
		contained.visible = false;
		updateGraphic();
	}

	public function insertFood(callback:() -> Void)
	{
		contained.visible = true;
		open();
		FlxTween.linearMotion(contained, x, Level_5.foods_y, x, y, 2, true, {
			ease: FlxEase.cubeInOut,
			onComplete: (_:FlxTween) ->
			{
				contained.visible = false;
				close();
				callback();
			},
			type: ONESHOT
		});
	}
}

class Level_5 extends Level
{
	// collider
	var levelColliders:Array<FlxRect> = [new FlxRect(0, 75, 110, 115), new FlxRect(32, 190, 48, 50)];

	// level sprites
	var ground:FlxSprite;
	var doors:FlxTypedGroup<Lv5Door>;
	var food:Lv5Food;
	var tooltip:FlxText;
	var foreground_L:FlxSprite;
	var foreground_R:FlxSprite;

	public static var player:Avatar;

	private static final random:FlxRandom = new FlxRandom();
	private static final sleep:(Int) -> Void = (ms:Int) ->
	{
		Timer.delay(function() {}, ms);
	};

	// level HUD
	var HUD:HUD;

	var text:FlxText;

	// level data
	public static final doors_positions:Array<Float> = [15, 44, 73];

	private var challenge_running:Bool = false; // wether the challenge is currently running

	public static final doors_y:Float = 55;
	public static final foods_y:Float = 85;
	public static final challenge_startY:Float = 110;

	override public function create()
	{
		super.create();

		// ground sprite
		ground = new FlxSprite(0, 0);
		ground.loadGraphic("assets/images/lv5/platform.png");
		ground.immovable = true;

		// doors sprites
		doors = new FlxTypedGroup<Lv5Door>();
		doors.add(new Lv5Door(0));
		doors.add(new Lv5Door(1));
		doors.add(new Lv5Door(2));

		// food sprite
		food = new Lv5Food(null); // will be replaced upon challenge start
		food.visible = true;

		// tooltip sprite
		tooltip = new FlxText(ground.width / 2, doors_y - 10, 0, "Press [" + Globals.controls_interact[0].toString() + "] to open a door", 6);
		tooltip.centerOrigin();
		tooltip.x = (ground.width / 2) - (tooltip.width / 2);

		// foreground sprites
		foreground_L = new FlxSprite(-10, 172);
		foreground_L.loadGraphic("assets/images/lv5/foreground_L.png");
		foreground_L.immovable = true;

		foreground_R = new FlxSprite(86, 172);
		foreground_R.loadGraphic("assets/images/lv5/foreground_R.png");
		foreground_R.immovable = true;

		// player sprite
		player = new Avatar(ground.x + ground.width / 2, ground.y + 210);
		player.animation.play("u_idle");

		// add the sprites
		add(ground);
		add(doors);
		add(food);
		add(player);
		add(tooltip);
		add(foreground_L);
		add(foreground_R);

		HUD = new HUD(this.camera);
		add(HUD);

		text = new FlxText(0, 0, 0, "lmao", 7);
		HUD.add(text);

		super.init(player, Level_6);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		player.updateMovement(elapsed, levelColliders);

		if (player.y < challenge_startY && !challenge_running)
			play(3, 2);
	}

	private function challenge_animations(callback:(FlxTween) -> Void)
	{
		player.LOCKED = true;

		var available_slots:Array<Int> = [0, 1, 2];
		random.shuffle(available_slots);
		doors.forEachAlive((door:Lv5Door) ->
		{
			door.insertFood(() ->
			{
				FlxTween.linearMotion(door, door.x, door.y, doors_positions[available_slots.pop()], door.y, 2, true, {
					ease: FlxEase.quadOut,
					onComplete: (_:FlxTween) ->
					{
						trace(door.x);
						player.LOCKED = false;
					}
				});
			});
		});
	}

	private function challenge(difficulty:Int)
	{
		final food_names:Array<String> = ["cheese", "chicken", "cake"];
		food = new Lv5Food(food_names[difficulty]);

		doors.members[random.int(0, 2)].contained = food;

		challenge_animations((_:FlxTween) ->
		{
			player.LOCKED = false;
		});

		return true;
	}

	private function play(iterations:Int, difficulty_increase:Float)
	{
		trace("challenge triggered");

		sleep(3000);
		challenge_running = true;

		for (i in 0...iterations)
			challenge(i);

		// challenge_running = false;
	}
}
