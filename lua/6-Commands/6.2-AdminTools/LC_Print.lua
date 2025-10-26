local LC = LithiumCore

LC.commands["print"] = {
	name = "LC_print",
	perm = "LC_print",
	useonself = true,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("print", LC.commands["print"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_PRINT",
	description = "LC_CMD_PRINT_TIP",
	command = "print",
	confirm = "Print",
	playermenu = {
		enable = true,
		select = 3,
		fastexec = false
	},
	custom_values = {
		[1] = {
			{name = "Message", value = "m"},
			{name = "Notice message", value = "n"},
			{name = "Warning message", value = "w"},
			{name = "Error message", value = "e"}
		}
	},
	args = {
		{header = "Type", type = "custom_value1", optional = false},
		{header = "Message", type = "text", optional = false},
		{header = "Player", type = "player", optional = true}
	}
})

COM_AddCommand(LC.serverdata.commands["print"].name, function(player, t, message, pname)
	local sets = LC.serverdata.commands["print"]
	-- Print an arbitrary message to the console, not in chat.
	-- You can even make your message look like a Lua violation or other in-game error.
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
	if not t then
		CONS_Printf(player, sets.name.." <type> <message>: print something to the console (server/admin only)")
		CONS_Printf(player, "type: Standard, Notice, Warning, Error")
		return
	end
	if not message then
		message = t
		t = "s"
	end
	local m = ''
	if message then m = message end
	local text = "`"..player.name.."` Uses command:`"..sets.name.." \""..t.."\" \""..message.."\"`\n"
	if bot_log then bot_log = bot_log..text end
	if not pname
		if string.sub(string.lower(t), 1, 1) == "n" then
			print("\x83".."NOTICE: \x80"..message)
		elseif string.sub(string.lower(t), 1, 1) == "w" then
			print("\x82".."WARNING: \x80"..message)
		elseif string.sub(string.lower(t), 1, 1) == "e" then
			print("\x85".."ERROR: \x80"..message)
		else
			print(message)
		end
	else
		local player2 = LC.functions.FindPlayer(pname)
		if player2
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
			if string.sub(string.lower(t), 1, 1) == "n" then
				CONS_Printf(player2, "\x83".."NOTICE: \x80"..message)
			elseif string.sub(string.lower(t), 1, 1) == "w" then
				CONS_Printf(player2, "\x82".."WARNING: \x80"..message)
			elseif string.sub(string.lower(t), 1, 1) == "e" then
				CONS_Printf(player2, "\x85".."ERROR: \x80"..message)
			else
				CONS_Printf(player2, message)
			end
		end
	end
end)

return true
