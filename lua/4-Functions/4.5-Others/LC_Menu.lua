local LC = LithiumCore

local CV_Showhud = CV_FindVar("showhud")

LC.functions.menuactive = function(player)
	if player != consoleplayer then return end
	local mainlastnav = 4
	local anim = LC.menu.animation
	if LC.menu.player_state and anim.closing == false and anim.opening == false
		LC.menu.animation = {
			fade = 16,
			panelx = 0,
			closing = true,
			opening = false
		}
		LC.menu.player_state = {
			nav = 0,
			lastnav = mainlastnav,
			category = "main",
			subcategory = nil,
			com_vars = {},
			capslock = false,
			shift = false
		}
		LC.menu.LC_ms = nil
	elseif not LC.menu.player_state
		if CV_Showhud.value == 0
			LC.menu.HUD_enaled = false
			CV_Set(CV_Showhud, 1)
		elseif CV_Showhud.value == 1
			LC.menu.HUD_enaled = true
		end
		LC.menu.animation = {
			fade = 0,
			panelx = -168,
			closing = false,
			opening = true
		}
		LC.menu.player_state = {
			nav = 0,
			lastnav = mainlastnav,
			category = "main",
			subcategory = nil,
			capslock = false,
			shift = false
		}
		LC.menu.LC_ms = {}
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
				for p = 1, #LC.serverdata.groups.list[consoleplayer.group].perms do
					if LC.serverdata.groups.list[consoleplayer.group].perms[p] == LC.menu.commands[i].perm
						local t = {command = LC.menu.commands[i], num = commandnum}
						table.insert(LC_menu.LC_allowcommands, t)
						commandnum = $ + 1
						break
					end
				end
			end
		end
	end
end
   
return true
