local LC = LithiumCore

local json = json //LC_require "json.lua"

local sc_keys = {"name", "ramp", "invcolor", "invshade", "chatcolor"}

LC.functions.Skincolor = function(player, arg, data_sc)
	local node = tostring(#player)
	if node:len() == 1
		node = "0"..node
	end
	local sc = skincolors[_G["SKINCOLOR_LCSEND"..node]]
	local lc = LC.localdata.skincolors
	if not consoleplayer or player != consoleplayer then return end
	if arg == "save"
		if data_sc
			local index
			for i = 1, #lc.slots do
				if lc.slots[i].name:lower() == data_sc.name:lower()
					index = i
					break
				end
			end
			if index
				lc.slots[index] = data_sc
			else
				table.insert(lc.slots, 1, data_sc)
				index = 1
			end
			lc.default = index
		end
		local ids = 0
		local str = "{\n  \"default\": "..lc.default..",\n  \"slots\": [\n"
		for i = 1, #lc.slots do
			local slot = "    {\n"
			slot = slot.."    \"name\": "..json.encode(lc.slots[i].name)..",\n"
			slot = slot.."    \"ramp\": "..json.encode(lc.slots[i].ramp)..",\n"
			slot = slot.."    \"invcolor\": "..json.encode(lc.slots[i].invcolor)..",\n"
			slot = slot.."    \"invshade\": "..json.encode(lc.slots[i].invshade)..",\n"
			slot = slot.."    \"chatcolor\": "..json.encode(lc.slots[i].chatcolor).."\n"
			slot = slot.."    }"
			if ids == 0
				str = str..slot
			else
				str = str..",\n"..slot
			end
			ids = $ + 1
		end
		str = str.."\n  ]\n}"
		local skincolor_file = io.openlocal(LC.serverdata.clientfolder.."/skincolors.dat", "w")
		skincolor_file:write(str)
		skincolor_file:close()
	elseif arg == "load"
		if lc.slots[lc.default]
			local psc = lc.slots[lc.default]
			local execute = "LC_sendcolor edit "
			for i = 1, #sc_keys do
				local str = ""
				if sc_keys[i] == "ramp"
					//print(#psc.ramp)
					local ids = 0
					str = "ramp="
					for r = 1, #psc.ramp do
						if ids == 0
							str = $..tostring(psc.ramp[r])
						else	
							str = $..","..tostring(psc.ramp[r])
						end
						ids = $ + 1
					end
				else
					str = sc_keys[i].."="..tostring((psc[sc_keys[i]]))
				end
				execute = $.."\""..str.."\" "
			end
			//print(execute)
			COM_BufInsertText(player, execute.." -f -ns")
		end
	end
end

return true
