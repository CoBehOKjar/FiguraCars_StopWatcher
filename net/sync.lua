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
    if stgs.roleIndex == 1 then return end

    for _, p in pairs(world.avatarVars()) do
        local net = p.SWNet
        if not net then goto continue end

        if net.senderRole == 1
        and net.id
        and net.id > data.lastSignalId then

            data.lastSignalId = net.id
            pings.sync(net)
            break
        end

        ::continue::
    end
end


return Sync