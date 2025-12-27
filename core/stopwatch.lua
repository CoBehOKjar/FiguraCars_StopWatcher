local state = require("state")

local Stopwatch = {}

local data = state.Data
local cfg = state.Config
local cbx = data.checkBox
local rl = data.race.racists


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

    for _, p in pairs(world.getPlayers()) do
        local name = p:getName()
        if not cfg.RACISTS[name] then goto continue end

        local racer = rl[name]
        if not racer then goto continue end

        racer.inCheckBox = Stopwatch.isInside(p:getPos())

        if racer.inCheckBox and not racer.wasInCheckBox then
            local tM, tS = formatTime(data.currentTime)

            print(string.format("§fLap §6%d §fTotal: §b%dm%ds.", 
                racer.lap, tM, tS))

            racer.lap = racer.lap + 1
            
        end

        racer.wasInCheckBox = racer.inCheckBox

        ::continue::
    end


    data.currentTime = data.currentTime + 1
end

return Stopwatch