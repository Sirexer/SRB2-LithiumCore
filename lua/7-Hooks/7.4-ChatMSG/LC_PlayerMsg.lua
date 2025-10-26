local LC = LithiumCore
local LC = LithiumCore

local hooktable = {
	name = "LC.ChatMSG",
	type = "PlayerMsg",
	toggle = true,
	TimeMicros = 0,
	func = function(player, type, target, msg)
		local group = ""
		local admin = ""
		local pname = ""
		local pname2 = ""
		local text = msg
		if not player then return end
		if type == 0 then
			local cmdprefix = LC.client_consvars["LC_cmdprefix"].string
			local len_prefix = cmdprefix:len()
			if cmdprefix != "" and len_prefix != 0 
				if text:sub(1, len_prefix) == cmdprefix
					local end_cmd = text:len()
					if text:find(" ") then end_cmd = text:find(" ")-1 end
					local re_cmd = text:sub(2, end_cmd)
					for k, v in pairs(LC.serverdata.commands) do
						local LC_cmd = LC.serverdata.commands[k]
						if not LC_cmd.chat or LC_cmd.chat == "" then continue end
						if LC_cmd.chat == re_cmd
							local cmd_name = LC_cmd.name
							local cmd_args = ""
							if text:find(" ") then cmd_args = text:sub(text:find(" ")+1) end
							if player == consoleplayer
								chatprintf(player, "\x8F".."$\x80"..cmd_name.." "..cmd_args)
								COM_BufInsertText(consoleplayer, cmd_name.." "..cmd_args)
							end
							return true
						end
					end
				end
			end
		end
		if not player.cantspeak then player.cantspeak = 0 end
		if player.cantspeak != 0 then chatprintf(player, "You can't talk for "..player.cantspeak/TICRATE.." seconds.") return true end
		if not player.lastmsg then player.lastmsg = "" end
		if LC.consvars.repeatmsg.value == 0
			if player.lastmsg == msg and not IsPlayerAdmin(player) then chatprintf(player, LC.shrases.msgrepeating) return true end
		end
		if player.LC_afk then player.LC_afk.time = 0 end
		if LC.consvars.banwordfilter.string != "Off"
			local msgcensor, ban, list = LC.functions.ChatFilter(msg, "ban")
			if ban == true
				if LC.consvars.banwordfilter.string == "Block"
					local banstr = ""
					for i = 1, #list do
						if i != #list
							banstr = banstr.."\x85"..list[i].."\x80, "
						elseif i == #list
							banstr = banstr.."\x85"..list[i].."\x80."
						end
					end
					chatprintf(player, "[\x88LC\x80]<\x82~\x80"..LC.consvars["LC_dedicatedname"].string.."\x80>\x82 ".."Your message contains banned words on the server\x80: "..banstr)
					return true
				elseif LC.consvars.banwordfilter.string == "Censor"
					text = msgcensor
				end
			end
		end
		if LC.client_consvars.censorswear.string != "Off"
			local msgcensor, swear = LC.functions.ChatFilter(msg, "swear")
			if swear == true and ((consoleplayer != nil and player != consoleplayer) or (consoleplayer == nil and player != server))
				if LC.client_consvars.censorswear.string == "Block"
					return true
				elseif LC.client_consvars.censorswear.string == "Censor"
					text = msgcensor
				end
			end
		end
		if player.group
			if player.LC_hidegroup != true
				group = "["..LC.serverdata.groups.list[player.group].color..LC.serverdata.groups.list[player.group].displayname.."\x80]"
			else
				local playergroup = LC.serverdata.groups.sets["player"]
				group = "["..LC.serverdata.groups.list[playergroup].color..LC.serverdata.groups.list[playergroup].displayname.."\x80]"
			end
		end
		if player.LC_hideadmin != true
			if server == player
				admin = "\x82~\x80"
			elseif IsPlayerAdmin(player)
				admin = "\x82@\x80"
			end
		end
		if player.mo
			local chatcolor = 0
			for i in ipairs(LC.colormaps) do
				if LC.colormaps[i].value == skincolors[player.skincolor].chatcolor
					chatcolor = LC.colormaps[i].hex
				end
			end
			pname = chatcolor..player.name.."\x80"
		else
			pname = "\x86"..player.name.."\x80"
		end
		if server.jointime == 0 and server == player then pname = LC.consvars["LC_dedicatedname"].string.."\x80" end
		if target and target.valid
			if target.mo
				local chatcolor = 0
				for i in ipairs(LC.colormaps) do
					if LC.colormaps[i].value == skincolors[target.skincolor].chatcolor
						chatcolor = LC.colormaps[i].hex
					end
				end
				pname2 = chatcolor..target.name.."\x80"
			else
				pname2 = "\x86"..target.name.."\x80"
			end
		end
		for mc=1, #LC.macrolist do 
			for t = 1, #LC.macrolist[mc].text do
				text = string.gsub(text, LC.macrolist[mc].text[t], LC.macrolist[mc].color)
			end
		end
		if type == 3
			if DiscordBot and DiscordBot.Data and DiscordBot.Data.msgsrb2
				local msgdiscord = "CSAY Message from "..pname..": "..text
				local formated = ""
				for i = 1, msgdiscord:len() do
					if msgdiscord:sub(i,i):byte() > 32 and msgdiscord:sub(i,i):byte() < 127 or msgdiscord:sub(i,i) == " "
						formated = formated..msgdiscord:sub(i,i)
					end
				end
				DiscordBot.Data.msgsrb2 = DiscordBot.Data.msgsrb2..formated.."\n"
			end
			LC.functions.sendcsay(pname, text, true)
			return true
		end
		if LC.consvars.unregsilence.value == 1
			local unregistered = LC.serverdata.groups.sets["unregistered"]
			if player.group == unregistered and player != server and not IsPlayerAdmin(player)
				chatprintf(player, "[\x88LC\x80]<\x82~\x80"..LC.consvars["LC_dedicatedname"].string.."\x80> \x82\Warning\x80\: You need an account to chat here!", true)
				return true
			elseif LC.consvars.waitregtosay.value != 0
				if player != server and not IsPlayerAdmin(player)
					local allminutes = 0
					if player.LC_timeplayed
						allminutes = player.LC_timeplayed.minutes + (player.LC_timeplayed.hours*60)
					end
					if allminutes < LC.consvars.waitregtosay.value
						chatprintf(player, "[\x88LC\x80]<\x82~\x80"..LC.consvars["LC_dedicatedname"].string.."\x80> \x82\Warning\x80\: After registration you need to wait "..LC.consvars.waitregtosay.value-allminutes.." minutes to chat here.", true)
						return true
					end
				end
			end
		end
		if LC.consvars.mutechat.value == 1
			chatprintf(player, "[\x88LC\x80]<\x82~\x80"..LC.consvars["LC_dedicatedname"].string.."\x80> \x82\Warning\x80\: Chat is disabled on this server!", true)
			return true
		end
		if consoleplayer and consoleplayer != player
			if LC.client_consvars["seechat"].value == 0
				return true
			end
		end
		if type != 2
			if type == 0
				if isdedicatedserver
					chatprintf(server, group.."<"..admin..pname.."> "..text, true)
				end
			end
			for p in players.iterate do
				local ignore = false
				if p.LC_ignorelist
					if p.LC_ignorelist.accounts and p.LC_ignorelist.accounts[1] and player.stuffname
						for i = 1, #p.LC_ignorelist.accounts do
							if string.lower(p.LC_ignorelist.accounts[i]) == string.lower(player.stuffname)
								ignore = true
								break
							end
						end
					end
					if p.LC_ignorelist.players and  p.LC_ignorelist.players[1]
						for i = 1, #p.LC_ignorelist.players do
							if p.LC_ignorelist.players[i] == player
								ignore = true
								break
							end
						end
					end
				end
				if ignore == false
					if type == 0 //Public message
						chatprintf(p, group.."<"..admin..pname.."> "..text, true)
					elseif type == 1 //Team message
						local team = ""
						if player.ctfteam == 0 //Spectator
							team = "[".."\x86".."SPECTATOR".."\x80".."]"
						elseif player.ctfteam == 1 //Red team
							team = "[".."\x85".."RED".."\x80".."]"
						elseif player.ctfteam == 2 //Blue team
							team = "[".."\x84".."BLUE".."\x80".."]"
						end
						if player.ctfteam == p.ctfteam
							chatprintf(p, team..group.."<"..admin..pname.."> "..text, true)
						end
					end
				end
			end
			if type == 0 and DiscordBot and DiscordBot.Data and DiscordBot.Data.msgsrb2
				local msgdiscord = group.."<"..admin..pname.."> "..text.."\n"
				local formated = ""
				for i = 1, msgdiscord:len() do
					if msgdiscord:sub(i,i):byte() > 32 and msgdiscord:sub(i,i):byte() < 127 or msgdiscord:sub(i,i) == " "
						formated = formated..msgdiscord:sub(i,i)
					end
				end
				DiscordBot.Data.msgsrb2 = DiscordBot.Data.msgsrb2..formated.."\n"
			end
			player.lastmsg = msg
		elseif type ==  2 //DM message
			local ignore = false
			local text1 = "[".."\x82".."FROM".."\x80".."]"
			local text2 = "[".."\x82".."TO".."\x80".."]"
			if target.LC_ignorelist
				if target.LC_ignorelist.accounts and target.LC_ignorelist.accounts[1]
					for i = 1, #target.LC_ignorelist.accounts do
						if string.lower(target.LC_ignorelist.accounts[i]) == string.lower(player.stuffname)
							ignore = true
							break
						end
					end
				end
				if target.LC_ignorelist.players and  target.LC_ignorelist.players[1]
					for i = 1, #target.LC_ignorelist.players do
						if target.LC_ignorelist.players[i] == player
							ignore = true
							break
						end
					end
				end
			end
			if ignore == false
				chatprintf(target, text1.."<"..admin..pname.."> "..text, true)
			end
			chatprintf(player, text2.."<"..admin..pname2.."> "..text, true)
		end
		return true
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
