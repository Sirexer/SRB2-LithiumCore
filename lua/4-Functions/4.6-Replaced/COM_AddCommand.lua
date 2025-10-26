local LC = LithiumCore

-- It's done for testing. When someone uses a command, we will see the player, command and arguments in the console.
LC.replaced_functions.COM_AddCommand = COM_AddCommand

local RunByScript = {
--[[
	[playernode] = {
		player_t = player,
		cmds = {
			["my_command"] = true
		}
	}
]]
}

COM_AddCommand = function(...)
	local args = {...}
	local name = args[1]
	local func = args[2]
	local flags = args[3]
	local NoConsole = args[3]
	if flags == nil then flags = 0 end
	
	if name == "CMD_THINKER" then
		LC.replaced_functions.COM_AddCommand(name, func, flags)
		return
	end
	
	local Auditfunc = function(...)
		local com_args = {...}
		local player = com_args[1]
		func(...)
		if isserver and player != server and player and player.valid and multiplayer
			local str_args = ""
			if #com_args > 1
				str_args = "with args: "
				for i = 2, #com_args do
					if i == #com_args
						str_args = str_args..com_args[i].."."
					else
						str_args = str_args..com_args[i]..", "
					end
				end
			end
			print(player.name.." executed command \""..name.."\" "..str_args)
		
			if DiscordBot and DiscordBot.Data and DiscordBot.Data.log != nil
				local msgdiscord = player.name.." executed command \""..name.."\" "..str_args
				local formated = ""
				for i = 1, msgdiscord:len() do
					if msgdiscord:sub(i,i):byte() > 32 and msgdiscord:sub(i,i):byte() < 127 or msgdiscord:sub(i,i) == " "
						formated = formated..msgdiscord:sub(i,i)
					end
				end
				DiscordBot.Data.log = DiscordBot.Data.log..formated.."\n"
			end
		end
	end
	
	LC.replaced_functions.COM_AddCommand(name, Auditfunc, flags)
	LC.CMD[name] = flags or 0
end

return true -- End Of File
