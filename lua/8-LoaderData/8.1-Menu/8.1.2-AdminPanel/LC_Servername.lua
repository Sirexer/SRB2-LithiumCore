local LC = LithiumCore

local new_servername = ""
local new_dedicatedname = ""
local new_tabmessage = ""
local selected_color = 1
local textcolors = {1, 182, 73, 96, 149, 32, 10, 53, 130, 192, 140, 188, 170, 224, 201, 26}

local GetLastColor = function(text)
	local reversed = string.reverse(text)
	local fc = 1
	local l = string.len(text)+1
	for i = 1, #LC.colormaps do
		if reversed:find(LC.colormaps[i].hex)
			if reversed:find(LC.colormaps[i].hex) < l
				l = reversed:find(LC.colormaps[i].hex)
				fc = i
			end
		end
	end
	return fc
end

local SetNewColor = function(text)
	local str = text
	local len = text:len()
	local ls = text:sub(len)
	if str == ""
		return LC.colormaps[selected_color].hex
	end
	for i = 1, #LC.colormaps do
		if ls == LC.colormaps[i].hex
			//str = str:gsub(LC.colormaps[i].hex, "")
			str = str:sub(1, len-1)
			break
		end
	end
	local reversed = string.reverse(str)
	local fc = 1
	local l = string.len(str)+1
	local IsColorsExists = false
	for i = 1, #LC.colormaps do
		if reversed:find(LC.colormaps[i].hex)
			if reversed:find(LC.colormaps[i].hex) == l
				l = reversed:find(LC.colormaps[i].hex)
				fc = i
				IsColorsExists = true
			end
		end
	end
	if fc != selected_color and IsColorsExists == true
		str = str
	else
		str = str..LC.colormaps[selected_color].hex
	end
	return str
end

local t = {
	name = "LC_MENU_SERVERNAME",
	description = "LC_MENU_SERVERNAME_TIP",
	type = "admin",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Server & dedicated name", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		if LC_menu.nav == 0
			v.drawString(136, 24, (tostring("\x82".."Servername")), V_SNAPTOTOP, "left")
		else
			v.drawString(136, 24, (tostring("Servername")), V_SNAPTOTOP, "left")
		end
		v.drawFill(136, 33, 180, 10, 253|V_SNAPTOTOP)
		if LC_menu.nav == 0 and (leveltime % 4) / 2
			v.drawString(138, 34, new_servername.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
		else
			v.drawString(138, 34, new_servername, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
		end
		
		if LC_menu.nav == 1
			v.drawString(136, 44, (tostring("\x82".."Dedicatedname")), V_SNAPTOTOP, "left")
		else
			v.drawString(136, 44, (tostring("Dedicatedname")), V_SNAPTOTOP, "left")
		end
		v.drawFill(136, 53, 180, 10, 253|V_SNAPTOTOP)
		if LC_menu.nav == 1 and (leveltime % 4) / 2
			v.drawString(138, 54, new_dedicatedname.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
		else
			v.drawString(138, 54, new_dedicatedname, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
		end
		
		if LC_menu.nav == 2
			v.drawString(136, 64, (tostring("\x82".."Tab message")), V_SNAPTOTOP, "left")
		else
			v.drawString(136, 64, (tostring("Tab message")), V_SNAPTOTOP, "left")
		end
		v.drawFill(136, 73, 180, 10, 253|V_SNAPTOTOP)
		if LC_menu.nav == 2 and (leveltime % 4) / 2
			v.drawString(138, 74, new_tabmessage.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
		else
			v.drawString(138, 74, new_tabmessage, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
		end
		
		v.drawString(136, 84, (tostring("Color")), V_SNAPTOTOP, "left")
		local y = 0
		v.drawFill(135, 93, 177, 12, 253|V_SNAPTOTOP)
		v.drawFill(135-11+(11*selected_color), 93, 12, 12, 83|V_SNAPTOTOP)
		for i = 1, #LC.colormaps do
			v.drawFill(136+y, 94, 10, 10, textcolors[i]|V_SNAPTOTOP)
			v.drawString(141+y, 94, LC.colormaps[i].hex..LC.colormaps[i].name:sub(1,1), V_SNAPTOTOP, "center")
			y = $ + 11
		end
		if IsPlayerAdmin(consoleplayer) or server == consoleplayer
			if LC_menu.nav == 3
				v.drawString(312, 184, (tostring("\x82".."Save")), V_SNAPTOTOP, "right")
			else
				v.drawString(312, 184, (tostring("Save")), V_SNAPTOTOP, "right")
			end
		else
			v.drawString(312, 184, (tostring("\x85".."READ ONLY")), V_SNAPTOTOP, "right")
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		new_servername = CV_FindVar("servername").string
		new_dedicatedname = CV_FindVar("LC_dedicatedname").string
		new_tabmessage = CV_FindVar("LC_tabmessage").string
		selected_color = GetLastColor(new_servername)
		LC_menu.lastnav = 3
		LC_menu.nav = 0
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		if not IsPlayerAdmin(consoleplayer) and server ~= consoleplayer then return end
		if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT or LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
				if selected_color == 1
					selected_color = 16
				elseif selected_color != 1
					selected_color = $ - 1
				end
				//new_servername = SetNewColor()
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
				if selected_color == 16
					selected_color = 1
				elseif selected_color != 16
					selected_color = $ + 1
				end
				//new_servername = SetNewColor(new_servername)
			end
			if LC_menu.nav == 0
				new_servername = SetNewColor(new_servername)
			elseif LC_menu.nav == 1
				new_dedicatedname = SetNewColor(new_dedicatedname)
			elseif LC_menu.nav == 2
				new_tabmessage = SetNewColor(new_tabmessage)
			end
		end
		
		if LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
			if LC_menu.nav == 1
				selected_color = GetLastColor(new_servername)
			elseif LC_menu.nav == 2
				selected_color = GetLastColor(new_dedicatedname)
			elseif LC_menu.nav == 3
				selected_color = GetLastColor(new_tabmessage)
			end
		elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
			if LC_menu.nav == 3
				selected_color = GetLastColor(new_servername)
			elseif LC_menu.nav == 0
				selected_color = GetLastColor(new_dedicatedname)
			elseif LC_menu.nav == 1
				selected_color = GetLastColor(new_tabmessage)
			end
		end
		
		if LC_menu.nav == 0
			new_servername = LC.functions.InputText("text", new_servername, key, LC_menu.capslock, LC_menu.shift, 31)
		elseif LC_menu.nav == 1
			new_dedicatedname = LC.functions.InputText("text", new_dedicatedname, key, LC_menu.capslock, LC_menu.shift, 31)
		elseif LC_menu.nav == 2
			new_tabmessage = LC.functions.InputText("text", new_tabmessage, key, LC_menu.capslock, LC_menu.shift, 63)
		elseif LC_menu.nav == 3
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				CV_Set(CV_FindVar("servername"), new_servername)
				CV_Set(CV_FindVar("LC_servername"), new_servername)
				CV_Set(CV_FindVar("LC_dedicatedname"), new_dedicatedname)
				CV_Set(CV_FindVar("LC_tabmessage"), new_tabmessage)
			end
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
