--===== FiveM Script =========================================
--= Vehicle Keys (Lock System)
--===== Developed By: ========================================
--= Azael Dev
--===== Website: =============================================
--= https://www.azael.dev
--===== License: =============================================
--= Copyright (C) Azael Dev - All Rights Reserved
--= You are not allowed to sell this script
--============================================================

Citizen.CreateThread(function()
    for k, v in ipairs(CONFIG.SwapItems.Search.Government.Jobs) do
        CONFIG.SwapItems.Search.Government.Jobs[v] = true
        CONFIG.SwapItems.Search.Government.Jobs[k] = nil
    end
end)

if GetResourceState('es_extended') == 'started' then
    local ESX = exports['es_extended']:getSharedObject()
    
    ---getPlayerIdentifier
    ---@param source number
    ---@return string|nil
    function getPlayerIdentifier(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        return xPlayer and xPlayer.identifier
    end
    
    ---getPlayerJob
    ---@param source number
    ---@return string|nil
    function getPlayerJob(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        
        return xPlayer and xPlayer.job.name
    end
    
    ---updateVehicleOwnership
    ---@param plate string
    ---@param from string
    ---@param to string
    ---@return boolean, string|nil
    function updateVehicleOwnership(plate, from, to, action)
        return pcall(MySQL.prepare.await, "UPDATE owned_vehicles SET owner = ?, transfers = JSON_ARRAY_APPEND(transfers, '$', ?) WHERE plate = ? AND owner = ?", { to, json.encode({ from = from, to = to, action = action, timestamp = os.time() }), plate, from })
    end
    
    MySQL.ready(function()
        local columns = MySQL.query.await('SHOW COLUMNS FROM `owned_vehicles`')
        
        if columns then
            local exist = false
            
            for i = 1, #columns, 1 do
                local column = columns[i]
                
                if column.Field == 'transfers' then
                    exist = true
                    break
                end
            end
            
            if not exist then
                MySQL.query.await('ALTER TABLE `owned_vehicles` ADD COLUMN `transfers` LONGTEXT NOT NULL DEFAULT (JSON_ARRAY())')
            end
        end
    end)
elseif GetResourceState('qb-core') == 'started' then
    local QBCore = exports['qb-core']:GetCoreObject()

    ---getPlayerIdentifier
    ---@param source number
    ---@return string|nil
    function getPlayerIdentifier(source)
        local Player = QBCore.Functions.GetPlayer(source)

        return Player and Player.PlayerData.citizenid
    end
    
    ---getPlayerJob
    ---@param source number
    ---@return string|nil
    function getPlayerJob(source)
        local Player = QBCore.Functions.GetPlayer(source)
        
        return Player and Player.PlayerData.job.name
    end
    
    --updateVehicleOwnership
    ---@param plate string
    ---@param from string
    ---@param to string
    ---@return boolean, string|nil
    function updateVehicleOwnership(plate, from, to, action)
        return pcall(MySQL.prepare.await, "UPDATE player_vehicles SET citizenid = ?, transfers = JSON_ARRAY_APPEND(transfers, '$', ?) WHERE plate = ? AND citizenid = ?", { to, json.encode({ from = from, to = to, action = action, timestamp = os.time() }), plate, from })
    end

    MySQL.ready(function()
        local columns = MySQL.query.await('SHOW COLUMNS FROM `player_vehicles`')
        
        if columns then
            local exist = false
            
            for i = 1, #columns, 1 do
                local column = columns[i]
                
                if column.Field == 'transfers' then
                    exist = true
                    break
                end
            end
            
            if not exist then
                MySQL.query.await('ALTER TABLE `player_vehicles` ADD COLUMN `transfers` LONGTEXT NOT NULL DEFAULT (JSON_ARRAY())')
            end
        end
    end)
else
    print(('[^1ERROR^7] Could not find dependency ^3es_extended^7, ^3qb-core^7 for resource ^5%s^7'):format(GetCurrentResourceName()))
end

---transferVehicleOwnership
---@param vehiclePlate string
---@param fromInventory number
---@param toInventory number
---@return boolean
local function transferVehicleOwnership(plate, from, to, action)
    local from = getPlayerIdentifier(from)
    
    if from then
        local to = getPlayerIdentifier(to)
        
        if to then
            local success, response = updateVehicleOwnership(plate, from, to, action)
            
            if not success and response then
                print(('[^1ERROR^7] %s'):format(response))
            end
            
            return success
        end
    end
    
    return false
end

---swapItems
---@param payload table<{ source: number, action: string, fromInventory: table|string|number, toInventory: table|string|number, fromType: string, toType: string, fromSlot: table, toSlot: table|number, count: number
---@return boolean|nil
local function swapItems(payload)
    if payload.action == 'give' then
        if CONFIG.SwapItems.Give.Transfer.Enable == true then
            return transferVehicleOwnership((payload.fromSlot.metadata.plate or payload.fromSlot.metadata.type), payload.fromInventory, payload.toInventory, 'player_give')
        end
        
        return CONFIG.SwapItems.Give.Enable
    elseif payload.action == 'move' then
        if payload.toType == 'drop' or payload.toType == 'newdrop' then
            return CONFIG.SwapItems.Drop.Enable
        elseif payload.fromInventory ~= payload.toInventory and (payload.fromType == 'player' and payload.toType == 'player') then
            local job = getPlayerJob(payload.source)
            
            if job then
                if not CONFIG.SwapItems.Search.Government.Jobs[job] then
                    if CONFIG.SwapItems.Search.Citizen.Transfer.Enable == true then
                        return transferVehicleOwnership((payload.fromSlot.metadata.plate or payload.fromSlot.metadata.type), payload.fromInventory, payload.toInventory, 'citizen_search')
                    end
                    
                    return CONFIG.SwapItems.Search.Citizen.Enable
                elseif CONFIG.SwapItems.Search.Government.Jobs[job] then
                    if CONFIG.SwapItems.Search.Government.Transfer.Enable == true then
                        return transferVehicleOwnership((payload.fromSlot.metadata.plate or payload.fromSlot.metadata.type), payload.fromInventory, payload.toInventory, ('%s_search'):format(job))
                    end
                    
                    return CONFIG.SwapItems.Search.Government.Enable
                end
            end
            
            return false
        end
    end
end

---addVehicleKey
---@param source number
---@param plate string
---@param description string|nil
local function addVehicleKey(source, plate, description)
    if type(source) ~= 'number' then
        print(('[^1ERROR^7] "^3source^7" is not a number (^3%s^7)'):format(source))
    elseif type(plate) ~= 'string' then
        print(('[^1ERROR^7] "^3plate^7" is not a string (^3%s^7)'):format(plate))
    elseif (description and type(description) ~= 'string') then
        print(('[^1ERROR^7] "^description^7" is not a string (^3%s^7)'):format(description))
    else
        local success, response = exports.ox_inventory:AddItem(source, CONFIG.ItemName, 1, { type = plate, plate = plate, description = description })

        if not success then
            print(('[^1ERROR^7] Add ^3%s^7 to netID ^3%s^7 failed (%s)'):format(CONFIG.ItemName, source, response))
            TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = ('ERROR: %s'):format(response) })
        end
    end
end

---removeVehicleKey
---@param source number
---@param plate string
---@param strict boolean|nil
local function removeVehicleKey(source, plate, strict)
    if type(source) ~= 'number' then
        print(('[^1ERROR^7] "^3source^7" is not a number (^3%s^7)'):format(source))
    elseif type(plate) ~= 'string' then
        print(('[^1ERROR^7] "^3plate^7" is not a string (^3%s^7)'):format(plate))
    elseif (strict and type(strict) ~= 'boolean') then
        print(('[^1ERROR^7] "^strict^7" is not a boolean (^3%s^7)'):format(strict))
    else
        local slotId = exports.ox_inventory:GetSlotIdWithItem(source, CONFIG.ItemName, { plate = plate }, (strict or false))

        if slotId then
            local success, response = exports.ox_inventory:RemoveItem(source, CONFIG.ItemName, 1, nil, slotId)

            if not success then
                print(('[^1ERROR^7] Remove ^3%s^7 from netID ^3%s^7 failed (%s)'):format(CONFIG.ItemName, source, response))
                TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = ('ERROR: %s'):format(response) })
            end
        end
    end
end

exports.ox_inventory:registerHook('swapItems', swapItems, { itemFilter = { [CONFIG.ItemName] = true } })
exports('AddKey', addVehicleKey)
exports('RemoveKey', removeVehicleKey)
