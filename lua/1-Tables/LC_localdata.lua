-- Client side, this data is not received by the server
LithiumCore.localdata = {
	savedpass = {}, -- Saved passwords from a file
	controls = {}, -- Saved сontrols from a file
	pressed_keys = {}, -- List of pressed keys
	menu_state = {}, -- Current menu state
	swearwords = {}, -- Swear table
	skincolors = {default = 1, slots = {}}, -- Table Skincolors loaded from file
	sendcolor = false, -- Whether Skincolor has been uploaded to the server
	loginwindow = false, -- A message box asking you to log into your account
	twofa_enabled = false,
	csay = {}, -- Message on the screen
	cmd_buffer = {},
	AltScores = { -- Current Information Table state
		enabled = false,
		holded = false,
		players = {},
		selected = nil,
		nav = {x = 0, y = 0},
		action = {nav = 1, index = 0, first = 1, args = {}, table = {}, textcolor = 1, errortext = nil },
		popupmsg = {str = nil, y = 0, scale = FU/4, flags = 0 },
		sort = 1,
		reverse = true,
		search = "",
		capslock = false,
		shift = false,
		first = 1
	},
	playernum = {}, -- Contains the player node and its ID
	bannedfromserver = nil, -- Table containing the reason, time of the ban
	timedelayserver = nil, -- 
	motd = {open = false, scroll = 0, nscroll = 0, closing = false}, -- Current MOTD state
	selectemoji = false -- message box with emotes
}

return true
