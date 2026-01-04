Locales = {
    de = {
        onboarding_title = 'Tablet Einrichten',
        onboarding_language = 'Sprache wählen',
        onboarding_region = 'Region & Zeitzone',
        onboarding_pin = 'PIN oder Passwort setzen',
        onboarding_biometrics = 'Biometrie (RP)',
        onboarding_theme = 'Design wählen',
        onboarding_wallpaper = 'Wallpaper wählen',
        onboarding_name = 'Name des Tablets',
        lockscreen_enter_pin = 'PIN oder Passwort eingeben',
        lockscreen_forgot = 'PIN vergessen?',
        settings_title = 'Einstellungen',
        settings_theme = 'Design',
        settings_wallpaper = 'Wallpaper',
        settings_language = 'Sprache',
        settings_accent = 'Akzentfarbe',
        settings_security = 'Sicherheit',
        settings_autolock = 'Auto-Lock',
        settings_about = 'Über dieses Tablet'
    },
    en = {
        onboarding_title = 'Set up tablet',
        onboarding_language = 'Choose language',
        onboarding_region = 'Region & timezone',
        onboarding_pin = 'Set PIN or password',
        onboarding_biometrics = 'Biometrics (RP)',
        onboarding_theme = 'Choose theme',
        onboarding_wallpaper = 'Select wallpaper',
        onboarding_name = 'Device name',
        lockscreen_enter_pin = 'Enter PIN or password',
        lockscreen_forgot = 'Forgot PIN?',
        settings_title = 'Settings',
        settings_theme = 'Appearance',
        settings_wallpaper = 'Wallpaper',
        settings_language = 'Language',
        settings_accent = 'Accent color',
        settings_security = 'Security',
        settings_autolock = 'Auto-Lock',
        settings_about = 'About this tablet'
    }
}

function _L(locale, key)
    local language = Locales[locale] or Locales[Config.DefaultLanguage]
    return language[key] or key
end
