package menu;

import assets.data.Trades.shop_trades;
import resources.Ui.Alert;
import resources.Ui.BackButton;
import resources.Ui.ShopShowcase;
import flixel.FlxState;
import flixel.FlxSprite;

class ShopState extends FlxState {

    final bg:FlxSprite = new FlxSprite(0, 0);
    var alert:Alert;

    override public function create()
    {
        super.create();

        bg.loadGraphic("assets/images/ui/shop/shopbg.png");
        //add(bg);

        final backbtn:BackButton = new BackButton(10, 10, "back", ShopState);
        add(backbtn);
        
        var i = 0;
        for (trade in shop_trades) {
            add(new ShopShowcase(10, 40+(i*110), trade, alert));
            i++;
        }

        alert = new Alert();
        add(alert);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed); 
    }
}