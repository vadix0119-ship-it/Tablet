local QBCore = exports['qb-core'] and exports['qb-core']:GetCoreObject() or nil

local BridgeQB = {}

function BridgeQB.getIdentifier(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player and Player.PlayerData and Player.PlayerData.citizenid or ('offline:%s'):format(src)
end

function BridgeQB.hasItem(src, item)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return false end
    local items = Player.Functions.GetItemsByName(item)
    return items and #items > 0
end

function BridgeQB.addItem(src, item, amount, metadata)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.AddItem(item, amount or 1, false, metadata)
end

function BridgeQB.removeItem(src, item, amount)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem(item, amount or 1)
end

function BridgeQB.notify(src, message, messageType)
    TriggerClientEvent('QBCore:Notify', src, message, messageType or 'primary')
end

function BridgeQB.getJob(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player and Player.PlayerData.job or { name = 'unemployed', grade = { level = 0 } }
end

return BridgeQB
