local Device = require('server.device')
local Security = require('server.security')
local Bridge = require('bridge.init')

RegisterNetEvent('bl_tablet:server:requestDevice', function(deviceId)
    local src = source
    local ensured = Device.ensureDevice(src, deviceId)
    Device.updateLastSeen(ensured)
    TriggerClientEvent('bl_tablet:client:deviceData', src, ensured, Device.getState(ensured))
end)

RegisterNetEvent('bl_tablet:server:saveProfile', function(deviceId, data)
    local src = source
    Device.saveProfile(deviceId, data)
    Bridge:Notify(src, 'Tablet gespeichert', 'success')
end)

RegisterNetEvent('bl_tablet:server:setPin', function(deviceId, pin)
    Security.registerPin(deviceId, pin)
    TriggerEvent('bl_tablet:server:log', 'pin_set', deviceId, source)
end)

RegisterNetEvent('bl_tablet:server:unlock', function(deviceId, pin)
    local src = source
    local success, reason, duration = Security.tryUnlock(deviceId, pin)
    TriggerClientEvent('bl_tablet:client:unlockResult', src, success, reason, duration)
end)

RegisterNetEvent('bl_tablet:server:pushNotification', function(deviceId, payload)
    local src = source
    MySQL.insert.await('INSERT INTO tablet_notifications (device_id, title, message, icon, created_at, `read`) VALUES (?, ?, ?, ?, NOW(), 0)', {
        deviceId,
        payload.title,
        payload.message,
        payload.icon or 'info'
    })
    TriggerClientEvent('bl_tablet:client:notification', -1, deviceId, payload)
end)

RegisterNetEvent('bl_tablet:server:log', function(event, deviceId, src)
    if not Config.DiscordWebhook or Config.DiscordWebhook == '' then return end
    if Config.WebhookToggles[event] == false then return end
    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode({
        username = 'BL Tablet',
        embeds = {
            {
                title = ('Tablet %s'):format(event),
                description = ('Device: **%s**\nPlayer: **%s**'):format(deviceId, src or 'unknown'),
                color = 3447003,
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end)

exports('OpenTablet', function(srcOrDevice)
    if type(srcOrDevice) == 'number' then
        TriggerClientEvent('bl_tablet:client:open', srcOrDevice)
    else
        -- allow server push open by deviceId later
    end
end)

exports('NotifyTablet', function(deviceId, data)
    TriggerEvent('bl_tablet:server:pushNotification', deviceId, data)
end)

lib.callback.register('bl_tablet:getState', function(_, deviceId)
    return Device.getState(deviceId)
end)
