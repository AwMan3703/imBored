package assets.data;

import assets.data.Items;
import resources.Ui.Alert;
import resources.Inventory;
import assets.data.Items.ItemStack;

class Trade
{
    /**
     * The price to pay for `this` `Trade`.
     */
    public final price:Array<ItemStack>;
    /**
     * The `Item`(s) obtained from `this` `Trade`.
     */
    public final loot:Array<ItemStack>;
    /**
     * How many times `this` `Trade` can be performed.
     * If -1, the `Trade` can always be performed.
     */
    public var remaining(default, null):Int;

    /**
     * A `Trade` represents an exchange.
     * When `perform()`ed, subtracts the items in `_price` from the `_MAIN_INVENTORY`
     * and adds the ones in `_loot`.
     * @param _price    The price to pay for `this` `Trade`.
     * @param _loot     The `Item`(s) obtained from `this` `Trade`.
     * @param limit     How many times `this` `Trade` can be performed. If -1, the `Trade` can always be performed.
     */
    public function new(_price:Array<ItemStack>, _loot:Array<ItemStack>, ?limit:Int = -1) {
        price = _price;
        loot = _loot;
        remaining = limit;
    }

    public function perform(?alert_output:Null<Alert>) {
        if (remaining > 0)
        {
            //     if the user can pay the price            add the new items         decrease remaining trades
            if (_MAIN_INVENTORY.remove_items(price)) { _MAIN_INVENTORY.add_items(loot); remaining--; }
        } else if (remaining == -1) 
        {
            //     if the user can pay the price            add the new items
            if (_MAIN_INVENTORY.remove_items(price)) { _MAIN_INVENTORY.add_items(loot); }
        } else if (alert_output != null)
        {
            alert_output.display(1.75, "no exchanges left", Alert.icon_EXCLAMATION_MARK, [true, false], Alert.padcolor_RED);
        }
    }
}

// all of the trades available in the main game shop
final shop_trades:Array<Trade> = [
    new Trade( [new ItemStack(orb_powerful, 5)], [new ItemStack(rollticket_10, 1), new ItemStack(rollticket_1, 2)] ),
    new Trade( [new ItemStack(test_spear, 1)], [new ItemStack(golden_dust, 4)], 3 ),
    new Trade( [new ItemStack(golden_dust, 8)], [new ItemStack(gold_nugget, 1)] ),
    new Trade( [new ItemStack(gold_nugget, 15)], [new ItemStack(rollticket_1, 3)], 5 )
];