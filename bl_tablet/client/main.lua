local Bridge = require('bridge.init')
local deviceId
local tabletOpen = false

RegisterNetEvent('bl_tablet:client:open', function()
    if tabletOpen then return end
    tabletOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
    TriggerServerEvent('bl_tablet:server:requestDevice', deviceId)
end)

RegisterNetEvent('bl_tablet:client:close', function()
    tabletOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end)

RegisterNUICallback('ready', function(_, cb)
    TriggerServerEvent('bl_tablet:server:requestDevice', deviceId)
    cb({})
end)

RegisterNUICallback('setPin', function(data, cb)
    TriggerServerEvent('bl_tablet:server:setPin', data.deviceId, data.pin)
    cb({})
end)

RegisterNUICallback('unlock', function(data, cb)
    TriggerServerEvent('bl_tablet:server:unlock', data.deviceId, data.pin)
    cb({})
end)

RegisterNUICallback('saveProfile', function(data, cb)
    TriggerServerEvent('bl_tablet:server:saveProfile', data.deviceId, data.profile)
    cb({})
end)

RegisterNetEvent('bl_tablet:client:deviceData', function(id, state)
    deviceId = id
    SendNUIMessage({ action = 'hydrate', deviceId = id, state = state })
end)

RegisterNetEvent('bl_tablet:client:unlockResult', function(success, reason, duration)
    SendNUIMessage({ action = 'unlockResult', success = success, reason = reason, duration = duration })
end)

RegisterNetEvent('bl_tablet:client:notification', function(targetDeviceId, payload)
    if targetDeviceId ~= deviceId then return end
    SendNUIMessage({ action = 'notification', payload = payload })
end)

CreateThread(function()
    RegisterCommand(Config.Command, function()
        TriggerEvent('bl_tablet:client:open')
    end)
    RegisterKeyMapping(Config.Command, 'Open tablet', 'keyboard', Config.Keybind)
end)
