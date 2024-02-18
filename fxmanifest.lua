fx_version 'cerulean'
games { 'gta5' }
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'm-dev.eu'
description 'Revivestation'
license 'GNU General Public License v3.0'
version '1.0'

dependencies {
    'es_extended',
    'oxmysql',
    'ox_lib',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'locales/*.json',
}