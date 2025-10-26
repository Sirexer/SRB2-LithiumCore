local LC = LithiumCore

LC.commands["afk"] = {
	name = "LC_afk",
	chat = "afk"
}

LC.functions.RegisterCommand("afk", LC.commands["afk"])

COM_AddCommand(LC.serverdata.commands["afk"].name, function(player)
	if not player and not player.valid then return end
	if not player.cmd then return end
	if not player.LC_afk then return end
	
	if player.LC_afk.enabled == true -- Actively active player removes AFK status
		player.LC_afk.enabled = false
		player.LC_afk.time = 0
		chatprint("\x82"..player.name.."\x80 is no longer in AFK.")
	elseif player.LC_afk.enabled == false
		if player.LC_afk.cd
			local text_s = "second"
			if player.LC_afk.cd/TICRATE > 1 then text_s = "seconds" end
			CONS_Printf(player, "Wait "..player.LC_afk.cd/TICRATE.." "..text_s.." before manually going AFK!")
		else
			player.LC_afk.cd = 30*TICRATE
			player.LC_afk.enabled = true
			chatprint("\x82"..player.name.."\x80 is currently in AFK.")
		end
	end
end)
   
return true
