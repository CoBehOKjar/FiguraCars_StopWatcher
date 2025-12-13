local State = {}

--*Const
State.Config = {
    FINISH = {vec(581,70,-2036), vec(603,76,-2030)},
    PITSTOP = {
        In = {vec(596,70,-1863), vec(606,76,-1848)},
        Out = {vec(612,0,-2096), vec(623,76,-2091)},
    },

    FIRST_SECTOR = {
        In = {vec(605,70,-2189), vec(628,76,-2185)},
        Out = {vec(579,70,-2505), vec(617,76,-2500)},
    },
    SECOND_SECTOR = {
        In = {vec(498,70,-2061), vec(523,76,-2054)},
        Out = {vec(399,70,-1879), vec(411,76,-1851)},
    },
    THIRD_SECTOR = {
        In = {vec(439,70,-1897), vec(445,76,-1877)},
        Out = {vec(559,70,-1813), vec(588,76,-1806)},
    },

    RACISTS = {
        NickName = true,
        CoBeHok = true,
        Anzorik = true,
    }
}


--*Runtime
State.Data = {
    --.Stopwatch states
    isClocking = false,
    currentTime = 0,
    currentLap = 0,
    lastTime = 0,
    

    checkBox = {vec(0,0,0), vec(0,0,0)},
    isCheckBoxCreated = false,
    inCheckBox = false,
    wasInCheckBox = false,

    renderBox = false
}

State.Settings = {

}

return State