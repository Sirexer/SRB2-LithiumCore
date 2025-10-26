local LC = LithiumCore

LC.commands["here"] = {
	name = "LC_here",
	perm = "LC_here",
	useonself = false,
	useonhost = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("here", LC.commands["here"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_HERE",
	description = "LC_CMD_HERE_TIP",
	command = "here",
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

COM_AddCommand(LC.serverdata.commands["here"].name, function(player, pname)
	local sets = LC.serverdata.commands["here"]
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
        CONS_Printf(player, sets.name.." <playername/node>: brings the given node")
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
        P_SetOrigin(player2.mo, player.mo.x, player.mo.y, player.mo.z)
        P_FlashPal(player2, PAL_MIXUP, 1*TICRATE)
        S_StartSound(player2.mo, sfx_mixup, player2)
        S_StartSound(player.mo, sfx_mixup, player)
		local text = "`"..player.name.."` Uses command:`"..sets.name.." \""..player2.name.."\"`\n"
		if bot_log then bot_log = bot_log..text end
	end
end)

return true
