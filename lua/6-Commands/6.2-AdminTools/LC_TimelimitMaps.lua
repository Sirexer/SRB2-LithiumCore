local LC = LithiumCore

LC.commands["timelimitmaps"] = {
	name = "LC_timelimitmaps",
	perm = "LC_timelimitmaps",
	useonself = false,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("timelimitmaps", LC.commands["timelimitmaps"])

COM_AddCommand(LC.serverdata.commands["timelimitmaps"].name, function(player, action, ...)
	local sets = LC.serverdata.commands["timelimitmaps"]
	local DoIHavePerm = false
	if not player.group and server != player
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	DoIHavePerm = LC.functions.CheckPerms(player, sets.perm)
	if DoIHavePerm != true
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	local tlm = LC.serverdata.exitlevel.maps
	if action == nil
		if isserver or consoleplayer == player
			print(
				"LC_timelimitmaps list - gives list",
				"LC_timelimitmaps add <mapnum>-<minutes> <mapnum>-<minutes> <mapnum>-<minutes>... - adds maps with timelimit to list",
				"LC_timelimitmaps remove <mapnum>-<minutes> <mapnum>-<minutes> <mapnum>-<minutes>... - removes maps from list",
				"LC_timelimitmaps clear - clears list"
			)
		end
	elseif action:lower() == "add"
		local args = {...}
		for i in ipairs(args) do
			local arg = args[i]
			if not arg:find("-") then continue end
			
			local mapnum = arg:sub(1, arg:find("-")-1)
			local time = tonumber(arg:sub(arg:find("-")+1))
			
			if time == nil then continue end
			time = abs(time)
			
			if tonumber(mapnum) == nil then mapnum = M_MapNumber(mapnum)
			else mapnum = tonumber(mapnum) end
			
			if mapnum < 1 or mapnum > 1035 then continue end
			local mapname = ""
			if mapheaderinfo[mapnum]
				mapname = mapheaderinfo[mapnum].lvlttl
				if mapheaderinfo[mapnum].actnum != 0 then mapname = mapname.." "..mapheaderinfo[mapnum].actnum end
			end
			
			local str_mapnum = tostring(mapnum)
			tlm[str_mapnum] = time
			CONS_Printf(player, "["..mapnum.."]"..mapname.." added to the list with a "..time.." minute timer.")
		end
		LC.functions.SaveTLM()
	elseif action:lower() == "remove"
		local args = {...}
		for i in ipairs(args) do
			local arg = args[i]
			if tlm[arg] != nil
				
				local mapname = ""
				if mapheaderinfo[arg]
					mapname = mapheaderinfo[arg].lvlttl
					if mapheaderinfo[arg].actnum != 0 then mapname = mapname.." "..mapheaderinfo[arg].actnum end
				end
				
				CONS_Printf(player, "["..arg.."]"..mapname.." removed from the list with a "..tlm[arg].." minute timer.")
				tlm[arg] = nil
			end
		end
		LC.functions.SaveTLM()
	elseif action:lower() == "list"
		local str_list = "List Time Limit for maps:\n"
		local i = 0
		for k, v in pairs(tlm) do
			i = $ + 1
			if type(v) != "number" then continue end
			if tonumber(k) == nil then continue end
			
			local mapnum = tonumber(k)
			local mapname = ""
			if mapheaderinfo[mapnum]
				mapname = mapheaderinfo[mapnum].lvlttl
				if mapheaderinfo[mapnum].actnum != 0 then mapname = mapname.." "..mapheaderinfo[mapnum].actnum end
			end
			local minutes = "minutes"
			if v == 1 then minutes = "minute" end
			if i == 1
				str_list = str_list.."["..mapnum.."]"..mapname.." - "..v.." "..minutes.."."
			elseif i != 1
				str_list = str_list:sub(1, str_list:len()-1)..";\n".."["..mapnum.."]"..mapname.." - "..v.." "..minutes.."."
			end
		end
		if i == 0 then str_list = str_list.."List is empty." end
		CONS_Printf(player, str_list)
	elseif action:lower() == "clearlist"
		LC.serverdata.exitlevel.maps = {}
		CONS_Printf(player, "TimelimitMaps has been cleared.")
		LC.functions.SaveTLM()
	end
end)

return true
