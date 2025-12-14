local state = require("state")
local stopwatch = require("core.stopwatch")
local action_wheel = require("ui.action_wheel")
local render = require("ui.render")

--*Entity initialization process
function events.entity_init()
    action_wheel.init()

    config:save("Racist", "CoBeHok")
end



--*Tick process
function events.tick()
    if not player:isLoaded() then return end
    stopwatch.tick()
end