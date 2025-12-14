local Racist = {}
Racist.__index = Racist

function Racist.add(playerName, teamId, role)
    return setmetatable({
        name = playerName,
        team = teamId,
        role = role,

        lap = 0,
        sector = 0,

        lastTrigger = nil,
        lastTriggerTick = -999,

        totalTime = 0,
        pitTime = 0,

        prevPos = nil,
        inPit = false,
    }, Racist)
end
