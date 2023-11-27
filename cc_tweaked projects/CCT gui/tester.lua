--testing gui.lua

--utility
local files_list = {
    'index.gui',
    'pages.group',
    'events.lua',
    'rednetInterface.lua',
    'helper.gui',
    'gui.manifest',
    'permissions.json'
}
local file_items = {}

--import the library
local gui = require('gui')

--create a new scene
local menu = gui.lab.scenes.createScene()
local editor = gui.lab.scenes.createScene()

--elements for menu scene
local function btn_newFile_cb() gui.runtime.setScene(editor) end
local btn_newFile = gui.lab.elements.mkButton(3, 3, 10, 2, "          \n new file \n          ", nil, colors.blue, btn_newFile_cb)
local function btn_quit_cb() gui.runtime.exit() end
local btn_quit = gui.lab.elements.mkButton(3, 18, 6, 1, "<exit>", nil, colors.red, btn_quit_cb)
local function btn_erase_cb() files_list = {} end
local btn_erase = gui.lab.elements.mkButton(10, 18, 7, 1, "<erase>", nil, colors.red, btn_erase_cb)
--elements for editor scene
local function btn_back_cb() gui.runtime.setScene(menu) end
local btn_back = gui.lab.elements.mkButton(1, 1, 6, 1, ' back ', nil, nil, btn_back_cb)

--add the elements to the scenes, retrieving the ids
--menu
btn_newFile = gui.lab.scenes.addElementToScene(menu, btn_newFile)
btn_quit = gui.lab.scenes.addElementToScene(menu, btn_quit)
btn_erase = gui.lab.scenes.addElementToScene(menu, btn_erase)
--editor
btn_back = gui.lab.scenes.addElementToScene(editor, btn_back)

--add a pre and post-update task to the menu scene
gui.lab.scenes.addPreUpdateTask(menu,
    function ()
        for _, v in ipairs(file_items) do
            gui.lab.scenes.removeElementFromScene(gui.runtime.getCurrentScene(), v)
        end
        local colorSwitch = false
        for i, v in ipairs(files_list) do
            colorSwitch = not colorSwitch
            local strlen = string.len(v)
            local suffix = string.upper(v:sub(v:find(".", 1, true)+1, strlen)).." file ->"
            local sfxlen = string.len(suffix)
            local totallen = 40
            local file_item = gui.lab.elements.mkText(6, 7+i, 100, 1, v..""..string.rep(' ', totallen-strlen-sfxlen)..suffix, nil, colorSwitch and colors.lightGray or colors.gray)
            table.insert(file_items, gui.lab.scenes.addElementToScene(menu, file_item))
        end
    end
)
gui.lab.scenes.addPostUpdateTask(menu,
    function ()
        local d = gui.runtime.getSceneDetails()
        term.setCursorPos(1, 1)
        term.setTextColor(colors.white)
        term.setBackgroundColor(colors.black)
        print('GUI.lua v'..gui.info.version, '- element count in scene:', d.elements_count)
    end
)

--set the scene as active
gui.runtime.setScene(menu)

--clear the screen
gui.rendering.wipe()

--launch
gui.runtime.start()

