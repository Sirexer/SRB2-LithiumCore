local LC = LithiumCore

local json = json //LC_require "json.lua"

LC.commands["permseditor"] = {
	name = "LC_permseditor"
}

LC.functions.RegisterCommand("permseditor", LC.commands["permseditor"])

COM_AddCommand(LC.commands["permseditor"].name, function(player, ...)
	local DoIHavePerm = false
	local sets = LC.commands["permseditor"]
	if not player.data_command and server != player
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	DoIHavePerm = LC.functions.CheckPerms(player, sets.perm)
	if DoIHavePerm != true
		CONS_Printf(player, LC.shrases.noperm)
		return
	end
	if not ... then return end
	if tostring(...):lower() == "confirm"
		if player.LC_permseditor
			local ge = player.LC_permseditor
			if LC.serverdata.commands[ge.name]
				CONS_Printf(player, "\x83".."NOTICE\x80"..": Commandperms \""..ge.name.."\"\x80 has been successfully modified.")
				LC.serverdata.commands[ge.name] = ge.data_command
				LC.functions.SaveCommandPerms()
			end
		end
		return
	end
	local data_command
	local commandname
	local edited = false
	local flags = {}
	for k, v in ipairs({...}) do
		if v:find("=")
			local equal = v:find("=")-1
			local key = v:sub(1, equal) key = key:gsub(" ", "") key = key:lower()
			local value = v:sub(equal+2)
			if key == "name"
				if LC.serverdata.commands[value]
					local target = LC.serverdata.commands[value]
					data_command = {
						name = target.name,
						perm = target.perm,
						useonself = target.useonself,
						useonhost = target.useonhost,
						onlyhighpriority = target.onlyhighpriority
					}
					commandname = value
				else
					for k, v in pairs(LC.serverdata.commands) do
						if LC.serverdata.commands[k].name == value
							local target = LC.serverdata.commands[k]
							data_command = {
								name = target.name,
								perm = target.perm,
								useonself = target.useonself,
								useonhost = target.useonhost,
								onlyhighpriority = target.onlyhighpriority
							}
							commandname = k
							break
						end
					end
					if not data_command or not commandname
						CONS_Printf(player, "\x82".."WARNING\x80"..": Command perms "..value.." doesn't exist.")
						return
					end
				end
				break
			end
		end
	end
	if not data_command or not commandname
		CONS_Printf(player, "\x82".."WARNING\x80"..": Name value is required to edit the commandperms!")
		return
	end
	for k, v in ipairs({...}) do
		if v:lower() == "-force" or v:lower() == "-f" or v:lower() == "-skipconfirm"
			flags.skipconfirm = true
		end
	end
	for k, v in ipairs({...}) do
		if v:find("=")
			local equal = v:find("=")-1
			local key = v:sub(1, equal) key = key:gsub(" ", "") key = key:lower()
			local value = v:sub(equal+2)
			if key == "perm"
				data_command.perm = value
				edited = true
			elseif key == "useonself"
				if value == "1" or value == "yes" or value == "on" or value == "true"
					data_command.useonself = true
				else
					data_command.useonself = false
				end
				edited = true
			elseif key == "useonhost"
				if value == "1" or value == "yes" or value == "on" or value == "true"
					data_command.useonhost = true
				else
					data_command.useonhost = false
				end
				edited = true
			elseif key == "onlyhighpriority"
				if value == "1" or value == "yes" or value == "on" or value == "true"
					data_command.onlyhighpriority = true
				else
					data_command.onlyhighpriority = false
				end
				edited = true
			end
		end
	end
	if data_command
		if edited == true then player.LC_permseditor = {name = commandname, data_command = data_command} end
		if flags.skipconfirm != true
		or edited == false
			if edited == true
				CONS_Printf(player, "Type \""..sets.name.." confirm\" in the console to save the data_command changes.")
				CONS_Printf(player, "Here is the modified configuration of the existing data_command:")
			else
				CONS_Printf(player, "Information about command perms:")
			end
			CONS_Printf(player, "Command perms name: \""..commandname.."\"")
			CONS_Printf(player, "perm: \""..data_command.perm .."\"")
			CONS_Printf(player, "useonself: "..tostring(data_command.useonself))
			CONS_Printf(player, "useonhost: "..tostring(data_command.useonhost))
			CONS_Printf(player, "onlyhighpriority: "..tostring(data_command.onlyhighpriority))
		else
			COM_BufInsertText(player, sets.name.." confirm")
		end
	end
end)

return true
