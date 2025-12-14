local State = {}

--*Const
State.Config = {
    TRACK = {
        name = "МП2 Grand prix",
        sectors = {
            {
                id = "S1",
                inBox = {vec(605,70,-2189), vec(629,76,-2185)},
                outBox = {vec(579,70,-2505), vec(618,76,-2500)},
            },
            {
                id = "S2",
                inBox = {vec(496,70,-2061), vec(524,76,-2054)},
                outBox = {vec(399,70,-1884), vec(411,76,-1850)},
            },
            {
                id = "S3",
                inBox = {vec(439,70,-1897), vec(445,76,-1877)},
                outBox = {vec(558,70,-1813), vec(589,76,-1806)},
            },
        },

        finish = {
            box = {vec(581,70,-2036), vec(604,76,-2030)}
        },

        pitStop = {
            inBox = {vec(596,70,-1863), vec(606,76,-1848)},
            outBox = {vec(612,0,-2096), vec(624,76,-2091)},
        },
    },

    RACE = {
        laps = 50,
        countPitTime = false,
    },

    TEAMS = {
        {
            id = "TeamName",
            color = "§f",
            racists = {
                {name = "NickName", role = "main"},
                {name = "AnotherName", role = "reserve"},
            }
        },

        {
            id = "Мамкины Ядерщики",
            color = "§6",
            racists = {
                {name = "CoBeHok", role = "main"},
                {name = "DodgerF", role = "reserve"},
                {name = "Romul_Us", role = "reserve"}
            }
        }
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
    isCheckBoxCreated = true,
    inCheckBox = false,
    wasInCheckBox = false,

    renderBox = true
}

State.Settings = {

}

return State