--copyright ©Aw_Man3703 2023
--Pandora Vault Manager--
--[[
    Single-script program, allows to manage an inventory so that
    multiple players can deposit items inside and not have them mix.
    Each player can access their items with a bank card, no player
    can access others' properties.
]]

--<command-line-args>
local args = {...}
--</command-line-args>

--<config>
local debug_mode = true
local vault_position_name = 'create:item_vault'
local interface_position_name = 'minecraft:barrel'
local drive_position_name = 'drive'
local data_location = 'data/data_table.txt'
--</config>

--references
local vault = nil
local interface = nil
local drive = nil

local data_table = nil
local item_blacklist = {
    'create:toolbox',
    'create:white_toolbox',
    'create:orange_toolbox',
    'create:magenta_toolbox',
    'create:light_blue_toolbox',
    'create:yellow_toolbox',
    'create:lime_toolbox',
    'create:pink_toolbox',
    'create:gray_toolbox',
    'create:light_gray_toolbox',
    'create:cyan_toolbox',
    'create:purple_toolbox',
    'create:blue_toolbox',
    'create:brown_toolbox',
    'create:green_toolbox',
    'create:red_toolbox',
    'create:black_toolbox',
    'minecraft:shulker_box',
    'minecraft:white_shulker_box',
    'minecraft:orange_shulker_box',
    'minecraft:magenta_shulker_box',
    'minecraft:light_blue_shulker_box',
    'minecraft:yellow_shulker_box',
    'minecraft:lime_shulker_box',
    'minecraft:pink_shulker_box',
    'minecraft:gray_shulker_box',
    'minecraft:light_gray_shulker_box',
    'minecraft:cyan_shulker_box',
    'minecraft:purple_shulker_box',
    'minecraft:blue_shulker_box',
    'minecraft:brown_shulker_box',
    'minecraft:green_shulker_box',
    'minecraft:red_shulker_box',
    'minecraft:black_shulker_box',
    'minecraft:bundle'
}

--interface and language
local info = {
    name = 'Pandora',
    full_name = 'Pandora Multiplayer Vault Manager',
}
local lang = 'en'
local dictionary = {
    dict_file_not_found = '> file dictionary_'..lang..'.txt not found, using built-in dictionary...',
    error = '[Error]',
    error_disk_ejected = '[ Card ejected, terminating iteration. ]\nPlease re-insert the card to begin a new one.',
    error_peripheral_detached = '[ A PERIPHERAL HAS BEEN REMOVED FROM THE NETWORK, terminating iteration. ]\nPlease  reconnect all of the peripherals, then restart '..info.name..'.\nRemoved from position:',
    fatal_error = '[Fatal error]',
    generating_network = '> generating '..info.name..' network...',
    item_is_blacklisted = 'Could not move item as it is blacklisted.',
    iteration_complete = '- - - Iteration $f complete - - -',
    iteration_starting = '- - - Iteration $f starting - - -',
    loading_dictionary = '> setting up dictionary ('..lang..')...',
    moved_to_vault = 'moved to vault.',
    network_incomplete = 'Network incomplete. Missing components:',
    please_insert_card = '::: Please insert your bank card :::',
    setup_failed = 'Failed to setup '..info.name..' environment.',
    starting_loop = '> starting '..info.name..'...',
    static_file_not_found = '> static storage file not found, generating new table...',
    vault_is_full = 'Vault is full, no more items will be transferred.\nPlease request assistance.',
    welcome = 'Welcome to '..info.full_name
}

local function table_contains(t, v)
    for i = 1, #t do
        if t[i]==v then return true end
        return false
    end
end

local function has_an_empty_slot(inventory)
    local ls = inventory.list()
    for slot, content in pairs(ls) do
        if content.count==0 then return true end
    end
    return false
end

local function can_take_item(inventory, item_name)
    local ls = inventory.list()
    if has_an_empty_slot(inventory) then return true end

    for slot, content in pairs(ls) do
        local limit = inventory.getItemLimit(slot)
        if content.name==item_name and content.count<limit then
            --[[return:
                true (can take more items),
                the remaining space
            ]]
            return true, limit-content.count
        end
    end
    return false
end

local function contains_item(inventory, item_name)
    local ls = inventory.list()
    for slot, content in pairs(ls) do
        if content.name==item_name then
            return true, slot, content.count
        end
    end
    return false
end

local function save_data_to_static()
   local fh = fs.open(data_location, 'w')
   local text = textutils.serialize(data_table)
   fh.write(text)
   fh.close()
   return true
end

local function load_data_from_static()
    local fh = fs.open(data_location, 'r')
    if fh==nil then
        printError(dictionary.static_file_not_found)
        data_table = {}
        return false
    end
    local text = fh.readAll()
    fh.close()
    data_table = textutils.unserialize(text)
    return true
end

local function setup()
    print(dictionary.loading_dictionary)
    local dfh = fs.open('dictionary_'..lang..'.txt', 'r')
    if dfh then
        dictionary = dfh.readAll()
        dfh.close()
        dictionary = textutils.unserialize(dictionary)
    else
        print(dictionary.dict_file_not_found)
    end

    print(dictionary.generating_network)
    vault = peripheral.find(vault_position_name)
    interface = peripheral.find(interface_position_name)
    drive = peripheral.find(drive_position_name)
    if vault and interface and drive then
        return true --setup succeeded
    else
        local network_missing = {""}
        if not vault then table.insert(network_missing, '- 1x '..vault_position_name..' ('..tostring(vault)..')') end
        if not interface then table.insert(network_missing, '- 1x '..interface_position_name..' ('..tostring(interface)..')') end
        if not drive then table.insert(network_missing, '- 1x '..drive_position_name..' ('..tostring(drive)..')') end
        network_missing = table.concat(network_missing, "\n  ")
        printError(dictionary.fatal_error, dictionary.network_incomplete, network_missing)
        return false --setup failed
    end
end

local function items_to_vault()
    --interface -> vault
    for slot, item in pairs(interface.list()) do
        --check that there is free space in the vault. if not, break the loop.
        if not (#vault.list() < vault.size() or can_take_item(vault, item.name)) then
            printError(dictionary.vault_is_full)
            break
        end
        --check that the item to transfer is not blacklisted, if it is, refuse it.
        if table_contains(item_blacklist, item.name) then
            printError('> ('..slot..')', item.name..':', dictionary.item_is_blacklisted)
        else
            local moved = interface.pushItem(peripheral.getName(vault), slot, 64)
            print('>', item.name..':', moved, dictionary.moved_to_vault)
        end
    end
    --return wether all the items were transferred.
    return not has_an_empty_slot(interface)
end

local function items_from_vault(item_name, amount)
    --vault -> interface
    local is_available, item_slot, available = contains_item(vault, item_name)
    if is_available then
        local moved = vault.pushItem(peripheral.getName(interface), item_slot, 64)
        return is_available, math.max(0, amount-moved)--wether the items were pushed successfully, how many are missing
    else
        return false
    end
end

local function await_disk_insert()
    print(dictionary.please_insert_card)
    os.pullEvent('disk')
end

local function disk_eject_handler()
    local ev, side = os.pullEvent('disk_eject')
    printError(dictionary.error, dictionary.error_disk_ejected)
    return true
end

local function peripheral_detach_handler()
    local ev, side = os.pullEvent('peripheral_detach')
    printError(dictionary.fatal_error, dictionary.error_peripheral_detached, side)
    return true
end


local function main()
    print('\n\n')
    if drive.isDiskPresent() then drive.ejectDisk() end
    await_disk_insert()
    items_to_vault()
    items_from_vault('minecraft:cobblestone', 1)
    sleep(1)
    save_data_to_static()
end

--[[try to setup the environment,
if it fails, exit the program]]
if not (setup() or debug_mode) then
    printError(dictionary.fatal_error, dictionary.setup_failed)
    return false
end

load_data_from_static()
print(dictionary.starting_loop)
local iteration_count = 0
while true do
    iteration_count = iteration_count + 1

    print(string.format(dictionary.iteration_starting, iteration_count))

    parallel.waitForAny(main, disk_eject_handler, peripheral_detach_handler)

    print(string.format(dictionary.iteration_complete, iteration_count))
end





