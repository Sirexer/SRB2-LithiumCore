local LC = LithiumCore

--[[
	Function: LC.functions.addVoteType
	------------------------------
	Registers a new vote type in the LithiumCore voting system.
	This function validates the provided vote table and adds it to the internal vote menu list.

	Arguments:
		tabledata (table)
			- Table containing all data required to define a custom vote.
			  The table must include the following fields:

			Required fields:
				• name (string)
					Unique identifier of the vote command (e.g. "exitlevel").

				• command (string)
					Console command executed when the vote passes.

				• cvartype (table)
					A list of argument types supported by this vote.
					Each entry must match one of the allowed keywords defined in:
					LC.serverdata.callvote.availableargs

				• enable (userdata consvar_t)
					Console variable that enables/disables this vote option.

			Optional fields (commonly used by vote modules):
				• help_str (string)
					Description or usage string shown to players.

				• cvars (table)
					List of console variables related to this vote entry.

				• func_start (function)
					Callback executed when a vote is initiated.
					Receives `(source, ...)` where `source` is the player starting the vote.

				• func_action (function)
					Callback executed if the vote passes successfully.

				• func_stop (function)
					Callback executed if the vote is cancelled or ends prematurely.

				• menu (table)
					Configuration for menu arguments shown in the voting UI.

	Returns:
		nil

	Description:
		This function performs strict type and content validation on `tabledata`.
		If any of the required fields are missing or invalid, a warning message is printed,
		and the vote is not registered.

		On success, the vote entry is inserted into `LC.menu.vote` and becomes available
		in the in-game voting menu system.

	Example:
		```lua
		local exitlevel_vote = {
			name = "exitlevel",
			help_str = "[reason] - start voting to exit from this level",
			cvars = {
				{name = "Enabled", PossibleValue = CV_OnOff, defaultvalue = 1, description = "LC_VOTING_CV_ENABLED"},
				{name = "Only admin", PossibleValue = CV_OnOff, defaultvalue = 0, description = "LC_VOTING_CV_ONLYADMIN"},
				{name = "Perm", PossibleValue = nil, defaultvalue = "", description = "LC_VOTING_CV_PERM"}
			},
			func_start = function(source, ...)
				local t = {...}
				local reason = t[1]
				local cvars = LC.serverdata.vote_cvars["exitlevel"]

				if cvars["onlyadmin"].value == 1 and not IsPlayerAdmin(source) then
					return false, "This vote is for administrators only."
				end

				if cvars["perm"].string ~= "" and not LC.functions.CheckPerms(source, cvars["perm"].string) then
					return false, "You do not have permission to start this vote."
				end

				local hud_data = { str_vote = "Exit from this level", reason = reason }
				local targets = { gamemap }

				return true, { hud_data = hud_data, targets = targets }
			end,

			func_action = function(targets)
				G_ExitLevel()
			end,

			func_stop = function(targets)
				if gamemap ~= targets[1] then
					return true, "The level has been completed."
				end
			end,

			menu = {
				args = {
					{header = "Player", type = "player"},
					{header = "Map", type = "map"},
					{header = "Seconds", type = "count", min = 1},
					{header = "Reason", type = "text"}
				}
			}
		}

		LC.functions.addVoteType(exitlevel_vote)
		```

	Notes:
		- If the provided table contains invalid fields, detailed warnings will be printed.
		- All valid votes are stored in `LC.menu.vote` and become visible to the menu system.
		- This is intended for developers extending the in-game voting framework.
]]


LC.functions.addVoteType = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expacted table got "..type(tabledata))
		return
	end
	local IsError = false
	if type(tabledata.name) != "string"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
		IsError = true
	end 
	if type(tabledata.help_str) != "string"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.help_str\" is "..type(tabledata.help_str).." should be \"string\"")
		IsError = true
	end
	if not tabledata.cvars then tabledata.cvars = {} end
	if type(tabledata.cvars) != "table"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.cvars\" is "..type(tabledata.cvars).." should be \"table\"")
		IsError = true
	end
	if type(tabledata.func_start) != "function"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_start\" is "..type(tabledata.func_start).." should be \"function\"")
		IsError = true
	end
	if type(tabledata.func_action) != "function"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_action\" is "..type(tabledata.func_action).." should be \"function\"")
		IsError = true
	end
	if not tabledata.func_stop then
		function tabledata.func_stop() end
	end
	if type(tabledata.func_stop) != "function"
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_stop\" is "..type(tabledata.func_stop).." should be \"function\"")
		IsError = true
	end
	if type(tabledata.menu) != "table" and tabledata.menu
		print("\x82".."WARNING".."\x80"..": value \"tabledata.func_stop\" is "..type(tabledata.menu).." should be \"function\"")
		IsError = true
	end
	
	if IsError == true then return nil end
	
	tabledata.name = tabledata.name:lower():gsub(" ", "")
	local cvars = {}
	local serverdata_cvars = {}
	for _, v in ipairs(tabledata.cvars) do
		if type(v.name) ~= "string" then
			print("\x82".."WARNING".."\x80"..": value \"cvars[".._.."].name\" is "..type(v.name).." should be \"string\"")
			return
		end
		if v.PossibleValue ~= nil and type(v.PossibleValue) ~= "table" and type(v.PossibleValue) ~= "userdata" then
			print("\x82".."WARNING".."\x80"..": value \"cvars[".._.."].PossibleValue\" is "..type(v.PossibleValue).." should be \"nil\", \"table\" or \"userdata\"")
			return
		end
		if type(v.defaultvalue) ~= "string" and type(v.defaultvalue) ~= "number" then
			print("\x82".."WARNING".."\x80"..": value \"cvars[".._.."].defaultvalue\" is "..type(v.defaultvalue).." should be \"string\" or \"number\"")
			return
		end
		
		local name = v.name
		local defaultvalue = v.defaultvalue
		local PossibleValue = v.PossibleValue
		local description = v.description or "No description"
		
		local value, str = LC.functions.parseValue(v.PossibleValue, v.defaultvalue)
		if value == nil and str == nil then
			print("\x82".."WARNING".."\x80"..": defaultvalue \""..tostring(v.defaultvalue).."\" not valid for option \""..v.name.."\"")
			return
		end
		
		local sd_t = {
			name = name,
			defaultvalue = defaultvalue,
			value = value,
			string = str,
			change = false
		}
		
		local t = {
			name = name,
			defaultvalue = defaultvalue,
			PossibleValue = PossibleValue,
			description = description
		}
		
		
		local cvar = t.name:gsub(" ", ""):lower()
		-- serverdata
		--table.insert(serverdata_cvars, sd_t)
		if LC.serverdata.vote_cvars[tabledata.name] and LC.serverdata.vote_cvars[tabledata.name][cvar] then
			local sd_value = LC.serverdata.vote_cvars[tabledata.name][cvar].string
			local value, str = LC.functions.parseValue(v.PossibleValue, sd_value)
			if value ~= nil or str ~= nil then sd_t.value = value; sd_t.string = str; end
		end
		serverdata_cvars[cvar] = sd_t
		
		-- static data
		--table.insert(cvars, t)
		cvars[cvar] = t
	end
	
	if not cvars["enabled"] 
	or cvars["enabled"].PossibleValue ~= CV_OnOff
	or cvars["enabled"].defaultvalue ~= 0 and cvars["enabled"].defaultvalue ~= 1 then
		local sd_t = {
			name = "Enabled",
			defaultvalue = 1,
			value = 1,
			string = "1",
			changed = false
		}
		
		local t = {
			name = "Enabled",
			defaultvalue = 1,
			PossibleValue = CV_OnOff,
			serverdata = sd_t
		}
		local cvar = t.name:gsub(" ", ""):lower()
		-- serverdata
		--table.insert(serverdata_cvars, 1, sd_t)
		serverdata_cvars[cvar] = sd_t
		
		-- static data
		--table.insert(cvars, 1, t)
		cvars[cvar] = t
	end
	
	LC.vote_types[tabledata.name] = {
		name = tabledata.name,
		help_str = tabledata.help_str,
		cvars = cvars,
		serverdata_cvars = serverdata_cvars,
		func_start = tabledata.func_start,
		func_action = tabledata.func_action,
		func_stop = tabledata.func_stop,
		menu = tabledata.menu
	}
	
	LC.serverdata.vote_cvars[tabledata.name] = serverdata_cvars
	
	
	print("\x83".."NOTICE".."\x80"..": Added Vote Type "..tabledata.name.."")
end

return true
