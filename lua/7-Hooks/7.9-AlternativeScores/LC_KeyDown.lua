local LC = LithiumCore

local hooktable = {
	name = "LC.AltScores",
	type = "KeyDown",
	toggle = true,
	priority = 900,
	TimeMicros = 0,
	func = function(key)
		if LC.localdata.AltScores.enabled == false then return end
		local HKT = LC.localdata.pressed_keys
		local key_aGI = LC.functions.GetControlByName("Alt GameInfo")
		for _, v in ipairs(HKT) do
			if v.name == key_aGI
				if v.tics > 0
					LC.localdata.AltScores.holded = true
					if key.num == input.gameControlToKeyNum(GC_SCORES)
						return true, true
					else
						return
					end
				end
			end
		end
		
		if key.name == key_aGI then LC.localdata.AltScores.enabled = false end
		
		
		local AltScores = LC.localdata.AltScores
		if AltScores.nav.y == 0 and AltScores.nav.x == 2
			AltScores.search = LC.functions.InputText("text", AltScores.search, key, AltScores.capslock, AltScores.shift, 21)
		end
		if key.name == "lshift" or key.name == "rshift"
			AltScores.shift = true
		end
		if key.name == "caps lock"
			if AltScores.capslock == false
				AltScores.capslock = true
			elseif AltScores.capslock  == true
				AltScores.capslock = false
			end
		end
		if LC.functions.GetMenuAction(key.name) == LCMA_BACK
			if AltScores.selected
				if AltScores.action.index != 0
					AltScores.action.index = 0
					return true, true
				end
				AltScores.selected = nil
			else
				LC.localdata.AltScores.enabled = false
			end
		end
		if not AltScores.selected
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				if AltScores.nav.y == 0
					if AltScores.nav.x == 0
						if AltScores.sort == #LC.SortingPlayers
							AltScores.sort = 1
						else
							AltScores.sort = $ + 1
						end
					elseif AltScores.nav.x == 1
						if AltScores.reverse == true
							AltScores.reverse = false
						elseif AltScores.reverse == false
							AltScores.reverse = true
						end
					end
				else
					AltScores.selected = AltScores.players[AltScores.nav.y]
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
				if AltScores.nav.y == #AltScores.players
					AltScores.nav.y = 0
				else
					AltScores.nav.y = $ + 1
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
				if AltScores.nav.y == 0
					AltScores.nav.y = #AltScores.players
				else
					AltScores.nav.y = $ - 1
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
				if AltScores.nav.y == 0
					if AltScores.nav.x == 2
						AltScores.nav.x = 0
					else
						AltScores.nav.x = $ + 1
					end
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
				if AltScores.nav.y == 0
					if AltScores.nav.x == 0
						AltScores.nav.x = 2
					else
						AltScores.nav.x = $ - 1
					end
				end
			end
		elseif AltScores.selected
			local action = AltScores.action
			if action.index == 0
				if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
					if action.table[action.nav]
						action.index = action.nav
						action.nav = 1
						action.args = {}
						action.textcolor = 1
						local act = AltScores.action.table[action.index]
						if not act.args or #act.args == 0
							action.index = 0
							act.func_comfirm(AltScores.selected)
							local popupstr = "SUCCESS!"
							if act.popup_msg then popupstr = act.popup_msg end
							AltScores.popupmsg.str = popupstr
							AltScores.popupmsg.y = 0
							AltScores.popupmsg.scale = FU/4
							AltScores.popupmsg.flags = 0
							AltScores.selected = nil
							AltScores.action = {
								nav = 1,
								index = 0,
								first = 1,
								args = {},
								table = {},
								textcolor = 1
							}
						else
							for i = 1, #act.args do
								local arg = act.args[i]
								if arg.type == "text"
									action.args[i] = ""
								elseif arg.type == "count"
									if arg.min
										action.args[i] = arg.min
									end
								end
							end
						end
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
					if action.nav == #action.table
						action.nav = 1
					else
						action.nav = $ + 1
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
					if action.nav == 1
						action.nav = #action.table
					else
						action.nav = $ - 1
					end
				end
			else
				local act = AltScores.action.table[action.index]
				if act.args[action.nav]
					local arg = act.args[action.nav]
					if arg.type == "text" or arg.type == "count" or arg.type == "float"
						action.args[action.nav] = LC.functions.InputText(arg.type, action.args[action.nav], key, AltScores.capslock, AltScores.shift, arg.max, arg.min)
						if arg.colored == true and arg.type == "text"
							if LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
								if action.textcolor == 1
									action.textcolor = #LC.colormaps
								else
									action.textcolor = $ - 1
								end
								action.args[action.nav] = LC.functions.SetNewColor(action.args[action.nav], action.textcolor)
							elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
								if action.textcolor == #LC.colormaps
									action.textcolor = 1
								else
									action.textcolor = $ + 1
								end
								action.args[action.nav] = LC.functions.SetNewColor(action.args[action.nav], action.textcolor)
							end
						end
					elseif LC.GIT_ArgTypes[arg.type]
						local cfg = LC.GIT_ArgTypes[arg.type]
						action.args[action.nav] = cfg.input(AltScores.selected, key, action.args[action.nav])
					end
				elseif action.nav == #act.args+1
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						local IsError = nil
							for i = 1, #act.args do
								local arg = act.args[i]
								if arg.type == "text"
									if arg.optional == false
										if action.args[i] == ""
											IsError = "Arg["..i.."] Cannot be empty!"
										elseif arg.min and action.args[i]:len() < arg.min
											IsError = "Arg["..i.."] Cannot be less than "..arg.min.."!"
											break
										end
									end
								elseif LC.GIT_ArgTypes[arg.type]
									local cfg = LC.GIT_ArgTypes[arg.type]
									local ET = cfg.checkvalid(AltScores.selected, action.args[i])
									if ET then IsError = "Arg["..i.."] "..ET end
								end
							end
						if IsError != nil
							action.errortext = IsError
						else
							act.func_comfirm(AltScores.selected, unpack(action.args, 1, #action.args))
							local popupstr = "SUCCESS!"
							if act.popup_msg then popupstr = act.popup_msg end
							AltScores.popupmsg.str = popupstr
							AltScores.popupmsg.y = 0
							AltScores.popupmsg.scale = FU/4
							AltScores.popupmsg.flags = 0
							AltScores.selected = nil
							AltScores.action = {
								nav = 1,
								index = 0,
								first = 1,
								args = {},
								table = {},
								textcolor = 1
							}
						end
					end
				end
				if LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN or LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
					if act.args[action.nav] and act.args[action.nav].type == "count"
						if act.args[action.nav].min
							if action.args[action.nav] < act.args[action.nav].min
								action.args[action.nav] = act.args[action.nav].min
							end
						end
					end
				end
				if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVDOWN
					if action.nav == #act.args+1
						action.nav = 1
					else
						action.nav = $ + 1
					end
					if act.args[action.nav]
						if act.args[action.nav].colored == true
							action.textcolor = LC.functions.GetLastColor(action.args[action.nav])
						end
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVUP
					if action.nav == 1
						action.nav = #act.args+1
					else
						action.nav = $ - 1
					end
					if act.args[action.nav]
						if act.args[action.nav].colored == true
							action.textcolor = LC.functions.GetLastColor(action.args[action.nav])
						end
					end
				end 
			end
		end
		return true, true
	end
}


table.insert(LC_Loaderdata["hook"], hooktable)

return true
