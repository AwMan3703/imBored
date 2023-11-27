package menu.roll;

import resources.Inventory._MAIN_INVENTORY;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import resources.shaders.ExplosionShader2;
import flixel.math.FlxRandom;
import flixel.ui.FlxButton;
import menu.roll.BannerState;
import assets.data.Items;
import assets.data.Banners;
import resources.Ui;

class RollState extends FlxState
{
	/*
	 * list of all rollable items (weapons, characters and whatnot)
	 * passed by selected_banner
	*/
	final _rollbanner:Banner;

	final all_tiers:Array<Tier> = [tier_S, tier_A, tier_B, tier_C, tier_1, tier_2];

	var _roll:Array<ItemStack>;
	var _rolltiers:Array<Tier>;

	// for roll phase
	var orb:FlxSprite;
	var orbbg:FlxSprite = new FlxSprite(FlxG.width / 2 - 142, FlxG.height/2-88.5).loadGraphic('assets/images/ui/roll/orbbg/orbbg2.png');
	var rollprompt:FlxButton;
	var emitter:FlxEmitter;
	
	// for result phase
	var bg:FlxSprite = new FlxSprite(FlxG.width / 2 - 360, 0);
	var resultsDisplayer:MultiItemDisplay;
	final rds:ExplosionShader2 = new ExplosionShader2();
	final backBtn:BackButton;
	final alert = new Alert();

	function pitydebug()
	{
		trace("--pity after current roll:--");
		for (i in BannerState.pity.keys())
		{
			trace(i + " : " + BannerState.pity[i]);
		}
		trace("--current chance for tier:--");
		for (i in all_tiers)
		{
			trace(i.toString + " : " + chance(i));
		}
		trace("----------------------------");
	}

	public function new(rolls:Int, selected_banner:Banner)
	{
		super();

		/* get all rollable items, passed by BannerState.hx
			based on what banner is selected */
		_rollbanner = selected_banner;
		if (BannerState.banners[BannerState.selectedBanner].availableRolls >= rolls)
		{
			BannerState.banners[BannerState.selectedBanner].availableRolls -= rolls;
		}
		_rolltiers = rollTiers(rolls);
		_roll = rollItems(_rolltiers);
		resultsDisplayer = new MultiItemDisplay(FlxG.width / 2, FlxG.height / 2 - 40, _roll, 12, 13.5, true);
		backBtn = new BackButton(FlxG.width - 90, 10, "back", RollState);
		
		_MAIN_INVENTORY.add_items(_roll);
	}

	override public function create()
	{
		rollprompt = new FlxButton(FlxG.width/2-40, FlxG.height/2+60, 'ROLL', transition);
		emitter = new FlxEmitter(FlxG.width/2-34, FlxG.height/2-34);
		orb = new FlxSprite(FlxG.width/2-48, FlxG.height/2-48).loadGraphic('assets/images/ui/roll/orb.png');
		final orbbgscale = FlxG.height/orbbg.frameHeight;
		orbbg.scale.set(orbbgscale, orbbgscale);

		add(orbbg);
		add(rollprompt);
		add(emitter);
		add(orb);

		emitter.loadParticles('assets/images/ui/particles/preroll_particles.png', 500, 0, true).scale.set(0.15, 0.15, 0.5, 0.5, 0.25, 0.25, 0.75, 0.75);
		emitter.lifespan.set(3, 3);
		emitter.speed.set(40, 45, 45, 50);
		emitter.elasticity.set(0, 0, 0, 0);
		emitter.alpha.set(1, 1, 0, 0);
		emitter.setSize(68, 68);

		emitter.start(false, 0.1);

		add(alert);
		alert.display(2.5, '-1   /   press \"roll\"', 'assets/images/item_resources/currency/roll${_roll.length}ticket.png', [true, false]);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		hover_scaling(orb);
		click_scaling(orb);
		if (FlxG.mouse.overlaps(orb) && FlxG.mouse.justReleased) for (i in 0...25) emitter.emitParticle();

		rds.u_time.value[0] += elapsed;
	}

	function transition()
	{
		alert.hide();
		emitter.frequency = 0.001;
		emitter.speed.set(100, 125, 125, 150);
		var fadecolor = FlxColor.WHITE;
		switch findHighestTier(_rolltiers)
		{
			case tier_S:
				fadecolor = FlxColor.YELLOW;
			case tier_1:
				fadecolor = FlxColor.RED;
			case tier_A:
				fadecolor = FlxColor.PURPLE;
			case tier_2:
				fadecolor = FlxColor.ORANGE;
			case tier_B:
				fadecolor = FlxColor.BLUE;
			default:
				fadecolor = FlxColor.fromRGB(95,95,95);
		}
		FlxG.camera.fade(fadecolor, 1.5, false, show_results);
	}
	
	function show_results()
	{
		FlxG.camera.stopFX();

		emitter.kill();
		rollprompt.kill();
		orb.kill();
		orbbg.kill();

		add(bg);
		add(backBtn);
		add(resultsDisplayer);

		resultsDisplayer.shader = rds;

		FlxG.camera.flash(FlxColor.WHITE, 0.2);
		//pitydebug();
	}

	function tryDeviantRoute()
	{
		var chance = new FlxRandom().bool(20);
		if (chance)
		{
			BannerState.deviantRoute = true;
			trace("taken deviant route");
		};
	}

	function findMissingTiers(input:Array<Tier>)
	{
		var missing:Array<Tier> = [];
		if (!input.contains(tier_S)) missing.push(tier_S);
		if (!input.contains(tier_1)) missing.push(tier_1);
		if (!input.contains(tier_A)) missing.push(tier_A);
		if (!input.contains(tier_2)) missing.push(tier_2);
		if (!input.contains(tier_B)) missing.push(tier_B);
		if (!input.contains(tier_C)) missing.push(tier_C);
		return missing;
	}

	function findHighestTier(input:Array<Tier>)
	{
		if (input.contains(tier_S)) return tier_S;
		else if (input.contains(tier_1)) return tier_1;
		else if (input.contains(tier_A)) return tier_A;
		else if (input.contains(tier_2)) return tier_2;
		else if (input.contains(tier_B)) return tier_B;
		else if (input.contains(tier_C)) return tier_C;
		else return null;
	}

	function chance(tier:Tier):Float
	{
		if (tier == tier_C)
			return 99.99;
		var x:Int = BannerState.pity[tier.toString];
		var g:Int = BannerState.guaranteed[tier.toString];
		var r:Float = 1 * BannerState.luck / (g - x);
		// positivize
		if (r < 0)
			r = 0;
		return r;
	}

	function updatePity(foundTier:Tier)
	{
		if (foundTier != tier_C)
			BannerState.pity[foundTier.toString] = 0;

		if (BannerState.deviantRoute)
		{
			for (tier in all_tiers)
			{
				if (tier != tier_C && tier != foundTier)
					BannerState.pity[tier.toString] += 1;
			}
		}
		else
		{
			for (tier in all_tiers)
			{
				if ([tier_S, tier_A, tier_B].contains(tier) && tier != foundTier) 
					BannerState.pity[tier.toString] += 1;
			}
		}
	}

	function rollTiers(times:Int):Array<Tier>
	{
		final results:Array<Tier> = [];
		final stresults:Array<String> = [];
		var itemTier:Tier;
		for (i in 0...times)
		{
			BannerState.timesRolled++;
			if (BannerState.timesRolled == 30)
			{
				tryDeviantRoute();
			};
			if (BannerState.deviantRoute)
			{
				itemTier = all_tiers[
					new FlxRandom().weightedPick([
						chance(tier_S),
						chance(tier_A),
						chance(tier_B),
						chance(tier_C),
						chance(tier_1), 
						chance(tier_2)
					])
				];
			}
			else
			{
				itemTier = all_tiers[
					new FlxRandom().weightedPick([
						chance(tier_S),
						chance(tier_A),
						chance(tier_B),
						chance(tier_C),
						0,
						0
					])
				];
			};
			updatePity(itemTier);
			results.push(itemTier);
			stresults.push(itemTier.toString);
		};
		//pitydebug();

		// set the background for item reveal
		bg.loadGraphic("assets/images/ui/roll/rollbg/resultsbg/" + findHighestTier(results).toString + "Tier.png");

		// trace a couple of useful information
		//trace("roll result (tiers): " + stresults + " (" + results.length + ")");
		//trace("timesRolled=" + BannerState.timesRolled);

		return results;
	}

	function rollItems(tiers:Array<Tier>):Array<ItemStack>
	{
		final results:Array<ItemStack> = [];
		final stresults:Array<String> = [];
		var items:Array<Item> = [];
		for (tier in tiers)
		{
			items = _rollbanner.getItems_byTier(tier);
			final rolled:Item = items[new FlxRandom().int(0, items.length - 1)];
			final stack:ItemStack = new ItemStack(rolled, 1);
			results.push(stack);
			stresults.push('['+stack.item.name+', '+stack.quantity+']');
		};
		//trace("roll result (items): " + /*stresults*/ "[enable in code to show]" + " (" + results.length + ")");
		return results;					// ^ yes, that's the correct name for the variable
	}

	function back()
	{
		FlxG.switchState(new BannerState());
	}	
}
