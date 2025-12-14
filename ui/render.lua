local state = require("state")

local Render = {}


function Render.spawnEdgeParticles(p1, p2)
    local x1, y1, z1 = p1.x, p1.y, p1.z
    local x2, y2, z2 = p2.x, p2.y, p2.z

    local function line(xa, ya, za, xb, yb, zb)
        local dx = xb - xa
        local dy = yb - ya
        local dz = zb - za

        local steps = math.max(math.abs(dx), math.abs(dy), math.abs(dz))
        if steps < 1 then steps = 1 end

        local sx = dx / steps
        local sy = dy / steps
        local sz = dz / steps

        for i = 0, steps do
            particles["minecraft:crit"]
                :spawn()
                :setPos(vec(
                    xa + sx * i,
                    ya + sy * i,
                    za + sz * i
                ))
        end
    end

    line(x1, y1, z1, x1, y2, z1)
    line(x2, y1, z1, x2, y2, z1)
    line(x1, y1, z2, x1, y2, z2)
    line(x2, y1, z2, x2, y2, z2)

    line(x1, y1, z1, x2, y1, z1)
    line(x1, y1, z1, x1, y1, z2)
    line(x2, y1, z1, x2, y1, z2)
    line(x1, y1, z2, x2, y1, z2)

    line(x1, y2, z1, x2, y2, z1)
    line(x1, y2, z1, x1, y2, z2)
    line(x2, y2, z1, x2, y2, z2)
    line(x1, y2, z2, x2, y2, z2)
end

return Render