local LC = LithiumCore

local hooktable = {
	name = "LC.Main",
	type = "MobjDamage",
	toggle = true,
	TimeMicros = 0,
	func = function(target, inflictor, source, damage, damagetype)
		if not target or not target.valid then return end
		if target.type != MT_PLAYER then return end
		
		local player = target.player
		if not player or not player.valid then return end
		
		local IsAFK = false
		if player.LC_afk and player.LC_afk.enabled then IsAFK = true end
		
		local IsFinished = false
		if player.LC_afk and player.LC_afk.finished then IsFinished = true end
		
		if LC.consvars["LC_finishedinvincible"].value == 1
			if IsFinished
				P_DoPlayerPain(player, source, inflictor)
				P_PlayDeathSound(target)
				return true
			end
		end
		
		if LC.consvars["LC_afkinvincible"].value == 1
			if IsAFK
				return true
			end
		end
		
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
