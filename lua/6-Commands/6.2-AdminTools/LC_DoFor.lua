local LC = LithiumCore

LC.commands["dofor"] = {
	name = "LC_dofor",
	perm = "LC_dofor",
	useonself = true,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("dofor", LC.commands["dofor"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_DOFOR",
	description = "LC_CMD_DOFOR_TIP",
	command = "dofor",
	confirm = "Execute",
	playermenu = {
		enable = true,
		select = 1,
		fastexec = false
	},
	args = {
		{header = "Player", type = "player", optional = false},
		{header = "Command", type = "text", optional = false}
	}
})

LC.functions.RegisterCommand("dofor", LC.commands["dofor"])

COM_AddCommand(LC.serverdata.commands["dofor"].name, function(player, pname, command)
	-- Force someone else's console to execute an arbitrary command.
	-- You can't read their console output, so make sure you don't make a mistake.
	local sets = LC.serverdata.commands["dofor"]
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
		CONS_Printf(player, sets.name.." <name> <command>: execute a command for someone else (server/admin only)")
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
		local text = "`"..player.name.."` Uses command:`"..sets.name.." \""..player2.name.."\" \""..command.."\"`\n"
		if bot_log then bot_log = bot_log..text end
		COM_BufInsertText(player2, command)
	end
end)

return true
