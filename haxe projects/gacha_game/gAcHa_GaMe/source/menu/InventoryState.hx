package menu;

import resources.Ui.BackButton;
import resources.Ui.Alert;
import flixel.FlxG;
import assets.data.Items;
import resources.Inventory._MAIN_INVENTORY;
import resources.Ui.MultiItemDisplay;
import flixel.FlxState;
import flixel.ui.FlxButton;

class InventoryState extends FlxState {

    var main_displayer:MultiItemDisplay;

    override public function create() {
        super.create();

        load_displayer(_MAIN_INVENTORY.itemlist);
        add(main_displayer);

        var backbtn:BackButton = new BackButton(10, 10, "back", InventoryState);
        add(backbtn);
        var resetbtn:FlxButton = new FlxButton(10, 35, "reset", reset);
        add(resetbtn);

        //add(new FlxButton(100, 20, "sort wpns", () -> {update_displayer(_MAIN_INVENTORY.get_items_byType(Weapon));}));

        final alert:Alert = new Alert();
        add(alert);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.DOWN) main_displayer.y -= 20;
        if (FlxG.keys.justPressed.UP && main_displayer.y < 66) main_displayer.y += 20;
    }

    private function update_displayer(source:Array<ItemStack>) {
        main_displayer.kill();
        load_displayer(_MAIN_INVENTORY.itemlist);
        main_displayer.revive();
        add(main_displayer);
    }

    private function load_displayer(source:Array<ItemStack>) {

        main_displayer = new MultiItemDisplay(10, 66, source, 12, 13.5, false);
    }

    function reset():Void
    {
        _MAIN_INVENTORY.wipe();
        Main.default_inventory();
        update_displayer(_MAIN_INVENTORY.itemlist);
    }

    function back():Void
    {
        FlxG.switchState(new MenuState());
    }
}