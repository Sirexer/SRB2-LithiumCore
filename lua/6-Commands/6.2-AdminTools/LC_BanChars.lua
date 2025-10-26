local LC = LithiumCore

LC.commands["banchars"] = {
	name = "LC_banchars",
	perm = "LC_banchars",
	useonself = true,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("banchars", LC.commands["banchars"])

COM_AddCommand(LC.serverdata.commands["banchars"].name, function(player, arg)
	local sets = LC.serverdata.commands["banchars"]
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
	if not arg
		local str = ""
		local c = 0
		for i = 1, #LC.serverdata.banchars do
			if c == 0
				str = str..LC.serverdata.banchars[i]
			else
				str = str..", "..LC.serverdata.banchars[i]
			end
			c = $ + 1
		end
		if str != ""
			CONS_Printf(player, "LithCore Banchars list: "..str..".")
		else
			CONS_Printf(player, "LithCore Banchars list is empty.")
		end
		return
	end
	
	
	local args = arg:lower()
	local argn = tonumber(arg)
	local skin_name = args
	local exist = false
	if argn != nil
		if (argn > -1 and argn < #skins)
			skin_name = skins[argn].name
			exist = true
		else
			CONS_Printf(player, "Skin "..tostring(skin).." invalid")
			return
		end
	else
		for s in skins.iterate() do
			if s.name == args
				exist = true
				break
			end
		end
	end
	local index
	for i = 1, #LC.serverdata.banchars do
		if skin_name == LC.serverdata.banchars[i]
			index = i
		end
	end
	if index != nil
		CONS_Printf(player, "Skin "..tostring(skin_name).." removed from banchars.")
		table.remove(LC.serverdata.banchars, index)
	else
		table.insert(LC.serverdata.banchars, skin_name)
		if exist == true
			CONS_Printf(player, "Skin "..tostring(skin_name).." added to banchars.")
		else
			CONS_Printf(player, "Skin "..tostring(skin_name).." invalid but added to banchars.")
		end
	end
	LC.functions.SaveBanChars()
	local change_t = {}
	local ban_t = {}
	for s = 0, #skins-1 do
		for b = 1, #LC.serverdata.banchars
			if skins[s].name ==	LC.serverdata.banchars[b]
				table.insert(ban_t, s, true)
				break
			end
		end
		if not ban_t[s]
			table.insert(change_t, s) 
		end
	end
	if change_t[1] == nil
		CONS_Printf(player, "\x82".."WARNING\x80"..": All skins on the server have been banned, so banchars will not work.")
	end
end)

return true
