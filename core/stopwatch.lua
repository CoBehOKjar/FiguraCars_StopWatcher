local state = require("state")
local send = require("net.send")

local Stopwatch = {}

local sdata = state.Data
local cfg = state.Config
local stgs = state.Settings
local cbx = sdata.checkBox



function Stopwatch.isThrough(p1, p2, box)
    local min = box[1]
    local max = box[2]

    local tmin = 0
    local tmax = 1

    local function axisCheck(p, d, minB, maxB)
        if math.abs(d) < 1e-6 then
            return p >= minB and p <= maxB
        end
        local ood = 1 / d
        local t1 = (minB - p) * ood
        local t2 = (maxB - p) * ood
        if t1 > t2 then t1, t2 = t2, t1 end
        tmin = math.max(tmin, t1)
        tmax = math.min(tmax, t2)
        return tmin <= tmax
    end

    local d = p2 - p1
    return axisCheck(p1.x, d.x, min.x, max.x)
       and axisCheck(p1.y, d.y, min.y, max.y)
       and axisCheck(p1.z, d.z, min.z, max.z)
end



function Stopwatch.isInside(pos, targetBox)
    local b = targetBox or cbx
    return  pos.x >= b[1].x and pos.x <= b[2].x
    and     pos.y >= b[1].y and pos.y <= b[2].y
    and     pos.z >= b[1].z and pos.z <= b[2].z
end



function Stopwatch.tick()
    if not sdata.isClocking or sdata.isPaused or stgs.roleIndex == 3 then return end

    local bx = sdata.race.boxes

    for _, p in pairs(world.getPlayers()) do
        local name = p:getName()
        if not cfg.RACISTS[name] then goto continue end

        local racer = sdata.race.racists[name]
        if not racer then goto continue end

        local pos = p:getPos()
        local prev = racer.prevPos

        racer.inCheckBox = false

        for _, box in ipairs(bx) do
            if Stopwatch.isInside(pos, box.box)
                or (prev and Stopwatch.isThrough(prev, pos, box.box)) then

                racer.inCheckBox = true
                racer.currentTrigger = box
                break
            end
        end

        if racer.inCheckBox and not racer.wasInCheckBox then
            print(string.format(
                "[%d] %s crossed %s (%s)",
                sdata.currentTime,
                racer.name,
                racer.currentTrigger.id,
                racer.currentTrigger.type
            ))

            send.toSheet(racer.name, racer.team, racer.role, racer.currentTrigger.id, racer.currentTrigger.type, sdata.currentTime)
        end

        racer.prevPos = pos
        racer.wasInCheckBox = racer.inCheckBox

        ::continue::
    end

    sdata.currentTime = sdata.currentTime + 1
end

return Stopwatch