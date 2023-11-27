package menu.roll;

import Main;
import resources.Inventory._MAIN_INVENTORY;
import resources.Ui.BackButton;
import resources.Ui.Alert;
import assets.data.Banners;
import assets.data.Items.rollticket_10;
import assets.data.Items.rollticket_1;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import menu.MenuState;

class BannerState extends FlxState
{
	public static final banners:Map<String, Banner> = available_banners;

	/* when banner is switched, update this.
	contains NAME of the selected banner (String)*/
	public static var selectedBanner:String = "";	
	
	// VEWY IMPOWTANT!!1! -> luck settings owo
	// after how many rolls a tier is guaranteed:
	public static final guaranteed:Map<String, Int> = [
		"s" => 100,
		"a" => 25,
		"1" => 20,
		"b" => 10,
		"2" => 3
		//tier_C => 0 // C tier is always guaranteed
	];
	// pity counter
	public static var pity:Map<String, Int> = [
		"s" => 0, // will be overwritten on start
		"a" => 0, // will be overwritten on start
		"1" => 0, // will be overwritten on start
		"b" => 0, // will be overwritten on start
		"2" => 0, // will be overwritten on start
		"c" => 0  // will be overwritten on start
	];
	/* luck multiplier increases the chance for
	every tier to be found. (idk mabye im gonna need it)
	Recommended limit: no more than 30 */
	public static final luck:Float = 1;
	
	// declare roll data variables
	public static var deviantRoute:Bool; // = Main.gameSave.data.deviantRoute;
	public static var timesRolled:Int; // = Main.gameSave.data.timesRolled;
	// declare background and banner for later use
	public var rollbg:FlxSprite;
	public var bannerTitleDisplayer:FlxText;
	public var bannerDisplayer:FlxSprite;
	public var availableCounter:FlxText;
	public var alert:Alert;

	override public function create():Void
	{
		//saveRollData(); //<- uncomment it to create non pre-existing save slots for new data
		loadRollData();
		final slotSupY = 10;
		final slotSubY = FlxG.height - 30;
		final slot1:Float = 10;
		final slot2:Float = 100;
		final slot2minus:Float = 190;
		final slot3:Float = FlxG.width - 180; //- 270;
		final slot4:Float = FlxG.width - 90; //- 140;

		rollbg = new FlxSprite(FlxG.width / 2 - 70, FlxG.height / 2 - 40);
		bgupdate();
		rollbg.scale.set(5, 5);
		add(rollbg);

		bannerDisplayer = new FlxSprite(FlxG.width / 2 - 245, FlxG.height / 2 - 155);
		bannerTitleDisplayer = new FlxText(FlxG.width / 2 - 225, FlxG.height / 2 - 155, 0, "loading...", 10);
		availableCounter = new FlxText(FlxG.width / 2 - 225, FlxG.height / 2 + 135, 0, "loading...", 12);
		add(bannerDisplayer);
		add(bannerTitleDisplayer);
		add(availableCounter);

		add(new FlxButton(slot2, slotSupY, "shop", toShop));
		add(new FlxButton(slot1, slotSubY, "<", previousBanner));
		add(new FlxButton(slot4, slotSubY, ">", nextBanner));
		add(new BackButton(slot1, slotSupY, "back", BannerState));

		// TESTING - REMOVE FOR RELEASE
		final rsetbtn:FlxButton = new FlxButton(slot2minus, slotSupY, "reset (!)", resetRollData);
		add(rsetbtn);
		// TESTING - REMOVE FOR RELEASE

		final roll1btn:FlxButton = new FlxButton(slot3 - 90, slotSupY, "", roll1);
		roll1btn.loadGraphic("assets/images/ui/roll/rollx1btn.png", true, 80, 32, false);
		roll1btn.scale.set(1.5, 1.5);
		roll1btn.updateHitbox();
		final roll10btn:FlxButton = new FlxButton(slot4 - 50, slotSupY, "", roll10);
		roll10btn.loadGraphic("assets/images/ui/roll/rollx10btn.png", true, 80, 32, false);
		roll10btn.scale.set(1.55, 1.55);
		roll10btn.updateHitbox();
		add(roll1btn);
		add(roll10btn);

		alert = new Alert();
		add(alert);

		if (selectedBanner == "") setBanner("main_banner");
		else setBanner(selectedBanner);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.RIGHT || FlxG.keys.justReleased.DOWN) nextBanner();
		if (FlxG.keys.justReleased.LEFT || FlxG.keys.justReleased.UP) previousBanner();
	}

	function bgupdate()
	{
		function load(filename:String)
			rollbg.loadGraphic("assets/images/ui/roll/rollbg/" + filename + ".jpg");
		if (deviantRoute)
		{
			if (timesRolled > 99) { load("deviant100"); }
			else if (timesRolled > 59) { load("deviant60"); }
			else { load("deviant30"); };
		}
		else
		{
			if (timesRolled > 199) { load("classic200"); }
			else if (timesRolled > 99) { load("classic100"); }
			else if (timesRolled > 49) { load("classic50"); }
			else { load("classic0"); };
		};
	}

	function roll1():Void
	{
		if (banners[selectedBanner].availableRolls > 0 || banners[selectedBanner].availableRolls == -1) {
			if (_MAIN_INVENTORY.remove_item(rollticket_1)) {
				saveRollData();
				FlxG.switchState(new RollState(1, banners[selectedBanner]));
				saveRollData();
			} else { alert.display(3, 'insufficient 1-Roll tickets', 'assets/images/item_resources/currency/roll1ticket.png', [true], Alert.padcolor_RED); }
		} else { alert.display(3, 'no rolls left for this banner', 'assets/images/icons/exclamation_mark.png', [true], Alert.padcolor_RED); }
	}

	function roll10():Void
	{
		if (banners[selectedBanner].availableRolls > 9 || banners[selectedBanner].availableRolls == -1) {
			if (_MAIN_INVENTORY.remove_item(rollticket_10)) {
				saveRollData();
				FlxG.switchState(new RollState(10, banners[selectedBanner]));
				saveRollData();
			} else { alert.display(3, 'insufficient 10-Roll tickets', 'assets/images/item_resources/currency/roll1ticket.png', [true], Alert.padcolor_RED); }
		} else { alert.display(3, 'available rolls for this banner are insufficient for a 10-Roll', 'assets/images/icons/exclamation_mark.png', [true], Alert.padcolor_RED); }
	}

	function toShop():Void
	{
		FlxG.switchState(new ShopState());
	}

	function resetRollData()
	{
		timesRolled = 0;
		deviantRoute = false;
		// wipe out pity one by one
		for (key in pity.keys())
		{
			pity[key] = 0;
		}
		// reset available rolls for each banner
		for (i in banners)
		{
			i.availableRolls = i.totalAvailableRolls;
		}
		bannerTitleDisplayer.text = "39 buried, 0 found";
		trace("timesRolled was reset to 0, abandoned eventual deviant route, pity and banners availableRolls were wiped");
		bgupdate();
		saveRollData();
	}

	function loadRollData()
	{
		pity = Main.gameSave.data.pity;
		timesRolled = Main.gameSave.data.timesRolled;
		deviantRoute = Main.gameSave.data.deviantRoute;
		/*trace('pity: '+pity);
		trace('total times rolled: '+timesRolled);
		trace('taken deviant route: '+deviantRoute);*/
		trace("loaded roll data");
	}

	function saveRollData()
	{
		bgupdate();
		Main.gameSave.data.pity = pity;
		Main.gameSave.data.timesRolled = timesRolled;
		Main.gameSave.data.deviantRoute = deviantRoute;
		Main.gameSave.flush();
		trace("saved roll data");
	}

	function setBanner(new_banner:String)
	{
		alert.hide();
		if (new_banner != null && new_banner != "") {
			selectedBanner = new_banner;
			bannerTitleDisplayer.text = banners[selectedBanner].bannerTitle;
			bannerDisplayer.loadGraphic(banners[new_banner].imageryPath);
			if (banners[new_banner].availableRolls == -1) {
				availableCounter.visible = false;
			} else {
				availableCounter.visible = true;
				availableCounter.text = "remaining rolls: " + banners[selectedBanner].availableRolls;
			}
		}
	}

	function previousBanner()
	{
		setBanner(banners.keyByIndex(banners.indexOfKey(selectedBanner) - 1));
	}

	function nextBanner()
	{
		setBanner(banners.keyByIndex(banners.indexOfKey(selectedBanner) + 1));
	}

	function back():Void
	{
		FlxG.switchState(new MenuState());
	}
}

