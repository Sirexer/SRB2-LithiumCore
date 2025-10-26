local LC = LithiumCore

LC.functions.SaveLoadOtherStuff = function(stuff, player, sl)
	if sl == "save"
		-- Silence
		if player.cantspeak != nil
			stuff.cantspeak = player.cantspeak
		end
		-- Time Played
		if player.LC_timeplayed != nil
			stuff.LC_timeplayed = player.LC_timeplayed
		end
		-- Team
		if G_GametypeHasTeams() then stuff.team = player.ctfteam end
		-- Spectator
		stuff.spectator = player.spectator
		if player.spectator == true then return end
		-- Player completed the level
		if (player.pflags & PF_FINISHED) and player.isafk != true and player.afk != true
			stuff.fineshed = PF_FINISHED
		end
		-- Player's time when he completed the level(does work without DU_Script.lua)
		if player.completiontime
			stuff.completiontime = player.completiontime
		end
		-- Star post
		if G_PlatformGametype()
			if player.starpostnum != 0
				stuff.starposted = true
				stuff.starpostx = player.starpostx
				stuff.starposty = player.starposty
				stuff.starpostz = player.starpostz
				stuff.starpostnum = player.starpostnum
				stuff.starposttime = player.starposttime
				stuff.starpostangle = player.starpostangle
				stuff.starpostscale = player.starpostscale
			end
		end
		-- Score
		stuff.score = player.score
		-- Shield
		stuff.shield = player.powers[pw_shield]
		-- Rings
		stuff.rings = player.rings
		-- Lives
		stuff.lives = player.lives
		-- Invincibility
		stuff.invincibility = player.powers[pw_invulnerability]
		-- Super Shoes
		stuff.speed = player.powers[pw_sneakers]
		-- Weapon rings
		stuff.weapons = player.ringweapons
		stuff.infinity = player.powers[pw_infinityring]
		stuff.automatic = player.powers[pw_automaticring]
		stuff.bounce = player.powers[pw_bouncering]
		stuff.scatter = player.powers[pw_scatterring]
		stuff.grenade = player.powers[pw_grenadering]
		stuff.explosion = player.powers[pw_explosionring]
		stuff.rail = player.powers[pw_railring]
		-- Times hit
		stuff.timeshit = player.timeshit
		-- Competition
		if gametype == GT_COMPETITION
			stuff.numboxes = player.numboxes
			stuff.totalring = player.totalring
			stuff.realtime = player.realtime
		end
		-- Laps
		if gametype == GT_RACE then stuff.laps = player.laps end
	elseif sl == "load"
		-- Silence
		if stuff.cantspeak
			player.cantspeak = stuff.cantspeak
		end
		-- Time Played
		if stuff.LC_timeplayed != nil
			player.LC_timeplayed = stuff.LC_timeplayed
		end
		-- Team
		if G_GametypeHasTeams() then player.ctfteam = stuff.team end
		-- Spectator
		if player.spectator == true and stuff.spectator == false
			player.spectator = false
			G_DoReborn(#player)
		elseif stuff.spectator == true
			return
		end
		-- Player completed the level
		if stuff.fineshed
			player.pflags = $ + PF_FINISHED
		end
		-- Player's time when he completed the level
		if stuff.completiontime
			player.completiontime = stuff.completiontime
		end
		-- Star post
		if G_PlatformGametype()
			if stuff.starposted == true
				player.starpostx = stuff.starpostx
				player.starposty = stuff.starposty
				player.starpostz = stuff.starpostz
				player.starpostnum = stuff.starpostnum
				player.starposttime = stuff.starposttime
				player.starpostangle = stuff.starpostangle
				player.starpostscale = stuff.starpostscale
				P_SetOrigin(player.mo, player.starpostx*FRACUNIT, player.starposty*FRACUNIT, player.starpostz*FRACUNIT)
				player.mo.angle = player.starpostangle
				player.mo.scale = player.starpostscale
			end
		end
		-- Score
		player.score = stuff.score
		-- Shield
		player.powers[pw_shield] = stuff.shield
		P_SpawnShieldOrb(player)
		-- Rings
		player.rings = stuff.rings
		-- Lives
		player.lives = stuff.lives
		-- Invincibility
		player.powers[pw_invulnerability] = $ + stuff.invincibility
		-- Super Shoes
		player.powers[pw_sneakers] = $ + stuff.speed
		-- Weapons
		player.ringweapons = $ | stuff.weapons
		player.powers[pw_infinityring] = $ + stuff.infinity
		player.powers[pw_automaticring] = $ + stuff.automatic
		player.powers[pw_bouncering] = $ + stuff.bounce
		player.powers[pw_scatterring] = $ + stuff.scatter
		player.powers[pw_grenadering] = $ + stuff.grenade
		player.powers[pw_explosionring] = $ + stuff.explosion
		player.powers[pw_railring] = $ + stuff.rail
		-- Times hit
		player.timeshit = stuff.timeshit
		-- Competition
		if gametype == GT_COMPETITION
			player.numboxes = stuff.numboxes
			player.totalring = stuff.totalring
			player.realtime = stuff.realtime
		end
		-- Laps
		if gametype == GT_RACE then player.laps = stuff.laps end
	end
end

return true
