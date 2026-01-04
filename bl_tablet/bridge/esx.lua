local ESX = exports['es_extended'] and exports['es_extended']:getSharedObject() or nil

local BridgeESX = {}

function BridgeESX.getIdentifier(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer and xPlayer.identifier or ('offline:%s'):format(src)
end

function BridgeESX.hasItem(src, item)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return false end
    local invItem = xPlayer.getInventoryItem(item)
    return invItem and invItem.count and invItem.count > 0
end

function BridgeESX.addItem(src, item, amount, metadata)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    xPlayer.addInventoryItem(item, amount or 1, metadata)
end

function BridgeESX.removeItem(src, item, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    xPlayer.removeInventoryItem(item, amount or 1)
end

function BridgeESX.notify(src, message, messageType)
    TriggerClientEvent('esx:showNotification', src, message, messageType or 'info')
end

function BridgeESX.getJob(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer and xPlayer.job or { name = 'unemployed', grade = 0 }
end

return BridgeESX
