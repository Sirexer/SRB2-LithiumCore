local LC = LithiumCore

LC.commands["scale"] = {
	name = "LC_scale",
	perm = "LC_scale",
	useonself = true,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("scale", LC.commands["scale"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_SCALE",
	description = "LC_CMD_SCALE_TIP",
	command = "scale",
	confirm = "Change",
	playermenu = {
		enable = true,
		select = 1,
		fastexec = false
	},
	args = {
		{header = "Player", type = "player", optional = false},
		{header = "Scale", type = "float", optional = false, min = 0}
	}
})

COM_AddCommand(LC.serverdata.commands["scale"].name, function(player, pname, scale)
	local sets = LC.serverdata.commands["scale"]
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
	local nScale = LC.functions.floatnumber(scale)

    if pname == nil
        CONS_Printf(player, sets.name.." <target> <number>: Make someone bigger or smaller")
        return
    end

	if not nScale then
		CONS_Printf(player, sets.name.." <target> <number>: Make someone bigger or smaller")
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
		if player2 and player2.valid
			player2.mo.destscale = nScale
			  --print(player.name .. " changed size!")
		end
	end
end)

return true
