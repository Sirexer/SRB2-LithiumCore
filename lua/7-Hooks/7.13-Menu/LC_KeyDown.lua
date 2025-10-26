local LC = LithiumCore

local hooktable = {
	name = "LC.Menu",
	type = "KeyDown",
	toggle = true,
	priority = 800,
	TimeMicros = 0,
	func = function(key)
		if LC.menu.player_state
			local anim = LC.menu.animation
			if anim.closing == false
				local LC_menu = LC.menu.player_state
				if key.name == "caps lock"
					if LC_menu.capslock == true
						LC_menu.capslock = false
					else
						LC_menu.capslock = true
					end
				elseif key.name == "tab"
					if LC_menu.showpass == true
						LC_menu.showpass = false
					else
						LC_menu.showpass = true
					end
				end
				
				if LC_menu.category == "main"
					LC.menu.lastkeys = LC.menu.lastkeys..key.name
					if LC.menu.lastkeys:len() > 16 then LC.menu.lastkeys = LC.menu.lastkeys:sub(2) end
				end
				
				if LC_menu.category == "account" and LC_menu.subcategory == "login" and LC_menu.nav == 0
				or LC_menu.category == "account" and LC_menu.subcategory == "register" and LC_menu.nav == 0
					LC_menu.user = LC.functions.InputText(
						"username",
						LC_menu.user,
						key,
						LC_menu.capslock,
						LC_menu.shift,
						21
					)
					
				elseif LC_menu.category == "account" and LC_menu.subcategory == "login" and LC_menu.nav == 1
				or LC_menu.category == "account" and LC_menu.subcategory == "register" and LC_menu.nav == 1
					LC_menu.pass = LC.functions.InputText(
						"text",
						LC_menu.pass,
						key,
						LC_menu.capslock,
						LC_menu.shift,
						32
					)
				end
				
				if LC_menu.category == "account" and LC_menu.subcategory != nil and consoleplayer.stuffname
					for m = 1, #LC.menu.subcat.account do
						if LC.menu.subcat.account[m].name == LC_menu.subcategory
							local r = LC.menu.subcat.account[m].funchook(key)
							if r == true then return r, true end
						end
					end
				elseif LC_menu.category == "options" and LC_menu.subcategory != nil
					for m = 1, #LC.menu.subcat.player do
						if LC.menu.subcat.player[m].name == LC_menu.subcategory
							local r = LC.menu.subcat.player[m].funchook(key)
							if r == true then return r, true end
						end
					end
				elseif LC_menu.category == "panel" and LC_menu.subcategory != nil
					for m = 1, #LC.menu.subcat.admin do
						if LC.menu.subcat.admin[m].name == LC_menu.subcategory
							local r = LC.menu.subcat.admin[m].funchook(key)
							if r == true then return r, true end
						end
					end
				elseif LC_menu.category == "misc" and LC_menu.subcategory != nil
					for m = 1, #LC.menu.subcat.misc do
						if LC.menu.subcat.misc[m].name == LC_menu.subcategory
							local r = LC.menu.subcat.misc[m].funchook(key)
							if r == true then return r, true end
						end
					end
				end
				
				if LC_menu.subcategory == "command"
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
				if LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
					if LC_menu.block != nil then return true, true end
					S_StartSound(nil, sfx_menu1, consoleplayer)
					if LC_menu.nav != LC_menu.lastnav
						LC_menu.nav = $ + 1
					else
						LC_menu.nav = 0
					end
					if LC_menu.category == "main"
						LC_menu.subcategory = nil
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
					if LC_menu.block != nil then return true, true end
					S_StartSound(nil, sfx_menu1, consoleplayer)
					
					if LC_menu.nav != 0
						LC_menu.nav = $ - 1
					else
						LC_menu.nav = LC_menu.lastnav
					end
					if LC_menu.category == "main"
						LC_menu.subcategory = nil
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT or key.name == "space"
					S_StartSound(nil, sfx_menu1, consoleplayer)
					if LC_menu.category == "main"
						if LC_menu.nav == 0
							LC.functions.saveloadmenustate("save")
							LC_menu.category = "account"
							if not consoleplayer.stuffname
								LC_menu.lognotice = nil
								LC_menu.nav = 0
								LC_menu.lastnav = 1
							else
								LC_menu.lognotice = nil
								-- LC_menu.subcategory = "info"
								LC_menu.nav = 0
								LC_menu.lastnav = #LC.menu.subcat.account-1
							end
						elseif LC_menu.nav == 1
							LC.functions.saveloadmenustate("save")
							LC_menu.category = "options"
							LC_menu.subcategory = nil
							LC_menu.lognotice = nil
							LC_menu.nav = 0
							LC_menu.lastnav = #LC.menu.subcat.player-1
						elseif LC_menu.nav == 2
							if LC.serverdata.groups.list[consoleplayer.group].perms[1] or consoleplayer == server
								LC.functions.saveloadmenustate("save")
								LC_menu.subcategory = nil
								LC_menu.lognotice = nil
								LC_menu.nav = 0
								LC_menu.lastnav = #LC.menu.subcat.admin-1
								LC_menu.category = "panel"
							end
						elseif LC_menu.nav == 3
							LC_menu.lognotice = nil
							LC.functions.saveloadmenustate("save")
							LC_menu.category = "misc"
							LC_menu.nav = 0
							LC_menu.lastnav = #LC.menu.subcat.misc-1
							LC_menu.subcategory = nil
						elseif LC_menu.nav == 4
							COM_BufInsertText(player, "LC_menu")
						end
					elseif LC_menu.category == "account" and not consoleplayer.stuffname
						if not LC_menu.subcategory
							if not consoleplayer.stuffname
								if LC_menu.nav == 0
									LC.functions.saveloadmenustate("save")
									LC_menu.subcategory = "login"
									LC_menu.user = ""
									LC_menu.pass = ""
									LC_menu.showpass = false
									LC_menu.nav = 0
									LC_menu.lastnav = 2
								elseif LC_menu.nav == 1
									LC.functions.saveloadmenustate("save")
									LC_menu.subcategory = "register"
									LC_menu.user = ""
									LC_menu.pass = ""
									LC_menu.showpass = false
									LC_menu.nav = 0
									LC_menu.lastnav = 3
								end
							end
						elseif LC_menu.subcategory == "login"
							if LC_menu.nav == 0
								LC_menu.nav = 1
							elseif LC_menu.nav == 1
								LC_menu.nav = 2
							elseif LC_menu.nav == 2
								if LC_menu.user != "" and LC_menu.pass != ""
									COM_BufInsertText(player, "LC_login "..LC_menu.user.." "..LC_menu.pass)
								elseif LC_menu.user != "" and LC_menu.pass == ""
									LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOPASSWORD")
								else
									LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOUSERNAME")
								end
							end
						elseif LC_menu.subcategory == "register"
							if LC_menu.nav == 0
								LC_menu.nav = 1
							elseif LC_menu.nav == 1
								LC_menu.nav = 3
							elseif LC_menu.nav == 2
								LC_menu.pass = LC.functions.GetRandomPassword(nil, 10)
								LC_menu.showpass = true
							elseif LC_menu.nav == 3
								if LC_menu.user != "" and LC_menu.pass != "" and string.len(LC_menu.pass) >= 6
									COM_BufInsertText(player, "LC_register "..LC_menu.user.." "..LC_menu.pass)
								elseif LC_menu.user != "" and LC_menu.pass != "" and string.len(LC_menu.pass) < 6
									LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_SHORTPASS")
								elseif LC_menu.user != "" and LC_menu.pass == ""
									LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOPASSWORD")
								else
									LC_menu.lognotice = "\x82"..LC.functions.getStringLanguage("LC_ERR_NOUSERNAME")
								end
							end
						end
					elseif LC_menu.category == "account" and consoleplayer.stuffname
						if LC_menu.subcategory == nil
							local id = LC_menu.nav+1
							LC.functions.saveloadmenustate("save")
							LC_menu.category = "account"
							LC_menu.subcategory = LC.menu.subcat.account[id].name
							LC_menu.lognotice = nil
							LC_menu.nav = 0
							LC.menu.subcat.account[id].funcenter()
						end
					elseif LC_menu.category == "options"
						if LC_menu.subcategory == nil
							local id = LC_menu.nav+1
							LC.functions.saveloadmenustate("save")
							LC_menu.category = "options"
							LC_menu.subcategory = LC.menu.subcat.player[id].name
							LC_menu.lognotice = nil
							LC_menu.nav = 0
							LC.menu.subcat.player[id].funcenter()
						end
					elseif LC_menu.category == "panel"
						if LC_menu.subcategory == nil
							local id = LC_menu.nav+1
							LC.functions.saveloadmenustate("save")
							LC_menu.category = "panel"
							LC_menu.subcategory = LC.menu.subcat.admin[id].name
							LC_menu.lognotice = nil
							LC_menu.nav = 0
							LC.menu.subcat.admin[id].funcenter()
						end
					elseif LC_menu.category == "misc"
						if LC_menu.subcategory == nil
							local id = LC_menu.nav+1
							LC.functions.saveloadmenustate("save")
							LC_menu.category = "misc"
							LC_menu.subcategory = LC.menu.subcat.misc[id].name
							LC_menu.lognotice = nil
							LC_menu.nav = 0
							LC.menu.subcat.misc[id].funcenter()
						end
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_BACK
					if LC_menu.block != nil then return true, true end
					S_StartSound(nil, sfx_tink, consoleplayer)
					if LC_menu.category == "main" or LC.menu.LC_ms[1] == nil
						COM_BufInsertText(consoleplayer, "LC_menu")
					elseif LC.menu.LC_ms[1] != nil
						LC.functions.saveloadmenustate("load")
					end
				end
				return true, true
			end
		end
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
