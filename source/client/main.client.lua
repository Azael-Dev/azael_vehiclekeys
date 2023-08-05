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

---@param ped number
---@param plate string|nil
---@param dist number
---@return boolean, number|nil, string|nil
local function vehicleSearch(ped, plate, dist)
    if plate then
        local pedCoords = GetEntityCoords(ped)
        local vehicles = GetGamePool('CVehicle')

        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(pedCoords - vehCoords)
    
            if distance <= dist then
                local vehPlate = GetVehicleNumberPlateText(vehicle)
                local found = (plate:gsub('%s+', '') == vehPlate:gsub('%s+', ''))
    
                if found then
                    return found, vehicle, vehPlate
                end
            end
        end
    else
        local items = exports.ox_inventory:Search('slots', CONFIG.UseKeyboard.ItemName)

        if type(items) == 'table' and next(items) then
            local pedCoords = GetEntityCoords(ped)
            local vehicles = GetGamePool('CVehicle')
            local data = {}

            for i = 1, #items do
                local metadata = items[i].metadata
                local plate = metadata.plate or metadata.type

                if type(plate) == 'string' then
                    plate = plate:gsub('%s+', '')
                    data[plate] = true
                end
            end
            
            for i = 1, #vehicles do
                local vehicle = vehicles[i]
                local vehCoords = GetEntityCoords(vehicle)
                local distance = #(pedCoords - vehCoords)
        
                if distance <= dist then
                    local plate = GetVehicleNumberPlateText(vehicle)
                    local key = plate:gsub('%s+', '')
                    local found = data[key]
                    
                    if found then
                        return found, vehicle, plate
                    end
                end
            end
        else
            lib.notify({ type = 'error', title = 'No Vehicle key',  description = 'Your don\'t have a vehicle keys' })
            
            return false
        end
    end
    
    lib.notify({ type = 'error', title = 'Vehicle Not Found',  description = 'Your vehicle could not be found in the area' })
    
    return false
end

---@param ped number
---@param vehicle number
---@param plate string
local function useVehicleKeys(ped, vehicle, plate)
    local inside = IsPedInAnyVehicle(ped, true)
    local locked = GetVehicleDoorLockStatus(vehicle)
    local hash = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(hash)
    local label = GetLabelText(name)

    if not inside then
        lib.requestModel('p_car_keys_01')
        lib.requestAnimDict('anim@mp_player_intmenu@key_fob@')
        
        local bone = GetPedBoneIndex(ped, 57005)
        local prop = CreateObject(`p_car_keys_01`, coords, true, true, true)
        SetEntityAsMissionEntity(prop, true, true)
        SetModelAsNoLongerNeeded(`p_car_keys_01`)
        
        AttachEntityToEntity(prop, ped, bone, 0.13, 0.060, 0.001, 0.0, 0.0, 15.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 8.0, -1, 48, 0.0, false, false, false)
        RemoveAnimDict('anim@mp_player_intmenu@key_fob@')
        Citizen.Wait(300)
        PlaySoundFrontend(-1, 'BUTTON', 'MP_PROPERTIES_ELEVATOR_DOORS', true)

        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            DetachEntity(prop, false, true)
            DeleteEntity(prop)
        end)
    end

    if locked == 1 then
        if not inside then
            for i = 0, 5 do
                SetVehicleDoorShut(vehicle, i, false)
            end

            Citizen.CreateThread(function()
                StartVehicleHorn(vehicle, 100, `HELDDOWN`, false)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 1)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 1)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 0)
            end)
        end

        SetVehicleDoorsLocked(vehicle, 2)
        PlayVehicleDoorCloseSound(vehicle, 0)
        
        lib.notify({ type = 'error', title = ('Locked %s'):format(plate),  description = ('Your vehicle (%s) is locked'):format((label ~= 'NULL' and label or name )), icon = 'lock', })
    else
        SetVehicleDoorsLocked(vehicle, 1)
        PlayVehicleDoorOpenSound(vehicle, 0)

        if not inside then
            Citizen.CreateThread(function()
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 1)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 1)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 2)
                Citizen.Wait(250)
                SetVehicleLights(vehicle, 0)
            end)
        end
        
        lib.notify({ type = 'success', title = ('Unlocked %s'):format(plate),  description = ('Your vehicle (%s) is unlocked'):format((label ~= 'NULL' and label or name )), icon = 'unlock' })
    end
end

---@param data table
---@param slot table
local function useItem(data, slot)
    local plate = slot.metadata.plate or slot.metadata.type

    if type(plate) == 'string' then
        local ped = PlayerPedId()
        local found, vehicle, plate = vehicleSearch(ped, plate, CONFIG.UseItem.Distance)

        if found then
            useVehicleKeys(ped, vehicle, plate)
        end
    end
end

local function useKeyboard()
    local ped = PlayerPedId()
    local found, vehicle, plate = vehicleSearch(ped, nil, CONFIG.UseKeyboard.Distance)
    
    if found then
        useVehicleKeys(ped, vehicle, plate)
    end
end

exports('useItem', useItem)
RegisterCommand(CONFIG.UseKeyboard.RegisterKey.CommandName, useKeyboard)
RegisterKeyMapping(CONFIG.UseKeyboard.RegisterKey.CommandName, CONFIG.UseKeyboard.RegisterKey.Description, CONFIG.UseKeyboard.RegisterKey.DefaultMapper, CONFIG.UseKeyboard.RegisterKey.DefaultParameter)
