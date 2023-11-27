package assets.data;

import flixel.util.typeLimit.OneOfTwo;
import Std;

private final MODULE_ERR:String = "ItemUtilityError: ";

class Tier {
	public var toString:String;
	public function new(string:String) {
		this.toString = string.toLowerCase();
	}
}
final tier_S:Tier = new Tier("s");
final tier_A:Tier = new Tier("a");
final tier_B:Tier = new Tier("b");
final tier_C:Tier = new Tier("c");
final tier_1:Tier = new Tier("1");
final tier_2:Tier = new Tier("2");

class ItemStack
{
	private final ERR:String = MODULE_ERR + "StackError: ";
	/**
	 * the type of `Item` stored here
	 */
	public var item(default, null):Item;
	/**
	 * the quantity of `this.item`s stored in `this` ItemStack
	 */
	public var quantity(default, set):Int;

	function set_quantity(new_quantity:Int):Int {
		if (item.stackable || [0, 1].contains(new_quantity)) {
			quantity = new_quantity;
			return new_quantity;
		}
		else { throw ERR + 'item stack overflow (setting ${item.name}\'s quantity to ${new_quantity}, stackable: ${item.stackable})'; }
	}

	public function new(_item:Item, ?_quantity:Int = 0) {
		item = _item;
		quantity = _quantity; //the check to make sure quantity doesn't overflow is run every time the property is set
	}
}

var all_items:Map<String, Item> = [];
/**
 * ABOUT ITEM CODES
 * Each item has a fixed unique _itemCode property, constructed when it is created,
 * by adding a string (max 5 characters + underscore) to the code for every parent class, up to `Item`.
 * For example, the `_itemCode` for `test_spear` would be "0_weapn_spear_2":
 * 
 * 		class `Item`        ->  "0_"	   (item system #)
 * 		class `Weapon`      ->  "weapn_"   (item type)
 * 		class `Spear`       ->  "spear_"   (item class)
 * 		final `test_spear`  ->  "2"		   (unique identifier)
 */

// ITEM, the base class for item resources
class Item
{
	private final ERR:String = MODULE_ERR + "ItemError: ";
	/**
	 * a unique code used to identify `this` item class, regardless of its `name`.
	 */
	public var _itemCode:String;
	/**
	 * the path to a .png file depicting `this` item.
	 */
	public var pngPath:String;
	/**
	 * the name of `this` item.
	 */
	public var name:String;
	/**
	 * the tier of `this` item.
	 */
	public var tier:Tier;
	/**
	 * wether multiple copies of `this` item can be contained in an `ItemStack`
	 */
	public var stackable:Bool;

	public function new(_item_code:String, name:String, tier:Tier, pngPath:String, ?stackable:Bool = true)
	{
		this.name = name;
		this.tier = tier;
		this.pngPath = "assets/images/item_resources/" + pngPath + ".png";
		this.stackable = stackable;

		//register this item
		if (all_items[_item_code] == null) {
			this._itemCode = "0_"+_item_code;
			all_items[_item_code] = this;
		} else {
			throw "ITEM CODE \""+_item_code+"\" (for \""+name+"\") ALREADY REGISTERED AS \""+all_items[_item_code].name+"\"";
		}
	}
}

// CURRENCY, creates currency-type items
class Currency extends Item
{
	override public function new(_item_code:Int, name:String, tier:Tier, pngPath:String)
	{
		super(
			"crncy_"+_item_code,
			name,
			tier,
			"currency/"+pngPath
		);
	}
}

// MATERIAL, creates material-type items
class Material extends Item {
	override public function new(_item_code:OneOfTwo<String, Int>, name:String, tier:Tier, pngPath:String, ?stackable:Bool = true)
	{
		super(
			"matrl_"+_item_code,
			name,
			tier,
			"materials/"+pngPath,
			stackable
		);
	}
}

// WEAPON, creates weapon-type items
class Weapon extends Item
{
	// please implement these
	public var dmg:Float;
	public var cooldown:Float;
	public var range:Float;

	override public function new(_item_code:OneOfTwo<String, Int>, name:String, tier:Tier, pngPath:String)
	{
		super(
			"weapn_"+_item_code,
			name,
			tier,
			"weapons/"+pngPath,
			false
		);
	}
}

// SPEAR, creates spear-type weapons
class Spear extends Weapon
{
	override public function new(_item_code:Int, name:String, tier:Tier, pngPath:String)
	{
		super(
			"spear_"+_item_code,
			name,
			tier,
			"spear/"+pngPath
		);
	}
}

// SWORD, creates sword-type weapons
class Sword extends Weapon
{
	override public function new(_item_code:Int, name:String, tier:Tier, pngPath:String)
	{
		super(
			"sword_"+_item_code,
			name,
			tier,
			"sword/"+pngPath // sword art offline lmao
		);
	}
}

// GUN, creates gun-type weapons
class Gun extends Weapon
{
	override public function new(_item_code:Int, name:String, tier:Tier, pngPath:String)
	{
		super(
			"gun_"+_item_code,
			name,
			tier,
			"gun/"+pngPath
		);
	}
}

// generating all the items haha
final void:Item				 = new Item("0", "null", tier_C, "void");
// CURRENCIES
final orb_regular:Currency   = new Currency(1, "Orb", tier_B, "orb");
final orb_powerful:Currency  = new Currency(2, "Powerful Orb", tier_S, "powerful_orb");
final rollticket_1:Currency  = new Currency(3, "1-Roll", tier_A, "roll1ticket");
final rollticket_10:Currency = new Currency(4, "10-Roll", tier_S, "roll10ticket");
// MATERIALS
final gold_nugget:Material   = new Material(1, "Gold Nugget", tier_B, "gold_nugget");
final golden_dust:Material   = new Material(2, "Gold Dust", tier_C, "golden_dust");
final iron_fragment:Material = new Material(3, "Iron Fragment", tier_C, "iron_fragment");
// WEAPONS
final magic_test_spear:Spear = new Spear(1, "Magic Spear", tier_S, "magic_test_spear");
final test_spear:Spear       = new Spear(2, "Test Spear", tier_C, "test_spear");
final test_spear_dev:Spear   = new Spear(3, "Deviant Spear", tier_2, "test_spear_dev");
final test_sword:Sword       = new Sword(4, "Test Sword", tier_A, "test_sword");
final test_sword_dev:Sword   = new Sword(5, "Deviant Sword", tier_1, "test_sword_dev");
final test_gun:Gun           = new Gun(6, "Test Gun", tier_B, "test_gun");
