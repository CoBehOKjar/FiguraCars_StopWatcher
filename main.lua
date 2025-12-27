local state = require("state")
local racist = require("obj.racist")

local setup = require("core.setup")
local stopwatch = require("core.stopwatch")

local util = require("lib.utilities")
local wand = require("lib.wand")

local action_wheel = require("ui.action_wheel")
local render = require("ui.render")


local ihost = host:isHost()


--*Entity initialization process
function events.entity_init()
    if not ihost then return end
    action_wheel.init()
    setup.init()
end



--*Tick process
function events.tick()
    if not player:isLoaded() or not ihost then return end
    stopwatch.tick()
    wand.tick()
end