local state = require("state")
local racist = require("obj.racist")

local Setup = {}

local cfg = state.Config
local data = state.Data


local function loadTriggerBoxes()
    local boxes = {}
    local track = cfg.TRACK

    for index, sector in ipairs(track.sectors) do
        boxes[#boxes + 1] = {
            type = "sector_in",
            sector = index,
            id = sector.id,
            box = sector.inBox,
        }

        boxes[#boxes + 1] = {
            type = "sector_out",
            sector = index,
            id = sector.id,
            box = sector.outBox,
        }
    end

    boxes[#boxes + 1] = {
        type = "finish",
        id = track.finish.id,
        box = track.finish.box,
    }

    boxes[#boxes + 1] = {
        type = "pit_in",
        id = track.pitStop.id,
        box = track.pitStop.inBox,
    }

    boxes[#boxes + 1] = {
        type = "pit_out",
        id = track.pitStop.id,
        box = track.pitStop.outBox,
    }

    data.race.boxes = boxes
end


local function loadRacists()
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


function Setup.init()
    loadRacists()
    loadTriggerBoxes()
end

return Setup