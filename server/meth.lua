local QBCore = exports['qb-core']:GetCoreObject()

-- Event for picking up Hydrochloric Acid
RegisterServerEvent('ps-drugprocessing:pickedUpHydrochloricAcid', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.AddItem("hydrochloric_acid", 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["hydrochloric_acid"], "add")
    end
end)

-- Event for picking up Sodium Hydroxide
RegisterServerEvent('ps-drugprocessing:pickedUpSodiumHydroxide', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.AddItem("sodium_hydroxide", 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sodium_hydroxide"], "add")
    end
end)

-- Event for picking up Sulfuric Acid
RegisterServerEvent('ps-drugprocessing:pickedUpSulfuricAcid', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.AddItem("sulfuric_acid", 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sulfuric_acid"], "add")
    end
end)

-- Event for processing chemicals into liquid mix
RegisterServerEvent('ps-drugprocessing:processChemicals', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem("sulfuric_acid", Config.MethProcessing.SulfAcid) then
        if Player.Functions.RemoveItem("hydrochloric_acid", Config.MethProcessing.HydAcid) then
            if Player.Functions.RemoveItem("sodium_hydroxide", Config.MethProcessing.SodHyd) then
                if Player.Functions.AddItem("liquidmix", 1) then
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sulfuric_acid"], "remove", Config.MethProcessing.SulfAcid)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["hydrochloric_acid"], "remove", Config.MethProcessing.HydAcid)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sodium_hydroxide"], "remove", Config.MethProcessing.SodHyd)
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["liquidmix"], "add", 1)
                else
                    -- Rollback if adding item fails
                    Player.Functions.AddItem("sulfuric_acid", Config.MethProcessing.SulfAcid)
                    Player.Functions.AddItem("hydrochloric_acid", Config.MethProcessing.HydAcid)
                    Player.Functions.AddItem("sodium_hydroxide", Config.MethProcessing.SodHyd)
                end
            else
                -- Rollback if removing sodium hydroxide fails
                Player.Functions.AddItem("sulfuric_acid", Config.MethProcessing.SulfAcid)
                Player.Functions.AddItem("hydrochloric_acid", Config.MethProcessing.HydAcid)
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_sodium_hydroxide"), "error")
            end
        else
            -- Rollback if removing hydrochloric acid fails
            Player.Functions.AddItem("sulfuric_acid", Config.MethProcessing.SulfAcid)
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_hydrochloric_acid"), "error")
        end
    else
        -- Rollback if removing sulfuric acid fails
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_sulfuric_acid"), "error")
    end
end)

-- Event for processing liquid mix into chemical vapor
RegisterServerEvent('ps-drugprocessing:processTempUp', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem("liquidmix", 1) then
        if Player.Functions.AddItem("chemicalvapor", 1) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["liquidmix"], "remove")
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["chemicalvapor"], "add")
        else
            -- Rollback if adding item fails
            Player.Functions.AddItem("liquidmix", 1)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_liquidmix"), "error")
    end
end)

-- Event for processing chemical vapor into meth tray
RegisterServerEvent('ps-drugprocessing:processTempDown', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem("chemicalvapor", 1) then
        if Player.Functions.AddItem("methtray", 1) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["chemicalvapor"], "remove")
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["methtray"], "add")
        else
            -- Rollback if adding item fails
            Player.Functions.AddItem("chemicalvapor", 1)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_chemicalvapor"), "error")
    end
end)

-- Event for processing meth tray into meth
RegisterServerEvent('ps-drugprocessing:processMeth', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player.Functions.RemoveItem("methtray", 1) then
        if Player.Functions.AddItem("meth", Config.MethProcessing.Meth) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["methtray"], "remove")
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["meth"], "add", Config.MethProcessing.Meth)
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.meth"), "success")
        else
            -- Rollback if adding item fails
            Player.Functions.AddItem("methtray", 1)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_chemicalvapor"), "error")
    end
end)

-- Event for handling process failure when temp is too high
RegisterServerEvent('ps-drugprocessing:processFailUp', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("liquidmix", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["liquidmix"], "remove")
    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.temp_too_high"), "error")
end)

-- Event for handling process failure when temp is too low
RegisterServerEvent('ps-drugprocessing:processFailDown', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("chemicalvapor", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["chemicalvapor"], "remove")
    TriggerClientEvent('QBCore:Notify', src, Lang:t("error.temp_too_low"), "error")
end)
