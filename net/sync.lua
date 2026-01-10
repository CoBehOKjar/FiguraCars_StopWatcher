local state = require("state")
local util = require("lib.utilities")

local Sync = {}

local cfg = state.Config
local data = state.Data
local stgs = state.Settings

local signalCounter = 0


function pings.sync(signals)
    avatar:store("SWNet", signals)
end



function Sync.send(signal, time)
    if state.Settings.roleIndex ~= 1 then return end

    signalCounter = signalCounter + 1

    pings.sync({
        senderRole = state.Settings.roleIndex,
        signal = signal,
        time = time,
        id = signalCounter
    })
end



function Sync.tick()
    if stgs.roleIndex ~= 1 then
        for _, p in pairs(world.avatarVars()) do
            if p.SWNet.role == 1 and p.SWNet.id > data.lastSignalId then
                pings.sync(p)
            end
        end
    end
end

return Sync