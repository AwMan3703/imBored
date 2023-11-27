package resources;

import assets.data.Trades.shop_trades;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import assets.data.Trades.Trade;
import flixel.group.FlxSpriteGroup;
import assets.data.Items;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class Ui {}

// default parameters
var default_animation_duration_short:Float = 0.05;
var default_animation_duration_medium:Float = 0.5;
var default_animation_duration_long:Float = 2;

// graphic functions
function hover_scaling(target:FlxSprite, ?scale:Float = 1.05, ?time:Float = 0.05)
{
	if (FlxG.mouse.overlaps(target)) FlxTween.tween(target.scale, {x: scale, y: scale}, time);
	else if (target.scale != FlxPoint.weak(target.default_scale, target.default_scale))
		FlxTween.tween(target.scale, {x: target.default_scale, y: target.default_scale}, time);
}

function click_scaling(target:FlxSprite, ?scale:Float = 0.25, ?time:Float = 0.25)
{
	if (FlxG.mouse.overlaps(target) && FlxG.mouse.pressed) FlxTween.tween(target.scale, {x: scale, y: scale}, time);
	else if (target.scale != FlxPoint.weak(target.default_scale, target.default_scale))
		FlxTween.tween(target.scale, {x: target.default_scale, y: target.default_scale}, time);
}

// GUI components
class ItemDisplay extends FlxSpriteGroup
{
	/**
	 * Displays an `Item`.
	 * Shows the `Item`'s `pngPath`, `name` and quantity
	 */
	override public function new(posX:Float, posY:Float, itemToShow:Null<Item>, quantity:Int, scale_factor:Float = 1)
	{
		var item:Item = itemToShow;
		if (item == null) { item = void; }
		super();
		x = posX;
		y = posY;

		// initialize group sprites
		var bckgr:FlxSprite = new FlxSprite(0, 0);
		var itPng:FlxSprite = new FlxSprite(1, 3);// <- (1, 3) instead of (0, 0) for centering
		var itFrm:FlxSprite = new FlxSprite(0, 0);
		// formatting the item name on display
		var nmTxt:FlxText = new FlxText(0, 63, 62, item.name, 10, true, true);
		final qtxt = ''+quantity;
		var itQty:FlxText = new FlxText(65-(qtxt.length/2*10), -10, 0, qtxt, 14, true, true);

		// prepare graphics, then scale
		bckgr.loadGraphic("assets/images/ui/item_framing/ifbg_" + item.tier.toString + "Tier.png");
		itPng.loadGraphic(item.pngPath);
		itFrm.loadGraphic("assets/images/ui/item_framing/item_frame.png");
		nmTxt.borderColor = FlxColor.BLACK;
		nmTxt.borderSize = 2;
		nmTxt.wordWrap = false;
		bckgr.default_scale = scale_factor;
		itPng.default_scale = scale_factor;
		itFrm.default_scale = scale_factor;
		nmTxt.default_scale = scale_factor;
		itQty.default_scale = scale_factor;

		// add all sprites together
		add(bckgr);
		add(itPng);
		add(itFrm);
		add(nmTxt);
		if(quantity!=1)add(itQty);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		hover_scaling(this, 1.05, default_animation_duration_short);
		click_scaling(this, 0.25, default_animation_duration_medium);
	}
}

class MultiItemDisplay extends FlxTypedSpriteGroup<ItemDisplay>
{
	public var total_width:Float;
	/**
	 *	Displays multiple items in a clean array.
	 *	Be careful: half the width/height is automatically subtracted from `posX` and `posY`,
	 *	which means that the x and y position are set to the CENTER of the group,
	 *	NOT the top-left corner.
	 */
	public function new(posX:Float, posY:Float, items:Array<ItemStack>, ?horizontal_margin:Float = 12, ?vertical_margin:Float = 13.5, ?centerItems:Bool = false)
	{
		super();
		x = posX;
		y = posY;

		final h_margin:Float = horizontal_margin;
		final v_margin:Float = vertical_margin;

		// calculate the width of the whole thing with this super duper cool formula:
		//                  [ width of 1 item  *   the items    -  margin ]
		var full_width:Float = (66 + h_margin) * (items.length) - h_margin;
		var half_width:Float = full_width / 2; //(66 + margin) * (items.length / 2) - (margin / 2);
		while (full_width > FlxG.width) {
			full_width = half_width;
			half_width = full_width / 2;
		}

		total_width = full_width;

		//
		/* /pòr•ko•dìo/
		 * (masc., sing.)
		 * bestemmia italiana, utilizzata in occasioni
		 * come questa, quando, dopo ore di tentativi e
		 * fallimenti, il codice che finalmente funziona
		 * risulta spaghettoso e incomprensibile come lA mErDA DIO CA-
		*/
		// 40 lines of spaghetti code. nice :D
		var hs:Float = 0;
		var vs:Float = 0;
		var xplacement:Float = x;
		var yplacement:Float = y;
		if (centerItems) {
			x = posX - half_width;
			for (i in items)
			{
				xplacement = hs * (66 + h_margin);
				if (xplacement > full_width){
					xplacement = 0;
					hs = 0;
					vs++;
				} // ...basically create a newline
				yplacement = vs * (80 + v_margin);
				add(new ItemDisplay(xplacement, yplacement, i.item, i.quantity,  0.7));
				hs++;
			}
			y = posY - (yplacement/2);
		} else {
			for (i in items)
			{
				xplacement = hs * (66 + h_margin);
				if (xplacement > FlxG.width-67){
					xplacement = 0;
					hs = 0;
					vs++;
				} // ...also basically create a newline
				yplacement = vs * (80 + v_margin);
				add(new ItemDisplay(xplacement, yplacement, i.item, i.quantity,  0.7));
				hs++;
				
			}
		}
	}
}

class ShopShowcase extends FlxTypedSpriteGroup<FlxSprite>
{
	final background:FlxSprite;
	final price_showcase:MultiItemDisplay;
	final arrow:FlxSprite;
	final loot_showcase:MultiItemDisplay;
	final remaining_text:Null<FlxText>;
	var _trade:Trade;
	var _out_alert:Null<Alert>;
	/**
	 * Showcases a possible purchase.
	 * @param price   The `Item`s necessary for the purchase
	 * @param loot 	  The `Item`s that would be received.
	 */
	public function new(posX:Float, posY:Float, trade:Trade, ?alert:Null<Alert>)
	{
		super();
		x = posX;
		y = posY;
		_trade = trade;
		_out_alert = alert;

		final gutter:Int = 5;
		price_showcase = new MultiItemDisplay(gutter, gutter, trade.price);
		arrow = new FlxSprite(gutter*2+price_showcase.total_width, gutter).loadGraphic("assets/images/ui/item_framing/arrow_right.png");
		loot_showcase = new MultiItemDisplay(gutter*3+price_showcase.total_width+arrow.width, gutter, trade.loot);
		remaining_text = new FlxText(gutter, gutter*2+80, 0, 'trades remaining: ${trade.remaining}');
		background = new FlxSprite(0, 0).makeGraphic(
			Std.int(gutter*4+price_showcase.total_width+arrow.width+loot_showcase.total_width),
			Std.int(gutter*2+remaining_text.height+80),
			FlxColor.fromString('#4b4b4b')
			);
		add(background);

		if (trade.remaining >= 0) {
			remaining_text.text = 'trades remaining: ${_trade.remaining}';
		} else {
			remaining_text.text = '(unlimited)';
		}
		add(remaining_text);
		add(price_showcase);
		add(arrow);
		add(loot_showcase);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(this) && FlxG.mouse.justReleased) perform_trade();

		hover_scaling(this);
		click_scaling(this);
	}

	function perform_trade()
	{
		_trade.perform(_out_alert);
		if (_trade.remaining >= 0) { remaining_text.text = 'trades remaining: ${_trade.remaining}'; }

		var s = "";
		for (i in shop_trades) { s+=', ${i.remaining}'; }
		trace(' > ${s}');
	}
}

private class MultiIconDisplay extends FlxSpriteGroup
{
	public var displaycount:Int = 3;
	public var contents:Array<FlxSprite>;
	public var icon_width:Float;
	public var icon_margin:Float;
	public var slots:Array<FlxPoint>;
	public var sideslot_margin:Float;
	public var sideslot_sx:FlxPoint;
	public var sideslot_dx:FlxPoint;

	/**
	 * WORK IN PROGRESS - DO NOT USE THIS PLEASE (`source/resources/Ui.hx`)
	*/
	public function new(posX:Float, posY:Float, iconWidth:Float, iconMargin:Float, sideslotMargin:Float, icons:Array<FlxSprite>, displayed:Int = 3)
	{
		super();

		if (!FlxMath.isEven(displayed))
		{
			displaycount = displayed;
		}
		icon_width = iconWidth;
		icon_margin = iconMargin;
		sideslot_margin = sideslotMargin;
		sideslot_sx = new FlxPoint(posX, posY);
		sideslot_dx = new FlxPoint((iconWidth + icon_margin) * displayed, posY);

		calculate_slots();

		// calculate half the width of the whole thing with this super duper cool formula:
		//              [ width of 1 item *  half the items  - half margin so it's half the length ]
		var halfWidth:Float = (iconWidth + icon_margin) * (displayed / 2) - (icon_margin / 2);

		// finally set the MultiItemDisplay's x and y positions
		x = posX - halfWidth;
		y = posY;
		for (i in 0...icons.length)
		{
			// item distance from one another: 66 (frame width) + margin
			var icon:FlxSprite = new FlxSprite(i * (iconWidth + icon_margin), 0);
			contents.push(icon);
			add(icon);
		}
	}

	public function calculate_slots()
	{
		for (i in 0...displaycount)
		{
			var px:Float = x + sideslot_margin + (i * (icon_width + icon_margin));
			slots.push(new FlxPoint(px, y));
		}
	}

	private function slide_to_slot(target:FlxSprite, slot:FlxPoint, duration:Float)
	{
		FlxTween.tween(target.x, slot.x, duration);
	}

	public function slide_left(animation_time:Float)
	{
		// remove the current icon in sideslot_sx

		// slide every icon 1 slot left (-)
		for (icon in contents)
		{
			if (contents.indexOf(icon) == 0)
			{
				slide_to_slot(icon, sideslot_sx, animation_time);
			}
			else
			{
				slide_to_slot(icon, slots[contents.indexOf(icon) - 1], animation_time);
			}
		}
		// add new icon in sideslot_dx
	}
}

class BackButton extends FlxButton
{
	/**
	 * Creates a `FlxButton` that can ✨magically✨ rewind
	 * to the previous `FlxState` the user visited.
	 * @param posX 			The `x` position of `this` button.
	 * @param posY 			The `y` position of `this` button.
	 * @param text			The text to display on `this` button.
	 * @param this_state 	The class for the `FlxState` the user is currently in.
	 */
	public function new(posX:Float, posY:Float, text:String, this_state:Class<flixel.FlxState>) {
		super(posX, posY, text, to_previous_state);
		if (Main._state_path[Main._state_path.length - 1] != this_state) { Main._state_path.push(this_state); }
	}

	function to_previous_state() {
		final state:FlxState = Type.createInstance(Main._state_path[Main._state_path.length - 2], []);
		Main._state_path.pop();
		FlxG.switchState(state);
	}
}

class ShaderToggler extends FlxButton
{
	var shadersOn:Bool = true;
	/**
	 * A button to toggle shaders in the current `FlxG.camera`
	 */
	public function new(posX:Float, posY:Int) {
		super(posX, posY, "shaders: true", toggle);
	}
	function toggle() {
		shadersOn = !shadersOn;
		FlxG.camera.filtersEnabled = shadersOn;
		text = "shaders: "+shadersOn;
	}
}

class Alert extends FlxSpriteGroup
{
	var waiting:Float = 0;

	final box:FlxSprite;
	final pad_left:FlxSprite;
	final pad_right:FlxSprite;
	final text:FlxText;
	final icon:FlxSprite;

	public static final icon_PROMPT:String = 'assets/images/icons/prompt.png';
	public static final icon_EXCLAMATION_MARK:String = 'assets/images/icons/exclamation_mark.png';
	public static final icon_YELLOW_STAR:String = 'assets/images/icons/star.png';

	public static final padcolor_RED:String = 'ff0019';
	public static final padcolor_ORANGE:String = '#ffac4a';
	public static final padcolor_YELLOW:String = '#ffd913';
	public static final padcolor_GREEN:String = '#21a157';
	public static final padcolor_LIGHT_BLUE:String = '#3eb3ff';
	public static final padcolor_BLUE:String = '#3100ff';

	/**
	 * Displays a quick message at the top of the screen.
	 * Add it to the `FlxState`, then call `Alert.display()` to use it.
	 */
	public function new() {
		super();
		x = FlxG.width/2;
		y = 20;
		box = new FlxSprite(x, y);
		pad_left = new FlxSprite(x, y);
		pad_right = new FlxSprite(x, y);
		text = new FlxText(x, y, 0, null, 10);
		icon = new FlxSprite(x, y);
		add(box);
		add(pad_left);
		add(pad_right);
		add(text);
		add(icon);
		visible = false;
	}

	/**
	 * Displays the `message`.
	 * @param permanence  How long the box will remain visible for
	 * @param message     The message to display
	 * @param icon_path   (optional) an icon to add to the message
	 */
	public function display(permanence:Float, message:String, ?icon_path:String = 'assets/images/icons/prompt.png', ?show_pads:Array<Bool>, ?pads_color:String = '#ffac4a') {
		x = FlxG.width/2;
		y = 20;
		final margin = 7;
		final boxheight = 20;
		final textwidth = message.length*6.5;
		final icon_size = 24;
		x -= (margin*1.5) + (icon_size/2) + (textwidth/2);

		icon.loadGraphic(icon_path);
		final icon_scale:Float = icon_size/icon.frameWidth;
		icon.scale.set(icon_scale, icon_scale);
		icon.updateHitbox();
		icon.setPosition(x+margin, y+(boxheight/2)-(icon_size/2));

		text.text = message;
		text.setPosition(x+(margin*2)+(icon_size), y);

		box.makeGraphic(Std.int(textwidth+icon_size+(margin*3)), boxheight+(margin*2), FlxColor.BLACK);
		box.setPosition(x, y-margin);
		if (show_pads[0]) {
			pad_left.makeGraphic(7, boxheight+(margin*2), FlxColor.fromString(pads_color));
			pad_left.setPosition(x-10, y-margin);
		} else { pad_left.destroy(); }
		if (show_pads[1]) {
			pad_right.makeGraphic(7, boxheight+(margin*2), FlxColor.fromString(pads_color));
			pad_right.setPosition(x+3+Std.int(textwidth+icon_size+(margin*3)), y-margin);
		} else { pad_right.destroy(); }

		visible = true;
		waiting = permanence; // start the countdown
	}

	/**
	 * Forcefully hide the message, even if the countdown isn't over
	 */
	public function hide() {
		visible = false;
		waiting = 0;
	}

	override public function update(elapsed:Float)
	{
		//hover_scaling(this); // crashes everything when executed. why tho?
		if (waiting > 0){
			waiting -= elapsed;
			if (waiting <= 0 && alpha > 0) { visible = false; }
		}
	}
}