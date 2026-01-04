local BridgeStandalone = {}

function BridgeStandalone.getIdentifier(src)
    return ('standalone:%s'):format(src)
end

function BridgeStandalone.hasItem(_, _)
    return true
end

function BridgeStandalone.addItem(_, _, _, _)
end

function BridgeStandalone.removeItem(_, _, _)
end

function BridgeStandalone.notify(src, message, messageType)
    print(('Notify %s [%s]: %s'):format(src, messageType or 'info', message))
end

function BridgeStandalone.getJob(_)
    return { name = 'unemployed', grade = 0 }
end

return BridgeStandalone
