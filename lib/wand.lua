local state = require("state")
local render = require("ui.render")

local Wand = {}

local data = state.Data
local cbx = data.checkBox
local track = state.Config.TRACK
local points = {vec(0,0,0), vec(0,0,0)}

local ALTKEY = keybinds:newKeybind("ResetBox", "key.keyboard.left.alt")
local CTRLKEY = keybinds:newKeybind("ResetBox", "key.keyboard.left.control")
local SHIFTKEY = keybinds:newKeybind("ResetBox", "key.keyboard.left.shift")


local function vecToString(v)
    return string.format("§cX.%.1f §aY.%.1f §bZ.%.1f§7", v[1], v[2], v[3])
end



function Wand.reset(pos)
    Wand.set(1, pos - vec(1,1,1))
    Wand.set(2, pos + vec(1,1,1))
    render.spawnEdgeParticles(cbx[1], cbx[2])
end



function Wand.set(point, pos, expand)
    points[point] = pos
    local p1, p2 = points[1], points[2]

    cbx[1] = vec(math.min(p1[1], p2[1]), math.min(p1[2], p2[2]), math.min(p1[3], p2[3]))
    cbx[2] = vec(math.max(p1[1], p2[1]), math.max(p1[2], p2[2]), math.max(p1[3], p2[3]))

    if expand then
        cbx[1].y = cbx[1].y - 1
        cbx[2].y = cbx[2].y + 1
    end

    host:setActionbar("§6Зона: "..vecToString(cbx[1]).." / "..vecToString(cbx[2]))
    render.spawnEdgeParticles(cbx[1], cbx[2])
    data.isCheckBoxCreated = true
end



function Wand.modify(dir)
    local alt = ALTKEY:isPressed()
    local ctrl = CTRLKEY:isPressed()
    local shift = SHIFTKEY:isPressed()

    local pos = player:getPos()
    local look = player:getLookDir():normalize()
    local ax, ay, az = math.abs(look.x), math.abs(look.y), math.abs(look.z)
    local maxAxis = math.max(ax, ay, az)
    local mainAxis = (maxAxis == ax and "x") or (maxAxis == ay and "y") or "z"

    if not data.isCheckBoxCreated then Wand.reset(pos) return end

    if ctrl and shift then
        cbx[1], cbx[2] = vec(0,0,0), vec(0,0,0)
        data.isCheckBoxCreated = false
        host:setActionbar("§cЗона удалена")
        return
    end

    if alt then Wand.reset(pos) return end

    if ctrl then
        local v = vec(dir, dir, dir)
        cbx[1], cbx[2] = cbx[1] - v, cbx[2] + v
    elseif shift then
        if look[mainAxis] > 0 then cbx[2][mainAxis] = cbx[2][mainAxis] + dir
        else cbx[1][mainAxis] = cbx[1][mainAxis] - dir end
    else
        local vz = vec(0,0,0)
        vz[mainAxis] = dir
        cbx[1], cbx[2] = cbx[1] - vz, cbx[2] + vz
    end

    host:setActionbar("§6Зона: "..vecToString(cbx[1]).." / "..vecToString(cbx[2]))
    render.spawnEdgeParticles(cbx[1], cbx[2])
end



function Wand.tick()
    if data.renderBox and world.getTime() % 10 == 0 then
        local zones = {}
        if track.sectors then
            for _, s in pairs(track.sectors) do 
                if s.inBox then table.insert(zones, s.inBox) end
                if s.outBox then table.insert(zones, s.outBox) end
            end
        end

        if track.finish and track.finish.box then table.insert(zones, track.finish.box) end
        
        if track.pitStop then
            if track.pitStop.inBox then table.insert(zones, track.pitStop.inBox) end
            if track.pitStop.outBox then table.insert(zones, track.pitStop.outBox) end
        end

        if data.isCheckBoxCreated then
            table.insert(zones, cbx)
        end
        
        for _, z in ipairs(zones) do render.spawnEdgeParticles(z[1], z[2]) end
    end
end

return Wand