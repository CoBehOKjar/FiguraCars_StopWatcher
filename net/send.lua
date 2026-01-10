local Send = {}

local pendingBuffers = {}
local eventBuffer = {}
local flushTicks = 20


function Send.toSheet(name, team, role, boxId, boxType, time)
    table.insert(eventBuffer, {
        name = name,
        team = team,
        role = role,
        boxId = boxId,
        boxType = boxType,
        time = time
    })
end


function Send.flush()
    if #eventBuffer == 0 then return end

    local url = "https://script.google.com/macros/s/AKfycbzk5nhgGYSDBwbvtFKSffeob6yRKbhou0jkBl3dif7WM6UG-NTZVo-rM3Swsj3xL2JgSg/exec"

    local payload = '{"events":['
    for i, e in ipairs(eventBuffer) do
        payload = payload .. string.format(
            '{"name":"%s","team":"%s","role":"%s","boxId":"%s","boxType":"%s","time":%d}',
            e.name, e.team, e.role, e.boxId, e.boxType, e.time
        )
        if i < #eventBuffer then payload = payload .. ',' end
    end
    payload = payload .. ']}'

    local buffer = data:createBuffer()
    buffer:writeByteArray(payload)
    buffer:setPosition(0)

    net.http:request(url)
        :method("POST")
        :header("Content-Type", "application/json")
        :body(buffer)
        :send()

    eventBuffer = {}
    table.insert(pendingBuffers, { buf = buffer, ticks = 200, closed = false })
end


local tickCounter = 0
function Send.tick()
    tickCounter = tickCounter + 1
    if tickCounter >= flushTicks then
        Send.flush()
        tickCounter = 0
    end

    for i = #pendingBuffers, 1, -1 do
        local entry = pendingBuffers[i]
        if entry.ticks > 0 then
            entry.ticks = entry.ticks - 1
        end
        if entry.ticks <= 0 then
            if not entry.closed then
                local ok, err = pcall(function() entry.buf:close() end)
                if not ok then
                    print("WARN: buffer:close() failed:", tostring(err))
                end
                entry.closed = true
            end
            table.remove(pendingBuffers, i)
        end
    end
end

return Send
