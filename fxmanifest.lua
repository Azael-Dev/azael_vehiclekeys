fx_version 'cerulean'
game 'gta5'

author 'Azael Dev <contact@azael.dev> (https://www.azael.dev/)'
description 'Vehicle Keys (Lock System)'
version '1.0.1'
url 'https://github.com/Azael-Dev/azael_vehiclekeys'

lua54 'yes'

shared_scripts {
    'config/shared.config.lua'
}

server_scripts {
    'source/server/main.server.lua'
}

client_scripts {
    '@ox_lib/init.lua',
    'config/client.config.lua',
    'source/client/main.client.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory'
}
