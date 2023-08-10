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

exports('AddKey', addVehicleKey)
exports('RemoveKey', removeVehicleKey)
