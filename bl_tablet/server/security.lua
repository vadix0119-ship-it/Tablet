local Security = {}

local bcrypt = require('bcrypt')

local function getLockoutDuration(attempts)
    for _, tier in ipairs(Config.LockoutPolicy or {}) do
        if attempts >= tier.attempts then
            return tier.duration
        end
    end
    return 0
end

function Security.hashPin(pin)
    local salt = bcrypt.salt(10)
    return bcrypt.digest(pin, salt)
end

function Security.verifyPin(pin, hash)
    return bcrypt.verify(pin, hash)
end

function Security.registerPin(deviceId, pin)
    local hash = Security.hashPin(pin)
    MySQL.update.await('UPDATE tablet_devices SET pin_hash = ?, setup_done = 1 WHERE device_id = ?', { hash, deviceId })
end

function Security.tryUnlock(deviceId, pin)
    local device = MySQL.single.await('SELECT pin_hash, failed_attempts, lock_until FROM tablet_devices WHERE device_id = ?', { deviceId })
    if not device then return false, 'missing_device' end

    if device.lock_until and device.lock_until > os.time() then
        return false, 'locked'
    end

    if Security.verifyPin(pin, device.pin_hash) then
        MySQL.update.await('UPDATE tablet_devices SET failed_attempts = 0, lock_until = NULL WHERE device_id = ?', { deviceId })
        return true
    end

    local attempts = (device.failed_attempts or 0) + 1
    local lockDuration = getLockoutDuration(attempts)
    local lockUntil = nil
    if lockDuration > 0 then
        lockUntil = os.time() + lockDuration
    end

    MySQL.update.await('UPDATE tablet_devices SET failed_attempts = ?, lock_until = ? WHERE device_id = ?', {
        attempts,
        lockUntil,
        deviceId
    })

    return false, lockDuration > 0 and 'locked' or 'invalid_pin', lockDuration
end

return Security
