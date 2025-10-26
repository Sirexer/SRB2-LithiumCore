local LC = LithiumCore

LC.commands["flip"] = {
	name = "LC_flip",
	perm = "LC_flip",
	useonself = true,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("flip", LC.commands["flip"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_FLIP",
	description = "LC_CMD_FLIP_TIP",
	command = "flip",
	confirm = "Flip",
	playermenu = {
		enable = true,
		select = 1,
		fastexec = true
	},
	args = {
		{header = "Player", type = "player", optional = false}
	}
})

COM_AddCommand(LC.serverdata.commands["flip"].name, function(player, pname)
	local sets = LC.serverdata.commands["flip"]
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
    if pname == nil then
        CONS_Printf(player, sets.name.." <name/node> to flip the player")
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
		if not (player2.mo.flags2 & MF2_OBJECTFLIP)
			player2.mo.flags2 = $1|MF2_OBJECTFLIP
		else
			player2.mo.flags2 = $1 & ~MF2_OBJECTFLIP
		end
	end
end)

return true
