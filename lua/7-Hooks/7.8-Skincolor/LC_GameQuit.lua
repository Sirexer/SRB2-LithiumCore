local LC = LithiumCore

local json = json //LC_require "json.lua"

local hooktable = {
	name = "LC.Skincolor",
	type = "GameQuit",
	toggle = true,
	TimeMicros = 0,
	func = function(quitting)
		LC.localdata.sendcolor = false
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
