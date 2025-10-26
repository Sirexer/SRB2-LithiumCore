local LC = LithiumCore

LC.commands["pilotplayer"] = {
	name = "LC_pilotplayer",
	perm = "LC_pilotplayer",
	useonself = true,
	onlyhighpriority = false
}

LC.functions.RegisterCommand("pilotplayer", LC.commands["pilotplayer"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_PILOTPLAYER",
	description = "LC_CMD_PILOTPLAYER_TIP",
	command = "pilotplayer",
	confirm = "Get Control",
	playermenu = {
		enable = true,
		select = 1,
		fastexec = true
	},
	args = {
		{header = "Player", type = "player", optional = true}
	}
})

COM_AddCommand(LC.serverdata.commands["pilotplayer"].name, function(player, p2)
	local sets = LC.serverdata.commands["pilotplayer"]
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
	if not p2 then return end
	local player2 = LC.functions.FindPlayer(p2)
	if player2
		if sets.useonself == false
			if player == player2
				CONS_Printf(player, "You can't use it on yourself")
				return
			end
		end
		if player2 == server
			if player != server
				CONS_Printf(player, "You can't use it on host")
				return
			end
		end
		if player != server and sets.onlyhighpriority == true
			if LC.serverdata.groups.list[player2.group].priority >= LC.serverdata.groups.list[player.group].priority
				CONS_Printf(player, LC.shrases.highpriority)
				return
			end
		end
		if player2 != player
			player.LC_pilot = {
				player = player2,
				angle = player.drawangle
			}
		else
			player.LC_pilot = nil 
			displayplayer = player
			player.charability = skins[player.skin].ability
			player.charability2 = skins[player.skin].ability2
			player.jumpfactor = skins[player.skin].jumpfactor
			player.normalspeed = skins[player.skin].normalspeed
			player.actionspd = skins[player.skin].actionspd
			player.runspeed = skins[player.skin].runspeed
			player.acceleration = skins[player.skin].acceleration
		end
	end
	if p2 == "off"
		player.LC_pilot = nil 
		displayplayer = player
		player.charability = skins[player.skin].ability
		player.charability2 = skins[player.skin].ability2
		player.jumpfactor = skins[player.skin].jumpfactor
		player.normalspeed = skins[player.skin].normalspeed
		player.actionspd = skins[player.skin].actionspd
		player.runspeed = skins[player.skin].runspeed
		player.acceleration = skins[player.skin].acceleration
	end
end)

return true
