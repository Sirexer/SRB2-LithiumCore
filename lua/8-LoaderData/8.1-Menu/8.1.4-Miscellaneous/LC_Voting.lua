local LC = LithiumCore

local vote_index = 1
local voting_t = {}

local t = {
	name = "LC_MENU_VOTING",
	description = "LC_MENU_VOTING_TIP",
	type = "misc",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Voting", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		if not voting_t[1] then
			LC.functions.drawString(v, 216, 30, "\x85"..LC.functions.getStringLanguage("LC_UNAVAILABLE"), V_SNAPTOTOP, "center")
			return
		end
		
		local vote_t = voting_t[vote_index]
		local vote_name = vote_t.name
		local args = vote_t.args
		
		if LC_menu.nav == 0
			v.drawString(216, 30, "\x82".."< "..vote_name.." >", V_SNAPTOTOP, "center")
		else
			v.drawString(216, 30, vote_name, V_SNAPTOTOP, "center")
		end
		
		local text = false
		local y = 50
		for i, a in ipairs(args) do
			if a.type == "text" or a.type == "count" then
				if LC_menu.nav == i
					v.drawString(136, y, "\x82"..a.header, V_SNAPTOTOP, "left")
				else
					v.drawString(136, y, a.header, V_SNAPTOTOP, "left")
				end
				v.drawFill(136, 9+y, 180, 10, 253|V_SNAPTOTOP)
				if LC_menu.nav == i and (leveltime % 4) / 2
					if string.len(a.arg) <= 32
						v.drawString(138, 10+y, a.arg.."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
					else
						v.drawString(138, 10+y, "..."..string.sub(a.arg, string.len(a.arg)-32, string.len(a.arg)).."_", V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
					end
				else
					if string.len(a.arg) <= 32
						v.drawString(138, 10+y, a.arg, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
					else
						v.drawString(138, 10+y, "..."..string.sub(a.arg, string.len(a.arg)-32, string.len(a.arg)), V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
					end	
				end
				text = true
				y = $ + 24
			elseif a.type == "map"
				local mapdata = mapheaderinfo[a.arg]
				local patchname = LC.functions.BuildMapName(a.arg).."P"
				if not v.patchExists(patchname)
					patchname = "BLANKLVL"
				end
				local title2 = ""
				if mapdata.actnum
					title2 = "Act "..mapdata.actnum
				end
				v.drawScaled(136*FRACUNIT, y*FRACUNIT, FRACUNIT/4, v.cachePatch(patchname), V_SNAPTOTOP)
				v.drawString(176, y, mapdata.lvlttl, V_SNAPTOTOP, "left")
				v.drawString(176, y+10, title2, V_SNAPTOTOP, "left")
				if LC_menu.nav == i
					v.drawString(244, y+18, "\x82".."< "..LC.functions.BuildMapName(a.arg).." >", V_SNAPTOTOP, "center")
				else
					v.drawString(244, y+18, LC.functions.BuildMapName(a.arg), V_SNAPTOTOP, "center")
				end
				y = $ + 32
			elseif a.type == "player"
				local pname
				if a.arg and a.arg.valid
					pname = a.arg.name
				else
					pname = "None"
				end
				if LC_menu.nav == i
					LC.functions.drawString(v, 136, y, "\x82"..LC.functions.getStringLanguage("LC_PLAYER"), V_SNAPTOTOP, "left")
					v.drawString(136, y+10, "\x82".."< "..pname.." >", V_SNAPTOTOP, "left")
				else
					LC.functions.drawString(v, 136, y, LC.functions.getStringLanguage("LC_PLAYER"), V_SNAPTOTOP, "left")
					v.drawString(136, y+10, pname, V_SNAPTOTOP, "left")
				end
				y = $ + 20
			end
		end
		
		local str_vote = LC.functions.getStringLanguage("LC_MENU_VOTE")
		local time_cd = (LC.serverdata.vote_cd/TICRATE) + 1
		local sel_color = (LC.serverdata.voting and "\x85"..str_vote) or "\x82"..str_vote
		local unsel_color = (LC.serverdata.voting and "\x86"..str_vote) or "\x80"..str_vote
		
		if not LC.serverdata.voting then
			sel_color = (LC.serverdata.vote_cd and not IsPlayerAdmin(consoleplayer) and server ~= consoleplayer and "\x85"..str_vote.."("..time_cd..")") or "\x82"..str_vote
			unsel_color = (LC.serverdata.vote_cd and not IsPlayerAdmin(consoleplayer) and server ~= consoleplayer and "\x86"..str_vote.."("..time_cd..")") or "\x80"..str_vote
		end
		
		if LC_menu.nav == LC_menu.lastnav then
			LC.functions.drawString(v, 312, y, sel_color, V_SNAPTOTOP, "right")
		else
			LC.functions.drawString(v, 312, y, unsel_color, V_SNAPTOTOP, "right")
		end
		
		if LC_menu.lognotice
			LC.functions.drawString(v, 136, y+10, LC_menu.lognotice, V_SNAPTOTOP, "thin")
		end
		
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		voting_t = {}
		for k, v in pairs(LC.vote_types) do
			if LC.serverdata.vote_cvars[k]["enabled"].value == 0 then continue end
			if not v.menu then continue end
			
			local args = {}
			for _, va in ipairs(v.menu.args) do
				local arg = ""
				if va.type == "map" then arg = gamemap end
				if va.type == "count" then arg = 0 end
				table.insert(args, {header = va.header, type = va.type, arg = arg, min = va.min, max = va.max} )
			end
			
			table.insert(voting_t, {
				name = k,
				args = args 
			})
		end
		
		LC_menu.nav = 0
		LC_menu.lastnav = voting_t[1] and #voting_t[1].args+1 or 0
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		
		if not voting_t[1] then return end
		
		local vote_t = voting_t[vote_index]
		local vote_name = vote_t.name
		local args = vote_t.args

		if LC_menu.nav == 0 then
			if LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT then
				vote_index = (vote_index == #voting_t and 1) or $ + 1
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT then
				vote_index = (vote_index == 1 and #voting_t) or $ - 1
			end
			LC_menu.lastnav = #voting_t[vote_index].args+1
		elseif LC_menu.nav == LC_menu.lastnav then
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT then
				
				if LC.serverdata.voting then
					LC_menu.lognotice = "\x85"..LC.functions.getStringLanguage("LC_VOTE_ERR_ALREADY")
					return
				end
			
				if LC.serverdata.vote_cd and not IsPlayerAdmin(consoleplayer) and server ~= consoleplayer then
					LC_menu.lognotice = "\x85"..LC.functions.getStringLanguage("LC_VOTE_ERR_WAIT"):format((LC.serverdata.vote_cd/TICRATE)+1)
					return
				end
				
				local str_args = ""
				local args_t = {}
				for i, v in ipairs(args) do
					if v.type == "map"
						str_args = str_args..v.arg.." "
						table.insert(args_t, v.arg)
					elseif v.type == "player"
						str_args = str_args..tostring(#v.arg).." "
						table.insert(args_t, tostring(#v.arg))
					elseif v.type == "text" or v.type == "count"
						str_args = str_args.."\""..v.arg.."\" "
						table.insert(args_t, v.arg)
					end
				end
				local tab, t = LC.vote_types[vote_name].func_start(consoleplayer, unpack(args_t))
	
				if tab ~= true and t then
					S_StartSound(nil, sfx_s3kb2, consoleplayer)
					LC_menu.lognotice = "\x85"..LC.functions.getStringLanguage(t)
					return
				end
				COM_BufInsertText(consoleplayer, "LC_voting "..vote_name.." "..str_args)
				print("LC_voting "..vote_name.." "..str_args)
			end
			return
		end
		
		for i, a in ipairs(args) do
			if LC_menu.nav ~= i then continue end
			if a.type == "text" then
				a.arg = LC.functions.InputText(
					"text",
					a.arg,
					key,
					LC_menu.capslock,
					LC_menu.shift,
					64
				)
			elseif a.type == "count" then
				a.arg = LC.functions.InputText(
					"count",
					a.arg,
					key,
					LC_menu.capslock,
					LC_menu.shift,
					nil,
					a.min
				)
			elseif a.type == "map" then
				local allmaps = {}
				local current = 0
				for m = 1, 1035 do
					if mapheaderinfo[m] != nil
						if mapheaderinfo[m].typeoflevel & LC.Gametypes["all"]["tol"][gametype]
							local IsSS = LC.functions.IsSpecialStage(m)
							if IsSS == false
								table.insert(allmaps, m)
								if m == a.arg
									current = #allmaps
								end
							end
						end
					end
				end
				if LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT then
					if current != nil
						if current < #allmaps
							a.arg = allmaps[current+1]
						else
							a.arg = allmaps[1]
						end
					else
						a.arg = allmaps[1]
					end
				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT then
					if current != nil
						if current > 1
							a.arg = allmaps[current-1]
						else
							a.arg = allmaps[#allmaps]
						end
					else
						a.arg = allmaps[1]
					end
				end
			elseif a.type == "player" then
				local allplayers = {}
				local current = nil

				for p in players.iterate do
					if p and p.valid then
						table.insert(allplayers, p)
						if a.arg == p then
							current = #allplayers
						end
					end
				end

				if not current then
					a.arg = allplayers[1]
					return
				end

				if LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT then
					current = current + 1
					if current > #allplayers then
						current = 1
					end
					a.arg = allplayers[current]

				elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT then
					current = current - 1
					if current < 1 then
						current = #allplayers
					end
					a.arg = allplayers[current]
				end
			end

		end
		
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
