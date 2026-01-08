local Racist = {}
Racist.__index = Racist

function Racist.add(playerName, teamId, role)
    return setmetatable({
        name = playerName,
        team = teamId,
        role = role,

        prevPos = nil,

        inCheckBox = false,
        wasInCheckBox = false,
        currentTrigger = nil,
    }, Racist)
end

return Racist