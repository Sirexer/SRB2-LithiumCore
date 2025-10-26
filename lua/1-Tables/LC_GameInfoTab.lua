local LC = LithiumCore

LC.SortingPlayers = { -- Functions to sort the players in the information board
	{
		name = "playername",
		func = function()
			local t = {}
			for player in players.iterate do
				if player and player.valid
					table.insert(t, player)
				end
			end
			table.sort(
				t,
				function(a,b)
					if LC.localdata.AltScores.reverse == false
						return b.name > a.name
					elseif LC.localdata.AltScores.reverse == true
						return b.name < a.name
					end
				end
			)
			return t
		end
		
	},
	
	{
		name = "ping",
		func = function()
			local t = {}
			for player in players.iterate do
				if player and player.valid
					table.insert(t, player)
				end
			end
			table.sort(
				t,
				function(a,b)
					if LC.localdata.AltScores.reverse == false
						return b.ping > a.ping
					elseif LC.localdata.AltScores.reverse == true
						return b.ping < a.ping
					end
				end
			)
			return t
		end,
		
	},
	
	{
		name = "node",
		func = function()
			local t = {}
			for player in players.iterate do
				if player and player.valid
					table.insert(t, player)
				end
			end
			table.sort(
				t,
				function(a,b)
					if LC.localdata.AltScores.reverse == false
						return #b > #a
					elseif LC.localdata.AltScores.reverse == true
						return #b < #a
					end
				end
			)
			return t
		end
		
	}
}

LC.GIT_ArgTypes = {
	["group"] = {
		offset = 8,
		
		setvalue = function(player)
			if not player or not player.valid then return end
			if not player.group then
				for i in ipairs(LC.serverdata.groups.num) do
					if LC.serverdata.groups.sets["unregistered"] == LC.serverdata.groups.num[i]
						return i
					end
				end
			else
				for i in ipairs(LC.serverdata.groups.num) do
					if player.group == LC.serverdata.groups.num[i]
						return i
					end
				end
			end
		end,
		
		output = function(hud_table, args_table)
			if not hud_table or not args_table then return end
			
			local v, player, camera = hud_table.v, hud_table.player, hud_table.camera
			local x, y, value, selected = args_table.x, args_table.y, args_table.value, args_table.selected
			
			local name = LC.serverdata.groups.num[value]
			local group = LC.serverdata.groups.list[name]
			
			local color = group.color
			local displayname = group.displayname
			
			local text = color..displayname
			v.drawFill(x+2, y+4, 96-4, 6, 254)
			if selected == false
				v.drawString(x+2, y+5, text, V_ALLOWLOWERCASE, "small")
			elseif selected == true
				if (leveltime % 16) >= 8
					v.drawString(x+3, y+5, " \x82"..string.char(28).."\x80"..text.."\x82"..string.char(29), V_ALLOWLOWERCASE, "small")
				else
					v.drawString(x+3, y+5, "\x82"..string.char(28).."\x80 "..text.." \x82"..string.char(29), V_ALLOWLOWERCASE, "small")
				end
			end
		end,
		
		input = function(player, key, value)
			if not player or not player.valid then return end
			
			
			local new_value = value
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT then
				while true do
					if new_value >= #LC.serverdata.groups.num then
						new_value = 1
					else
						new_value = $ + 1
					end
					
					local name = LC.serverdata.groups.num[value]
					local group = LC.serverdata.groups.list[name]
					if (group.priority < LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer) 
					or (server == consoleplayer) then
						break
					end
					if new_value == value then break end
				end
			end
			
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT then
				while true do
					if new_value <= 1 then
						new_value = #LC.serverdata.groups.num
					else
						new_value = $ - 1
					end
					
					local name = LC.serverdata.groups.num[value]
					local group = LC.serverdata.groups.list[name]
					if (group.priority < LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer) 
					or (server == consoleplayer) then
						break
					end
					if new_value == value then break end
				end
			end
			
			return new_value
		end,
		
		checkvalid = function(player, value)
			local name = LC.serverdata.groups.num[value]
			local group = LC.serverdata.groups.list[name]
					
			if not player or not player.valid then
				return "That player doesn't exist!"
			end
			
			if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer and server != consoleplayer then
				return "Player's group priority should be lower!"
			end
			
			if LC.serverdata.commands["group"].onlyhighpriority == true
				if (group.priority < LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer and server != consoleplayer) then
					return "Group priority should be lower!"
				end
			end
			
			//return "OK!"
		end
	},
	
	["skin"] = {
		offset = 8,
		
		setvalue = function(player)
			if not player or not player.valid then return end
			
			return player.skin
		end,
		
		output = function(hud_table, args_table)
			if not hud_table or not args_table then return end
			
			local v, player, camera = hud_table.v, hud_table.player, hud_table.camera
			local x, y, value, selected = args_table.x, args_table.y, args_table.value, args_table.selected
			
			local text = skins[value].name
			v.drawFill(x+2, y+4, 96-4, 6, 254)
			if selected == false
				v.drawString(x+2, y+5, text, V_ALLOWLOWERCASE, "small")
			elseif selected == true
				if (leveltime % 16) >= 8
					v.drawString(x+3, y+5, " \x82"..string.char(28).."\x80"..text.."\x82"..string.char(29), V_ALLOWLOWERCASE, "small")
				else
					v.drawString(x+3, y+5, "\x82"..string.char(28).."\x80 "..text.." \x82"..string.char(29), V_ALLOWLOWERCASE, "small")
				end
			end
		end,
		
		input = function(player, key, value)
			if not player or not player.valid then return end
			
			local new_value = value
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT then
				while true do
					if new_value <= 0 then
						new_value = #skins-1
					else
						new_value = $ - 1
					end
					
					local IsBanned = false
					for i in ipairs(LC.serverdata.banchars) do
						if skins[new_value].name:lower() == LC.serverdata.banchars[i]:lower() then
							IsBanned = true
							break
						end
					end
					
					if IsBanned == false then break end
					
					if new_value == value then break end
				end
			end
			
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT then
				while true do
					if new_value >= #skins-1 then
						new_value = 0
					else
						new_value = $ + 1
					end
					
					local IsBanned = false
					for i in ipairs(LC.serverdata.banchars) do
						if skins[new_value].name:lower() == LC.serverdata.banchars[i]:lower() then
							IsBanned = true
							break
						end
					end
					
					if IsBanned == false then break end
					
					if new_value == value then break end
				end
			end
			
			return new_value
		end,
		
		checkvalid = function(player, value)
			if not player or not player.valid then
				return "That player doesn't exist!"
			end
			
			for i in ipairs(LC.serverdata.banchars) do
				if skins[value].name == LC.serverdata.banchars[i] then
					return "This skin is banned!"
				end
			end
			
			if LC.serverdata.commands["playerskin"].onlyhighpriority == true
				if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer and server != consoleplayer then
					return "Player's group priority should be lower!"
				end
			end
			
			//return "OK!"
		end
	},
	
	["color"] = {
		offset = 8,
		
		setvalue = function(player)
			if not player or not player.valid then return end
			
			return player.skincolor
		end,
		
		output = function(hud_table, args_table)
			if not hud_table or not args_table then return end
			
			local v, player, camera = hud_table.v, hud_table.player, hud_table.camera
			local x, y, value, selected = args_table.x, args_table.y, args_table.value, args_table.selected
			
			local name = skincolors[value].name
			local chatcolor = 0
			for cm in ipairs(LC.colormaps) do
				if LC.colormaps[cm].value == tonumber(skincolors[value].chatcolor)
					chatcolor = LC.colormaps[cm].hex
				end
			end
			
			local text = chatcolor..name
			v.drawFill(x+2, y+4, 96-4, 6, 254)
			if selected == false
				v.drawString(x+2, y+5, text, V_ALLOWLOWERCASE, "small")
			elseif selected == true
				if (leveltime % 16) >= 8
					v.drawString(x+3, y+5, " \x82"..string.char(28).."\x80"..text.."\x82"..string.char(29), V_ALLOWLOWERCASE, "small")
				else
					v.drawString(x+3, y+5, "\x82"..string.char(28).."\x80 "..text.." \x82"..string.char(29), V_ALLOWLOWERCASE, "small")
				end
			end
		end,
		
		input = function(player, key, value)
			if not player or not player.valid then return end
			
			local new_value = value
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT then
				while true do
					if new_value <= 1 then
						new_value = #skincolors-1
					else
						new_value = $ - 1
					end
					
					if skincolors[new_value].accessible == true then
						break
					end
					
					if new_value == value then break end
				end
			end
			
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT then
				while true do
					if new_value >= #skincolors-1 then
						new_value = 1
					else
						new_value = $ + 1
					end
					
					if skincolors[new_value].accessible == true then
						break
					end
					
					if new_value == value then break end
				end
			end
			
			return new_value
		end,
		
		checkvalid = function(player, value)
			if not player or not player.valid then
				return "That player doesn't exist!"
			end
			
			if skincolors[value].accessible == false then
				return "This skin is unavailable!"
			end
			
			if LC.serverdata.commands["playercolor"].onlyhighpriority == true
				if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer and server != consoleplayer then
					return "Player's group priority should be lower!"
				end
			end
			
			//return "OK!"
		end
	},
		
	["data"] = {
		offset = 8,
		
		setvalue = function()
			local t = {
				day = "DD",
				month = "MM",
				year = "YY",
				hour = "HH",
				min = "MM",
				sub = {1,1},
				setted = false
			}
			
			return t
		end,
		
		output = function(hud_table, args_table)
			if not hud_table or not args_table then return end
			
			local v, player, camera = hud_table.v, hud_table.player, hud_table.camera
			local x, y, value, selected = args_table.x, args_table.y, args_table.value, args_table.selected
			
			local str = ""
			
			local dd = {"day", "month", "year", "hour", "min"}
			
			for _, v in ipairs(dd) do
				if dd[_] == "month" or dd[_] == "year" then
					str = str.."."
				elseif dd[_] == "hour" then
					str = str.."-"
				elseif dd[_] == "min" then
					str = str..":"
				end
				for i = 1, #value[ dd[_] ] do
					if value.sub[1] == _ and value.sub[2] == i and selected == true then
						str = str.."\x82"..value[ dd[_] ]:sub(i, i).."\x80"
					else
						str = str..value[ dd[_] ]:sub(i, i)
					end
				end
			end
			v.drawFill(x+2, y+4, 96-4, 6, 254)
			v.drawString(x+2, y+5, str, V_ALLOWLOWERCASE, "small")
		end,
		
		input = function(player, key, value)
			if not player or not player.valid then return end
			
			local dd = {"day", "month", "year", "hour", "min"}
			local num = tonumber(key.name)
			local s1, s2 = value.sub[1], value.sub[2]
			
			if key.name == "backspace" then
				return {
					day = "DD",
					month = "MM",
					year = "YY",
					hour = "HH",
					min = "MM",
					sub = {1,1},
					setted = false
				}
			end
			
			if num ~= nil then
				value.setted = true
				local sb = value[ dd[s1] ]
				if s2 == 1 then
					sb = key.name..sb:sub(2,2)
					value.sub[2] = 2
					value[ dd[s1] ] = sb
				elseif s2 == 2 then
					sb = sb:sub(1,1)..key.name
					if dd[s1] == "day" then
						if tonumber(sb) > 31 then sb = "31"
						elseif tonumber(sb) < 1 then sb = "01" end
					elseif dd[s1] == "month" then
						if tonumber(sb) > 12 then sb = "12"
						elseif tonumber(sb) < 1 then sb = "01" end
					elseif dd[s1] == "year" then
						if tonumber(sb) > 38 then sb = "38"
						elseif tonumber(sb) < tonumber( os.date("%y") ) then sb = os.date("%y") end
					elseif dd[s1] == "hour" then
						if tonumber(sb) > 23 then sb = "23"
						elseif tonumber(sb) < 0 then sb = "01" end
					elseif dd[s1] == "min" then
						if tonumber(sb) > 59 then sb = "59"
						elseif tonumber(sb) < 0 then sb = "01" end
					end
					value[ dd[s1] ] = sb
					//if s1 ~= 5 then value.sub[1] = $ + 1 else value.sub[1] = 1 end
					value.sub[1] = (s1 ~= 5) and ($ + 1) or 1
					value.sub[2] = 1
				end
				if value.sub[1] == 1 and value.sub[2] == 1 then
					local _time = {sec = 0}
					for _, v in ipairs(dd) do
						if v == "year" then
							_time[ dd[_] ] = tonumber("20"..value[ dd[_] ])
						else
							_time[ dd[_] ] = tonumber(value[ dd[_] ])
						end
					end
					local int_time = os.time(_time)
					local set_time = nil
					if int_time == nil
						set_time = 2147470000
					elseif os.time(_time) < os.time(os.date("*t")) then
						set_time = os.time(os.date("*t")) + 86400
					end
					if set_time then
						for k, v in pairs(os.date("*t", set_time)) do
							if value[k] then
								if k == "year" then
									value[k] = tostring(v):sub(3)
								else
									local sk = tostring(v)
									if sk:len() == 1 then sk = "0"..sk end
									value[k] = sk
								end
							end
						end
					end
				end
			end
			return value
		end,
		
		checkvalid = function(player, value)
			if not player or not player.valid then
				return "That player doesn't exist!"
			end
			
			local dd = {"day", "month", "year", "hour", "min"}
			local _time = {sec = 0}
			for _, v in ipairs(dd) do
				if not tonumber(value[ dd[_] ]) then _time[ dd[_] ] = "0" continue end
				if v == "year" then
					_time[ dd[_] ] = tonumber("20"..value[ dd[_] ])
				else
					_time[ dd[_] ] = tonumber(value[ dd[_] ])
				end
			end
			local int_time = os.time(_time)
			if int_time == nil and value.setted == true then
				return "Invalid date!"
			end
			if LC.serverdata.commands["ban"].onlyhighpriority == true
				if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer and server != consoleplayer then
					return "Player's group priority should be lower!"
				end
			end
			
			//return "OK!"
		end
	}
}

LC.GIT_Actions = { -- Table of actions on the selected player in the Information Board

	{
		name = "LC_ALTGI_SENDMSG", -- Name action
		conditions = function(player) -- The condition under which an action must work
			local r = true
			if consoleplayer.cantspeak then return false end
			return r
		end,
		args = { -- Arguments to Action
			{type = "text", header = "Message", min = 5, max = 220, colored = true, optional = false}
		},
		func_comfirm = function(player, ...) -- When an action is taken, this function is triggered
			local args = {...}
			local text = "\""..args[1].."\""
			for i = 1, #LC.macrolist do
				local m = LC.macrolist[i]
				text = text:gsub(m.color, m.text[1])
			end
			COM_BufInsertText(consoleplayer, "sayto "..#player.." "..text)
		end,
		confirm = "SEND!", -- Custom name for the Confirm button
		popup_msg = "SENDED!" -- Pop-up text if the action is completed
	},
	
	{
		name = "LC_ALTGI_SPECTATE",
		conditions = function(player)
			local r = true
			if displayplayer == player then return false end
			return r
		end,
		func_comfirm = function(player)
			displayplayer = player
		end,
		confirm = "SPECTATE!",
		popup_msg = "SPECTATING!"
	},
	
	{
		name = "LC_ALTGI_MUTE",
		conditions = function(player)
			local r = true
			if player == consoleplayer then return false end
			if consoleplayer.LC_ignorelist
				if player.stuffname and consoleplayer.LC_ignorelist.accounts
					for i = 1, #consoleplayer.LC_ignorelist.accounts
						if consoleplayer.LC_ignorelist.accounts[i] == player.stuffname:lower()
							return false
						end
					end
				elseif not player.stuffname and consoleplayer.LC_ignorelist.players
					for i = 1, #consoleplayer.LC_ignorelist.players
						if consoleplayer.LC_ignorelist.players[i] == player
							return false
						end
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_ignore "..#player)
		end,
		confirm = "MUTE!",
		popup_msg = "MUTED!"
	},
	
	{
		name = "LC_ALTGI_UNMUTE",
		conditions = function(player)
			local r = false
			if player == consoleplayer then return false end
			if consoleplayer.LC_ignorelist
				if player.stuffname and consoleplayer.LC_ignorelist.accounts
					for i = 1, #consoleplayer.LC_ignorelist.accounts
						if consoleplayer.LC_ignorelist.accounts[i] == player.stuffname:lower()
							return true
						end
					end
				elseif not player.stuffname and consoleplayer.LC_ignorelist.players
					for i = 1, #consoleplayer.LC_ignorelist.players
						if consoleplayer.LC_ignorelist.players[i] == player
							return true
						end
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_ignore "..#player)
		end,
		confirm = "UNMUTE!",
		popup_msg = "UNMUTED!"
	},
	
	{
		name = "LC_ALTGI_VOTESILENCE",
		conditions = function(player)
			local r = false
			if server == player then return false end
			if consoleplayer == server then r = true end
			if LC.vote_types["silence"] and LC.serverdata.vote_cvars["silence"]["enabled"].value == 1 then
				r = LC.vote_types["silence"].func_start(consoleplayer, #player, 30)
			else
				return false
			end
			return r
		end,
		args = {
			{type = "count", header = "Seconds", min = 10, optional = false},
			{type = "text", header = "Reason", max = 32, colored = true, optional = true}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local seconds = args[1]
			local reason = args[2]
			if reason == "" or not reason
				COM_BufInsertText(consoleplayer, "LC_voting silence "..#player.." "..seconds)
			elseif reason != ""
				COM_BufInsertText(consoleplayer, "LC_voting silence "..#player.." "..seconds.." \""..reason.."\"")
			end
		end,
		confirm = "VOTE!",
		popup_msg = "VOTE IS STARTING!"
	},
	
	{
		name = "LC_ALTGI_VOTEKICK",
		conditions = function(player)
			local r = false
			if server == player then return false end
			--if LC.consvars.al_kick.value == 1 then r = true end
			if consoleplayer == server then r = true end
			if LC.vote_types["kick"] and LC.serverdata.vote_cvars["kick"]["enabled"].value == 1 then
				r = LC.vote_types["kick"].func_start(consoleplayer, #player, "")
			else
				return false
			end
			return r
		end,
		args = {
			{type = "text", header = "Reason", max = 28, colored = true, optional = true}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local reason = args[1]
			if reason == "" or not reason
				COM_BufInsertText(consoleplayer, "LC_voting kick "..#player)
			elseif reason != ""
				COM_BufInsertText(consoleplayer, "LC_voting kick "..#player.." \""..reason.."\x80\"")
			end
		end,
		confirm = "VOTE!",
		popup_msg = "VOTE IS STARTING!"
	},
	
	{
		name = "LC_ALTGI_VOTEBAN",
		conditions = function(player)
			local r = false
			if server == player then return false end
			--if LC.consvars.al_ban.value == 1 then r = true end
			if consoleplayer == server then r = true end
			if player.bot != 0 then return false end
			if LC.vote_types["ban"] and LC.serverdata.vote_cvars["ban"]["enabled"].value == 1 then
				r = LC.vote_types["ban"].func_start(consoleplayer, #player, "")
			else
				return false
			end
			return r
		end,
		args = {
			{type = "text", header = "Reason", max = 28, colored = true, optional = true},
			{type = "data", header = "Unban date", optional = true}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local reason = args[1] or ""
			local date = args[2]
			local str_date = ""
				
			if date then
				local dd = {"day", "month", "year", "hour", "min"}
				
				for _, v in ipairs(dd) do
					if dd[_] == "month" or dd[_] == "year" then
						str_date = str_date.."."
					elseif dd[_] == "hour" then
						str_date = str_date.." "
					elseif dd[_] == "min" then
						str_date = str_date..":"
					end
					for i = 1, #date[ dd[_] ] do
						str_date = str_date..date[ dd[_] ]:sub(i, i)
					end
				end
			end
			
			if str_date ~= "" then
				COM_BufInsertText(consoleplayer, "LC_voting ban "..#player.." \""..reason.."\x80\"".." \""..str_date.."\"")
			else
				COM_BufInsertText(consoleplayer, "LC_voting ban "..#player.." \""..reason.."\x80\"")
			end
		end,
		confirm = "VOTE!",
		popup_msg = "VOTE IS STARTING!"
	},
	
	{
		name = "LC_ALTGI_TPTOPLAYER",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["goto"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_goto "..#player)
		end,
		confirm = "TELEPORT!",
		popup_msg = "TELEPORTED!"
	},
	
	{
		name = "LC_ALTGI_TPTOYOURSELF",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["here"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_here "..#player)
		end,
		confirm = "TELEPORT!",
		popup_msg = "TELEPORTED!"
	},
	
	{
		name = "LC_ALTGI_KICK",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["kick"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "text", header = "Reason", max = 28, colored = true, optional = true}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local reason = args[1]
			if reason == "" or not reason
				COM_BufInsertText(consoleplayer, "LC_kick "..#player)
			elseif reason != ""
				COM_BufInsertText(consoleplayer, "LC_kick "..#player.." \""..reason.."\x80\"")
			end
		end,
		confirm = "KICK!",
		popup_msg = "KICKED IN BALLS!"
	},
	
	{
		name = "LC_ALTGI_BAN",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["ban"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "text", header = "Reason", max = 28, colored = true, optional = true},
			{type = "data", header = "Unban date", optional = true}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local reason = args[1]
			local date = args[2]
			local str_date = ""
				
			if date then
				local dd = {"day", "month", "year", "hour", "min"}
				
				for _, v in ipairs(dd) do
					if dd[_] == "month" or dd[_] == "year" then
						str_date = str_date.."."
					elseif dd[_] == "hour" then
						str_date = str_date.." "
					elseif dd[_] == "min" then
						str_date = str_date..":"
					end
					for i = 1, #date[ dd[_] ] do
						str_date = str_date..date[ dd[_] ]:sub(i, i)
					end
				end
			end
				
			
			if reason == "" or not reason
				reason = "(reason is not given)"
			end
			COM_BufInsertText(consoleplayer, "LC_ban "..#player.." \""..reason.."\x80\" \""..str_date.."\"")
		end,
		confirm = "BAN!",
		popup_msg = "CANCELED!"
	},
	
	{
		name = "LC_ALTGI_SILENCE",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["silence"]
			local r = true
			if player.cantspeak then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "count", header = "Seconds", min = 10, optional = false},
			{type = "text", header = "Reason", max = 32, colored = true, optional = true}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local seconds = args[1]
			local reason = args[2]
			if reason == "" or not reason
				COM_BufInsertText(consoleplayer, "LC_silence "..#player.." "..seconds)
			elseif reason != ""
				COM_BufInsertText(consoleplayer, "LC_silence "..#player.." "..seconds.." \""..reason.."\"")
			end
		end,
		confirm = "SILENCE!",
		popup_msg = "SHUP UP!"
	},
	
	{
		name = "LC_ALTGI_UNSILENCE",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["silence"]
			local r = true
			if not player.cantspeak then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		func_comfirm = function(player, ...)
			local args = {...}
			COM_BufInsertText(consoleplayer, "LC_silence "..#player.." 0")
		end,
		confirm = "UNSILENCE!",
		popup_msg = "TALK AGAIN!"
	},
	
	{
		name = "LC_ALTGI_KILL",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["kill"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_kill "..#player)
		end,
		confirm = "KILL!",
		popup_msg = "KYS!"
	},
	
	{
		name = "LC_ALTGI_FLIP",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["flip"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_flip "..#player)
		end,
		confirm = "FLIP!",
		popup_msg = "FLIPPED!"
	},
	
	{
		name = "LC_ALTGI_CONTROL",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["pilotplayer"]
			local r = true
			if player.LC_pilot then return false end
			if player == consoleplayer then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_pilotplayer "..#player)
		end,
		confirm = "CONTROL!",
		popup_msg = "LOST CONTROL!"
	},
	
	{
		name = "LC_ALTGI_STOPCONTROL",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["pilotplayer"]
			local r = true
			if not player.LC_pilot then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		func_comfirm = function(player)
			COM_BufInsertText(consoleplayer, "LC_pilotplayer "..#player)
		end,
		confirm = "BE YOURSELF!",
		popup_msg = "GET CONTROL!"
	},
	
	{
		name = "LC_ALTGI_CHANGESCALE",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["scale"]
			local r = true
			if player.cantspeak then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "float", header = "scale", min = 0, optional = false}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local scale = args[1]
			COM_BufInsertText(consoleplayer, "LC_scale "..#player.." "..scale)
		end,
		confirm = "Scale!",
		popup_msg = "Scaled!"
	},
	
	{
		name = "LC_ALTGI_CHANGESCORE",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["playerscore"]
			local r = true
			if player.cantspeak then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "count", header = "Score", min = 0, max = 99999990, optional = false}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local score = args[1]
			COM_BufInsertText(consoleplayer, "LC_setplayerscore "..#player.." "..score)
		end,
		confirm = "Change!",
		popup_msg = "Changed!"
	},
	
	{
		name = "LC_ALTGI_CHANGERINGS",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["playerrings"]
			local r = true
			if player.cantspeak then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "count", header = "Score", min = 0, max = 9999, optional = false}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local rings = args[1]
			COM_BufInsertText(consoleplayer, "LC_setplayerrings "..#player.." "..rings)
		end,
		confirm = "Change!",
		popup_msg = "Changed!"
	},
	
	{
		name = "LC_ALTGI_CHANGELIVES",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["playerlives"]
			local r = true
			if player.cantspeak then return false end
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "count", header = "Lives", min = -128, max = 127, optional = false}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local rings = args[1]
			COM_BufInsertText(consoleplayer, "LC_setplayerlives "..#player.." "..rings)
		end,
		confirm = "Change!",
		popup_msg = "Changed!"
	},
	
	{
		name = "LC_ALTGI_CHANGEGROUP",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["group"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "group", header = "Group", optional = false}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local group = args[1]
			COM_BufInsertText(consoleplayer, "LC_group "..#player.." "..group)
		end,
		confirm = "Change!",
		popup_msg = "Changed!"
	},
	
	{
		name = "LC_ALTGI_CHANGESKIN",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["playerskin"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "skin", header = "Skin", optional = false}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local skin = args[1]
			COM_BufInsertText(consoleplayer, "LC_setplayerskin "..#player.." "..skin)
		end,
		confirm = "Change!",
		popup_msg = "Changed!"
	},
	
	{
		name = "LC_ALTGI_CHANGECOLOR",
		conditions = function(player)
			local com_sets = LC.serverdata.commands["playercolor"]
			local r = true
			r = LC.functions.CheckPerms(consoleplayer, com_sets.perm)
			if com_sets.useonself == false
				if player == consoleplayer then return false end
			end
			if consoleplayer != server
				if com_sets.useonhost == false
					if player == server then return false end
				end
				if com_sets.onlyhighpriority == true
					if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != consoleplayer
						return false
					end
				end
			end
			return r
		end,
		args = {
			{type = "color", header = "color", optional = false}
		},
		func_comfirm = function(player, ...)
			local args = {...}
			local color = args[1]
			COM_BufInsertText(consoleplayer, "LC_setplayercolor "..#player.." "..color)
		end,
		confirm = "Change!",
		popup_msg = "Changed!"
	}

}



return true
