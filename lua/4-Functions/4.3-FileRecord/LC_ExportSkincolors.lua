local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.functions.ExportSkincolors = function(colorname, filetype)
	local slot = LC.localdata.skincolors.default
	local format = "all"
	if colorname
		local argn = tonumber(colorname)
		local args = colorname
		if argn
			if LC.localdata.skincolors.slots[argn]
				slot = argn
			else
				print("\x82".."WARNING\x80"..": Slot "..argn.." does not exist. Type LC_sendcolor list in the console to view existing ones.")
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
				print("\x82".."WARNING\x80"..": Skincolor "..args.." not found. Type LC_sendcolor list in the console to view existing ones.")
				return
			end
		end
	end
	if filetype
		if filetype:lower() == "lua"
			format = "lua"
		elseif filetype:lower() == "soc"
			format = "soc"
		elseif filetype:lower() == "json"
			format = "json"
		elseif filetype:lower() == "all"
			format = "all"
		else
			print("\x82".."WARNING\x80"..": Format "..filetype:lower().." is not available, available formats: lua, soc, json..")
			return
		end
	end
	local IsExist = false
	local freeslot_name = "SKINCOLOR_"..string.upper(LC.localdata.skincolors.slots[slot].name)
	local lsc = LC.localdata.skincolors.slots[slot]
	
	local ramp = ""
	local ids = 0
	for i = 1, 16 do
		local int = 0
		if lsc.ramp[i] != nil
		and type(lsc.ramp[i]) == "number"
			int = lsc.ramp[i]
		end
		if ids == 0
			ramp = ramp..int
		else
			ramp = ramp..","..int
		end
		ids = $ + 1
	end
	ramp = ramp
	
	local num = tonumber(lsc.invcolor)
	local invcolor
	if num and num > 0 and num < #skincolors
		invcolor = num
	end
	if not invcolor
		for i = 1, #skincolors-1 do
			if skincolors[i].name:lower() == lsc.invcolor:lower()
				invcolor = i
				break
			end
		end
	end
	if not invcolor
		local v = invcolor:upper()
		if v:sub(1, 10) != "SKINCOLOR_"
			v = _G["SKINCOLOR_"..v]
		end
		xpcall(
			function()
				if _G[v] != nil then invcolor = v end
			end,
			function()
				invcolor = SKINCOLOR_WHITE
			end
		)
	end
		
	local invshade = tonumber(lsc.invshade)
	if not invshade
		invshade = 1
	elseif invshade > 15
		invshade = 15
	elseif invshade < 1
		invshade = 1
	end
	
	local chatcolor
	local v = tonumber(lsc.chatcolor)
	if v != nil
		for i = 1, #LC.colormaps do
			if v == LC.colormaps[i].value
				chatcolor = LC.colormaps[i].value
			end
		end
	else
		chatcolor = 0
	end
	if format == "all" or format == "lua"
		local text = ""
		text = text.."freeslot(\""..freeslot_name.."\")\n"
		text = text.."skincolors["..freeslot_name.."] = {\n"
		text = text.."    name = \""..lsc.name.."\",\n"
		text = text.."    ramp = {"..ramp.."},\n"
		text = text.."    invcolor = "..invcolor..",\n"
		text = text.."    invshade = "..invshade..",\n"
		text = text.."    chatcolor = "..chatcolor..",\n"
		text = text.."    accessible = true\n}"
		local dir = LC.serverdata.clientfolder.."/Skincolors/Lua/"..LC.functions.getname(lsc.name)..".txt"
		local skincolor_file = io.openlocal(dir, "w")
		skincolor_file:write(text)
		skincolor_file:close()
		print("\x83".."NOTICE\x80"..": Skincolor ["..slot.."]"..lsc.name.." saved as lua format. Directory: ./"..dir)
	end
	if format == "all" or format == "soc"
		local text = ""
		text = text.."FREESLOT\n"..freeslot_name.."\n\n"
		text = text.."SKINCOLOR "..freeslot_name.."\n"
		text = text.."NAME = "..lsc.name.."\n"
		text = text.."RAMP = "..ramp.."\n"
		text = text.."INVCOLOR = "..invcolor.."\n"
		text = text.."INVSHADE = "..invshade.."\n"
		text = text.."CHATCOLOR = "..chatcolor.."\n"
		text = text.."ACCESSIBLE = true\n"
		local dir = LC.serverdata.clientfolder.."/Skincolors/SOC/"..LC.functions.getname(lsc.name)..".txt"
		local skincolor_file = io.openlocal(dir, "w")
		skincolor_file:write(text)
		skincolor_file:close()
		print("\x83".."NOTICE\x80"..": Skincolor ["..slot.."]"..lsc.name.." saved as SOC format. Directory: ./"..dir)
	end
	if format == "all" or format == "json"
		local text = "{\n"
		text = text.."    \"name\": \""..lsc.name.."\",\n"
		text = text.."    \"ramp\": ["..ramp.."],\n"
		text = text.."    \"invcolor\": "..invcolor..",\n"
		text = text.."    \"invshade\": "..invshade..",\n"
		text = text.."    \"chatcolor\": "..chatcolor..",\n"
		text = text.."    \"accessible\": true\n"
		text = text.."}"
		local dir = LC.serverdata.clientfolder.."/Skincolors/JSON/"..LC.functions.getname(lsc.name)..".txt"
		local skincolor_file = io.openlocal(dir, "w")
		skincolor_file:write(text)
		skincolor_file:close()
		print("\x83".."NOTICE\x80"..": Skincolor ["..slot.."]"..lsc.name.." saved as JSON format. Directory: ./"..dir)
	end
end

return true
