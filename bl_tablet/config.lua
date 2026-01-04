Config = {}

Config.Framework = 'standalone' -- esx | qb | standalone
Config.UseItem = true
Config.ItemName = 'tablet'
Config.Command = 'tablet'
Config.Keybind = 'F3'
Config.Debug = true

Config.DiscordWebhook = ''
Config.WebhookToggles = {
    LoginAttempts = true,
    Lockouts = true,
    Wipes = true,
    Transfers = true
}

Config.DefaultLanguage = 'de'
Config.DefaultTheme = 'auto'
Config.DefaultAccent = '#4e8ef7'
Config.DefaultWallpaper = 'aurora-orange'

Config.AvailableWallpapers = {
    { id = 'aurora-orange', label = 'Aurora Orange', asset = 'wallpapers/orange.jpg' },
    { id = 'midnight-blue', label = 'Midnight Blue', asset = 'wallpapers/midnight.jpg' },
    { id = 'graphite', label = 'Graphite', asset = 'wallpapers/graphite.jpg' }
}

Config.AutoLockMinutes = 5
Config.LockoutPolicy = {
    { attempts = 5, duration = 30 },
    { attempts = 10, duration = 300 }
}

Config.JobRestrictions = {
    dispatch = { esx = { 'police', 'ambulance' }, qb = { 'police', 'ambulance' } },
    mdt = { esx = { 'police' }, qb = { 'police' } }
}

Config.Apps = {
    { id = 'home', label = 'Home', icon = 'home', dock = false },
    { id = 'settings', label = 'Settings', icon = 'settings', dock = true },
    { id = 'notes', label = 'Notes', icon = 'notes', dock = true },
    { id = 'mail', label = 'Mail', icon = 'mail', dock = true },
    { id = 'gallery', label = 'Gallery', icon = 'gallery', dock = false },
    { id = 'browser', label = 'Browser', icon = 'browser', dock = false },
    { id = 'appstore', label = 'App Store', icon = 'appstore', dock = false },
    { id = 'camera', label = 'Camera', icon = 'camera', dock = false }
}

Config.AdminGroups = {
    esx = { 'admin', 'superadmin' },
    qb = { 'god' }
}
