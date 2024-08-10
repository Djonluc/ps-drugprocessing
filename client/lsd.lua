local isPickingUp, isProcessing = false, false
local QBCore = exports['qb-core']:GetCoreObject()

local function ProcessLSD()
    isProcessing = true
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
    QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.processing"), 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        disableKeyboard = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('ps-drugprocessing:ProcessLSD')

        local timeLeft = Config.Delays.lsdProcessing / 1000
        while timeLeft > 0 do
            Wait(1000)
            timeLeft = timeLeft - 1
            if #(GetEntityCoords(playerPed) - Config.CircleZones.lsdProcessing.coords) > 5 then
                QBCore.Functions.Notify(Lang:t("error.too_far"))
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

local function ProcessThionylChloride()
    isProcessing = true
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
    QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.processing"), 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        disableKeyboard = true,
    }, {}, {}, {}, function()
        TriggerServerEvent('ps-drugprocessing:processThionylChloride')

        local timeLeft = Config.Delays.thionylchlorideProcessing / 1000
        while timeLeft > 0 do
            Wait(1000)
            timeLeft = timeLeft - 1
            if #(GetEntityCoords(playerPed) - Config.CircleZones.thionylchlorideProcessing.coords) > 5 then
                QBCore.Functions.Notify(Lang:t("error.too_far"))
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

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if #(coords - Config.CircleZones.lsdProcessing.coords) < 2 then
            if not isProcessing then
                QBCore.Functions.DrawText3D(coords.x, coords.y, coords.z, Lang:t("drawtext.processlsd"))
            end
            if IsControlJustReleased(0, 38) and not isProcessing then
                QBCore.Functions.TriggerCallback('ps-drugprocessing:validate_items', function(result)
                    if result.ret then
                        ProcessLSD()
                    else
                        QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
                    end
                end, {lsa = 1, thionyl_chloride = 1})
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent('ps-drugprocessing:processingThiChlo', function()
    local coords = GetEntityCoords(PlayerPedId())
    
    if #(coords - Config.CircleZones.thionylchlorideProcessing.coords) < 5 then
        if not isProcessing then
            QBCore.Functions.TriggerCallback('ps-drugprocessing:validate_items', function(result)
                if result.ret then
                    ProcessThionylChloride()
                else
                    QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
                end
            end, {lsa = 1, chemicals = 1})
        end
    end
end)

-- Add targets for interaction using ox_target's addBoxZone
CreateThread(function()
    -- LSD Processing Zone
    exports['ox_target']:addBoxZone({
        coords = Config.CircleZones.lsdProcessing.coords,
        size = vec3(2.0, 2.0, 0.5),
        rotation = 0,
        debug = Config.Debug,
        options = {
            {
                name = "processLSD",
                icon = "fas fa-flask",
                label = Lang:t("target.processlsd"),
                action = function()
                    TriggerEvent('ps-drugprocessing:processLSD')
                end
            }
        }
    })

    -- Thionyl Chloride Processing Zone
    exports['ox_target']:addBoxZone({
        coords = Config.CircleZones.thionylchlorideProcessing.coords,
        size = vec3(2.0, 2.0, 0.5),
        rotation = 0,
        debug = Config.Debug,
        options = {
            {
                name = "processThionylChloride",
                icon = "fas fa-flask",
                label = Lang:t("target.process_thionyl_chloride"),
                action = function()
                    TriggerEvent('ps-drugprocessing:processingThiChlo')
                end
            }
        }
    })
end)
