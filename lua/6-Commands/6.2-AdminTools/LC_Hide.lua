local LC = LithiumCore

LC.commands["hide"] = {
	name = "LC_hide",
	perm = "LC_hide",
	useonself = false,
	useonhost = false,
	onlyhighpriority = true
}

LC.functions.RegisterCommand("hide", LC.commands["hide"])

COM_AddCommand(LC.serverdata.commands["hide"].name, function(player, toggle)
	local sets = LC.serverdata.commands["hide"]
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
	if player.LC_hideadmin == nil then player.LC_hideadmin = false end
	if player.LC_hidegroup == nil then player.LC_hidegroup = false end
	if toggle == nil
		print(
			LC.serverdata.commands["hide"].name.." - Hides the admin badge or group.",
			"Hide admin badge is "..tostring(player.LC_hideadmin)..".",
			"Hide group is "..tostring(player.LC_hidegroup)..".",
			"",
			LC.serverdata.commands["hide"].name.." admin = hides admin badge.",
			LC.serverdata.commands["hide"].name.." group = hides group."
		)
	elseif toggle:lower() == "admin"
		if player.LC_hideadmin == true then player.LC_hideadmin = false
		else player.LC_hideadmin = true end
		print("Hide admin badge is set to "..tostring(player.LC_hideadmin)..".")
	elseif toggle:lower() == "group"
		if player.LC_hidegroup == true then player.LC_hidegroup = false
		else player.LC_hidegroup = true end
		print("Hide group is set to "..tostring(player.LC_hidegroup)..".")
	end
end)

return true
