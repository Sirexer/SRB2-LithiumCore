local LC = LithiumCore

local SetEmote = false
local search = ""
local searcged_t = {}
local first = 1

local t = {
	name = "LC_MENU_EMOTES",
	description = "LC_MENU_EMOTES_TIP",
	type = "player",
	funchud = function(v)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		v.drawScaledNameTag(216*FRACUNIT, 8*FRACUNIT, "Hot keys of emotes", V_ALLOWLOWERCASE|V_SNAPTOTOP, FRACUNIT/2, SKINCOLOR_SKY, SKINCOLOR_BLACK)
		if SetEmote == false
			local y = 30
			for i = 1, 9 do
				local emojiname = "\x85"..LC.functions.getStringLanguage("LC_HTEMOTES_NOSET")
				if consoleplayer.LC_emotes[i]
					local index = consoleplayer.LC_emotes[i]
					if LC.serverdata.emotes[index]
						emojiname = LC.serverdata.emotes[index].name
						local width = v.stringWidth(emojiname, 0, "normal")
						local state = LC.serverdata.emotes[index].state
						local sprite = states[state].sprite
						local frame = states[state].frame
						local patch = v.getSpritePatch(sprite, frame)
						local scale = (FU/patch.width) * 8
						local x_e = (136*FU + width*FU) + (patch.leftoffset*scale)
						local y_e = (y*FU) + (patch.topoffset*scale)
						v.drawScaled(x_e, y_e, scale, patch, V_SNAPTOTOP, nil)
					end
				end
				local selectflag = 0
				if LC_menu.nav+1 == i then selectflag = V_YELLOWMAP end
				LC.functions.drawString(v, 136, y, emojiname, V_SNAPTOTOP|selectflag, "left")
				v.drawString(316, y, i, V_SNAPTOTOP|selectflag, "right")
				y = $ + 10
			end
		elseif SetEmote != false
			local setting = LC.functions.getStringLanguage("LC_HTEMOTED_MSG1"):format(SetEmote)
			LC.functions.drawString(v, 220, 22, setting, V_SNAPTOTOP, "center")
			local selectedflag = 0
			local typed = ""
			if LC_menu.nav == 0 then selectedflag = V_YELLOWMAP end
			if LC_menu.nav == 0 and (leveltime % 4) / 2 then typed = "_" end
			local crop_search = search
			local width = v.stringWidth(crop_search, 0, "thin")
			while width > 164 do
				crop_search = crop_search:sub(2)
				width = v.stringWidth(crop_search, 0, "thin")
			end
			if crop_search != search then crop_search = "..."..crop_search end
			LC.functions.drawString(v, 136, 34,  LC.functions.getStringLanguage("LC_SEARCH"), V_SNAPTOTOP|selectedflag, "left")
			v.drawFill(136, 43, 180, 10, 253|V_SNAPTOTOP)
			v.drawString(138, 44, crop_search+typed, V_SNAPTOTOP|V_ALLOWLOWERCASE, "thin")
			searcged_t = {}
			for i in ipairs(LC.serverdata.emotes) do
				if search != ""
					local s = search:gsub("%W","%%%0")
					if LC.serverdata.emotes[i].name:lower():find(search:lower())
						table.insert(searcged_t, {index = i, info = LC.serverdata.emotes[i]})
					end
				else
					table.insert(searcged_t, {index = i, info = LC.serverdata.emotes[i]})
				end
			end
			LC_menu.lastnav = #searcged_t
			local real_height = (v.height() / v.dupx())
			local maxslots = real_height/20 - 4
			if searcged_t[1] and LC_menu.nav != 0
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
			if LC_menu.nav+1 > 0 and first != 1
				v.drawString(318, 60+arrow_y, "\x82"..string.char(26), V_SNAPTOTOP, "right")
			end
			-- Arrow Down
			if LC_menu.nav+1 != LC_menu.lastnav and #searcged_t > maxslots and first+maxslots-1 < #searcged_t
				v.drawString(318, 164+arrow_y, "\x82"..string.char(27), V_SNAPTOBOTTOM, "right")
			end
			local y = 60
			for i = first, first+maxslots-1 do
				if not searcged_t[i] then break end
				local emojiname = searcged_t[i].info.name
				local state = searcged_t[i].info.state
				local sprite = states[state].sprite
				local frame = states[state].frame
				local patch = v.getSpritePatch(sprite, frame)
				local scale = (FU/patch.width) * 16
				local x_e = (138*FU) + (patch.leftoffset*scale)
				local y_e = (y*FU) + (patch.topoffset*scale)
				v.drawScaled(x_e, y_e, scale, patch, V_SNAPTOTOP, nil)
				local selectedflag = 0
				if LC_menu.nav == i then selectedflag = V_YELLOWMAP end
				v.drawString(160, y, emojiname, V_SNAPTOTOP|selectedflag, "left")
				local colored = tostring(searcged_t[i].info.colored)
				local colorized = tostring(searcged_t[i].info.colorized)
				v.drawString(160, y+8, "Colored: "..colored..", Colorized: "..colorized, V_SNAPTOTOP, "thin")
				if LC_menu.nav == i
					v.drawFill(136, y-1, 172, 1, 72|V_SNAPTOTOP)
					v.drawFill(136, y+18, 172, 1, 72|V_SNAPTOTOP)
					
					v.drawFill(136, y-1, 1, 19, 72|V_SNAPTOTOP)
					v.drawFill(307, y-1, 1, 19, 72|V_SNAPTOTOP)
				else
					v.drawFill(136, y-1, 172, 1, 20|V_SNAPTOTOP)
					v.drawFill(136, y+18, 172, 1, 20|V_SNAPTOTOP)
					
					v.drawFill(136, y-1, 1, 19, 20|V_SNAPTOTOP)
					v.drawFill(307, y-1, 1, 19, 20|V_SNAPTOTOP)
				end
				y = $ + 20
			end
		end
	end,
	
	funcenter = function()
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		LC_menu.nav = 0
		LC_menu.lastnav = 8
	end,
		
	funchook = function(key)
		local player = consoleplayer
		local LC_menu = LC.menu.player_state
		if SetEmote == false
			if key.name == "backspace"
				if player.LC_emotes[LC_menu.nav+1]
					S_StartSound(nil, sfx_thok, consoleplayer)
					COM_BufInsertText(player, "LC_emotes set "..LC_menu.nav+1)
				end
			end
			if LC_menu.nav >= 0 and LC_menu.nav <= 8
				if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
					SetEmote = LC_menu.nav+1
				end
			end
		elseif SetEmote != false
			if LC_menu.nav == 0
				local prev = search
				search = LC.functions.InputText("text", search, key, LC_menu.capslock, LC_menu.shift, 64)
				if prev != search
					first = 1
				end
			else
				if LC_menu.nav > 0
					if LC.functions.GetMenuAction(key.name) == LCMA_ACCEPT
						COM_BufInsertText(player, "LC_emotes set "..SetEmote.." "..searcged_t[LC_menu.nav].index)
						S_StartSound(nil, sfx_strpst, consoleplayer)
						LC_menu.nav = SetEmote-1
						LC_menu.lastnav = 8
						first = 1
						SetEmote = false
						LC_menu.lastnav = 8
					end
				end
			end
			if LC.functions.GetMenuAction(key.name) == LCMA_BACK
				LC_menu.nav = SetEmote-1
				LC_menu.lastnav = 8
				SetEmote = false
				first = 1
				return true
			end
		end
	end
}

table.insert(LC_Loaderdata["menu"], t)

return true
