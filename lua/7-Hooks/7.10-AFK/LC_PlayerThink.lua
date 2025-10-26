local LC = LithiumCore

local hooktable = {
	name = "LC.AFK",
	type = "PlayerThink",
	toggle = true,
	TimeMicros = 0,
	func = function(player)
		-- AFK system should not work for bots
		if player.is_bot then return end
		
		-- Before working with the AFK system, create a table if it does not exist
		if player.LC_afk == nil then player.LC_afk = {time = 0, cd = 0, enabled = false, finished = false} end
		
		-- Check if the player has completed the level or not yet
		if (player.pflags & PF_FINISHED) and player.LC_afk.enabled == false
			player.LC_afk.finished = true
		elseif not (player.pflags & PF_FINISHED)
		and	player.LC_afk.enabled == false and player.LC_afk.finished == true
			player.LC_afk.finished = false
		end
		
		-- Time counter when the player is inactive
		player.LC_afk.time = $ + 1
		if player.LC_afk.enabled == false
			if player.LC_afk.cd != 0
				player.LC_afk.cd = $ - 1
			end
		end
		
		-- Player Control Table
		local cmd = player.cmd
		-- Check whether the player is active or not
		if cmd.forwardmove != 0 or cmd.sidemove != 0 or cmd.buttons != 0
			player.LC_afk.time = 0
			if player.LC_afk.enabled == true -- Actively active player removes AFK status
				player.LC_afk.enabled = false
				chatprint("\x82"..player.name.."\x80 is no longer in AFK.")
			end
		end
		
		-- Inactive player gets AFK status
		if LC.consvars["LC_afktimer"].value*TICRATE <= player.LC_afk.time
		and player.LC_afk.enabled == false
			player.LC_afk.enabled = true
			chatprint("\x82"..player.name.."\x80 is currently in AFK.")
		end
		
		-- A player receives a level completion status if another player non-AFK has completed the level
		
		if player.LC_afk.enabled == true and player.LC_afk.finished == false
		and not (player.pflags & PF_FINISHED)
		and LC.serverdata.completedlevel != 0
		and G_CoopGametype()
			player.pflags = $|PF_FINISHED
		end
		
		-- The player loses the level completion status if they don't actually hit the finish line
		if player.LC_afk.enabled == false and player.LC_afk.finished == false
		and (player.pflags & PF_FINISHED)
		and G_CoopGametype()
			player.pflags = $ - PF_FINISHED
		end
			
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
