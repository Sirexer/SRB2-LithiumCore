local LC = LithiumCore

local controls_t = {}
local first = 1

local t = {
	name = "LC_MENU_CONTROLS",
	type = "player",
	description = "LC_MENU_CONTROLS_TIP",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "CONTROL SETUP", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		local real_height = (v.height() / v.dupx())
		local maxslots = real_height/10 - 4
		if controls_t[1]
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
		if LC_menu.nav+1 != LC_menu.lastnav and #controls_t > maxslots and first+maxslots-1 < #controls_t
			v.drawString(318, 180+arrow_y, "\x82"..string.char(27), V_SNAPTOBOTTOM, "right")
		end
		local y = 0
		for i = first, first+maxslots-1 do
			if controls_t and controls_t[i] and controls_t[i].name
				local name = LC.functions.getStringLanguage(controls_t[i].displayname) --or controls_t[i].name
				if LC_menu.nav == i-1
					LC.functions.drawString(v, 136, 30+y, "\x82"..name, V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, 30+y, name, V_SNAPTOTOP, "left")
				end
				if LC_menu.setwhat != controls_t[i].name
					v.drawString(308, 30+y, controls_t[i].key, V_SNAPTOTOP, "right")
				else
					v.drawString(308, 30+y, "\x83"..controls_t[i].key, V_SNAPTOTOP, "right")
				end
				y = $ + 10
			end
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		local LC_Controls = LC.localdata.controls
		controls_t = {}
		local names = {}
		for i in ipairs(LC.controls) do
			if LC.controls[i]
				table.insert(controls_t, {name = LC.controls[i].name, key = LC.controls[i].key, displayname = LC.controls[i].displayname})
				names[LC.controls[i].name] = i
			end
		end
		
		for i in ipairs(LC_Controls) do
			if LC_Controls[i]
				local index = names[LC_Controls[i].name]
				if index
					controls_t[index].key = LC_Controls[i].key
				end
			end
		end
		LC_menu.lastnav = #controls_t-1
	end,
		
	funchook = function(key)
		//LC_menu.setwhat = false
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		local LC_Controls = LC.localdata.controls
		if LC_menu.setwhat == nil
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				LC_menu.setwhat = controls_t[LC_menu.nav+1].name
				LC_menu.block = true
			elseif key.name == "backspace"
				COM_BufInsertText(player, "LC_setcontol \""..controls_t[LC_menu.nav+1].name.."\" \"...\"")
				controls_t[LC_menu.nav+1].key = "..."
			end
		else
			if LC.functions.GetMenuAction(key.name) == LCMA_BACK
				LC_menu.setwhat = nil
				LC_menu.block = nil
				return true
			else
				COM_BufInsertText(player, "LC_setcontol \""..controls_t[LC_menu.nav+1].name.."\" \""..key.name.."\"")
				controls_t[LC_menu.nav+1].key = key.name
				LC_menu.setwhat = nil
				LC_menu.block = nil
				return true
			end
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
