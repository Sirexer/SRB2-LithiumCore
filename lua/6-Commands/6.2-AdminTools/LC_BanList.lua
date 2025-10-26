local LC = LithiumCore

LC.commands["banlist"] = {
	name = "LC_banlist",
	perm = "LC_banlist",
}

LC.functions.RegisterCommand("banlist", LC.commands["banlist"])

COM_AddCommand(LC.serverdata.commands["banlist"].name, function(player, action, ...)
	local sets = LC.serverdata.commands["banlist"]
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
	if not action
		if isserver or consoleplayer == player
			print(
				sets.name.." action ...",
				"Examples:",
				sets.name.." list - shows the full list.",
				sets.name.." list 1 2 3 ... - shows slots 1 2 3 ... from the list.",
				sets.name.." remove 1 2 3 ... - remove slots 1 2 3 ... from the list.",
				sets.name.." clear ... - Clear banlist."
				)
			end
		return
	end
	local args = {...}
	if action:lower() == "list"
		if server == player or player == consoleplayer
			if args[1]
				for i = 1, #args do
					local index = tonumber(args[i])
					if index == nil then continue end
					local b = LC.serverdata.banlist[index]
					if b != nil
						local unban = "Permanent"
						if b.timestamp_unban then unban = os.date("%c", b.timestamp_unban).." ("..LC.functions.convertTimestamp("<t:"..b.timestamp_unban..":R>")..")" end
						print(
							"Slot - ["..args[i].."]",
							"  ID: "..tostring(b.id),
							"  Name: "..tostring(b.name),
							"  Username: "..tostring(b.username),
							"  Moderator: "..tostring(b.moderator),
							"  Reason: "..tostring(b.reason),
							"  Ban duration "..tostring(unban)
						)
					else
						print("Slot ["..args[i].."] is not on the list.")
					end
				end
			else
				print("Ban list on the server:")
				if not LC.serverdata.banlist[1]
					print("No bans?")
				end
				for i = 1, #LC.serverdata.banlist do
					local b = LC.serverdata.banlist[i]
					local str = ""
					local unban = "Permanent"
					if b.timestamp_unban then unban = os.date("%c", b.timestamp_unban) end
					if b.username != nil then str = str.."Username: "..b.username
					elseif b.username == nil then str = str.." Name: "..b.name end
					if b.id != nil then str = str.." ID: ("..b.id..")" end
					if b.moderator != nil then str = str.." Moderator: "..b.moderator end
					str = str.." Ban duration: "..unban
					print("["..i.."]"..str)
				end
			end
		end
	elseif action:lower() == "remove"
		if args[1]
			for i = 1, #args do
				local index = tonumber(args[i])
				if index == nil then continue end
				local b = LC.serverdata.banlist[index]
				if b != nil
					b.remove = true
					local str = "Slot["..args[i].."] deleted from the list: "
					if b.username != nil then str = str.."Username: "..b.username
					elseif b.username == nil then str = str.." Name: "..b.name end
					if b.id != nil then str = str.." ID: ("..b.id..")" end
					CONS_Printf(player, str)
				else
					CONS_Printf(player, "Slot ["..args[i].."] is not on the list.")
				end
			end
			local new_table = {}
			for i = 1, #LC.serverdata.banlist do
				if LC.serverdata.banlist[i].remove != true
					table.insert(new_table, LC.serverdata.banlist[i])
				end
			end
			LC.serverdata.banlist = new_table
			if isserver
				LC.functions.SaveBanlist()
			end
		else
			CONS_Printf(player, "\x82".."WARNING".."\x80"..": Check list with LC_banlist command and enter slots.")
			return
		end
	elseif action:lower() == "clear"
		LC.serverdata.banlist = {}
		if isserver
			LC.functions.SaveBanlist()
		end
		CONS_Printf(player, "The list of bans has been cleared!")
	end
end)

return true
