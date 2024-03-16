author 'Real Stoner Gamer'
version '1.1'
description 'ou can use this script to show a fire effect when the player is on fire'

fx_version "adamant"
lua54 "on"
game "rdr3"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
    'config.lua',
}

client_scripts {
	'client.lua'
}

server_scripts {
	'server.lua'
}
