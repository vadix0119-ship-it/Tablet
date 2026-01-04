fx_version 'cerulean'
game 'gta5'

name 'bl_tablet'
description 'Framework-agnostic tablet with React NUI'
author 'ChatGPT'
version '0.1.0'

lua54 'yes'

shared_scripts {
    'config.lua',
    'languages.lua'
}

client_scripts {
    'bridge/*.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/*.lua',
    'server/*.lua'
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/assets/*'
}

escrow_ignore {
    'config.lua',
    'languages.lua',
    'sql/schema.sql',
    'bridge/*.lua',
    'client/*.lua',
    'server/*.lua',
    'web/src/**/*'
}
