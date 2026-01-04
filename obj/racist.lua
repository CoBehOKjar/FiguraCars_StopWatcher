local Racist = {}
Racist.__index = Racist

function Racist.add(playerName, teamId, role)
    return setmetatable({
        name = playerName,
        team = teamId,
        role = role,

        lap = 0,
        sector = nil,

        currentTrigger = "None",
        lastTrigger = "None",
        lastTriggerTick = 0,

        lastSegmentTime = 0,
        lastLapTime = 0,
        pitTime = 0,

        prevPos = nil,
        inPit = false,

        inCheckBox = false,
        wasInCheckBox = false,
    }, Racist)
end

return Racist