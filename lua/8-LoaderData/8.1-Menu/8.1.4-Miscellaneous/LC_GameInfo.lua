local LC = LithiumCore

local t = {
	name = "LC_MENU_GAMEINFO",
	description = "LC_MENU_GAMEINFO_TIP",
	type = "misc",
	funchud = function(v)
		
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		
		LC.localdata.AltScores.holded = false
		LC.localdata.AltScores.enabled = true
		LC.localdata.AltScores.selected = nil
		LC.localdata.AltScores.nav = {x = 0, y = 0}
		LC.localdata.AltScores.first = 1
		LC.localdata.AltScores.action = {
			nav = 1,
			index = 0,
			first = 1,
			args = {},
			table = {}
		}
		LC.localdata.AltScores.popupmsg = {
			str = nil,
			y = 0,
			flags = 0
		}
		LC.functions.saveloadmenustate("load")
	end,
		
	funchook = function(key)
		
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
