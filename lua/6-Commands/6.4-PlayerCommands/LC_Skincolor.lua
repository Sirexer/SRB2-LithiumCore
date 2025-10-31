local LC = LithiumCore

local json = json //LC_require "json.lua"

local colormaps = {
	{name = "White", value = 0},
	{name = "Magenta", value = V_MAGENTAMAP},
	{name = "Yellow", value = V_YELLOWMAP},
	{name = "Green", value = V_GREENMAP},
	{name = "Blue", value = V_BLUEMAP},
	{name = "Red", value = V_REDMAP},
	{name = "Gray", value = V_GRAYMAP},
	{name = "Orange", value = V_ORANGEMAP},
	{name = "Sky", value = V_SKYMAP},
	{name = "Purple", value = V_PURPLEMAP},
	{name = "Aqua", value = V_AQUAMAP},
	{name = "Peridot", value = V_PERIDOTMAP},
	{name = "Azure", value = V_AZUREMAP},
	{name = "Brown", value = V_BROWNMAP},
	{name = "Rosy", value = V_ROSYMAP},
	{name = "Invert", value = V_INVERTMAP}
}

local sc_keys = {"name", "ramp", "invcolor", "invshade"}

COM_AddCommand("LC_sendcolor", function(player, ...)
	local args_t = {...}
	local flags = {}
	local node = tostring(#player)
	local editcolor
	if node:len() == 1
		node = "0"..node
	end
	local sc = skincolors[_G["SKINCOLOR_LCSEND"..node]]
	for k, v in ipairs({...}) do
		if v:lower() == "-force" or v:lower() == "-f" or v:lower() == "-skipconfirm"
			flags.skipconfirm = true
		end
		if v:lower() == "-nosave" or v:lower() == "-ns"
			flags.nosave = true
		end
	end
	if ... == "confirm"
		if player.LC_sendcolor
			local psc = player.LC_sendcolor
			for i = 1, #sc_keys do
				if psc[sc_keys[i]] == nil then return end
			end
			local exist = false
			for i = 1, #skincolors-1 do
				if skincolors[i].name:lower() == psc.name:lower()
				and skincolors[_G["SKINCOLOR_LCSEND"..node] ] != skincolors[i]
					exist = true
				end
			end
			if exist == true
				CONS_Printf(player, "\x83".."NOTICE\x80: ".."A skincolor with that name exists on the server.")
			elseif exist == false
				for i = 1, #sc_keys do
					sc[sc_keys[i]] = psc[sc_keys[i]]
					LC.serverdata.skincolors["SKINCOLOR_LCSEND"..node][sc_keys[i]] = psc[sc_keys[i]]
				end
				if psc.chatcolor == nil
					sc.chatcolor = 0
					LC.serverdata.skincolors["SKINCOLOR_LCSEND"..node].chatcolor = 0
				else
					sc.chatcolor = psc.chatcolor
					LC.serverdata.skincolors["SKINCOLOR_LCSEND"..node].chatcolor = psc.chatcolor
				end
				LC.serverdata.skincolors["SKINCOLOR_LCSEND"..node].accessible = true
				sc.accessible = true
			end
			if LC.serverdata.skincolors["SKINCOLOR_LCSEND"..node].accessible == true
				player.skincolor = _G["SKINCOLOR_LCSEND"..node]
				if gamestate == GS_LEVEL
				and player.realmo and player.realmo.valid
					player.realmo.color = _G["SKINCOLOR_LCSEND"..node]
				end
				local cv_color = CV_FindVar("color")
				if player == consoleplayer then CV_StealthSet(cv_color, skincolors[ _G["SKINCOLOR_LCSEND"..node] ].name) end
				if flags.nosave != true
					LC.functions.Skincolor(player, "save", player.LC_sendcolor)
				end
			end
			player.LC_sendcolor = nil
		end
	elseif ... == "list"
		if player != consoleplayer then return end
		if args_t[2]
			local argn = tonumber(args_t[2])
			local args = args_t[2]
			local slot
			if argn
				if LC.localdata.skincolors.slots[argn]
					slot = argn
				else
					CONS_Printf(player, "\x82".."WARNING\x80"..": Slot "..argn.." does not exist.")
					return
				end
			else
				local IsFound = false
				for i = 1, #LC.localdata.skincolors.slots do
					if LC.localdata.skincolors.slots[i].name == args
						slot = i
						IsFound = true
						break
					end
				end
				if IsFound == false
					CONS_Printf(player, "\x82".."WARNING\x80"..": Skincolor "..args.." not found.")
					return
				end
			end
			local lsc = LC.localdata.skincolors.slots[slot]
			local str_ramp = json.encode(lsc.ramp)
			local invcolor
			if type(lsc.invcolor) == "string"
				invcolor = lsc.invcolor
			else
				invcolor = skincolors[lsc.invcolor].name
			end
			local chatcolor = lsc.chatcolor
			if chatcolor != nil
				for i = 1, #colormaps do
					if chatcolor == colormaps[i].value
						chatcolor = colormaps[i].name
						break
					end
				end
			end
			if chatcolor == nil
				chatcolor = "White"
			end
			CONS_Printf(player, "Skincolor name: \""..lsc.name.."\"")
			CONS_Printf(player, "Ramp: "..str_ramp)
			CONS_Printf(player, "Invcolor: "..invcolor)
			CONS_Printf(player, "Invshade: "..lsc.invshade)
			CONS_Printf(player, "Chatcolor: "..chatcolor)
		else 
			local str = "Existing Skincolors from the file:"
			local ids = 0
			for i = 1, #LC.localdata.skincolors.slots do
				if LC.localdata.skincolors.slots[i].name != nil
				and type(LC.localdata.skincolors.slots[i].name) == "string"
					if ids == 0
						str = str.." ["..i.."]"..LC.localdata.skincolors.slots[i].name
					else
						str = str..", ["..i.."]"..LC.localdata.skincolors.slots[i].name
					end
					ids = $ + 1
				end
			end
			str = str.."."
			CONS_Printf(player, str)
		end
	elseif ... == "load"
		if player != consoleplayer then return end
		if args_t[2]
			local argn = tonumber(args_t[2])
			local args = args_t[2]
			if argn
				if LC.localdata.skincolors.slots[argn]
					LC.localdata.skincolors.default = argn
				else
					CONS_Printf(player, "\x82".."WARNING\x80"..": Slot "..argn.." does not exist. Type LC_sendcolor list in the console to view existing ones.")
					return
				end
			else
				local IsFound = false
				for i = 1, #LC.localdata.skincolors.slots do
					if LC.localdata.skincolors.slots[i].name == args
						LC.localdata.skincolors.default = i
						IsFound = true
						break
					end
				end
				if IsFound == false
					CONS_Printf(player, "\x82".."WARNING\x80"..": Skincolor "..args.." not found. Type LC_sendcolor list in the console to view existing ones.")
					return
				end
			end
		end
		LC.functions.Skincolor(player, "load")
		if flags.nosave != true
			LC.functions.Skincolor(player, "save")
		end
	elseif ... == "delete"
		if player != consoleplayer then return end
		if args_t[2]
			local n = tonumber(args_t[2])
			if not n
				for i = 1, #LC.localdata.skincolors.slots do
					if LC.localdata.skincolors.slots[i].name:lower() == args_t[2]:lower()
						n = i
						break
					end
				end
			end
			if LC.localdata.skincolors.slots[n]
				print("\x83".."NOTICE\x80"..": Skincolor "..LC.localdata.skincolors.slots[n].name.." has been successfully removed.")
				table.remove(LC.localdata.skincolors.slots, n)
				LC.functions.Skincolor(consoleplayer, "save")
			else
				CONS_Printf(player, "\x82".."WARNING\x80"..": Skincolor "..args_t[2].." not found. Type LC_sendcolor list in the console to view existing ones.")
				return
			end
		end
	elseif ... == "export"
		if player != consoleplayer then return end
		LC.functions.ExportSkincolors(args_t[2], args_t[3])
	elseif ... == "import"
		if player != consoleplayer then return end
		local skincolors_table = LC.functions.ImportSkincolors(args_t[2], args_t[3])
		if skincolors_table == nil then return end
		for sc = 1, #skincolors_table
			local index
			for i = 1, #LC.localdata.skincolors.slots do
				if LC.localdata.skincolors.slots[i].name:lower() == skincolors_table[sc].name:lower()
					index = i
					break
				end
			end
			if index
				LC.localdata.skincolors.slots[index] = skincolors_table[sc]
			else
				table.insert(LC.localdata.skincolors.slots, skincolors_table[sc])
			end
			print("\x83".."NOTICE\x80"..": Skincolor "..skincolors_table[sc].name.." has been successfully imported.")
		end
		LC.functions.Skincolor(player, "save")
	elseif ... == "edit"
		if sc.accessible == false
			editcolor = {
				name = "SKINCOLOR_LCSEND"..node,
				ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
				invcolor = SKINCOLOR_WHITE,
				invshade = 1,
				chatcolor = 0,
				accessible = true 
			}
		else
			local ramp = {}
			for i = 0, 15 do
				table.insert(ramp, sc.ramp[i])
			end
			editcolor = {
				name = sc.name,
				ramp = ramp,
				invcolor = sc.invcolor,
				invshade = sc.invshade,
				chatcolor = sc.chatcolor,
				accessible = true 
			}
		end
		for k, v in ipairs({...}) do
			if v:find("=")
				local equal = v:find("=")-1
				local key = v:sub(1, equal) key = key:gsub(" ", "") key = key:lower()
				local value = v:sub(equal+2)
				if key == "name"
					local v, reason = LC.functions.CheckName(value)
					if not v then return end
					editcolor.name = v
				elseif key == "ramp"
					local ramp, reason = LC.functions.CheckRamp(value)
					if ramp == nil
						ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
					end
					editcolor.ramp = ramp
				elseif key == "invcolor"
					local invcolor, reason = LC.functions.CheckInvcolor(value)
					if invcolor == nil
						invcolor = SKINCOLOR_WHITE
					end
					editcolor.invcolor = invcolor
				elseif key == "invshade"
					local v = tonumber(value)
					local invshade, reason = LC.functions.CheckInvshade(value)
					if invshade == nil
						invshade = 0
					end
					editcolor.invshade = invshade
				elseif key == "chatcolor"
					local chatcolor, reason = LC.functions.CheckChatcolor(value)
					editcolor.chatcolor = chatcolor
				end
			end
		end
		player.LC_sendcolor = editcolor
		if flags.skipconfirm == true
			if flags.nosave == true
				COM_BufInsertText(player, "LC_sendcolor confirm -ns")
			else
				COM_BufInsertText(player, "LC_sendcolor confirm")
			end
		else
			local str_ramp = json.encode(editcolor.ramp)
			local invcolor = skincolors[editcolor.invcolor].name
			local chatcolor = editcolor.chatcolor
			if chatcolor != nil
				for i = 1, #colormaps do
					if chatcolor == colormaps[i].value
						chatcolor = colormaps[i].name
						break
					end
				end
			end
			if chatcolor == nil
				chatcolor = "White"
			end
			CONS_Printf(player, "Type \"LC_sendcolor confirm\" in the console to save the skincolor changes.")
			CONS_Printf(player, "Here is the modified configuration of skincolor:")
			CONS_Printf(player, "Skincolor name: \""..editcolor.name.."\"")
			CONS_Printf(player, "Ramp: "..str_ramp)
			CONS_Printf(player, "Invcolor: "..invcolor)
			CONS_Printf(player, "Invshade: "..editcolor.invshade)
			CONS_Printf(player, "Chatcolor: "..chatcolor)
		end
	end
end)

return true
