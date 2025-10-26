local LC = LithiumCore

local hooktable = {
	name = "LC.Main",
	type = "MapLoad",
	toggle = true,
	TimeMicros = 0,
	func = function(mapnum)
		for player in players.iterate do
			if not player and not player.valid then return end
			player.LC_kills = 0
			player.LC_deaths = 0
			player.LC_timefinished = nil
			if player.LC_afk
				player.LC_afk.finished = false
			end
		end
		
		LC.cache["hud"] = {}
	end
}

table.insert(LC_Loaderdata["hook"], hooktable)

return true -- End Of File
