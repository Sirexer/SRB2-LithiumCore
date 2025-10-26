local LC = LithiumCore

COM_AddCommand("@LC_serverTPS", function(player, tps)
	if player ~= server then return end
	
	LC.serverdata.tps = tonumber(tps)
	
end, COM_ADMIN)