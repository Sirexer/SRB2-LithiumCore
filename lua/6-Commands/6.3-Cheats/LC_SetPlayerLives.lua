local LC = LithiumCore

LC.commands["playerlives"] = {
	name = "LC_setplayerlives",
	perm = "LC_setplayerlives",
	useonself = true,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("playerlives", LC.commands["playerlives"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_SETLIVES",
	description = "LC_CMD_SETLIVES_TIP",
	command = "playerlives",
	confirm = "Change",
	playermenu = {
		enable = false,
		select = nil,
		fastexec = false
	},
	args = {
		{header = "Player", type = "player", optional = false},
		{header = "Lives", type = "count", optional = false, min = -128, max = 127}
	}
})

COM_AddCommand(LC.serverdata.commands["playerlives"].name, function(player, pname, lives, silent)
	local sets = LC.serverdata.commands["playerlives"]
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
		CONS_Printf(player, sets.name.." <node> <lives>")
		return
	end
	if not lives then
		CONS_Printf(player, sets.name.." <node> <lives>")
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
		local n = tonumber(lives)
		if n != nil
			if n < -127 then n = 127
			elseif n > 128 then n = 127 end
			player2.lives = n
			if silent != "-s" and silent != "silent"
				CONS_Printf(player, "Changed "..player2.name.."'s lives to "..n..".")
				if player != player2
					CONS_Printf(player2, player2.name.." changed your lives to "..n..".")
				end
			end
		else
			CONS_Printf(player, "Need a number for lives.")
		end
	end
end)

return true
