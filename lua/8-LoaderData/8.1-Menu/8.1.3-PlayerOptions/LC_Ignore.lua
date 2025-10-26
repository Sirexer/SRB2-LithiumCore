local LC = LithiumCore

local ignore_t = {}
local first = 1

local t = {
	name = "LC_MENU_IGNORE",
	description = "LC_MENU_IGNORE_TIP",
	type = "player",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Ignore options", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		local pname
		if LC_menu.select_player and LC_menu.select_player.valid
			pname = LC_menu.select_player.name
		else
			pname = "None"
		end
		
		local addplayer =  LC.functions.getStringLanguage("LC_ING_ADDPLAYER")
		local ignorelist = LC.functions.getStringLanguage("LC_ING_LIST")
		if LC_menu.nav == 0
			LC.functions.drawString(v, 136, 30, "\x82"..addplayer, V_SNAPTOTOP, "left")
			v.drawString(136, 40, "\x82".."< "..pname.." >", V_SNAPTOTOP, "left")
		else
			LC.functions.drawString(v, 136, 30, addplayer, V_SNAPTOTOP, "left")
			v.drawString(136, 40, pname, V_SNAPTOTOP, "left")
		end
		LC.functions.drawString(v, 136, 60, ignorelist, V_SNAPTOTOP, "left")
		local real_height = (v.height() / v.dupx())
		local maxslots = real_height/10 - 8
		if ignore_t[1] and LC_menu.nav != 0
			if LC_menu.nav < first
				first = $ - 1
			elseif LC_menu.nav > first+maxslots-1
				first = $ + 1
			end
		end
		-- Animate Arrow
		local arrow_y = 0
		if (leveltime % 10) > 5
			arrow_y = 2
		end
		
		-- Arrow Up
		if LC_menu.nav > 0 and first != 1
			v.drawString(318, 32+arrow_y, "\x82"..string.char(26), V_SNAPTOTOP, "right")
		end
		-- Arrow Down
		if LC_menu.nav != LC_menu.lastnav and #ignore_t > maxslots and first+maxslots-1 < #ignore_t
			v.drawString(318, 180+arrow_y, "\x82"..string.char(27), V_SNAPTOBOTTOM, "right")
		end
		local y = 0
		for i = first, first+maxslots-1 do
			if ignore_t and ignore_t[i] and ignore_t[i].type
				local name
				if ignore_t[i].type == "player"
					name = "[p]"..ignore_t[i].arg.name
				elseif ignore_t[i].type == "account"
					name = "[a]"..ignore_t[i].arg
				end
				if LC_menu.nav == i
					v.drawString(136, 70+y, (tostring("\x82"..name)), V_SNAPTOTOP, "left")
				else
					v.drawString(136, 70+y, (tostring(name)), V_SNAPTOTOP, "left")
				end
				y = $ + 10
			end
		end
	end,
	
	funcenter = function()
		local LC_menu = LC.menu.player_state
		ignore_t = {}
		if consoleplayer.LC_ignorelist
			if consoleplayer.LC_ignorelist.players
				for p = 1, #consoleplayer.LC_ignorelist.players do
					if consoleplayer.LC_ignorelist.players[p].valid
						table.insert(ignore_t, {type = "player", arg = consoleplayer.LC_ignorelist.players[p]})
					end
				end
			end
			if consoleplayer.LC_ignorelist.accounts
				for a = 1, #consoleplayer.LC_ignorelist.accounts do
					if consoleplayer.LC_ignorelist.accounts[a]
						table.insert(ignore_t, {type = "account", arg = consoleplayer.LC_ignorelist.accounts[a]})
					end
				end
			end
		end
		LC_menu.lastnav = #ignore_t
	end,
	
	funchook = function(key)
		local LC_menu = LC.menu.player_state
		local t_players = {}
		local selected = 1
		local count = 0
		local pnext = 1
		for player in players.iterate do
			if player == consoleplayer then continue end
			local skip = false
			if consoleplayer.LC_ignorelist
				if consoleplayer.LC_ignorelist.players
					for i = 1, #consoleplayer.LC_ignorelist.players do
						if consoleplayer.LC_ignorelist.players[i] == player
							skip = true
							break
						end
					end
				end
				if consoleplayer.LC_ignorelist.accounts
					for i = 1, #consoleplayer.LC_ignorelist.accounts do
						if consoleplayer.LC_ignorelist.accounts[i] == player.stuffname
							skip = true
							break
						end
					end
				end
			end
			if skip == true
				continue
			end
			count = $ + 1
			table.insert(t_players, player)
			if player == LC_menu.select_player then selected = count end
			continue
		end
		if LC_menu.nav == 0
			if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT or key.name == "space"
				if LC_menu.select_player and LC_menu.select_player.valid
					if LC_menu.select_player.stuffname == nil
						COM_BufInsertText(consoleplayer, "LC_ignore "..#LC_menu.select_player.." player")
						table.insert(ignore_t, {type = "player", arg = LC_menu.select_player})
						LC_menu.select_player = nil
					else
						COM_BufInsertText(consoleplayer, "LC_ignore "..LC_menu.select_player.stuffname.." account")
						table.insert(ignore_t, {type = "account", arg = LC_menu.select_player.stuffname})
						LC_menu.select_player = nil
					end
				end
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVLEFT
				if count > selected
					pnext = selected + 1
				else
					pnext = 1
				end
				LC_menu.select_player = t_players[pnext]
			elseif LC.functions.GetMenuAction(key.name) == LCMA_NAVRIGHT
				if selected > 1
					pnext = selected - 1
				else
					pnext = #t_players
					end
				LC_menu.select_player = t_players[pnext]
			end
		else
			if key.name == "backspace" or key.name == "delete"
				local a = ignore_t[LC_menu.nav].arg
				if ignore_t[LC_menu.nav].type == "account"
					COM_BufInsertText(consoleplayer, "LC_ignore "..a.." account")
					table.remove(ignore_t, LC_menu.nav)
				elseif ignore_t[LC_menu.nav].type == "player"
					local p = ignore_t[LC_menu.nav].arg
					if p and p.valid
						COM_BufInsertText(consoleplayer, "LC_ignore "..#p.." player")
					end
					table.remove(ignore_t, LC_menu.nav)
				end
			end
		end
		LC_menu.lastnav = #ignore_t
		if LC_menu.nav > LC_menu.lastnav then LC_menu.nav = LC_menu.lastnav end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
