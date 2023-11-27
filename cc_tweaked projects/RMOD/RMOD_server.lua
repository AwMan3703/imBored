
local hostname = "mymodule.rmod"
local RMOD_path = "RMOD/"

local serverAPI = require("serverAPI")

--RMOD modules are saved as "<RMOD_path>/<module_name>/<version>.lua"
local function module_path(modName, modVersion)
    return modName.."/"..modVersion..".lua"
end

local function msgHandler(id, msg)

    
    
end

local function setup()
    
end

local function start()
    
end

return {
    setup = setup,
    start = start,
}
