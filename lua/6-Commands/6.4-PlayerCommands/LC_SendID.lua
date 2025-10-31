local LC = LithiumCore

COM_AddCommand("@LC_send_id", function(player, id)
	if player == server then return end
	if player.LC_id == true then return end
	player.LC_id = true
	if isserver
		if not LC.localdata.playernum[#player] then LC.localdata.playernum[#player] = {id = nil, ip = nil} end
		LC.localdata.playernum[#player].id = id
	end
end)

return true
