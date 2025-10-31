local LC = LithiumCore

LC.serverdata.commands["ignore"] = {
	name = "LC_ignore"
}

LC.functions.RegisterCommand("ignore", LC.commands["ignore"])

COM_AddCommand(LC.serverdata.commands["ignore"].name, function(player, pname, type)
	local sets = LC.serverdata.commands["ignore"]
	if not pname then
		CONS_Printf(player, sets.name.." <name> <account/player>")
		return
	end
	if not player.LC_ignorelist then player.LC_ignorelist = {} end
	if not player.LC_ignorelist.players then player.LC_ignorelist.players = {} end
	if not player.LC_ignorelist.accounts then player.LC_ignorelist.accounts = {} end
	if type == "player" or type != "player" and type != "account"
		local player2 = LC.functions.FindPlayer(pname)
		if player2 then
			if player == player2
				CONS_Printf(player, "You can't use it on yourself")
				return
			end
			local key
			if player.LC_ignorelist.players[1]
				for i = 1, #player.LC_ignorelist.players do
					if player.LC_ignorelist.players[i] == player2
						key = i
						break
					end
				end
			end
			local acc
			if player.LC_ignorelist.accounts[1]
				for i = 1, #player.LC_ignorelist.accounts do
					if player.LC_ignorelist.accounts[i] == player2.stuffname
						acc = i
						break
					end
				end
			end
			if acc != nil
				table.remove(player.LC_ignorelist.accounts, acc)
				CONS_Printf(player, "Now you'll see messages from "..player2.name)
			else
				if key == nil
					table.insert(player.LC_ignorelist.players, player2)
					CONS_Printf(player, "Now you won't see any messages from "..player2.name)
				else
					table.remove(player.LC_ignorelist.players, key)
					CONS_Printf(player, "Now you'll see messages from "..player2.name)
				end
			end
		end
	elseif type == "account"
		if string.lower(player.stuffname) == string.lower(pname)
			CONS_Printf(player, "You can't use it on yourself")
			return
		end
		local key
		if player.LC_ignorelist.accounts[1]
			for i = 1, #player.LC_ignorelist.accounts do
				if string.lower(player.LC_ignorelist.accounts[i]) == string.lower(pname)
					key = i
					break
				end
			end
		end
		if key == nil
			table.insert(player.LC_ignorelist.accounts, string.lower(pname))
			CONS_Printf(player, "Now you won't see any messages from "..string.lower(pname))
		else
			table.remove(player.LC_ignorelist.accounts, key)
			CONS_Printf(player, "Now you'll see messages from "..string.lower(pname))
		end
	end
end)

return true
