local LC = LithiumCore

local json = json //LC_require "json.lua"

local hooktable = {
	name = "LC.Menu",
	type = "GameQuit",
	toggle = true,
	TimeMicros = 0,
	func = function(quitting)
		LC.menu.player_state = nil
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true -- End of File
