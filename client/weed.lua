local spawnedWeeds = 0
local weedPlants = {}
local inWeedField = false
local QBCore = exports['qb-core']:GetCoreObject()

local function ValidateWeedCoord(plantCoord)
    local validate = true
    if spawnedWeeds > 0 then
        for _, v in pairs(weedPlants) do
            if #(plantCoord - GetEntityCoords(v)) < 5 then
                validate = false
            end
        end
        if not inWeedField then
            validate = false
        end
    end
    return validate
end

local function GetCoordZWeed(x, y)
    local groundCheckHeights = { 20.0, 21.0, 22.0, 23.0, 24.0, 175.0, 190.0, 200.0, 205.0, 215.0, 225.0 }

    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
        if foundGround then
            return z
        end
    end

    return 24.5
end

local function GenerateWeedCoords()
    while true do
        Wait(1)

        local coordX, coordY

        math.randomseed(GetGameTimer())
        local modX = math.random(-15, 15)

        Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(-15, 15)

        coordX = Config.CircleZones.WeedField.coords.x + modX
        coordY = Config.CircleZones.WeedField.coords.y + modY

        local coordZ = GetCoordZWeed(coordX, coordY)
        local coord = vector3(coordX, coordY, coordZ)

        if ValidateWeedCoord(coord) then
            return coord
        end
    end
end

local function SpawnWeedPlants()
    local model = `prop_weed_02`
    while spawnedWeeds < 5 do
        Wait(0)
        local coords = GenerateWeedCoords()
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        table.insert(weedPlants, obj)
        spawnedWeeds = spawnedWeeds + 1

        -- Add ox_target interaction for weed plant
        exports['ox_target']:addLocalEntity(obj, {
            {
                event = "ps-drugprocessing:pickWeed",
                icon = "fas fa-cannabis",
                label = Lang:t("target.pickweed"),
                type = "client"
            }
        })
    end
    SetModelAsNoLongerNeeded(model)
end

RegisterNetEvent("ps-drugprocessing:pickWeed", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local nearbyObject, nearbyID

    for i = 1, #weedPlants, 1 do
        if #(coords - GetEntityCoords(weedPlants[i])) < 2 then
            nearbyObject, nearbyID = weedPlants[i], i
        end
    end

    if nearbyObject and IsPedOnFoot(playerPed) then
        isPickingUp = true
        TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
        QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.collecting"), 10000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            ClearPedTasks(playerPed)
            SetEntityAsMissionEntity(nearbyObject, false, true)
            DeleteObject(nearbyObject)

            table.remove(weedPlants, nearbyID)
            spawnedWeeds = spawnedWeeds - 1

            TriggerServerEvent('ps-drugprocessing:pickedUpWeed')
            isPickingUp = false
        end, function()
            ClearPedTasks(playerPed)
            isPickingUp = false
        end)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(weedPlants) do
            SetEntityAsMissionEntity(v, false, true)
            DeleteObject(v)
        end
    end
end)

CreateThread(function()
    local weedZone = CircleZone:Create(Config.CircleZones.WeedField.coords, 50.0, {
        name = "ps-weedzone",
        debugPoly = false
    })
    weedZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inWeedField = true
            SpawnWeedPlants()
        else
            inWeedField = false
        end
    end)
end)
