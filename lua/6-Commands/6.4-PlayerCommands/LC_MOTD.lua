local LC = LithiumCore

COM_AddCommand("LC_motd", function(player)
	if player != consoleplayer then return end
	LC.localdata.motd.open = true
end)
   
return true
