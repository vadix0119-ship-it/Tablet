local Device = {}

local function generateDeviceId()
    local random = math.random(100000, 999999)
    local stamp = os.time()
    return ('BLT-%s-%s'):format(random, stamp)
end

function Device.ensureDevice(src, deviceId)
    if deviceId and deviceId ~= '' then
        return deviceId
    end
    local newId = generateDeviceId()
    MySQL.insert.await('INSERT INTO tablet_devices (device_id, created_at, last_seen, locked, failed_attempts, lock_until, setup_done) VALUES (?, NOW(), NOW(), 0, 0, NULL, 0)', {
        newId
    })
    return newId
end

function Device.getState(deviceId)
    local device = MySQL.single.await('SELECT * FROM tablet_devices WHERE device_id = ?', { deviceId })
    local profile = MySQL.single.await('SELECT * FROM tablet_profiles WHERE device_id = ?', { deviceId })
    return {
        device = device,
        profile = profile
    }
end

function Device.updateLastSeen(deviceId)
    MySQL.update.await('UPDATE tablet_devices SET last_seen = NOW() WHERE device_id = ?', { deviceId })
end

function Device.saveProfile(deviceId, data)
    local existing = MySQL.single.await('SELECT device_id FROM tablet_profiles WHERE device_id = ?', { deviceId })
    if existing then
        MySQL.update.await('UPDATE tablet_profiles SET display_name = ?, language = ?, theme = ?, accent = ?, wallpaper = ?, settings_json = ? WHERE device_id = ?', {
            data.displayName,
            data.language,
            data.theme,
            data.accent,
            data.wallpaper,
            json.encode(data.settings or {}),
            deviceId
        })
    else
        MySQL.insert.await('INSERT INTO tablet_profiles (device_id, profile_id, display_name, language, theme, accent, wallpaper, settings_json) VALUES (?, 1, ?, ?, ?, ?, ?, ?)', {
            deviceId,
            data.displayName,
            data.language,
            data.theme,
            data.accent,
            data.wallpaper,
            json.encode(data.settings or {})
        })
    end
end

return Device
