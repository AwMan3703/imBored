package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import levels.Level;
import openfl.ui.Keyboard;

class GameOverState extends FlxState
{
	private var last_level:Class<Level>;

	/**
	 * Creates a gameover screen
	 * @param lost The level that triggered the gameover, so it can be restarted
	 */
	public function new(lost:Class<Level>)
	{
		super();
		last_level = lost;
		FlxG.camera.fade(FlxColor.BLACK, .5, false);
		FlxG.switchState(Type.createInstance(last_level, []));
	}

	override public function create()
	{
		/*super.create();
			var restartBtn:FlxButton = new FlxButton(0, 0, "RETRY", () ->
			{
				FlxG.switchState(Type.createInstance(last_level, []));
			});
			restartBtn.screenCenter();

			var toolTip:FlxText = new FlxText(0, (FlxG.height / 2) + 10, 0, "or press R to retry (button may not work yet)");
			toolTip.screenCenter(FlxAxes.X);

			add(restartBtn);
			add(toolTip); */
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.pressed.R)
		{
			final newLevel:Level = Type.createInstance(last_level, []);
			FlxG.switchState(newLevel);
		}
	}
}
