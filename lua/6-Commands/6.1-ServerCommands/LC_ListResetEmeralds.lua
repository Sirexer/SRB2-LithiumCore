local LC = LithiumCore

COM_AddCommand("LC_listresetemeralds", function(player, ...)
	if player != server then CONS_Printf(player, "This command cannot be used by a remote admin.") return end
	if not ... then CONS_Printf(player, "LC_listresetemeralds <map number>: \nEXAMPLE: \n1)\"LC_listresetemeralds 01 101 748...\" - Which maps will reset emeralds. \n2)\"LC_listresetemeralds show\" - Shows a list. \n3)\"LC_listresetemeralds clear\" - Clears the list.") return end
	if not LC.serverdata.serverstate.emeraldsresetmaps then LC.serverdata.serverstate.emeraldsresetmaps = {} end
	if string.lower(...) == "show"
		local list = ""
		for b=0, #LC.serverdata.serverstate.emeraldsresetmaps do
			if LC.serverdata.serverstate.emeraldsresetmaps[b] != nil
				list = list..LC.serverdata.serverstate.emeraldsresetmaps[b].." "
			end
		end
		if list == "" then CONS_Printf(player, "The list is empty.") end
		if list != "" then CONS_Printf(player, list) end
		return
	end
	if string.lower(...) == "clear"
		for i=0, #LC.serverdata.serverstate.emeraldsresetmaps do
			table.remove(LC.serverdata.serverstate.emeraldsresetmaps)
		end
		CONS_Printf(player, "List has been cleared.")
		return
	end
	local numbers = ""
	for _,i in ipairs({...}) do
		local IsExist = false
		if tonumber(i)
			for b=0, #LC.serverdata.serverstate.emeraldsresetmaps do
				if tonumber(i) == LC.serverdata.serverstate.emeraldsresetmaps[b]
					CONS_Printf(player, "Map number "..tonumber(i).." is already on the list.")
					IsExist = true
				end
			end
			if IsExist == false
				if tonumber(i) > 1035 or  tonumber(i) < 1 then CONS_Printf(player, "The number "..tonumber(i).." cannot be lower than 1 and higher than 1035") end
				if tonumber(i) < 1036 and tonumber(i) > 0
					table.insert(LC.serverdata.serverstate.emeraldsresetmaps, tonumber(i))
					numbers = numbers..tonumber(i).." "
				end
			end
		end
	end
	if numbers != "" then CONS_Printf(player, "Map number(s) "..numbers.."added to the list.") end
	LC.functions.SaveState()
end, 1)

return true
