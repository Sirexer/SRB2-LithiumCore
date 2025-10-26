local LC = LithiumCore

LC.commands["votingsettings"] = {
	name = "LC_votingsettings",
	perm = "LC_votingsettings"
}

LC.functions.RegisterCommand("votingsettings", LC.commands["votingsettings"])

COM_AddCommand(LC.serverdata.commands["votingsettings"].name, function(player, vote_type, cvar, value)
	local sets = LC.serverdata.commands["votingsettings"]
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
	
	if not vote_type or not LC.vote_types[vote_type:lower()] then
		if vote_type and not LC.vote_types[vote_type:lower()] then
			CONS_Printf(player, vote_type.." is not exist!")
		end
	
		CONS_Printf(player, "Available vote types:")
		
		local str_votes = ""
		for k, v in pairs(LC.vote_types) do
			local cvars = ""
			for _, c in pairs(v.cvars) do
				local cvar_name = c.name:gsub(" ", ""):lower()
				--cvars = (_ == 1 and cvars..cvar_name) or cvars..", "..cvar_name
				cvars = cvars..cvar_name..", "
			end
			cvars = cvars:sub(1, #cvars-2)
			str_votes = str_votes.."vote type: "..k.." CVARS: "..cvars..".\n"
		end
		
		if str_votes ~= ""
			str_votes = str_votes:sub(1, str_votes:len() - 1 )
		else
			str_votes = "No available vote types"
		end
			
		CONS_Printf(player, str_votes)
		return
	end
	
	vote_type = vote_type:lower()
	if cvar then cvar = cvar:lower() end
	
	local vote_t = LC.vote_types[vote_type]
	local cvars = vote_t.cvars
	
	if not cvar or not cvars[cvar] then
		if cvar and not cvars[cvar] then
			CONS_Printf(player, cvar.." is not exist!")
		end
	
		CONS_Printf(player, "Available "..vote_type.." cvars:")
		
		for _, c in pairs(cvars) do
			local cvar_name = c.name:gsub(" ", ""):lower()
			local possible = LC.functions.normalizePossibleValue(c.PossibleValue)
			local sd_t = LC.serverdata.vote_cvars[vote_type][cvar_name] --c.serverdata_cvars[cvar_name]
			local current_val, current_str = LC.functions.parseValue(c.PossibleValue, sd_t.string)
			
			CONS_Printf(player, "\x82".."Variable "..cvar_name.."\x80"..": \""..current_str.."\"")
			--[[
			CONS_Printf(player, "\x82".."Variable "..cvar_name..":")
			CONS_Printf(player, " Possible values:")

			if possible and possible.MIN and possible.MAX then
				CONS_Printf(player, "  range from "..possible.MIN.." to "..possible.MAX)
			elseif possible then
				for k, val in pairs(possible) do
					CONS_Printf(player, string.format("  %-3s : %s", val, k))
				end
			else
				CONS_Printf(player, "  any string/number")
			end

			CONS_Printf(player, " Current value: "..tostring(current_str))
			]]
		end
		return
	end
	
	local cvar_t = cvars[cvar]
	local sd_t = LC.serverdata.vote_cvars[vote_type][cvar]
	
	if not value then
		local possible = LC.functions.normalizePossibleValue(cvar_t.PossibleValue)
		local current_val, current_str = LC.functions.parseValue(cvar_t.PossibleValue, sd_t.string)

		CONS_Printf(player, "\x82".."Variable "..cvar..":")
		if cvar_t.description and cvar_t.description ~= "" then
			CONS_Printf(player, " Description:")
			CONS_Printf(player, cvar_t.description)
		end
		
		CONS_Printf(player, " Possible values:")

		if possible and possible.MIN and possible.MAX then
			CONS_Printf(player, "  range from "..possible.MIN.." to "..possible.MAX)
		elseif possible then
			for k, val in pairs(possible) do
				CONS_Printf(player, string.format("  %-3s : %s", val, k))
			end
		else
			CONS_Printf(player, "  any string/number")
		end

		CONS_Printf(player, " Current value: "..tostring(current_str))
		return
	end
	
	local new_value, new_string = LC.functions.parseValue(cvar_t.PossibleValue, value)
	
	if not new_value and not new_string then
		CONS_Printf(player, "\""..value.."\" is not a possible value for \""..cvar.."\"")
		return
	end
	
	sd_t.value = new_value
	sd_t.string = new_string
	sd_t.changed = true
	
	LC.functions.saveVotingSettings()
end)

return true -- End of File
