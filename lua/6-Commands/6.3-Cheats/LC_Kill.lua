local LC = LithiumCore

LC.commands["kill"] = {
	name = "LC_kill",
	perm = "LC_kill",
	useonself = true,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("kill", LC.commands["kill"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_KILL",
	description = "LC_CMD_KILL_TIP",
	command = "kill",
	confirm = "Kill",
	playermenu = {
		enable = true,
		select = 1,
		fastexec = true
	},
	args = {
		{header = "Player", type = "player", optional = false}
	}
})

COM_AddCommand(LC.serverdata.commands["kill"].name, function(player, pname)
	local sets = LC.serverdata.commands["kill"]
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
    if pname == nil
        CONS_Printf(player, sets.name.." <node>: Kills the player")
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
        P_DamageMobj(player2.mo, nil, nil, 101, DMG_INSTAKILL)
    end
end)

return true
