local LC = LithiumCore

local first = 1

local t = {
	name = "LC_MENU_COMMANDS",
	description = "LC_MENU_COMMANDS_TIP",
	type = "admin",
	funchud = function(v)
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Commands", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		local LC_menu = LC.menu.player_state
		if LC_menu.command == nil
			local player = consoleplayer
			local LC_menu = LC.menu.player_state
			local real_height = (v.height() / v.dupx())
			local maxslots = real_height/10 - 4
			if LC_menu.LC_allowcommands[1]
				if LC_menu.nav+1 < first
					first = $ - 1
				elseif LC_menu.nav+1 > first+maxslots-1
					first = $ + 1
				end
			end
			-- Animate Arrow
			local arrow_y = 0
			if (leveltime % 10) > 5
				arrow_y = 2
			end
			
			-- Arrow Up
			if LC_menu.nav+1 > 0 and first != 1
				v.drawString(318, 32+arrow_y, "\x82"..string.char(26), V_SNAPTOTOP, "right")
			end
			-- Arrow Down
			if LC_menu.nav+1 != LC_menu.lastnav and #LC_menu.LC_allowcommands > maxslots and first+maxslots-1 < #LC_menu.LC_allowcommands
				v.drawString(318, 180+arrow_y, "\x82"..string.char(27), V_SNAPTOBOTTOM, "right")
			end
			local y = 0
			for i = first, first+maxslots-1 do
				if LC_menu.LC_allowcommands and LC_menu.LC_allowcommands[i] and LC_menu.LC_allowcommands[i].command
					local cmd_name = LC.functions.getStringLanguage(LC_menu.LC_allowcommands[i].command.name)
					if LC_menu.nav == LC_menu.LC_allowcommands[i].num and LC_menu.category != "main"
						LC.functions.drawString(v, 136, 30+y, "\x82"..cmd_name, V_SNAPTOTOP, "left", 178)
						if LC_menu.LC_allowcommands[i].command.description
							LC_menu.tip = LC.functions.getStringLanguage(LC_menu.LC_allowcommands[i].command.description)
						else
							LC_menu.tip = ""
						end
					else
						LC.functions.drawString(v, 136, 30+y, cmd_name, V_SNAPTOTOP, "left", 178)
					end
					y = $ + 10
				end
			end
		else
			local command = LC_menu.LC_allowcommands[LC_menu.command].command
			v.drawFill(136, 28, 181, 2, 31|V_SNAPTOTOP)
			v.drawFill(136, 28, 180, 1, 74|V_SNAPTOTOP)
			local cmd_name = LC.functions.getStringLanguage(command.name)
			LC.functions.drawString(v, 136, 20, "\x82"..cmd_name, V_SNAPTOTOP, "left")
			local x = 0
			local nav = 0
			local text = false
			local pass = false
			if command.args[1]
				for arg = 1, #command.args do
					local var = command.args[arg]
					if var.type == "text" or var.type == "username"
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
						end
						v.drawFill(136, 39+x, 180, 10, 253|V_SNAPTOTOP)
						if LC_menu.nav == nav and (leveltime % 4) / 2
							if string.len(LC_menu.com_vars[nav+1].arg) <= 32
								v.drawString(138, 40+x, LC_menu.com_vars[nav+1].arg.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..string.sub(LC_menu.com_vars[nav+1].arg, string.len(LC_menu.com_vars[nav+1].arg)-32, string.len(LC_menu.com_vars[nav+1].arg)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end
						else
							if string.len(LC_menu.com_vars[nav+1].arg) <= 32
								v.drawString(138, 40+x, LC_menu.com_vars[nav+1].arg, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..string.sub(LC_menu.com_vars[nav+1].arg, string.len(LC_menu.com_vars[nav+1].arg)-32, string.len(LC_menu.com_vars[nav+1].arg)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end	
						end
						text = true
						x = $ + 20
					elseif var.type == "count"
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
						end
						v.drawFill(136, 39+x, 180, 10, 253|V_SNAPTOTOP)
						if LC_menu.nav == nav and (leveltime % 4) / 2
							if string.len(tostring(LC_menu.com_vars[nav+1].arg)) <= 32
								v.drawString(138, 40+x, tostring(LC_menu.com_vars[nav+1].arg).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..tostring(string.sub(LC_menu.com_vars[nav+1].arg), string.len(tostring(LC_menu.com_vars[nav+1].arg))-32, string.len(tostring(LC_menu.com_vars[nav+1].arg))).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end
						else
							if string.len(tostring(LC_menu.com_vars[nav+1].arg)) <= 32
								v.drawString(138, 40+x, tostring(LC_menu.com_vars[nav+1].arg), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..string.sub(tostring(LC_menu.com_vars[nav+1].arg), string.len(tostring(LC_menu.com_vars[nav+1].arg))-32, string.len(tostring(LC_menu.com_vars[nav+1].arg))), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end	
						end
						x = $ + 20
					elseif var.type == "float"
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
						end
						v.drawFill(136, 39+x, 180, 10, 253|V_SNAPTOTOP)
						if LC_menu.nav == nav and (leveltime % 4) / 2
							if string.len(LC_menu.com_vars[nav+1].arg) <= 32
								v.drawString(138, 40+x, LC_menu.com_vars[nav+1].arg.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..string.sub(LC_menu.com_vars[nav+1].arg, string.len(LC_menu.com_vars[nav+1].arg)-32, string.len(LC_menu.com_vars[nav+1].arg)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end
						else
							if string.len(LC_menu.com_vars[nav+1].arg) <= 32
								v.drawString(138, 40+x, LC_menu.com_vars[nav+1].arg, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..string.sub(LC_menu.com_vars[nav+1].arg, string.len(LC_menu.com_vars[nav+1].arg)-32, string.len(LC_menu.com_vars[nav+1].arg)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end	
						end
						x = $ + 20
					elseif var.type == "password"
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
						end
						v.drawFill(136, 39+x, 180, 10, 253|V_SNAPTOTOP)
						local viewpass
						if LC_menu.showpass == true
							viewpass = LC_menu.com_vars[nav+1].arg
						else
							viewpass = string.gsub(LC_menu.com_vars[nav+1].arg, ".", "*")
						end
						if LC_menu.nav == nav and (leveltime % 4) / 2
							if string.len(viewpass) <= 32
								v.drawString(138, 40+x, viewpass.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end
						else
							if string.len(viewpass) <= 32
								v.drawString(138, 40+x, viewpass, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							else
								v.drawString(138, 40+x, "..."..string.sub(viewpass, string.len(viewpass)-32, string.len(viewpass)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
							end	
						end
						pass = true
						text = true
						x = $ + 20
					elseif var.type == "player"
						local pname
						if LC_menu.com_vars[nav+1].arg and LC_menu.com_vars[nav+1].arg.valid
							pname = LC_menu.com_vars[nav+1].arg.name
						else
							pname = "None"
						end
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring("\x82".."< "..pname.." >")), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring(pname)), V_SNAPTOTOP, "left")
						end
						x = $ + 20
					elseif var.type == "skin"
						local sname
						if LC_menu.com_vars[nav+1].arg != nil
							sname = skins[LC_menu.com_vars[nav+1].arg].name
						else
							sname = "None"
						end
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring("\x82".."< "..sname.." >")), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring(sname)), V_SNAPTOTOP, "left")
						end
						x = $ + 20
					elseif var.type == "skincolor"
						local cname
						if LC_menu.com_vars[nav+1].arg != nil
							cname = skincolors[LC_menu.com_vars[nav+1].arg].name
						else
							cname = "None"
						end
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring("\x82".."< "..cname.." >")), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring(cname)), V_SNAPTOTOP, "left")
						end
						x = $ + 20
					elseif string.find(var.type, "custom_value")
						local cv = tonumber(string.sub(var.type, 13))
						local name = LC_menu.com_vars[nav+1].arg
						if command.custom_values[cv][LC_menu.com_vars[nav+1].arg].name
							name = command.custom_values[cv][LC_menu.com_vars[nav+1].arg].name
						end
						if LC_menu.nav == nav
							v.drawString(136, 30+x, (tostring("\x82"..var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring("\x82".."<"..name..">")), V_SNAPTOTOP, "left")
						else
							v.drawString(136, 30+x, (tostring(var.header)), V_SNAPTOTOP, "left")
							v.drawString(136, 40+x, (tostring(name)), V_SNAPTOTOP, "left")
						end
						x = $ + 20
					end
					nav = $ + 1
				end
			end
			if pass == true
				if LC_menu.showpass == true
					v.drawString(136, 30+x, (tostring("SHOW PASSWORD(TAB) IS ON")), V_SNAPTOTOP, "thin")
				else
					v.drawString(136, 30+x, (tostring("SHOW PASSWORD(TAB) IS OFF")), V_SNAPTOTOP, "thin")
				end
				x = $ + 8
			end
			if text == true
				if LC_menu.capslock == true
					v.drawString(136, 30+x, (tostring("CAPS LOCK IS ON")), V_SNAPTOTOP, "thin")
				else
					v.drawString(136, 30+x, (tostring("CAPS LOCK IS OFF")), V_SNAPTOTOP, "thin")
				end
				x = $ + 8
			end
			if LC_menu.lognotice
				v.drawString(136, 30+x, (tostring(LC_menu.lognotice)), V_SNAPTOTOP, "thin")
			end
			if LC_menu.nav == nav
				v.drawString(312, 40+x, (tostring("\x82"..command.confirm)), V_SNAPTOTOP, "right")
			else
				v.drawString(312, 40+x, (tostring(command.confirm)), V_SNAPTOTOP, "right")
			end
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		LC_menu.LC_allowcommands = {}
		local allcommands = false
		local commandnum = 0
		for i = 1, #LC.serverdata.groups.list[consoleplayer.group].perms do
			if LC.serverdata.groups.list[consoleplayer.group].perms[i] == "all"
				allcommands = true
				break
			end
		end
		if consoleplayer == server then allcommands = true end 
		if allcommands == true
			for i = 0, #LC.menu.commands do
				local t = {command = LC.menu.commands[i], num = commandnum}
				table.insert(LC_menu.LC_allowcommands, t)
				commandnum = $ + 1
			end
		else
			for i = 0, #LC.menu.commands do
				/*
				for p = 1, #LC.serverdata.groups.list[consoleplayer.group].perms do
					if LC.serverdata.groups.list[consoleplayer.group].perms[p] == LC.menu.commands[i].command.perm
						local t = {command = LC.menu.commands[i], num = commandnum}
						table.insert(LC_menu.LC_allowcommands, t)
						commandnum = $ + 1
						break
					end
				end
				*/
				local perm = LC.serverdata.commands[LC.menu.commands[i].command].perm
				if LC.functions.CheckPerms(consoleplayer, perm) == true
					local t = {command = LC.menu.commands[i], num = commandnum}
					table.insert(LC_menu.LC_allowcommands, t)
					commandnum = $ + 1
				end
			end
		end
		LC_menu.lognotice = nil
		LC_menu.nav = 0
		LC_menu.lastnav = commandnum-1
		//LC_menu.subcategory = "commandslist"
	end,
		
	funchook = function(key)
		local LC_menu = LC.menu.player_state
		if LC_menu.command == nil
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT or key.name == "space"
				LC_menu.lognotice = nil
				LC_menu.command = LC_menu.nav+1
				LC_menu.com_vars = {}
				local nav = 0
				for i = 1, #LC_menu.LC_allowcommands[LC_menu.command].command.args do
					local arg = LC_menu.LC_allowcommands[LC_menu.command].command.args[i]
					local com_data = LC.serverdata.commands[LC_menu.LC_allowcommands[LC_menu.command].command.command]
					if arg.type == "text"
						local t = {type = "text", nav = nav, arg = ""}
						table.insert(LC_menu.com_vars, t)
					elseif arg.type == "username"
						local t = {type = "username", nav = nav, arg = ""}
						table.insert(LC_menu.com_vars, t)
					elseif arg.type == "password"
						local t = {type = "password", nav = nav, arg = ""}
						table.insert(LC_menu.com_vars, t)
					elseif arg.type == "count"
						local t = {type = "count", nav = nav, arg = 0}
						table.insert(LC_menu.com_vars, t)
					elseif arg.type == "float"
						local t = {type = "float", nav = nav, arg = "1"}
						table.insert(LC_menu.com_vars, t)
					elseif arg.type == "player"
						local p = nil
						if arg.optional != true
							for player in players.iterate do
								local accessible = true
								if player == consoleplayer
									if com_data.useonself == false
										accessible = false
									end
								end
								if player == server and consoleplayer != server
									if com_data.useonhost == false
										accessible = false
									end
								end
								if consoleplayer != server and com_data.onlyhighpriority == true
									if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority
										accessible = false
									end
								end
								if accessible == true
									p = player
									break
								end
							end
						else
							p = nil
						end
						local t = {type = "player", nav = nav, arg = p}
						table.insert(LC_menu.com_vars, t)
					elseif arg.type == "skin"
						local s = nil
						for i = 0, #skins-1 do
							if skins[i] and skins[i].valid
								s = i
								break
							end
						end
						local t = {type = "skin", nav = nav, arg = s}
						table.insert(LC_menu.com_vars, t)
					elseif arg.type == "skincolor"
						local c = nil
						for i = 1, #skincolors-1 do
							if skincolors[i]
								if arg.accessible != nil
									if arg.accessible == 0 -- only super colors
										if skincolors[i].accessible == false
											c = i
											break
										end
									elseif arg.accessible == 1 -- only common colors
										if skincolors[i].accessible == true
											c = i
											break
										end
									elseif arg.accessible == 2 -- All colors
										c = i
										break
									end
								else
									c = i
									break
								end
							end
						end
						local t = {type = "skincolor", nav = nav, arg = c}
						table.insert(LC_menu.com_vars, t)
					elseif string.find(arg.type, "custom_value")
						local cv = tonumber(string.sub(arg.type, 13))
						local t = {type = "custom_value", nav = nav, arg = 1, custom_value = LC_menu.LC_allowcommands[LC_menu.command].command.custom_values[cv]}
						table.insert(LC_menu.com_vars, t)
					end
					nav = $ + 1
				end
				LC_menu.nav = 0
				LC_menu.lastnav = #LC_menu.LC_allowcommands[LC_menu.command].command.args
				//LC_menu.subcategory = "command"
			end
		else
			if LC.functions.GetMenuAction(key.name) == LCMA_BACK
				LC_menu.nav = LC_menu.command-1
				LC_menu.lastnav = #LC_menu.LC_allowcommands-1
				LC_menu.command = nil
				return true
			elseif LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				if LC_menu.nav == #LC_menu.com_vars
					local command = LC_menu.LC_allowcommands[LC_menu.command].command
					local com_data = LC.serverdata.commands[command.command]
					local errormsg
					local com_insert = com_data.name.." "
					for i = 1, #command.args do
						local arg = command.args[i]
						if arg 
							if arg.type == "count"
								local maxs = command.args[i].max
								local mins = command.args[i].min
								if maxs == nil or maxs > 2147483647 then maxs = 2147483647 end
								if mins == nil or mins < -2147483648 then mins = -2147483648 end
								local count = LC_menu.com_vars[i].arg
								if count > maxs
									local printerror
									if arg.header
										printerror = "\x82"..arg.header..": Number cannot be more than "..maxs
									else
										printerror = "\x82[arg"..i.."]: Number cannot be more than "..maxs
									end
									if not errormsg
										errormsg = printerror
									end
									if printerror then CONS_Printf(consoleplayer, printerror) end
								elseif count < mins
									local printerror
									if arg.header
										printerror = "\x82"..arg.header..": Number cannot be less than "..mins
									else
										printerror = "\x82[arg"..i.."]: Number cannot be less than "..mins
									end
									if not errormsg
										errormsg = printerror
									end
									if printerror then CONS_Printf(consoleplayer, printerror) end
								end
								if not errormsg
									if LC_menu.com_vars[i].arg != nil then com_insert = com_insert.."\""..LC_menu.com_vars[i].arg.."\" " end
								end
							elseif arg.type == "float"
								local maxs = command.args[i].max
								local mins = command.args[i].min
								if maxs == nil or maxs > FRACUNIT then maxs = FRACUNIT end
								if mins == nil or mins < -FRACUNIT then mins = -FRACUNIT end
								local float = LC_menu.com_vars[i].arg
								local dot
								local int
								local fcl
								if string.find(float, "%.")
									dot = string.find(float, "%.")
									int = tonumber(string.sub(float, 1, dot-1))
									fcl = (string.sub(float, dot+1))
								else
									int = tonumber(float)
								end
								if int < mins
									local printerror
									if arg.header
										printerror = "\x82"..arg.header..": Number cannot be less than "..mins
									else
										printerror = "\x82[arg"..i.."]: Number cannot be less than "..mins
									end
									if not errormsg
										errormsg = printerror
									end
									if printerror then CONS_Printf(consoleplayer, printerror) end
								end
								if int > maxs
									local printerror
									if arg.header
										printerror = "\x82"..arg.header..": Number cannot be more than "..maxs
									else
										printerror = "\x82[arg"..i.."]: Number cannot be more than "..maxs
									end
									if not errormsg
										errormsg = printerror
									end
									if printerror then CONS_Printf(consoleplayer, printerror) end
								end
								if not errormsg
									if LC_menu.com_vars[i].arg != nil then com_insert = com_insert.."\""..LC_menu.com_vars[i].arg.."\" " end
								end
							elseif arg.type == "text" or arg.type == "username" or arg.type == "password"
								local text = LC_menu.com_vars[i].arg
								if text != "" and text != nil
									local lens = string.len(text)
									local maxs = command.args[i].maxsymbols
									local mins = command.args[i].minsymbols
									if maxs and lens > maxs
										local printerror
										if arg.header
											printerror = "\x82"..arg.header..": Text must be more than "..maxs.." symbols"
										else
											printerror = "\x82[arg"..i.."]: Text must be more than "..maxs.." symbols"
										end
										if not errormsg
											errormsg = printerror
										end
										if printerror then CONS_Printf(consoleplayer, printerror) end
									end
									if mins and lens < mins
										local printerror
										if arg.header
											printerror = "\x82"..arg.header..": Text must be less than "..mins.." symbols"
										else
											printerror = "\x82[arg"..i.."]: Text must be less than "..mins.." symbols"
										end
										if not errormsg
											errormsg = printerror
										end
										if printerror then CONS_Printf(consoleplayer, printerror) end
									end
								else
									if arg.optional != true
										local printerror
										if arg.header
											printerror = "\x82"..arg.header..": Enter "..arg.type
										else
											printerror = "\x82[arg"..i.."]: Enter "..arg.type
										end
										if not errormsg
											errormsg = printerror
										end
										if printerror then CONS_Printf(consoleplayer, printerror) end
									end
								end
								if not errormsg
									if LC_menu.com_vars[i].arg != nil then com_insert = com_insert.."\""..LC_menu.com_vars[i].arg.."\" " end
								end
							elseif arg.type == "skincolor"
								if not errormsg
									if LC_menu.com_vars[i].arg != nil then com_insert = com_insert.."\""..LC_menu.com_vars[i].arg.."\" " end
								end
							elseif arg.type == "skin"
								if not errormsg
									if LC_menu.com_vars[i].arg != nil then com_insert = com_insert.."\""..LC_menu.com_vars[i].arg.."\" " end
								end
							elseif arg.type == "player"
								local printerror
								local accessible = true
								if LC_menu.com_vars[i].arg and LC_menu.com_vars[i].arg.valid
									if LC_menu.com_vars[i].arg == consoleplayer
										if com_data.useonself == false
											if arg.header
												printerror = "\x82"..arg.header..": You can't use it on yourself"
											else
												printerror = "\x82[arg"..i.."]: You can't use it on yourself"
											end
											accessible = false
										end
									end
									if LC_menu.com_vars[i].arg == server
										if com_data.useonhost == false and consoleplayer != server
											if arg.header
												printerror = "\x82"..arg.header..": You can't use it on the host"
											else
												printerror = "\x82[arg"..i.."]: You can't use it on the host"
											end
											accessible = false
										end
									end
									if consoleplayer != server and com_data.onlyhighpriority == true
										if LC.serverdata.groups.list[LC_menu.com_vars[i].arg.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority and player != player2
											if arg.header
												printerror = "\x82"..arg.header..": You can't use who has a high priority"
											else
												printerror = "\x82[arg"..i.."]: You can't use who has a high priority"
											end
											accessible = false
										end
									end
								else
									if arg.optional != true
										if arg.header
											printerror = "\x82"..arg.header..": Need a player"
										else
											printerror = "\x82[arg"..i.."]: Need a player"
										end
										accessible = false
									else
										
									end
								end
								if accessible == false
									if not errormsg
										errormsg = printerror
									end
									if printerror then CONS_Printf(consoleplayer, printerror) end
								end
								if not errormsg
									if LC_menu.com_vars[i].arg == nil
										LC_menu.com_vars[i].arg = " "
									end
									com_insert = com_insert.."\""..#LC_menu.com_vars[i].arg.."\" "
								end
							elseif string.find(arg.type, "custom_value")
								if not errormsg
									local cv = tonumber(string.sub(arg.type, 13))
									com_insert = com_insert.."\""..command.custom_values[cv][LC_menu.com_vars[i].arg].value.."\" "
								end
							end
						end
					end
					if errormsg 
						LC_menu.lognotice = errormsg
					else
						LC_menu.lognotice = "\x83"..LC.functions.getStringLanguage("LC_SUCCESS")
						COM_BufInsertText(consoleplayer, com_insert)
					end
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
				if LC_menu.com_vars[LC_menu.nav+1]
					local arg = LC_menu.LC_allowcommands[LC_menu.command].command.args[LC_menu.nav+1]
					local com_data = LC_menu.LC_allowcommands[LC_menu.command].command.command
					if arg.type == "player"
						local t_players = {}
						local selected = 1
						local count = 0
						local pnext = 1
						for player in players.iterate do
							local accessible = true
							if player and player.valid
								if player == consoleplayer
									if com_data.useonself == false
										accessible = false
									end
								end
								if player == server and consoleplayer != server
									if com_data.useonhost == false
										accessible = false
									end
								end
								if consoleplayer != server and com_data.onlyhighpriority == true
									if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority
										accessible = false
									end
								end
								if accessible == true
									count = $ + 1
									table.insert(t_players, player)
									if player == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
									continue
								end
							end
						end
						if arg.optional != true
							if count > selected
								pnext = selected + 1
							else
								pnext = 1
							end
							LC_menu.com_vars[LC_menu.nav+1].arg = t_players[pnext]
						else
							if LC_menu.com_vars[LC_menu.nav+1].arg != nil
								if count > selected
									LC_menu.com_vars[LC_menu.nav+1].arg = t_players[selected+1]
								else
									LC_menu.com_vars[LC_menu.nav+1].arg = nil
								end
							else
								LC_menu.com_vars[LC_menu.nav+1].arg = t_players[1]
							end
						end
					elseif arg.type == "skin"
						if LC_menu.com_vars[LC_menu.nav+1].arg == 0
							LC_menu.com_vars[LC_menu.nav+1].arg = #skins-1
						else
							LC_menu.com_vars[LC_menu.nav+1].arg = $ - 1
						end
					elseif arg.type == "skincolor"
						local t_colors = {}
						local selected = 1
						local count = 0
						local cnext = 1
						for i = 1, #skincolors-1 do
							if skincolors[i]
								if arg.accessible != nil
									if arg.accessible == 0 -- only super colors
										if skincolors[i].accessible == false
											count = $ + 1
											table.insert(t_colors, skincolors[i])
											if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
											continue
										end
									elseif arg.accessible == 1 -- only common colors
										if skincolors[i].accessible == true
											count = $ + 1
											table.insert(t_colors, skincolors[i])
											if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
											continue
										end
									elseif arg.accessible == 2 -- All colors
										count = $ + 1
										table.insert(t_colors, skincolors[i])
										if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
										continue
									end
								else
									count = $ + 1
									table.insert(t_colors, skincolors[i])
									if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
									continue
								end
							end
						end
						if selected > 1
							cnext = selected - 1
						else
							cnext = #t_colors
						end
						LC_menu.com_vars[LC_menu.nav+1].arg = #t_colors[cnext]
					elseif string.find(arg.type, "custom_value")
						local cv = tonumber(string.sub(arg.type, 13))
						if #LC_menu.LC_allowcommands[LC_menu.command].command.custom_values[cv] > 1
							if LC_menu.com_vars[LC_menu.nav+1].arg != 1
								LC_menu.com_vars[LC_menu.nav+1].arg = $ - 1
							else
								LC_menu.com_vars[LC_menu.nav+1].arg = #LC_menu.LC_allowcommands[LC_menu.command].command.custom_values[cv]
							end
						end
					end
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
				if LC_menu.com_vars[LC_menu.nav+1]
					local arg = LC_menu.LC_allowcommands[LC_menu.command].command.args[LC_menu.nav+1]
					local com_data = LC_menu.LC_allowcommands[LC_menu.command].command.command
					if arg.type == "player"
						local t_players = {}
						local selected = 1
						local count = 0
						local pnext = 1
						for player in players.iterate do
							local accessible = true
							if player and player.valid
								if player == consoleplayer
									if com_data.useonself == false
										accessible = false
									end
								end
								if player == server and consoleplayer != server
									if com_data.useonhost == false
										accessible = false
									end
								end
								if consoleplayer != server and com_data.onlyhighpriority == true
									if LC.serverdata.groups.list[player.group].priority >= LC.serverdata.groups.list[consoleplayer.group].priority
										accessible = false
									end
								end
								if accessible == true
									count = $ + 1
									table.insert(t_players, player)
									if player == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
									continue
								end
							end
						end
						if arg.optional != true
							if selected > 1
								pnext = selected - 1
							else
								pnext = #t_players
							end
							LC_menu.com_vars[LC_menu.nav+1].arg = t_players[pnext]
						else
							if LC_menu.com_vars[LC_menu.nav+1].arg != nil
								if selected > 1
									LC_menu.com_vars[LC_menu.nav+1].arg = t_players[selected-1]
								else
									LC_menu.com_vars[LC_menu.nav+1].arg = nil
								end
							else
								LC_menu.com_vars[LC_menu.nav+1].arg = t_players[#t_players]
							end
						end
					elseif arg.type == "skin"
						if LC_menu.com_vars[LC_menu.nav+1].arg == #skins-1
							LC_menu.com_vars[LC_menu.nav+1].arg = 0
						else
							LC_menu.com_vars[LC_menu.nav+1].arg = $ + 1
						end
					elseif arg.type == "skincolor"
						local t_colors = {}
						local selected = 1
						local count = 0
						local cnext = 1
						for i = 1, #skincolors-1 do
							if skincolors[i]
								if arg.accessible != nil
									if arg.accessible == 0 -- only super colors
										if skincolors[i].accessible == false
											count = $ + 1
											table.insert(t_colors, skincolors[i])
											if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
											continue
										end
									elseif arg.accessible == 1 -- only common colors
										if skincolors[i].accessible == true
											count = $ + 1
											table.insert(t_colors, skincolors[i])
											if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
											continue
										end
									else -- All colors
										count = $ + 1
										table.insert(t_colors, skincolors[i])
										if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
										continue
									end
								else
									count = $ + 1
									table.insert(t_colors, skincolors[i])
									if i == LC_menu.com_vars[LC_menu.nav+1].arg then selected = count end
									continue
								end
							end
						end
						if count > selected
							cnext = selected + 1
						else
							cnext = 1
						end
						if cnext > #t_colors then cnext = 1 end
						LC_menu.com_vars[LC_menu.nav+1].arg = #t_colors[cnext]
					elseif string.find(arg.type, "custom_value")
						local cv = tonumber(string.sub(arg.type, 13))
						if #LC_menu.LC_allowcommands[LC_menu.command].command.custom_values[cv] > 1
							if LC_menu.com_vars[LC_menu.nav+1].arg < #LC_menu.LC_allowcommands[LC_menu.command].command.custom_values[cv]
								LC_menu.com_vars[LC_menu.nav+1].arg = $ + 1
							else
								LC_menu.com_vars[LC_menu.nav+1].arg = 1
							end
						end
					end
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVUP or LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
				for i = 1, #LC_menu.LC_allowcommands[LC_menu.command].command.args do
					local arg = LC_menu.LC_allowcommands[LC_menu.command].command.args[i]
					local command = LC_menu.LC_allowcommands[LC_menu.command].command
					if arg
						if arg.type == "count"
							if LC_menu.com_vars[i].arg == "-" or LC_menu.com_vars[i].arg == "" then LC_menu.com_vars[i].arg = 0 end
							if LC_menu.LC_allowcommands[LC_menu.command].command.args[i].min
								if LC_menu.com_vars[i].arg < LC_menu.LC_allowcommands[LC_menu.command].command.args[i].min
									LC_menu.com_vars[i].arg = LC_menu.LC_allowcommands[LC_menu.command].command.args[i].min
								end
							end
							if LC_menu.LC_allowcommands[LC_menu.command].command.args[i].max
								if LC_menu.com_vars[i].arg > LC_menu.LC_allowcommands[LC_menu.command].command.args[i].max
									LC_menu.com_vars[i].arg = LC_menu.LC_allowcommands[LC_menu.command].command.args[i].max
								end
							end
						elseif arg.type == "float"
							local maxs = LC_menu.LC_allowcommands[LC_menu.command].command.args[i].max
							local mins = LC_menu.LC_allowcommands[LC_menu.command].command.args[i].min
							if maxs == nil or maxs > FRACUNIT then maxs = FRACUNIT end
							if mins == nil or mins < -FRACUNIT then mins = -FRACUNIT end
							if LC_menu.com_vars[i].arg == "-" or LC_menu.com_vars[i].arg == "" then LC_menu.com_vars[i].arg = "0" end
							local float = LC_menu.com_vars[i].arg
							local dot
							local int
							local fcl
							if string.find(float, "%.")
								dot = string.find(float, "%.")
								int = tonumber(string.sub(float, 1, dot-1))
								fcl = (string.sub(float, dot+1))
							else
								int = tonumber(float)
							end
							if int < mins
								LC_menu.com_vars[i].arg = mins
							end
							if int > maxs
								LC_menu.com_vars[i].arg = maxs
							end
						end
					end
				end
			else
				if LC_menu.com_vars[LC_menu.nav+1]
					local arg = LC_menu.LC_allowcommands[LC_menu.command].command.args[LC_menu.nav+1]
					local maxs
					local mins
					if arg.type == "text" or arg.type == "username" or arg.type == "password"
						maxs = LC_menu.LC_allowcommands[LC_menu.command].command.args[LC_menu.nav+1].maxsymbols
					elseif arg.type == "count" or arg.type == "float"
						maxs = LC_menu.LC_allowcommands[LC_menu.command].command.args[LC_menu.nav+1].max
						mins = LC_menu.LC_allowcommands[LC_menu.command].command.args[LC_menu.nav+1].min
					end
					LC_menu.com_vars[LC_menu.nav+1].arg = LC.functions.InputText(
						arg.type,
						LC_menu.com_vars[LC_menu.nav+1].arg,
						key,
						LC_menu.capslock,
						LC_menu.shift,
						maxs,
						mins
					)
				end
			end
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
