local state = require("state")

local Sync = {}

function pings.sync(signals)
    for signal, d in pairs(signals) do
        avatar:store(signal, d)
    end
end



function Sync.tick()
    
end

return Sync