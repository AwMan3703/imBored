--© Aw_Man3703

--info
local i_name = 'GUI.lua'
local i_version = '1.6.1'
local i_modversion = '1.19.2-1.101.1'
local i_author = 'Aw_Man3703'
local i_credit = '@Aw_Man3703 (Twitter/Instagram)'
local i_description = 'Graphic library for CraftOs (CC:Tweaked v'..i_modversion..')'

--configuration, default and utilities
local objects_path = 'Aw_Man3703.gui.'
local id_counter = 0
local utils = {
    --import needed cc libraries
    strings = require("cc.strings"),
    expect = require("cc.expect"),
    --not a cc function but handy to have it here
    table_lentgth = function (tab)
                        if type(tab)~='table' then error('can only count table values (provided type:'..type(tab)..')', 1) end
                        local c = 0
                        for k, v in pairs(tab) do
                            c = c+1
                        end
                        return c
                    end,
    create_id_str = function (obj)
                        id_counter = id_counter+1
                        return '<'..objects_path..obj..':'..id_counter..'>'
                    end
}
local default_data = {
    invalidBitmap = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 1, 1, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 1, 1, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1},
    }
}

--scene and updating
local Current_Scene = {}
local stop_flag = false
local update_iterations = 0

local function resetColors()
    --reset foreground/background colors
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
end

local function wipeScreen()
    --delete everything from the screen
    resetColors()
    term.clear()
end

local function resetEnvironment()
    --reset everything lmao
    Current_Scene = {}
    update_iterations = 0
    resetColors()
    term.clear()
end

local function updateElement(data)
    utils.expect.expect(1, data, 'table')

    --reset the colors to avoid dirty brush rendering
    resetColors()

    --if element has style or a custom bitmap, update it
    if type(data.custombitmap) == 'table' then
        local bitmap_pixels = data.custombitmap.pixels or default_data.invalidBitmap
        for y = 1, #bitmap_pixels do
            for x = 1, #bitmap_pixels[y] do
                if (bitmap_pixels[y][x] ~= 0) then
                    paintutils.drawPixel(x, y, bitmap_pixels[y][x])
                end
            end
        end
    --otherwise, it must have procedurally generating style, draw it
    elseif type(data.style) == 'table' then
        local ex = (data.style.x or 1) + (data.style.w or 1)
        local ey = (data.style.y or 1) + (data.style.h or 1)
        if data.style.colorFill then
            paintutils.drawFilledBox(data.style.x or 1, data.style.y or 1, ex, ey, data.style.colorFill or colors.gray)
        end
        if data.style.colorBorder then
            paintutils.drawBox(data.style.x or 1, data.style.y or 1, ex, ey, data.style.colorBorder or colors.lightGray)
        end
    end

    --if element has text content, update it
    if type(data.content) == 'table' then
        local text_lines = utils.strings.wrap(""..data.content.text or "", data.content.style.w or data.style.w or 1)
        local posX = data.content.style.x or data.style.x or 1
        local posY = data.content.style.y or data.style.y or 1
        term.setTextColor(data.content.style.colorFg or colors.white)
        term.setBackgroundColor(data.content.style.colorBg or data.style.colorFill or colors.gray)
        term.setCursorPos(posX, posY)
        for i = 1, #text_lines do
            local line = text_lines[i]
            term.write(line)
            term.setCursorPos(posX, posY+i)
        end
    end
end

local function updateScene(scene)
    utils.expect(1, scene, "table")

    --reset rendering
    resetColors()
    term.clear()

    --run pre-update tasks
    for i = 1, #scene.update_tasks.pre do
        scene.update_tasks.pre[i]()
    end
    --update every element
    for _, data in pairs(scene.elements) do
        updateElement(data)
    end
    --run post-update tasks
    for i = 1, #scene.update_tasks.post do
        scene.update_tasks.post[i]()
    end
    --increment iterations count
    update_iterations = update_iterations + 1
end

local function awaitNextEvent()
    local evdata = {os.pullEvent()}
    local evname = evdata[1]

    for _, element in pairs(Current_Scene.elements) do
        if (not element.events) or element.events=={} or element.events[evname]==nil then --[[ignore]]
        else element.events[evname](table.unpack(evdata)) --[[run callback]] end
    end

    return true
end

local function mkBitmapElement(x, y, bitmap)
    utils.expect(1, x, "number", "nil")
    utils.expect(2, y, "number", "nil")
    utils.expect(3, bitmap, "table", "nil")
    return {
        custombitmap = {
            x = x or 1,
            y = y or 1,
            pixels = bitmap or default_data.invalidBitmap
        }
    }
end

local function mkGenericElement(x, y, w, h, text, textX, textY, colorFg, colorBg, colorFill, colorBorder, events)
    utils.expect(1, x, "number", "nil")
    utils.expect(2, y, "number", "nil")
    utils.expect(3, w, "number", "nil")
    utils.expect(4, h, "number", "nil")
    utils.expect(5, text, "string", "nil")
    utils.expect(6, textX, "string", "nil")
    utils.expect(7, textY, "string", "nil")
    utils.expect(8, colorFg, "number", "nil")
    utils.expect(9, colorBg, "number", "nil")
    utils.expect(10, colorFill, "number", "nil")
    utils.expect(11, colorBorder, "number", "nil")
    utils.expect(12, events, "table", "nil")
    return {
                content = {
                    text = text or "",
                    style = {
                        x=(x or 1)+(textX or 0),
                        y=(y or 1)+(textY or 0),
                        colorFg=colorFg or colors.white,
                        colorBg=colorBg or colors.gray
                    }
                },
                style = {
                    x=x or 1,
                    y=y or 1,
                    w=w or 5,
                    h=h or 4,
                    colorFill=colorFill,
                    colorBorder=colorBorder
                },
                events = events or {}
            }
end

local function mkButton(x, y, w, h, text, colorFg, colorBg, callback)
    utils.expect(1, x, "number", "nil")
    utils.expect(2, y, "number", "nil")
    utils.expect(3, w, "number", "nil")
    utils.expect(4, h, "number", "nil")
    utils.expect(5, text, "string", "nil")
    utils.expect(6, colorFg, "number", "nil")
    utils.expect(7, colorBg, "number", "nil")
    utils.expect(8, callback, "function", "nil")
    return {
                content = {
                    text = text or "",
                    style = {
                        x = x or 1,
                        y = y or 1,
                        w = w or 15,
                        h = h or 7,
                        colorFg=colorFg or colors.white,
                        colorBg=colorBg or colors.gray
                    }
                },
                events = {
                    ["mouse_up"] = function (ev, btn, mx, my)
                            --check if the button was clicked
                            local inx = mx>=( x or 1) and mx<=(w or 15)+(x or 1)-1
                            local iny = my>=(y or 1) and my<=(h or 7)+(y or 1)-1
                            if inx and iny then
                                if callback then callback()
                                else print('['..text..'] button clicked') end
                            end
                        end
                }
            }
end

local function mkTextSquare(x, y, w, h, text, textColor, colorFill, colorBorder)
    utils.expect(1, x, "number", "nil")
    utils.expect(2, y, "number", "nil")
    utils.expect(3, w, "number", "nil")
    utils.expect(4, h, "number", "nil")
    utils.expect(5, text, "string", "nil")
    utils.expect(6, textColor, "number", "nil")
    utils.expect(7, colorFill, "number", "nil")
    utils.expect(8, colorBorder, "number", "nil")
    return {
                content = {
                    text = text or "",
                    style = {
                        colorFg=textColor or colors.white,
                        colorBg=colorFill or colors.gray
                    }
                },
                style = {
                    x=x,
                    y=y,
                    w=w,
                    h=h,
                    colorFill=colorFill,
                    colorBorder=colorBorder
                }
            }
end

local function mkSquare(x, y, w, h, colorFill, colorBorder)
    utils.expect(1, x, "number", "nil")
    utils.expect(2, y, "number", "nil")
    utils.expect(3, w, "number", "nil")
    utils.expect(4, h, "number", "nil")
    utils.expect(5, colorFill, "number", "nil")
    utils.expect(6, colorBorder, "number", "nil")
    return {
                style = {
                    x=x,
                    y=y,
                    w=w,
                    h=h,
                    colorFill=colorFill,
                    colorBorder=colorBorder
                }
            }
end

local function mkText(x, y, w, h, text, colorFg, colorBg)
    utils.expect(1, x, "number", "nil")
    utils.expect(2, y, "number", "nil")
    utils.expect(3, w, "number", "nil")
    utils.expect(4, h, "number", "nil")
    utils.expect(5, text, "string", "nil")
    utils.expect(6, colorFg, "number", "nil")
    utils.expect(7, colorBg, "number", "nil")
    return {
                content = {
                    text = text or "",
                    style = {
                        x=x or 1,
                        y=y or 1,
                        w=w or 1000,
                        h=h or 1000,
                        colorFg=colorFg or colors.white,
                        colorBg=colorBg or colors.gray
                    }
                }
            }
end

local function createScene()
    --return an empty scene
    return {
        id = utils.create_id_str('sceneObject'),
        elements_count = 0,
        elements = {},
        update_tasks = {
            pre = {},
            post = {}
        }
    }
end

local function addElementToScene(scene, element)
    utils.expect.expect(1, scene, 'table')
    utils.expect.expect(2, element, 'table')
    element.id = utils.create_id_str('elementObject')
    scene.elements[element.id] = element
    scene.elements_count = scene.elements_count + 1
    return element.id
end

local function removeElementFromScene(scene, element_id)
    utils.expect.expect(1, scene, 'table')
    utils.expect.expect(2, element_id, 'string')
    scene.elements[element_id] = nil
    return element_id
end

local function setScene(data)
    utils.expect.expect(1, data, 'table')
    resetEnvironment()
    Current_Scene = data
    return true
end

local function getSceneDetails(scene)
    utils.expect(1, scene, "table", "nil")
    if not scene then scene = Current_Scene end

    return {
        id = scene.id,
        update_tasks_count = #scene.update_tasks.pre + #scene.update_tasks.post,
        elements_count = utils.table_lentgth(scene.elements),
        update_iterations = update_iterations
    }
end

local function addUpdateTask_bf(scene, task)
    utils.expect.expect(1, scene, 'table')
    utils.expect.expect(2, task, 'function')
    table.insert(scene.update_tasks.pre, task)
    return scene
end

local function addUpdateTask_af(scene, task)
    utils.expect.expect(1, scene, 'table')
    utils.expect.expect(2, task, 'function')
    table.insert(scene.update_tasks.post, task)
    return scene
end

local function start()
    --while cycle is not suppressed, keep updating
    while not stop_flag do
        updateScene(Current_Scene)
        awaitNextEvent()
    end
    term.clear()
end

local function exit()
    --check that callback type is function or nothing
    utils.expect(1, callback, "function", "nil")

    --stop everything
    resetEnvironment()
    stop_flag = true
end

local fgoc = term.getTextColor()
term.setTextColor(colors.green)
print('\n[', i_author, '/', i_name, 'v'..i_version, 'loading complete ]\n')
term.setTextColor(fgoc)

--return the library
return {
    info = { --information about the library
        name = i_name,
        author = i_author,
        credit = i_credit,
        description = i_description,
        version = i_version,
        cc_version = i_modversion
    },
    lab = { --element/scene building functions
        elements = {
            mkGenericElement = mkGenericElement,
            mkButton = mkButton,
            mkBitmapElement = mkBitmapElement,
            mkTextSquare = mkTextSquare,
            mkSquare = mkSquare,
            mkText = mkText
        },
        scenes = {
            createScene = createScene,
            addElementToScene = addElementToScene,
            removeElementFromScene = removeElementFromScene,
            addPreUpdateTask = addUpdateTask_bf,
            addPostUpdateTask = addUpdateTask_af
        }
    },
    runtime = { --runtime management interface
        start = start,
        exit = exit,
        setScene = setScene,
        getSceneDetails = getSceneDetails,
        getCurrentScene = function() return Current_Scene end
    },
    rendering = { --rendering interface
        resetColors = resetColors,
        wipe = wipeScreen
    }
}


