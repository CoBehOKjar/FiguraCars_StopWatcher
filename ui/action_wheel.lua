local state = require("state")
local wand = require("lib.wand")
local util = require("lib.utilities")
local sync = require("net.sync")

local ActionWheel = {}

local data = state.Data

local function resetRacers()
    for _, racer in pairs(data.race.racists) do
        racer.prevPos = nil
        racer.inCheckBox = false
        racer.wasInCheckBox = false
        racer.currentTrigger = nil
    end
end

local function vecToStr(v)
    return string.format("%s, %s, %s", v.x, v.y, v.z)
end


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
    local setBox = wheels[2]:newAction()
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
    data.AW.setBox = setBox


    local toggleStopwatch = wheels[1]:newAction()
        :title("Запустить/запаузить секундомер\n§7ЛКМ/ПКМ")
        :item("minecraft:clock")
        :onLeftClick(function()
            data.isClocking = true
            data.isPaused = false
            sync.send("start")

            print("Таймер запущен")
        end)
        :onRightClick(function()
            if not data.isClocking then return end
            data.isPaused = not data.isPaused

            if data.isPaused then
                sync.send("pause")
                print("Таймер на паузе")
            else
                sync.send("start")
                print("Таймер продолжен")
            end
        end)
    data.AW.toggleStopwatch = toggleStopwatch


    local stopStopwatch = wheels[1]:newAction()
        :title("Сбросить секундомер")
        :item("minecraft:barrier")
        :onLeftClick(function()
            data.isClocking = false
            data.isPaused = false
            data.currentTime = 0

            resetRacers()
            sync.send("stop")

            print("Таймер остановлен и сброшен")
        end)
    data.AW.stopStopwatch = stopStopwatch


    local toggleRender = wheels[1]:newAction()
        :title("Постоянный рендер зоны секундомера")
        :item("minecraft:spawner")
        :onToggle(function() ActionWheel.toggleBoxRender(not data.renderBox) end)
    data.AW.toggleRender = toggleRender


    local slctRole = wheels[1]:newAction()
        :title("Выбрать роль аватара: "..state.Config.ROLES[state.Settings.roleIndex].."\n§7ПКМ/ЛКМ§f | §6Скролл\n§fMain - Главный наблюдатель\nChain - Остальные наблюдатели\nRepeater - Антена для остальных наблюдателей")
        :item("minecraft:ender_eye")
        :onLeftClick(function()
            ActionWheel.selectRole(1)
        end)
        :onRightClick(function()
            ActionWheel.selectRole(-1)
        end)
        :setOnScroll(ActionWheel.selectRole)
    data.AW.slctRole = slctRole

    
    local printBox = wheels[2]:newAction()
        :title("Вывести в чат текущее выделение\n§7ЛКМ §f- для вставки в код\n§7ПКМ §f- просто числа")
        :item("minecraft:writable_book")
        :onLeftClick(function ()
            print("box = {vec("..vecToStr(data.checkBox[1]).."), vec("..vecToStr(data.checkBox[2])..")}")            
        end)
        :onRightClick(function ()
            print(vecToStr(data.checkBox[1]), vecToStr(data.checkBox[2])) 
        end)
    data.AW.printBox = printBox

    
    local storeTest = wheels[2]:newAction()
        :title("Send|Find data")
        :item("minecraft:paper")
        :onLeftClick(function ()
            local time = world.getTime() 
            sync.send("test")
        end)
        :onRightClick(function ()
            util.tprint(world.avatarVars())
        end)
    data.AW.storeTest = storeTest

    local resetNet = wheels[2]:newAction()
        :title("Reset last signal ID")
        :item("minecraft:sponge")
        :onLeftClick(function () data.lastSignalId = 0 end)
end


function ActionWheel.toggleBoxRender(tgl)
    data.renderBox = tgl
end

function ActionWheel.selectRole(dir)
    local roles = state.Config.ROLES
    local count = #roles

    if count == 0 then return end

    state.Settings.roleIndex = state.Settings.roleIndex + (dir > 0 and 1 or -1)

    if state.Settings.roleIndex > count then
        state.Settings.roleIndex = 1
    elseif state.Settings.roleIndex < 1 then
        state.Settings.roleIndex = count
    end

    data.AW.slctRole:setTitle("Выбрать роль аватара: "..state.Config.ROLES[state.Settings.roleIndex].."\n§7ПКМ/ЛКМ§f | §6Скролл\n§fMain - Главный наблюдатель\nChain - Остальные наблюдатели\nRepeater - Антена для остальных наблюдателей")
    print(state.Settings.roleIndex)
end


return ActionWheel