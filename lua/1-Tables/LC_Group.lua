-- Default groups
LithiumCore.group_default = {
	num = { -- List of groups
		"superadmin",
		"admin",
		"moderator",
		"helper",
		"player",
		"unregistered",
		"bot"
	},

	sets = { -- Special groups that cannot be deleted
		["superadmin"] = "superadmin",
		["bot"] = "bot",
		["player"] = "player",
		["unregistered"] = "unregistered"
	},

	list = { -- Group table with data
		["superadmin"] = {
			displayname = "superadmin", -- Name of group
			color = "\x82", -- Color of group
			priority = 999, -- How prioritized is the group
			admin = true, -- Does the group have to have admin access?
			perms = {"all"} -- List of permissions for groups
		},

		["admin"] = {
			displayname = "Admin",
			color = "\x87", 
			priority = 100,
			admin = true,
			perms = {"votekick", "voteban", "votemap", "voteexit", "LC_ban", "LC_kick", "LC_changepassuser", "LC_print", "LC_silence", "LC_print", "LC_kick", "LC_goto", "LC_here", "LC_flip", "LC_scale", "LC_kill", "LC_setplayerscore", "LC_setplayerrings", "LC_setplayerlives", "LC_setplayercolor", "LC_setplayerskin"}
		},

		["moderator"] = {
			displayname = "Mod",
			color = "\x8A", 
			priority = 90,
			admin = false,
			perms = {"LC_silence", "LC_print", "LC_kick", "LC_goto", "LC_here", "LC_flip", "LC_scale"}
		},

		["helper"] = {
			displayname = "Helper",
			color = "\x83", 
			priority = 80,
			admin = false,
			perms = {"LC_goto", "LC_here", "LC_flip", "LC_scale"}
		},

		["player"] = {
			displayname = "Player",
			color = "\x84", 
			priority = 10,
			admin = false,
			perms = {}
		},

		["unregistered"] = {
			displayname = "Guest",
			color = "\x85", 
			priority = 0,
			admin = false,
			perms = {}
		},

		["bot"] = {
			displayname = "Bot",
			color = "\x84", 
			priority = 0,
			admin = false,
			perms = {}
		}
	}
}

return true

