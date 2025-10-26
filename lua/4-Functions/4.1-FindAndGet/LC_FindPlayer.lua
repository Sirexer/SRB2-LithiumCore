-- Search for players by node and nickname
-- Was a player found or not
local LC = LithiumCore

LC.functions.FindPlayer = function(p)
	if p == nil then return end
	if tonumber(p) == 0 or p == "00" then
		return server
	end
	local node = tonumber(p)
	if node ~= nil and node >= 0 and node < 32 then
		for player in players.iterate do
			if #player == node then
				return player
			end
		end
	end
	for player in players.iterate do
		if string.lower(p) == string.lower(player.name)
			return player
		end
		if string.find(string.lower(player.name), string.lower(p))
			return player
		end
	end
	return nil
end

return true
