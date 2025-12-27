local state = require("state")
local render = require("ui.render")

local Stopwatch = {}

local data = state.Data
local cbx = data.checkBox


local function formatTime(ticks)
    local sec = ticks / 20
    return math.floor(sec / 60), math.floor(sec % 60)
end



function Stopwatch.isInside(pos, targetBox)
    local b = targetBox or cbx
    return  pos.x >= b[1].x and pos.x <= b[2].x
    and     pos.y >= b[1].y and pos.y <= b[2].y
    and     pos.z >= b[1].z and pos.z <= b[2].z
end



function Stopwatch.tick()
    if not data.isClocking then return end

    data.inCheckBox = Stopwatch.isInside(player:getPos())

    if data.inCheckBox and not data.wasInCheckBox then
        local lM, lS = formatTime(data.currentTime - data.lastTime)
        local tM, tS = formatTime(data.currentTime)

        print(string.format("§fLap §6%d §ftime: §a%dm%ds. §fTotal: §b%dm%ds.", 
              data.currentLap, lM, lS, tM, tS))

        data.lastTime = data.currentTime
        data.currentLap = data.currentLap + 1
    end

    data.wasInCheckBox = data.inCheckBox
    data.currentTime = data.currentTime + 1
end

return Stopwatch