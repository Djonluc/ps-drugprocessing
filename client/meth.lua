local isProcessing, isTempChangeU, isTempChangeD, isBagging = false, false, false, false
local Methlab = false
local QBCore = exports['qb-core']:GetCoreObject()

-- Function to process chemicals
local function ProcessChemicals()
    if isProcessing then return end  -- Prevent overlapping processes
    isProcessing = true
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
    QBCore.Functions.Progressbar("process_chemicals", Lang:t("progressbar.processing"), 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('ps-drugprocessing:processChemicals')

        -- Check if player is still in the zone
        local timeLeft = Config.Delays.MethProcessing / 1000
        while timeLeft > 0 do
            Wait(1000)
            timeLeft = timeLeft - 1
            if #(GetEntityCoords(playerPed) - Config.CircleZones.MethProcessing.coords) > 2 then
                QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
                TriggerServerEvent('ps-drugprocessing:cancelProcessing')
                break
            end
        end
        ClearPedTasks(playerPed)
        isProcessing = false
    end, function()
        ClearPedTasks(playerPed)
        isProcessing = false
    end)
end

-- Function to increase temperature
local function ProcessTempUp()
    if isTempChangeU then return end
    isTempChangeU = true
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
    QBCore.Functions.Progressbar("temp_up", Lang:t("progressbar.temp_up"), 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('ps-drugprocessing:processTempUp')

        -- Check if player is still in the zone
        local timeLeft = Config.Delays.MethProcessing / 1000
        while timeLeft > 0 do
            Wait(1000)
            timeLeft = timeLeft - 1
            if #(GetEntityCoords(playerPed) - Config.CircleZones.MethTemp.coords) > 2 then
                QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
                TriggerServerEvent('ps-drugprocessing:cancelProcessing')
                break
            end
        end
        ClearPedTasks(playerPed)
        isTempChangeU = false
    end, function()
        ClearPedTasks(playerPed)
        isTempChangeU = false
    end)
end

-- Function to decrease temperature
local function ProcessTempDown()
    if isTempChangeD then return end
    isTempChangeD = true
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
    QBCore.Functions.Progressbar("temp_down", Lang:t("progressbar.temp_down"), 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('ps-drugprocessing:processTempDown')

        -- Check if player is still in the zone
        local timeLeft = Config.Delays.MethProcessing / 1000
        while timeLeft > 0 do
            Wait(1000)
            timeLeft = timeLeft - 1
            if #(GetEntityCoords(playerPed) - Config.CircleZones.MethTemp.coords) > 2 then
                QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
                TriggerServerEvent('ps-drugprocessing:cancelProcessing')
                break
            end
        end
        ClearPedTasks(playerPed)
        isTempChangeD = false
    end, function()
        ClearPedTasks(playerPed)
        isTempChangeD = false
    end)
end

-- Function to process the product
local function ProcessProduct()
    if isBagging then return end
    isBagging = true
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
    QBCore.Functions.Progressbar("process_product", Lang:t("progressbar.packing"), 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('ps-drugprocessing:processMeth')

        -- Check if player is still in the zone
        local timeLeft = Config.Delays.MethProcessing / 1000
        while timeLeft > 0 do
            Wait(1000)
            timeLeft = timeLeft - 1
            if #(GetEntityCoords(playerPed) - Config.CircleZones.MethBag.coords) > 2 then
                QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
                TriggerServerEvent('ps-drugprocessing:cancelProcessing')
                break
            end
        end
        ClearPedTasks(playerPed)
        isBagging = false
    end, function()
        ClearPedTasks(playerPed)
        isBagging = false
    end)
end

-- Function to load animation dictionary
local function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

-- Function to open door animation
local function OpenDoorAnimation()
    local ped = PlayerPedId()
    LoadAnimationDict("anim@heists@keycard@")
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(ped)
end

-- Function to enter meth lab
local function EnterMethlab()
    local ped = PlayerPedId()
    OpenDoorAnimation()
    Methlab = true
    Wait(500)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.MethLab["exit"].coords.x, Config.MethLab["exit"].coords.y, Config.MethLab["exit"].coords.z - 0.98)
    SetEntityHeading(ped, Config.MethLab["exit"].coords.w)
    Wait(1000)
    DoScreenFadeIn(250)
end

-- Function to exit meth lab
local function ExitMethlab()
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local keypad = {coords = {x = 969.04, y = -146.17, z = -46.4, h = 94.5, r = 1.0}}
    SetEntityCoords(ped, keypad.coords.x, keypad.coords.y, keypad.coords.z - 0.98)
    SetEntityHeading(ped, keypad.coords.h)
    Methlab = true
    LoadAnimationDict(dict)
    TaskPlayAnim(ped, "mp_heists@keypad@", "idle_a", 8.0, 8.0, -1, 0, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "mp_heists@keypad@", "exit", 2.0, 2.0, -1, 0, 0, false, false, false)
    Wait(1000)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.MethLab["enter"].coords.x, Config.MethLab["enter"].coords.y, Config.MethLab["enter"].coords.z - 0.98)
    SetEntityHeading(ped, Config.MethLab["enter"].coords.w)
    Methlab = false
    Wait(1000)
    DoScreenFadeIn(250)
end

-- Register targets for interaction
CreateThread(function()
    -- Meth Processing Zone
    exports['ox_target']:AddCircleZone("methProcessingZone", Config.CircleZones.MethProcessing.coords, 2.0, {
        debugPoly = false,
        options = {
            {
                name = 'processChemicals',
                icon = 'fas fa-flask',
                label = Lang:t("target.process_chemicals"),
                action = function()
                    TriggerEvent('ps-drugprocessing:ProcessChemicals')
                end
            }
        },
        distance = 2.0
    }) -- update to ox_target support

    -- Temp Up Zone
    exports['ox_target']:AddCircleZone("tempUpZone", Config.CircleZones.MethTemp.coords, 2.0, {
        debugPoly = true,
        options = {
            {
                name = 'changeTempUp',
                icon = 'fas fa-temperature-high',
                label = Lang:t("interaction.temp_up"),
                action = function()
                    TriggerEvent('ps-drugprocessing:ChangeTemp')
                end
            }
        },
        distance = 2.0
    }) -- update to ox_target support

    -- Temp Down Zone
    exports['ox_target']:AddCircleZone("tempDownZone", Config.CircleZones.MethTemp.coords, 2.0, {
        debugPoly = true,
        options = {
            {
                name = 'changeTempDown',
                icon = 'fas fa-temperature-low',
                label = Lang:t("interaction.temp_down"),
                action = function()
                    TriggerEvent('ps-drugprocessing:ChangeTemp2')
                end
            }
        },
        distance = 2.0
    }) -- update to ox_target support

    -- Bagging Zone
    exports['ox_target']:AddCircleZone("baggingZone", Config.CircleZones.MethBag.coords, 2.0, {
        debugPoly = false,
        options = {
            {
                name = 'processProduct',
                icon = 'fas fa-bag',
                label = Lang:t("interaction.bagging"),
                action = function()
                    TriggerEvent('ps-drugprocessing:ProcessProduct')
                end
            }
        },
        distance = 2.0
    }) -- update to ox_target support
end)

-- Register events
RegisterNetEvent('ps-drugprocessing:ProcessChemicals', ProcessChemicals)
RegisterNetEvent('ps-drugprocessing:ChangeTemp', ProcessTempUp)
RegisterNetEvent('ps-drugprocessing:ChangeTemp2', ProcessTempDown)
RegisterNetEvent('ps-drugprocessing:ProcessProduct', ProcessProduct)
