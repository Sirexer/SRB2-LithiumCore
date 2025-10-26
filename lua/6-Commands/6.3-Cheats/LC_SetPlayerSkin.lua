local LC = LithiumCore

LC.commands["playerskin"] = {
	name = "LC_setplayerskin",
	perm = "LC_setplayerskin",
	useonself = true,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("playerskin", LC.commands["playerskin"])

LC.functions.AddCommandMenu({
	name = "LC_CMD_SETSKIN",
	description = "LC_CMD_SETSKIN_TIP",
	command = "playerskin",
	confirm = "Change",
	playermenu = {
		enable = false,
		select = nil,
		fastexec = false
	},
	args = {
		{header = "Player", type = "player", optional = false},
		{header = "Skin", type = "skin", optional = false}
	}
})

COM_AddCommand(LC.serverdata.commands["playerskin"].name, function(player, pname, skin, silent)
	local sets = LC.serverdata.commands["playerskin"]
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
		CONS_Printf(player, sets.name.." <node> <skin>")
		return
	end
	if not skin then
		CONS_Printf(player, sets.name.." <node> <skin>")
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
		
		local args = skin:lower()
		local argn = tonumber(skin)
		local done = nil
		if argn != nil
			if (argn > -1 and argn < #skins)
				if R_SkinUsable(player2, argn)
					R_SetPlayerSkin(player2, argn)
					done = true
				else
					done = false
				end
			end
		end
		if done == nil
			for s in skins.iterate() do
				if s.name == args
					if R_SkinUsable(player2, args)
						R_SetPlayerSkin(player2, args)
						done = true
					else
						done = false
					end
					break
				end
			end
		end
		
		if done == true
			if silent != "-s" and silent != "silent"
				CONS_Printf(player, "Changed "..player2.name.."'s skin to "..skins[player2.skin].name..".")
				if player != player2
					CONS_Printf(player2, player2.name.." changed your skin to "..skins[player2.skin].name..".")
				end
			end
		elseif done == false
			if silent != "-s" and silent != "silent"
				CONS_Printf(player, "\x82".."WARNING".."\x80: Player has not unlocked this skin.")
			end
		else
			CONS_Printf(player, "Skin "..tostring(skin).." invalid")
		end
	end
end)

return true
