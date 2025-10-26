local LC = LithiumCore

local t = {
	name = "LC_MENU_INFO",
	description = "LC_MENU_INFO_TIP",
	type = "account",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Information", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		local x = 10
		LC.functions.drawString(v, 136, 30, LC.functions.getStringLanguage("LC_MENU_USERNAME")..": "..player.stuffname, V_SNAPTOTOP, "left")
		if IsPlayerAdmin(player)
			LC.functions.drawString(v, 136, 40, LC.functions.getStringLanguage("LC_ADMIN")..": Yes", V_SNAPTOTOP, "left")
		else
			LC.functions.drawString(v, 136, 40, LC.functions.getStringLanguage("LC_ADMIN")..": No", V_SNAPTOTOP, "left")
		end
		if player.group != nil
			LC.functions.drawString(v, 136, 50, LC.functions.getStringLanguage("LC_MENU_GROUP")..": "..LC.serverdata.groups.list[player.group].color..LC.serverdata.groups.list[player.group].displayname, V_SNAPTOTOP, "left")
			if LC.serverdata.groups.list[player.group].perms
				LC.functions.drawString(v, 136, 50+x, LC.functions.getStringLanguage("LC_MENU_PERMLIST")..": ", V_SNAPTOTOP, "left")
				local perms = 1
				local t_index = 1
				while t_index <= #LC.serverdata.groups.list[player.group].perms do
					local str = ""
					while perms <= 4 do
						if t_index <= #LC.serverdata.groups.list[player.group].perms and perms <= 4
							if t_index == #LC.serverdata.groups.list[player.group].perms
								str = str.." "..LC.serverdata.groups.list[player.group].perms[t_index]
							else
								str = str.." "..LC.serverdata.groups.list[player.group].perms[t_index]..","
							end
							str = string.gsub(str, "LC_", "")
							perms = $ + 1
							t_index = $ + 1
						else
							break
						end
					end
					v.drawString(136, 60+x, str, V_SNAPTOTOP, "thin")
					perms = 1
					x = $ + 8
				end
			end
		else
			LC.functions.drawString(v, 136, 50+x, LC.functions.getStringLanguage("LC_MENU_GROUP")..": None", V_SNAPTOTOP, "left")
		end
		if player.LC_timeplayed
			LC.functions.drawString(v, 136, 180, LC.functions.getStringLanguage("LC_MENU_TIMEPLAYED"):format(player.LC_timeplayed.hours..":"..player.LC_timeplayed.minutes..":"..player.LC_timeplayed.seconds..":"..player.LC_timeplayed.tics), V_SNAPTOTOP, "left")
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		LC_menu.nav = 0
		LC_menu.lastnav = 0
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
