local LC = LithiumCore

local t = {
	name = "LC_MENU_CHANGEPASS",
	description = "LC_MENU_CHANGEPASS_TIP",
	type = "account",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Change password", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		local password = LC.functions.getStringLanguage("LC_MENU_PASSWORD")
		if LC_menu.nav == 0
			LC.functions.drawString(v, 136, 30, password, V_SNAPTOTOP|V_YELLOWMAP, "left")
		else
			LC.functions.drawString(v, 136, 30, password, V_SNAPTOTOP, "left")
		end
		v.drawFill(136, 39, 180, 10, 253|V_SNAPTOTOP)
		local viewpass
		if LC_menu.pass == nil then LC_menu.pass = "" end
		if LC_menu.showpass == true
			viewpass = LC_menu.pass
		else
			viewpass = string.gsub(LC_menu.pass, ".", "*")
		end
		if LC_menu.nav == 0 and (leveltime % 4) / 2
			if string.len(viewpass) <= 32
				v.drawString(138, 40, viewpass.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			else
				v.drawString(138, 40, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			end
		else
			if string.len(viewpass) <= 32
				v.drawString(138, 40, viewpass, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			else
				v.drawString(138, 40, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			end	
		end
		
		local showpass = LC.functions.getStringLanguage("LC_MENU_SHOWPASS")
		if LC_menu.showpass == true
			LC.functions.drawString(v, 136, 70, showpass.."(TAB): ON", V_SNAPTOTOP, "thin")
		else
			LC.functions.drawString(v, 136, 70, showpass.."(TAB): OFF", V_SNAPTOTOP, "thin")
		end
		
		local capslock = LC.functions.getStringLanguage("LC_MENU_CAPSLOCK")
		if LC_menu.capslock == true
			LC.functions.drawString(v, 136, 78, capslock..": ON", V_SNAPTOTOP, "thin")
		else
			LC.functions.drawString(v, 136, 78, capslock..": OFF", V_SNAPTOTOP, "thin")
		end
		
		local genepass = LC.functions.getStringLanguage("LC_MENU_GENEPASS")
		if LC_menu.nav == 1
			LC.functions.drawString(v, 136, 50, genepass, V_SNAPTOTOP|V_YELLOWMAP, "left")
		else
			LC.functions.drawString(v, 136, 50, genepass, V_SNAPTOTOP, "left")
		end
		
		local change = LC.functions.getStringLanguage("LC_MENU_CHANGE")
		if LC_menu.nav == 2
			LC.functions.drawString(v, 312, 120, change, V_SNAPTOTOP|V_YELLOWMAP, "right")
		else
			LC.functions.drawString(v, 312, 120, change, V_SNAPTOTOP, "right")
		end
		if LC_menu.lognotice
			if type(LC_menu.lognotice) == "string"
				LC.functions.drawString(v, 136, 62, LC.functions.getStringLanguage(LC_menu.lognotice), V_SNAPTOTOP, "thin")
			end
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		LC_menu.nav = 0
		LC_menu.lastnav = 2
		LC_menu.pass = ""
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		if LC_menu.nav == 0
			LC_menu.pass = LC.functions.InputText(
				"password",
				LC_menu.pass,
				key,
				LC_menu.capslock,
				LC_menu.shift,
				32
			)
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				LC_menu.nav = 2
			end
		elseif LC_menu.nav == 1
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				LC_menu.pass = LC.functions.GetRandomPassword(nil, 10)
				LC_menu.showpass = true
			end
		elseif LC_menu.nav == 2
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				if LC_menu.pass != "" and string.len(LC_menu.pass) >= 6
					if consoleplayer.delaychange
						LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_DELAYPASS")
					else
						COM_BufInsertText(player, "LC_changepass "..LC_menu.pass)
						LC_menu.lognotice = "\x83"..LC.functions.getStringLanguage("LC_SUCCESS")
					end
				elseif LC_menu.user != "" and LC_menu.pass != "" and string.len(LC_menu.pass) < 6
					LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_SHORTPASS")
				elseif LC_menu.user != "" and LC_menu.pass == ""
					LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOPASSWORD")
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
