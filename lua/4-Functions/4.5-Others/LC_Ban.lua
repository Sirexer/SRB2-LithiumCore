local LC = LithiumCore

LC.functions.ban = function(reason, unban, moderator, server, server_time)
	COM_BufInsertText(consoleplayer, "exitgame")
	LC.localdata.bannedfromserver = {
		reason = reason,
		unban = unban,
		moderator = moderator,
		server = server,
		server_time = server_time
	}
end

return true
