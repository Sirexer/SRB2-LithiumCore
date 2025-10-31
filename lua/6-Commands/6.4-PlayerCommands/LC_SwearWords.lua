local LC = LithiumCore

LC.serverdata.commands["swearwords"] = {
	name = "LC_swearwords"
}

LC.functions.RegisterCommand("swearwords", LC.commands["swearwords"])

COM_AddCommand(LC.serverdata.commands["swearwords"].name, function(player, action, ...)
	if player != consoleplayer then return end
	local sets = LC.serverdata.commands["swearwords"]
	
	local tbw = LC.localdata.swearwords
	local SaveFile = false
	if action == nil
		print(
			"LC_swearwords list - gives swearwords list",
			"LC_swearwords add word1 word2 word3... - adds words to list",
			"LC_swearwords remove word1 word2 word3... - removes words from list",
			"LC_swearwords clear - clears swearwords list",
			"LC_swearwords reset - Returns the default list"
		)
	elseif action:lower() == "list"
		local str_list = ""
		for i = 1, #tbw do
			if i != #tbw
				str_list = str_list..tbw[i]..", "
			elseif i == #tbw
				str_list = str_list..tbw[i].."."
			end
		end
		CONS_Printf(player, "Swearwords list: "..str_list)
	elseif action:lower() == "add"
		local count = 0
		local args = {...}
		for a = 1, #args do
			local IsInList = false
			local index = nil
			if args[a] == "" or args[a] == " " then continue end
			for b = 1, #tbw do
				if args[a]:lower() == tbw[b]:lower()
					IsInList = true
					break
				end
				if tbw[b]:len() == args[a]:len()
				and index == nil
					index = b
				end
			end
			if IsInList == true then continue end
			if index == nil then index = 1 end
			count = $ + 1
			table.insert(tbw, index, args[a])
		end
		if count == 1
			CONS_Printf(player, "Added "..count.." word to swearwords list.")
		else
			CONS_Printf(player, "Added "..count.." words to swearwords list.")
		end
		if count != 0 then SaveFile = true end
	elseif action:lower() == "remove" or action:lower() == "delete"
		local count = 0
		local args = {...}
		for a = 1, #args do
			for b = 1, #tbw do
				if args[a]:lower() == tbw[b]:lower()
					table.remove(tbw, b)
					count = $ + 1
					break
				end
			end
		end
		if count == 1
			CONS_Printf(player, "Removed "..count.." word from swearwords list.")
		else
			CONS_Printf(player, "Removed "..count.." words from swearwords list.")
		end
		if count != 0 then SaveFile = true end
	elseif action:lower() == "clear"
		while true do
			if tbw[1]
				table.remove(tbw, 1)
			else
				break
			end
		end
		CONS_Printf(player, "Swearwords list has been cleared.")
		SaveFile = true
	elseif action:lower() == "default" or action:lower() == "reset"
		local dbw = LC.ChatFilter.defaultswearword
		while tbw[1] do table.remove(tbw, 1) end
		for i = 1, #dbw do
			table.insert(tbw, dbw[i])
		end
		CONS_Printf(player, "Swearwords list has been reset.")
		SaveFile = true
	end
	if SaveFile == true
		local str_list = ""
		for i = 1, #tbw do
			if i != #tbw
				str_list = str_list..tbw[i].."\n"
			elseif i == #tbw
				str_list = str_list..tbw[i]
			end
		end
		local bwcfg_file = io.openlocal(LC.serverdata.clientfolder.."/swearwords.cfg", "w")
		bwcfg_file:write(str_list)
		bwcfg_file:close()
	end
end, COM_LOCAL)

return true
