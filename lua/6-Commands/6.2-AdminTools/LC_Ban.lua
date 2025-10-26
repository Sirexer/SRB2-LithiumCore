local LC = LithiumCore

LC.commands["ban"] = {
	name = "LC_ban",
	perm = "LC_ban",
	useonself = false,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("ban", LC.commands["ban"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_BAN",
	description = "LC_CMD_BAN_TIP",
	command = "ban",
	confirm = "Ban",
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

COM_AddCommand(LC.serverdata.commands["ban"].name, function(player, pname, reason, unban)
	local sets = LC.serverdata.commands["ban"]
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
	if not pname
		if isserver or consoleplayer == player
			print(
				sets.name.." <name/node> <reason> <duration>",
				"Examples:",
				sets.name.." 1 - ban player with node 1",
				sets.name.." Sonic1984 \"Don't be cocky\" - ban player with name 'Sonic1984' and reason 'Don't be cocky'",
				sets.name.." 1 \"bulling\" \"31.12.24 13:00\" - ban player with node 1, reason and duration of the ban until 31.12.2024 13:00"
				)
			end
		return
	end
	local player2 = LC.functions.FindPlayer(pname)
	if player2
		if player2.bot != 0
			CONS_Printf(player, "Cannot't ban bots")
			return
		end
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
		local r
		if reason and reason != "" and reason != " "
			r = reason
		else
			r = "(reason is not given)"
		end
		local int_time
		
		if unban then
			int_time = LC.functions.parseTime(unban)
		end
		
		if not int_time then
			CONS_Printf(player, "\x82".."WARNING".."\x80"..": Wrong date format: must be \"DD.MM.YY\" or \"1d 2h 3min\".")
			return
		elseif int_time <= os.time() then
			CONS_Printf(player, "\x82".."WARNING".."\x80"..": The date cannot be earlier than the current date.")
			return
		end
		local id
		if LC.localdata.playernum[#player2]
			id = LC.localdata.playernum[#player2].id
		end
		
		local moderator
		if player == server and server.jointime == 0
			moderator = "Server"
		elseif player.stuffname
			moderator = player.stuffname
		else
			moderator = player.name
		end
		
		local table_ban = {
			id = id,
			name = player2.name,
			username = player2.stuffname,
			timestamp_unban = int_time,
			reason = r,
			moderator = moderator
		}
		
		table.insert(LC.serverdata.banlist, table_ban)
		if isserver
			LC.functions.SaveBanlist()
			COM_BufInsertText(server, "kick \""..player2.name.."\"")
		end
		if player2 == consoleplayer
			LC.functions.ban(r, int_time, moderator, LC.consvars["LC_servername"].string, LC.serverdata.os_time)
		end
		
	end
end)

return true
