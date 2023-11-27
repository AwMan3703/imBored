package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import levels.*;

class MenuState extends FlxState
{
	var startBtn:FlxButton;
	var text:FlxText;

	private function uiSlot(index:Int)
	{
		var spacing:Float = 30;
		return spacing * index;
	}

	override public function create()
	{
		super.create();
		text = new FlxText(0, uiSlot(2), -1, "Menu screen here");
		text.screenCenter(X);
		add(text);
		// startBtn = new FlxButton(0, uiSlot(3), "START", function():Void
		// {
		FlxG.switchState(new Level_1());
		// });
		// startBtn.screenCenter(X);
		// add(startBtn);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
