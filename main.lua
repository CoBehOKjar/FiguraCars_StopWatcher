--TODO синхронизация через время суток в кубах
local state = require("state")
local setup = require("core.setup")
local stopwatch = require("core.stopwatch")
local send = require("net.send")

local wand = require("lib.wand")
local util = require("lib.utilities")

local action_wheel = require("ui.action_wheel")


local ihost = host:isHost()


--*Entity initialization process
function events.entity_init()
    if not ihost then return end
    action_wheel.init()
    setup.init()
    --util.tprint(state.Data.race)
end



--*Tick process
function events.tick()
    if not player:isLoaded() or not ihost then return end
    stopwatch.tick()
    wand.tick()
    send.tick()
end