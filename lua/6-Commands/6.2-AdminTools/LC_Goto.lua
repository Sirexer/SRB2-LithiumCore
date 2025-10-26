local LC = LithiumCore

LC.commands["goto"] = {
	name = "LC_goto",
	perm = "LC_goto",
	useonself = false,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("goto", LC.commands["goto"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_GOTO",
	description = "LC_CMD_GOTO_TIP",
	command = "goto",
	confirm = "Teleport",
	playermenu = {
		enable = true,
		select = 1,
		fastexec = true
	},
	args = {
		{header = "Player", type = "player", optional = false}
	}
})

LC.functions.RegisterCommand("goto", LC.commands["goto"])

COM_AddCommand(LC.serverdata.commands["goto"].name, function(player, pname)
	local sets = LC.serverdata.commands["goto"]
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
    if pname == nil
        CONS_Printf(player, sets.name.." <playername/node>: Teleports to the given node")
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
		local text = "`"..player.name.."` Uses command:`"..sets.name.." \""..player2.name.."\"`\n"
		if bot_log then bot_log = bot_log..text end
		P_SetOrigin(player.mo, player2.mo.x, player2.mo.y, player2.mo.z)
		P_FlashPal(player, PAL_MIXUP, 1*TICRATE)
		S_StartSound(player2.mo, sfx_mixup, player2)
		S_StartSound(player.mo, sfx_mixup, player)
	end
end)

return true
