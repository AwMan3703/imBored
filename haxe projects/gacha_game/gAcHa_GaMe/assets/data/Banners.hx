package assets.data;

import flixel.FlxSprite;
import assets.data.Items;

class Banners {}

class Banner extends FlxSprite
{
	// store all rollable items
	public var _contents:Array<Item>;
	/* total available rolls and rolls left
	(if there is a limit, otherwise availableRolls = -1)*/
	public var totalAvailableRolls:Int;
	public var availableRolls:Int;
	// title for the banner
	public var bannerTitle:String;
	// path for showcase
	public var imageryPath:String;

	// WHEN ADDING NEW PROPERTIES REMEMBER TO IMPLEMENT THEM IN SAVEFORMAT() AND LOADFROMFORMAT()

	public function new(title:String, imagery_path:String, rollable_items:Array<Item>, ?available_rolls:Int = -1)
	{
		super();
		_contents = rollable_items;
		totalAvailableRolls = available_rolls;
		availableRolls = available_rolls;
		bannerTitle = title;
		imageryPath = "assets/images/ui/banners/" + imagery_path + "_showcase.png";

		// WHEN ADDING NEW PROPERTIES REMEMBER TO IMPLEMENT THEM IN SAVEFORMAT() AND LOADFROMFORMAT()
	}

	public function getItems_byTier(tier:Tier):Array<Item>
	{
		var results:Array<Item> = [];
		for (item in _contents)
		{
			if (item.tier == tier) results.push(item);
		}
		return results;
	}

	public function getItems_byType(type:Type)
	{
		var results:Array<Item> = [];
		for (item in _contents)
		{
			if (Std.isOfType(item, type)) results.push(item);
		}
		return results;
	}

	public static function loadFromFormat(formatted:Map<String, Dynamic>):Banner
	{
		var loaded:Banner = new Banner("", "", []);
		loaded._contents = formatted["contents"];
		loaded.totalAvailableRolls = formatted["totalAvailableRolls"];
		loaded.availableRolls = formatted["availableRolls"];
		loaded.bannerTitle = formatted["title"];
		loaded.imageryPath = formatted["imageryPath"];
		return loaded;
	}

	public static function saveFormat(toSave:Banner):Map<String, Dynamic>
	{
		var savable:Map<String, Dynamic> = [];
		savable["contents"] = toSave._contents;
		savable["totalAvailableRolls"] = toSave.totalAvailableRolls;
		savable["availableRolls"] = toSave.availableRolls;
		savable["title"] = toSave.bannerTitle;
		savable["imageryPath"] = toSave.imageryPath;
		return savable;
	}
}

// banners loot
final main_banner_loot:Array<Item> = [
    magic_test_spear,
    test_sword,
    test_sword_dev,
    test_gun,
    test_spear_dev,
    test_spear,
	gold_nugget,
	golden_dust,
	orb_powerful,
	orb_regular,
	iron_fragment
];
final spear_banner_loot:Array<Item> = [
    magic_test_spear,
    test_spear_dev,
    test_spear,
	iron_fragment
];
final standard_banner_loot:Array<Item> = [
    magic_test_spear,
    test_spear,
    test_sword,
    test_gun,
	golden_dust,
	orb_regular,
	iron_fragment
];

// create banners
var available_banners:Map<String, Banner> = [
    "main_banner" => new Banner("Testing Time", "main_banner", main_banner_loot),
    "spear_banner" => new Banner("Spear Exclusive", "spear_banner", spear_banner_loot, 3),
    "standard_banner" => new Banner("Standard Rolls", "standard_banner", standard_banner_loot)
];