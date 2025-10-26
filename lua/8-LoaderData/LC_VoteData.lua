local LC = LithiumCore

local votes_type = {
	{
		name = "exitlevel",
		help_str = "[reason] - start voting to exit from this level",
		cvars = {
			{name = "Enabled", PossibleValue = CV_OnOff, defaultvalue = 1,
			description = "LC_VOTING_CV_ENABLED"},
			{name = "Only admin", PossibleValue = CV_OnOff, defaultvalue = 0,
			description = "LC_VOTING_CV_ONLYADMIN"},
			{name = "Perm", PossibleValue = nil, defaultvalue = "",
			description = "LC_VOTING_CV_PERM"}
		},
		func_start = function(source, ...)
			local t = {...}
			local reason = t[1]
			
			local cvars = LC.serverdata.vote_cvars["exitlevel"]
			if cvars["onlyadmin"].value == 1 then
				if not IsPlayerAdmin(source) then
					return false, "This vote is for administrators only."
				end
			end
			
			if cvars["perm"].string != "" then
				if not LC.functions.CheckPerms(source, cvars["perm"].string) then
					return false, "You do not have the permission to start this vote."
				end
			end
			
			local hud_data = {
				str_vote = "Exit from this level",
				reason = reason
			}
			local targets = {gamemap}
			
			return true, {hud_data = hud_data, targets = targets}
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
				{header = "Reason", type = "text"}
			}
		}
	},
	
	{
		name = "changemap",
		help_str = "<MAPXX/mapnum> [reason] - start voting to exit from this level",
		cvars = {
			{name = "Enabled", PossibleValue = CV_OnOff, defaultvalue = 1,
			description = "LC_VOTING_CV_ENABLED"},
			{name = "Only admin", PossibleValue = CV_OnOff, defaultvalue = 0,
			description = "LC_VOTING_CV_ONLYADMIN"},
			{name = "Perm", PossibleValue = nil, defaultvalue = "",
			description = "LC_VOTING_CV_PERM"}
		},
		func_start = function(source, ...)
			local t = {...}
			local mapnum = t[1]
			local reason = t[2]
			
			local cvars = LC.serverdata.vote_cvars["changemap"]
			if cvars["onlyadmin"].value == 1 then
				if not IsPlayerAdmin(source) then
					return false, "This vote is for administrators only."
				end
			end
			
			if cvars["perm"].string != "" then
				if not LC.functions.CheckPerms(source, cvars["perm"].string) then
					return false, "You do not have the permission to start this vote."
				end
			end
			
			if not mapnum then
				return false, "<MAPXX/mapnum> [reason] - start voting to exit from this level"
			end
			
			mapnum = LC.functions.FindMap(mapnum)
			if mapnum != nil
				if LC.functions.IsSpecialStage(mapnum) == true
					return false, "This is Special Stage level!"
				end
				if not (mapheaderinfo[mapnum].typeoflevel & LC.Gametypes["all"]["tol"][gametype])
					return false, "This is not a "..LC.Gametypes["all"]["name"][gametype].." level.!"
				end
			else
				return false, "No such map exists"
			end
			
			local mapname = "NO NAME"
			if mapheaderinfo[mapnum].actnum
				if mapheaderinfo[mapnum].actnum == 0 then
					mapname = (mapheaderinfo[mapnum].lvlttl)
				else
					mapname = (mapheaderinfo[mapnum].lvlttl..mapheaderinfo[mapnum].actnum)
				end
			end
			
			local hud_data = {
				str_vote = "Change map to "..mapname,
				reason = reason,
				patchname = LC.functions.BuildMapName(mapnum).."P"
			}
			local targets = {gamemap, mapnum}
			
			return true, {hud_data = hud_data, targets = targets}
		end,
		
		func_action = function(targets)
			local mapnum = targets[2]
			G_ExitLevel(mapnum)
		end,
		
		func_stop = function(targets)
			local source = targets[1]
			local target = targets[2]
			if gamemap == target and source ~= gamemap then
				return true, "The server is currently at this level."
			end
		end,
		
		menu = {
			args = {
				{header = "Map", type = "map"},
				{header = "Reason", type = "text"}
			}
		}
	},
	
	{
		name = "kick",
		help_str = "<pname/node> [reason] - Kicks a player from the server",
		cvars = {
			{name = "Enabled", PossibleValue = CV_OnOff, defaultvalue = 1,
			description = "LC_VOTING_CV_ENABLED"},
			{name = "Only admin", PossibleValue = CV_OnOff, defaultvalue = 0,
			description = "LC_VOTING_CV_ONLYADMIN"},
			{name = "Perm", PossibleValue = nil, defaultvalue = "",
			description = "LC_VOTING_CV_PERM"}
		},
		func_start = function(source, ...)
			local t = {...}
			local target = LC.functions.FindPlayer(t[1])
			local reason = t[2]
			
			local cvars = LC.serverdata.vote_cvars["kick"]
			if cvars["onlyadmin"].value == 1 then
				if not IsPlayerAdmin(source) then
					return false, "This vote is for administrators only."
				end
			end
			
			if cvars["perm"].string != "" then
				if not LC.functions.CheckPerms(source, cvars["perm"].string) then
					return false, "You do not have the permission to start this vote."
				end
			end
			
			if t[1] == nil then
				return false, "<pname/node> [reason] - Kicks a player from the server"
			end
			
			if not target or not target.valid then
				return false, "No one here has that name."
			end
			
			if target == server then
				return false, "You can't kick the host!"
			end
			
			local hud_data = {
				str_vote = "Kick "..target.name,
				reason = reason
			}
			local targets = {target, reason}
			
			return true, {hud_data = hud_data, targets = targets}
		end,
		
		func_action = function(targets)
			local target = targets[1]
			local reason = (targets[2] and "\""..targets[2].."\x80\"") or ""
			COM_BufInsertText(server, "kick "..#target.." "..reason)
		end,
		
		func_stop = function(targets)
			local target = targets[1] 
			if not target or not target.valid then
				return true, "The player has left the server."
			end
		end,
		
		menu = {
			args = {
				{header = "Player", type = "player"},
				{header = "Reason", type = "text"}
			}
		}
	},
	
	{
		name = "ban",
		help_str = "<pname/node> [reason] [date] - Kicks a player from the server",
		cvars = {
			{name = "Enabled", PossibleValue = CV_OnOff, defaultvalue = 1,
			description = "LC_VOTING_CV_ENABLED"},
			{name = "Only admin", PossibleValue = CV_OnOff, defaultvalue = 0,
			description = "LC_VOTING_CV_ONLYADMIN"},
			{name = "Perm", PossibleValue = nil, defaultvalue = "",
			description = "LC_VOTING_CV_PERM"}
		},
		func_start = function(source, ...)
			local t = {...}
			local target = LC.functions.FindPlayer(t[1])
			local reason = t[2]
			local date = LC.functions.parseTime(t[3])
			
			local cvars = LC.serverdata.vote_cvars["ban"]
			if cvars["onlyadmin"].value == 1 then
				if not IsPlayerAdmin(source) then
					return false, "This vote is for administrators only."
				end
			end
			
			if cvars["perm"].string != "" then
				if not LC.functions.CheckPerms(source, cvars["perm"].string) then
					return false, "You do not have the permission to start this vote."
				end
			end
			
			if not t[1] == nil then
				return false, "<pname/node> [reason] [date] - ban a player on the server"
			end
			
			if t[3] and not date then
				return false, "Date format must be \"DD.MM.YY\" or \"1d 2h 3min\""
			end
			
			if not target or not target.valid then
				return false, "No one here has that name."
			end
			
			if target == server then
				return false, "You can't ban the host!"
			end
			
			if date and date+300 <= os.time() then
				return false, "Date can't be earlier than current date."
			end
			
			local relative
			if date then
				relative = LC.functions.convertTimestamp("<t:"..date..":R>")
				relative = relative:gsub("in", "for", 1)
			end
			
			local str_vote = (relative and "Ban "..target.name.." "..relative) or "Ban "..target.name
			
			local hud_data = {
				str_vote = str_vote,
				reason = reason
			}
			local targets = {target, reason, date}
			
			return true, {hud_data = hud_data, targets = targets}
		end,
		
		func_action = function(targets)
			local target = targets[1]
			local reason = (targets[2] and "\""..targets[2].."\x80\"") or ""
			local date   = targets[3] or ""
			COM_BufInsertText(server, "LC_ban "..#target.." "..reason.." "..date)
		end,
		
		func_stop = function(targets)
			local target = targets[1] 
			if not target or not target.valid then
				return true, "The player has left the server."
			end
		end,
		
		menu = {
			args = {
				{header = "Player", type = "player"},
				{header = "Reason", type = "text"},
				{header = "Ban period", type = "text"}
			}
		}
	},
	
	{
		name = "silence",
		help_str = "<pname/node> <seconds> [reason] - start voting to mute a player's chat",
		cvars = {
			{name = "Enabled", PossibleValue = CV_OnOff, defaultvalue = 1,
			description = "LC_VOTING_CV_ENABLED"},
			{name = "Only admin", PossibleValue = CV_OnOff, defaultvalue = 0,
			description = "LC_VOTING_CV_ONLYADMIN"},
			{name = "Perm", PossibleValue = nil, defaultvalue = "",
			description = "LC_VOTING_CV_PERM"}
		},
		func_start = function(source, ...)
			local t = {...}
			local target = LC.functions.FindPlayer(t[1])
			local seconds = tonumber(t[2])
			local reason = t[3]
			
			local cvars = LC.serverdata.vote_cvars["silence"]
			if cvars["onlyadmin"].value == 1 then
				if not IsPlayerAdmin(source) then
					return false, "This vote is for administrators only."
				end
			end
			
			if cvars["perm"].string != "" then
				if not LC.functions.CheckPerms(source, cvars["perm"].string) then
					return false, "You do not have the permission to start this vote."
				end
			end
			
			if not t[1] == nil then
				return false, "<pname/node> <seconds> [reason] - start voting to mute a player's chat"
			end
			
			if not target or not target.valid then
				return false, "No one here has that name."
			end
			
			if target.cantspeak then
				return false, "Player already unable to speak."
			end
			
			if not seconds then
				return false, "seconds should be number"
			end
			
			local hud_data = {
				str_vote = "Silence "..target.name.." for "..seconds.." seconds",
				reason = reason
			}
			local targets = {target, seconds, reason}
			
			return true, {hud_data = hud_data, targets = targets}
		end,
		
		func_action = function(targets)
			local target  = targets[1]
			local seconds = targets[2]
			local reason  = targets[3]
			chatprintf(target, "You have been silenced for "..seconds.." seconds.")
			target.cantspeak = seconds*TICRATE
			if reason and reason ~= ""
				chatprintf(target, "Reason: "..reason)
			end
		end,
		
		func_stop = function(targets)
			local target = targets[1] 
			if not target or not target.valid then
				return true, "The player has left the server."
			end
		end,
		
		menu = {
			args = {
				{header = "Player", type = "player"},
				{header = "seconds", type = "count", min = 1},
				{header = "Reason", type = "text"}
			}
		}
	},
}

for i = 1, #votes_type do
	table.insert(LC_Loaderdata["vote"], votes_type[i])
end

return true
