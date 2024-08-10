local spawnedSodiumHydroxideBarrels = 0
local SodiumHydroxideBarrels = {}
local inSodiumFarm = false
local QBCore = exports['qb-core']:GetCoreObject()

-- Validate if the new coordinates for Sodium Hydroxide barrels are valid
local function ValidateSodiumHydroxideCoord(plantCoord)
    local validate2 = true
    if spawnedSodiumHydroxideBarrels > 0 then
        for _, v in pairs(SodiumHydroxideBarrels) do
            if #(plantCoord - GetEntityCoords(v)) < 5 then
                validate2 = false
            end
        end
        if not inSodiumFarm then
            validate2 = false
        end
    end
    return validate2
end

-- Get the Z-coordinate for Sodium Hydroxide barrel placement
local function GetCoordZSodiumHydroxide(x, y)
    -- Return the specific ground level Z-coordinate
    return 164.59573
end

-- Generate random coordinates for placing Sodium Hydroxide barrels
local function GenerateSodiumHydroxideCoords()
    while true do
        Wait(1)

        local weed3CoordX, weed3CoordY

        math.randomseed(GetGameTimer())
        local modX3 = math.random(-7, 7)

        Wait(100)

        math.randomseed(GetGameTimer())
        local modY3 = math.random(-7, 7)

        weed3CoordX = Config.CircleZones.SodiumHydroxideFarm.coords.x + modX3
        weed3CoordY = Config.CircleZones.SodiumHydroxideFarm.coords.y + modY3

        local coordZ3 = GetCoordZSodiumHydroxide(weed3CoordX, weed3CoordY)
        local coord3 = vector3(weed3CoordX, weed3CoordY, coordZ3)

        if ValidateSodiumHydroxideCoord(coord3) then
            return coord3
        end
    end
end

-- Spawn Sodium Hydroxide barrels at random locations
local function SpawnSodiumHydroxideBarrels()
    local model = `mw_sodium_barrel`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    while spawnedSodiumHydroxideBarrels < 10 do
        Wait(0)
        local coords = GenerateSodiumHydroxideCoords()

        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)
        if obj then
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            table.insert(SodiumHydroxideBarrels, obj)
            spawnedSodiumHydroxideBarrels = spawnedSodiumHydroxideBarrels + 1

            -- Add ox_target interaction for Sodium Hydroxide barrel
            exports['ox_target']:addLocalEntity(obj, {
                {
                    event = "ps-drugprocessing:client:pickSodium",
                    icon = "fas fa-tachometer-alt",
                    label = Lang:t("target.pickSodium"),
                    type = "client"
                }
            })
        end
    end

    SetModelAsNoLongerNeeded(model)
end

-- Event handler for picking up Sodium Hydroxide barrels
RegisterNetEvent("ps-drugprocessing:client:pickSodium", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local nearbyObject, nearbyID

    for i = 1, #SodiumHydroxideBarrels do
        if #(coords - GetEntityCoords(SodiumHydroxideBarrels[i])) < 2 then
            nearbyObject, nearbyID = SodiumHydroxideBarrels[i], i
        end
    end

    if nearbyObject and IsPedOnFoot(playerPed) then
        if not isPickingUp then
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

                table.remove(SodiumHydroxideBarrels, nearbyID)
                spawnedSodiumHydroxideBarrels = spawnedSodiumHydroxideBarrels - 1

                -- Corrected event name to match server-side registration
                TriggerServerEvent('ps-drugprocessing:pickedUpSodiumHydroxide')
                isPickingUp = false
            end, function()
                ClearPedTasks(playerPed)
                isPickingUp = false
            end)
        end
    end
end)

-- Clean up Sodium Hydroxide barrels on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(SodiumHydroxideBarrels) do
            SetEntityAsMissionEntity(v, false, true)
            DeleteObject(v)
        end
    end
end)

-- Create a zone for the Sodium Hydroxide farm and handle player entry/exit
CreateThread(function()
    local sodiumZone = CircleZone:Create(Config.CircleZones.SodiumHydroxideFarm.coords, 50.0, {
        name = "ps-sodiumzone",
        debugPoly = false
    })
    sodiumZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inSodiumFarm = true
            SpawnSodiumHydroxideBarrels()
        else
            inSodiumFarm = false
        end
    end)
end)
