local LC = LithiumCore

-- The table contains subcategories for Menu.
LC.menu = {
	player_state = nil,
	animation = {
		fade = 0,
		panelx = -168,
		closing = false,
		opening = false,
	},
	vote = {},
	vars = {},
	client_vars = {},
	commands = {},
	HUD_enabled = true,
	subcat = {
		admin = {},
		player = {},
		misc = {},
		account = {}
	}, 
	lastkeys = ""
}

return true
