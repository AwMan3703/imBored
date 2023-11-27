package menu;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import generate.GenerateState;
import menu.roll.BannerState;
import menu.ShopState;
import menu.InventoryState;
import net.Client;


class MenuState extends FlxState
{
	public var centerX:Float = FlxG.width / 2;
	public var centerY:Float = FlxG.height / 2;

	var client = new Client();
	var statustxt:FlxText;

	override public function create():Void
	{
		var playbtn:FlxButton = new FlxButton(centerX - 90, centerY - 40, "", startgame);
		var rollbtn:FlxButton = new FlxButton(centerX - 50, centerY + 60, "roll", rollscreen);
		var inventorybtn:FlxButton = new FlxButton(centerX - 50, centerY + 85, "inventory", inventoryscreen);
		var shopbtn:FlxButton = new FlxButton(centerX - 50, centerY + 110, "shop", shopscreen);
		var connectbtn:FlxButton = new FlxButton(10, FlxG.height - 90, "Connect TS - beta", connect);
		var sendtbtn:FlxButton = new FlxButton(10, FlxG.height - 60, "Send TS - beta", sendmsg);
		var disconnectbtn:FlxButton = new FlxButton(10, FlxG.height - 30, "Disconnect - beta", disconnect);
		playbtn.loadGraphic("assets/images/ui/playbtn.png");
		playbtn.setGraphicSize(160, 80);
		playbtn.updateHitbox();
		statustxt = new FlxText(10, FlxG.height - 105, 0, "status: [disabled]");
		add(playbtn);
		add(rollbtn);
		add(inventorybtn);
		add(shopbtn);
		add(connectbtn);
		add(sendtbtn);
		add(disconnectbtn);
		add(statustxt);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.SPACE)
		{
			FlxG.switchState(new GenerateState());
		}
	}

	function connect():Void
	{
		return;
		// server settings
		var server = '0.0.0.0';
		var port = 8000;

		trace('connecting to server ${server}, port ${port}');
		client.connect(server, port);
		statustxt.text = 'status: connected to ${server} (${port})';
	}

	function sendmsg()
	{
		return;
		trace('sending message...');
		client.send('test 123412341324');
	}

	function disconnect()
	{
		return;
		client.disconnect();
		trace('connection terminated.');
		statustxt.text = 'status: disconnected';
	}

	function startgame():Void
	{
		FlxG.switchState(new GenerateState());
	}

	function rollscreen():Void
	{
		FlxG.switchState(new BannerState());
	}

	function inventoryscreen():Void
	{
		FlxG.switchState(new InventoryState());
	}

	function shopscreen():Void
	{
		FlxG.switchState(new ShopState());
	}
}
