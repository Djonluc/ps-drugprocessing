local spawnedSulfuricAcidBarrels = 0
local SulfuricAcidBarrels = {}
local inSulfuricFarm = false
local isPickingUp = false
local QBCore = exports['qb-core']:GetCoreObject()

-- Validate if the new coordinates for Sulfuric Acid barrels are valid
local function ValidateSulfuricAcidCoord(plantCoord)
    local validate = true
    if spawnedSulfuricAcidBarrels > 0 then
        for _, v in pairs(SulfuricAcidBarrels) do
            if #(plantCoord - GetEntityCoords(v)) < 5 then
                validate = false
            end
        end
        if not inSulfuricFarm then
            validate = false
        end
    end
    return validate
end

-- Get the Z-coordinate for Sulfuric Acid barrel placement
local function GetCoordZSulfuricAcid(x, y)
    -- Return the specific ground level Z-coordinate
    return 42.49
end

-- Generate random coordinates for placing Sulfuric Acid barrels
local function GenerateSulfuricAcidCoords()
    while true do
        Wait(1)

        local coordX, coordY

        math.randomseed(GetGameTimer())
        local modX = math.random(-7, 7)

        Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(-7, 7)

        coordX = Config.CircleZones.SulfuricAcidFarm.coords.x + modX
        coordY = Config.CircleZones.SulfuricAcidFarm.coords.y + modY

        local coordZ = GetCoordZSulfuricAcid(coordX, coordY)
        local coord = vector3(coordX, coordY, coordZ)

        if ValidateSulfuricAcidCoord(coord) then
            return coord
        end
    end
end

-- Spawn Sulfuric Acid barrels at random locations
local function SpawnSulfuricAcidBarrels()
    local model = `mw_sulfuric_barrel`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    while spawnedSulfuricAcidBarrels < 10 do
        Wait(0)
        local coords = GenerateSulfuricAcidCoords()

        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)
        if obj then
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            table.insert(SulfuricAcidBarrels, obj)
            spawnedSulfuricAcidBarrels = spawnedSulfuricAcidBarrels + 1

            -- Add ox_target interaction for Sulfuric Acid barrel
            exports['ox_target']:addLocalEntity(obj, {
                {
                    event = "ps-drugprocessing:client:pickSulfuric",
                    icon = "fas fa-tachometer-alt",
                    label = Lang:t("target.pickSulfuric"),
                    type = "client"
                }
            }) -- update to ox_target support
        end
    end

    SetModelAsNoLongerNeeded(model)
end

-- Event handler for picking up Sulfuric Acid barrels
RegisterNetEvent("ps-drugprocessing:client:pickSulfuric", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local nearbyObject, nearbyID

    for i = 1, #SulfuricAcidBarrels do
        if #(coords - GetEntityCoords(SulfuricAcidBarrels[i])) < 2 then
            nearbyObject, nearbyID = SulfuricAcidBarrels[i], i
            break
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

                -- Remove the barrel from the list and update the count
                for i = #SulfuricAcidBarrels, 1, -1 do
                    if SulfuricAcidBarrels[i] == nearbyObject then
                        table.remove(SulfuricAcidBarrels, i)
                        break
                    end
                end
                spawnedSulfuricAcidBarrels = spawnedSulfuricAcidBarrels - 1

                -- Corrected event name to match server-side registration
                TriggerServerEvent('ps-drugprocessing:pickedUpSulfuricAcid')
                isPickingUp = false
            end, function()
                ClearPedTasks(playerPed)
                isPickingUp = false
            end)
        end
    end
end)

-- Clean up Sulfuric Acid barrels on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(SulfuricAcidBarrels) do
            SetEntityAsMissionEntity(v, false, true)
            DeleteObject(v)
        end
    end
end)

-- Create a zone for the Sulfuric Acid farm and handle player entry/exit
CreateThread(function()
    local sulfuricZone = CircleZone:Create(Config.CircleZones.SulfuricAcidFarm.coords, 50.0, {
        name = "ps-sulfuriczone",
        debugPoly = false
    })
    sulfuricZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inSulfuricFarm = true
            SpawnSulfuricAcidBarrels()
        else
            inSulfuricFarm = false
        end
    end)
end)
