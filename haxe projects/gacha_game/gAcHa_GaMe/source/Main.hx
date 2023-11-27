package;

import assets.data.Items.orb_powerful;
import assets.data.Items.gold_nugget;
import resources.Inventory;
import flixel.FlxState;
import flixel.FlxGame;
import flixel.util.FlxSave;
import menu.MenuState;
import sys.io.File;
import openfl.display.Sprite;

var gameSave:FlxSave = new FlxSave();

class Main extends Sprite
{
	public static final _state_path:Array<Class<FlxState>> = [];

	public function new()
	{
		// haha im funny
		if (File.getContent('assets/images/ui/roll/lmao.txt') != 'PRAISE THE ORB') return;

		super();
		// main save file, any data should be saved here.
		gameSave.bind("SavedData");

		// TESTING - REMOVE FOR RELEASE
		default_inventory();
		// TESTING - REMOVE FOR RELEASE

		// the first state to be displayed on start.
		// CHANGE IN VARIABLE, NOT IN addChild() FUNCTION
		final start_state:Class<flixel.FlxState> = MenuState;

		_state_path.push(start_state);
		addChild(new FlxGame(640, 480, start_state));
	}

	// TESTING - REMOVE FOR RELEASE
	public static function default_inventory() {
		/*_MAIN_INVENTORY.add_item(rollticket_1, 5);
		_MAIN_INVENTORY.add_item(rollticket_10, 3);*/
		_MAIN_INVENTORY.add_item(orb_powerful, 35);
		_MAIN_INVENTORY.add_item(gold_nugget, 35);
	}
	// TESTING - REMOVE FOR RELEASE
}
