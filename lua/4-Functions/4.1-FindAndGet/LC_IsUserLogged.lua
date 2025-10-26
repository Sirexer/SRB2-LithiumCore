local LC = LithiumCore

LC.functions.IsUsernameLogged = function(username)
	local check_user = nil
	if username == nil
		return
	end
	for player in players.iterate do
		if player.stuffname == username
			check_user = true
			return check_user
		end
	end
end

return true
