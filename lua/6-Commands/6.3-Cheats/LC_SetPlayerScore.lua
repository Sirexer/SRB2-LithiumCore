local LC = LithiumCore

LC.commands["playerscore"] = {
	name = "LC_setplayerscore",
	perm = "LC_setplayerscore",
	useonself = true,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("playerscore", LC.commands["playerscore"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_SETSCORE",
	description = "LC_CMD_SETSCORE_TIP",
	command = "playerscore",
	confirm = "Change",
	playermenu = {
		enable = false,
		select = nil,
		fastexec = false
	},
	args = {
		{header = "Player", type = "player", optional = false},
		{header = "Score", type = "count", optional = false, min = 0, max = 99999990}
	}
})

COM_AddCommand(LC.serverdata.commands["playerscore"].name, function(player, pname, score, silent)
	local sets = LC.serverdata.commands["playerscore"]
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
		CONS_Printf(player, sets.name.." <node> <score>")
		return
	end
	if not score then
		CONS_Printf(player, sets.name.." <node> <score>")
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
		local n = tonumber(score)
		if n != nil
			if n < 0 then n = 0
			elseif n > 99999990 then n = 99999990 end
			player2.score = n
			if silent != "-s" and silent != "silent"
				CONS_Printf(player, "Changed "..player2.name.."'s score to "..n..".")
				if player != player2
					CONS_Printf(player2, player2.name.." changed your score to "..n..".")
				end
			end
		else
			CONS_Printf(player, "Need a number for score.")
		end
	end
end)

return true
