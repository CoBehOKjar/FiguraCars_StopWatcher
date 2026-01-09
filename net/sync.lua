local state = require("state")

local Sync = {}

function pings.syncTime(time)
    state.Data.launchTime = time
    avatar:store("launchTime", state.Data.launchTime)
end

return Sync