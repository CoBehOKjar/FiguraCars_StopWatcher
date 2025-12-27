local state = require("state")
local render = require("ui.render")

local Stopwatch = {}

local data = state.Data
local cbx = data.checkBox
local track = state.Config.TRACK


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
    if data.renderBox and data.isCheckBoxCreated and world.getTime() % 10 == 0 then
        local zones = {}
        if track.sectors then
            for _, s in pairs(track.sectors) do 
                if s.inBox then table.insert(zones, s.inBox) end
                if s.outBox then table.insert(zones, s.outBox) end
            end
        end

        if track.finish and track.finish.box then table.insert(zones, track.finish.box) end
        
        if track.pitStop then
            if track.pitStop.inBox then table.insert(zones, track.pitStop.inBox) end
            if track.pitStop.outBox then table.insert(zones, track.pitStop.outBox) end
        end
        
        for _, z in ipairs(zones) do render.spawnEdgeParticles(z[1], z[2]) end
    end

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