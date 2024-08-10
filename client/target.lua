local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    local function spawnPed(model, coords, event, icon, label)
        -- Load model and spawn ped entity
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, false, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        -- Add interaction using ox_target
        exports['ox_target']:addLocalEntity(ped, {
            {
                event = event,
                icon = icon,
                label = label,
                type = "client",
            }
        })
    end

    spawnPed(`a_m_m_hillbilly_02`, vector4(-1187.73, -445.27, 43.91, 289.45), "ps-drugprocessing:EnterMethlab", "fas fa-atom", Lang:t("target.talk_to_walter"))
    spawnPed(`a_m_m_mlcrisis_01`, vector4(812.49, -2399.59, 23.66, 223.1), "ps-drugprocessing:EnterCWarehouse", "fas fa-key", Lang:t("target.talk_to_draco"))
    spawnPed(`mp_f_weed_01`, vector4(102.07, 175.08, 104.59, 159.91), "ps-drugprocessing:EnterWWarehouse", "fas fa-key", Lang:t("target.talk_to_charlotte"))
end)

CreateThread(function()
    local function addBoxZone(name, coords, width, length, heading, event, icon, label, minZ, maxZ)
        exports['ox_target']:addBoxZone({
            coords = coords,
            size = vec3(width, length, maxZ - minZ),
            rotation = heading,
            debug = false,
            options = {
                {
                    name = name,
                    event = event,
                    icon = icon,
                    label = label,
                    type = "client",
                },
            },
        })
    end

    addBoxZone("chemmenu", vector3(3535.66, 3661.69, 28.12), 1.65, 2.4, 350.0, "ps-drugprocessing:chemicalmenu", "fas fa-vials", Lang:t("target.chemmenu"), 27.52, 29.12)
    addBoxZone("methprocess", vector3(978.22, -147.1, -48.53), 1.6, 1.8, 0, "ps-drugprocessing:ProcessChemicals", "fas fa-vials", Lang:t("target.methprocess"), -50.33, -45.53)
    addBoxZone("methtempup", vector3(982.56, -145.59, -49.0), 1.2, 1.4, 0, "ps-drugprocessing:ChangeTemp", "fas fa-temperature-empty", Lang:t("target.methtempup"), -50.3, -47.3)
    addBoxZone("methtempdown", vector3(979.59, -144.14, -49.0), 1.2, 0.5, 354, "ps-drugprocessing:ChangeTemp2", "fas fa-temperature-full", Lang:t("target.methtempdown"), -49.2, -47.9)
    addBoxZone("methbagging", vector3(987.44, -140.5, -49.0), 0.5, 0.7, 1, "ps-drugprocessing:ProcessProduct", "fas fa-box", Lang:t("target.bagging"), -49.35, -48.65)
    addBoxZone("methkeypad", vector3(969.04, -146.17, -46.4), 0.4, 0.2, 0, "ps-drugprocessing:ExitMethlab", "fas fa-lock", Lang:t("target.keypad"), -46.2, -45.8)
    addBoxZone("cokeleave", vector3(1088.56, -3187.02, -38.67), 5, 5, 0, "ps-drugprocessing:ExitCWarehouse", "fas fa-lock", Lang:t("target.keypad"), -70.74, -79.54)
    addBoxZone("cokeleafproc", vector3(1086.2, -3194.9, -38.99), 2.5, 1.4, 0, "ps-drugprocessing:ProcessCocaFarm", "fas fa-scissors", Lang:t("target.cokeleafproc"), -39.39, -38.39)
    addBoxZone("cokepowdercut", vector3(1092.89, -3195.78, -38.99), 7.65, 1.2, 90, "ps-drugprocessing:ProcessCocaPowder", "fas fa-weight-scale", Lang:t("target.cokepowdercut"), -39.39, -38.44)
    addBoxZone("cokebricked", vector3(1100.51, -3199.46, -38.93), 2.6, 1.0, 90, "ps-drugprocessing:ProcessBricks", "fas fa-weight-scale", Lang:t("target.bagging"), -39.99, -38.59)
    addBoxZone("weedproces", vector3(1038.37, -3206.06, -38.17), 2.6, 1.0, 0, "ps-drugprocessing:processWeed", "fas fa-envira", Lang:t("target.weedproces"), -38.37, -37.57)
    addBoxZone("weedkeypad", vector3(1066.51, -3183.44, -39.16), 1.6, 0.4, 0, "ps-drugprocessing:ExitWWarehouse", "fas fa-lock", Lang:t("target.keypad"), -40.16, -37.76)
    addBoxZone("heroinproces", vector3(1384.9, -2080.61, 52.21), 2.5, 2.5, 223.98, "ps-drugprocessing:processHeroin", "fas fa-envira", Lang:t("target.heroinproces"), 51.21, 53.21)
    addBoxZone("thychloride", vector3(-679.77, 5800.7, 17.33), 1, 1, 340.0, "ps-drugprocessing:processingThiChlo", "fas fa-biohazard", Lang:t("target.process_thionyl_chloride"), 14.33, 18.33)
    addBoxZone("heroinproc", vector3(1413.7, -2041.77, 52.0), 1, 1, 352.15, "ps-drugprocessing:ProcessPoppy", "fas fa-leaf", Lang:t("target.heroinproc"), 51.00, 53.00)
end)

CreateThread(function()
    local function addTargetModel(model, event, icon, label)
        exports['ox_target']:addModel(model, {
            {
                event = event,
                icon = icon,
                label = label,
                type = "client",
            }
        })
    end

    addTargetModel(`h4_prop_bush_cocaplant_01`, "ps-drugprocessing:pickCocaLeaves", "fas fa-leaf", Lang:t("target.pickCocaLeaves"))
    addTargetModel(`prop_plant_01b`, "ps-drugprocessing:pickHeroin", "fas fa-leaf", Lang:t("target.pickHeroin"))
    addTargetModel(`prop_weed_01`, "ps-drugprocessing:pickWeed", "fas fa-envira", Lang:t("target.pickWeed"))
    addTargetModel(`prop_barrel_01a`, "ps-drugprocessing:pickSodium", "fas fa-dna", Lang:t("target.pickSodium"))
    addTargetModel(`prop_barrel_02b`, "ps-drugprocessing:pickSulfuric", "fas fa-shield-virus", Lang:t("target.pickSulfuric"))
    addTargetModel(`prop_barrel_exp_01a`, "ps-drugprocessing:pickChemicals", "fas fa-radiation", Lang:t("target.pickChemicals"))
    addTargetModel(`prop_barrel_exp_01b`, "ps-drugprocessing:client:hydrochloricacid", "fas fa-radiation", Lang:t("target.hydrochloricacid"))
end)
