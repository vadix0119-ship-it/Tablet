local Bridge = require('bridge.init')
local cachedDeviceId

RegisterNetEvent('bl_tablet:client:useItem', function(meta)
    cachedDeviceId = meta and meta.deviceId or cachedDeviceId
    TriggerEvent('bl_tablet:client:open')
end)

-- Basic auto close after focus loss
CreateThread(function()
    while true do
        if IsPauseMenuActive() and cachedDeviceId then
            TriggerEvent('bl_tablet:client:close')
        end
        Wait(500)
    end
end)
