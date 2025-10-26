local LC = LithiumCore

LC.commands["kick"] = {
	name = "LC_kick",
	perm = "LC_kick",
	useonself = false,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("kick", LC.commands["kick"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_KICK",
	description = "LC_CMD_KICK_TIP",
	command = "kick",
	confirm = "Kick",
	playermenu = {
		enable = true,
		select = 1,
		fastexec = false
	},
		args = {
		{header = "Player", type = "player", optional = false},
		{header = "Reason", type = "text", optional = true, minsymbols = 1, maxsymbols = 32}
	}
})

COM_AddCommand(LC.serverdata.commands["kick"].name, function(player, pname, reason)
	local sets = LC.serverdata.commands["kick"]
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
		CONS_Printf(player, sets.name.." <name> <reason>")
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
		local text = "`"..player.name.."` Uses command:".."`"..sets.name.." \""..player2.name.."\" \""..r.."\"`\n"
		if bot_log then bot_log = bot_log..text end
		if reason
			COM_BufInsertText(server, "kick \""..#player2.."\" \""..reason.."\"")
		else
			COM_BufInsertText(server, "kick \""..#player2.."\"")
		end
	end
end)

return true
