
local protocol = "RMOD"

local function lookup(host)
    local servers = {rednet.lookup(protocol, host)}
    local s = servers[1]
    print("Found "..host.." server at #"..s)
    return s
end

local function sendRequestAndAwaitResponse(recipientID, request, timeout)
    rednet.send(recipientID, request, protocol)

    local id, response
    repeat
        id, response, _ = rednet.receive(protocol, timeout or 10)
    until id==recipientID or id==nil

    if not id then printError("Response timed out") end
    return response
end


local function runModule(m)
    local f = load(m)
    if not f then printError("Module is nil"); return false end
    return f()
  end

--RMOD request
--{
--  module = "<name of the module to get>"
--  version = "<version number or nil to get the latest one>"
--}
local function requestModule(hostname, module, version)
    local serverID = lookup(hostname)

    local request = {
        module = module,
        version = version
    }
    local response = sendRequestAndAwaitResponse(serverID, request)
    if not library then printError("Module could not be obtained"); return nil end
    local library = runModule(response)

    if not library then printError("Module could not be run"); return nil
    else return library end
end


--Setup function - RUN BEFORE ANYTHING ELSE
local function setup()
    local modems = { peripheral.find("modem") }
    if #modems==0 then printError("No modem found"); return nil end
    for _, m in ipairs(modems) do
        rednet.open( peripheral.getName(m) )
    end
    print("All modems open")
end

setup()

return {
    get = requestModule
}
