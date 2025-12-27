local state = require("state")
local stopwatch = require("core.stopwatch")
local wand = require("lib.wand")

local ActionWheel = {}

local data = state.Data

function ActionWheel.titleUpdate(action, title)
    action:setTitle(title)
end

function ActionWheel.init()
    --.Creating action wheels
    local wheels = {
        action_wheel:newPage("Utilities"),
        action_wheel:newPage("Debug")
    }

    action_wheel:setPage(wheels[1]) --?Default active wheel

    --.Adding navigation buttons to wheels
    for i, wheel in ipairs(wheels) do       --?Calculating next and prevous wheel
        local prevIndex = (i - 2) % #wheels + 1     --?Pervous
        local nextIndex = i % #wheels + 1           --?Next

        local nav = wheel:newAction()   --?Creating navigation button
            :title("< Пред / След >")
            :item("minecraft:spectral_arrow") --TODO сделать иконки
            :onLeftClick(function()
                action_wheel:setPage(wheels[prevIndex])
            end)
            :onRightClick(function()
                action_wheel:setPage(wheels[nextIndex])
            end)
    end

    --.Adding buttons
    local setBox = wheels[1]:newAction()
        :title(
            "Выбрать зону секундомера\n" ..
            "§7ПКМ/ЛКМ§f - Выбор углов\n" ..
            "§6Скролл§f - Выбрать зону 3х3 вокруг себя\n" ..
            "§6Скролл§f - Изменить размер вдоль оси взгляда\n" ..
            "§aShift§f+§6скролл§f - Изменить размер в сторону взгляда\n" ..
            "§eCtrl§f+§6скролл§f - Изменить размер во все стороны\n" ..
            "§9Alt§f+§6скролл§d - Сбросить выделение\n" ..
            "§eCtrl§f+§aShift§f+§6скролл§c - Удалить выделение"
        )

        :item("minecraft:wooden_axe")
        :onLeftClick(function() wand.set(1, player:getPos(), true) end)
        :onRightClick(function() wand.set(2, player:getPos(), true) end)
        :onScroll(wand.modify)

    local toggleStopwatch = wheels[1]:newAction()
        :title("Запустить/остановить секундомер\n§7ЛКМ/ПКМ")
        :item("minecraft:clock")
        :onLeftClick(function()
            data.isClocking = true
            print("Таймер запущен")
        end)
        :onRightClick(function()
            data.isClocking = false
            data.currentTime = 0
            data.lastTime = 0
            print("Таймер остановлен")
        end)

    local toggleRender = wheels[1]:newAction()
        :title("Постоянный рендер зоны секундомера")
        :item("minecraft:spawner")
        :onToggle(function() ActionWheel.toggleBoxRender(not data.renderBox) end)
end



function ActionWheel.toggleBoxRender(tgl)
    data.renderBox = tgl
end

return ActionWheel