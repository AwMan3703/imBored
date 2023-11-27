package levels;

import levels.Level_7;
import utility.Avatar;

class Level_6 extends Level
{
	var player:Avatar = new Avatar(0, 0);

	override function create()
	{
		super.create();
		super.init(player, Level_7);
	}
}
