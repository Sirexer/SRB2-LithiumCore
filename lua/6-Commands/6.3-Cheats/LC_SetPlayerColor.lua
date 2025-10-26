local LC = LithiumCore

LC.commands["playercolor"] = {
	name = "LC_setplayercolor",
	perm = "LC_setplayercolor",
	useonself = true,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("playercolor", LC.commands["playercolor"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_SETCOLOR",
	description = "LC_CMD_SETCOLOR_TIP",
	command = "playercolor",
	confirm = "Change",
	playermenu = {
		enable = false,
		select = nil,
		fastexec = false
	},
	args = {
		{header = "Player", type = "player", optional = false},
		{header = "Color", type = "skincolor", accessible = 1}
	}
})

COM_AddCommand(LC.serverdata.commands["playercolor"].name, function(player, pname, color, silent)
	local sets = LC.serverdata.commands["playercolor"]
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
	if not pname then
		CONS_Printf(player, sets.name.." <node> <color>")
		return
	end
	if not color then
		CONS_Printf(player, sets.name.." <node> <color>")
		return
	end
	local player2 = LC.functions.FindPlayer(pname)
	if player2 then
		if sets.useonself == false
			if player == player2
				CONS_Printf(player, "You can't use it on yourself")
				return
			end
		end
		if sets.useonhost == false
			if player2 == server
				if player != server
					CONS_Printf(player, "You can't use it on host")
					return
				end
			end
		end
		if player != server and sets.onlyhighpriority == true
			if LC.serverdata.groups.list[player2.group].priority >= LC.serverdata.groups.list[player.group].priority and player != player2
				CONS_Printf(player, LC.shrases.highpriority)
				return
			end
		end
		
		local args = color:lower()
		local argn = tonumber(color)
		local done = false
		if argn
			if (argn > 0 and argn < #skincolors) or argn == -1
				player2.skincolor = argn
				player2.mo.color = argn
				done = true
			end
		end
		if R_GetColorByName(args) and done == false
			player2.skincolor = R_GetColorByName(args)
			player2.mo.color = R_GetColorByName(args)
			done = true
		end
		
		if done == true
			local colorname = ""
			if R_GetColorByName(args) then colorname = skincolors[R_GetColorByName(args)].name
			else colorname = skincolors[argn].name end 
			if silent != "-s" and silent != "silent"
				CONS_Printf(player, "Changed "..player2.name.."'s color to "..colorname..".")
				if player != player2
					CONS_Printf(player2, player2.name.." changed your color to "..colorname..".")
				end
			end
		else
			CONS_Printf(player, "Color "..tostring(color).." invalid")
		end
	end
end)

return true
