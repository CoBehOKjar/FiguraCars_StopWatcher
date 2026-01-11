local state = require("state")
local util = require("lib.utilities")

local Sync = {}

local cfg = state.Config
local data = state.Data
local stgs = state.Settings

local signalCounter = 0


local function syncTime(hostTime)
    local localTime = world.getTime()
    if math.abs(hostTime - localTime) > 10 then
        return hostTime
    else
        return localTime
    end
end


local function applySignal(signal, hostTime, tick, paused)
    local time = hostTime ~= nil and syncTime(hostTime) or world.getTime()

    if signal == "start" then
        data.isClocking = true

        if data.isPaused then
            data.currentTime = tick
            print("Resumed")
        else
            data.currentTime = data.currentTime + (world.getTime() - time) or tick
            print("Started")
        end

        data.isPaused = false

    elseif signal == "pause" then
        if not data.isClocking then return end
        data.isPaused = paused == true
        data.currentTime = tick
        print("Paused")

    elseif signal == "stop" then
        data.isClocking = false
        data.isPaused = false
        data.currentTime = 0
        print("Stopped")
    end
end



function pings.sync(signals)
    avatar:store("SWNet", signals)
end



function Sync.send(signal)
    if stgs.roleIndex ~= 1 then return end

    signalCounter = signalCounter + 1

    pings.sync({
        senderRole = 1,
        signal = signal,
        paused = data.isPaused,
        time = world.getTime(),
        tick = data.currentTime,
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
            print("Synced")

            if stgs.roleIndex == 2 then
                applySignal(net.signal, net.time, net.tick, net.paused)
                print(
                    "Synced. ID "..tostring(net.id)..
                    "\nTime: "..tostring(net.time).." | "..tostring(world.getTime())..
                    "\nTick: "..tostring(net.tick).." | "..tostring(data.currentTime)
                )
            end
            break
        end

        ::continue::
    end
end


return Sync