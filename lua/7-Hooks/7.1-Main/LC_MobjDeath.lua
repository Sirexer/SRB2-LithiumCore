local LC = LithiumCore

local hooktable = {
	name = "LC.Main",
	type = "MobjDeath",
	toggle = true,
	TimeMicros = 0,
	func = function(target, inflictor, source, damage)
		if not target or not target.valid then return end
		if target.type != MT_PLAYER then return end
		
		local player = target.player
		if not player or not player.valid then return end
		
		player.LC_deaths = $ + 1
		
		if not source or not source.valid then return end
		if source.type != MT_PLAYER then return end
		
		local player = source.player
		if not player or not player.valid then return end
		
		player.LC_kills = $ + 1
		
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true
