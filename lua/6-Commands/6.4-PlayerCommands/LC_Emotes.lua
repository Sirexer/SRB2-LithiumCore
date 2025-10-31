local LC = LithiumCore

LC.serverdata.commands["emotes"] = {
	name = "LC_emotes"
}

LC.functions.RegisterCommand("emotes", LC.commands["emotes"])

COM_AddCommand(LC.serverdata.commands["emotes"].name, function(player, action, arg1, arg2)
	local sets = LC.serverdata.commands["emotes"]
	if not action
		if consoleplayer != player
			print(
				"LC_emotes play <emote name/slot> - plays emote",
				"LC_emotes list - shows list of emote on this server",
				"LC_emotes set - shows keys of emotes",
				"LC_emotes set <key 1-9> <emote name/slot> - sets emote on key",
				"LC_emotes set <key 1-9> - removes emote on key"
			)
		end
	elseif action:lower() == "play"
		if arg1 == nil
			CONS_Printf(player, "Type \"LC_emotes list\" in the console, to view emotes on this server.")
			return
		end
		
		local n = tonumber(arg1)
		
		local emote
		if LC.serverdata.emotes[n]
			emote = LC.serverdata.emotes[n] 
		else
			for i in ipairs(LC.serverdata.emotes) do
				local e = LC.serverdata.emotes[i]
				if arg1:lower() == e.name:lower()
					emote = e
					break
				end
			end
		end
		
		if not emote
			CONS_Printf(player, "No \""..arg1.."\" emote, type \"LC_emotes list\" in the console, to view emotes on this server.")
			return
		end
		
		if not player.mo or not player.mo.valid
			CONS_Printf(player, "Unable to play emote when the player object is not spawned.")
			return
		end
		
		if player.mo.LC_emote and player.mo.LC_emote.mo and player.mo.LC_emote.mo.valid
			CONS_Printf(player, "You cannot replay an emote while the current emote is still being played back.")
			return
		end
		
		if player.mo.LC_emote and player.mo.LC_emote.countdown != 0
			local second = player.mo.LC_emote.countdown/TICRATE
			if second <= 1
				second = second.." second"
			else
				second = second.." seconds"
			end
			CONS_Printf(player, "You'll have to wait "..second.." to play the emote again.")
			return
		end
		
		local pmo = player.mo
		
		local x, y, z = pmo.x, pmo.y, pmo.z + pmo.height + 24*pmo.scale
		
		if P_MobjFlip(pmo) == -1 then z = pmo.z - pmo.height end
		
		local emote_mo = P_SpawnMobj(x, y, z, MT_LCEMOJI)
		P_SetMobjStateNF(emote_mo, emote.state)
		emote_mo.scale = FixedMul(pmo.scale, emote.scale)
		emote_mo.dispoffset = 2
		if P_MobjFlip(pmo) == -1 then emote_mo.eflags = $|MFE_VERTICALFLIP end

		if #emote.sfx == 1
			S_StartSound(player.mo, emote.sfx[1], nil)
		elseif #emote.sfx > 1
			local r_sfx = P_RandomRange(1, #emote.sfx)
			S_StartSound(player.mo, emote.sfx[r_sfx], nil)
		end
		
		if emote.colorized == true then emote_mo.colorized = true end
		if emote.colored == true then emote_mo.color = player.skincolor end
		
		player.mo.LC_emote = {
			mo = emote_mo,
			scale = emote.scale,
			countdown = LC.consvars.emotecountdown.value*TICRATE
		}
		
	elseif action:lower() == "set"
		if arg1 == nil
			local str_list = "Hot key of emotes:\n"
			for i = 1, 9 do
				local emotekey = "KEY "..i.." - "
				if not player.LC_emotes
				or not player.LC_emotes[i]
					emotekey = emotekey.."\x85".."NOT SETTED".."\x80"
				else
					emotekey = emotekey..LC.serverdata.emotes[player.LC_emotes[i]].name
				end
				if i != 9
					str_list = str_list..emotekey..",\n"
				elseif i == 9
					str_list = str_list..emotekey.."."
				end
			end
			CONS_Printf(player, str_list)
			return
		end
	
		local key = tonumber(arg1)
		if key == nil or key > 9 or key < 1
			CONS_Printf(player, "Can only be assigned to keys 1-9")
			return
		end
		
		if arg2 == nil
			player.LC_emotes[key] = false
			CONS_Printf(player, "Removed key "..key.." from selecting emote.")
			return
		end
		
		local emote_slot = tonumber(arg2)
		local emote_name = arg2:lower()
		
		local index
		if emote_slot
			if LC.serverdata.emotes[emote_slot] then index = emote_slot end
		else
			for i in ipairs(LC.serverdata.emotes) do
				if LC.serverdata.emotes[i].name:lower() == emote_name
					index = i
					break
				end
			end
		end
		
		if not index
			CONS_Printf(player, "No \""..arg2.."\" emote, type \"LC_emotes list\" in the console, to view emotes on this server.")
			return
		end
		
		if not player.LC_emotes then player.LC_emotes = {} end
		player.LC_emotes[key] = index
		local str_message = "Emote "..LC.serverdata.emotes[index].name.." is set to the "..key.."."
		local keyemote = ""
		for _, v in ipairs(LC.localdata.controls) do
			if v.name == "Play Emotes"
				keyemote = v.key
			end
		end
		if LC.localdata.controls["Play Emotes"] != "..."
			str_message = "Emote "..LC.serverdata.emotes[index].name.." is set to the "..key..", press the "..keyemote.." key, then the "..key.." key."
		end
		CONS_Printf(player, str_message)
	elseif action:lower() == "list"
		local str_list = "List of Emotes on this server: "
		for i in ipairs(LC.serverdata.emotes) do
			if i != #LC.serverdata.emotes
				str_list = str_list.."["..i.."]"..LC.serverdata.emotes[i].name..", "
			elseif i == #LC.serverdata.emotes
				str_list = str_list.."["..i.."]"..LC.serverdata.emotes[i].name.."."
			end
		end
		CONS_Printf(player, str_list)
		
	end
end)

return true -- End Of File