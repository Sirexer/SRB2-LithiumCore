local LC = LithiumCore

--[[
	Function: LC.functions.AddVote
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
					Callback executed checks in which cases to cancel the vote.

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

		LC.functions.AddVote(exitlevel_vote)
		```

	Notes:
		- If the provided table contains invalid fields, detailed warnings will be printed.
		- All valid votes are stored in `LC.menu.vote` and become visible to the menu system.
		- This is intended for developers extending the in-game voting framework.
]]

LC.functions.AddVote = function(tabledata)
	if type(tabledata) != "table"
		print("\x82".."WARNING".."\x80"..": Expacted table got "..type(tabledata))
	else
		local IsError = false
		if type(tabledata.name) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.name\" is "..type(tabledata.name).." should be \"string\"")
			IsError = true
		end 
		if type(tabledata.command) != "string"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.command\" is "..type(tabledata.command).." should be \"string\"")
			IsError = true
		end
		if type(tabledata.cvartype) != "table"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.cvartype\" is "..type(tabledata.cvartype).." should be \"table\"")
			IsError = true
		else
			for i = 1, #tabledata.cvartype do
				local found = false
				for a = 1, #LC.serverdata.callvote.availableargs do
					if string.lower(tabledata.cvartype[i]) == string.lower(LC.serverdata.callvote.availableargs[a])
						found = true
						break
					end
				end
				if found == false
					print("\x82".."WARNING".."\x80"..": invalid "..string.lower(tabledata.cvartype[i]).." in tabledata.cvartype["..i.."]")
					IsError = true
				end
			end
		end
		if type(tabledata.enable) != "userdata"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.enable\" is "..type(tabledata.enable).." should be \"userdata consvar_t\"")
			IsError = true
		elseif userdataType(tabledata.enable) != "consvar_t"
			print("\x82".."WARNING".."\x80"..": value \"tabledata.enable\" is "..userdataType(tabledata.enable).." should be \"userdata consvar_t\"")
			IsError = true
		end
		if IsError == false
			local t = {
				name = tabledata.name,
				command = tabledata.command,
				cvartype = tabledata.cvartype,
				enable = tabledata.enable
			}
			if LC.menu.vote[0] == nil
				LC.menu.vote[0] = t
			else
				table.insert(LC.menu.vote, t)
			end
			print("\x83".."NOTICE".."\x80"..": Added Vote "..tabledata.name.." to menu")
		end
	end
end

return true
