-- Get count of players on the server
local LC = LithiumCore

LC.functions.playerontheserver = function()
	local count = 0
	for player in players.iterate do
		if player and player.valid and player.bot != 1
			count = $ + 1
		end
	end
	LC.serverdata.countplayers = count
	return count
end

return true
