local LC = LithiumCore

LC.commands["changepassuser"] = {
	name = "LC_changepassuser",
	perm = "LC_changepassuser"
}

LC.functions.RegisterCommand("changepassuser", LC.commands["changepassuser"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_CHANGEPASS",
	description = "LC_CMD_CHANGEPASS_TIP",
	command = "changepassuser",
	confirm = "Change",
	playermenu = {
		enable = false,
		select = nil,
		fastexec = false
	},
	args = {
		{header = "Username", type = "username", optional = false, minsymbols = 1, maxsymbols = 21},
		{header = "Password", type = "password", optional = false, minsymbols = 6, maxsymbols = 32}
	}
})

LC.functions.RegisterCommand("changepassuser", LC.commands["changepassuser"])

COM_AddCommand(LC.serverdata.commands["changepassuser"].name, function(player, user, pass)
	local sets = LC.serverdata.commands["changepassuser"]
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
	if user and pass
		if user != LC.functions.getname(user)
			CONS_Printf(player, "Do not use symbols such as / \ | < > * : ? ^ . \" in username")
			return
		end
		if user != string.gsub(user, " ", "")
			CONS_Printf(player, "Don't use spaces in username!")
			return
		end
		if pass != string.gsub(pass, " ", "")
			CONS_Printf(player, "Don't use spaces in passwords!")
			return
		end
		if player.stuffname == user
			CONS_Printf(player, "To change your password, use command <LC_changepass>.")
			return
		end
		if player != server
			COM_BufInsertText(server, "changepassuser "..user.." "..pass.." "..#player)
		else
			COM_BufInsertText(server, "changepassuser "..user.." "..pass)
		end
	else
		CONS_Printf(player, LC.serverdata.commands["changepassuser"].name.." <username> <newpassword>")
	end
end)

return true
