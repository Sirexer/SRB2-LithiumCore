local LC = LithiumCore

-- Checking a player's permissions
LC.functions.CheckPerms = function(player, perm)
	if server == player then return true end
	if player.group == LC.serverdata.groups.sets["superadmin"] then return true end
	if perm == nil then return false end
	for p = 1, #LC.serverdata.groups.list[player.group].perms do
		if perm == LC.serverdata.groups.list[player.group].perms[p] or "all" == LC.serverdata.groups.list[player.group].perms[p]
			return true
		end
	end
	return false
end

return true
