local LC = LithiumCore

local json = json //LC_require "json.lua"

local load_voteSettings = function()
	-- Load Server console vars
	local votecvars_data
	local votecvars_file = io.openlocal(LC.serverdata.folder.."/voting_cvars.cfg", "r")
	if votecvars_file
		votecvars_data = votecvars_file:read("*a")
		votecvars_file:close()
		xpcall(
			function()
				votecvars_data = json.decode(votecvars_data)
				
				local sd_t = LC.serverdata.vote_cvars
				
				for k_t, v_t in pairs(votecvars_data) do
					if not v_t then continue end
					if type(v_t) ~= "table" then continue end
					
					local vote_t = LC.vote_types[k_t]

					if sd_t[k_t] then
						for k_c, v_c in pairs(v_t) do
							if not v_c then continue end
							if type(v_c) ~= "string" then continue end
							
							local cvar = vote_t.cvars[k_c]
							if sd_t[k_t][k_c] and cvar
								local string = tostring(v_c)
								local new_value, new_string = LC.functions.parseValue(cvar.PossibleValue, string)
								if new_value == nil and new_string == nil then
									print("\""..string.."\" is not a possible value for \""..k_c.."\"")
									continue
								end
								
								sd_t[k_t][k_c].value = new_value
								sd_t[k_t][k_c].string = new_string
							end
						end
					else
						sd_t[k_t] = {}
						for k_c, v_c in pairs(v_t) do
							sd_t[k_t][k_c] = {string = v_c}
						end
					end
				end
			end,
			function()
				local ostime = os.time()
				print("\x82".."WARNING".."\x80"..": voting_cvars.cfg is damaged, create a new voting_cvars.cfg...")
				print("Damaged file will be saved as voting_cvars_"..ostime..".dead.cfg")
				local copy_file = io.openlocal(LC.serverdata.folder.."/voting_cvars_"..ostime..".dead.cfg", "w")
				copy_file:write(votecvars_data)
				copy_file:close()
				LC.functions.saveVotingSettings()
				if votecvars_data and votecvars_data != ""
					votecvars_data = json.decode(votecvars_data)
				else
					votecvars_data = {}
				end
			end
		)
	else
		votecvars_data = LC.functions.saveVotingSettings()
		if votecvars_data and votecvars_data != ""
			votecvars_data = json.decode(votecvars_data)
		else
			votecvars_data = {}
		end
	end
	return {name = "votecvars_data", value = votecvars_data}
end

table.insert(LC_LoaderCFG["server"], load_voteSettings)

return true
