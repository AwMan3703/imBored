--command line tool for rmod server management

local RMOD_path = "RMOD"
--RMOD modules are saved as "<RMOD_path>/<module_name>/<version>.lua"
local module_path = fs.combine(RMOD_path, "%s/%d.lua")
--RMOD metadata files are saved as "<RMOD_path>/<module_name>/meta.txt"
local metadata_path = fs.combine(RMOD_path, "%s/meta.txt")

--Output utility
local function colored_print(color, ...)
    local oldColor = term.getTextColor()
    term.setTextColor(color)
    print(...)
    term.setTextColor(oldColor)
end
local function log(str)
    colored_print(colors.gray, ("[RMOD] %s"):format(str))
end
local function warn(str)
    colored_print(colors.lightGray, ("[RMOD] %s"):format(str))
end

--Utility
local function removeFileExtension(p) return p:match("(.*)%..+") end

local function dashArgsTable(argList, p)
    --convert { "-a", "argA", "-b", "argB", "argC", "-c", "argD" }
    --into { ["a"] = {"argA"}, ["b"] = {"argB", "argC"}, ["c"] = {"argD"} }
    local prefix = p or "-"
    local res = {}
    local args = {}
    local index = prefix.."-"
    for _, e in ipairs(argList) do
        if e:sub(1, #prefix)==prefix then
            res[index] = args
            index = e:sub(#prefix+1, #e)
            args = {}
        else
            table.insert(args, e)
        end
        res[index] = args
    end

    return res
end

local function getLatestVersion(module)
    local path = fs.combine(RMOD_path, module)
    local highest = -1
    for _, f in ipairs(fs.list(path)) do
        local n = tonumber(removeFileExtension(f))
        if n and n > highest then highest = n end
    end
    return highest
end

local function setMeta(module, meta)
    local path = metadata_path:format(module)
    
    local fh = fs.open(path, "w")
    fh.write(textutils.serialize(meta))
    fh.close()
end

local function getMeta(module)
    local path = metadata_path:format(module)
    
    local fh = fs.open(path, "r")
    local meta = textutils.unserialize(fh.readAll())
    fh.close()
    
    return meta
end

local function updateMeta(module)
    local path = metadata_path:format(module)
    
    if not fs.exists(path) then setMeta(module, { latest_version = -1 }) end
    
    local fh = fs.open(path, "w")
    local meta = {
        latest_version = getLatestVersion(module)
    }
    fh.write(textutils.serialize(meta))
    log(("latest %s version is now %d"):format(module, meta.latest_version))
    fh.close()
end

--create shell commands to manage module versions
local function shell_command(argList)
    local args = dashArgsTable(argList)

    local actions = {
        --Save "dev/testing.lua" as version 1.0 of mymodule:
        --rmod push -p dev/testing.lua -m mymodule -v 1.0
        ["push"] = function()
            fs.copy(args["p"][1], module_path:format(args["m"][1], args["v"][1]))
            log(("%s pushed as version %d of %s"):format(args["p"][1], args["v"][1], args["m"][1]))
            updateMeta(args["m"][1])
        end,
        --Delete version 0.3 of somemodule
        --rmod delete -m mymodule -v 0.3
        ["delete"] = function()
            fs.delete(module_path:format(args["m"][1], tonumber(args["v"][1])))
            log(("version %d of %s deleted"):format(args["v"][1], args["m"][1]))
            updateMeta(args["m"][1])
        end
    }

    actions[args["--"][1]]()
end


shell_command(arg)
