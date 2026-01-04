Bridge = {}

local framework = string.lower(Config.Framework or 'standalone')

local handlers = {
    esx = 'bridge.esx',
    qb = 'bridge.qb',
    standalone = 'bridge.standalone'
}

local module = handlers[framework] or handlers.standalone
local loaded = require(module)

Bridge = loaded

function Bridge:GetPlayerIdentifier(src)
    return loaded.getIdentifier(src)
end

function Bridge:HasItem(src, item)
    if loaded.hasItem then
        return loaded.hasItem(src, item)
    end
    return true
end

function Bridge:RemoveItem(src, item, amount)
    if loaded.removeItem then
        return loaded.removeItem(src, item, amount)
    end
end

function Bridge:AddItem(src, item, amount, metadata)
    if loaded.addItem then
        return loaded.addItem(src, item, amount, metadata)
    end
end

function Bridge:Notify(src, message, messageType)
    if loaded.notify then
        return loaded.notify(src, message, messageType)
    end
    print(('Notify %s [%s]: %s'):format(src, messageType or 'info', message))
end

function Bridge:GetJob(src)
    if loaded.getJob then
        return loaded.getJob(src)
    end
    return { name = 'unemployed', grade = 0 }
end

return Bridge
