local state = require("state")
local util = require("lib.utilities")

local Stopwatch = {}

local data = state.Data
local cfg = state.Config
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
    local rl = data.race.racists
    local bx = data.race.boxes
    
    for _, p in pairs(world.getPlayers()) do
        local name = p:getName()
        if not cfg.RACISTS[name] then goto continue end

        local racer = rl[name]
        if not racer then goto continue end


        for _, box in ipairs(bx) do
            if Stopwatch.isInside(p:getPos(), box.box) then
                racer.inCheckBox = true
                racer.currentTrigger = box.id
                break
            end
            racer.inCheckBox = false
        end


        if racer.inCheckBox and not racer.wasInCheckBox then
            local tM, tS = formatTime(data.currentTime - racer.pitTime)
            local sM, sS = formatTime(data.currentTime - racer.lastSegmentTime)
            local lM, lS = formatTime(data.currentTime - racer.lastLapTime)

            if racer.currentTrigger == "F1" then
                print(string.format("Lap §6%d: §b%dm%ds. Total time: §b%dm%ds.",
                    racer.lap, lM, lS, tM, tS))

                racer.lastLapTime = data.currentTime
                racer.lastSegmentTime = data.currentTime
                racer.lap = racer.lap + 1

            elseif racer.currentTrigger == "P1" and racer.lastTrigger == "P1" then
                print(string.format("Pit time: §b%dm%ds.",
                    sM, sS))
                print(string.format("Lap §6%d: §b%dm%ds. Total time: §b%dm%ds.",
                    racer.lap, lM, lS, tM, tS))

                racer.pitTime = racer.pitTime + (data.currentTime - racer.lastSegmentTime)
                racer.lastSegmentTime = data.currentTime
                racer.lastLapTime = data.currentTime
                racer.lap = racer.lap + 1

            else
                print(string.format("Sector §6%s - %s§f: §b%dm%ds.", 
                    racer.lastTrigger, racer.currentTrigger, sM, sS))

                racer.lastSegmentTime = data.currentTime
            end            
        end

        racer.lastTrigger = racer.currentTrigger
        racer.wasInCheckBox = racer.inCheckBox

        ::continue::
    end


    data.currentTime = data.currentTime + 1
end

return Stopwatch