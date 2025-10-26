local LC = LithiumCore

LC.commands["silence"] = {
	name = "LC_silence",
	perm = "LC_silence",
	useonself = true,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("silence", LC.commands["silence"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_SILENCE",
	description = "LC_CMD_SILENCE_TIP",
	command = "silence",
	confirm = "Silence",
	playermenu = {
		enable = true,
		select = 1, //args[1]
		fastexec = false
	},
	args = {
		{header = "Player", type = "player", optional = false},
		{header = "Seconds", type = "count", optional = false},
		{header = "Reason", type = "text", optional = true}
	}
})

COM_AddCommand(LC.serverdata.commands["silence"].name, function(player, pname, seconds, reason)
	local sets = LC.serverdata.commands["silence"]
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
		CONS_Printf(player, sets.name.." <node> <seconds> <reason>")
		return
	end
	if not seconds then
		CONS_Printf(player, sets.name.." <node> <seconds> <reason>")
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
		local r = ''
		if reason then r = reason end
		local text = "`"..player.name.."` Uses command:".."`"..sets.name.." \""..player2.name.."\" \""..r.."\""..seconds.." seconds`\n"
		if bot_log then bot_log = bot_log..text end
		player2.cantspeak = seconds*TICRATE
		if tonumber(seconds) != 0
			CONS_Printf(player, player2.name.." was silenced for "..seconds.." seconds.")
			chatprintf(player2, "You have been silenced for "..seconds.." seconds.")
		else
			CONS_Printf(player, player2.name.." was unsilenced.")
			chatprintf(player2, "You have been unsilenced.")
		end
		if (reason and tonumber(seconds) != 0)
			chatprintf(player2, "Reason: "..reason)
		end
	end
end)

return true
