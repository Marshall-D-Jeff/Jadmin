fx_version 'adamant'
game 'gta5'

server_script '@mysql-async/lib/MySQL.lua'

client_scripts {
    "src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",

    "src/client/components/*.lua",

    "src/client/menu/elements/*.lua",

    "src/client/menu/items/*.lua",

    "src/client/menu/panels/*.lua",

    "src/client/menu/windows/*.lua"

}

client_scripts {
	'cl_admin.lua',
    'cl_utils.lua',
    'cl_users.lua'
}

server_scripts {
	'srv_admin.lua',
}

shared_scripts {
    "cfg_config.lua"
}

dependencies {
	'es_extended'
}

