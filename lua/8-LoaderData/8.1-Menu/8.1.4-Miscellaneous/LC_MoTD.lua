local LC = LithiumCore

local t = {
	name = "LC_MENU_MOTD",
	description = "LC_MENU_MOTD_TIP",
	type = "misc",
	funchud = function(v)
		
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		
		COM_BufInsertText(consoleplayer, "LC_motd")
		LC.functions.saveloadmenustate("load")
	end,
		
	funchook = function(key)
	
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
