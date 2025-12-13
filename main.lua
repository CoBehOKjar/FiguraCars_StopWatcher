local state = require("state")
local stopwatch = require("lib.stopwatch")
local action_wheel = require("ui.action_wheel")
local render = require("ui.render")

--*Entity initialization process
function events.entity_init()
    action_wheel.init()

end



--*Tick process
function events.tick()
    if not player:isLoaded() then return end
    render.tick()
    stopwatch.tick()
end