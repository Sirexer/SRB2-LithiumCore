local LC = LithiumCore

local first = 1

local t = {
	name = "LC_MENU_CLIENTVARIABLES",
	description = "LC_MENU_CLIENTVARIABLES_TIP",
	type = "player",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Variable Commands", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		local real_height = (v.height() / v.dupx())
		local maxslots = real_height/10 - 4
		if LC.menu.vars[1]
			if LC_menu.nav+1 < first
				first = $ - 1
			elseif LC_menu.nav+1 > first+maxslots-1
				first = $ + 1
			end
		end
		-- Animate Arrow
		local arrow_y = 0
		if (leveltime % 10) > 5
			arrow_y = 2
		end
		
		-- Arrow Up
		if LC_menu.nav+1 > 0 and first != 1
			v.drawString(318, 32+arrow_y, "\x82"..string.char(26), V_SNAPTOTOP, "right")
		end
		-- Arrow Down
		if LC_menu.nav+1 != LC_menu.lastnav and #LC.menu.client_vars > maxslots and first+maxslots-1 < #LC.menu.client_vars
			v.drawString(318, 180+arrow_y, "\x82"..string.char(27), V_SNAPTOBOTTOM, "right")
		end
		local y = 0
		for i = first, first+maxslots-1 do
			if LC.menu.client_vars and LC.menu.client_vars[i] and LC.menu.client_vars[i].command
				local name = LC.functions.getStringLanguage(LC.menu.client_vars[i].name)
				if LC_menu.nav+1 == i
					--local name = LC.menu.client_vars[i].name
					LC.functions.drawString(v, 136, 30+y, "\x82"..name, V_SNAPTOTOP, "left", 144)
					v.drawString(308, 30+y, (tostring("\x82".."<"..LC.menu.client_vars[i].command.string..">")), V_SNAPTOTOP, "right")
					if LC.menu.client_vars[i].description
						LC_menu.tip = LC.functions.getStringLanguage(LC.menu.client_vars[i].description)
					else
						LC_menu.tip = ""
					end
				else
					LC.functions.drawString(v, 136, 30+y, name, V_SNAPTOTOP, "left", 144)
					v.drawString(308, 30+y, (tostring(LC.menu.client_vars[i].command.string)), V_SNAPTOTOP, "right")
				end
				y = $ + 10
			end
		end 
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		LC_menu.nav = 0
		LC_menu.lastnav = #LC.menu.client_vars-1
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		local step = (LC_menu.shift and 10) or 1
		if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
			CV_AddValue(LC.menu.client_vars[LC_menu.nav+1].command, -step)
		elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
			CV_AddValue(LC.menu.client_vars[LC_menu.nav+1].command, step)
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
