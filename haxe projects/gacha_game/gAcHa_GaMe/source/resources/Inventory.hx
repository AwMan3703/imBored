package resources;

import assets.data.Items.ItemStack;
import assets.data.Items.Item;

class Inventory {
    /**
     * The complete list of all `Item`s stored in this `Inventory`.
     * The `key`s are the `Item`'s `_itemCode`, and the `value`s are `ItemStack`s
     */
    public var itemlist(default, null):Array<ItemStack>;

    /**
     * For each `Item` currently stored, maps all the positions of `ItemStack`s
     * containing it to its `Item._itemCode`.
     */
    public var index(default, null):Map<String, Array<Int>>;

    public function new()
    {
        //idk initialize stuff ig
        itemlist = [];
        index = [];
        trace_contents();
    }

    /**
     * Traces all the contents of `this.itemlist` following this scheme:
     * "source/resources/Inventory.hx:??: `item.code` -> `item.name` (`item.tier`) : `item.quantity`/`item.maxStack`"
     */
    public function trace_contents()
    {
        var i:Int = 0;
        for (k in itemlist) {
            if (k != null) {trace('${i} -> ${k.item.name} (${k.item.tier.toString}) : ${k.quantity} (stackable=${k.item.stackable})');}
            i++;
        }
    }

    /**
    * Traces all the contents of `this.index` following this scheme:
    * "source/resources/Inventory.hx:??: `item.code` -> `allocated slots list`"
    */
    public function trace_index()
    {
        for (k in index.keys()) {
            trace('${k} -> ${index[k]}');
        }
    }

    /**
     * Traces `this.index` and `this.itemlist`.
     */
    public function trace_all(index:Bool, contents:Bool)
    {
        trace('- inventory content -');
        if (index) {
            trace_index();
            trace('- - - - - - - - - - -');
        }
        if (contents) {
            trace_contents();
            trace('- - - - - - - - - - -');
        }
    }

    /**
     * DANGEROUS - CLEARS `this` INVENTORY, irreversibly removing ALL the `Item`s stored.
     */
    public function wipe()
    {
        itemlist = [];
        index = [];
        trace('INVENTORY WIPED');
    }

    /**
     * W.I.P. - do not use
     * Converts an `Inventory` to a `String` for easier storage in `flixel.FlxSave()`.
     * @param input  The `Inventory` instance to convert.
     * @return       The converted `String`.
     */
    public static function to_save_format(input:Inventory):String
    {
        var res:String = "";
        return res;
    }

    /**
     * W.I.P. - do not use
     * Converts a `String` created with `Inventory.to_save_format()` back to an `Inventory` object.
     * @param input  The `String` to convert back into an `Inventory`.
     * @return       The extracted `Inventory`
     */
    public static function from_save_format(input:String):Inventory
    {
        var res:Inventory = new Inventory();
        return res;
    }

    /**
     * Iterates through every code in `this.itemlist.keys()` to find out wether it contains `item._itemCode`.
     * @param item        The `Item` to search for.
     * @param registered  Wether to only check if the `item` is registered, not if it is actually present
     * @return            Wether `this.itemlist` contains  `item._itemCode`.
     */
    public function contains(item:Item):Bool
    {
        return index.exists(item._itemCode);
    }

    /**
     * Returns an `Int`eger, representing the position of
     * an entry for `item` in `this.itemlist`.
     */
    public function get_index(item:Item):Null<Int>
    {
        if (!index.exists(item._itemCode)) { return null; }
        final x:Null<Array<Null<Int>>> = index[item._itemCode];
        return x[x.length-1];
    }

    /**
     * Returns the last entry for `item` (`ItemStack`). If no entry is available, returns `null`.
     * @param item    The `Item` to search for.
     * @return        The `item` stack (if available).
     */
    public function get_entry(item:Item):Null<ItemStack>
    {
        return itemlist[get_index(item)];
    }
    
    /**
    * Returns all of the entries for `item` (`ItemStack`). If no entry is available, returns `null`.
    * @param item    The `Item` to search for.
    * @return        The `item` stack (if available).
    */
    public function get_all_entries(item:Item):Null<Array<ItemStack>>
    {
        final res:Null<Array<ItemStack>> = [];
        for (i in index[item._itemCode]) {
            res.push(itemlist[i]);
        }
        return res;
    }

    /**
     * Returns how many `item`s are stored in `this` Inventory
     * @param item    The item to search for.
     * @return        The quantity of `item`s.
     */
    public function get_quantity(item:Item):Int
    {
        var res:Int = 0;
        if (index.exists(item._itemCode)) {
            for (i in get_all_entries(item)) {
                res += i.quantity;
            }
        } else { res = 0; }
        return res;
    }

    /**
     * Adds all the `Item`s in `list` to `this` Inventory.
     * If you only need to add one type of item, please use `add_item()` instead, as
     * this function loops through the array and `Inventory.itemlist` and could negatively
     * impact the performance.
     * @param list    The `Array` of items to add.
     */
    public function add_items(list:Array<ItemStack>)
    {
        for (stack in list) {
            add_item(stack.item, stack.quantity);
        }
    }

    /**
     * Converts `item` to an `ItemStack`, then adds it to `this` inventory.
     * If another entry with the same `_itemCode` is present, increments the entry's `quantity` instead.
     * @param item      The `Item` to add.
     * @param quantity  The number (`Int`) of `item`s to add. If unspecified, 1 `item` is added.
     * @return          The updated quantity.
     */
    public function add_item(item:Item, ?quantity:Int = 1)
    {
        if (!contains(item)) {                                // IF item does NOT already have a position
            final pos:Int = itemlist.length;                  // get the last position in the list
            itemlist.insert(pos, new ItemStack(item, 0));     // use that as the item's position
            index[item._itemCode] = [];                       // map the item code to an array (register the item in this inventory)
            index[item._itemCode].push(pos);                  // add the new index to the array (register the index)
            //trace('allocated index ${pos} for item ${item.name}');
        }                                                     // NOW THE ITEM IS SURE TO HAVE A POSITION REGISTERED
        //trace('target for insertion: [${get_index(item)} : ${get_entry(item).item.name} x${get_entry(item).quantity}]');
        if (item.stackable) {                                 // IF the item is stackable
            //trace('- piling up ${item.name} -');
            itemlist[get_index(item)].quantity += quantity;   // increase the quantity of the already existing stack
        } else {                                              // ELSE (item is not stackable)
            //trace('- overstacking ${item.name} -');
            for (i in 0...quantity) {                         // repeat for every item to add:
                var pos:Int = get_index(item) + 1;            // create a new position
                while (itemlist[pos] != null) { pos++; }      // make sure the index is not already registered
                index[item._itemCode].push(pos);              // add the new index to the array (register the index)
                itemlist.insert(pos, new ItemStack(item, 1)); // insert 1 item at the newly registered index
            }
        }
        //trace_all(true, true);
    }

    /**
     * Removes all the `Item`s in `list` from `this` Inventory.
     * If you only need to remove one type of item, please use `remove_item()` instead, as
     * this function loops through the array and `Inventory.itemlist` and could negatively
     * impact the performance.
     * Before subtracting, the function checks if all the items in `list` are contained in
     * `this` Inventory. If any of the `Item`s has insufficient `quantity`, the function
     * aborts and returns `false`. Otherwise, the `Item`s are subtracted and `true` is returned.
     * @param list    The `Array` of items to remove.
     * @return        (`Bool`) Wether the items were subtracted or not.
     */
    public function remove_items(list:Array<ItemStack>, ?allow_negative:Bool = false):Bool
    {
        if (allow_negative) {
            trace('allow_negative is true (avc: ${allow_negative}), skipping quantity check');
        } else {
            for (stack in list) {
                final qt = get_quantity(stack.item);
                trace('removal info: [available: ${qt}/${stack.quantity}]');
                if (!(qt >= stack.quantity)) { trace('returning false'); return false; }
                trace('passed');
            }
        }
        for (stack in list) {
            trace('removing ${stack.item.name}...');
            remove_item(stack.item, stack.quantity, allow_negative);
        }
        return true;
    }

    /**
     * Removes `item`s from the corresponding `ItemStack` in `this` inventory.
     * @param item            The `Item` type to remove.
     * @param quantity        The number of `Item`s to remove.
     *                        If `quantity` is greater than the number of `item`s, behaves according to `allow_negative`.
     * @param allow_negative  In case the `quantity` to remove is greater than the number of `item`s available: wether to proceed anyway (resulting in a negative quantity).
     *                        If `false`, blocks the operation and returns `false` (so, for example, a purchase can be denied).
     * @return                `true` if the item was removed, `false` if not.
     */
    public function remove_item(item:Item, ?quantity:Int = 1, ?allow_negative:Bool = false):Bool
    {
        //trace('target stack for subtraction: [${get_index(item)} : ${get_entry(item).item.name} x${get_entry(item).quantity}]');
        if (get_quantity(item) >= quantity) {                 // IF its quantity is enough for a subtraction
            itemlist[get_index(item)].quantity -= quantity;   // subtract
            if (get_entry(item).quantity == 0) {              // IF the new quantity is 0
                itemlist[get_index(item)] = null;             // un-register the item from itemlist
                index.remove(item._itemCode);                 // un-register the item from index
            }
            //trace_all(true, false);
            return true;                                      // return true (e.g. complete transaction)
        } else if (allow_negative) {                          // ELSE if the quantity is insufficient BUT negative value is allowed
            if ([[], null].contains(get_all_entries(item))) {add_item(item, 0);} // IF quantity was insufficient because it was null, create an empty stack
            itemlist[get_index(item)].quantity -= quantity;   // subtract
            //trace_all(true, false);
            return true;                                      // return true (e.g. complete transaction)
        } else {
            //trace('subtraction aborted');
            return false;                                     // ELSE (insufficient items && negative not allowed) return false (e.g. fail transaction)
        }
    }

    /**
     * Returns every item of type `type`.
     * @param type      The `Type` to search for.
     * @return          An `Array<ItemStack>` containing all the matching stacks found.
     */
    public function get_items_byType(type:Dynamic):Array<ItemStack>
    {
        var res:Array<ItemStack> = [];
        for (k in itemlist) {
            if (Std.isOfType(k.item, type)) // check the type
            {
                res.push(k); // if it matches, add the entry to the array
            }
        }
        return res;
    }
}

// CREATE THE MAIN INVENTORY
// this inventory will be used by the player to store their items
final _MAIN_INVENTORY:Inventory = new Inventory();