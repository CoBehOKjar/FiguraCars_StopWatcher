local state = require("state")
local racist = require("obj.racist")

local Setup = {}

local cfg = state.Config
local data = state.Data

function Setup.init()
    for _, team in ipairs(cfg.TEAMS) do
        for _, rcr in ipairs(team.racists) do
            local racer = racist.add(
                rcr.name,
                team.id,
                rcr.role
            )

            data.race.racists[rcr.name] = racer
        end
    end
end

return Setup